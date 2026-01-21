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
        block_cv2 = cv2[k];
        m=0;
        for(;k < n; k++) {
            if( sprintf("%.3f",cv2[k]) != sprintf("%.3f",block_cv2) ) break;
            m++;
        }
        backward = 0;
        if( sprintf("%.3f",cv1[idx]) > sprintf("%.3f",cv1[idx+1]) ) backward = 1;
        if( backward == 1 ){
            k=idx+m-1;
            for(l=0;l<m;l++){
                printf("%9.4f %9.4f %18.3f\n",cv1[k],cv2[k],ene[k]);
                k--;
                idx++;
            }
        } else { 
            for(l=0;l<m;l++){
                printf("%9.4f %9.4f %18.3f\n",cv1[idx],cv2[idx],ene[idx]);
                idx++;
            }
        }
        printf("\n");
    }
}

