@include periodic-table.awk

BEGIN{
    num_of_atoms = 0;
    start_read_xyz = 0;
    skip_lines = 0;
    energy = 0;
}
/Z-Matrix orientation/ {
    start_read_xyz = 1;
    skip_lines = 4;
    num_of_atoms = 0;
}
/Standard orientation:/{
    start_read_xyz = 1;
    skip_lines = 4;
    num_of_atoms = 0;
}
/Input orientation:/{
    start_read_xyz = 1;
    skip_lines = 4;
    num_of_atoms = 0;
}


{
    if( start_read_xyz == 1 ){
        read_xyz();
    }
}

/^ Energy= /{
    energy = $2;
}

/^ SCF Done:/{
    energy = $5;
}

/^ ONIOM: extrapolated energy =/{
    energy = $5;
}

/Stationary point found./ {
    printf("%d\n",num_of_atoms);
    printf("E= %16.9f\n",energy);
    for(i=0; i < num_of_atoms; i++){
        printf(" %2s %14.7f %14.7f %14.7f\n",get_symbol(xzy[i,3]),xzy[i,0],xzy[i,1],xzy[i,2]);
    }
}

/-- Number of steps exceeded/{
    printf("%d\n",num_of_atoms);
    printf("E= %16.9f\n",energy);
    for(i=0; i < num_of_atoms; i++){
        printf(" %2s %14.7f %14.7f %14.7f\n",get_symbol(xzy[i,3]),xzy[i,0],xzy[i,1],xzy[i,2]);
    }
 }

# --------------------------------------------------------------

function read_xyz() 
{
    if( skip_lines >= 0 ){
        skip_lines--;
        return;
    }
    if( $1 == "---------------------------------------------------------------------" ){
        start_read_xyz = 0;
        energy = 0;
        return;
    }
    switch(NF) {
        case 6:
            xzy[num_of_atoms,0] = $4;
            xzy[num_of_atoms,1] = $5;
            xzy[num_of_atoms,2] = $6;
            xzy[num_of_atoms,3] = $2;
            num_of_atoms++;
        break;
        case 5: # g09-D.01
            xzy[num_of_atoms,0] = $3;
            xzy[num_of_atoms,1] = $4;
            xzy[num_of_atoms,2] = $5;
            xzy[num_of_atoms,3] = $2;
            num_of_atoms++;
        break;
    }
}

