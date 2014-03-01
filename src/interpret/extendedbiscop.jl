function printbeforeop(
    op::ExtendedBISCOp,
    memory::Vector{Uint8},
    ptr::Integer
)
    @printf(
        STDERR,
        "\n---\nBefore executing '(%d, %d)': (%s, %d)\n",
        op.code,
        op.operand,
        repr(memory),
        ptr
    )
    return
end

function printafterop(
    op::ExtendedBISCOp,
    memory::Vector{Uint8},
    ptr::Integer
)
    @printf(
        STDERR,
        "After executing '(%d, %d)': (%s, %d)\n---\n\n",
        op.code,
        op.operand,
        repr(memory),
        ptr
    )
    return
end

function interpret(
    ops::Vector{ExtendedBISCOp};
    debug::Bool = false,
    io_in::IO = STDIN,
    io_out::IO = STDOUT,
    as::Symbol = :brainfuck
)
    ptr = 1
    memory = zeros(Uint8, 1)
    opindex = 1

    n_ops = length(ops)

    while opindex <= n_ops
        op = ops[opindex]

        if debug
            printbeforeop(op, memory, ptr)
        end

        # EOP1: Move the memory pointer to the specified byte of memory.
        #       Enlarge the available memory if needed.
        if op.code == 0x01
            ptr += op.operand
            if ptr > length(memory)
                for i in 1:op.operand
                    push!(memory, 0x00)
                end
            end
            opindex += 1

        # EOP2: Add to the byte of memory pointed at by the memory pointer.
        elseif op.code == 0x02
            memory[ptr] += op.operand
            opindex += 1

        # EOP3: Read a character from STDIN and put its ASCII value into the
        #       byte of memory pointed at by the memory pointer.
        elseif op.code == 0x03
            memory[ptr] = read(io_in, Uint8)
            opindex += 1

        # EOP6: Print the character with ASCII value equal to the value in the
        #       byte of memory pointed at by the memory pointer.
        elseif op.code == 0x04
            if debug
                @printf(STDERR, "Printing '%s'\n", char(memory[ptr]))
            end
            print(io_out, char(memory[ptr]))
            opindex += 1

        # EOP7: Forward GOTO if the byte of memory pointed to by the memory
        #       pointer is 0.
        elseif op.code == 0x05
            if memory[ptr] == 0x00
                opindex = op.operand
            else
                opindex += 1
            end

        # EOP8: Backward GOTO if the byte of memory pointed to by the memory
        #       pointer is not 0.
        elseif op.code == 0x06
            if memory[ptr] != 0x00
                opindex = op.operand
            else
                opindex += 1
            end
        end

        if debug
            printafterop(op, memory, ptr)
        end
    end

    return
end
