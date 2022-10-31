(* Executing 10000 tasks in parallel *)
(* Very likely to fail because running out of cores on the machine 
   So your OS will yell at you. *)
let n_tasks = 10000 

let square n = 
  Printf.printf "square %d\n" n;
  n * n 

let launch_tasks () = 
  Array.init n_tasks (fun i -> 
    Domain.spawn (fun _ -> square i)
  )

let _ =

  (* Launching the tasks in the pool *)
  let tasks = launch_tasks () in

  (* Getting our results *)
  for i=0 to (n_tasks-1) do
    let result = Domain.join tasks.(i) in
    Printf.printf "Result for task %d: %d\n" i result;
  done;
