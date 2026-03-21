@include "conv.awk"

# ------------------------------------------------------------------------------

/\$hessian/ {
    start = 3;
    next;
}

# ------------------------------------------------------------------------------

{
    if( start == 3 ){
        nsize = $1;
        start--;
        next;
    }
    if( start == 1 ){
        if( nrow > 0 ) {
            row = $1;
            for(i=2;i<=NF;i++){
                # print row, col[i-1], $i;
                hess[row,col[i-1]] = $i;
            }
            nrow--
            next;
        }
        start = 2;
        if( last_col == nsize - 1 ) start = 0;
    }
    if( start == 2 ){
        for(i=1;i<=NF;i++) col[i] = $i;
        last_col = $NF;
        nrow = nsize;
        start--;
        next;
    }
}

# ------------------------------------------------------------------------------

END {
    printf("HESSIAN\n");
    for(r=0;r<nsize;r++){
        for(c=0;c<nsize;c++){
            printf("%18.16E ",hess[r,c]*au2kcalmol(1.0)/(au2ang(1.0)*au2ang(1.0)));
        }
        printf("\n");
    }
}
