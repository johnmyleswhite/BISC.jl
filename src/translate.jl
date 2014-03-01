function indent(io::IO, level::Integer, tabwidth::Integer = 4)
    for i in 1:(tabwidth * level)
        print(io, ' ')
    end
end

function translate(
    ops::Vector{BISCOp};
    as::Symbol = :brainfuck,
    tabwidth::Integer = 4
)
    if as == :c
        level = 1
    else
        level = 0
    end

    io = IOBuffer()

    # Print intro initializing memory buffer and memory pointer
    if as == :c
        println(io, "#include <stdio.h>")
        println(io, "int main(int argc, const char* argv[])")
        println(io, "{")
        indent(io, level, tabwidth)
        println(io, "char memory[30000];")
        indent(io, level, tabwidth)
        println(io, "char *ptr = memory;")
    elseif as == :julia
        println(io, "memory = zeros(Uint8, 30_000)")
        println(io, "ptr = 1\n")
    end

    for op in ops
        if op == OP8
            level -= 1
        end
        indent(io, level, tabwidth)
        println(io, string(op, as))
        if op == OP7
            level += 1
        end
    end

    # Print outro freeing memory buffer and memory pointer
    if as == :c
        println(io, "}")
    end

    return takebuf_string(io)
end
