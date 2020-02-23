//File that modifies newvec(), freevec() and init()

import "io"
export {newvec_, freevec_, init_}
manifest	{

	status = 0,
	chunk_size = 1,
	previous = 2,
	next = 3
}

manifest	{
	size_all_metadata = 4,
	unocc = 1212,
	occ = 9898
}

static {heap, next_free_address, ptr_free, curr_address}
static {vecsize = 0, vecused = 0, vecspace, remaining_size}

let print_heap() be
{
    for i = 0 to 50 do
    {
        out("0x%x || ", @(heap ! i));
        out("%d: ", i);
        test heap ! i < 10000 then out("%d", heap ! i)
        else out("0x%x", heap ! i);
        
        out("\n")
    }
}


let freelist(sz) be 	{

	//initialize freelist called by init 
	test sz = 0 then 		{
		ptr_free := heap; //address of first free
		ptr_free ! status := unocc;
		ptr_free ! chunk_size := remaining_size;

		next_free_address := heap;
		remaining_size := vecsize;
		return
					}
	else	{
		ptr_free := next_free_address;
		curr_address := next_free_address;

		//next_free_address +:= (sz + size_all_metadata);		
		remaining_size -:= sz + size_all_metadata;
	
		//initialize allocated chunk
		ptr_free ! status := occ;
                ptr_free ! chunk_size := sz + size_all_metadata;
		ptr_free ! previous := @(next_free_address ! previous);

		//ptr_free ! next := next_free_address;
		next_free_address +:= (sz + size_all_metadata);
		ptr_free ! next := next_free_address;

		//set next free chunk
		next_free_address ! status := unocc;
                next_free_address ! chunk_size := remaining_size;
                next_free_address ! previous := @ptr_free;
               	
		}

	return
}

let init_ (array, size) be {
        // calls by init_(heap, 1000)
        let x;

        vecsize := size;
        vecspace := array;
	vecused := 0;
	x := freelist(0); //initialize freelist

        return
}

let newvec_(sz) be	{
	// I need a free list to keep track of free chunks 
	let x;
	let malloc;
	let size;

	size := sz + size_all_metadata;

	test (vecused + size) > vecsize then	{ 
		out("insufficient memory\n");
		out("vecsize = %d, vecused = %d\n", vecsize, vecused);
		finish
						}

	else	{
		vecused +:= size;

	//check freelist to find the chunk, returns address of the chunk
		freelist(sz);

		malloc := @(curr_address ! 4);
	
		resultis malloc
		}
}


let freevec_ (x) be 	{
	//free the allocation
	//merge neighboring chunks

	let ptr_heap;
	let prev_chunk, next_chunk;

	ptr_heap := x;

	ptr_heap ! -4 := unocc;
	
	prev_chunk := ptr_heap ! -2;
	next_chunk := next_free_address;
	remaining_size +:= ptr_heap ! -3;

	test (ptr_heap ! -5) = next_free_address then 	{
		ptr_heap ! -4 := 0;

		next_free_address ! chunk_size +:= ptr_heap ! -3 ;
		ptr_heap ! -3 := 0;

		next_free_address ! previous := 0;
		ptr_heap ! -2 := 0;
		ptr_heap ! -1 := 0;
        	vecused -:= (ptr_heap ! -3) + size_all_metadata;
		
		return							}	

	else	{
		ptr_heap ! -2 := 0;
		ptr_heap ! -1 := next_free_address
		}

	next_free_address := @(ptr_heap ! -4);
	vecused -:= (ptr_heap ! -3) + size_all_metadata;
  
	return

}


let testrun() be		{

	let a, b, c, d, e, f, g;
	let array = vec(50);

	init_(array, 50);

	a := newvec_(6);
	a ! 0 := 1;
	b := newvec_(6);
	b ! 0 := 2;
	c := newvec_(6);
	c ! 0 := 3;
	d := newvec_(6);
	d ! 0 := 4;
	e := newvec_(6);
	e ! 0 := 5;

	freevec_(a);
	f := newvec_(3);
	f ! 0 := 6;

//	freevec_(b);

	print_heap();

	out("vecused = %d\n", vecused);
	out("vecsize = %d\n", vecsize);
	out("\n");
	out("\n");
	out("a = 0x%x\n\n", @(a ! 0));
  	out("b = 0x%x\n\n", @(b ! 0));
	out("c = 0x%x\n\n", @(c ! 0));
        out("d = 0x%x\n\n", @(d ! 0));
 	out("e = 0x%x\n\n", @(e ! 0));
//	out("----------- Freed (a) and (b) at this point -----------\n\n");
	out("----------- Freed (a) at this point -----------\n\n");
	out("\n");
	out("f allocated!\n");
	out("\n");

	out("f = 0x%x\n\n", @(f ! 0));	
	out("\n");

	out("a = 0x%x << Sadly no garbage collector\n\n", @(a ! 0));
//	out("b = 0x%x << Sadly no garbage collector\n\n", @(b ! 0));
	
	out("\n");
	out("next free address = %d\n", next_free_address);		
	out("\n");
	//print_heap();

	out("Done!")
}
