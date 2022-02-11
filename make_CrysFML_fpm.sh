#!/bin/bash
#
#  
#  Attempt to create a unified build method for CrysFML using fmp
#  
echo "---- Construction of the CrysFML library for 64 bits using gfortran, ifort or ifx (oneAPI) ----         "
echo "---- The building procedure installs also some executable programs of the Program_Examples subdirectory"
echo "     Default: ifort compiler in release mode. Equivalent to the first example below"
echo "     Examples of using the script:"
echo "            make_CrysFML_fpm.sh  ifort"
echo "            make_CrysFML_fpm.sh  ifort debug"
echo "            make_CrysFML_fpm.sh  gfortran"
echo "            make_CrysFML_fpm.sh  gfortran debug"
echo "            make_CrysFML_fpm.sh  ifx"
echo "            make_CrysFML_fpm.sh  ifx debug"
echo "    For using the Winteracter library add the word "win" as the last argument (without quotes)"
echo "----"

if [ -z "$1" ]; then
cat << !
Syntax : make_CrysFML_fpm.sh xxx  or make_CrysFML_fpm.sh f90
         or make_CrysFML_fpm.sh xxx win make_CrysFML_fpm.sh f90 win
!
exit
fi
#
# Default values for Arguments
#
COMP=""
DEBUG="N"
CONS="Y"
WINT="N"
#
for arg in "$@"
do
   case "$arg" in
      "ifort")
         COMP=$arg
         ;;
      "ifx")
         COMP=$arg
         ;;
      "gfortran")
         COMP=$arg
         ;;
      "debug")
         DEBUG="Y"
         ;;
      "win")
         WINT=$arg
         ;;
   esac
done

# 
# Select the proper fpm.toml file depending on win
# 
   if [ $WINT == "Y" ]; then
          echo "Copying ./toml/fpm_linmac_win.toml to fpm.toml"
          cp ./toml/fpm_linmac_win.toml  fpm.toml
   else
          echo Copying ./toml/fpm_linmac_con.toml to fpm.toml
          cp ./toml/fpm_windows_con.toml  fpm.toml
   fi       
#  
#  First change the extensions of files that are optionally used in fpm to "xxx" by
#  invoking the tochange.bat script in the Src directory.
#
cd ./Src
    if [ $WINT == "win" ]; then
          tochange.sh xxx win
    else
          tochange.sh xxx
    fi
cd ..
#
#  Block if-then-else for compiler "ifort"
#
#
    if [ $COMP == "ifort" ]; then
      cd ./Src
      mv  CFML_GlobalDeps_Linux_Intel.xxx  CFML_GlobalDeps.f90
      cd ..
        if [ $WINT == "win" ]; then 
            if [ $DEBUG == "Y" ];then 
               fpm @./rsp/ifort_debug_win
            else  
               fpm @./rsp/ifort_release_win
            fi
        else  
            if [ $DEBUG == "Y" ]; then 
               fpm @./rsp/ifort_debug
            else 
               fpm @./rsp/ifort_release
            fi
        fi
      
      cd ./Src
      mv CFML_GlobalDeps.f90 CFML_GlobalDeps_Linux_Intel.xxx
      cd ..
    fi 
#
#  Block if-then-else for compiler "ifx"
#
#
    if [ $COMP == "ifx" ]; then
      cd ./Src
      mv  CFML_GlobalDeps_Linux_Intel.xxx  CFML_GlobalDeps.f90
      cd ..
        if [ $WINT == "win" ]; then 
            if [ $DEBUG == "Y" ]; then 
               fpm @./rsp/ifx_debug_win
            else  
               fpm @./rsp/ifx_release_win
            fi
        else  
            if [ $DEBUG == "Y" ]; then 
               fpm @./rsp/ifx_debug
            else 
               fpm @./rsp/ifx_release
            fi
        fi
      
      cd ./Src
      mv CFML_GlobalDeps.f90 CFML_GlobalDeps_Linux_Intel.xxx
      cd ..
    fi 
#
#  Block if-then-else for compiler "gfortran"
#
#
    if [ $COMP == "gfortran" ]; then
      cd ./Src
      mv  CFML_GlobalDeps_Linux.xxx  CFML_GlobalDeps.f90
      cd ..
        if [ $WINT == "win" ]; then 
            if [ $DEBUG == "Y" ]; then 
               fpm @./rsp/gfortran_debug_win
            else  
               fpm @./rsp/gfortran_release_win
            fi
        else  
            if [ $DEBUG == "Y" ]; then 
               fpm @./rsp/gfortran_debug
            else 
               fpm @./rsp/gfortran_release
            fi
        fi
      
      cd ./Src
      mv CFML_GlobalDeps.f90 CFML_GlobalDeps_Linux.xxx
      cd ..
    fi 
#  
#  Undo the changes in extensions of files that were change above
#
cd ./Src
    if [ $WINT == "win" ]; then
          tochange.sh f90 win
    else
          tochange.sh f90
    fi
cd ..
