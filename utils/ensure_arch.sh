#!/bin/bash

# Ensures bundles exist for secondary arches by copying the bundle for
# the source arch for the given target arches and performing some arch
# name substitution on the copies.
#
# Usage:
# $ ensure_arch.sh bundleDir sourceArch targetArch targetArch ...

pushd $1 1>/dev/null
src=$(ls | grep -e "gtk\.linux\.$2$" || ls | grep -e "linux\.$2$")
if [ -z "$src" ] ; then
	echo "no bundle found for $2"
	exit 1
fi
for a in ${@:3} ; do
	tgt=${src/$2/$a/}
	if [ -d "$tgt" ] ; then
		echo "bundle $tgt already exists"
	else
		cp -r ${src} $tgt
		find $tgt -type f -exec sed -i -e "s/$2/$a/g" {} \;
		echo "bundle $tgt created"
	fi
done
popd 1>/dev/null