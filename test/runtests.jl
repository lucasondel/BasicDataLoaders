
using BasicDataLoaders
using Test

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

@testset "Data loaders" begin
    @testset "VectorDataLoader" begin
        obj = Float32[i for i in 1:10]

        dl = VectorDataLoader(obj, batchsize = 1)
        @test typeof(dl) == VectorDataLoader{Array{Float32, 1}}
        @test_throws ArgumentError VectorDataLoader(obj, batchsize = 0)
        @test_throws ArgumentError VectorDataLoader(obj, batchsize = -1)
        @test_throws ArgumentError VectorDataLoader([], batchsize = 1)

        dl = VectorDataLoader(obj, batchsize = 3)
        @test length(dl) == 4
        @test all(dl[1] .== [1, 2, 3])
        @test all(dl[2] .== [4, 5, 6])
        @test all(dl[3] .== [7, 8, 9])
        @test all(dl[4] .== [10])
        @test all(dl[1] .== dl[begin])
        @test all(dl[4] .== dl[end])

        dl2 = VectorDataLoader(obj, batchsize = 3, preprocess = x -> 2 .* x)
        for (i, batch) in enumerate(dl2)
            @test all((2 .* dl[i]) .== dl2[i])
        end
    end

    @testset "MatrixDataLoader" begin
        obj = Float32[2*(j-1) + i for i in 1:2, j in 1:4]

        dl = MatrixDataLoader(obj, batchsize = 1)
        @test typeof(dl) == MatrixDataLoader{Array{Float32, 2}}
        @test_throws ArgumentError MatrixDataLoader(obj, batchsize = 0)
        @test_throws ArgumentError MatrixDataLoader(obj, batchsize = -1)
        @test_throws ArgumentError MatrixDataLoader(Array{Float64}(undef, 1, 0), batchsize = 1)
        @test_throws ArgumentError MatrixDataLoader(Array{Float64}(undef, 0, 1), batchsize = 1)

        dl = MatrixDataLoader(obj, batchsize = 3)
        @test length(dl) == 2
        @test all(dl[1] .== [1 3 5; 2 4 6])
        @test all(dl[2] .== [7; 8])
        @test all(dl[1] .== dl[begin])
        @test all(dl[2] .== dl[end])

        dl2 = MatrixDataLoader(obj, batchsize = 3, preprocess = x -> 2 * x)
        for (batch, batch2) in zip(dl, dl2)
            @test all((2 * batch) .== batch2)
        end
    end
end

