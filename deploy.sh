#!/bin/bash
set -ex

BUILD_DIR=public
GIT_COMMIT_SHA=$(git rev-parse --short HEAD)
GIT_BRANCH_NAME=$(git rev-parse --abbrev-ref HEAD | sed 's#/#_#g')
TARGET_DIR=${TARGET_DIR:-$HOME/git/indigo-iam.github.io}

function error_and_exit(){
  echo "Website build failed!" && exit 1
}

rm -rf ${BUILD_DIR}
mkdir -p ${BUILD_DIR}

if [ "${GIT_BRANCH_NAME}" == "HEAD" ]; then
  echo "headless build, exiting..."
  exit 1
fi

VERSIONED_BUILD_DIR="${BUILD_DIR}/v/${GIT_BRANCH_NAME}"
mkdir -p ${VERSIONED_BUILD_DIR}

HUGO_ENV="production" hugo --gc -d ${VERSIONED_BUILD_DIR} -b /v/${GIT_BRANCH_NAME} || error_and_exit

rsync -a --delete ${VERSIONED_BUILD_DIR}/* ${TARGET_DIR}/v/${GIT_BRANCH_NAME}

if [ -n "${LINK_TO_MAIN}" ]; then
  pushd ${TARGET_DIR}/v
  rm -f current
  ln -sf ${GIT_BRANCH_NAME} current
  popd
fi
