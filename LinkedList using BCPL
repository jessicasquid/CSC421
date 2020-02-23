import "io"

manifest
 { data = 0;
   right = 1;
   size = 2
 }

let start() be
{ let i, input, temp, head;
  let heap = vec(10000);

  init(heap, 10000);

  head := newvec(size);
  out("insert a positive number, negative number to end.\n");
  input := inno ();

  test input < 0 then
  out ("Bye!\n")

  else
  head ! data := input;
  temp := newvec(3);
  head ! right := temp;

  while input >= 0 do
        { input := inno();

          temp ! data := input;
          temp ! right := newvec(3);

          test temp ! data < 0 then
          temp ! data := "end"

          else
          temp := temp ! right;
        }

  temp ! right := nil;

  until head ! right = nil do
        {  out("        %d\n", head ! data);
           head := head ! right
        }

  out("Done!\n")
}
