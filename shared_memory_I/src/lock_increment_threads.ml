let increment count lock n =
  let thread_id = Thread.id (Thread.self ()) in
  for _=0 to n-1 do
    Mutex.lock lock;
    let c = !count in
    Thread.delay 0.5; (* Do something else, like read from file or call http query...*)
    count := c + 1;
    Printf.printf "Thread %d incremented from %d to %d\n" thread_id c !count;
    flush stdout;
    Mutex.unlock lock;
  done

let _ =
  let count = ref 0 in
  let lock = Mutex.create () in
  let t1 = Thread.create (increment count lock) 10 in
  let t2 = Thread.create (increment count lock) 10 in
  Thread.join t1;
  Thread.join t2;
  Printf.printf "Result: %d\n" !count
