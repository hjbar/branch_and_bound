"""
import Pkg
Pkg.add("Cbc")
"""


using JuMP, Cbc


function branch_and_bound()

    m = Model(Cbc.Optimizer)

    @variable(m, x[i in 1:4], Bin)
    @objective(m, Max, 8*x[1] + 18*x[2] + 20*x[3] + 11*x[4])
    @constraint(m, poids, 3*x[1] + 7*x[2] + 9*x[3] + 6*x[4] <= 17)

    optimize!(m)

    println("max(P) = Z* = ", JuMP.objective_value(m))
    println("x[1] = ", JuMP.value(x[1]))
    println("x[2] = ", JuMP.value(x[2]))
    println("x[3] = ", JuMP.value(x[3]))
    println("x[4] = ", JuMP.value(x[4]))

end


branch_and_bound()
