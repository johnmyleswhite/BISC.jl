module TestInterpret
    using Base.Test
    using BISC

    ops = [BISC.OP7, BISC.OP3, BISC.OP3, BISC.OP8]
    BISC.interpret(ops)

    type MyIO <: IO
        bytes::Vector{Uint8}
    end
    Base.write(io::MyIO, val::Uint8) = push!(io.bytes, val)
    Base.read(io::MyIO, ::Type{Uint8}) = shift!(io.bytes)

    text = readall(
        Pkg.dir(
            "BISC",
            "test",
            "programs",
            "brainfuck",
            "print.bfk"
        )
    )
    ops = BISC.parse(text, as = :brainfuck)

    io1 = MyIO(Uint8[])
    write(io1, 'a')
    write(io1, 'b')
    io2 = IOBuffer()
    BISC.interpret(ops, io_in = io1, io_out = io2)
    @test takebuf_array(io2) == [0x62, 0x61, 0x63, 0x62]

    text = readall(
        Pkg.dir(
            "BISC",
            "test",
            "programs",
            "ook",
            "print.ook"
        )
    )
    ops = BISC.parse(text, as = :ook)

    io1 = MyIO(Uint8[])
    write(io1, 'a')
    write(io1, 'b')
    io2 = IOBuffer()
    BISC.interpret(ops, io_in = io1, io_out = io2)
    @test takebuf_array(io2) == [0x62, 0x61, 0x63, 0x62]
end
