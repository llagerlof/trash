# AGENTS.md

Technical notes for automated agents working on this repository.

## Overview
- `trash` is a Bash script that moves files, directories, and symlinks into a destination without overwriting existing entries.
- Name collisions are resolved by appending numeric suffixes (`-2`, `-3`, ...). For files, the suffix is inserted before the extension.

## Command Behavior
- Usage: `./trash <source>... [destination_directory]`
- Usage: `./trash <source>... -d destination_directory`
- `-h`/`--help` prints usage and exits.
- If the last argument is an existing directory, it is treated as the destination and all preceding arguments are sources.
- If no destination is provided, the script uses `~/.trash` and creates it if missing.
- If a destination is provided, it must already exist.
- `-d` explicitly sets the destination directory.
- Multiple sources are supported in a single invocation.

## Safety/Edge Cases
- Refuses to move a directory into itself or one of its subdirectories.
- Handles symlinks explicitly and moves them as symlinks (including broken symlinks).
- Uses `mv --` to avoid issues with leading-dash filenames.
- Exits non-zero on errors (missing source, invalid destination, failed moves).

## Tests
- Tests live in `tests/test_trash.sh` and are shell-based (no external framework).
- Run tests with `bash tests/test_trash.sh`.
- Current coverage includes:
  - File suffixing with multi-extension filenames.
  - Directory name conflicts.
  - Symlink handling (valid and broken).
  - Multi-source invocations.
  - Missing source failure.
  - Self-move guard.

## Compatibility
- Designed for Bash; uses `${!#}` and array-like expansions.
- Should run on POSIX-like systems with Bash installed.
