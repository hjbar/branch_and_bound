# IMPORTS
include("utils.jl")
include("instance.jl")
include("glouton.jl")
include("fayard_plateau.jl")
include("branch_and_bound.jl")


# FUNCTIONS
function test_instance(file, detailed)
    result = parse_instance(file)
    sol = result.fst
    inst = result.snd

    println("Glouton :")
    res = glouton(inst)
    print_solution(res, detailed)

    println("\nFayard&Plateau :")
    res = fayard_plateau(inst)
    print_solution(res, detailed)

    println("\nBranch&Bound :")
    res = branch_and_bound(inst)
    print_solution(res, detailed)

    println("\nSolution : ", sol)
end

function print_sep()
  println("----------------------------------------------")
  println("----------------------------------------------")
end

function main()
    print_sep()

    test_instance("test/instance_test.dat", true) # test solution exacte

    print_sep()

    test_instance("test/instance_random_50.dat", true) # test efficacité branch_and_bound

    print_sep()

    test_instance("test/instance_random_1000.dat", false) # test efficacité branch_and_bound

    print_sep()

    test_instance("test/instance_random_50000.dat", false) # test efficacité branch_and_bound

    print_sep()

    #test_instance("instances/sac94/pb/pb2.dat") # sol .dat erronée

    #print_sep()

    #test_instance("instances/sac94/pb/pb4.dat") # cas où glouton optimal + sol .dat erronée

    #print_sep()

    #test_instance("instances/sac94/pet/pet2.dat") # cas où glouton optimal + sol .dat erronée

    #print_sep()
end


# MAIN
main()
