immutable OokToken
    code::Uint8
    function OokToken(code::Integer)
        if !(oftype(code, 1) <= code <= oftype(code, 3))
            throw(ArgumentError("Invalid OokToken"))
        else
            new(code)
        end
    end
end

const PERIOD = OokToken(0x01)
const QUESTION = OokToken(0x02)
const EXCLAMATION = OokToken(0x03)
