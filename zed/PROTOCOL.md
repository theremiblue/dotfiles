# Hand-Coding & Muscle-Memory Protocol (Zed 14-Day Sprint)

## 1. The Golden Rules of the Protocol
1. **Use What Is Already Automatic + Only 3 Target Keys**:
   - Keep using basic Vim motions that require zero thought (`h/j/k/l`, `w/b`, `i/a/o`, `d/c/y`, `/`, `space w` to save, `cmd-p` to open files).
   - **Never try to remember more than 3 new keys at once.** Only practice the 3 keys in your current Stage below. For everything else, do it the slow/manual way without guilt.
2. **Zero Mid-Session Configuration**:
   - You are forbidden from opening `settings.json`, `keymap.json`, or searching docs while coding C/C++/Zig.
   - If something feels clunky, run `ulog`, type 1 raw line, close the buffer, and immediately return to your code.
3. **Zero Mid-Session Chatboxes**:
   - Keep Zed's AI panel closed while coding by hand.
   - AI is used only at the bookends (`ulog start` and `ulog eod`) or silently in the background when you close a `ulog` commit buffer.

---

## 2. The Core 10 Progression (Advance Only When `[x]` Automatic)

### Stage 1: Spatial Navigation (Days 1–4)
- [ ] `gd` — Jump to definition of symbol under cursor
- [ ] `ctrl-o` / `ctrl-i` — Jump back / forward to exact previous cursor location
- [ ] `mA` then `'A` — Pin primary source file to mark `A` (`mA`) and jump back to it from anywhere (`'A`)

### Stage 2: Inspection & Callers (Days 5–9)
- [ ] `K` (`shift-k`) — Hover documentation / function signature (`K` twice to focus popup)
- [ ] `gr` — Find all references in a single editable multibuffer
- [ ] `]d` / `[d` — Jump to next / previous compiler diagnostic in file

### Stage 3: Speed & Precision (Days 10–14)
- [ ] `ctrl-^` — Toggle instantly between current and previous file
- [ ] `*` then `n` / `N` — Search exact word under cursor forward / backward
- [ ] `g.` — Open code actions / apply `clang-tidy` fix or `#include`
- [ ] `.` — Repeat last edit command (`ciw`, `daf`, etc.)

---

## 3. Daily Rhythm (`ulog`)
1. **Start of Day (`ulog start`)**: Review active 3-key Stage, carry over unfinished tasks, and pick 1 doorstep action (`<60s`).
2. **During Coding (`ulog`)**: Works like `git commit`. Opens a scratch buffer; dump raw thoughts/friction at the top, save & close (`space w`, `cmd-w`). Background agent formats and files it into `~/log/YYYY-MM-DD.md` while you keep coding.
3. **End of Day (`ulog eod`)**: Check off `[x]` any key used 5+ times without thinking, and let the agent resolve today's logged friction items.
