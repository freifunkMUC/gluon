#!/bin/bash

set -e
shopt -s nullglob

. scripts/modules.sh


GLUONDIR="$(pwd)"

for module in $GLUON_MODULES; do
	echo "--- Updating patches for module '$module' ---"

<<<<<<< HEAD
	rm -f "$GLUONDIR"/patches/$module/*.patch
	mkdir -p "$GLUONDIR"/patches/$module
=======
	rm -rf "$GLUONDIR"/patches/"$module"
>>>>>>> 6a3d5554c170da07c3c5be3741ab9921e5839159

	cd "$GLUONDIR"/"$module"

	n=0
	for commit in $(git rev-list --reverse --no-merges base..patched); do
		let n=n+1
<<<<<<< HEAD
		git show --pretty=format:'From: %an <%ae>%nDate: %aD%nSubject: %B' --no-renames $commit > "$GLUONDIR"/patches/$module/"$(printf '%04u' $n)-$(git show -s --pretty=format:%f $commit).patch"
=======
		mkdir -p "$GLUONDIR"/patches/"$module"
		git -c core.abbrev=40 show --pretty=format:'From: %an <%ae>%nDate: %aD%nSubject: %B' --no-renames "$commit" > "$GLUONDIR/patches/$module/$(printf '%04u' $n)-$(git show -s --pretty=format:%f "$commit").patch"
>>>>>>> 6a3d5554c170da07c3c5be3741ab9921e5839159
	done
done
