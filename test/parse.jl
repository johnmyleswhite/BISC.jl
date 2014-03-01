module TestParse
    using Base.Test
    using BISC

    s1 = "[\n    +\n    +\n]\n"
    ops1 = BISC.parse(s1, as = :brainfuck)
    @test ops1 == [BISC.OP7, BISC.OP3, BISC.OP3, BISC.OP8]

    s2 = "Ook! Ook?\n    Ook. Ook.\n    Ook. Ook.\nOok? Ook!\n"
    ops2 = BISC.parse(s2, as = :ook)
    @test ops2 == [BISC.OP7, BISC.OP3, BISC.OP3, BISC.OP8]

    s3 = "<-->"
    ops3 = BISC.parse(s3, as = :brainfuck)
    @test ops3 == [BISC.OP2, BISC.OP4, BISC.OP4, BISC.OP1]

    s4 = """
        >--< ++ -- ><
        >--< ++ -- ><
    """
    ops4 = BISC.parse(s4, as = :brainfuck)
    @test ops4 == [
        BISC.OP1,
        BISC.OP4,
        BISC.OP4,
        BISC.OP2,
        BISC.OP3,
        BISC.OP3,
        BISC.OP4,
        BISC.OP4,
        BISC.OP1,
        BISC.OP2,
        BISC.OP1,
        BISC.OP4,
        BISC.OP4,
        BISC.OP2,
        BISC.OP3,
        BISC.OP3,
        BISC.OP4,
        BISC.OP4,
        BISC.OP1,
        BISC.OP2,
    ]

    s5 = "Ook. Ook! Ook. Ook?"
    ops5 = BISC.parse(s5, as = :ook)
    @test ops5 == [BISC.OP5, BISC.OP1]

    s6 = """
        Ook. Ook! Ook. Ook?
        Ook! Ook!
    """
    ops6 = BISC.parse(s6, as = :ook)
    @test ops6 == [BISC.OP5, BISC.OP1, BISC.OP4]

    s7 = """
        Ook. Ook?
        Ook? Ook.
        Ook. Ook.
        Ook! Ook!
        Ook. Ook!
        Ook! Ook.
        Ook! Ook?
        Ook? Ook!

        Ook? Ook!
        Ook! Ook?
        Ook! Ook.
        Ook. Ook!
        Ook! Ook!
        Ook. Ook.
        Ook? Ook.
        Ook. Ook?
    """
    ops7 = BISC.parse(s7, as = :ook)
    @test ops7 == [
        BISC.OP1,
        BISC.OP2,
        BISC.OP3,
        BISC.OP4,
        BISC.OP5,
        BISC.OP6,
        BISC.OP7,
        BISC.OP8,
        BISC.OP8,
        BISC.OP7,
        BISC.OP6,
        BISC.OP5,
        BISC.OP4,
        BISC.OP3,
        BISC.OP2,
        BISC.OP1,
    ]
end
