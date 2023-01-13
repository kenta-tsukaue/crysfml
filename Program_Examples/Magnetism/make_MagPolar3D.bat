@echo off
rem ****
rem ****---- Compilation for MagPolar3D Program ----****
rem ****
rem **** Author: JRC
rem **** Revision: June-2009
rem ****
rem
   if not x%1 == x goto CONT
   cls
   echo    MAKE_MAGPOLAR3D: Make MagPolar3D Compilation
   echo    Syntax: Make_MagPolar3D [lf95/g95/gfortran/ifort]
   goto END
rem
:CONT
   if x%1 == xlf95      goto LF95
   if x%1 == xg95       goto G95
   if x%1 == xgfortran  goto GFOR
   if x%1 == xifort     goto IFORT
   if x%1 == xifortd    goto IFORTd
   goto END
rem
rem ****---- Lahey Compiler ----****
:LF95
   lf95 -c MagPolar3D.f90    -info  -o1 -chk -mod ".;%CRYSFML%\lahey\libC"
   lf95 *.obj -out MagPolar3D_lf  -o1 -lib %CRYSFML%\lahey\libC\crysFML
   goto END
rem
rem ****---- Intel Compiler ----****
:IFORT
   ifort /c MagPolar3D.f90 /O2 /nologo /I. /I%CRYSFML%\ifort64\LibC
   link /subsystem:console /stack:102400000 /out:MagPolar3D.exe *.obj %CRYSFML%\ifort64\LibC\CrysFML.lib
   goto END
:IFORTD
   ifort /c MagPolar3D.f90  /debug:full /check /traceback /nologo  /I. /I%CRYSFML%\ifort64_debug\LibC
rem   ifort  *.obj /exe:MagPolar3D_if  %CRYSFML%\ifort_debug\LibC\CrysFML.lib /link /stack:102400000
   link /subsystem:console /stack:102400000 /out:MagPolar3D.exe *.obj %CRYSFML%\ifort64_debug\LibC\CrysFML.lib
   goto END
rem
rem **---- G95 Compiler ----**
:G95
   g95 -c -O3  -std=f2003  -funroll-loops  -msse2   MagPolar3D.f90   -I%CRYSFML%\G95\LibC
   g95  *.o -o MagPolar3D_g95 -O3  -funroll-loops  -msse2  -L%CRYSFML%\G95\LibC -lcrysfml  -Wl,--heap=0x01000000
   goto END
rem
rem **---- GFORTRAN Compiler ----**
:GFOR
   gfortran -c -O3  -std=f2003  -funroll-loops  -msse2   MagPolar3D.f90   -I%CRYSFML%\GFortran\LibC
   gfortran  *.o -o MagPolar3D_gf -O3  -funroll-loops  -msse2  -L%CRYSFML%\GFortran\LibC -lcrysfml  -Wl,--heap=0x01000000
   goto END
rem
:END
   del *.obj *.mod *.o *.map *.bak > nul
