module TestOptimize
    using Base.Test
    using BISC

    # Test optimization of a simple code

    # Test optimization of complex code
    text = readall(
        Pkg.dir(
            "BISC",
            "test",
            "programs",
            "brainfuck",
            "99bottles.bfk"
        )
    )

    ops = BISC.parse(text, as = :brainfuck)

    extops = BISC.optimize(ops)

    io = IOBuffer()
    BISC.interpret(ops, io_out = io)
    s1 = takebuf_string(io)

    io = IOBuffer()
    BISC.interpret(extops, io_out = io)
    s2 = takebuf_string(io)

    @test s1 == s2
end
