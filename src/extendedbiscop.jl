# OP1: memory[ptr] += operand
# OP2: ptr += operand
# OP3: read byte
# OP4: write byte
# OP5: if memory[ptr] == 0x00
#  opindex = operand
# else
#  opindex += 1
# end
# OP6: if memory[ptr] != 0x00
#  opindex = operand
# else
#  opindex += 1
# end

immutable ExtendedBISCOp
    code::Uint8
    operand::Int
    function ExtendedBISCOp(code::Integer, operand::Integer = 0)
        if !(oftype(code, 1) <= code <= oftype(code, 6))
            throw(ArgumentError("Invalid op code"))
        else
            new(uint8(code), int(operand))
        end
    end
end
