immutable OokToken
    code::Uint8
    function OokToken(code::Integer)
        if !(oftype(code, 0) <= code <= oftype(code, 3))
            throw(ArgumentError("Invalid OokToken"))
        else
            new(code)
        end
    end
end

const NULL = OokToken(0x00)
const PERIOD = OokToken(0x01)
const QUESTION = OokToken(0x02)
const EXCLAMATION = OokToken(0x03)
