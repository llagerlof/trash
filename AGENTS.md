# AGENTS.md

Technical notes for automated agents working on this repository.

## Overview
- `trash` is a Bash script that moves files, directories, and symlinks into a destination without overwriting existing entries.
- Name collisions are resolved by appending numeric suffixes (`-2`, `-3`, ...). For files and symlinks, the suffix is inserted before the extension when present; single-dot hidden names like `.bashrc` become `.bashrc-2`.

## Command Behavior
- Usage: `./trash <source>... [destination_directory]`
- Usage: `./trash <source>... -d destination_directory`
- `-h`/`--help` prints usage and exits.
- `--version` prints the current version and exits.
- Literal source names that look like options must be passed with a path prefix such as `./-h`, `./--help`, or `./-d`.
- If more than one source is provided and the last argument is an existing directory, it is treated as the destination and all preceding arguments are sources.
- If no destination is provided, the script uses `~/.trash` and creates it if missing.
- If a destination is provided, it must already exist.
- `-d` explicitly sets the destination directory.
- Multiple sources are supported in a single invocation.

## Safety/Edge Cases
- Refuses to move a directory into itself or one of its subdirectories.
- Handles symlinks explicitly and moves them as symlinks (including broken symlinks).
- Uses `mv --` to avoid issues with leading-dash filenames.
- Exits non-zero on errors (missing source, invalid destination, failed moves, or mixed-success runs with at least one failure).

## Tests
- Tests live in `tests/test_trash.sh` and are shell-based (no external framework).
- Run tests with `bash tests/test_trash.sh`.
- Current coverage includes:
  - File suffixing with multi-extension filenames.
  - Repeated file suffix escalation (`-3`, `-4`, ...).
  - Dotfile collision suffixing such as `.bashrc-2`.
  - Directory name conflicts.
  - Symlink handling (valid and broken), including symlink name collisions.
  - Multi-source invocations.
  - Missing source failure.
  - Self-move guard.

## Compatibility
- Designed for Bash; uses `${!#}` and array-like expansions.
- Should run on POSIX-like systems with Bash installed.

## Versioning

- Folow the Semantic Versioning (SEMVER 2.0.0) rules (https://semver.org) when applying a fix or a new feature. Update the version in the script if necessary.
