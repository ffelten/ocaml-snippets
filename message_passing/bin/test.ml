module Task = Domainslib.Task
module Channel = Domainslib.Chan

let usrs = ["billy"; "lola"; "henry"; "alice"; "bob"; "bill"; "joel"] 
let passwords = ["passw"; "much"; "safe"; "pwnd"; "omg"; "abba"; "luke"] 
let hashed = List.map (fun p -> Digestif.MD5.to_hex (Digestif.MD5.digest_string p)) passwords

type userinfo = {
  name: string;
  password: string;
  hashed: string
}

let triples = List.map2 (fun usr_pass hash -> 
    {name= fst (usr_pass); password= snd (usr_pass); hashed= hash}
  ) 
(List.combine usrs passwords) hashed

let gen_word length = 
  let rec make size_left acc = match size_left with 
      0 -> acc
    | _ -> make (size_left-1) (acc ^ (Char.escaped (Char.chr (97 + (Random.int 26)))))
  in
  make length ""

let () = match Sys.argv with
  | _ ->
    let cracked = ref false in
    while not !cracked do
      let gen_pass = gen_word 4 in
      Printf.printf "Trying: %s\n" gen_pass;
      let hashed_gen = Digestif.MD5.to_hex (Digestif.MD5.digest_string gen_pass) in
      match List.find_opt (fun userinfo -> hashed_gen = userinfo.hashed) triples with
        Some found -> 
          if found.password = gen_pass then
            Printf.printf "User: %s\tPassword: %s\tEncrypted: %s\n" found.name gen_pass found.hashed;
            cracked := true;
            ()
        | None -> ()
    done
  (* | _ -> Format.eprintf "%s [<filename>]\n%!" Sys.argv.(0) *)
    