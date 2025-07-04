#!/usr/bin/env bash
set -euo pipefail

echo "[+] Action start"

# we should get it before changing directory
LAST_COMMIT_MESSAGE=$(git log -1 --pretty=%B --first-parent -- $SOURCE_DIRECTORY) || true

CLONE_DIR=$(mktemp -d)/$WORKTREE_DIR
mv ./$WORKTREE_DIR "$CLONE_DIR"

TEMP_WORKDIR=$(mktemp -d)
# This mv has been the easier way to be able to remove files that were there
# but not anymore. Otherwise we had to remove the files from "$CLONE_DIR",
# including "." and with the exception of ".git/"
mv "$CLONE_DIR/.git" "$TEMP_WORKDIR/.git"

# $DESTINATION_DIRECTORY is '' by default
ABSOLUTE_DESTINATION_DIRECTORY="$CLONE_DIR/$DESTINATION_DIRECTORY/"
echo "[+] Deleting $ABSOLUTE_DESTINATION_DIRECTORY"
rm -rf "$ABSOLUTE_DESTINATION_DIRECTORY"
echo "[+] Creating (now empty) $ABSOLUTE_DESTINATION_DIRECTORY"
mkdir -p "$ABSOLUTE_DESTINATION_DIRECTORY"

mv "$TEMP_WORKDIR/.git" "$CLONE_DIR/.git"

echo "[+] evacuate source .git directory to avoid conflicts when mirroring the root directory"
mv "$GITHUB_WORKSPACE/.git" "$TEMP_WORKDIR/.git"

echo "[+] Copying contents of source repository folder $SOURCE_DIRECTORY to folder $DESTINATION_DIRECTORY in destination repository"
cp -ra "$SOURCE_DIRECTORY"/. "$CLONE_DIR/$DESTINATION_DIRECTORY"

cd "$CLONE_DIR"
echo "[+] Building commit message"
COMMIT_MESSAGE="${COMMIT_MESSAGE/LAST_COMMIT_MESSAGE/$LAST_COMMIT_MESSAGE}"
ORIGIN_COMMIT="$GITHUB_SERVER_URL/$GITHUB_REPOSITORY/commit/$GITHUB_SHA"
COMMIT_MESSAGE="${COMMIT_MESSAGE/ORIGIN_COMMIT/$ORIGIN_COMMIT}"
COMMIT_MESSAGE="${COMMIT_MESSAGE/GITHUB_REF/$GITHUB_REF}"
{
  echo 'commit-message<<EOF'
  echo "$COMMIT_MESSAGE"
  echo 'EOF'
} >> "$GITHUB_OUTPUT"

echo "[+] Swap github.workspace with the cloned repository to work with commit-action"
mv "$GITHUB_WORKSPACE" "$TEMP_WORKDIR/$WORKTREE_DIR"
mv "$TEMP_WORKDIR/.git" "$TEMP_WORKDIR/$WORKTREE_DIR/.git"
mv "$CLONE_DIR" "$GITHUB_WORKSPACE"

# Stash the original workspace in a ignored worktree directory.
mv "$TEMP_WORKDIR/$WORKTREE_DIR" "$GITHUB_WORKSPACE/$WORKTREE_DIR"
cd "$GITHUB_WORKSPACE"
# The stash directory is ignored from version control.
echo "$WORKTREE_DIR" >> .git/info/exclude
