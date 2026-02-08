#!/bin/bash

set -ouex pipefail

# Prepare /opt for installing packages
rm /opt
mkdir /opt

### Install packages

# Packages can be installed from any enabled yum repo on the image.
# RPMfusion repos are available by default in ublue main images
# List of rpmfusion packages can be found here:
# https://mirrors.rpmfusion.org/mirrorlist?path=free/fedora/updates/43/x86_64/repoview/index.html&protocol=https&redirect=1

rpm -v --import "https://repo.nordvpn.com/gpg/nordvpn_public.asc"
dnf5 config-manager addrepo --id="nordvpn" --set=baseurl="https://repo.nordvpn.com/yum/nordvpn/centos/x86_64/" --set=enabled=1 --overwrite

# this installs a package from fedora repos
dnf5 install -y libunity konsole nordvpn nordvpn-gui

# Use a COPR Example:
#
# dnf5 -y copr enable ublue-os/staging
# dnf5 -y install package
# Disable COPRs so they don't end up enabled on the final image:
# dnf5 -y copr disable ublue-os/staging

#### Example for enabling a System Unit File

systemctl enable nordvpnd.socket

# Move files installed to /opt to /usr/share/factory so they will be in the final image
mv /opt /usr/share/factory
# Restore symlink from /opt to /var/opt
ln -s /var/opt /opt
