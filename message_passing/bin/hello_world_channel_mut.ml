(* Example of why sending mutable data is a bad idea *)
(* The thing is if you share mutable data, then you will probably need to fall back
   to locking mechanisms to keep your program thread safe... and you will miss the 
  whole point of message passing.
*)
let n_domains = 3 

module Task = Domainslib.Task
module Channel = Domainslib.Chan

let rec printer c = 
  let msg = Channel.recv c in
  match !msg with 
  | "quit" -> ()
  | _ -> 
      Thread.delay 0.5;
      msg := !msg ^ " ALTERED ";
      Printf.printf "Msg: %s\n" !msg;
      flush stdout;
      printer c


let producer c =
  let send msg = 
    Printf.printf "Producer sends %s\n" !msg;
    flush stdout;
    Channel.send c msg;
    ()
  in
  let msg = ref "Hello" in
  send msg;
  Thread.delay 0.5;
  send (ref "quit");
  Thread.delay 0.5;
  (* Now my internal variable is being modified by another thread -_- *)
  Printf.printf "Initial message seen from producer: %s\n" !msg;
  ()

let () =
  (* Instantiating a thread pool *)
  let pool = Task.setup_pool ~num_additional_domains:(n_domains - 1) () in

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