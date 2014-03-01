macro check(i, s, chr, linenumber, chrnumber, validvalues)
    i = esc(i)
    s = esc(s)
    chr = esc(chr)
    linenumber = esc(linenumber)
    chrnumber = esc(chrnumber)
    validvalues = esc(validvalues)

    return quote
        $i = nextind($s, $i)
        if $i <= endof($s)
            $chr = $s[i]
            $chrnumber += 1
        else
            msg = @sprintf(
                "Premature end of input at line %d, character %d",
                $linenumber,
                $chrnumber
            )
            throw(ArgumentError(msg))
        end
        if !(chr in $validvalues)
            msg = @sprintf(
                "Invalid token found at line %d, character %d",
                $linenumber,
                $chrnumber
            )
            throw(ArgumentError(msg))
        end
    end
end

function nexttoken(
    s::ByteString,
    i::Integer,
    linenumber::Integer,
    chrnumber::Integer
)
    while i <= endof(s)
        chr = s[i]
        chrnumber += 1

        while chr != 'O'
            if chr == '\n'
                linenumber += 1
                chrnumber = 0
            end
            i = nextind(s, i)
            if i <= endof(s)
                chr = s[i]
                chrnumber += 1
            else
                return NULL, i, linenumber, chrnumber
            end
        end

        @check(i, s, chr, linenumber, chrnumber, ['o'])
        @check(i, s, chr, linenumber, chrnumber, ['k'])
        @check(i, s, chr, linenumber, chrnumber, ['.', '?', '!'])

        if chr == '.'
            return PERIOD, i, linenumber, chrnumber
        elseif chr == '?'
            return QUESTION, i, linenumber, chrnumber
        elseif chr == '!'
            return EXCLAMATION, i, linenumber, chrnumber
        end

        i = nextind(s, i)
    end

    return NULL, i, linenumber, chrnumber
end

function getop(token1::OokToken, token2::OokToken)
    if token1 == PERIOD
        if token2 == PERIOD
            return OP3
        elseif token2 == QUESTION
            return OP1
        elseif token2 == EXCLAMATION
            return OP5
        end
    elseif token1 == QUESTION
        if token2 == PERIOD
            return OP2
        elseif token2 == QUESTION
            throw(ArgumentError(@sprintf("Invalid token pair: Ook? Ook?")))
        elseif token2 == EXCLAMATION
            return OP8
        end
    elseif token1 == EXCLAMATION
        if token2 == PERIOD
            return OP6
        elseif token2 == QUESTION
            return OP7
        elseif token2 == EXCLAMATION
            return OP4
        end
    end
end

function parseook(s::ByteString)
    i = nextind(s, 0)
    linenumber, chrnumber = 1, 0

    ops = Array(BISCOp, 0)

    while i <= endof(s)
        token1, i, linenumber, chrnumber = nexttoken(
            s,
            i,
            linenumber,
            chrnumber
        )
        if token1 == NULL
            return ops
        end

        token2, i, linenumber, chrnumber = nexttoken(
            s,
            i,
            linenumber,
            chrnumber
        )
        if token2 == NULL
            msg = "At least one Ook token is missing from input"
            throw(ArgumentError(msg))
        end

        push!(ops, getop(token1, token2))
    end

    return ops
end
