# ==============================================================================
# qmutil
# ==============================================================================

INSTALL(FILES
            extract-gdrv-ene.awk
            extract-gdrv-xyz.awk
            extract-gdrv-pts.awk
            extract-odrv-xyz.awk
            extract-odrv-pts.awk
            extract-gopt-ene.awk
            extract-gopt-xyz.awk
            extract-xyz-numofstr.awk
            extract-xyz-str.awk
            extract-fchk-pts.awk
            periodic-table.awk
            convert-ene-2d-gnuplot.awk
            convert-orca-xyz2pts.awk
            convert-orca-xyz2pts.awk
            extract-gdrv-ene-2d.awk
            extract-xyz-glbmin.awk
            conv.awk
        DESTINATION
            lib
        )
