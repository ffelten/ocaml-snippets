module Task = Domainslib.Task
module Channel = Domainslib.Chan

let n_domains = 2
(* Instantiating a thread pool *)
let pool = Task.setup_pool ~num_additional_domains:(n_domains - 1) ()

let rec filter_and_forward n in_channel out_channel =
  Thread.delay 0.1;
  let current = Channel.recv in_channel in
  if (current mod n) <> 0 then 
    begin
      (* Printf.printf "Filter #%d forwarding %d\n" n current; *)
      flush stdout;
      Channel.send out_channel current;
    end;
  filter_and_forward n in_channel out_channel

let rec new_prime_filter c = 
  let my_prime = Channel.recv c in
  Printf.printf "Prime found: %d\n" my_prime;
  flush stdout;
  let channel_to_next_prime = Channel.make_bounded 1 in
  (* Using lightweight threads to filter the next numbers,
     I tried to use Domains but it blocked somehow. *)
  let _ = Thread.create new_prime_filter channel_to_next_prime in
  filter_and_forward my_prime c channel_to_next_prime


let producer c n =
  for i=2 to n do
    Channel.send c i
  done;
  ()

let () =
  (* Bounded channel of size 2 *)
  let channel = Channel.make_bounded 1 in

  (* Careful, Task.await should be called inside the Task.run *)
  Task.run pool (fun _ -> 
    let producer_thread = Task.async pool (fun _ -> producer channel 1000) in
    let consumer_thread = Task.async pool (fun _ -> new_prime_filter channel) in

    Task.await pool producer_thread;
    Task.await pool consumer_thread;
    ()
  );

  Task.teardown_pool pool;