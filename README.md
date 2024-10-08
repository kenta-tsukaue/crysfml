CMake is a system used to control the software compilation process using simple platform 
and compiler independent configuration files. CMake generates native makefiles and 
workspaces that can be used in the compiler environment of your choice. 

Here are the instructions to run cmake in order to build the CrysFML library.

1. download and install a recent version of cmake (>= 3.0.0 required)

2. check that the cmake binary directory is in the PATH altogether 
   with the different compilers that will be used for the build.

3. set the environment variable CRYSFML to the directory where the README.md is 
   located.

4. create a directory wherever you want that will contain the files 
   generated during the build (e.g. ${CRYSFML}/build).
   If you intend to do the build as superuser, this directory should 
   give recursively the writing rights for every user.     
   Now you are ready for the cmake run that will configure your build.
    
5. change directory to the build directory created in step 4.
 
6. the CMake usage is:
      
      cmake -G generator -Dvariable=value path_to_your_source_directory

   generator:
      CMake requires to know for which build tool it shall generate 
      files (GNU make, Visual Studio, Xcode, etc). If not specified 
      on the command line, it tries to guess it based on you 
      environment. Once identified the build tool, CMake uses the 
      corresponding Generator for creating files for your build tool. 
      You can explicitly specify the generator with the command line 
      option -G "Name of the generator".
         
      For knowing the available generators on your platform, execute
   
         cmake --help
       
      This will list the generator's names at the end of the help text. 
      Take care the generator's names are case-sensitive.
   
      For standard console Makefiles the generator should be:
         - "NMake Makefiles" on Windows
         - "Unix Makefiles" on Linux
           
   variable:
      Variables customize how the build will be generated.
       
      Useful CMake variables (case sensitive):
       
         * USE_HDF: ON|OFF. (Deprecated)
           Default OFF
           If ON, CrysFML will be able to read NeXuS input data files.
           
         * GUI: ON|OFF.
           Default OFF
           If OFF, only CrysFML will be built.
           If ON, both CrysFML and WCrysFML libraries will be built

	       * ARCH32: ON|OFF
	        Default ON
	        If ON 32-bits architecture is built

	       * HEAP_ARRAYS: ON|OFF
	        Default OFF
	        Put arrays in heap instead of stack (only for Windows ifort)

	       * PYTHON_API: ON|OFF
	        Default OFF
	        If ON, build the Python API

         * CMAKE_Fortran_COMPILER: ifort|g95|gfortran.
           Default ifort.
           Sets the compiler to use for the build.

         * CMAKE_BUILD_TYPE: Release|Debug|RelWithDebInfo|MinSizeRel.
           Default Release.
           Sets the build type for make based generators.
           
         * CMAKE_INSTALL_PREFIX
           Default /usr/lib/libcrysfml (Unix) C:\Program Files\libcrysfml (Windows).
           Path where the library will be installed if "make install" is invoked or the 
           "INSTALL" target is built.

         * CRYSFML_PREFIX
           Default crysfml.
           Sets the name of the subdirectory within CMAKE_INSTALL_PREFIX where 
           crysfml will be installed.

         * WCRYSFML_PREFIX
           Default wcrysfml.
           Sets the name of the subdirectory within CMAKE_INSTALL_PREFIX where 
           wcrysfml will be installed.

           
7. the final step is now to build and install the library. The command to invoke will 
   depend on the generator used for the build.

   Examples:
      - Unix: make install
      - Window: nmake install




