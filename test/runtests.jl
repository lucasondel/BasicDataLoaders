
using BasicDataLoaders
using Distributed
using Documenter
using Test

doctest(BasicDataLoaders)

@testset "input/output operations" begin
    obj = Float32[1, 2, 3]
    dir = mktempdir(cleanup = true)
    path = joinpath(dir, "test")

    T = save(path*".bson", obj)
    @test T == Array{Float32, 1}
    @test isfile(path*".bson")

    lobj = load(path*".bson")
    @test typeof(lobj) == Array{Float32, 1}
    @test all(lobj .≈ obj)

    save(path, obj)
    @test ! isfile(path)
    @test isfile(path*".bson")

    lobj = load(path*".bson")
    @test typeof(lobj) == Array{Float32, 1}
    @test all(lobj .≈ obj)
end

@testset "Data loader" begin
    obj = Float32[i for i in 1:10]

    dl = DataLoader(obj, batchsize = 1)
    @test typeof(dl) == DataLoader{Array{Float32, 1}}
    @test_throws ArgumentError DataLoader(obj, batchsize = 0)
    @test_throws ArgumentError DataLoader(obj, batchsize = -1)
    @test_throws ArgumentError DataLoader([], batchsize = 1)

    dl = DataLoader(obj, batchsize = 3)
    @test length(dl) == 4
    @test all(dl[1] .== [1, 2, 3])
    @test all(dl[2] .== [4, 5, 6])
    @test all(dl[3] .== [7, 8, 9])
    @test all(dl[4] .== [10])
    @test all(dl[1] .== dl[begin])
    @test all(dl[4] .== dl[end])

    sobj = [[1, 1], [2, 2], [3, 3]]
    v = [3, 4]
    sdl = DataLoader(obj, batchsize = 2)
    sdl2 = DataLoader(obj, batchsize = 2, preprocess_element = x -> v .* x)
    for (i, batch) in enumerate(sdl2)
        @test all((sdl2[i]) .== [v .* a for a in sdl[i]])
    end

    dl2 = DataLoader(obj, batchsize = 3, preprocess = x -> 2 .* x)
    for (i, batch) in enumerate(dl2)
        @test all((2 .* dl[i]) .== dl2[i])
    end

    N = 10
    dl = DataLoader(1:10, batchsize = 3, preprocess = x -> 2*x)
    addprocs(2)
    @everywhere using BasicDataLoaders
    res = @distributed (+) for x in dl
        sum(x)
    end
    @test res == N*(N+1)
end

