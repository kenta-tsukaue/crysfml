include(LibFindMacros)

get_filename_component(COMPILER_NAME ${CMAKE_Fortran_COMPILER} NAME_WE)

set(WINTERACTER "$ENV{WINTERACTER}")
set(WINTER "$ENV{WINTER}")
set(WINT "$ENV{WINT}")

if (WIN32)
        
    string(REGEX REPLACE "\\\\" "/" WINTERACTER "${WINTERACTER}")
    string(REGEX REPLACE "\\\\" "/" WINTER "${WINTER}")
    string(REGEX REPLACE "\\\\" "/" WINT "${WINT}")

    set(USERPROFILE "$ENV{USERPROFILE}")
    set(HOMEDRIVE "$ENV{HOMEDRIVE}")
    set(SYSTEMDRIVE "$ENV{SYSTEMDRIVE}")

    if(COMPILER_NAME STREQUAL ifort)

        find_path(WINTERACTER_MOD_DIR
                  NAMES winteracter.mod
                  PATHS ${WINTERACTER}/lib.i64
                        ${WINTERACTER}/lib.if8
                        ${WINTER}/lib.i64
                        ${WINTER}/lib.if8
                        ${WINT}/lib.i64
                        ${WINT}/lib.if8
                        ${USERPROFILE}/wint/lib.i64
                        ${USERPROFILE}/wint/lib.if8
                        ${HOMEDRIVE}/wint/lib.i64
                        ${HOMEDRIVE}/wint/lib.if8
                        ${SYSTEMDRIVE}/wint/lib.i64
                        ${SYSTEMDRIVE}/wint/lib.if8)
    
    elseif(COMPILER_NAME STREQUAL g95)

        find_path(WINTERACTER_MOD_DIR
                  NAMES winteracter.mod
                  PATHS ${WINTERACTER}/lib.g95
                        ${WINTER}/lib.g95
                        ${WINT}/lib.g95
                        ${USERPROFILE}/wint/lib.g95
                        ${HOMEDRIVE}/wint/lib.g95
                        ${SYSTEMDRIVE}/wint/lib.g95)
    
    endif()

    libfind_library(USER32 user32)
    libfind_library(GDI32 gdi32)
    libfind_library(COMDLG32 comdlg32)
    libfind_library(WINSPOOL winspool)
    libfind_library(WINMM winmm)
    libfind_library(SHELL32 shell32)
    libfind_library(ADVAPI32 advapi32)
    libfind_library(HTMLHELP htmlhelp)

    find_library(WINTERACTER_LIBRARY
                 NAMES winter wint
                 PATHS ${WINTERACTER_MOD_DIR})
     
    set(WINTERACTER_PROCESS_LIBS WINTERACTER_LIBRARY
                                 USER32_LIBRARY
                                 GDI32_LIBRARY
                                 COMDLG32_LIBRARY
                                 WINSPOOL_LIBRARY
                                 WINMM_LIBRARY
                                 SHELL32_LIBRARY
                                 ADVAPI32_LIBRARY
                                 HTMLHELP_LIBRARY)
    
else(WIN32)

    if(COMPILER_NAME STREQUAL ifort)

        find_path(WINTERACTER_MOD_DIR
                  NAMES winteracter.mod
                  PATHS ${WINTERACTER}/lib.i64
                        ${WINTERACTER}/lib.if8                  
                        ${WINTER}/lib.i64
                        ${WINTER}/lib.if8
                        ${WINT}/lib.i64
                        ${WINT}/lib.if8
                        ${HOME}/wint/lib.i64
                        ${HOME}/wint/lib.if8
                        ${HOME}/lib.i64
                        ${HOME}/lib.if8
                        /usr/local/lib/wint/lib.i64
                        /usr/local/lib/wint/lib.if8
                        /usr/lib/wint/lib.i64
                        /usr/lib/wint/lib.if8
                        /opt/lib/wint/lib.i64
                        /opt/lib/wint/lib.if8)

    elseif(COMPILER_NAME STREQUAL g95)

        find_path(WINTERACTER_MOD_DIR
                  NAMES winteracter.mod
                  PATHS ${WINTERACTER}/lib.g95
                        ${WINTER}/lib.g95
                        ${WINT}/lib.g95
                        ${HOME}/wint/lib.g95
                        ${HOME}/lib.g95
                        /usr/local/lib/wint/lib.g95
                        /usr/lib/wint/lib.g95
                        /opt/lib/wint/lib.g95)
    
    endif()

    libfind_library(XM Xm)
    libfind_library(XT Xt)
    libfind_library(XMU Xmu)
    libfind_library(X11 X11)
    libfind_library(XEXT Xext)
    libfind_library(XP Xp)
    libfind_library(SM SM)
    libfind_library(ICE ICE)
    libfind_library(XFT Xft)
    libfind_library(PNG png)
    libfind_library(JPEG jpeg)

    find_library(WINTERACTER_LIBRARY NAMES winter wint PATHS ${WINTERACTER_MOD_DIR})

    find_library(WINTGL_LIBRARY NAMES winterGL wintGL PATHS ${WINTERACTER_MOD_DIR})

    set(WINTERACTER_PROCESS_MODS WINTERACTER_MOD_DIR)

    set(WINTERACTER_PROCESS_LIBS WINTERACTER_LIBRARY
                                 WINTGL_LIBRARY
                                 XM_LIBRARY
                                 XT_LIBRARY
                                 XMU_LIBRARY
                                 X11_LIBRARY
                                 XEXT_LIBRARY
                                 XP_LIBRARY
                                 SM_LIBRARY
                                 ICE_LIBRARY
                                 XFT_LIBRARY
                                 PNG_LIBRARY
                                 JPEG_LIBRARY)

endif()

get_filename_component(WINTERACTER_INCLUDE_DIR ${WINTERACTER_MOD_DIR} PATH)

set(WINTERACTER_INCLUDE_DIR ${WINTERACTER_INCLUDE_DIR}/include)

set(WINTERACTER_PROCESS_INCLUDES WINTERACTER_INCLUDE_DIR)

set(WINTERACTER_PROCESS_MODS WINTERACTER_MOD_DIR)

libfind_process(WINTERACTER)
