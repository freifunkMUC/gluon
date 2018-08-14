#!/bin/bash

set -e
shopt -s nullglob

. scripts/modules.sh


mkdir -p "$GLUON_TMPDIR"

GLUONDIR="$(pwd)"

PATCHDIR="$GLUON_TMPDIR"/patching
trap 'rm -rf "$PATCHDIR"' EXIT

TMPDIR="$GLUON_BUILDDIR"/tmp

mkdir -p "$TMPDIR"

PATCHDIR="$TMPDIR"/patching
trap 'rm -rf "$PATCHDIR"' EXIT

for module in $GLUON_MODULES; do
	echo "--- Patching module '$module' ---"

<<<<<<< HEAD
	git clone -s -b base --single-branch "$GLUONDIR"/$module "$PATCHDIR" 2>/dev/null

	cd "$PATCHDIR"
	for patch in "$GLUONDIR"/patches/$module/*.patch; do
		git -c user.name='Gluon Patch Manager' -c user.email='gluon@void.example.com' -c commit.gpgsign=false am --whitespace=nowarn --committer-date-is-author-date "$patch"
	done

	cd "$GLUONDIR"/$module
	git fetch "$PATCHDIR" 2>/dev/null
	git checkout -B patched FETCH_HEAD
=======
	git clone -s -b base --single-branch "$GLUONDIR/$module" "$PATCHDIR" 2>/dev/null

	cd "$PATCHDIR"
	for patch in "$GLUONDIR/patches/$module"/*.patch; do
		git -c user.name='Gluon Patch Manager' -c user.email='gluon@void.example.com' -c commit.gpgsign=false am --whitespace=nowarn --committer-date-is-author-date "$patch"
	done

	cd "$GLUONDIR/$module"
	git fetch "$PATCHDIR" 2>/dev/null
	git checkout -B patched FETCH_HEAD >/dev/null

	git config branch.patched.remote .
	git config branch.patched.merge refs/heads/base

>>>>>>> 6a3d5554c170da07c3c5be3741ab9921e5839159
	git submodule update --init --recursive

	rm -rf "$PATCHDIR"
done
