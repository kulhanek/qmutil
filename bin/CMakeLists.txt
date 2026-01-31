# ==============================================================================
# qmutil
# ==============================================================================

INSTALL(FILES
            extract-gdrv-ene
            extract-gdrv-xyz
            extract-gdrv-pts
            extract-odrv-xyz
            extract-odrv-pts
            extract-gopt-ene
            extract-gopt-xyz
            extract-xyz-numstr
            extract-xyz-str
            extract-xyz-glbmin
            extract-fchk-pts
            convert-ene-2d-gnuplot
            convert-orca-xyz2pts
            extract-gdrv-ene-2d
            extract-gdrv-xyz-2d
        DESTINATION
            bin
        PERMISSIONS
            OWNER_READ OWNER_WRITE OWNER_EXECUTE GROUP_READ GROUP_EXECUTE WORLD_READ WORLD_EXECUTE
        )
