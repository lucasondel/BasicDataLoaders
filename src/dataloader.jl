# DataLoaders - Concrete subtypes of AbstractDataLoader
#
# Lucas Ondel 2020

function Base.show(io::IO, dl::AbstractDataLoader)
    println(io, "$(typeof(dl))")
    println(io, "  data: $(typeof(dl.data))")
    print(io, "  batchsize: $(dl.batchsize)")
end

_index(i, batchsize) = (i-1) * batchsize + 1

#######################################################################
# DataLoader

"""
    struct DataLoader
        data
        batchsize
    end

# Constructor

    DataLoader(data[, batchsize = 1, preprocess = x -> x])

where `data` is a sequence of elements to iterate over, `batchsize` is
the size of each batch and `preprocess` is a user-defined function to
apply on each batch. By default, `preprocess` is simpy the identity
function.

!!! warning

    When iterating, the final batch may have a size smaller
    than `batchsize`.

"""
struct DataLoader{T<:AbstractVector}  <: AbstractDataLoader{T}
    data::T
    batchsize::UInt
    f::Function

    function DataLoader(data::AbstractVector; batchsize = 1, preprocess = x -> x)
        length(data) > 0 || throw(ArgumentError("cannot create a DataLoader from an empty collection"))
        batchsize >= 1 || throw(ArgumentError("`batchsize = $batchsize` should greater or equal to 1"))
        new{typeof(data)}(data, batchsize, preprocess)
    end
end

function Base.iterate(dl::DataLoader, state = 1)
    if state > size(dl.data, 1)
        return nothing
    end
    offset = min(state+dl.batchsize-1, size(dl.data,1))
    dl.f(dl.data[state:offset]), offset+1
end
Base.length(dl::DataLoader) = UInt(ceil(size(dl.data, 1)/dl.batchsize))
Base.eltype(dl::DataLoader) = eltype(dl.data)

function Base.getindex(dl::DataLoader, i)
    1 <= i <= length(dl) || throw(BoundsError(dl, i))
    start = _index(i, dl.batchsize)
    offset = min(start + dl.batchsize - 1, size(dl.data,1))
    dl.f(dl.data[start:offset])
end

function Base.getindex(dl::DataLoader, ur::UnitRange)
    1 <= ur.start <= length(dl) || throw(BoundsError(dl, ur.start))
    1 <= ur.stop <= length(dl) || throw(BoundsError(dl, ur.stop))

    N = size(dl.data, 1)
    start = _index(ur.start, dl.batchsize)
    offset = min(_index(ur.stop, dl.batchsize) + dl.batchsize - 1, N)
    DataLoader(dl.data[start:offset], batchsize = dl.batchsize, preprocess = dl.f)
end

Base.firstindex(dl::DataLoader) = 1
Base.lastindex(dl::DataLoader) = length(dl)

