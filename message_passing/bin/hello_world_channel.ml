(* Example of channel usage *)
let n_domains = 3 

module Task = Domainslib.Task
module Channel = Domainslib.Chan

let rec printer c = 
  let msg = Channel.recv c in
  match msg with 
  | "quit" -> ()
  | _ -> 
      Thread.delay 0.5;
      Printf.printf "Msg: %s\n" msg;
      flush stdout;
      printer c


let producer c =
  let send msg = 
    Printf.printf "Producer sends %s\n" msg;
    flush stdout;
    Channel.send c msg;
    ()
  in
  send "Hello ";
  Thread.delay 0.5;
  send "World!";
  Thread.delay 0.87;
  send "quit";
  ()

let () =
  (* Instantiating a thread pool *)
  let pool = Task.setup_pool ~num_domains:(n_domains - 1) () in

  (* Bounded channel of size 2 *)
  let channel = Channel.make_bounded 2 in

  (* Careful, Task.await should be called inside the Task.run *)
  Task.run pool (fun _ -> 
    let producer_thread = Task.async pool (fun _ -> producer channel) in
    let consumer_thread = Task.async pool (fun _ -> printer channel) in

    Task.await pool producer_thread;
    Task.await pool consumer_thread;
    ()
  );

  Task.teardown_pool pool;