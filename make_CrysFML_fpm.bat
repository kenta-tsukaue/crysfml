@echo off
rem .
rem  Attempt to create a unified build method for CrysFML using fmp
rem .
echo ---- Construction of the CrysFML library for 64 bits using gfortran, ifort or ifx (oneAPI) ----
echo ---- The building procedure installs also some executable programs of the Program_Examples subdirectory
echo      Default: ifort compiler in release mode. Equivalent to the first example below
echo      Examples of using the script:
echo             make_CrysFML_fpm  ifort
echo             make_CrysFML_fpm  ifort debug
echo             make_CrysFML_fpm  gfortran
echo             make_CrysFML_fpm  gfortran debug
echo             make_CrysFML_fpm  ifx
echo             make_CrysFML_fpm  ifx debug
echo     For using the Winteracter library add the word "win" as the last argument (without quotes)
echo ----
   (set _DEBUG=N)
   (set _COMP=ifort)
   (set _WINT=N)
rem > Arguments ----
:LOOP
    if [%1]==[debug]    (set _DEBUG=Y)
    if [%1]==[ifort]    (set _COMP=ifort)
    if [%1]==[ifx]      (set _COMP=ifx)
    if [%1]==[gfortran] (set _COMP=gfortran)
    if [%1]==[win]      (set _WINT=win)
    shift
    if not [%1]==[] goto LOOP
rem .
rem  First change the extensions of files that are optionally used in fpm to "xxx" by
rem  invoking the tochange.bat script in the Src directory.
cd .\Src
   if [%_WINT%]==[win] (
          call tochange xxx win
   ) else (
          call tochange xxx
          )
   )
cd ..

    if [%_COMP%]==[ifort] (
      cd .\Src
      ren  CFML_GlobalDeps_Windows_Intel.xxx  CFML_GlobalDeps.f90
      cd ..
      if [%_WINT%]==[win] (
          if [%_DEBUG%]==[Y] (
             fpm @./rsp/ifort_debug_win
          ) else (
             fpm @./rsp/ifort_release_win
          )
      ) else (
          if [%_DEBUG%]==[Y] (
             fpm @./rsp/ifort_debug
          ) else (
             fpm @./rsp/ifort_release
          )
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
         fpm @./rsp/ifx_debug
      ) else (
         fpm @./rsp/ifx_release
      )
      cd .\Src
      ren CFML_GlobalDeps.f90 CFML_GlobalDeps_Windows_Intel.xxx
      cd ..
    )
    if [%_COMP%]==[gfortran] (
      cd .\Src
      ren  CFML_GlobalDeps_Windows.xxx  CFML_GlobalDeps.f90
      cd ..
      if [%_DEBUG%]==[Y] (
         fpm @./rsp/gf_debug
      ) else (
         fpm @./rsp/gf_release
      )
      cd .\Src
      ren  CFML_GlobalDeps.f90 CFML_GlobalDeps_Windows.xxx
      cd ..
    )
rem .
rem  Undo the changes of extensions to be compatilbe with Cmake
rem .
cd .\Src
   if [%_WINT%]==[win] (
          call tochange f90 win
   ) else (
          call tochange f90
          )
   )
cd ..
