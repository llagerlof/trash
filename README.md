# Trash Utility

A Bash script that safely moves files and directories to a destination folder without overwriting existing items.

## Purpose

This utility works similar to a "trash" or "safe move" operation, ensuring that when files or directories are moved to a destination, they will never overwrite existing items with the same name. Instead, the script automatically renames them by adding a numerical suffix.

## Features

- Moves both files and directories
- Handles name conflicts by adding numerical suffixes (2, 3, 4, etc.)
- Preserves file extensions when renaming
- Provides informative error messages

## Usage

```bash
./trash <source> <destination_directory>
```

### Parameters

- `source`: The file or directory you want to move
- `destination_directory`: The directory where you want to move the source

### Examples

```bash
# Move a file
./trash document.txt ~/Documents/

# Move a directory
./trash project_folder ~/Projects/
```

## Behavior

- If the destination already contains an item with the same name:
  - For files: Adds a numerical suffix before the extension (e.g., document-2.txt)
  - For directories: Adds a numerical suffix to the directory name (e.g., project_folder-2)
- The script will increment the suffix (2, 3, 4, etc.) until it finds an available name

## Exit Codes

- 0: Success
- 1: Invalid arguments or errors