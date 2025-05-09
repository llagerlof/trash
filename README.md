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

## Usage

```bash
./trash <source> [destination_directory]
```

### Parameters

- `source`: The file or directory you want to move
- `destination_directory`: (Optional) The directory where you want to move the source
  - If not provided, the script will use `~/.trash` in your home directory
  - If `~/.trash` does not exist, it will be created automatically

### Examples

```bash
# Move a file to a specific location
./trash document.txt ~/old/

# Move a directory to a specific location
./trash project_folder ~/archived/

# Move a file to the default trash directory (~/.trash)
./trash document.txt

# Move a directory to the default trash directory (~/.trash)
./trash project_folder
```

## Behavior

- If the destination already contains an item with the same name:
  - For files: Adds a numerical suffix before the extension (e.g., document-2.txt)
  - For directories: Adds a numerical suffix to the directory name (e.g., project_folder-2)
- The script will increment the suffix (2, 3, 4, etc.) until it finds an available name

## Exit Codes

- 0: Success
- 1: Invalid arguments or errors