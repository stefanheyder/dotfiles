#!/bin/sh
KPSonServer="/usr/share/nginx/html/kps.online"
buildDir=$KPSA/dist

echo "TUI for creating a KPSA release"
echo "================================="

echo "These releases are available on the server"
ssh root@ig6.intelligentgraphics.biz "ls $KPSonServer"

echo "================================="
echo "Please enter the name of the release you would like to publish"

read releaseName

echo "================================="
if ssh root@ig6.intelligentgraphics.biz "! [ -d $KPSonServer/$releaseName ]"; then
    echo "Creating the new release directory"
    ssh root@ig6.intelligentgraphics.biz "mkdir $KPSonServer/$releaseName"
else
    echo "This release is already available. Currently not supporting overwrite,"
    echo "as rm -rf via ssh is dangerous, please delete on your own"
    exit 1
fi

cd $KPSA

echo "================================="
echo "Deleting old dist directory"
echo "================================="
echo "Update to current npm dependencies"
echo "================================="
echo "Building a release"
npm start vifian prod

echo "================================="
echo "Copying the files to the server"
cd $buildDir
scp -rp . "root@ig6.intelligentgraphics.biz:/usr/share/nginx/html/kps.online/$releaseName"

echo "================================="
echo "Enjoy at ig6.intelligentgraphics.biz/kps.online/$releaseName"
