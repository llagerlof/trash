# Trash Utility

A Bash script that safely moves files and directories to a destination folder without overwriting existing items.

## Purpose

This utility works similar to a "trash" or "safe move" operation, ensuring that when files or directories are moved to a destination, they will never overwrite existing items with the same name. Instead, the script automatically renames them by adding a numerical suffix.

## Features

- Moves both files and directories
- Handles name conflicts by adding numerical suffixes (2, 3, 4, etc.)
- Preserves file extensions when renaming
- Uses a default trash location if no destination is specified
- Provides informative error messages

## Installation

The script name is `trash`.

If you install it to `~/.local/bin`, make sure that directory is on your `PATH`.

### Install only for the current user

#### Option 1: Clone the repository and create a symlink

Clone the repository into `~/repos/trash` or `~/repositories/trash`, make the script executable, and symlink it into `~/.local/bin`:

```bash
mkdir -p ~/repos ~/.local/bin
git clone https://github.com/llagerlof/trash.git ~/repos/trash
chmod +x ~/repos/trash/trash
ln -sf ~/repos/trash/trash ~/.local/bin/trash
```

If you prefer `~/repositories`, replace `~/repos/trash` with `~/repositories/trash`.

#### Option 2: Download the script directly

Download the script into `~/.local/bin` and make it executable:

```bash
mkdir -p ~/.local/bin
curl -fsSL https://raw.githubusercontent.com/llagerlof/trash/main/trash -o ~/.local/bin/trash
chmod +x ~/.local/bin/trash
```

### Install for everyone

#### Option 3: Clone the repository and create a system-wide symlink

Clone the repository into a normal user's home directory such as `~/repos/trash` or `~/repositories/trash`, make the script executable, and symlink it into `/usr/local/bin`:

```bash
mkdir -p ~/repos
git clone https://github.com/llagerlof/trash.git ~/repos/trash
chmod +x ~/repos/trash/trash
sudo ln -sf ~/repos/trash/trash /usr/local/bin/trash
```

Run the `git clone` and `chmod` commands as a normal user, not as `root`. If you prefer `~/repositories`, replace `~/repos/trash` with `~/repositories/trash`.

#### Option 4: Download the script directly system-wide

Download the script into `/usr/local/bin` and make it executable:

```bash
sudo curl -fsSL https://raw.githubusercontent.com/llagerlof/trash/main/trash -o /usr/local/bin/trash
sudo chmod +x /usr/local/bin/trash
```

## Usage

```bash
./trash <source>... [destination_directory]
./trash <source>... -d destination_directory
./trash -h|--help
./trash --version
```

### Parameters

- `source`: One or more files/directories (and symlinks) you want to move
  - Filenames that look like options must be passed with a path prefix, for example `./-h`, `./--help`, or `./-d`
- `destination_directory`: (Optional) The directory where you want to move the sources
  - If not provided, the script will use `~/.trash` in your home directory
  - If `~/.trash` does not exist, it will be created automatically
  - If provided, it must already exist
  - If the last argument is an existing directory, it is treated as the destination
- `-d destination_directory`: (Optional) Explicitly sets the destination directory

### Examples

```bash
# Move a file to the default trash directory (~/.trash)
trash document.txt

# Move files to a specific location
trash document.txt photo.jpg ~/old/

# Move a directory to a specific location
trash project_folder ~/archived/

# Move files to a specific location using -d
trash document.txt photo.jpg -d ~/old/

# Move a directory to the default trash directory (~/.trash)
trash project_folder

# Move files whose names look like options by prefixing the path
trash ./-h
trash ./--help
trash ./-d /some/destination

# Show the current version
trash --version
```

## Behavior

- If the destination already contains an item with the same name:
  - For files: Adds a numerical suffix before the extension (e.g., document-2.txt)
  - For directories: Adds a numerical suffix to the directory name (e.g., project_folder-2)
- The script will increment the suffix (2, 3, 4, etc.) until it finds an available name
- Symlinks are moved as symlinks
- The script refuses to move a directory into itself or one of its subdirectories
- Sources that do not exist cause a non-zero exit
- If some sources move successfully and others fail, the script still exits non-zero

## Exit Codes

- 0: Success
- 1: Invalid arguments, move failures, or mixed-success runs with at least one failure
