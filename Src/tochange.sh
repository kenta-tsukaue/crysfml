#!/bin/bash
#
if [ -z "$1" ]; then
cat << !
Syntax : tochange.sh xxx  or tochange.sh f90
         or tochange.sh xxx win or tochange.sh f90 win
!
exit
fi
#
# Arguments
#
_WIN="win"
_CHANGEX="xxx"
_CHANGEF="f90"
to_change="xxx"
win="N"
for arg in "$@"
do
   case "$arg" in
      "xxx")
         to_change=$arg
         ;;
      "f90")
         to_change=$arg
         ;;
      "win")
         win=$arg
         ;;
   esac
done
echo "to_change:"  $to_change
echo " _CHANGEX:"  $_CHANGEX
echo "      win:"  $win
# Space between [ and  comparison are essential!
if [ $to_change == $_CHANGEX ]
then
   echo "---- Changing the extension of some *.f90 files to *.xxx to maintain compatibility with FPM"
   mv CFML_Export_Vtk_LF95.f90               CFML_Export_Vtk_LF95.xxx
   mv CFML_FlipR_Mod.f90                     CFML_FlipR_Mod.xxx
   mv CFML_GlobalDeps_Linux.f90              CFML_GlobalDeps_Linux.xxx
   mv CFML_GlobalDeps_Linux_Intel.f90        CFML_GlobalDeps_Linux_Intel.xxx
   mv CFML_GlobalDeps_MacOS.f90              CFML_GlobalDeps_MacOS.xxx
   mv CFML_GlobalDeps_MacOS_Intel.f90        CFML_GlobalDeps_MacOS_Intel.xxx
   mv CFML_GlobalDeps_Windows.f90            CFML_GlobalDeps_Windows.xxx
   mv CFML_GlobalDeps_Windows_Intel.f90      CFML_GlobalDeps_Windows_Intel.xxx
   mv CFML_HDF5.f90                          CFML_HDF5.xxx
   mv CFML_ILL_Instrm_Data_LF.f90            CFML_ILL_Instrm_Data_LF.xxx
   mv CFML_IO_MessagesRW.f90                 CFML_IO_MessagesRW.xxx
   if [ $win  ==  $_WIN ]
   then
      mv CFML_IO_Messages.f90                CFML_IO_Messages.xxx
      mv CFML_IO_MessagesWin.f90             CFML_IO_Messages.f90
   else
      mv CFML_IO_MessagesWin.f90             CFML_IO_MessagesWin.xxx
   fi
   mv CFML_String_Utilities_gf.f90           CFML_String_Utilities_gf.xxx
   mv CFML_String_Utilities_LF.f90           CFML_String_Utilities_LF.xxx
   mv f2kcli.f90                             f2kcli.xxx
   exit
fi
#
if [ $to_change  ==  $_CHANGEF ]
then
   echo "---- Changing the extension of *.xxx files to *.f90 to maintain compatibility with CMake"
   mv  CFML_Export_Vtk_LF95.xxx              CFML_Export_Vtk_LF95.f90
   mv  CFML_FlipR_Mod.xxx                    CFML_FlipR_Mod.f90
   mv  CFML_GlobalDeps_Linux.xxx             CFML_GlobalDeps_Linux.f90
   mv  CFML_GlobalDeps_Linux_Intel.xxx       CFML_GlobalDeps_Linux_Intel.f90
   mv  CFML_GlobalDeps_MacOS.xxx             CFML_GlobalDeps_MacOS.f90
   mv  CFML_GlobalDeps_MacOS_Intel.xxx       CFML_GlobalDeps_MacOS_Intel.f90
   mv  CFML_GlobalDeps_Windows.xxx           CFML_GlobalDeps_Windows.f90
   mv  CFML_GlobalDeps_Windows_Intel.xxx     CFML_GlobalDeps_Windows_Intel.f90
   mv  CFML_HDF5.xxx                         CFML_HDF5.f90
   mv  CFML_ILL_Instrm_Data_LF.xxx           CFML_ILL_Instrm_Data_LF.f90
   mv  CFML_IO_MessagesRW.xxx                CFML_IO_MessagesRW.f90
   mv  CFML_IO_MessagesWin.xxx               CFML_IO_MessagesWin.f90
   if [ $win ==  $_WIN ]
   then
      mv CFML_IO_Messages.f90                CFML_IO_MessagesWin.f90
      mv CFML_IO_Messages.xxx                CFML_IO_Messages.f90
   else
      mv CFML_IO_MessagesWin.xxx             CFML_IO_MessagesWin.f90
   fi
   mv  CFML_String_Utilities_gf.xxx          CFML_String_Utilities_gf.f90
   mv  CFML_String_Utilities_LF.xxx          CFML_String_Utilities_LF.f90
   mv  f2kcli.xxx                            f2kcli.f90
   exit
else
   echo "---- NOTHING DONE! This script should be invoked with argument xxx or f90 and optionally a second argument win!"
fi
