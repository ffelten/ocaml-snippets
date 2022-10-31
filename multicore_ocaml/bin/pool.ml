(* Executing 10000 tasks in parallel on n_domains cores *)
let n_domains = 3 
let n_tasks = 1000 

module Task = Domainslib.Task

let square n = 
  Printf.printf "square %d\n" n;
  n * n 

let launch_tasks pool = 
  Array.init n_tasks (fun i -> 
    Task.async pool (fun _ -> square i)
  )

let _ =
  (* Instantiating a thread pool *)
  let pool = Task.setup_pool ~num_additional_domains:(n_domains - 1) () in

  (* Launching the tasks in the pool *)
  let tasks = launch_tasks pool in

  (* Careful, Task.await should be called inside the Task.run *)
  Task.run pool (fun _ -> 
    (* Getting our results *)
    for i=0 to n_tasks-1 do
      let result = Task.await pool tasks.(i) in
      Printf.printf "Result for task %d: %d\n" i result;
    done;
  );

  Task.teardown_pool pool;