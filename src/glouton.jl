# Stratégie de la méthode (très) gloutonne
# ========================================
#
# - On trie les objets par "utilité" décroissante (valeur/cout)
# - On parcours ces objets de manière décroissante en les prennants s'ils ne font pas dépasser le poid max

# FUNCTIONS
function glouton(inst::Instance)
    # ENTREE : Instance
    # SORTIE : Paire(tableau, valeur) ; une solution assez bien calculée rapidement

    coeff_utilite = [Paire(i, inst.v[i]/inst.w[i]) for i in 1:inst.n]
    sort!(coeff_utilite, lt=snd_compare)
    coeff_utilite = [p.fst for p in coeff_utilite] # on enleve les coefficients valeur/cout

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

    return Paire(solution, valeur)

end
