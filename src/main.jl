# IMPORTS
include("instance.jl")
include("glouton.jl")
include("fayard_plateau.jl")
include("utils.jl")


# FUNCTIONS
function main()
    test_instance("test/instance_test.dat")
end


# MAIN
main()
