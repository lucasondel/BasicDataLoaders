push!(LOAD_PATH, "../src/")

using Documenter
using BasicDataLoaders

makedocs(sitename="BasicDataLoaders Manual")

deploydocs(repo = "github.com/lucasondel/BasicDataLoaders.git")

