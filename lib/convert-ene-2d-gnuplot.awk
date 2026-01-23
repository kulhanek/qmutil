BEGIN {
    n = 0;
}

/^#/ {
    next;
}

{
    cv1[n] = $2;
    cv2[n] = $3;
    ene[n] = $4;
    n++;
}

END {
    idx=0;
    while( idx < n ){
        k=idx;
        if( backward == 1 ) {
            k=idx+block_size-1;
            for(l=0;l<block_size;l++){
                printf("%9.4f %9.4f %18.3f\n",cv1[k],cv2[k],ene[k]);
                k--;
                idx++;
            }
            backward = 0;
        } else {
            for(l=0;l<block_size;l++){
                printf("%9.4f %9.4f %18.3f\n",cv1[idx],cv2[idx],ene[idx]);
                idx++;
            }
            backward = 1;
        }
        printf("\n");
    }
}

