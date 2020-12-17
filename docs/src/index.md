# BasicDataLoaders

Julia package providing a simple data loader to train machine learning
systems.

The source code of the project is available on [github](https://github.com/lucasondel/BasicDataLoaders).

## Authors

Lucas Ondel, Brno University of Technology, 2020

## Installation

The package can be installed with the Julia package manager. From the
Julia REPL, type `]` to enter the Pkg REPL mode and run:
```julia
pkg> add BasicDataLoaders
```

## API

The package provide a simple data loader object:
```@docs
DataLoader
```

!!! note

    `DataLoder` supports the iterating and indexing interface and,
    consequently, it can be used in [distributed for
    loops](https://docs.julialang.org/en/v1/manual/distributed-computing/).

Because it is very common for data loaders to load data from disk, the
package also provides two convenience functions to  easily read and
write files:
```@docs
save
load
```

## Examples

Here is a complete example that simply print the batches:
```jldoctest
julia> using BasicDataLoaders

julia> dl = DataLoader(1:10, batchsize = 3)
DataLoader{UnitRange{Int64}}
  data: UnitRange{Int64}
  batchsize: 3

julia> for batch in dl println(batch) end
[1, 2, 3]
[4, 5, 6]
[7, 8, 9]
[10]
```

Here is another example that computes the sum of all even numbers
between 2 and 200 included:
```jldoctest
julia> using BasicDataLoaders

julia> dl = DataLoader(1:100, batchsize = 10, preprocess = x -> 2*x)
DataLoader{UnitRange{Int64}}
  data: UnitRange{Int64}
  batchsize: 10

julia> sum(sum(batch) for batch in dl)
10100
```

Finally, here is an example simulating loading data from files. In
practice, you can replace the printing function with the [`load`](@ref)
function.
```jldoctest
julia> using BasicDataLoaders

julia> files = ["file1.bson", "file2.bson", "file3.bson"]
3-element Array{String,1}:
 "file1.bson"
 "file2.bson"
 "file3.bson"

julia> dl = DataLoader(files, batchsize = 2, preprocess = x -> println("load and merge files $x"))
DataLoader{Array{String,1}}
  data: Array{String,1}
  batchsize: 2

julia> for batch in dl println("do something on this batch") end
load and merge files ["file1.bson", "file2.bson"]
do something on this batch
load and merge files ["file3.bson"]
do something on this batch
```

