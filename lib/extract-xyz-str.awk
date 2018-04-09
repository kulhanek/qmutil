BEGIN{
num_of_atoms = 0;
current_index = 1;
current_atom = 0;
skip = 2;
found = 0;
}
{
 if(NR == 1) num_of_atoms = $1;

 if( current_index == my_index ){
     found = 1;
     print $0;
     }

 if( skip > 0 ){
     skip--;
     }
   else{
     current_atom++;
     }

 if( current_atom == num_of_atoms ){
     skip = 2;
     current_atom = 0;
     current_index++;
     }
}
END{

 if( found == 0 ){
     printf("\n");
     printf(" ERROR: Structure with index '%d' was not found !\n",my_index);
     printf("        Only '%d' structures were found in xyz file.\n",current_index-1);
     printf("\n");
     }
}
