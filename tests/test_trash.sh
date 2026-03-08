#!/bin/bash
set -euo pipefail

trash_script="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)/trash"

fail() {
    echo "FAIL: $1" >&2
    exit 1
}

assert_file() {
    [ -f "$1" ] || fail "Expected file: $1"
}

assert_dir() {
    [ -d "$1" ] || fail "Expected directory: $1"
}

assert_symlink() {
    [ -L "$1" ] || fail "Expected symlink: $1"
}

workdir="$(mktemp -d)"
trap 'rm -rf "$workdir"' EXIT

# Version output
version_output="$($trash_script --version)"
[ "$version_output" = "Trash 1.5.0" ] || fail "Expected version output to be 'Trash 1.5.0'"

# File conflict with extension handling
src_dir="$workdir/src"
dest_dir="$workdir/dest"
mkdir -p "$src_dir" "$dest_dir"

echo "hello" > "$dest_dir/report.tar.gz"
echo "data" > "$src_dir/report.tar.gz"
"$trash_script" "$src_dir/report.tar.gz" "$dest_dir" >/dev/null
assert_file "$dest_dir/report.tar-2.gz"

# File conflict should continue escalating suffixes
echo "hello again" > "$dest_dir/report.tar-2.gz"
echo "data again" > "$src_dir/report.tar.gz"
"$trash_script" "$src_dir/report.tar.gz" "$dest_dir" >/dev/null
assert_file "$dest_dir/report.tar-3.gz"

# Dotfile conflict should preserve the leading dot
echo "original" > "$dest_dir/.bashrc"
echo "replacement" > "$src_dir/.bashrc"
"$trash_script" "$src_dir/.bashrc" "$dest_dir" >/dev/null
assert_file "$dest_dir/.bashrc-2"

# Directory conflict
mkdir -p "$src_dir/project"
mkdir -p "$dest_dir/project"
"$trash_script" "$src_dir/project" "$dest_dir" >/dev/null
assert_dir "$dest_dir/project-2"

# Symlink handling
ln -s "$dest_dir/project-2" "$src_dir/link"
"$trash_script" "$src_dir/link" "$dest_dir" >/dev/null
assert_symlink "$dest_dir/link"

# Symlink collisions should use the same suffix behavior
ln -s "$dest_dir/project" "$dest_dir/.env"
ln -s "$dest_dir/project-2" "$src_dir/.env"
"$trash_script" "$src_dir/.env" "$dest_dir" >/dev/null
assert_symlink "$dest_dir/.env-2"

# Multi-source with destination
echo "x" > "$src_dir/a.txt"
echo "y" > "$src_dir/b.txt"
"$trash_script" "$src_dir/a.txt" "$src_dir/b.txt" "$dest_dir" >/dev/null
assert_file "$dest_dir/a.txt"
assert_file "$dest_dir/b.txt"

# Single directory with no destination should use default trash
single_dir="$src_dir/single-dir"
mkdir -p "$single_dir"
HOME="$workdir/home" "$trash_script" "$single_dir" >/dev/null
assert_dir "$workdir/home/.trash/single-dir"

# Missing source should fail
if "$trash_script" "$src_dir/does-not-exist" "$dest_dir" >/dev/null 2>&1; then
    fail "Expected missing source to fail"
fi

# Symlink target missing (broken symlink) should still move as link
ln -s "$src_dir/missing-target" "$src_dir/broken"
"$trash_script" "$src_dir/broken" "$dest_dir" >/dev/null
assert_symlink "$dest_dir/broken"

# Self-move guard
mkdir -p "$src_dir/tree/sub"
if "$trash_script" "$src_dir/tree" "$src_dir/tree/sub" >/dev/null 2>&1; then
    fail "Expected self-move guard to fail"
fi

echo "OK"
