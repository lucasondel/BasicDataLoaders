var documenterSearchIndex = {"docs":
[{"location":"#BasicDataLoaders","page":"BasicDataLoaders","title":"BasicDataLoaders","text":"","category":"section"},{"location":"","page":"BasicDataLoaders","title":"BasicDataLoaders","text":"Julia package providing a simple data loader to train machine learning systems.","category":"page"},{"location":"","page":"BasicDataLoaders","title":"BasicDataLoaders","text":"The source code of the project is available on github.","category":"page"},{"location":"#Installation","page":"BasicDataLoaders","title":"Installation","text":"","category":"section"},{"location":"","page":"BasicDataLoaders","title":"BasicDataLoaders","text":"The package can be installed with the Julia package manager. From the Julia REPL, type ] to enter the Pkg REPL mode and run:","category":"page"},{"location":"","page":"BasicDataLoaders","title":"BasicDataLoaders","text":"pkg> add BasicDataLoaders","category":"page"},{"location":"#Usage","page":"BasicDataLoaders","title":"Usage","text":"","category":"section"},{"location":"","page":"BasicDataLoaders","title":"BasicDataLoaders","text":"This package provides a simple object DataLoader which reads its data from a sequence-like object.","category":"page"},{"location":"","page":"BasicDataLoaders","title":"BasicDataLoaders","text":"A data loader is constructed as follows:","category":"page"},{"location":"","page":"BasicDataLoaders","title":"BasicDataLoaders","text":"dl = DataLoader(data[, batchsize = 1, preprocess = (x) -> x])","category":"page"},{"location":"","page":"BasicDataLoaders","title":"BasicDataLoaders","text":"The user can provide a preprocessing function with the keyword argument preprocess. By default, the pre-processing function is simply identity. Importantly, the data loader implements the iterating and indexing interfaces, allowing it to be used in parallel loops with Distributed.","category":"page"},{"location":"","page":"BasicDataLoaders","title":"BasicDataLoaders","text":"Here is a complete example:","category":"page"},{"location":"","page":"BasicDataLoaders","title":"BasicDataLoaders","text":"julia> using BasicDataLoaders\n\njulia> data = Array(1:10)\n10-element Array{Int64,1}:\n  1\n  2\n  3\n  4\n  5\n  6\n  7\n  8\n  9\n 10\n\njulia> dl = DataLoader(data, batchsize = 3)\nDataLoader{Array{Int64,1}}\n  data: Array{Int64,1}\n  batchsize: 3\n\njulia> for batch in dl println(batch) end\n[1, 2, 3]\n[4, 5, 6]\n[7, 8, 9]\n[10]","category":"page"},{"location":"","page":"BasicDataLoaders","title":"BasicDataLoaders","text":"Because it is very common for data loaders to load data from disk, the package also provide two convenience functions to  easily read and write files:","category":"page"},{"location":"","page":"BasicDataLoaders","title":"BasicDataLoaders","text":"save(\"path/to/file[.bson]\", obj)\nobj = load(\"path/to/file[.bson]\")","category":"page"},{"location":"","page":"BasicDataLoaders","title":"BasicDataLoaders","text":"The files are stored in the BSON format using the BSON julia package. Note that both save or load will add the \".bson\" extension to the path if it doesn't have it already.","category":"page"}]
}