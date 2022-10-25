let increment count n =
  let thread_id = Thread.id (Thread.self ()) in
  for _=0 to n-1 do
    let c = !count in
    Thread.delay 0.5; (* Do something else, like read from file or call http query...*)
    count := c + 1;
    Printf.printf "Thread %d incremented from %d to %d\n" thread_id c !count;
    flush stdout
  done

let _ =
  let count = ref 0 in
  let t1 = Thread.create (increment count) 10 in
  let t2 = Thread.create (increment count) 10 in
  Thread.join t1;
  Thread.join t2;
  Printf.printf "Result: %d\n" !count

