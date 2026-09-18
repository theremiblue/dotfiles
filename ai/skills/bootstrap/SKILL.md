---
name: bootstrap
description: >-
  Use this skill when the user feels stuck, overwhelmed, facing task initiation paralysis, or asks to break down, start, or plan a feature.
---

# Bootstrap Protocol (Task Initiation & Decomposition)

Overcomes task initiation paralysis by reducing cognitive load to the absolute minimum viable action.

## Rules of Engagement

1. **No Project Roadmaps**: Do not provide 10-step or 20-step plans.
2. **Doorstep Action (<60s)**: Step 1 must be a single, physical, zero-decision action:
   - An exact file path and line number to open: `path/to/file:42`
   - A single terminal command to run: `git checkout -b feat/xyz`
3. **Max 3–5 Micro-Steps**: Each subsequent step must take under 5 minutes.
4. **Define "Done Enough"**: Explicitly declare the minimum functional outcome that constitutes completion.
5. **Define "Out of Scope"**: List tempting side-quests to ignore.

## Response Format

```markdown
### Doorstep Action (<60 seconds)
`open file/to/target.ts:12` or `npm test -- path/to/test.ts`

### Micro-Queue (Max 4 steps, <5 min each)
1. Step one action
2. Step two action
3. Step three action

### Boundary Guard
- **Done Enough**: <single sentence defining MVP stopping point>
- **Out of Scope**: <features, refactors, or optimizations to avoid right now>
```
