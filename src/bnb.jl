# IMPORTS
using Bonobo
using JuMP
using HiGHS

const BB = Bonobo

# CREATE MODEL
m = Model(HiGHS.Optimizer)
set_optimizer_attribute(m, "log_to_console", false)
@variable(m, x[1:4] >= 0)
@constraint(m, 3x[1]+7x[2]+9x[3]+6x[4] <= 17)
@objective(m, Max, 8x[1]+18x[2]+20x[3]+11x[4])

# FUNCTIONS
mutable struct MIPNode <: AbstractNode
    std :: BnBNodeInfo
    lbs :: Vector{Float64}
    ubs :: Vector{Float64}
    status :: MOI.TerminationStatusCode
end


function BB.get_branching_indices(model::JuMP.Model)
    # every variable should be discrete
    vis = MOI.get(model, MOI.ListOfVariableIndices())
    return 1:length(vis)
end

# USE BONOBO
bnb_model = BB.initialize(;
    branch_strategy = BB.MOST_INFEASIBLE,
    Node = MIPNode,
    root = m,
    sense = objective_sense(m) == MOI.MAX_SENSE ? :Max : :Min
)

BB.set_root!(bnb_model, (
    lbs = zeros(length(x)),
    ubs = fill(Inf, length(x)),
    status = MOI.OPTIMIZE_NOT_CALLED
))

BB.optimize!(bnb_model)
