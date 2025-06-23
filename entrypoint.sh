#!/usr/bin/env bash
set -euo pipefail

echo "[+] Action start"

# we should get it before changing directory
LAST_COMMIT_MESSAGE=$(git log -1 --pretty=%B --first-parent -- $SOURCE_DIRECTORY) || true

CLONE_DIR=$(mktemp -d)/$WORKTREE_DIR
mv ./$WORKTREE_DIR "$CLONE_DIR"

ls -la "$CLONE_DIR"

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

echo "[+] Listing Current Directory Location"
ls -al

echo "[+] Listing root Location"
ls -al /

mv "$TEMP_WORKDIR/.git" "$CLONE_DIR/.git"

echo "[+] List contents of $SOURCE_DIRECTORY"
ls "$SOURCE_DIRECTORY"

echo "[+] evacuate source .git directory to avoid conflicts when mirroring the root directory"
mv "$SOURCE_DIRECTORY/.git" "$TEMP_WORKDIR/.git"

echo "[+] Copying contents of source repository folder $SOURCE_DIRECTORY to folder $DESTINATION_DIRECTORY in git repo $DESTINATION_REPOSITORY"
cp -ra "$SOURCE_DIRECTORY"/. "$CLONE_DIR/$DESTINATION_DIRECTORY"
cd "$CLONE_DIR"

echo "[+] Files that will be pushed"
ls -la

COMMIT_MESSAGE="${COMMIT_MESSAGE/LAST_COMMIT_MESSAGE/$LAST_COMMIT_MESSAGE}"
ORIGIN_COMMIT="$GITHUB_SERVER_URL/$GITHUB_REPOSITORY/commit/$GITHUB_SHA"
COMMIT_MESSAGE="${COMMIT_MESSAGE/ORIGIN_COMMIT/$ORIGIN_COMMIT}"
COMMIT_MESSAGE="${COMMIT_MESSAGE/GITHUB_REF/$GITHUB_REF}"
echo "commit-message=$COMMIT_MESSAGE" >> "$GITHUB_OUTPUT"

echo "[+] Swap github.workspace with the cloned repository"
mv "$GITHUB_WORKSPACE" "$TEMP_WORKDIR/$WORKTREE_DIR"
mv "$TEMP_WORKDIR/.git" "$TEMP_WORKDIR/$WORKTREE_DIR/.git"
mv "$CLONE_DIR" "$GITHUB_WORKSPACE"
mv "$TEMP_WORKDIR/$WORKTREE_DIR" "$GITHUB_WORKSPACE/$WORKTREE_DIR"

cd "$GITHUB_WORKSPACE"
echo "$WORKTREE_DIR" >> .git/info/exclude
