
# Publishing the Serverpod extension

This document describes how to publish the Serverpod VS Code extension to the VS Code Marketplace and Open VSX, using either the preferred CI pipeline or manual methods.

## Pre-step: Version and changelog update

Before publishing, always:
- Update the `version` field in `package.json` to the new release version.
- Update the changelog with the changes for the new version.

## Preferred method: publish via CI pipeline

Publishing the Serverpod VS Code extension should be done through the automated CI pipeline, as defined in `.github/workflows/publish-extension.yaml`. This ensures a consistent, secure, and reproducible release process.

**Steps:**
1. Complete the pre-step above.
2. **Tag a release:**
	- Push a git tag matching the pattern `extension-v<major>.<minor>.<patch>` (e.g., `extension-v1.2.3`).
	- Pre-release tags are also supported (e.g., `extension-v1.2.3-pre.1`).
3. **CI workflow triggers:**
	- The pipeline will automatically run on tag push and publish the extension to both the VS Code Marketplace and Open VSX.
	- The environment variables `VSCE_PAT` and `OVSX_PAT` are used to provide the required tokens for publishing. These are already configured in the repository settings.

**Alternative: Manual workflow dispatch**
You can also manually trigger the publish workflow from the GitHub Actions tab using the "workflow dispatch" feature. This allows you to publish a release without pushing a new tag. Make sure the pre-step is completed before triggering the workflow.

## Manual publishing

If you need to publish the extension manually (not recommended), you must supply your own Personal Access Tokens (PAT) for each service.

**Steps:**
1. Complete the pre-step above.
2. **Install dependencies**
	- Run `npm ci` in the `tools/serverpod_vscode_extension` directory.
3. **Publish to VS Code Marketplace**
	- Run `npm run publish-vscode` (requires `VSCE_PAT` environment variable).
4. **Publish to Open VSX**
	- Run `npm run publish-openvsx` (requires `OVSX_PAT` environment variable).

The publish scripts are defined in `package.json`:
  - `publish-vscode`: Publishes to VS Code Marketplace
  - `publish-openvsx`: Publishes to Open VSX

You must set the required PATs in your environment before running these commands:
```sh
export VSCE_PAT=your-vsce-token
export OVSX_PAT=your-ovsx-token
```
