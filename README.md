# FilePicker

[![Build Status](https://github.com/joshday/FilePicker.jl/actions/workflows/CI.yml/badge.svg?branch=main)](https://github.com/joshday/FilePicker.jl/actions/workflows/CI.yml?query=branch%3Amain)


**A simple zero-dependency file picker for Julia.**

This package relies on native file pickers on each platform (mac, windows, linux).

## Usage:

```julia
using FilePicker

filepicker()  # single file

filepicker(true)  # multiple files

dirpicker()  # directory
```
