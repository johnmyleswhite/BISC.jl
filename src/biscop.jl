immutable BISCOp
	code::Uint8
	function BISCOp(code::Integer)
		if !(oftype(code, 1) <= code <= oftype(code, 8))
			throw(ArgumentError("Invalid op code"))
		else
			new(uint8(code))
		end
	end
end

const OP1 = BISCOp(0x01)
const OP2 = BISCOp(0x02)
const OP3 = BISCOp(0x03)
const OP4 = BISCOp(0x04)
const OP5 = BISCOp(0x05)
const OP6 = BISCOp(0x06)
const OP7 = BISCOp(0x07)
const OP8 = BISCOp(0x08)

function Base.string(op::BISCOp, as::Symbol)
    strings = [
        :brainfuck => [
            ">",
            "<",
            "+",
            "-",
            ".",
            ",",
            "[",
            "]",
        ],
        :ook => [
            "Ook. Ook?",
            "Ook? Ook.",
            "Ook. Ook.",
            "Ook! Ook!",
            "Ook. Ook!",
            "Ook! Ook.",
            "Ook! Ook?",
            "Ook? Ook!",   
        ],
        :c => [
			"++ptr;",
			"--ptr;",
			"++*ptr;",
			"--*ptr;",
			"*ptr = getchar();",
			"putchar(*ptr);",
			"while (*ptr) {",
			"}",
		],
        :julia => [
			"ptr += 1",
			"ptr -= 1",
			"memory[ptr] += 1",
			"memory[ptr] -= 1",
			"memory[ptr] = read(io_in, Uint8)",
			"print(io_out, char(memory[ptr]))",
			"while (memory[ptr] != 0)",
			"end",
		],
    ]
    return strings[as][op.code]
end
