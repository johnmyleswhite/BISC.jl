module BISC
	include("biscop.jl")
	include("interpret.jl")
	include("translate.jl")

	include("parse/brainfuck.jl")
	include("parse/ooktoken.jl")
	include("parse/ook.jl")
	include("parse.jl")
end
