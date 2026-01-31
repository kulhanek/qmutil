@include "conv.awk"

BEGIN {
    num_of_atoms = 0;
    start_read_xyz = 0;
    skip_lines = 0;
    energy = 0;
}

# ------------------------------------------------------------------------------

/^CARTESIAN COORDINATES \(ANGSTROEM\)/ {
    start_read_xyz = 1;
    skip_lines = 1;
    num_of_atoms = 0;
}

/*** OPTIMIZATION RUN DONE ***/ {
    print_xyz();
}

/^FINAL SINGLE POINT ENERGY/ {
    energy = $5;
}

# ------------------------------------------------------------------------------

{
    if( start_read_xyz == 1 ) {
        read_xyz();
    }
}

# --------------------------------------------------------------

function read_xyz() 
{
    if( skip_lines >= 0 ){
        skip_lines--;
        return;
    }
    if( NF == 0 ){
        start_read_xyz = 0;
        return;
    }
    xyz[num_of_atoms,0] = $1;
    xyz[num_of_atoms,1] = $2;
    xyz[num_of_atoms,2] = $3;
    xyz[num_of_atoms,3] = $4;
    num_of_atoms++;
}

# ------------------------------------------------------------------------------

function print_xyz() {
    printf("%d\n",num_of_atoms);
    printf("E= %16.9f\n",energy);
    for(i=0; i < num_of_atoms; i++){
        printf(" %2s %14.6f %14.6f %14.6f\n",xyz[i,0],xyz[i,1],xyz[i,2],xyz[i,3]);
    }
}

# ------------------------------------------------------------------------------

