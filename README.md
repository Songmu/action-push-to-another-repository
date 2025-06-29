# action-push-to-another-repository

A GitHub Action that pushes files from a source repository to a destination repository.

> [!NOTE]
> This is a maintained fork of the original [cpina/github-action-push-to-another-repository](https://github.com/cpina/github-action-push-to-another-repository) based on commit [7c1bd86](https://github.com/cpina/github-action-push-to-another-repository/commit/7c1bd869f38327ce403753fc2a5769e26cacb5ac).

## Features
- Push files from one repository to another
- Configurable source and destination directories
- Custom commit messages with template variables
- Support for different destination branches
- Creates signed commits when using GitHub App tokens

## Quick Start

```yaml
steps:
- uses: actions/checkout@v4
- uses: Songmu/action-push-to-another-repository@v2
  with:
    destination-repository: 'owner/repo'
```

## Requirements

### Prerequisites

Before using this action, ensure the following requirements are met:

1. **Source Repository Checkout**: You must checkout the source repository to ensure the files you want to push are available in the workflow.

2. **Destination Branch**: The destination branch must already exist in the destination repository. If the branch doesn't exist, the action will fail.

   To create a new branch before using this action, use [`Songmu/action-create-branch`](https://github.com/Songmu/action-create-branch).

### Permissions

This action requires the following permissions for the **destination repository**:

- `contents: write` - Write files and create commits
- `workflows: write` - Only needed if updating `.github/workflows/` files


## Inputs

| Name | Description | Required | Default |
|------|-------------|----------|---------|
| `token` | GitHub token with write access to the destination repository | No | `${{ github.token }}` |
| `destination-repository` | Destination repository (format: `owner/repo`) | Yes | - |
| `source-directory` | Source directory from the origin directory | No | `.` |
| `destination-branch` | Destination branch name for the destination repository | No | `main` |
| `commit-message` | Commit message for the output repository | No | `LAST_COMMIT_MESSAGE (via ORIGIN_COMMIT from GITHUB_REF)` |
| `destination-directory` | The directory to wipe and replace in the destination repository | No | `''` |

## Outputs

| Name | Description |
|------|-------------|
| `pushed` | Whether a commit was pushed to the destination repository (`true` or `false`) |

### Commit Message Variables

The `commit-message` input supports the following template variables:

- `LAST_COMMIT_MESSAGE`: Replaced by the last commit message in the source repository
- `ORIGIN_COMMIT`: Replaced by the URL@commit in the origin repository
- `GITHUB_REF`: Replaced by the origin `$GITHUB_REF`

## Examples

### Using GitHub App Token

```yaml
name: Push to another repository
on:
  push:
    branches:
    - main
jobs:
  push-to-another-repository:
    runs-on: ubuntu-latest
    steps:
    - uses: actions/checkout@v4
      persist-credentials: false
    - id: generate_token
      uses: actions/create-github-app-token@v1
      with:
        app-id: ${{ secrets.APP_ID }}
        private-key: ${{ secrets.PRIVATE_KEY }}
        repositories: dest-repo
    - id: push
      name: Push to another repository
      uses: Songmu/action-push-to-another-repository@v2
      with:
        token: "${{ steps.generate_token.outputs.token }}"
        destination-repository: 'owner/dest-repo'
    - name: Check if pushed
      if: steps.push.outputs.pushed == 'true'
      run: echo "Successfully pushed changes to the destination repository"
```

### Creating a New Branch

```yaml
name: Push to new branch
on:
  push:
    branches:
    - main
jobs:
  push-to-another-repository:
    runs-on: ubuntu-latest
    steps:
    - uses: actions/checkout@v4
      persist-credentials: false
    - name: Create branch if needed
      uses: Songmu/action-create-branch@v0
      with:
        repository: 'owner/dest-repo'
        branch: 'new-feature'
    - name: Push to another repository
      uses: Songmu/action-push-to-another-repository@v2
      with:
        destination-repository: 'owner/dest-repo'
        destination-branch: 'new-feature'
```

### Pull From Another Repository

You can also use this action to pull files from another repository and push them to your own repository. This is useful for syncing files or configurations across repositories.

```yaml
name: Pull from another repository
on:
  schedule:
    - cron: '0 0 * * *'
  workflow_dispatch:
jobs:
  push-to-another-repository:
    runs-on: ubuntu-latest
    steps:
    - uses: actions/checkout@v4
      repo: '$owner/$source-another-repo'
      persist-credentials: false
    - name: Push to another repository
      uses: Songmu/action-push-to-another-repository@v2
      with:
        token: "${{ secrets.GITHUB_TOKEN }}"
        destination-repository: '$you/$yourepo'
        source-directory: './src'
        destination-directory: 'vendor/another-repo'
```

## How it Works
1. The action checks out the destination repository
2. Copies files from the source directory to the destination
3. Creates a commit with the specified message
4. Pushes the changes to the destination repository


## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

- Original work Copyright (c) 2020 Carles Pina Estany
- Modified work Copyright (c) 2025 Masayuki Matsuki
