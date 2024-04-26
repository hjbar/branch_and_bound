let c = 1000
let _ = Random.self_init()

let generate nvar =
  Printf.sprintf "%i 1 %i" nvar (Random.int c)
  (* objectif *)
  ^ (List.init nvar (fun _ -> Printf.sprintf "%i " (Random.int c)) |> List.fold_left (^) "\n")
  (* contrainte *)
  ^ (List.init nvar (fun _ -> Printf.sprintf "%i " (Random.int c)) |> List.fold_left (^) "\n")
  (* poid *)
  ^ (Printf.sprintf "\n%i" (Random.int c+500))

let _ = generate 1000 |> Printf.printf "%s"
