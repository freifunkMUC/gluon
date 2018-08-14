#!/bin/bash

set -e

. scripts/modules.sh


GLUONDIR="$(pwd)"

for module in $GLUON_MODULES; do
	echo "--- Updating module '$module' ---"
<<<<<<< HEAD
	var=$(echo $module | tr '[:lower:]/' '[:upper:]_')
=======
	var=$(echo "$module" | tr '[:lower:]/' '[:upper:]_')
>>>>>>> 6a3d5554c170da07c3c5be3741ab9921e5839159
	eval repo=\${${var}_REPO}
	eval branch=\${${var}_BRANCH}
	eval commit=\${${var}_COMMIT}

	mkdir -p "$GLUONDIR/$module"
	cd "$GLUONDIR/$module"
	git init
	git config commit.gpgsign false

<<<<<<< HEAD
	if ! git branch -f base $commit 2>/dev/null; then
		git fetch $repo $branch
		git branch -f base $commit 2>/dev/null
=======
	if ! git branch -f base "$commit" 2>/dev/null; then
		git fetch "$repo" "$branch"
		git branch -f base "$commit"
>>>>>>> 6a3d5554c170da07c3c5be3741ab9921e5839159
	fi
done
