function printbeforeop(
    op::BISCOp,
    memory::Vector{Uint8},
    ptr::Integer,
    as::Symbol
)
    @printf(
        STDERR,
        "\n---\nBefore executing '%s': (%s, %d)\n",
        string(op, as),
        repr(memory),
        ptr
    )
    return
end

function printafterop(
    op::BISCOp,
    memory::Vector{Uint8},
    ptr::Integer,
    as::Symbol
)
    @printf(
        STDERR,
        "After executing '%s': (%s, %d)\n---\n\n",
        string(op, as),
        repr(memory),
        ptr
    )
    return
end

function interpret(
    ops::Vector{BISCOp};
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
            printbeforeop(op, memory, ptr, as)
        end

        # OP1: Move the memory pointer to the next byte of memory.
        #      Enlarge the available memory if needed.
        if op == OP1
            ptr += 1
            if ptr > length(memory)
                push!(memory, 0x00)
            end
            opindex += 1

        # OP2: Move the memory pointer to the previous byte of memory.
        elseif op == OP2
            ptr -= 1
            opindex += 1

        # OP3: Increment the byte of memory pointed at by the memory pointer.
        elseif op == OP3
            memory[ptr] += 1
            opindex += 1

        # OP4: Decrement the byte of memory pointed at by the memory pointer.
        elseif op == OP4
            memory[ptr] -= 1
            opindex += 1

        # OP5: Read a character from STDIN and put its ASCII value into the
        #      byte of memory pointed at by the memory pointer.
        elseif op == OP5
            memory[ptr] = read(io_in, Uint8)
            opindex += 1

        # OP6: Print the character with ASCII value equal to the value in the
        #      byte of memory pointed at by the memory pointer.
        elseif op == OP6
            if debug
                @printf(STDERR, "Printing '%s'\n", char(memory[ptr]))
            end
            print(io_out, char(memory[ptr]))
            opindex += 1

        # OP7: Move to the command following the matching OP8 if the value in
        #      the byte of memory pointed at by the memory pointer is zero.
        #      Note that OP7 and OP8 commands nest like pairs of parentheses,
        #      and matching pairs are defined in the same way as for
        #      parentheses.
        elseif op == OP7
            if memory[ptr] == 0x00
                level = 0
                opindex += 1
                finished = false
                while !finished && opindex <= n_ops
                    if ops[opindex] == OP7
                        level += 1
                        opindex += 1
                    elseif ops[opindex] == OP8
                        if level == 0
                            opindex += 1
                            finished = true
                        else
                            level -= 1
                            opindex += 1
                        end
                    else
                        opindex += 1
                    end
                end
            else
                opindex += 1
            end

        # OP8: Move to the command following the matching OP7 if the value in
        #      the byte of memory pointed at by the memory pointer is non-zero.
        #      This involves traversing the ops array backwards.
        elseif op == OP8
            if memory[ptr] != 0x00
                level = 0
                opindex -= 1
                finished = false
                while !finished && opindex >= 1
                    if ops[opindex] == OP8
                        level += 1
                        opindex -= 1
                    elseif ops[opindex] == OP7
                        if level == 0
                            opindex += 1
                            finished = true
                        else
                            level -= 1
                            opindex -= 1
                        end
                    else
                        opindex -= 1
                    end
                end
            else
                opindex += 1
            end
        end

        if debug
            printafterop(op, memory, ptr, as)
        end
    end

    return
end
