#!/usr/bin/env bash
set -euo pipefail

echo "[+] Action start"
OWNER="${GITHUB_REPOSITORY%%/*}"

if [[ "$DESTINATION_REPOSITORY" != *"/"* ]]; then
  DESTINATION_REPOSITORY="$OWNER/$DESTINATION_REPOSITORY"
fi

GIT_CMD_REPOSITORY="https://x-access-token:$API_TOKEN_GITHUB@$GITHUB_SERVER/$DESTINATION_REPOSITORY.git"

CLONE_DIR="$(pwd)/.push-to-another-repository"

echo "[+] Git version"
git --version

echo "[+] Enable git lfs"
git lfs install

echo "[+] Cloning destination git repository $DESTINATION_REPOSITORY"

# Setup git
git config --global user.email "$USER_EMAIL"
git config --global user.name "$USER_NAME"

# workaround for https://github.com/cpina/github-action-push-to-another-repository/issues/103
git config --global http.version HTTP/1.1

{
	git clone --single-branch --depth 1 --branch "$TARGET_BRANCH" "$GIT_CMD_REPOSITORY" "$CLONE_DIR"
} || {
    if [ "$CREATE_TARGET_BRANCH_IF_NEEDED" = "true" ]
    then
        # Default branch of the repository is cloned. Later on the required branch
	# will be created
        git clone --single-branch --depth 1 "$GIT_CMD_REPOSITORY" "$CLONE_DIR"
    else
        false
    fi
} || {
	echo "::error::Could not clone the destination repository. Command:"
	echo "::error::git clone --single-branch --branch $TARGET_BRANCH $GIT_CMD_REPOSITORY $CLONE_DIR"
	echo "::error::(Note that if they exist USER_NAME and API_TOKEN is redacted by GitHub)"
	echo "::error::Please verify that the target repository exist AND that it contains the destination branch name, and is accesible by the API_TOKEN_GITHUB OR SSH_DEPLOY_KEY"
	exit 1

}
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

ORIGIN_COMMIT="https://$GITHUB_SERVER/$GITHUB_REPOSITORY/commit/$GITHUB_SHA"
COMMIT_MESSAGE="${COMMIT_MESSAGE/ORIGIN_COMMIT/$ORIGIN_COMMIT}"
COMMIT_MESSAGE="${COMMIT_MESSAGE/\$GITHUB_REF/$GITHUB_REF}"

echo "[+] Set directory is safe ($CLONE_DIR)"
# Related to https://github.com/cpina/github-action-push-to-another-repository/issues/64
git config --global --add safe.directory "$CLONE_DIR"

if [ "$CREATE_TARGET_BRANCH_IF_NEEDED" = "true" ]
then
    echo "[+] Switch to the TARGET_BRANCH"
    # || true: if the $TARGET_BRANCH already existed in the destination repo:
    # it is already the current branch and it cannot be switched to
    # (it's not needed)
    # If the branch did not exist: it switches (creating) the branch
    git switch -c "$TARGET_BRANCH" || true
fi

echo "commit-message=$COMMIT_MESSAGE" >> "$GITHUB_OUTPUT"
