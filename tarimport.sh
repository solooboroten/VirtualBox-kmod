#! /bin/sh

args=$#
PROG="${0##*/}"
PROGDIR="${0%/*}"
PROGDIR=`readlink -m "$PROGDIR"`

giturl="git://github.com/larsr/VirtualBox-OSE"

if [ "$args" -lt 2 ]; then
	echo "ERR: No args!"
	exit 1
fi

branch="$1"
shift

tarfile="$1"
shift
tarfile=`readlink -m "$tarfile"`
if [ ! -r "$tarfile" ]; then
	echo "ERR: Not found tarfile!"
	exit 1
fi
tarname="${tarfile##*/}"

parent=
if [ "$args" -ge 3 ]; then
	parent="$1"
	echo git rev-parse "$parent"
	parent=`git rev-parse "$parent"`
	shift
fi

urllistfile=`readlink -m "$(pwd)/.tar/urls.list"`
if [ ! -r "$urllistfile" ]; then
	echo "ERR: Not found urllistfile!"
	exit 1
fi

url=`fgrep "$tarname" "$urllistfile" || :`
if [ -z "$url" ]; then
	echo "ERR: Not found url!"
	exit 1
fi

if [ "branchhead" == "$parent" ]; then
	parent=
fi

msg="imported $tarname

$url
"
mergemsg=

gitdir=`readlink -m "$(pwd)/.git"`
if [ ! -d "$gitdir" ]; then
	echo "ERR: Not found gitdir!"
	exit 1
fi
export GIT_DIR="$gitdir"

echo git rev-parse "$branch"
branchhead=`git rev-parse "$branch"`
git checkout -f "$branch"

getmergemsg()
{
	if [ -r "$gitdir/MERGE_MSG" ]; then
		echo "$mergemsg"
		sed '1d' "$gitdir/MERGE_MSG"
	fi
}

if [ -n "$parent" ]; then
	mergemsg="Merge commit '$parent' of $giturl into $branch"
	if git merge --no-commit "$parent"; then
		getmergemsg | \
			git commit -F -
	fi	
fi

tmpdir="$(mktemp -dt "$PROG.XXXXXXXX")"
pushd "$tmpdir"

git ls-tree --name-only -z $branchhead | \
	xargs -0 git rm -r -f

tar xaSf "$tarfile" --strip-components=1
find -type d -empty -print0 | \
	xargs -0i touch "{}/.gitignore"

find -mindepth 1 -maxdepth 1 -print0 | \
	xargs -0 git add

	(
		echo "$msg"
		getmergemsg
	) | \
		git commit --date "`LANG=C date -r "$tarfile" '+%F %T %:::z'`" --author '? <?>' -F -

popd
rm -rf "$tmpdir"

git checkout -f "$branch"
