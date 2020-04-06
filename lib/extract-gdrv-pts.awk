@include "periodic-table.awk"
@include "conv.awk"

BEGIN {
    num_of_atoms = 0;
	num_of_cvs = 0;
    start_read_xyz = 0;
	start_read_cvs = 0;
	start_read_cvs_values = 0;
    skip_lines = 0;
    energy = 0;
}
/Z-Matrix orientation/ {
    start_read_xyz = 1;
    skip_lines = 4;
    num_of_atoms = 0;
}
/Standard orientation:/ {
    start_read_xyz = 1;
    skip_lines = 4;
    num_of_atoms = 0;
}
/Input orientation:/ {
    start_read_xyz = 1;
    skip_lines = 4;
    num_of_atoms = 0;
}
/Initial Parameters/ {
	start_read_cvs = 1;
	skip_lines = 4;
}
/Optimized Parameters/ {
	start_read_cvs_values = 1;
	skip_lines = 4;
}

{
    if( start_read_xyz == 1 ) {
        read_xyz();
    }
}
{
	if( start_read_cvs == 1) {
		read_cvs(); # definition of CVs
	}
}
{
	if( start_read_cvs_values == 1) {
		read_cvs_values(); # reads values for each step, calls print_cvs()
	}
}

/^ Energy= /{
    energy = $2;
}
/^ SCF Done:/ {
    energy = $5;
}
/^ ONIOM: extrapolated energy =/ {
    energy = $5;
}

/Stationary point found./ {
    printf("%d\n",num_of_atoms);
    printf("E= %16.9f\n",energy);
    for(i=0; i < num_of_atoms; i++){
        printf(" %2s %14.7f %14.7f %14.7f\n",get_symbol(xyz[i,3]),xyz[i,0],xyz[i,1],xyz[i,2]);
    }
}

/-- Number of steps exceeded/ {
    printf("%d\n",num_of_atoms);
    printf("E= %16.9f\n",energy);
    for(i=0; i < num_of_atoms; i++){
        printf(" %2s %14.7f %14.7f %14.7f\n",get_symbol(xyz[i,3]),xyz[i,0],xyz[i,1],xyz[i,2]);
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
            xyz[num_of_atoms,0] = $4;
            xyz[num_of_atoms,1] = $5;
            xyz[num_of_atoms,2] = $6;
            xyz[num_of_atoms,3] = $2;
            num_of_atoms++;
        break;
        case 5: # g09-D.01
            xyz[num_of_atoms,0] = $3;
            xyz[num_of_atoms,1] = $4;
            xyz[num_of_atoms,2] = $5;
            xyz[num_of_atoms,3] = $2;
            num_of_atoms++;
        break;
    }
}

function read_cvs()
{
	if(skip_lines >= 0){
        skip_lines--;
        return;
    }
    if($1 == "--------------------------------------------------------------------------------"){
        start_read_cvs = 0;
        return;
    }
	if($5 == "Scan") {
		cvs[num_of_cvs,0] = num_of_cvs + 1; #index
		cvs[num_of_cvs,1] = $2; #name
		cvs[num_of_cvs,2] = substr($3,1,1); #type
		cvs[num_of_cvs,3] = 0; #value, will be read later from another section
		atoms_string = substr($3,3,length($3)-3); #definition
		atoms_count = split(atoms_string,atoms_array,",");
		cvs[num_of_cvs,4] = atoms_count;
		for(i=1; i<=atoms_count; i++){
			cvs[num_of_cvs,4+i] = atoms_array[i];
		}
		num_of_cvs++;
	}
}

function read_cvs_values()
{
	if(skip_lines >= 0){
        skip_lines--;
        return;
    }
    if($1 == "--------------------------------------------------------------------------------"){
        start_read_cvs_values = 0;
		print_cvs(); # print values when the section ends
        return;
    }
	for(i=0; i<num_of_cvs; i++) {
		if($2 == cvs[i,1]){
			cvs[i,3] = $4;
		}
	}

}

function print_cvs() {
	printf("ENERGY\n");
	printf("%16.9f\n", au2kcalmol(energy));
	printf("RST\n");
	printf("%d\n",num_of_cvs);
	for(i=0; i<num_of_cvs; i++){
		printf("%1d %1s %10.4f", cvs[i,0], cvs[i,2], cvs[i,3]);
		for(j=1; j<=cvs[i,4]; j++){
			printf(" %2d",cvs[i,4+j]);
		}
		printf("\n");
	}
}

