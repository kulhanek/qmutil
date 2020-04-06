@include "conv.awk"

BEGIN{
 energy = 0;
 step = 1;
 first = 0;
 firstenergy = 0;
 stop = 0;
 printf("# Coordinate: %s\n",modstring);
 printf("# Step      Energy [kcal/mol]  Energy [au]       \n");
 printf("# --------- ------------------ ------------------\n");
}
/^ Energy= /{
 if( stop == 1 ) exit;
 energy = $2;
 if( first == 0 ){
    first = 1;
    firstenergy = energy;
    }
 printf("  %9d %18.3f %18.9f\n",step,au2kcalmol(energy - firstenergy),energy);
 step++; 
}
/^ SCF Done:/{
 if( stop == 1 ) exit;
 energy = $5;
 if( first == 0 ){
    first = 1;
    firstenergy = energy;
    }
 printf("  %9d %18.3f %18.9f\n",step,au2kcalmol(energy - firstenergy),energy);
 step++;
}
/Normal termination of Gaussian/{
 stop = 1;
}

# --------------------------------------------------------------

