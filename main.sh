#! /bin/bash
DEBIAN_FRONTEND=noninteractive
apt update

# Clone Upstream
apt-get source $1 -y

# Get build deps
apt-get build-dep $1 -y

# Build package
for i in ./*.dsc
do
    cd $(echo $i | sed 's/.dsc//g')
    dpkg-buildpackage --no-sign
done

# Move the debs to output
cd ../
mkdir -p ./output
mv ./*.deb ./output/
