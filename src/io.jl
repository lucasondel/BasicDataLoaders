# DataLoaders - Basic input/output operations
#
# Lucas Ondel 2020

"""
    save(path, obj)

Write `obj` to file `path`. The intermediate directories are created
if they do not exists. If `path` does not end with the extension
".bson", the extension is appended to the output path. The function
returns the type of the object saved. See also [`load`](@ref).
"""
function save(path, obj)
    if ! endswith(path, ".bson")
        path *= ".bson"
    end
    mkpath(dirname(path))
    T = typeof(obj)
    bson(path, data = obj, type = T)
    T
end

"""
    load(path)

Load a julia object saved in `path`. See also [`save`](@ref). If path
does not end with thex extension ".bson", the extension is appended to
output path.
"""
function load(path)
    if ! endswith(path, ".bson")
        path *= ".bson"
    end
    dict = BSON.load(path)
    convert(dict[:type], dict[:data])
end

