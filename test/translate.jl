module TestTranslate
    using Base.Test
    using BISC

    s1 = BISC.translate(
        [BISC.OP7, BISC.OP3, BISC.OP3, BISC.OP8],
        as = :brainfuck
    )
    @test s1 == "[\n    +\n    +\n]\n"

    s2 = BISC.translate(
        [BISC.OP7, BISC.OP3, BISC.OP3, BISC.OP8],
        as = :ook
    )
    @test s2 == "Ook! Ook?\n    Ook. Ook.\n    Ook. Ook.\nOok? Ook!\n"
end
