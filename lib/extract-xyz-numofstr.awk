BEGIN{
num_of_atoms = 0;
current_index = 0;
current_atom = 0;
skip = 2;
}
{
 if(NR == 1) num_of_atoms = $1;

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
printf("%d\n",current_index);
}
