@include "conv.awk"

BEGIN {
  natoms = 0;
  start_sym = 0;
  start_xyz = 0;
  start_grd = 0;
  start_hess = 0;
  progress = 0;
  idx = 0;
  energy = 0;
  energy_avail = 0;
  grd_avail = 0;
  hess_avail = 0;
}
{
	if( start_sym == 1 ){
	  if( idx < progress ) {
		for(i=1;i<=NF;i++){
		  sym[idx] = $i;
		  idx++;
		}
	  }	else {
		idx = 0;
		progress = 0;
		start_sym = 0;
	  }
	}

	if( start_xyz == 1 ){
	  if( idx < progress ) {
		for(i=1;i<=NF;i++){
		  crd[idx] = $i;
		  idx++;
		}
	  }	else {
		idx = 0;
		progress = 0;
		start_xyz = 0;
	  }
	}

	if( start_grd == 1 ){
	  if( idx < progress ) {
		for(i=1;i<=NF;i++){
		  grd[idx] = $i;
		  idx++;
		}
	  }	else {
		idx = 0;
		progress = 0;
		start_grd = 0;
	  }
	}

	if( start_hess == 1 ){
	  if( idx < progress ) {
		for(i=1;i<=NF;i++){
		  hess[idx] = $i;
		  idx++;
		}
	  }	else {
		idx = 0;
		progress = 0;
		start_hess = 0;
	  }
	}

}
/Number of atoms/ {
  natoms = $5;
}
/Atomic numbers/ {
  start_sym =1;
  progress = natoms;
  idx = 0;
}
/Current cartesian coordinates/ {
  start_xyz = 1;
  progress = 3*natoms;
  idx = 0;
}
/Cartesian Gradient/ {
  start_grd = 1;
  progress = 3*natoms;
  idx = 0;
  grd_avail = 1;
}
/Cartesian Force Constants/ {
  start_hess = 1;
  progress = (3*natoms*3*natoms - 3*natoms)/2 + 3*natoms;
  idx = 0;
  hess_avail = 1;
}
/SCF Energy/ {
  energy_avail = 1;
  energy = $4;
}

END {
  printf("%d\n",natoms);
  printf("extracted from gaussian\n");
  for(i=0;i<natoms;i++){
	printf("%2d %16.8f %16.8f %16.8f\n",sym[i],au2ang(crd[i*3 + 0]),au2ang(crd[i*3 + 1]),au2ang(crd[i*3 + 2]));
  }
  if( energy_avail == 1 ) {
	printf("ENERGY\n");
	conv = 627.509469;
	printf("%16.8f\n",au2kcalmol(energy));
  }
  if( grd_avail == 1 ) {
	printf("GRADIENT\n");
	conv = au2kcalmol(1.0) / au2ang(1.0);
	for(i=0;i<natoms;i++){
	  printf("%16.8f %16.8f %16.8f\n",grd[i*3 + 0]*conv,grd[i*3 + 1]*conv,grd[i*3 + 2]*conv);
	}
  }
  if( hess_avail == 1 ) {
	printf("HESSIAN\n");
	conv = au2kcalmol(1.0) / (au2ang(1.0)*au2ang(1.0));
	for(i=0;i<3*natoms;i++){
	  for(j=0;j<3*natoms;j++){
		if( i > j ) {
			k = i
			l = j
		} else {
			k = j
			l = i
		}
		idx = k*(k+1)/2 + l
		printf("%16.8f ",hess[idx]*conv);
	  }
	  printf("\n");
	}
  }
}
