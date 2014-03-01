function pass1(ops::Vector{BISCOp})
    extops= Array(ExtendedBISCOp, 0)

    opindex = 1

    n_ops = length(ops)

    while opindex <= n_ops
        # Collapse sequence of form (OP1|OP2)+ into single instruction
        if ops[opindex] == OP1 || ops[opindex] == OP2
            operand = 0
            while opindex <= n_ops &&
                (ops[opindex] == OP1 || ops[opindex] == OP2)
                if ops[opindex] == OP1
                    operand += 1
                else
                    operand -= 1
                end
                opindex += 1
            end
            push!(extops, ExtendedBISCOp(0x01, operand))

        # Collapse sequence of form (OP3|OP4)+ into single instruction
        elseif ops[opindex] == OP3 || ops[opindex] == OP4
            operand = 0
            while opindex <= n_ops &&
                (ops[opindex] == OP3 || ops[opindex] == OP4)
                if ops[opindex] == OP3
                    operand += 1
                else
                    operand -= 1
                end
                opindex += 1
            end
            push!(extops, ExtendedBISCOp(0x02, operand))

        # Translate OP5 into EOP3
        elseif ops[opindex] == OP5
            push!(extops, ExtendedBISCOp(0x03, 0))
            opindex += 1

        # Translate OP6 into EOP4
        elseif ops[opindex] == OP6
            push!(extops, ExtendedBISCOp(0x04, 0))
            opindex += 1

        # Translate OP7 into EOP5
        elseif ops[opindex] == OP7
            push!(extops, ExtendedBISCOp(0x05, 0))
            opindex += 1

        # Translate OP8 into EOP6
        elseif ops[opindex] == OP8
            push!(extops, ExtendedBISCOp(0x06, 0))
            opindex += 1
        end
    end

    return extops
end

function pass2!(ops::Vector{ExtendedBISCOp})
    opindex = 1

    n_ops = length(ops)

    while opindex <= n_ops
        # Replace EOP5 with forward GOTO
        if ops[opindex].code == 0x05
            level = 0
            finished = false
            gotoindex = opindex + 1
            while !finished && gotoindex <= n_ops
                if ops[gotoindex].code == 0x05
                    level += 1
                    gotoindex += 1
                elseif ops[gotoindex].code == 0x06
                    if level == 0
                        finished = true
                        gotoindex += 1
                    else
                        level -= 1
                        gotoindex += 1
                    end
                else
                    gotoindex += 1
                end
            end
            ops[opindex] = ExtendedBISCOp(0x05, gotoindex)
            opindex += 1

        # Replace EOP5 with forward GOTO
        elseif ops[opindex].code == 0x06
            level = 0
            finished = false
            gotoindex = opindex - 1
            while !finished && gotoindex <= n_ops
                if ops[gotoindex].code == 0x06
                    level += 1
                    gotoindex -= 1
                elseif ops[gotoindex].code == 0x05
                    if level == 0
                        finished = true
                        gotoindex += 1
                    else
                        level -= 1
                        gotoindex -= 1
                    end
                else
                    gotoindex -= 1
                end
            end
            ops[opindex] = ExtendedBISCOp(0x06, gotoindex)
            opindex += 1

        else
            opindex += 1
        end
    end

    return
end

function optimize(ops::Vector{BISCOp})
    extops = pass1(ops)
    pass2!(extops)
    return extops
end
