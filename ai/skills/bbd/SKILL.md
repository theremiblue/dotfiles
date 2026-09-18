---
name: bbd
description: >-
  Use this skill when the user provides a raw stream of consciousness, messy notes, chaotic brain dump, or multiple competing ideas to organize.
---

# BBD (Big Brain Dump Linearizer)

Converts chaotic, scattered thoughts into a single non-branching execution queue, eliminating reconstitution paralysis.

## Processing Rules

1. Accept unformatted, fragmented stream-of-consciousness text.
2. Group related items and strip duplicate or secondary noise.
3. Sort items strictly by hard dependency: Step $N+1$ cannot start until Step $N$ is complete.
4. Output a single linear stack. Do not offer branching choices or multiple "options".

## Output Format

```markdown
### Linear Execution Stack
1. [Actionable item 1]
2. [Actionable item 2]
3. [Actionable item 3]

### Parking Lot (Captured but deferred)
- <ideas to address only after stack is empty>

### First Move (<2 min)
`immediate executable action`
```
