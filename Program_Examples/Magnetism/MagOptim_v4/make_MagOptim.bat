@echo off
rem ****
rem ****---- Compilation for MagOptim Program ----****
rem ****
rem **** Author: JRC
rem **** Revision: June-2012
rem ****
rem
   if not x%1 == x goto CONT
   cls
   echo    MAKE_MagOptim: Make MagOptim Compilation
   echo    Syntax: make_MagOptim [gfortran/ifort]
   goto END
rem
:CONT
   if x%1 == xgfortran  goto GFOR
   if x%1 == xifort     goto IFORT
   goto END
rem
rem
rem ****---- Intel Compiler ----****
:IFORT
   ifort /c Prep_Input.f90              /O2 /nologo /I%CrysFML%\ifort64\LibC
   ifort /c Cost_MagFunctions.f90       /O2 /nologo /I%CrysFML%\ifort64\LibC
   ifort /c MagOptim.f90                /O2 /nologo /I%CrysFML%\ifort64\LibC
   link /subsystem:console /stack:64000000 /out:MagOptim.exe *.obj  %CrysFML%\ifort64\LibC\CrysFML.lib
   goto END
rem
rem **---- GFORTRAN Compiler ----**
:GFOR
   gfortran -c Prep_Input.f90           -O3 -funroll-loops  -msse2  -I%CrysFML%\GFortran\LibC
   gfortran -c Cost_MagFunctions.f90    -O3 -funroll-loops  -msse2  -I%CrysFML%\GFortran\LibC
   gfortran -c MagOptim.f90             -O3 -funroll-loops  -msse2  -I%CrysFML%\GFortran\LibC
   gfortran  *.o -o  MagOptim_gf  -L%CrysFML%\GFortran\LibC -lcrysfml  -Wl,--heap=0x01000000
   goto END
rem
:END
   del *.obj *.mod *.o *.map *.bak > nul
