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
    # test_instance("test/instance_test.dat") # test solution exacte

    # test_instance("instances/sac94/pb/pb2.dat")

    # test_instance("test/instance_random_50.dat") # test efficacité branch_and_bound

    # test_instance("test/instance_random_1000.dat") # test efficacité branch_and_bound

    test_instance("test/instance_random_50000.dat") # test efficacité branch_and_bound

    # test_instance("instances/sac94/pb/pb4.dat") # cas où glouton optimal

    # test_instance("instances/sac94/pet/pet2.dat") # cas où glouton optimal
end


# MAIN
main()
