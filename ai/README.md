# AI Configuration

System-wide configuration, prompt rules, and setup scripts for different agents.

```bash
./ai/setup.sh
```

Run setup for all supported agents:
```bash
./ai/setup.sh all
```

Run setup for specific agents:
```bash
./ai/setup.sh claude opencode
```

## Skills

Modular on-demand workflows located in `ai/skills/`:

| Skill | Trigger Words | Purpose |
| :--- | :--- | :--- |
| **`bootstrap`** | `bootstrap`, `break down`, `how to start`, `stuck` | Generates a 60-second physical doorstep action, max 3–5 micro-steps, and an explicit "Done Enough" MVP boundary. |
| **`bbd`** | `bbd`, `brain dump`, `linearize`, `organize thoughts` | Converts raw stream-of-consciousness thoughts into an unbranching $1 \to N$ linear execution stack. |

### Inspirations

- [ayghri/i-have-adhd](https://github.com/ayghri/i-have-adhd)
