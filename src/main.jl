# IMPORTS
include("instance.jl")
include("glouton.jl")
include("fayard_plateau.jl")
include("utils.jl")


# FUNCTIONS
function main()
    inst = read_instance()

    sol = glouton(inst)
    print_solution(sol)

    sol = fayard_plateau(inst)
    print_solution(sol)
end


# MAIN
main()
