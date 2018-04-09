BEGIN{
 start_read_mod = 0;
 mod_read = 0;
 energy = 0;
 last_energy = 0;
 publish = 0;
 modstring = "";
 modstep = 0;
 first = 0;
 firstenergy = 0;
 step = 1;
}
/The following ModRedundant input section has been read/{
 start_read_mod = 1;
}

{
 if( start_read_mod > 0 ){
    read_mod();
    }
 if( ($3 == modstring) && (publish > 1) && (mod_read == 1) ){
    if( first == 0 ){
        first = 1;
        firstenergy = energy;
        last_energy = energy;
        }
    steepness = "-";
    if( last_energy > energy ) steepness = "\\";
    if( last_energy < energy ) steepness = "/";
    printf("  %4d %9.4f %18.3f %1s %18.9f\n",step,$4,(energy - firstenergy)*627.510,steepness,energy);
    last_energy = energy;
    step++;
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

/! Name  Definition              Value          Derivative Info.                !/{
 publish++;
}

/! Name  Definition              Value          Derivative Info.             !/ {
 publish++;
}


# --------------------------------------------------------------

function read_mod()
{
 if( start_read_mod > 0 ) start_read_mod++;
 if( start_read_mod != 3 ) return;

 if( $1 == "D" ){
    mod_read = 1;
    modstring = sprintf("D(%d,%d,%d,%d)",$2,$3,$4,$5);
    }
 if( $1 == "B" ){
        mod_read = 1;
        modstring = sprintf("R(%d,%d)",$2,$3);
        } 
 start_read_mod = 0;

 printf("# Coordinate: %s\n",modstring);
 printf("# Step Value     Energy [kcal/mol]  S Energy [au]       \n");
 printf("# ---- --------- ------------------ - ------------------\n");
}

# --------------------------------------------------------------

