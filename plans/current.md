# Remediation Plan: Repository Cleanup for UKF-TE

## Context & Objectives
Clean the repository of legacy scaffolding inherited from `terraform-provider-file`. Remove obsolete tools, update references to match `ukf-te`, and ensure repository integrity following the strict 2-item remediation loop protocol.

---

## Remediation Batches

### Batch 1 (Completed)
- [x] Item 1: Update `agent-scripts/cleanup-data.js` to target `.gemini/tmp/ukf-te` instead of `.gemini/tmp/terraform-provider-file`.
- [x] Item 2: Remove unneeded scripts inherited from Terraform provider development (`agent-scripts/update-modules.sh` and `agent-scripts/compile-docs.js`). Unstaged from index. File deletion on disk requires user execution due to hook guardrails.

### Batch 2 (Completed)
- [x] Item 3: Clean up environment manifests (`flake.nix` and `.aliases`, `run-in-nix.sh`) to remove Terraform, leftovers, and Terraform aliases.
- [x] Item 4: Remove/update references to `terraform-provider-file` in `.functions`, `.gemini/system.md`, and skill scripts (`.gemini/skills/github-pr/scripts/read_comments.js`, `.gemini/skills/github-pr/SKILL.md`, `.gemini/skills/github-ci/SKILL.md`). Made upstream remote checks and examples fully repository-agnostic.

### Batch 3 (Completed)
- [x] Item 5: Update unit test fixtures and assertions across `.gemini/skills/git/tests/git.test.js`, `agent-scripts/lib/utils.test.js`, and GitHub skills to be repository-agnostic. All 372 unit tests across skills and agent utilities pass cleanly with zero failures.
- [x] Item 6: Ensure template-ready document structure, keeping UKF-TE architecture documentation intact while organizing repo scaffolding cleanly. Zero legacy references remain in the repository.

### Batch 4 (Completed)
- [x] Item 7: Update `github-ci` and `github-pr` skills and test suites (`.gemini/skills/github-ci/tests/github-ci.test.js`, `.gemini/skills/github-pr/tests/github-pr.test.js`, and `github-ci/scripts/auth.js`) to dynamically derive owner/repo from Go directory structure and fork from git remote.
- [x] Item 8: Expose `getRepoContext()` in `agent-scripts/lib/utils.js` and update `agent-scripts/lib/utils.test.js` and `.gemini/skills/git/tests/git.test.js` to dynamically determine owner and repo. All 372 tests pass with zero failures and zero hardcoded dummy owner/repo strings.
