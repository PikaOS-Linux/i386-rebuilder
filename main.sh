#! /bin/bash
DEBIAN_FRONTEND=noninteractive
touch /etc/apt/sources.list.d/ubuntu.list
echo "deb-src http://archive.ubuntu.com/ubuntu/ mantic main restricted universe multiverse" > /etc/apt/sources.list.d/ubuntu.list
echo "deb-src http://archive.ubuntu.com/ubuntu/ mantic-updates main restricted universe multiverse" >> /etc/apt/sources.list.d/ubuntu.list
echo "deb-src http://archive.ubuntu.com/ubuntu/ mantic-security main restricted universe multiverse" >> /etc/apt/sources.list.d/ubuntu.list
echo "deb-src http://archive.ubuntu.com/ubuntu/ mantic-backports main restricted universe multiverse" >> /etc/apt/sources.list.d/ubuntu.list
echo "deb-src http://archive.ubuntu.com/ubuntu/ mantic-proposed main restricted universe multiverse" >> /etc/apt/sources.list.d/ubuntu.list

apt update

# Clone Upstream
apt-get source $1 -y

# Get build deps
apt-get build-dep $1 -y

# Build package
for i in ./*.dsc
do
    dpkg-source -x $i
    cd $(dpkg-source -x $i | grep "dpkg-source: info: extracting $1 in" | cut -d":" -f3 | sed -s "s/extracting $1 in/ /g")
    dpkg-buildpackage --no-sign
done

# Move the debs to output
cd ../
mkdir -p ./output
mv ./*.deb ./output/
