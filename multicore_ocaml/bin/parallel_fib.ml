let rec fib n = 
  if n < 2 then 1 
  else fib (n - 1) + fib (n - 2)

let _ =
  let d1 = Domain.spawn (fun _ -> fib 40) in
  let d2 = Domain.spawn (fun _ -> fib 40) in
  let r1 = Domain.join d1 in
  let r2 = Domain.join d2 in
  Printf.printf "All done!\n";
  Printf.printf "Results: %d - %d\n" r1 r2;