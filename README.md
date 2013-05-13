# Synopsis
Hugediff, an utility for computing differencies between huge textual files.
Somewhat like diff, but doesn't respect the line ordering.
Can be used with a huge directory listings for example.

## Requirements
* Ruby-1.9

## Usage:
ruby main.rb <file1> <file2>

Also you can specify a custom block length (number of lines for in-memory sorting)
by passing a PIECE_SIZE environment variable. The default is 200000.

## Structure
* main.rb - main module
* huge_diff.rb - implementation of a diff algorithm
* ext_sort.rb - implementation of an external sort algorithm
* ext_stream.rb - streams sourced from disk
* heap.rb - implementation of heap data structure

Source repository is located at https://github.com/akamaus/hugediff.git
