let process n = 
  Printf.printf "thread %d starts processing.\n" n;  
  flush stdout; (* Forces print *)
  Thread.delay 0.5;
  Printf.printf "thread %d done processing.\n" n;
in

let t1 = Thread.create process 1 in
let t2 = Thread.create process 2 in
Thread.join t1;
Thread.join t2;
Printf.printf "all done!\n"