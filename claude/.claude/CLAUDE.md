## Git Repositories

- `/home/spajxo/Projects/git.digital.cz` - GitLab (používej `glab` skill)
- `/home/spajxo/Projects/github.com` - GitHub (používej `gh`)

**GitLab MR:** Vždy `--reviewer @me` (ne assignee — kvůli code-review funkcím v GitLabu) a `--remove-source-branch`.

**Commit messages:** Always in English.

## DevProxy

Lokální HTTPS reverse proxy (nginx v Dockeru), doména `*.dsdev.digital` (wildcard → 127.0.0.1). Compose: `VIRTUAL_HOST`, `VIRTUAL_PORT`, external network `proxy_network`. Ovládání: `dsdev proxy …`.

## Atlassian

- **Site:** digitalcz.atlassian.net
- **Cloud ID:** 6b2c79e1-f26a-48a5-9145-d9d5c553993e

## Portainer (`porty`)

Portainer používáme pro většinu projektů (testing i produkce, pár výjimek). `porty` = read-only CLI (jen GET/HEAD — nic nemění), na ověření stavu stacků/kontejnerů. Katalog příkazů, config a flagy: `porty guide` (lidsky) / `porty guide --json` (pro agenty).

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

### 12. A question is not a task

**When I ask whether something is possible, answer first — don't implement.**

- Phrasing like "dá se to udělat?", "je to možné?", "existuje...?" is a request for
  information, not a mandate to act. Same for English equivalents ("can this be
  done?", "is there a way to...?").
- Give a direct answer (ANO/NE + brief reasoning). Do whatever research is needed to
  answer confidently, but stop there — don't build, configure, or edit files as part
  of answering.
- Only implement after I've explicitly said to go ahead ("udělej to", "nastav to",
  "implementuj", "pojď na to").
- It's fine to offer the next step ("Ano, jde to takto — mám to i nastavit?"), but
  wait for confirmation before acting on it.

### 13. Sync before you analyze — never reason from a stale branch

**A local checkout can be behind `origin`. Verify freshness before you draw conclusions from it.**

- Before reading files to reason about "current state" (audits, reviews, drift checks,
  "what's done"), run `git fetch` and check how far the local branch is behind
  (`git status -sb` / `git log --oneline HEAD..origin/<branch>`). If behind, sync or read
  from `origin/<branch>` (`git show origin/main:path`) — don't analyze the stale tree.
- Especially when cross-referencing local files against live remote data (GitLab/GitHub API,
  deployed state): both sides must be the same revision, or you'll chase phantom drift.
- New worktrees branch from `origin` (fresh) — if the local checkout differs, that's the tell
  the local branch is stale. Trust `origin`, not the old working copy.

### 14. Comment sparingly — code should read itself

**Comments explain WHY, not WHAT. If the code already says it, don't repeat it.**

- No comments that restate the code (`// increment i`, `// loop over users`,
  `i++ // add one`). If a reader who knows the language can see it from the line,
  the comment is noise.
- No narration comments that walk through the steps (`// first we fetch the data`,
  `// now validate`, `// finally return`). Structure and naming carry that.
- No diff/changelog comments about what you just did (`// added error handling`,
  `// changed to async`, `// new`). Git history is the changelog, not the source.
- No header/banner blocks or section dividers that weren't already the file's style.
- Prefer self-documenting code over a comment: a well-named function, variable, or
  constant beats a comment that explains a bad name. Fix the name first.
- When you do document, document the API surface (public contract, params, invariants),
  not the implementation details — those change and the comment rots.
- Business decisions and rationale belong in the commit body or the docs, not in an
  inline comment. The source is not a changelog or a decision log.
- DO write a comment when it earns its place: a non-obvious WHY, a gotcha, a
  workaround with a reason, a link to an issue/spec, or a warning about a
  surprising constraint. Rare and load-bearing beats frequent and obvious.
- Match the file's existing comment density. If the surrounding code is sparse,
  stay sparse — don't be the one function that's over-annotated.
- When unsure whether a comment earns its place, cut it. The default is no comment.
