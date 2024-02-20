macro(set_compiler_flags)

    # Nullify all the Fortran flags.
    set(CMAKE_Fortran_FLAGS "")

    get_filename_component(COMPILER_NAME ${CMAKE_Fortran_COMPILER} NAME_WE)

    if(COMPILER_NAME STREQUAL ifort)

        if(WIN32 OR MSYS)
            if(CMAKE_BUILD_TYPE STREQUAL Debug)
                if (HEAP_ARRAYS)
                    set(CMAKE_Fortran_FLAGS_DEBUG "/debug:full /traceback /nologo /fpp /Qopt-report=0 /heap-arrays /Qdiag-disable:10448")
                else()
                    set(CMAKE_Fortran_FLAGS_DEBUG "/debug:full /traceback /nologo /fpp /Qopt-report=0 /Qdiag-disable:10448")
                endif()
                set(OPT_FLAGS0 "/Od /check:noarg_temp_created ")
                set(OPT_FLAGS  "/Od /check:noarg_temp_created ")
                set(OPT_FLAGS1 "/Od /check:noarg_temp_created ")
                set(OPT_FLAGS2 "/Od /check:noarg_temp_created ")
            elseif(CMAKE_BUILD_TYPE STREQUAL Release)
                if (HEAP_ARRAYS)
                    set(CMAKE_Fortran_FLAGS_RELEASE "/Qopt-report=0 /nologo /heap-arrays /Qdiag-disable:10448")
                else()
                    set(CMAKE_Fortran_FLAGS_RELEASE "/Qopt-report=0 /nologo /Qdiag-disable:10448")
                endif()
		        if (QPARALLEL) 
                       set(OPT_FLAGS0 "/Od")
                       set(OPT_FLAGS  "/O2 /Qparallel")
                       set(OPT_FLAGS1 "/Od")
                       set(OPT_FLAGS2 "/O1 /Qparallel")
                       set(OPT_FLAGS3 "/O3 /Qparallel")
		        else()
		       set(OPT_FLAGS0 "/Od")
                       set(OPT_FLAGS  "/O2")
                       set(OPT_FLAGS1 "/Od")
                       set(OPT_FLAGS2 "/O1")
                       set(OPT_FLAGS3 "/O3")
		        endif()
            endif()
        elseif(APPLE)
            if(CMAKE_BUILD_TYPE STREQUAL Debug)
                set(CMAKE_Fortran_FLAGS_DEBUG "-g -warn -cpp  -qopt-report=0 -fPIC")
                set(OPT_FLAGS  "-g")
                set(OPT_FLAGS1 "-g")
                set(OPT_FLAGS0 "-O0")
		set(OPT_FLAGS2 "-O1")
            elseif(CMAKE_BUILD_TYPE STREQUAL Release)
                set(CMAKE_Fortran_FLAGS_RELEASE "-warn -cpp  -qopt-report=0 -fPIC")
                set(OPT_FLAGS0 "-O0")
                set(OPT_FLAGS  "-O2")
                set(OPT_FLAGS1 "-O0")
                set(OPT_FLAGS2 "-O1")
            endif()
        else()
            if(CMAKE_BUILD_TYPE STREQUAL Debug)
                set(CMAKE_Fortran_FLAGS_DEBUG "-g -warn -cpp  -qopt-report=0 -fPIC")
                set(OPT_FLAGS  "-g")
                set(OPT_FLAGS1 "-g")
                set(OPT_FLAGS0 "-O0")
		set(OPT_FLAGS2 "-O1")
            elseif(CMAKE_BUILD_TYPE STREQUAL Release)
                set(CMAKE_Fortran_FLAGS_RELEASE "-warn -cpp  -qopt-report=0 -fPIC")
                set(OPT_FLAGS0 "-O0")
                set(OPT_FLAGS  "-O2")
                set(OPT_FLAGS1 "-O0")
                set(OPT_FLAGS2 "-O1")
            endif()
        endif()

    elseif(COMPILER_NAME STREQUAL ifx)

        if(WIN32 OR MSYS)
            if(CMAKE_BUILD_TYPE STREQUAL Debug)
                if (HEAP_ARRAYS)
                    set(CMAKE_Fortran_FLAGS_DEBUG "/debug:full /traceback /nologo /fpp /Qopt-report=0 /heap-arrays")
                else()
                    set(CMAKE_Fortran_FLAGS_DEBUG "/debug:full /traceback /nologo /fpp /Qopt-report=0")
                endif()
                set(OPT_FLAGS0 "/Od /check:noarg_temp_created ")
                set(OPT_FLAGS  "/Od /check:noarg_temp_created ")
                set(OPT_FLAGS1 "/Od /check:noarg_temp_created ")
                set(OPT_FLAGS2 "/Od /check:noarg_temp_created ")
            elseif(CMAKE_BUILD_TYPE STREQUAL Release)
                if (HEAP_ARRAYS)
                    set(CMAKE_Fortran_FLAGS_RELEASE "/Qopt-report=0 /nologo /heap-arrays")
                else()
                    set(CMAKE_Fortran_FLAGS_RELEASE "/Qopt-report=0 /nologo")
                endif()
		        set(OPT_FLAGS0 "/Od")
                set(OPT_FLAGS  "/O3")
                set(OPT_FLAGS1 "/Od")
                set(OPT_FLAGS2 "/O3")
                set(OPT_FLAGS3 "/O3")
            endif()
        else()
            if(CMAKE_BUILD_TYPE STREQUAL Debug)
                set(CMAKE_Fortran_FLAGS_DEBUG "-g -warn -cpp  -qopt-report=0 -fPIC")
                set(OPT_FLAGS  "-g")
                set(OPT_FLAGS1 "-g")
                set(OPT_FLAGS0 "-O0")
		set(OPT_FLAGS2 "-O1")
            elseif(CMAKE_BUILD_TYPE STREQUAL Release)
                set(CMAKE_Fortran_FLAGS_RELEASE "-warn -cpp  -qopt-report=0 -fPIC")
                set(OPT_FLAGS0 "-O0")
                set(OPT_FLAGS  "-O3")
                set(OPT_FLAGS1 "-O0")
                set(OPT_FLAGS2 "-O3")
            endif()
        endif()

    elseif(COMPILER_NAME MATCHES "^gfortran")

        if(WIN32 OR MSYS)
            if(CMAKE_BUILD_TYPE STREQUAL Debug)
                set(CMAKE_Fortran_FLAGS_DEBUG "-fbacktrace -ffree-line-length-none")
                set(OPT_FLAGS0 "-O0")
                set(OPT_FLAGS  "-O0")
                set(OPT_FLAGS1 "-O0")
                set(OPT_FLAGS2 "-O0")
                set(CMAKE_Fortran_FLAGS_DEBUG "-fbacktrace -cpp -ffree-line-length-none")
            elseif(CMAKE_BUILD_TYPE STREQUAL Release)
                set(CMAKE_Fortran_FLAGS_RELEASE "-cpp -ffree-line-length-none -fPIC")
                set(OPT_FLAGS  "-O3 -funroll-loops -msse2")
                set(OPT_FLAGS1 "-O0")
                set(OPT_FLAGS0 "-O0")
                set(OPT_FLAGS2 "-O1")
            endif()
        elseif(APPLE)
            if(CMAKE_BUILD_TYPE STREQUAL Debug)
                set(CMAKE_Fortran_FLAGS_DEBUG "-cpp -Wall -ffree-line-length-none -fPIC")
                set(OPT_FLAGS  "-g")
                set(OPT_FLAGS1 "-g")
                set(OPT_FLAGS0 "-g")
		set(OPT_FLAGS2 "-g")
            elseif(CMAKE_BUILD_TYPE STREQUAL Release)
                set(CMAKE_Fortran_FLAGS_RELEASE "-cpp -ffree-line-length-none -fPIC")
                set(OPT_FLAGS  "-O3")
                set(OPT_FLAGS1 "-O0")
                set(OPT_FLAGS0 "-O0")
		set(OPT_FLAGS2 "-O1")
            endif()
        else()
            if(CMAKE_BUILD_TYPE STREQUAL Debug)
                set(CMAKE_Fortran_FLAGS_DEBUG "-Wall -ffree-line-length-none")
                set(OPT_FLAGS  "-g")
                set(OPT_FLAGS1 "-g")
                set(OPT_FLAGS2 "-g")
                set(OPT_FLAGS0 "-O0")
                set(CMAKE_Fortran_FLAGS_DEBUG "-cpp -ffree-line-length-none -fPIC")
            elseif(CMAKE_BUILD_TYPE STREQUAL Release)
                set(CMAKE_Fortran_FLAGS_RELEASE "-cpp -ffree-line-length-none -fPIC")
                set(OPT_FLAGS0 "-O0")
                set(OPT_FLAGS  "-O2")
                set(OPT_FLAGS1 "-O0")
                set(OPT_FLAGS2 "-O1")
            endif()
        endif()

    endif()

endmacro()
