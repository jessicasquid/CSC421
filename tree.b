//creates binary tree that takes input as string and print them in alphabetical order
//this file uses newfreevec 

import "io"
import "newfreevec"

manifest	{
	data = 0,
	left_node = 1,
	right_node = 2
}

let strcmp(a, b) be 	{
	let i = 0, y , z, diff;

	if byte 0 of a = byte 0 of b  then resultis 0;

	for i = 0 to 25 do     {
                diff := (byte i of a) - (byte i of b);
		test diff < 0 then	{
			 resultis -1
					}
		else test diff > 0 then 	{
			 resultis 1
                                		}
		else			{
			 break
					}
				}
	resultis 0
}

let print_format(x) be  {

        let i;
        let c;
        for i = 0 to 25 do      {
               if byte i of x = '0' then	{
               		byte i of x := ' ';
			break
						}
             
				   }
        //byte i+1 of x := 's';

        resultis(x)
}

let print_order(ptr) be		{

	let temp;

	if ptr = nil then return;

	print_order(ptr ! left_node);

	temp := print_format(ptr ! data);
	out("%s", temp);
	out("\n");

	print_order(ptr ! right_node); 

	return
}

let new_node(x) be 	{
	let p = newvec_(3);

	p ! data := x;
	p ! left_node := nil;
	p ! right_node := nil;

	resultis p
}

let add_to_tree(ptr, input) be 		{

	let x, y;

	if ptr = nil then {
		resultis new_node(input)
			  }
	y := strcmp(input, ptr ! data);

	test (y < 0) then 
		ptr ! left_node := add_to_tree(ptr ! left_node, input)
	else
		ptr ! right_node := add_to_tree(ptr ! right_node, input);

	resultis ptr				
}

let get_s() be	{
 	
	let i, c, input = newvec_(3);

	for i = 0 to 25 do      {
              c := inch();
              if c = '\n' then        {
                   	byte i of input := '0';
                        break
                                      }

              byte i of input := c;
                                 }

       //out("start_echoing: %s\n", input);

	resultis input 
}

let free_vars(ptr) be 	{

//this traverse the tree in right leaf -> left leaf -> root node to free the variables 
//call freevec

        if ptr = nil then return;

        free_vars(ptr ! left_node);
	free_vars(ptr ! right_node);
        
	freevec_(ptr);

        out("%s successfully freed", ptr ! data);
        out("\n");

        return
}

let print_heap(heap) be     {
    for i = 0 to 100 do
    {
        out("0x%x || ", @(heap ! i));
        out("%d: ", i);
        test heap ! i < 10000 then out("%d", heap ! i)
        else out("0x%x", heap ! i);

        out("\n")
    }
}

let start() be 	{

	let input, stop_when;
	let tree, i = 0, y;
	let heap = vec(1000);

	init_(heap, 1000);
	
	input := newvec_(3);
	stop_when := newvec_(3);

	//initialize tree
	tree := nil; 

	//input constraint	
	byte i of stop_when := '*';
	byte i+1 of stop_when := '0';

	out("please type in string , type * to print, ^C to exit: \n");	
	while (strcmp(input, stop_when) <> 0) do	{

		input := get_s();

		y := strcmp(input, stop_when);
		if (y = 0) then {
			out("here is your list!!\n");
			break
				}
		
		//out("checking input status %s\n", input);
		tree := add_to_tree(tree, input);
								}

	//print in order 
	print_order(tree);

	//print_heap(heap);
	out("\n");
	out("\n");

	out("Freevec status: -----------------\n");
	free_vars(tree);
	out("Freevec status: -----------------\n");


	out("\n");
	out("\n");

	out("Done!\n");


	out("\n");
	out("\n");

	start()
			
//end of start function

}
