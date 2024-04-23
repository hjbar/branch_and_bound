# Stratégie de la méthode (très) gloutonne
# ========================================
#
# - On trie les objets par "utilité" décroissante (valeur/cout)
# - On parcours ces objets de manière décroissante en les prennants s'ils ne font pas dépasser le poid max


# IMPORTS
include("instance.jl")
include("utils.jl")


# FUNCTIONS
function glouton(inst::Instance)
    # ENTREE : Instance
    # SORTIE : Paire(tableau d'entiers, valeur) ; une solution assez bien calculée rapidement

    coeff_utilite = sort_instance(inst)

    solution = [0 for _ in 1:inst.n]
    poid = 0
    valeur = 0

    for i in coeff_utilite
        # ajout d'un objet
        if poid + inst.w[i] <= inst.w_max
            poid += inst.w[i]
            valeur += inst.v[i]
            solution[i] = 1
        end
    end

    Paire(solution, valeur)
end
