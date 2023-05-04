#! /bin/bash

DEBIAN_FRONTEND=noninteractive
sed -i '/deb-src/s/^# //' /etc/apt/sources.list && apt update

# Get build deps
ln -fs /usr/share/zoneinfo/America/New_York /etc/localtime
DEBIAN_FRONTEND=noninteractive apt-get install -y tzdata


apt-get source $1
apt-get install -y pbuilder debootstrap devscripts debhelper sbuild debhelper ubuntu-dev-tools piuparts

apt install -y debian-archive-keyring
cp -rvf ./pbuilderrc /etc/pbuilderrc
mkdir -p /var/cache/pbuilder/hook.d/
cp -rvf ./hooks/* /var/cache/pbuilder/hook.d/
rm -rf /var/cache/apt/
mkdir -p /pbuilder-results
DIST=lunar ARCH=i386 pbuilder create --distribution lunar --architecture i386 --debootstrapopts --exclude=aptitude
echo 'starting build'
DIST=lunar ARCH=i386 pbuilder build ./*.dsc --distribution lunar --architecture i386 --debootstrapopts --exclude=aptitude

# Move the debs to output
mkdir -p ./output
mv /var/cache/pbuilder/result/*.deb ./output/ || sudo mv ../*.deb ./output/
