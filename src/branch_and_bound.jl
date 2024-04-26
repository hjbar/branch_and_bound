# IMPORTS
using Bonobo
using JuMP
using HiGHS

const BB = Bonobo

include("instance.jl")
include("glouton.jl")
include("fayard_plateau.jl")


# STRUCTS
mutable struct MIPNode <: AbstractNode
    std :: BnBNodeInfo
    lbs :: Vector{Float64}
    ubs :: Vector{Float64}
    status :: MOI.TerminationStatusCode
end

mutable struct Bounds
    lower :: Float64
    upper :: Float64
end

bounds = Bounds(0.0, Inf)


# FUNCTIONS (for model)
function inst_constrait(x, inst::Instance)
    s = 0
    for i in 1:length(x)
        s = s + inst.w[i]*x[i]
    end
    return s
end


function inst_objective(x, inst::Instance)
    s = 0
    for i in 1:length(x)
        s = s + inst.v[i]*x[i]
    end
    return s
end


function create_model(inst::Instance)
    m = Model(HiGHS.Optimizer)
    set_optimizer_attribute(m, "log_to_console", false)

    @variable(m, x[1:inst.n], Bin)
    @constraint(m, inst_constrait(x, inst) <= inst.w_max)
    @objective(m, Max, inst_objective(x, inst))

    return m
end


# FUNCTIONS (for branch&bound)
function BB.get_branching_indices(model::JuMP.Model)
    vis = MOI.get(model, MOI.ListOfVariableIndices())
    return 1:length(vis)
end


function BB.evaluate_node!(tree::BnBTree{MIPNode, JuMP.Model}, node::MIPNode)
    m = tree.root
    vids = MOI.get(m ,MOI.ListOfVariableIndices())
    vars = VariableRef.(m, vids)

    # on calcul la solution continue de ce noeud
    optimize!(m)
    status = termination_status(m)
    node.status = status

    # Si c'est un noeud impossible alors on renvoie 'NaN' pour les deux bornes
    if status != MOI.OPTIMAL
        return NaN,NaN
    end

    # On récupère la solution
    obj_val = objective_value(m)
    node.ub = obj_val

    # On regarde si la solution est entière, si oui on renvoie la même valeur les deux bornes
    if all(BB.is_approx_feasible.(tree, value.(vars)))

        # On met à jour si on a une meilleure solution
        if bounds.lower < obj_val
            node.lb = obj_val
            bounds.lower = obj_val
        else
            node.lb = bounds.lower
        end

        return obj_val, obj_val
    end

    # On renvoie les bornes du noeud
    node.lb = bounds.lower
    return node.lb, node.ub
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

    # Le flls gauche est arrondit à l'entier supérieur
    ubs[vidx] = floor(Int, val)

    push!(node_info, (
        lbs = copy(node.lbs),
        ubs = ubs,
        status = MOI.OPTIMIZE_NOT_CALLED,
    ))

    # Le fils droit est arrondit à l'entier inférieur
    lbs[vidx] = ceil(Int, val)

    push!(node_info, (
        lbs = lbs,
        ubs = copy(node.ubs),
        status = MOI.OPTIMIZE_NOT_CALLED,
    ))

    return node_info
end


################ get bounds ################

######## lower bound (greedy one) #######
function get_lb(inst::Instance)
    glouton(inst).snd
end
#########################################

#### upper bound (fayard et plateau) ####
function get_ub(inst::Instance)
    fayard_plateau(inst).snd
end
#########################################

############################################


# BRANCH & BOUND
function branch_and_bound(inst::Instance)
    m = create_model(inst)
    bounds = Bounds(get_lb(inst), get_ub(inst))

    bnb_model = BB.initialize(;
        Node = MIPNode,
        root = m,
        sense = objective_sense(m) == MOI.MAX_SENSE ? :Max : :Min
    )

    BB.set_root!(bnb_model, (
        lbs = zeros(inst.n),
        ubs = ones(inst.n),
        status = MOI.OPTIMIZE_NOT_CALLED
    ))

    BB.optimize!(bnb_model)

    sol_vars = BB.get_solution(bnb_model)
    sol_f = BB.get_objective_value(bnb_model)

    return Paire(sol_vars, sol_f)
end
