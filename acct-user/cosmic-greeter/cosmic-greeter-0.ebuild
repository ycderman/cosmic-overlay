# Copyright 2026 ycderman
# Distributed under the terms of the GNU General Public License v3

EAPI=8

inherit acct-user

DESCRIPTION="User for the COSMIC greeter"
ACCT_USER_ID=-1
ACCT_USER_HOME=/var/lib/cosmic-greeter
ACCT_USER_HOME_PERMS=0750
ACCT_USER_GROUPS=( cosmic-greeter video )

acct-user_add_deps
