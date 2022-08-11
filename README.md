# Commodore config package template

This repository is part of Project Syn.
For documentation on Project Syn and this component, see https://syn.tools.

## Template sync

This repository contains a GitHub action which runs `commodore package sync`.
The action is triggered when changes are pushed to the `main` branch.
Additionally, the action can be triggered manually.

To enable updates from the template for a package, you need to add the package in `packages.yaml` in format `<organization>/<repository-name>`.

The GitHub action uses credentials (SSH key and personal access token) associated with account @vshnbot to push changes and create PRs on the managed package repositories.

Please note that, while we provide a GitHub action which executes `commodore package sync --dry-run`, the PR action output will not preview of package updates caused by template changes in the PR, as `commodore package sync` updates each package to the template version indicated in the package's `cruft.json`.
