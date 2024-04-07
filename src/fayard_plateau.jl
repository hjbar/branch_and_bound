# Algorithme de Fayard & Plateau (1978)
# =====================================
#
# - On trie les objets par "utilité" décroissante (valeur/cout)
# - On parcours ces objets de manière décroissante en les prennants s'ils ne font pas dépasser le poid max
#
# On trouve une solution exacte (donc pas forcément entière) avec la relaxation continue


# IMPORTS
include("instance.jl")


# FUNCTIONS
function fayard_plateau(inst::Instance)
    # Entrée : Instance
    # Sortie : Paire(tableau de flottants, valeur) ; une solution exacte

    coeff_utilite = sort_instance(inst)

    solution = [0. for _ in 1:inst.n]
    poid = 0
    valeur = 0

    for i in coeff_utilite
        # ajout d'un objet
        if poid + inst.w[i] <= inst.w_max
            poid += inst.w[i]
            valeur += inst.v[i]
            solution[i] = 1
        else
            ratio = (inst.w_max - poid) / inst.w[i]

            poid += inst.w[i] * ratio
            valeur += inst.v[i] * ratio
            solution[i] = ratio

            break
        end
    end

    Paire(solution, valeur)
end
