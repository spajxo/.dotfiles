## Git Repositories

- `/home/spajxo/Projects/git.digital.cz` - GitLab (používej `glab` skill)
- `/home/spajxo/Projects/github.com` - GitHub (používej `gh`)

**GitLab MR:** Vždy `--assignee @me` a `--remove-source-branch`.

**Commit messages:** Always in English.

## DevProxy

Lokální HTTPS reverse proxy (nginx v Dockeru). Doména: `*.dsdev.digital` (wildcard DNS → 127.0.0.1, funguje i mezi kontejnery).

Docker Compose: `VIRTUAL_HOST`, `VIRTUAL_PORT`, network `proxy_network` (external).

Příkazy: `dsdev proxy start|stop|list|status|update|cert-install`

## Atlassian

- **Site:** digitalcz.atlassian.net
- **Cloud ID:** 6b2c79e1-f26a-48a5-9145-d9d5c553993e

## Coding Guidelines

**Tradeoff:** These guidelines bias toward caution over speed. For trivial tasks, use judgment.

### 1. Think Before Coding

**Don't assume. Don't hide confusion. Surface tradeoffs.**

Before implementing:
- State your assumptions explicitly. If uncertain, ask.
- If multiple interpretations exist, present them - don't pick silently.
- If a simpler approach exists, say so. Push back when warranted.
- If something is unclear, stop. Name what's confusing. Ask.

### 2. Simplicity First

**Minimum code that solves the problem. Nothing speculative.**

- No features beyond what was asked.
- No abstractions for single-use code.
- No "flexibility" or "configurability" that wasn't requested.
- No error handling for impossible scenarios.
- If you write 200 lines and it could be 50, rewrite it.

Ask yourself: "Would a senior engineer say this is overcomplicated?" If yes, simplify.

### 3. Surgical Changes

**Touch only what you must. Clean up only your own mess.**

When editing existing code:
- Don't "improve" adjacent code, comments, or formatting.
- Don't refactor things that aren't broken.
- Match existing style, even if you'd do it differently.
- If you notice unrelated dead code, mention it - don't delete it.

When your changes create orphans:
- Remove imports/variables/functions that YOUR changes made unused.
- Don't remove pre-existing dead code unless asked.

The test: Every changed line should trace directly to the user's request.

### 4. Goal-Driven Execution

**Define success criteria. Loop until verified.**

Transform tasks into verifiable goals:
- "Add validation" → "Write tests for invalid inputs, then make them pass"
- "Fix the bug" → "Write a test that reproduces it, then make it pass"
- "Refactor X" → "Ensure tests pass before and after"

For multi-step tasks, state a brief plan:
```
1. [Step] → verify: [check]
2. [Step] → verify: [check]
3. [Step] → verify: [check]
```

Strong success criteria let you loop independently. Weak criteria ("make it work") require constant clarification.

### 5. Use the model only for judgment calls

**If code can answer, code answers.**

- Use me for: classification, drafting, summarization, extraction.
- Do NOT use me for: routing, retries, deterministic transforms.
- Deterministic logic belongs in code, not in a prompt.

### 6. Surface conflicts, don't average them

**If two patterns contradict, pick one. Explain why.**

- Prefer the more recent / more tested pattern.
- Flag the loser for cleanup — don't silently leave both.
- Never blend conflicting patterns into a third hybrid.

### 7. Read before you write

**"Looks orthogonal" is dangerous.**

Before adding code:
- Read the exports of the file you're touching.
- Read immediate callers.
- Read shared utilities you might be duplicating.
- If unsure why code is structured a particular way, ask — don't guess.

### 8. Tests verify intent, not just behavior

**A test that can't fail when business logic changes is wrong.**

- Tests must encode WHY the behavior matters, not just WHAT it does.
- Snapshot/assert-anything tests that pass regardless of intent are noise.
- If a test wouldn't catch a real bug, rewrite it or delete it.

### 9. Checkpoint after every significant step

**Don't continue from a state you can't describe back.**

- Summarize what was done, what's verified, what's left.
- If you lose track, stop and restate before doing more.
- Checkpoints are how multi-step work stays recoverable.

### 10. Match the codebase's conventions, even if you disagree

**Conformance > taste inside the codebase.**

- Mirror existing patterns, naming, and structure even if you'd write it differently.
- If a convention is genuinely harmful, surface it as a separate concern.
- Don't fork silently — a quiet "improvement" is just inconsistency.

### 11. Fail loud

**Default to surfacing uncertainty, not hiding it.**

- "Completed" is wrong if anything was skipped silently.
- "Tests pass" is wrong if any were skipped or marked xfail without note.
- Partial success is not success — name what didn't work.
