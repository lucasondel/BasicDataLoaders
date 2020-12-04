# BasicDataLoaders

Julia package providing a simple data loader to train machine learning
systems.

The source code of the project is available on [github](https://github.com/lucasondel/BasicDataLoaders).

## Installation

The package can be installed with the Julia package manager. From the
Julia REPL, type `]` to enter the Pkg REPL mode and run:
```julia
pkg> add BasicDataLoaders
```

## Usage

This package provides a simple object `DataLoader` which
reads its data from a sequence-like object.

A data loader is constructed as follows:
```julia
dl = DataLoader(data[, batchsize = 1, preprocess = (x) -> x])
```
The user can provide a preprocessing function with the keyword argument
`preprocess`. By default, the pre-processing function is simply
identity. Importantly, the data loader implements the iterating and
indexing interfaces, allowing it to be used in parallel loops with
`Distributed`.

Here is a complete example:
```jldoctest
julia> using BasicDataLoaders

julia> data = Array(1:10)
10-element Array{Int64,1}:
  1
  2
  3
  4
  5
  6
  7
  8
  9
 10

julia> dl = DataLoader(data, batchsize = 3)
DataLoader{Array{Int64,1}}
  data: Array{Int64,1}
  batchsize: 3

julia> for batch in dl println(batch) end
[1, 2, 3]
[4, 5, 6]
[7, 8, 9]
[10]
```

Because it is very common for data loaders to load data from disk, the package also provide two convenience functions to  easily read and write files:
```julia
save("path/to/file[.bson]", obj)
obj = load("path/to/file[.bson]")
```
The files are stored in the [BSON format](http://bsonspec.org/) using the [BSON julia package](https://github.com/JuliaIO/BSON.jl). Note that both `save` or `load` will add the ".bson" extension to the path if it doesn't have it already.
