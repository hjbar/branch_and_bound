# IMPORTS
using JuMP, Cbc

include("../src/instance.jl")
include("../src/branch_and_bound.jl")


# FUNCTIONS
function get_model(inst::Instance)
  m = Model(Cbc.Optimizer)
  MOI.set(m, MOI.Silent(), true)

  @variable(m, x[1:inst.n], Bin)
  @objective(m, Max, inst_objective(x, inst))
  @constraint(m, inst_constrait(x, inst) <= inst.w_max)

  return m
end

function get_sol(inst::Instance)
  m = get_model(inst)

  optimize!(m)

  return JuMP.objective_value(m)
end

function print_sol(file)
  inst = parse_instance(file).snd
  sol = get_sol(inst)
  println("\nSolution : ", sol)
end

function main()
  print_sol("test/instance_random_50.dat")

  print_sol("test/instance_random_1000.dat")

  print_sol("test/instance_random_50000.dat")
end


# MAIN
main()
