let rec fib n = 
  if n < 2 then 1 
  else fib (n - 1) + fib (n - 2)

let _ =
  let r1 = fib 40 in
  let r2 = fib 40 in
  Printf.printf "All done!\n";
  Printf.printf "Results: %d - %d\n" r1 r2;