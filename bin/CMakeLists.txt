# ==============================================================================
# qmutil
# ==============================================================================

INSTALL(FILES
            extract-gdrv-ene
            extract-gdrv-xyz
            extract-gdrv-pts
            extract-gopt-ene
            extract-gopt-xyz
            extract-xyz-numstr
            extract-xyz-str
            extract-fchk-pts
        DESTINATION
            bin
        PERMISSIONS
            OWNER_READ OWNER_WRITE OWNER_EXECUTE GROUP_READ GROUP_EXECUTE WORLD_READ WORLD_EXECUTE
        )
