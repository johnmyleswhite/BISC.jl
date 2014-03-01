using BISC

text = readall(
    Pkg.dir(
        "BISC",
        "test",
        "programs",
        "ook",
        "squares2.ook"
    )
)

ops = BISC.parse(text, as = :ook)

# Interpretation of raw BISC ops
t = Array(Float64, 5)
t[1] = @elapsed BISC.interpret(ops)
t[2] = @elapsed BISC.interpret(ops)
t[3] = @elapsed BISC.interpret(ops)
t[4] = @elapsed BISC.interpret(ops)
t[5] = @elapsed BISC.interpret(ops)
println(STDERR, "Naive interpretation of BISC ops")
println(STDERR, t)

# Interpretation of generated Julia code
code = BISC.translate(ops, as = :julia)
name, io = mktemp()
println(io, "function foo()")
println(io, code)
println(io, "end")
println(io, "print(@elapsed foo())")
println(io, "print(@elapsed foo())")
println(io, "print(@elapsed foo())")
println(io, "print(@elapsed foo())")
println(io, "print(@elapsed foo())")
close(io)

t = [parsefloat(t_i) for t_i in matchall(r"\d+\.\d+", readall(`julia $name`))]
println(STDERR, "Interpretation of generated Julia code")
println(STDERR, t)

# Execution of generated C code after compilation
code = BISC.translate(ops, as = :c)
cname = string(tempname(), ".c")
exename = tempname()
io = open(cname, "w")
println(io, code)
close(io)
run(`clang -o $exename $cname`)

t = Array(Float64, 5)
t[1] = @elapsed run(`$exename`)
t[2] = @elapsed run(`$exename`)
t[3] = @elapsed run(`$exename`)
t[4] = @elapsed run(`$exename`)
t[5] = @elapsed run(`$exename`)
println(STDERR, "Execution of generated C code after compilation")
println(STDERR, t)

# Interpretation of optimized BISC operations
extops = BISC.optimize(ops)
t = Array(Float64, 5)
t[1] = @elapsed BISC.interpret(extops)
t[2] = @elapsed BISC.interpret(extops)
t[3] = @elapsed BISC.interpret(extops)
t[4] = @elapsed BISC.interpret(extops)
t[5] = @elapsed BISC.interpret(extops)
println(STDERR, "Optimized interpretation of extended BISC ops")
println(STDERR, t)
