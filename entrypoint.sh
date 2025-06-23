#!/usr/bin/env bash
set -euo pipefail

echo "[+] Action start"

# we should get it before changing directory
LAST_COMMIT_MESSAGE=$(git log -1 --pretty=%B --first-parent -- $SOURCE_DIRECTORY) || true

CLONE_DIR=$(mktemp -d)/.push-to-another-repository
mv ./.push-to-another-repository "$CLONE_DIR"

ls -la "$CLONE_DIR"

TEMP_DIR=$(mktemp -d)
# This mv has been the easier way to be able to remove files that were there
# but not anymore. Otherwise we had to remove the files from "$CLONE_DIR",
# including "." and with the exception of ".git/"
mv "$CLONE_DIR/.git" "$TEMP_DIR/.git"

# $TARGET_DIRECTORY is '' by default
ABSOLUTE_TARGET_DIRECTORY="$CLONE_DIR/$TARGET_DIRECTORY/"

echo "[+] Deleting $ABSOLUTE_TARGET_DIRECTORY"
rm -rf "$ABSOLUTE_TARGET_DIRECTORY"

echo "[+] Creating (now empty) $ABSOLUTE_TARGET_DIRECTORY"
mkdir -p "$ABSOLUTE_TARGET_DIRECTORY"

echo "[+] Listing Current Directory Location"
ls -al

echo "[+] Listing root Location"
ls -al /

mv "$TEMP_DIR/.git" "$CLONE_DIR/.git"

echo "[+] List contents of $SOURCE_DIRECTORY"
ls "$SOURCE_DIRECTORY"

echo "[+] rm source .git directory to avoid conflicts when mirroring the root directory"
rm -rf "$SOURCE_DIRECTORY/.git"

echo "[+] Copying contents of source repository folder $SOURCE_DIRECTORY to folder $TARGET_DIRECTORY in git repo $DESTINATION_REPOSITORY"
cp -ra "$SOURCE_DIRECTORY"/. "$CLONE_DIR/$TARGET_DIRECTORY"
cd "$CLONE_DIR"

echo "[+] Files that will be pushed"
ls -la

COMMIT_MESSAGE="${COMMIT_MESSAGE/LAST_COMMIT_MESSAGE/$LAST_COMMIT_MESSAGE}"
ORIGIN_COMMIT="https://$GITHUB_SERVER/$GITHUB_REPOSITORY/commit/$GITHUB_SHA"
COMMIT_MESSAGE="${COMMIT_MESSAGE/ORIGIN_COMMIT/$ORIGIN_COMMIT}"
COMMIT_MESSAGE="${COMMIT_MESSAGE/GITHUB_REF/$GITHUB_REF}"

echo "[+] Swap github.workspace with the cloned repository"
rm -rf "$GITHUB_WORKSPACE"
mv "$CLONE_DIR" "$GITHUB_WORKSPACE"

echo "commit-message=$COMMIT_MESSAGE" >> "$GITHUB_OUTPUT"
