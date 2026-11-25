# BootBreaker

A Breakout-style game that boots straight from a disk image, with no operating
system. Written in 16-bit real-mode x86 assembly (NASM): a 512-byte Stage 1
bootloader loads Stage 2, which runs the game with BIOS interrupts and direct
writes to VGA mode 13h memory.

CMSC 131 project · Birondo, Blancada, Salomeo, Sian · Lecture section 2

## Build and run

Needs NASM, GNU Make and QEMU (on Windows, run from Git Bash, MSYS2 or WSL).

```bash
make          # build/bootbreaker.img
make run      # boot it in QEMU
make check    # verify the boot sector size and signature
```

### Module demos

Run these in QEMU to check Marc's modules independently of the unfinished
game loop:

```bash
make test T=print   # prints "print_str ok", 0, 1234, 65535, and an X at row 10, column 20
make test T=input   # reports elapsed ticks, then press any key; LEFT/RIGHT report scan codes; ESC exits
```

`make run` currently boots the loading message and Stage 2's `Hello from Stage
2!` greeting; the full game loop is not integrated yet. Use the module demos
above to assess Marc's routines.

In the print demo, the expected text is `print_str ok` followed by the three
numbers on separate lines; `X` appears partway down the screen.

The input demo first reports the BIOS ticks elapsed while waiting for 18 ticks
(around 18; slight variation is normal). It then waits for a key, prints idle
dots without blocking, and reports each key's BIOS scan code: LEFT is `75`,
RIGHT is `77`, and ESC is `1`. ESC ends the test.

## Team

Start with **[docs/MODULE_GUIDE.md](docs/MODULE_GUIDE.md)**: ownership, the
calling convention every routine follows, the memory map, per-module specs and
the weekly checklist.

| Module | Owner | Reviewer |
|---|---|---|
| Boot (Stage 1 and 2 loader) | Yuan | Eusef |
| Graphics (VGA drawing) | Eusef | Marc |
| Input and timing | Marc | JP |
| Text output (print) | Marc | JP |
| Game logic | JP | Eusef |
| Documentation and testing | Eusef | Yuan |
