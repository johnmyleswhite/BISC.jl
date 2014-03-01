function parse(s::String; as::Symbol = :brainfuck)
	parsers = [
		:ook => parseook,
		:brainfuck => parsebrainfuck,
	]
	return parsers[as](s)
end
