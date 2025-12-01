# Code of Conduct

We are committed to creating a welcoming and inclusive environment for all contributors.
As such, we have adopted the following code of conduct, which all contributors are expected to follow:

- Be respectful of others. Harassment or discrimination of any kind will not be tolerated.
- Be mindful of your language and behavior when communicating with others.
- Be open-minded and willing to learn from others.

# Contributing Guidelines

We welcome contributions to this repository. Here are some guidelines to follow when contributing:

- Make sure your code follows the [Effective Go](https://golang.org/doc/effective_go.html).
- Run the tests and make sure they pass before submitting your changes.
- Make sure you ran linters before submitting your code:
  - `goimports -w ./`
  - `gofmt -s -w ./`
  - `golangci-lint run ./...`
- Create a pull request, follow the PR template to fill the description.
- The maintainers will review your pull request and may request changes or ask questions.
    - <details><summary>The `git log` of you PR is also a subject of review, and you could be asked to fix it by squashing with a meaningful message or simply amending commits in the way that you see it fit.</summary>

      Try to maintain a clean `git log` within your branch.
      You may separate your changes into several commits to make the PR reviews easier.

      If you push small commits addressing review comments to fix a small bug or typo, those should be squashed before merging.
      It helps to think of you commits as something that will be easy to revert later, or bisect to identify bugs.
      A commit for `some change` will be easier to handle than 3 commits about `some change` + `small fix` + `fix typo`.

      </details>
    - Try to rebase your PR against main on a regular basis.
    - Try to avoid merging in main your branch instead of rebasing.
- Merge your PR after getting at least one approval (two are preferable on larger PRs).

# Commit and PR Title Format

This project uses [Conventional Commits](https://www.conventionalcommits.org/) format for both commit messages and PR titles. This is **required** because we use automated semantic versioning - your commit messages directly determine version bumps.

## Format

```
<type>[optional scope]: <description>

[optional body]

[optional footer(s)]
```

## Types

| Type | Description | Version Bump |
|------|-------------|--------------|
| `feat` | A new feature | Minor (0.1.0 → 0.2.0) |
| `fix` | A bug fix | Patch (0.1.0 → 0.1.1) |
| `docs` | Documentation only changes | No release |
| `style` | Code style changes (formatting, etc.) | No release |
| `refactor` | Code changes that neither fix a bug nor add a feature | No release |
| `perf` | Performance improvements | Patch (0.1.0 → 0.1.1) |
| `test` | Adding or correcting tests | No release |
| `build` | Changes to build system or dependencies | No release |
| `ci` | Changes to CI configuration | No release |
| `chore` | Other changes that don't modify src or test files | No release |
| `revert` | Reverts a previous commit | Depends on reverted commit |

## Breaking Changes

For breaking changes, add `!` after the type or include `BREAKING CHANGE:` in the footer:

```
feat!: redesign provider configuration

BREAKING CHANGE: The `endpoint` field is now required.
```

Breaking changes trigger a **major** version bump (0.1.0 → 1.0.0).

## Examples

✅ **Good commit messages:**

```
feat: add support for multi-region clusters
fix: correct timeout handling in vpc peering
docs: update cluster resource examples
refactor: simplify allowlist rule validation
feat(cluster): add node_count parameter
fix!: change default scylla version to 6.0
```

❌ **Bad commit messages:**

```
Add feature          # Missing type prefix
FEAT: add feature    # Type must be lowercase
feat:add feature     # Missing space after colon
feat: Add feature    # Description should start with lowercase
fixed bug            # Missing type prefix
```

## PR Titles

PR titles **must** follow the same Conventional Commits format. When your PR is merged, the PR title becomes the commit message in main, which determines the version bump.

**Important:** The PR title is validated automatically by GitHub Actions. PRs with invalid titles cannot be merged.

## Validation

Both commit messages and PR titles are validated automatically:

- **PR titles** are validated on every PR using [semantic-pull-request](https://github.com/amannn/action-semantic-pull-request)
- **Commit messages** are validated using [commitlint](https://commitlint.js.org/)

If validation fails, update your commit message or PR title to follow the format above.
