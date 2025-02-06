# FilePicker

[![Build Status](https://github.com/joshday/FilePicker.jl/actions/workflows/CI.yml/badge.svg?branch=main)](https://github.com/joshday/FilePicker.jl/actions/workflows/CI.yml?query=branch%3Amain)


**A lightweight file picker for Julia.**

This package relies on different built-in[^1] dependencies depending on the platform:

1. Mac: `osascript`
2. Windows: `powershell`
3. Linux: `zenity`, `kdialog`, or `yad`.

[^1]: `osascript` and `powershell` are part of macOS and Windows, respectively. `zenity`, `kdialog`, and `yad` are not necessarily included in a Linux distribution and may need to be installed separately.

## Usage:

```julia
using FilePicker

file()  # single file

files(true)  # multiple files

dir()  # directory

dirs()  # multiple directories
```
