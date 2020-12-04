# DataLoaders - Basic data loaders for training machine learning
# models
#
# Lucas Ondel 2020

module BasicDataLoaders

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

export DataLoader

include("dataloader.jl")

end
