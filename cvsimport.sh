#! /bin/sh

cvsroot=':pserver:anonymous@cvs.rpmfusion.org:/cvs/free'
cvsmodulepref='rpms/VirtualBox/'

for branch in F-15 F-16 F-17 F-18 F-19 F-20 devel
do
	echo git cvsimport -m -p x -v -i -r rpmfusion -d "$cvsroot" -o "$branch" "$cvsmodulepref$branch"
	git cvsimport -m -p x -v -i -r rpmfusion -d "$cvsroot" -o "$branch" "$cvsmodulepref$branch"
done
