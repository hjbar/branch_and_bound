# IMPORTS
include("utils.jl")
include("instance.jl")
include("glouton.jl")
include("fayard_plateau.jl")
include("branch_and_bound.jl")


# FUNCTIONS
function test_instance(file)
    result = parse_instance(file)
    sol = result.fst
    inst = result.snd

    println("Glouton :")
    res = glouton(inst)
    print_solution(res)

    println("\nFayard&Plateau :")
    res = fayard_plateau(inst)
    print_solution(res)

    println("\nBranch&Bound :")
    res = branch_and_bound(inst)
    print_solution(res)

    println("\nSolution : ", sol)
    println("\n")
end

function main()
    test_instance("../test/instance_test.dat")
end


# MAIN
main()
