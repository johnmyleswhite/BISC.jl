module TestPrograms
    using Base.Test
    using BISC

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
            "hello2.bfk"
        )
    )
    ops = BISC.parse(text, as = :brainfuck)
    io = IOBuffer()
    BISC.interpret(ops, io_out = io)
    @test takebuf_string(io) == "Hello world!\n"

    text = readall(
        Pkg.dir(
            "BISC",
            "test",
            "programs",
            "brainfuck",
            "99bottles.bfk"
        )
    )
    io = IOBuffer()
    ops = BISC.parse(text, as = :brainfuck)
    BISC.interpret(ops, io_out = io)

    text = readall(
        Pkg.dir(
            "BISC",
            "test",
            "programs",
            "brainfuck",
            "gameoflife.bfk"
        )
    )
    io_in = MyIO(Uint8[])
    write(io_in, 'q')
    write(io_in, '\n')
    io_out = IOBuffer()
    ops = BISC.parse(text, as = :brainfuck)
    BISC.interpret(ops, io_in = io_in, io_out = io_out)

    text = readall(
        Pkg.dir(
            "BISC",
            "test",
            "programs",
            "ook",
            "squares.ook"
        )
    )
    io = IOBuffer()
    ops = BISC.parse(text, as = :ook)
    BISC.interpret(ops, io_out = io)
    @test takebuf_string(io) == "1 4 9 16 25 36 49 64 81 100 "

    text = readall(
        Pkg.dir(
            "BISC",
            "test",
            "programs",
            "ook",
            "squares2.ook"
        )
    )
    io = IOBuffer()
    ops = BISC.parse(text, as = :ook)
    BISC.interpret(ops, io_out = io)
    output = takebuf_string(io)
    reference = ""
    for i in 0:100
        reference = string(reference, @sprintf("%d\n", i^2))
    end
    @test output == reference
end
