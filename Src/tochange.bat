@echo off
(set _WINT=no)
if [%1]==[xxx]  (set _CHANGE=to_xxx)
if [%1]==[f90]  (set _CHANGE=to_f90)
if [%2]==[win]  (set _WINT=win)
if [%_CHANGE%]==[to_xxx] (
   echo ---- Changing the extension of some *.f90 files to *.xxx to maintain compatibility with FPM
   ren  CFML_Export_Vtk_LF95.f90               CFML_Export_Vtk_LF95.xxx
   ren  CFML_FlipR_Mod.f90                     CFML_FlipR_Mod.xxx
   ren  CFML_GlobalDeps_Linux.f90              CFML_GlobalDeps_Linux.xxx
   ren  CFML_GlobalDeps_Linux_Intel.f90        CFML_GlobalDeps_Linux_Intel.xxx
   ren  CFML_GlobalDeps_MacOS.f90              CFML_GlobalDeps_MacOS.xxx
   ren  CFML_GlobalDeps_MacOS_Intel.f90        CFML_GlobalDeps_MacOS_Intel.xxx
   ren  CFML_GlobalDeps_Windows.f90            CFML_GlobalDeps_Windows.xxx
   ren  CFML_GlobalDeps_Windows_Intel.f90      CFML_GlobalDeps_Windows_Intel.xxx
   ren  CFML_HDF5.f90                          CFML_HDF5.xxx
   ren  CFML_ILL_Instrm_Data_LF.f90            CFML_ILL_Instrm_Data_LF.xxx
   ren  CFML_IO_MessagesRW.f90                 CFML_IO_MessagesRW.xxx
   if [%_WINT%]==[win] (
     ren  CFML_IO_Messages.f90                   CFML_IO_Messages.xxx
     ren  CFML_IO_MessagesWin.f90                CFML_IO_Messages.f90
   ) else (
     ren  CFML_IO_MessagesWin.f90                CFML_IO_MessagesWin.xxx
   )
   ren  CFML_String_Utilities_gf.f90           CFML_String_Utilities_gf.xxx
   ren  CFML_String_Utilities_LF.f90           CFML_String_Utilities_LF.xxx
   ren  f2kcli.f90                             f2kcli.xxx
)
if [%_CHANGE%]==[to_f90] (
   echo ---- Changing the extension of *.xxx files to *.f90 to maintain compatibility with CMake
   ren  CFML_Export_Vtk_LF95.xxx               CFML_Export_Vtk_LF95.f90
   ren  CFML_FlipR_Mod.xxx                     CFML_FlipR_Mod.f90
   ren  CFML_GlobalDeps_Linux.xxx              CFML_GlobalDeps_Linux.f90
   ren  CFML_GlobalDeps_Linux_Intel.xxx        CFML_GlobalDeps_Linux_Intel.f90
   ren  CFML_GlobalDeps_MacOS.xxx              CFML_GlobalDeps_MacOS.f90
   ren  CFML_GlobalDeps_MacOS_Intel.xxx        CFML_GlobalDeps_MacOS_Intel.f90
   ren  CFML_GlobalDeps_Windows.xxx            CFML_GlobalDeps_Windows.f90
   ren  CFML_GlobalDeps_Windows_Intel.xxx      CFML_GlobalDeps_Windows_Intel.f90
   ren  CFML_HDF5.xxx                          CFML_HDF5.f90
   ren  CFML_ILL_Instrm_Data_LF.xxx            CFML_ILL_Instrm_Data_LF.f90
   ren  CFML_IO_MessagesRW.xxx                 CFML_IO_MessagesRW.f90
   if [%_WINT%]==[win] (
     ren  CFML_IO_Messages.f90                   CFML_IO_MessagesWin.f90
     ren  CFML_IO_Messages.xxx                   CFML_IO_Messages.f90
   ) else (
     ren  CFML_IO_MessagesWin.xxx               CFML_IO_MessagesWin.f90
   )
   ren  CFML_String_Utilities_gf.xxx           CFML_String_Utilities_gf.f90
   ren  CFML_String_Utilities_LF.xxx           CFML_String_Utilities_LF.f90
   ren  f2kcli.xxx                             f2kcli.f90
)
