let d = 1000

let generate nvar =
  Printf.sprintf "%i 1 0" nvar
  (* objectif *)
  ^ (List.init nvar (fun _ -> Printf.sprintf "%i " (d + Random.int d)) |> List.fold_left (^) "\n")
  (* contrainte *)
  ^ (List.init nvar (fun _ -> Printf.sprintf "%i " (Random.int d)) |> List.fold_left (^) "\n")
  (* poid *)
  ^ (Printf.sprintf "\n%i" (d / 2 + Random.int d))

let () =
  Random.self_init ();

  Printf.printf "Nombre de variables : %!";
  let num_vars = read_int () in
  let content = generate num_vars in

  let file = open_out (Printf.sprintf "test/instance_random_%i.dat" num_vars) in
  output_string file content;
  close_out file
