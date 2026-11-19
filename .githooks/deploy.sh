#!/bin/sh

# https://gist.github.com/apexskier/efb7c1aaa6e77e8127a8
# Deploy hooks stored in your git repo to everyone!
#
# I keep this in $ROOT/$HOOK_DIR/deploy
# From the top level of your git repo, run ./hook/deploy (or equivalent) after
# cloning or adding a new hook.
# No output is good output.

# Only deploy in this package's own clone. Installed as a dependency (npm runs
# `prepare` in a temporary clone with no .git, or inside another project's
# repository), there is nothing to deploy, and that repository's hooks are
# not ours to replace.
TOPLEVEL=`git rev-parse --show-toplevel 2>/dev/null` || exit 0
[ "$TOPLEVEL" = "`pwd -P`" ] || exit 0

BASE=`git rev-parse --git-dir`
ROOT=`git rev-parse --show-toplevel`
HOOK_DIR=.githooks
HOOKS=$ROOT/$HOOK_DIR/*

if [ ! -d "$ROOT/$HOOK_DIR" ]
then
  echo "Couldn't find hooks dir."
  exit 1
fi

# Clean up existing hooks.
rm -f $BASE/hooks/*

# Synlink new hooks.
for HOOK in $HOOKS
do
  (cd $BASE/hooks ; ln -s $HOOK `basename $HOOK` || echo "Failed to link $HOOK to `basename $HOOK`.")
done

echo "Git hooks deployed to $BASE/hooks. The hooks automatically check your code on every commit."
echo "To bypass them for a single commit, use: git commit --no-verify"

exit 0
