# IMPORTS
using Bonobo
using JuMP
using HiGHS

const BB = Bonobo

include("../utils.jl")


# CREATE MODEL
m = Model(HiGHS.Optimizer)
set_optimizer_attribute(m, "log_to_console", false)
@variable(m, x[1:4], Bin)
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


function BB.evaluate_node!(tree::BnBTree{MIPNode, JuMP.Model}, node::MIPNode)
    m = tree.root # this is the JuMP.Model
    vids = MOI.get(m ,MOI.ListOfVariableIndices())
    # we set the bounds for the current node based on `node.lbs` and `node.ubs`.
    vars = VariableRef.(m, vids)
    for vidx in eachindex(vars)
        if isfinite(node.lbs[vidx])
            JuMP.set_lower_bound(vars[vidx], node.lbs[vidx])
        elseif node.lbs[vidx] == -Inf && JuMP.has_lower_bound(vars[vidx])
            JuMP.delete_lower_bound(vars[vidx])
        elseif node.lbs[vidx] == Inf # making problem infeasible
            error("Invalid lower bound for variable $vidx: $(node.lbs[vidx])")
        end
        if isfinite(node.ubs[vidx])
            JuMP.set_upper_bound(vars[vidx], node.ubs[vidx])
        elseif node.ubs[vidx] == Inf && JuMP.has_upper_bound(vars[vidx])
            JuMP.delete_upper_bound(vars[vidx])
        elseif node.ubs[vidx] == -Inf # making problem infeasible
            error("Invalid upper bound for variable $vidx: $(node.lbs[vidx])")
        end
    end

    # get the relaxed solution of the current model using HiGHS
    optimize!(m)
    status = termination_status(m)
    node.status = status
    # if it is infeasible we return `NaN` for bother lower and upper bound
    if status != MOI.OPTIMAL
        return NaN,NaN
    end

    obj_val = objective_value(m)
    # we check whether the values are approximately feasible (are integer)
    # in that case we return the same value for lower and upper bound for this node
    if all(BB.is_approx_feasible.(tree, value.(vars)))
        node.ub = obj_val
        return obj_val, obj_val
    end
    # otherwise we only have a lower bound
    return obj_val, NaN
end


function BB.get_relaxed_values(tree::BnBTree{MIPNode, JuMP.Model}, node)
    vids = MOI.get(tree.root, MOI.ListOfVariableIndices())
    vars = VariableRef.(tree.root, vids)
    return JuMP.value.(vars)
end


function BB.get_branching_nodes_info(tree::BnBTree{MIPNode, JuMP.Model}, node::MIPNode, vidx::Int)
    m = tree.root
    node_info = NamedTuple[]

    var = VariableRef(m, MOI.VariableIndex(vidx))

    lbs = copy(node.lbs)
    ubs = copy(node.ubs)

    val = JuMP.value(var)

    # left child set upper bound
    ubs[vidx] = floor(Int, val)

    push!(node_info, (
        lbs = copy(node.lbs),
        ubs = ubs,
        status = MOI.OPTIMIZE_NOT_CALLED,
    ))

    # right child set lower bound
    lbs[vidx] = ceil(Int, val)

    push!(node_info, (
        lbs = lbs,
        ubs = copy(node.ubs),
        status = MOI.OPTIMIZE_NOT_CALLED,
    ))
    return node_info
end


# USE BONOBO
bnb_model = BB.initialize(;
    Node = MIPNode,
    root = m,
    sense = objective_sense(m) == MOI.MAX_SENSE ? :Max : :Min
)

BB.set_root!(bnb_model, (
    #lbs = [1, 1, 0, 1],
    #ubs = [1.0, 1.0, 0.778, 0.0],
    lbs = zeros(length(x)),
    ubs = fill(Inf, length(x)),
    status = MOI.OPTIMIZE_NOT_CALLED
))

BB.optimize!(bnb_model)


# SOLUTIONS
sol_vars = BB.get_solution(bnb_model)
sol_f = BB.get_objective_value(bnb_model)

print_solution(Paire(sol_vars, sol_f))
