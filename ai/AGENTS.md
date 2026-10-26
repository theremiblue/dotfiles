# AGENTS.md

## 1. Response Structure & Interaction Rules

### Rule 1.1: Lead with the Next Action
The first line must be something immediately executable: a terminal command, a code snippet, or an exact file path with line numbers (`path/to/file:42`).
- Prose comes after the action, if at all.
- Zero throat-clearing: no greetings, pleasantries, or conversational openers.

### Rule 1.2: Number Multi-Step Work
- Multi-step tasks must use a strictly numbered list.
- Each step must represent exactly one bounded action.
- Use the minimal viable number of steps.

### Rule 1.3: Restate State Every Turn
Begin multi-turn responses with a one-sentence summary of current state:
- Format: `State: <completed action>. Next: <pending action>.`

### Rule 1.4: Suppress Tangents
- Finish active tasks completely before mentioning secondary findings.
- Secondary findings or suggested improvements must be placed in a single line at the very end:
  `Separately: <issue>.`

### Rule 1.5: End with One Concrete Micro-Action (<2 min)
Always close with exactly one concrete action that takes under two minutes.

### Rule 1.6: Concrete Time Estimates & Tone
- State precise time estimates (e.g., `~5 minutes`).
- Use a matter-of-fact tone. Never apologize or include emotional filler.

### Rule 1.7: Compression Trigger
If the user requests "shorter", "condense", "compress", or "bullets only":
- Drop all explanatory prose entirely.
- Output only the numbered executable steps and the final micro-action.

---

## 2. Code Style & Engineering Rules

### Rule 2.1: Zero Comments
- Code must be self-documenting through clear naming and small functions.
- Do not write explanatory or narrative comments.
- Comments are allowed only for compiler, linter, or type directives (`@formatter:off` and other tool-specific).

### Rule 2.2: Flat Logic (Max 2–3 Levels of Nesting)
- 3 levels of nesting is maximum.
- Deep nesting is forbidden.
- Use guard clauses and early returns to handle errors and boundary conditions early.
- Extract nested blocks into dedicated helper functions.

### Rule 2.3: Targeted Edits Only
- Modify only lines directly relevant to the current task.
- Do not reformat or rewrite adjacent unmodified code.

### Rule 2.4: Ruthless Cleanup
- Never keep compatibility shims, wrappers, or unused imports unless explicitly requested.
- Delete dead functions, stale types, and orphaned variables immediately.
- Do not leave commented-out code or TODO stubs.

---

## 3. Testing & Verification Rules

### Rule 3.1: No Unsolicited Tests
- Do NOT create any tests unless asked.

### Rule 3.2: Implementation Precedence Over Tests
- Do NOT change the agreed upon implementation to satisfy tests.

### Rule 3.3: Frozen Test Code
- Do NOT change the test code unless explicitly asking, even if after changes tests fail.

