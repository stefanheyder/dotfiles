#!/bin/sh
# delete the corresponding directiory on the server
KPSDIR="/usr/share/nginx/html/kps.online"

if [ "$#" -ne 1 ] || ssh root@ig6.intelligentgraphics.biz "! [ -d $KPSDIR/$1 ]"; then
	echo "You need to pass a valid directory located in $KPSDIR, these are available:"
	ssh root@ig6.intelligentgraphics.biz "ls $KPSDIR"
	exit
else
	echo "This is a valid directory in $KPSDIR"
fi

echo "Building a release"
cd $KPSA
grunt release

echo "Copying the files to the server"
cd httpdocs
scp -rp . "root@ig6.intelligentgraphics.biz:/usr/share/nginx/html/kps.online/$1"
