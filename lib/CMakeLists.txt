# ==============================================================================
# qmutil
# ==============================================================================

INSTALL(FILES
            extract-gdrv-ene.awk
            extract-gdrv-xyz.awk
            extract-gdrv-pts.awk
            extract-gopt-ene.awk
            extract-gopt-xyz.awk
            extract-xyz-numofstr.awk
            extract-xyz-str.awk
            extract-fchk-pts.awk
            periodic-table.awk
            convert-ene-2d-gnuplot.awk
            extract-gdrv-ene-2d.awk
            conv.awk
        DESTINATION
            lib
        )
