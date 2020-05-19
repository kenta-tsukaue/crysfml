macro(set_compiler_flags_08)

    # Nullify all the Fortran flags.
    set(CMAKE_Fortran_FLAGS "")
    set(CMAKE_Fortran_FLAGS_DEBUG "")

    get_filename_component(COMPILER_NAME ${CMAKE_Fortran_COMPILER} NAME_WE)

    if(WIN32)
        if(COMPILER_NAME STREQUAL ifort)
            if(CMAKE_BUILD_TYPE STREQUAL Debug)
                set(OPT_FLAGS "/nologo")
                set(OPT_FLAGS0 "/Od")                
                set(OPT_FLAGS1 "/debug:full /check /check:noarg_temp_created /traceback /nologo /CB")                
            elseif(CMAKE_BUILD_TYPE STREQUAL Release)
                set(OPT_FLAGS "/nologo")
                set(OPT_FLAGS0 "/Od")
                set(OPT_FLAGS1 "/O2")
            endif()
            set(OPT_FLAGS2 "/fpp /Qopt-report:0")
        elseif(COMPILER_NAME STREQUAL gfortran)
            if(ARCH32)
                set(OPT_FLAGSC "-m32")
            else()
                set(OPT_FLAGSC "-m64")
            endif()
            if(CMAKE_BUILD_TYPE STREQUAL Debug)
                set(OPT_FLAGS0 "-O0 -std=f2008 -Wunused-variable -fbacktrace -fdec-math -ffree-line-length-0 -fall-intrinsics")
                set(OPT_FLAGS1 "-O0 -std=f2008 -Wunused-variable -fbacktrace -fdec-math -ffree-line-length-0 -fall-intrinsics")
            elseif(CMAKE_BUILD_TYPE STREQUAL Release)
                set(OPT_FLAGS0 "-O0 -std=f2008 -ffree-line-length-0 -fdec-math -fall-intrinsics")
                set(OPT_FLAGS1 "-O3 -std=f2008 -ffree-line-length-0 -fdec-math -fall-intrinsics")
            endif()
            set(OPT_FLAGS2 "")
        endif()
    elseif(UNIX)
        # Covers Linux and macOS
        # Flags are minimal here and should be updated (notably on optimization)
        if(COMPILER_NAME STREQUAL gfortran)
            if(ARCH32)
                set(OPT_FLAGSC "-m32")
            else()
                set(OPT_FLAGSC "-m64")
            endif()
            if(CMAKE_BUILD_TYPE STREQUAL Debug)
                set(OPT_FLAGS0 "-O0 -std=f2008 -Wunused-variable -fbacktrace -fdec-math -ffree-line-length-0 -fall-intrinsics")
                set(OPT_FLAGS1 "-O0 -std=f2008 -Wunused-variable -fbacktrace -fdec-math -ffree-line-length-0 -fall-intrinsics")
            elseif(CMAKE_BUILD_TYPE STREQUAL Release)
                set(OPT_FLAGS0 "-O0 -std=f2008 -ffree-line-length-0  -fdec-math -fall-intrinsics")
                set(OPT_FLAGS1 "-O3 -std=f2008 -ffree-line-length-0  -fdec-math -fall-intrinsics")
            endif()
        elseif(COMPILER_NAME STREQUAL ifort)
            if(CMAKE_BUILD_TYPE STREQUAL Debug)
                set(OPT_FLAGS0 "-O0")
                set(OPT_FLAGS1 "-g")
            elseif(CMAKE_BUILD_TYPE STREQUAL Release)
                set(OPT_FLAGS0 "-O0")
                set(OPT_FLAGS1 "-O2")
            endif()
        endif()
    endif()

endmacro()
