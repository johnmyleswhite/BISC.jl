module BISC
    include("biscop.jl")
    include("extendedbiscop.jl")

    include("interpret/biscop.jl")
    include("interpret/extendedbiscop.jl")

    include("translate.jl")

    include("parse/brainfuck.jl")
    include("parse/ooktoken.jl")
    include("parse/ook.jl")
    include("parse.jl")

    include("optimize.jl")
end
