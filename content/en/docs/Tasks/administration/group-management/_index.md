---
title: Group Management
weight: 2
---

IAM provides a group management system, that can be used by IAM administrators
to create groups, remove existing ones and manage membership in the group.

Groups can be organized in a hierarchical structure, with the following constraints:
 - a group can have only a parent group;
 - a group can have many childrens.

# Manage groups using the web interface

The simplest way to manage groups is using the IAM dashboard.

## Creating a group

From the home page, open the _Groups_ section and click the _Add group_ button:

![INDIGO IAM Add Group button](../images/IAM-groups-01.png)

To create a group, specify a group name. If the created group is a subgroup of
an already existing group, the parent group can be selected via a dialog.

Note that IAM allows for multiple root level groups.

![INDIGO IAM Parent group creation](../images/IAM-groups-02.png)

![INDIGO IAM Child group creation](../images/IAM-groups-03.png)

A new children group can also be created from the parent group details page.

![INDIGO IAM Add Subgroup button](../images/IAM-groups-04.png)

## Deleting a group

From the groups list page, click on the corresponding _Remove_ button.
A confirmation window will be opened, so you can confirm or abort the
the delete operation.

![INDIGO IAM Group removal](../images/IAM-groups-05.png)

**Only empty groups can be removed. If you try to remove a group
with a child group or with user members, the operation fails with an error.**

## Managing membership for a group


To add a user to a group open the user details page.
In the _Groups_ section, click on the _Add to group_ button:

![INDIGO IAM Add group to user button](../images/IAM-groups-06.png)

Choose one or more groups and confirm the operation:

![INDIGO IAM Add group membership](../images/IAM-groups-07.png)

Starting with version 1.7.0, when a user is added as member of group `g`, IAM
takes care of adding him/her to all the parent groups leading to `g` that
he/she is not already a member of.  In previous versions this had to be done
manually by the IAM administrator. Following the same rationale, when a user is
removed from a group, it is also automatically removed from any children groups
he is a member of.

To remove a user from a group, click the _Remove_ button.

Members can also be removed from the group details page, as shown in the
following screenshot:

![INDIGO IAM Members list](../images/IAM-groups-08.png)
