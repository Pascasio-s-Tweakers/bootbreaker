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
