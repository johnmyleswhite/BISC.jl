function parsebrainfuck(s::ByteString)
    const chrs =  ['>', '<', '+', '-', ',', '.', '[', ']']
    const chrs2ops = Dict(
        ['>', '<', '+', '-', ',', '.', '[', ']'],
        [OP1, OP2, OP3, OP4, OP5, OP6, OP7, OP8]
    )

    ops = Array(BISCOp, 0)

    i = nextind(s, 0)

    linenumber, chrnumber = 1, 0

    while i <= endof(s)
        chr = s[i]
        chrnumber += 1

        while !(chr in chrs)
            if chr == '\n'
                linenumber += 1
                chrnumber = 0
            end
            i = nextind(s, i)
            if i <= endof(s)
                chr = s[i]
                chrnumber += 1
            else
                return ops
            end
        end

        push!(ops, chrs2ops[chr])

        i = nextind(s, i)
    end

    return ops
end
