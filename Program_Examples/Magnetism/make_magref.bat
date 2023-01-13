@echo off
rem ****
rem ****---- Compilation for MagRef Program ----****
rem ****
rem **** Author: JRC
rem **** Revision: June-2009
rem ****
rem
   if not x%1 == x goto CONT
   cls
   echo    MAKE_MAGREF: Make Calc_Powder Compilation
   echo    Syntax: make_magref [lf95/g95/gfortran/ifort]
   goto END
rem
:CONT
   if [%TARGET_ARCH%]==[] (set TARGET_ARCH=ia32)
   if [%TARGET_ARCH%]==[ia32] (
       set LIBCRYS=%CRYSFML%\ifort\LibC
       set LIBCRYSGF=%CRYSFML%\GFortran\LibC
   ) else (
       set LIBCRYS=%CRYSFML%\ifort64\LibC
   )
   if x%1 == xlf95      goto LF95
   if x%1 == xg95       goto G95
   if x%1 == xgfortran  goto GFOR
   if x%1 == xifort     goto IFORT
   goto END
rem
rem ****---- Lahey Compiler ----****
:LF95
   lf95 -c magref.f90    -info  -o1 -chk -mod ".;%CRYSFML%\lahey\libC"
   lf95 *.obj -out magref_lf  -o1 -lib %CRYSFML%\lahey\libC\crysFML
   goto END
rem
rem ****---- Intel Compiler ----****
:IFORT
   ifort /c magref.f90 /Ox /nologo /I. /I%LIBCRYS%
   rem ifort /exe:magref_if *.obj "%LIBCRYS%"\CrysFML.lib /link /stack:102400000
   link /subsystem:console /stack:102400000 /out:magref_if.exe *.obj %LIBCRYS%"\CrysFML.lib
   goto END
rem
rem **---- G95 Compiler ----**
:G95
   g95 -c -O3  -std=f2003  -funroll-loops  -msse2   magref.f90   -I%CRYSFML%\G95\LibC
   g95  *.o -o magref_g95 -O3  -funroll-loops  -msse2  -L%CRYSFML%\G95\LibC -lcrysfml  -Wl,--heap=0x01000000
   goto END
rem
rem **---- GFORTRAN Compiler ----**
:GFOR
   gfortran -c -O3  -std=f2003  -funroll-loops  -msse2   magref.f90   -I%CRYSFML%\GFortran\LibC
   gfortran  *.o -o magref_gf -O3  -funroll-loops  -msse2  -L$LIBCRYSGF -lcrysfml  -Wl,--heap=0x01000000
   goto END
rem
:END
   del *.obj *.mod *.o *.map *.bak > nul
