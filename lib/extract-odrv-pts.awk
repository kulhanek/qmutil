@include "conv.awk"

BEGIN {
    num_of_atoms = 0;
	num_of_cvs = 0;
    start_read_xyz = 0;
	start_read_cvs = 0;
    skip_lines = 0;
    energy = 0;
}

# ------------------------------------------------------------------------------

/^CARTESIAN COORDINATES \(ANGSTROEM\)/ {
    start_read_xyz = 1;
    skip_lines = 1;
    num_of_atoms = 0;
}
/--- Optimized Parameters ---/ {
	start_read_cvs = 1;
	skip_lines = 4;
    num_of_cvs = 0;
}

/*** OPTIMIZATION RUN DONE ***/ {
    print_pts();
}

/^FINAL SINGLE POINT ENERGY/ {
    energy = $5;
}

# ------------------------------------------------------------------------------

{
    if( start_read_xyz == 1 ) {
        read_xyz();
    }
	if( start_read_cvs == 1) {
		read_cvs(); 
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

function read_cvs()
{
	if(skip_lines >= 0){
        skip_lines--;
        return;
    }
    if($1 == "----------------------------------------------------------------------------"){
        start_read_cvs = 0;
        return;
    }
	if($NF == "C") {
        cvs[num_of_cvs,0] = num_of_cvs + 1; #index
        cvs[num_of_cvs,1] = substr($2,1,1); #type
        cvs[num_of_cvs,2] = $(NF-1); #value
        if (match($0, /[ABD]\([^)]*\)/)) {
            s = substr($0, RSTART, RLENGTH);
            gsub(/^[ABD]\(|\)$/, "", s);
            atoms_count = 0;
            while (match(s, /[A-Z][a-z]?[[:space:]]*([0-9]+)/, m)) {
                atoms_count++;
                cvs[num_of_cvs,3] = atoms_count;
                cvs[num_of_cvs,3+atoms_count] = m[1];
                s = substr(s, RSTART + RLENGTH);
            }
        }
		num_of_cvs++;
	}
}

# ------------------------------------------------------------------------------

function print_pts() {
    printf("%d\n",num_of_atoms);
    printf("E= %16.9f\n",energy);
    for(i=0; i < num_of_atoms; i++){
        printf(" %2s %14.6f %14.6f %14.6f\n",xyz[i,0],xyz[i,1],xyz[i,2],xyz[i,3]);
    }
	printf("ENERGY\n");
	printf("%16.9f\n", au2kcalmol(energy));
	printf("RST\n");
	printf("%d\n",num_of_cvs);
	for(i=0; i<num_of_cvs; i++){
		printf("%1d %1s %10.4f", cvs[i,0], cvs[i,1], cvs[i,2]);
		for(j=1; j<=cvs[i,3]; j++){
			printf(" %2d",cvs[i,3+j]+1); # +1: zero->one indexing
		}
		printf("\n");
	}
}

# ------------------------------------------------------------------------------

