function parse(s::String; as::Symbol = :ook)
	parsers = [
		:ook => parseook,
		:brainfuck => parsebrainfuck,
	]
	return parsers[as](s)
end
