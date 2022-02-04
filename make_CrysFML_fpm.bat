@echo off
rem
rem  Attempt to create a unified build method for CrysFML using fmp
rem
rem
rem  First change the extensions of files that are optionally used in fpm to "xxx" 
rem
cd .\Src
call tochange xxx
cd ..
echo ---- Construction of the CrysFML library for 64 bits using gfortran, ifort or ifx (oneAPI) ----
echo ---- The building procedure install also some executable programs of the Program_Examples subdirectory 
echo      Default: ifort compiler in release mode. Equivalent to the first example below 
echo  Usage: make_CrysFML  ifort  
echo         make_CrysFML  ifort debug 
echo         make_CrysFML  gfortran 
echo         make_CrysFML  gfortran debug 
echo         make_CrysFML  ifx 
echo         make_CrysFML  ifx debug 
   (set _DEBUG=N)
   (set _COMP=ifort)
rem > Setting the FullProf source directory relative to the current script directory
rem
rem > Arguments ----
:LOOP
    if [%1]==[debug]  (set _DEBUG=Y)
    if [%1]==[ifort]  (set _COMP=ifort)
    if [%1]==[ifx]    (set _COMP=ifx)
    if [%1]==[gfortran] (
       (set _COMP=gfortran)
       (set _VER=m64)
    )
    shift
    if not [%1]==[] goto LOOP
 
    if [%_COMP%]==[ifort] (
      cd .\Src
      ren  CFML_GlobalDeps_Windows_Intel.xxx  CFML_GlobalDeps.f90
      cd ..
      if [%_DEBUG%]==[Y] (
         fpm @ifort_debug
      ) else (
         fpm @ifort_release
      )
      cd .\Src
      ren CFML_GlobalDeps.f90 CFML_GlobalDeps_Windows_Intel.xxx  
      cd ..
    )
    if [%_COMP%]==[ifx] (
      cd .\Src
      ren  CFML_GlobalDeps_Windows_Intel.xxx  CFML_GlobalDeps.f90
      cd ..
      if [%_DEBUG%]==[Y] (
         fpm @ifx_debug
      ) else (
         fpm @ifx_release
      )
      cd .\Src
      ren CFML_GlobalDeps.f90 CFML_GlobalDeps_Windows_Intel.xxx  
      cd ..
    )
    if [%_COMP%]==[gfortran] (
      cd .\Src
      ren  CFML_GlobalDeps_Windows_gfortran.xxx  CFML_GlobalDeps.f90
      cd ..
      if [%_DEBUG%]==[Y] (
         fpm @gf_debug
      ) else (
         fpm @gf_release
      )
      cd .\Src
      ren  CFML_GlobalDeps.f90 CFML_GlobalDeps_Windows_gfortran.xxx  
      cd ..
    )

rem
rem  Undo the changes of extensions to be compatilbe with Cmake
rem
cd .\Src
call tochange f90
cd ..  