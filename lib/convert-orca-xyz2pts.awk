@include "conv.awk"

BEGIN {
    energy = 0.0;

}
{
    print $0;
    if( NR == 2 ){
        energy = $NF;
    }
}
END {
    printf("ENERGY\n");
    printf("%16.9f\n", au2kcalmol(energy));
}

