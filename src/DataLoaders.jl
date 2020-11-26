# DataLoaders - Basic data loaders for training machine learning
# models
#
# Lucas Ondel 2020

module DataLoaders

using BSON

#######################################################################
# Basic input for loading / saving data, models, ...

export load
export save

include("io.jl")

#######################################################################
# Abstract data loader

export AbstractDataLoader

"""
    abstract type AbstractDataLoader end

Base type for all the data loaders.
"""
abstract type AbstractDataLoader{T} end

# Subtypes should implement the Iteration and Indexing interfaces

#######################################################################
# Concrete data loaders

export MatrixDataLoader
export VectorDataLoader

include("dataloaders.jl")

end
