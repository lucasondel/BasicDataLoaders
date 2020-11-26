# DataLoaders [![Actions Status: test](https://github.com/iondel/DataLoaders/workflows/test/badge.svg)](https://github.com/iondel/DataLoaders/actions?query=workflow%3Atest)

Julia package providing simple data loaders to train machine learning
systems.

# Usage

Ths package provide two types of data loader: `VectorDataLoader`
and `MatrixDataLoader`. A `VectorDataLoader` reads its data from a
`Vector` object whereas a `MatrixDataLoader` reads its data from
a `Matrix` object. Note that the `MatrixDataLoader` always iterate
over the second dimension of the matrix.

The data loaders are constructed as follows:
```julia
vdl = VectorDataLoader(vectordata[, batchsize = 1, preprocess = (x) -> x])
mdl = MatrixDataLoader(matrixdata[, batchsize = 1, preprocess = (x) -> x])
```

Complete example:
```julia
julia> using DataLoaders

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

julia> dl = VectorDataLoader(data, batchsize = 3)
VectorDataLoader{Array{Int64,1}}
  data: Array{Int64,1}
  batchsize: 3

julia> for batch in dl println(batch) end
[1, 2, 3]
[4, 5, 6]
[7, 8, 9]
[10]

julia> data = [1 2; 3 4; 5 6]
3×2 Array{Int64,2}:
 1  2
 3  4
 5  6

julia> dl = MatrixDataLoader(data, batchsize = 1, preprocess = x -> 10*x)
MatrixDataLoader{Array{Int64,2}}
  data: Array{Int64,2}
  batchsize: 1

julia> for batch in dl println(batch) end
[10; 30; 50]
[20; 40; 60]
```

Because it is very common for data loaders to load data from disk, the package also provide two convience functions to  easily read and write files:
```julia
save("path/to/file[.bson]", obj)
obj = load("path/to/file[.bson]")
```
The files are stored in the [BSON format](http://bsonspec.org/) using the [BSON julia package](https://github.com/JuliaIO/BSON.jl). Note that both `save` or `load` will add the ".bson" extension to the path if it doesn't have it already.
