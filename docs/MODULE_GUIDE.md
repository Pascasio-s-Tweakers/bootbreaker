# BootBreaker Module Guide

How the team builds BootBreaker. Read sections 1–6 once, then work from your
module's section in 8. The skeleton already builds: every routine exists as a
stub with its contract written above it. Your job is to fill in the bodies
marked `TODO(<your name>)` without changing a contract unless the team agrees.

## Contents

1. [Quick start](#1-quick-start)
2. [Repository layout](#2-repository-layout)
3. [Ownership and workflow](#3-ownership-and-workflow)
4. [Memory map and disk layout](#4-memory-map-and-disk-layout)
5. [Calling convention](#5-calling-convention)
6. [Code style](#6-code-style)
7. [How Stage 2 is assembled](#7-how-stage-2-is-assembled)
8. [Module specs](#8-module-specs)
9. [Testing](#9-testing)
10. [Debugging](#10-debugging)
11. [Timeline checklist](#11-timeline-checklist)
12. [Interrupt and port reference](#12-interrupt-and-port-reference)

---

## 1. Quick start

### Tools

| Tool | Why | Windows | Linux / macOS |
|---|---|---|---|
| NASM | assembler | [nasm.us](https://www.nasm.us/) installer, add to `PATH` | `apt install nasm` / `brew install nasm` |
| GNU Make, dd, od | build | MSYS2: `pacman -S make`, or use WSL | preinstalled / `xcode-select --install` |
| QEMU | main emulator | [qemu.org/download](https://www.qemu.org/download/) | `apt install qemu-system-x86` / `brew install qemu` |
| Bochs **or** VirtualBox | second emulator | [bochs.sourceforge.io](https://bochs.sourceforge.io/) | `apt install bochs bochs-x` / `brew install bochs` |
| GDB (optional) | debugging with QEMU | MSYS2: `pacman -S gdb` | `apt install gdb` |

On Windows, run `make` from Git Bash, an MSYS2 shell, or WSL. PowerShell and
cmd do not have `dd`.

### Build and run

```bash
make            # builds build/bootbreaker.img
make check      # Stage 1 is 512 bytes and ends in 55 AA
make run        # boots in QEMU
make test T=graphics   # boots tests/test_graphics.asm instead of the game
make clean
```

Until Stage 1 is implemented, `make run` shows a black screen that hangs.
That is expected.

VirtualBox: create a VM with type "Other/Unknown", no hard disk, add a floppy
controller, and attach `build/bootbreaker.img` as the floppy image.

---

## 2. Repository layout

```
bootbreaker/
├── Makefile                 build, run, test, check
├── bochsrc.txt              Bochs config (second emulator)
├── src/
│   ├── boot/stage1.asm      boot sector, loads Stage 2              Yuan
│   ├── stage2/main.asm      Stage 2 entry, includes everything      Yuan
│   ├── include/
│   │   ├── config.inc       memory map, disk layout                 Yuan
│   │   ├── stage2_env.inc   STAGE2_ENV_SETUP macro                  Yuan
│   │   ├── stage2_pad.inc   pads Stage 2 to its sector budget       Yuan
│   │   ├── video.inc        mode 13h sizes, colours                 Eusef
│   │   ├── keys.inc         scan codes                              Marc
│   │   └── game.inc         layout and tuning constants             JP
│   ├── lib/
│   │   ├── print.asm        text output (INT 10h)                   Marc
│   │   ├── graphics.asm     pixels and rectangles (VGA memory)      Eusef
│   │   ├── keyboard.asm     non-blocking input (INT 16h)            Marc
│   │   └── timer.asm        frame pacing (BIOS tick)                Marc
│   └── game/
│       ├── state.asm        all game variables (data only)          JP
│       ├── game.asm         title, main loop, win/lose              JP
│       ├── paddle.asm                                               JP
│       ├── ball.asm                                                 JP
│       ├── bricks.asm                                               JP
│       ├── collision.asm                                            JP
│       └── score.asm        score, lives, HUD                       JP
├── tests/                   standalone harnesses, one per library
│   ├── test_print.asm                                               Marc
│   ├── test_input.asm                                               Marc
│   └── test_graphics.asm                                            Eusef
└── docs/
    ├── MODULE_GUIDE.md      this file                               Eusef
    ├── USER_GUIDE.md        how to build and play (deliverable)     Eusef
    └── TEST_LOG.md          emulator test results                   Eusef
```

`lib/print.asm` belongs to Marc, but Yuan's week 1 "Hello" milestone calls
`print_char` and `print_str`, so Marc delivers those two in week 1 and the
rest of the print module in week 2.

---

## 3. Ownership and workflow

| Module | Files | Owner | Reviewer |
|---|---|---|---|
| Boot (Stage 1 and Stage 2 loader) | `boot/`, `stage2/`, `config.inc`, `stage2_*.inc` | Yuan | Eusef |
| Text output (print) | `lib/print.asm` | Marc | JP |
| Graphics (VGA drawing) | `lib/graphics.asm`, `video.inc` | Eusef | Marc |
| Input and timing | `lib/keyboard.asm`, `lib/timer.asm`, `keys.inc` | Marc | JP |
| Game logic | `game/`, `game.inc` | JP | Eusef |
| Documentation and testing | `docs/`, `tests/` harness upkeep, emulator runs | Eusef | Yuan |

### Rules

- **Only the owner edits a module's files.** Need a change in someone else's
  module? Ask them, or open a PR and request them as reviewer.
- **Contracts are shared.** The header above each routine (inputs, outputs,
  clobbers) is a promise to everyone who calls it. Changing one needs the
  caller's OK, and the header changes in the same commit as the code.
- **Branch per task**, named `<module>/<task>`, e.g. `graphics/fill-rect`,
  `boot/load-stage2`. Never push straight to `main`.
- **Every PR is reviewed by the module's reviewer** before merging. The
  reviewer builds it and runs it in QEMU, not just reads it.
- **`main` always builds.** `make && make check` must pass before you merge.
- **Commits**: one logical change each, Conventional Commits style:
  `feat(graphics): add gfx_fill_rect`, `fix(boot): retry disk read after reset`,
  `docs: add memory map to report`. Types: `feat`, `fix`, `docs`, `test`,
  `refactor`, `chore`. Scope = module name.

### Definition of done (per routine)

1. Body implemented, `TODO` removed.
2. Header comment still accurate (In / Out / Clobbers / Notes).
3. Assembles with no NASM warnings.
4. Its test harness shows the expected result in QEMU.
5. Reviewer approved the PR.

---

## 4. Memory map and disk layout

Everything runs in 16-bit real mode with all segment registers = 0, except ES
while drawing.

| Address | Contents |
|---|---|
| `0x00000–0x003FF` | Interrupt vector table, do not write |
| `0x00400–0x004FF` | BIOS data area (tick counter at `0x046C`) |
| `0x00500–0x07BFF` | Free; stack starts at `0x7C00` and grows down |
| `0x07C00–0x07DFF` | Stage 1 (boot sector) |
| `0x07E00–0x09DFF` | Stage 2 (16 sectors = 8 KiB budget) |
| `0xA0000–0xAF9FF` | VGA mode 13h framebuffer, 320 × 200 bytes |

Disk image (1.44 MB floppy, 18 sectors per track):

| Sector (CHS) | Contents |
|---|---|
| 0/0/1 | Stage 1 |
| 0/0/2 … 0/0/17 | Stage 2, padded to `STAGE2_SECTORS` |
| rest | zeros |

All of these numbers live in `src/include/config.inc`. If Stage 2 outgrows
8 KiB the build fails with `TIMES value is negative`; raise `STAGE2_SECTORS`
(17 is the most one INT 13h read can fetch from track 0).

---

## 5. Calling convention

Every routine in the project follows these rules, so anyone can call anyone
else's code without reading it.

1. **Arguments go in registers**, listed under `In:` in the header. No stack
   arguments. Usual order: `AX, BX, CX, DX, SI, DI`.
   - Screen coordinates: **x in CX, y in DX** (same as BIOS INT 10h AH=0Ch).
   - Rectangle size: **width in SI, height in DI**.
   - Colour: **AL**. Brick index: **BX**. String pointer: **DS:SI**.
2. **Results** come back in the registers listed under `Out:`, usually AX.
   Yes/no answers (hit, error, game over) come back in **CF**: `CF = 1` means
   yes. Use `stc` / `clc` and test with `jc` / `jnc`.
3. **Callee saves.** A routine must leave every general register it does not
   list under `Out:` or `Clobbers:` exactly as it found it. `push` what you
   use at the top, `pop` in reverse order before `ret`.
4. **Flags are not preserved** unless the header says so (CF results are
   the exception, by rule 2).
5. **Segments**: DS = ES = SS = 0 on entry and on return. If you point ES at
   `VGA_SEGMENT`, set it back to 0 before `ret`.
6. **Direction flag** is clear (`cld`). If you use `std`, `cld` before `ret`.
7. **Interrupts** stay enabled in Stage 2. Do not leave them off.
8. **Labels inside a routine** start with a dot (`.loop`, `.done`) so they
   are local and never clash with another module.

Stage 1 is exempt from rule 3 where bytes are tight, but its headers still
list what each routine clobbers.

### Routine header template

Copy this above every routine you add:

```nasm
; -----------------------------------------------------------------------------
; module_verb_noun - one line saying what it does
; In:       CX = x, DX = y, AL = colour
; Out:      AX = result  /  CF = 1 if ..., CF = 0 if ...  /  none
; Clobbers: none  (or list the registers it changes besides Out)
; Notes:    algorithm, edge cases, which interrupt it uses
; -----------------------------------------------------------------------------
```

This header is also objective 5 of the proposal ("document the calling
convention and register usage of every routine"), so the report can quote it
directly.

---

## 6. Code style

- **Naming**: routines are `prefix_verb[_noun]` in lowercase. Prefixes:
  `s1_` (Stage 1), `print_`, `gfx_`, `kbd_`, `tmr_`, `game_`, `paddle_`,
  `ball_`, `bricks_`, `col_` / `collision_`, `score_`. Constants are
  `UPPER_SNAKE` with `equ`. Variables are `lower_snake`.
- **Constants**: no magic numbers in code. Put them in the right `.inc` file.
- **Comments**: comment the *why* on the right of the instruction. A
  reader should follow the routine from comments alone.
- **Indentation**: 4 spaces, instructions indented, labels at column 0.
  Align comments at column 41 where practical.
- **File header**: every file starts with the banner already in the
  skeleton (name, purpose, owner, reviewer). Keep it current.
- **Data** goes after code. Game state goes in `game/state.asm`, not in the
  module that happens to use it first.

---

## 7. How Stage 2 is assembled

NASM assembles one file per stage. `src/stage2/main.asm` `%include`s every
library and game file, so Stage 2 is one flat binary loaded at `0x7E00` that
starts running at its first byte.

- `stage2_entry` must stay the first thing that emits bytes.
- Code files are included before data; `stage2_pad.inc` is always last.
- Adding a file: create it under `lib/` or `game/`, add one `%include` line
  in `main.asm` in the right group, and the Makefile picks it up
  automatically.
- `.inc` files hold constants and macros only, so including one twice is
  harmless (they have include guards). `.asm` files emit bytes: include each
  exactly once.
- Include paths are relative to `src/` (`%include "lib/print.asm"`).

---

## 8. Module specs

### 8.1 Boot — Yuan (reviewer Eusef)

**Files**: `src/boot/stage1.asm`, `src/stage2/main.asm`,
`src/include/config.inc`, `stage2_env.inc`, `stage2_pad.inc`

| Routine | Contract |
|---|---|
| `stage1_entry` | Far-jump to `0000:xxxx` to fix CS, set up segments and stack, save DL, print a message, `load_stage2`, jump to `0000:7E00` with DL = boot drive |
| `s1_print` | DS:SI = zero-terminated string, prints with INT 10h AH=0Eh |
| `load_stage2` | INT 13h AH=02h, `STAGE2_SECTORS` sectors from CHS 0/0/2 to `0000:7E00`; up to 3 tries with AH=00h reset between; `disk_error` on failure |
| `disk_error` | Prints a message and halts forever |
| `STAGE2_ENV_SETUP` | Macro: `cli`, DS = ES = SS = 0, SP = `STACK_TOP`, `sti`, `cld` |
| `stage2_entry` | Runs `STAGE2_ENV_SETUP`, saves DL, prints "Hello" (week 1), later calls `game_main` |

**Done when**: `make check` passes, and `make run` shows Stage 1's loading
message followed by Stage 2's "Hello".

**Watch out for**

- 510 bytes is the limit. Short messages, no `lib/` includes in Stage 1.
- Some BIOSes jump to `07C0:0000` instead of `0000:7C00`. Do the far jump
  before using any absolute address.
- Set SS and SP back to back with interrupts off.
- `DL` from the BIOS is the only reliable boot drive number. Do not hardcode
  `0x00`.
- If a read fails on real hardware it is often the motor spinning up; that is
  why we retry.

### 8.2 Text output — Marc (reviewer JP)

**File**: `src/lib/print.asm` · **Test**: `make test T=print`

| Routine | In | Out |
|---|---|---|
| `print_char` | AL = char, BL = colour | — |
| `print_str` | DS:SI = string, BL = colour | — (SI restored) |
| `print_newline` | — | — |
| `print_u16` | AX = value, BL = colour | — |
| `print_set_cursor` | DH = row, DL = col | — |

**Watch out for**: INT 10h may trash BP and other registers on some BIOSes;
save what you need. In mode 13h the text grid is 40 × 25 and BL is the
foreground colour. `print_u16` must print `0` correctly (the classic bug is
printing nothing).

### 8.3 Graphics — Eusef (reviewer Marc)

**Files**: `src/lib/graphics.asm`, `src/include/video.inc` ·
**Test**: `make test T=graphics`

| Routine | In | Out |
|---|---|---|
| `gfx_init` | — | mode 13h on, screen black |
| `gfx_text_mode` | — | back to 80 × 25 text |
| `gfx_clear` | AL = colour | whole screen filled |
| `gfx_put_pixel` | CX = x, DX = y, AL = colour | — |
| `gfx_fill_rect` | CX = x, DX = y, SI = w, DI = h, AL = colour | — |
| `gfx_wait_vsync` | — | returns at the start of vertical retrace |

**Done when**: the graphics test shows a blue screen, four corner pixels, a
16-colour strip and a square moving without tearing.

**Watch out for**

- Offset = `y * 320 + x`. Compute `y * 320` as `(y << 8) + (y << 6)`.
- Save ES, set it to `VGA_SEGMENT`, restore it to 0 before `ret`.
- `rep stosb` uses CX as the counter and DI as the destination; both are
  also arguments, so save them first.
- Off-by-one: a 10-wide rectangle at x = 0 covers x = 0..9.
- Optional, only if flicker is bad after week 3: draw into a back buffer at
  segment `0x1000` and copy it to `0xA000` once per frame.

### 8.4 Input and timing — Marc (reviewer JP)

**Files**: `src/lib/keyboard.asm`, `src/lib/timer.asm`, `src/include/keys.inc` ·
**Test**: `make test T=input`

| Routine | In | Out |
|---|---|---|
| `kbd_poll` | — | AX = key (AH scan, AL ASCII) or 0; never blocks |
| `kbd_wait` | — | AX = key; blocks |
| `kbd_flush` | — | keyboard buffer empty |
| `tmr_get_ticks` | — | AX = low word of the BIOS tick counter |
| `tmr_wait_tick` | — | returns on the next tick (~55 ms) |
| `tmr_wait_ticks` | CX = ticks | returns after CX ticks |

**Done when**: the input test prints dots continuously while idle, shows 75 /
77 / 1 for LEFT / RIGHT / ESC, and two tick readings one second apart differ
by 18.

**Watch out for**

- `kbd_poll` must consume the key (AH=00h) after AH=01h says one is waiting,
  or the same key repeats forever.
- INT 16h gives key presses with the typematic repeat, not "key is held".
  That is fine for the paddle. A custom INT 09h handler for smooth held keys
  is out of scope unless the game feels bad in week 3.
- The tick counter wraps. Compare "changed", never "greater than".
- 18.2 Hz is a slow frame rate. If the ball looks choppy, the game loop can
  pace on `gfx_wait_vsync` (~70 Hz) instead; agree with JP.
- Emulators run timing differently; check on both QEMU and the second
  emulator (anticipated challenge in the proposal).

### 8.5 Game logic — JP (reviewer Eusef)

**Files**: `src/game/*.asm`, `src/include/game.inc`

Depends on everything above. Until the libraries land, call the stubs — they
assemble and return, so you can write the flow first.

| File | Routines |
|---|---|
| `state.asm` | data: `game_state`, `lives`, `score`, `bricks_left`, `paddle_x`, `ball_x/y`, `ball_dx/dy`, `brick_map` |
| `game.asm` | `game_main`, `game_title_screen`, `game_reset`, `game_frame`, `game_end_screen` |
| `paddle.asm` | `paddle_reset`, `paddle_update` (AX = key), `paddle_draw`, `paddle_erase` |
| `ball.asm` | `ball_reset`, `ball_update`, `ball_draw`, `ball_erase` |
| `bricks.asm` | `bricks_init`, `bricks_rect` (BX → CX, DX, SI, DI), `bricks_draw_all`, `bricks_break` (BX) |
| `collision.asm` | `collision_check`, `col_ball_vs_rect` (CF), `col_walls` (CF = floor), `col_paddle`, `col_bricks` |
| `score.asm` | `score_reset`, `score_add` (AX), `score_lose_life` (CF = game over), `score_draw` |

**State machine**

```
GS_TITLE --ENTER--> GS_PLAYING --bricks_left = 0--> GS_WON  --key--> GS_TITLE
    |                   |  \--lives = 0-----------> GS_LOST --key--> GS_TITLE
    +------ESC----------+--ESC--> GS_QUIT (halt)
```

**Frame order** (`game_frame`): wait tick → poll key → erase paddle and ball →
move → collide → draw paddle, ball, HUD. Erasing only what moved avoids
clearing the whole screen every frame, which flickers.

**Done when**: a full game can be won and lost, score and lives update on
screen, ESC quits, and a new game starts cleanly after win or lose.

**Watch out for**

- Velocities are signed: use `neg` to bounce, `jl` / `jg` (signed) when
  comparing positions that can go negative.
- Fast balls can skip through thin bricks. Keep `|dx|, |dy| <= BRICK_H / 2`.
- Break one brick per frame, then bounce, or the ball can tunnel through a
  whole row.
- Clamp the ball against walls after moving, not only flip the sign, or it can
  stick inside a wall.

### 8.6 Documentation and testing — Eusef (reviewer Yuan)

**Files**: `docs/`, `tests/` upkeep

- Keep this guide in sync when a contract or layout changes.
- `docs/USER_GUIDE.md`: build and play instructions (proposal deliverable).
- `docs/TEST_LOG.md`: record every emulator run (date, commit, emulator,
  result). Objective 6 needs a 5-minute crash-free session on QEMU and one
  other emulator.
- Technical report outline (deliverable): design overview, memory map
  (section 4), boot process, interrupts used (section 12), calling convention
  (section 5) with the routine headers, testing results, lessons learned.

---

## 9. Testing

Each library has a harness in `tests/` that replaces Stage 2 in a throwaway
image (`build/test_<name>.img`). They need a working Stage 1, so Boot comes
first.

```bash
make test T=print
make test T=input
make test T=graphics
```

Each harness lists what you should see under "Expect". A routine passes when
the screen matches. Add a harness for a new library by copying an existing
one: `STAGE2_ENV_SETUP`, your test code, a hang loop, your `%include`s, then
`stage2_pad.inc` last.

Before every merge to `main`:

```bash
make clean && make && make check && make run
```

---

## 10. Debugging

**QEMU + GDB**

```bash
make debug        # QEMU starts paused, listening on :1234
gdb -ex "target remote :1234" -ex "set architecture i8086" -ex "break *0x7c00" -ex "continue"
```

Useful GDB commands: `info registers`, `x/16xb 0x7e00`, `stepi`,
`break *0x7e00` (Stage 2 entry). GDB shows linear addresses: `seg * 16 + off`.

**QEMU monitor**: press `Ctrl+Alt+2` in the QEMU window, then `info registers`
or `xp /16xb 0x7c00`. `Ctrl+Alt+1` returns to the screen.

**Bochs**: put `xchg bx, bx` anywhere in the code; with `magic_break` on (see
`bochsrc.txt`) the Bochs debugger stops there. Remove it before merging.

**Quick checks**

- Black screen, nothing printed: Stage 1 never ran. `make check`, then confirm
  `55 aa` at offset 510 with `xxd build/stage1.bin | tail -1`.
- Prints "loading" then hangs: Stage 2 not loaded or the jump target is wrong.
  Look at `0x7e00` in the monitor.
- Garbage on screen: a routine broke DS or ES. Check rule 5 of the calling
  convention.
- Crash after many frames: unbalanced `push`/`pop` (stack slowly drifts).

---

## 11. Timeline checklist

### Week 1 — Boot (Yuan, with Marc on print)
- [ ] Toolchain installed on every member's machine; `make` builds the empty skeleton
- [ ] `STAGE2_ENV_SETUP`, `s1_print`, `load_stage2`, `disk_error`, `stage1_entry` (Yuan)
- [ ] `print_char`, `print_str`, needed for "Hello" (Marc)
- [ ] **Milestone**: Stage 2 prints "Hello" after loading from disk

### Week 2 — Core routines (Eusef, Marc)
- [ ] `print_newline`, `print_u16`, `print_set_cursor` — `make test T=print` (Marc)
- [ ] All `gfx_*` — `make test T=graphics`
- [ ] All `kbd_*`, `tmr_*` — `make test T=input`
- [ ] **Milestone**: each routine passes its own test

### Week 3 — Game (JP, with the others reviewing)
- [ ] `game_main` flow and state machine with stubbed screens
- [ ] Paddle moves and clamps
- [ ] Ball moves and bounces off walls
- [ ] Bricks drawn, broken, counted
- [ ] Score and lives HUD
- [ ] Win and lose screens, restart
- [ ] **Milestone**: playable start to finish

### Week 4 — Polish (everyone, Eusef leads)
- [ ] Second emulator (Bochs or VirtualBox) runs it
- [ ] 5-minute crash-free session on both, logged in `TEST_LOG.md`
- [ ] Every routine header accurate; no `TODO` left (`grep -rn TODO src`)
- [ ] User guide, technical report, demo script
- [ ] **Milestone**: 5-minute play session runs without crashes

---

## 12. Interrupt and port reference

| Call | Registers in | Result | Used by |
|---|---|---|---|
| INT 10h AH=00h | AL = mode (`03h` text, `13h` graphics) | sets video mode | graphics |
| INT 10h AH=02h | BH = page 0, DH = row, DL = col | moves cursor | print |
| INT 10h AH=0Eh | AL = char, BH = page 0, BL = colour | teletype output | print, stage1 |
| INT 13h AH=00h | DL = drive | resets disk; CF = 1 on error | stage1 |
| INT 13h AH=02h | AL = count, CH = cyl, CL = sector, DH = head, DL = drive, ES:BX = buffer | reads sectors; CF = 1 on error, AH = status | stage1 |
| INT 16h AH=00h | — | waits; AH = scan code, AL = ASCII | keyboard |
| INT 16h AH=01h | — | ZF = 1 if no key; else AX = key, not removed | keyboard |
| `[0x046C]` | — | BIOS tick counter dword, ~18.2 Hz | timer |
| port `0x3DA` | `in al, dx` | bit 3 = vertical retrace | graphics |
| `A000:0000` | — | mode 13h framebuffer, byte per pixel | graphics |

References: [OSDev Wiki](https://wiki.osdev.org/) (Boot Sequence, BIOS,
VGA Hardware, Real Mode), [NASM manual](https://www.nasm.us/doc/),
[Ralf Brown's Interrupt List](https://www.ctyme.com/rbrown.htm),
Intel SDM vol. 2 for instruction details.
