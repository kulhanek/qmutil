BEGIN {
    read_natoms = 1;
    read_comment = 0;
    read_xyz = 0;
    num_of_atoms = 0;
    natoms = 0;
    num_of_str = 0;
}

# ------------------------------------------------------------------------------

{
    if( read_natoms == 1 ){
        num_of_atoms = $1;
        read_natoms = 0;
        read_comment = 1;
        next;
    }
    if( read_comment == 1 ){
        energy[num_of_str] = $NF;
        read_comment = 0;
        read_xyz = 1;
        natoms = 0;
        next;
    }
    if( read_xyz == 1 ){
        if( NF != 4 ){
            num_of_atoms = $1;
            read_xyz = 0;
            read_comment = 1;
            num_of_str++;
            if( natoms != num_of_atoms ) {
                print ">>> WARNING: Number of atoms read and at the first line does not match!" > "/dev/stderr";
            }
            next;
        }
        xyz[num_of_str,natoms,0] = $1;
        xyz[num_of_str,natoms,1] = $2;
        xyz[num_of_str,natoms,2] = $3;
        xyz[num_of_str,natoms,3] = $4;
        natoms++;
    }
}

END{
    if( read_xyz == 1 ){
        num_of_str++;
        if( natoms != num_of_atoms ) {
            print ">>> WARNING: Number of atoms read and at the first line does not match!" > "/dev/stderr";
        }
    }

    print "# Number of structures:      ", num_of_str > "/dev/stderr";
    print "# Number of atoms:           ", natoms > "/dev/stderr";

    lestr = 0;
    lene = energy[lestr];
    for(i=0; i < num_of_str; i++){
        if( lene > energy[i] ){
            lene = energy[i];
            lestr = i;
        }
    }
    print "# The lowest energy structure", lestr+1 " (" lene ")" > "/dev/stderr";
    print_xyz();
}

# ------------------------------------------------------------------------------

function print_xyz() {
    printf("%d\n",num_of_atoms);
    printf("E= %16.9f\n",energy[lestr]);
    for(i=0; i < num_of_atoms; i++){
        printf(" %2s %14.6f %14.6f %14.6f\n",xyz[lestr,i,0],xyz[lestr,i,1],xyz[lestr,i,2],xyz[lestr,i,3]);
    }
}

# ------------------------------------------------------------------------------

