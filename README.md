# rudolph

A personal build conductor (`/rudolph`) that drives one feature from idea to
review-ready PR through eight phases, keeping the main context thin by delegating
mechanical work to fresh subagents and pausing at human gates. Sibling to `frosty`.

## The pipeline

| # | Phase | How |
|---|-------|-----|
| 1 | Plan / shared understanding | `/grill-me` (gate) |
| 2 | Architecture review | `craft-architect` loop (gate) |
| 3 | Implement + TDD (Red→Green) | subagent + `react-`/`mamba-` testing patterns |
| 4 | Test audit | subagent |
| 5 | De-slop | subagent |
| 6 | PR draft + description (from the diff, not the workpad) | subagent |
| 7 | Cursor cloud E2E | `bin/rudolph-cursor-e2e` over the Cursor API |
| 8 | Verify CI + self-review | gate |

State for each feature lives in `~/development/workdiary/PIPELINE/<ticket>/`
(one artifact per phase + `state.json`). The pipeline is resumable: `/clear` at any
gate and re-run `/rudolph <ticket>`.

## Why it stays thin

Running all eight phases in one window degrades quality by the end. rudolph holds only
the state ledger; phases 3–6 run in subagents whose heavy context is discarded, handing
off through on-disk artifacts. Phase 6 sees **only** `git diff` — so the PR description
can't be polluted by the grill-me/architecture context, which is exactly the goal.

## Setup

```bash
ln -s ~/development/rudolph/skills/rudolph ~/.claude/skills/rudolph   # if not already
cp .env.example .env        # then add CURSOR_API_KEY for phase 7
```

`CURSOR_API_KEY` comes from https://cursor.com/dashboard/api. Phase 7 also needs a paid
Cursor plan and the Cursor GitHub App installed on the repo. Without the key, phase 7
falls back to "run `/agent-e2e-testing` in Cursor yourself."

## Helpers

- `bin/rudolph-cursor-e2e launch <branch> [prompt-file]` — launch the E2E cloud agent.
- `bin/rudolph-cursor-e2e status <agent-id> <run-id>` — poll the run.
