@include "conv.awk"

BEGIN{
 start_read_mod = 0;
 mod_read = 0;
 energy = 0;
 last_energy = 0;
 publish = 0;
 modstring1 = "";
 modstep1 = 0;
 modstring2 = "";
 modstep2 = 0;

 first = 0;
 firstenergy = 0;
 step = 1;
}
/                           !    Initial Parameters    !/{
 start_read_mod = 1;
}

{
    if( start_read_mod > 0 ){
        read_mod();
    }

    if( ($3 == modstring1) && (publish > 1) && (mod_read1 == 1) ){
        cv_value1 = $4;
    }
    if( ($3 == modstring2) && (publish > 1) && (mod_read1 == 1) ){
        if( first == 0 ){
            first = 1;
            firstenergy = energy;
            last_energy = energy;
        }
        steepness = "-";
        if( last_energy > energy ) steepness = "\\";
        if( last_energy < energy ) steepness = "/";
        printf("  %4d %9.4f %9.4f %18.3f %1s %18.9f\n",step,cv_value1,$4,au2kcalmol(energy - firstenergy),steepness,energy);
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
    if( $5 != "Scan" ) return;

    if( start_read_mod == 1 ) {
        modstring1 = $3;
        start_read_mod = 2;
        mod_read1 = 1;
    } else if( start_read_mod == 2 ) {
        modstring2 = $3;
        start_read_mod = 3;
        mod_read2 = 1;
    }

    if( mod_read1 && mod_read2 ) {

        start_read_mod = 0;

        printf("# 1st Coordinate: %s\n",modstring1);
        printf("# 2nd Coordinate: %s\n",modstring2);
        printf("# Step Value#1   Value#2   Energy [kcal/mol]  S Energy [au]       \n");
        printf("# ---- --------- --------- ------------------ - ------------------\n");
    }
}

# --------------------------------------------------------------

