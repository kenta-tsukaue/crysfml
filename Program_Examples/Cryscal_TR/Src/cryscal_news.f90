!     Last change:  TR   17 Jul 2007    4:52 pm
subroutine write_cryscal_NEWS(input_string)
 use cryscal_module, only : news_year, expert_mode, debug_proc
 USE IO_module, ONLY : write_info

  implicit none
   character (len=*), intent(in) :: input_string

  if(debug_proc%level_2)  call write_debug_proc_level(2, "write_cryscal_news ("//trim(input_string)//")")
   
  call write_cryscal_news_line(input_string,  '')
  call write_cryscal_news_line(input_string,  '  Main new features implemented in CRYSCAL:')
  call write_cryscal_news_line(input_string,  '  (for more details, see the CRYSCAL manual (MAN keyword))')
  call write_cryscal_news_line(input_string,  ' ')
  call write_cryscal_news_line(input_string,  '  T. Roisnel / CDIFX - ISCR Rennes')
  call write_cryscal_news_line(input_string,  '')

  if(news_year(1:3) == 'all' .or. news_year(1:2) == '14' .or. news_year(1:4) == '2014') then
   call write_cryscal_news_line(input_string,  '')
   call write_cryscal_news_line(input_string,  '   . June 14 :') 
   call write_cryscal_news_line(input_string,  '     # "create_PAT_PRF" field has been added in the "[COMMAND LINE ARGUMENTS]"')
   call write_cryscal_news_line(input_string,  '       part in the setting file (cryscal.ini) : X-ray diffraction pattern')
   call write_cryscal_news_line(input_string,  '       is then created (PRF file FullProf format) after reading a CIF file.')
   call write_cryscal_news_line(input_string,  '')
   call write_cryscal_news_line(input_string,  '')
   call write_cryscal_news_line(input_string,  '   . May 14 :') 
   call write_cryscal_news_line(input_string,  '     # Corrections of bugs caused by the new CRYSFML library')
   call write_cryscal_news_line(input_string,  '       specially in bond distribution routine')
   call write_cryscal_news_line(input_string,  '     # New arguments for CONN keyword:')
   call write_cryscal_news_line(input_string,  '        . ANG : interatomic angle calculation')
   call write_cryscal_news_line(input_string,  '        . CONDENSED : short output')
   call write_cryscal_news_line(input_string,  '')
   call write_cryscal_news_line(input_string,  '   . March 14 :') 
   call write_cryscal_news_line(input_string,  '     # ALL_X argument for CONN keyword:')
   call write_cryscal_news_line(input_string,  '       output atomic connectivity for all atoms')
   call write_cryscal_news_line(input_string,  '       of the X species.')
   call write_cryscal_news_line(input_string,  '       ex: CONN ALL_Cu')   
   call write_cryscal_news_line(input_string,  '     # in_A argument for WRITE_ATOMS keyword:')
   call write_cryscal_news_line(input_string,  '       Atomic coordinates are listes in A')
   call write_cryscal_news_line(input_string,  '     # VOL argument for CONN keyword:')
   call write_cryscal_news_line(input_string,  '       polyedron volume calculation, based on VOLCAL program')
   call write_cryscal_news_line(input_string,  '       of L. W. FINGER, included in CFML')
   call write_cryscal_news_line(input_string,  '')
   call write_cryscal_news_line(input_string,  '   . Feb 14 :') 
   call write_cryscal_news_line(input_string,  '     # BARY keyword:')
   call write_cryscal_news_line(input_string,  '       Centroid calculation can be applied with only 2 input atoms')
   call write_cryscal_news_line(input_string,  '     # Bug has been corrected in the HTML report combined with ')
   call write_cryscal_news_line(input_string,  '       SQUEEZE option.')   
  end if
  
  if(news_year(1:3) == 'all' .or. news_year(1:2) == '13' .or. news_year(1:4) == '2013') then
   call write_cryscal_news_line(input_string,  '')
   call write_cryscal_news_line(input_string,  '   . Nov 13 :') 
   call write_cryscal_news_line(input_string,  '     # STAR_K keyword:')
   call write_cryscal_news_line(input_string,  '       Apply rotational parts of the symmetry operators of a given')
   call write_cryscal_news_line(input_string,  '       space group on the components of a propagation wave')
   call write_cryscal_news_line(input_string,  '       vector.')

   call write_cryscal_news_line(input_string,  '')
   call write_cryscal_news_line(input_string,  '   . Oct 13 :') 
   call write_cryscal_news_line(input_string,  '     # CONN keyword:')
   call write_cryscal_news_line(input_string,  '       . new argument for GEN_HKL keyword : PM2K')
   call write_cryscal_news_line(input_string,  '         PM2K_hkl.inp is created : its contains hkl reflections list')
   call write_cryscal_news_line(input_string,  '         to be copied in the input file for PM2K program (M. Leoni).')
   call write_cryscal_news_line(input_string,  '       . new MIN= and MAX= arguments (default values are defined')
   call write_cryscal_news_line(input_string,  '         in cryscal.ini setting file ([PARAMETERS] section)')
   call write_cryscal_news_line(input_string,  '       . calculation of effective interatomic distances')
   
   

   call write_cryscal_news_line(input_string,  '')
   call write_cryscal_news_line(input_string,  '   . Sept 13 :') 
   call write_cryscal_news_line(input_string,  '     # new SELF argument for CONN keyword: output interatomic')
   call write_cryscal_news_line(input_string,  '       distance only between atoms with same labels.')
   call write_cryscal_news_line(input_string,  '       This can be useful for M-M distances in a organometallic complex.')   
   call write_cryscal_news_line(input_string,  '     # New READ_FACES keyword : read crystal habitus .')
   call write_cryscal_news_line(input_string,  '       ex. : READ_FACES absorb.ins')
   call write_cryscal_news_line(input_string,  '       ex. : READ_FACES faces.Def')
   
   
    
   call write_cryscal_news_line(input_string,  '')

   call write_cryscal_news_line(input_string,  '')
   call write_cryscal_news_line(input_string,  '   . July 13 :') 
   call write_cryscal_news_line(input_string,  '     # New DHA keyword : calculation of H position given donor and')
   call write_cryscal_news_line(input_string,  '       acceptor atoms.')
   
   call write_cryscal_news_line(input_string,  '     # Change in MENDEL argument that can be atomic number.:')
   call write_cryscal_news_line(input_string,  '       ex: MENDEL 59')
    
   call write_cryscal_news_line(input_string,  '')
   call write_cryscal_news_line(input_string,  '   . May 13 :') 
   call write_cryscal_news_line(input_string,  '     # READ_INS keyword: by default, Q peaks are not read.')
   call write_cryscal_news_line(input_string,  '       Q_PEAKS argument has to be specified for not skipping Q peaks')

   call write_cryscal_news_line(input_string,  '')
   call write_cryscal_news_line(input_string,  '   . April 13 :') 
   
   call write_cryscal_news_line(input_string,  '     # new arguments for CREATE_FST keyword:')
   call write_cryscal_news_line(input_string,  '       MOLE : space group line is commented to draw')
   call write_cryscal_news_line(input_string,  '       only atoms of the asymmetric unit cell')
   call write_cryscal_news_line(input_string,  '       No_H : Hydrogen atoms and related bonds are excluded from the ')
   call write_cryscal_news_line(input_string,  '              drawing (lines are commented).')
   call write_cryscal_news_line(input_string,  '       No_H argument is valid only with MOLE argument')
   call write_cryscal_news_line(input_string,  '       POLY : includes polyedra drawing in Fp_Studio if connectivity')
   call write_cryscal_news_line(input_string,  '              calculations have been performed')
   call write_cryscal_news_line(input_string,  '       RUN  : launch FP_Studio')
   
   call write_cryscal_news_line(input_string,  '     # argument "CART" after the "WRITE_ATOMS" keyword outputs the')
   call write_cryscal_news_line(input_string,  '       cartesian coordinates of the atoms. Cartesian frame type can')
   call write_cryscal_news_line(input_string,  '       be specified by "CART_A" (x//a) and "CART_C" (x//c). ')
   call write_cryscal_news_line(input_string,  '     # argument "SHAPE" after the "CONN" keyword creates an input')
   call write_cryscal_news_line(input_string,  '       for SHAPE programm (http://www.ee.ub.es/)')
   call write_cryscal_news_line(input_string,  '       derivative SHAPE arguments : SHAPE_A (a//x), SHAPE_C (x//c)')
   call write_cryscal_news_line(input_string,  '     # Cartesian frame type (A: x//a or C: x//c) can be specified in the')
   call write_cryscal_news_line(input_string,  '       setting file, through the "cartesian_frame_type" keyword in the')
   call write_cryscal_news_line(input_string,  '       [OPTIONS] section. Default value for the cartesian frame is A (x//a)')
   
   
   call write_cryscal_news_line(input_string,  '     # argument "CART" after the "WRITE_CELL" keyword outputs the')
   call write_cryscal_news_line(input_string,  '       cartesian frame, metric tensors and Busing-Levy B-matrix. Cartesian')
   call write_cryscal_news_line(input_string,  '       frame type can be specified by "CART_A" (x//a) and "CART_C" (x//c).')
   call write_cryscal_news_line(input_string,  '       argument.')
   
	
   if(expert_mode) then    
    call write_cryscal_news_line(input_string,  '     # DEBUG, DEBUG_2 and DEBUG_3 keywords : access to debug modes and create')
	call write_cryscal_news_line(input_string,  '       cryscal_debug.txt file. In level_2 debug mode, this file contains')
	call write_cryscal_news_line(input_string,  '       the name of main called routines. In level_3 mode, this file')
	call write_cryscal_news_line(input_string,  '       contains more explanations.') 
	call write_cryscal_news_line(input_string,  '       [only in EXPERT mode]') 
   endif

   call write_cryscal_news_line(input_string,  '')
   call write_cryscal_news_line(input_string,  '   . March 13 :')   
   call write_cryscal_news_line(input_string,  '     # New keywords related to TIDY software (standardisation of inorganic')
   call write_cryscal_news_line(input_string,  '       crystal-structure data (Acta Cryst. 1984, A40, 169-183):')
   call write_cryscal_news_line(input_string,  '       - CREATE_TIDY   : create input file for TIDY from a .CIF or .INS file')
   call write_cryscal_news_line(input_string,  '       - READ_TIDY_out : read output file from TIDY (default name = stidy.out)')
   
   call write_cryscal_news_line(input_string,  '')
   call write_cryscal_news_line(input_string,  '   . Feb. 13 :')   
   call write_cryscal_news_line(input_string,  '     # CONN keyword can have BVS argument for Bond Valence Sum Calculation.')
   call write_cryscal_news_line(input_string,  '       Oxidation state of the input atoms have to be provided trough the ')
   call write_cryscal_news_line(input_string,  '       ATOM keyword.')
   call write_cryscal_news_line(input_string,  '       ex: ATOM Fe1 Fe+3 0.11 0.22 0.33 0.4 1.')
   call write_cryscal_news_line(input_string,  '       example of CFL file : ')
   call write_cryscal_news_line(input_string,  '         http:\\www.cdifx.univ-rennes1.fr\cryscal\cryscal_y2o3_bvs.cfl')
   call write_cryscal_news_line(input_string,  "     # Final.y file (coming from EVALCCD) are not read anymore, since they")
   call write_cryscal_news_line(input_string,  "       don't contain structure factors.")
   call write_cryscal_news_line(input_string,  '     # Connectivity calculation outputs symmetry operators used to generate')
   call write_cryscal_news_line(input_string,  '       atoms around a particular one. CFML has been modified to output this')
   call write_cryscal_news_line(input_string,  '       list.')
   call write_cryscal_news_line(input_string,  '     # Profile (U, V, W, eta0, eta1) and pattern (step, constant background, ')
   call write_cryscal_news_line(input_string,  '       scale factor) parameters can be specified in the [PATTERN SIMULATION]')   
   call write_cryscal_news_line(input_string,  '       section of the cryscal.ini setting file, for X-ray and neutron pattern')   
   call write_cryscal_news_line(input_string,  '       calculation.')     
   
   
   call write_cryscal_news_line(input_string,  '')
   call write_cryscal_news_line(input_string,  '   . Jan. 13 :')
   call write_cryscal_news_line(input_string,  '     # When creating archive_cryscal.cif file, CRYSCAL is looking for ')   
   call write_cryscal_news_line(input_string,  '       output files creating by different versions of SQUEEZE procedure ')   
   call write_cryscal_news_line(input_string,  '       in PLATON, as platon.sqf or platon_sqr.sqf (PLATON jan. 2013)')   
   call write_cryscal_news_line(input_string,  '     # New argument for GEN_HKL for powder diffraction pattern calculation : ')
   call write_cryscal_news_line(input_string,  '       particle size (in A) can be specified through the "SIZE=" keyword.')
   call write_cryscal_news_line(input_string,  '       If not, particle size is considered as infinite and ')
   call write_cryscal_news_line(input_string,  '       no line broadening is calculated.')
   call write_cryscal_news_line(input_string,  '       Example : GEN_HKl 2theta_min=20 2theta_max=120 PAT SIZE=250')
   call write_cryscal_news_line(input_string,  '       Example of CFL file : ')
   call write_cryscal_news_line(input_string,  '         http:\\www.cdifx.univ-rennes1.fr\cryscal\cryscal_si_x_100.cfl')
  
   call write_cryscal_news_line(input_string,  '     # Import.cif file can be created from .P4P file and .RAW file (output of')
   call write_cryscal_news_line(input_string,  '       SAINT program). This has to be specified in the command line through')
   call write_cryscal_news_line(input_string,  '       the "RAW=" keyword.')
   call write_cryscal_news_line(input_string,  '       Example:')
   call write_cryscal_news_line(input_string,  '         d:\data\CRYSCAL file_0m.P4P RAW=file_0m.RAW')
   
   call write_cryscal_news_line(input_string,  '     # New "DIST_X" and "DIST_PLUS" keywords allow to calculate the coordinates ')
   call write_cryscal_news_line(input_string,  '       of a particular point aligned with with the input atoms')
   
  end if
  
  if(news_year(1:3) == 'all' .or. news_year(1:2) == '12' .or. news_year(1:4) == '2012') then
   call write_cryscal_news_line(input_string,  '')
   call write_cryscal_news_line(input_string,  '   . Dec. 12 :')
   call write_cryscal_news_line(input_string,  '     # New "FRIEDEL" keyword allows to get number pairs of Friedel')
   call write_cryscal_news_line(input_string,  '       in hkl file')
   
   
   call write_cryscal_news_line(input_string,  '')
   call write_cryscal_news_line(input_string,  '   . Nov. 12 :')
   call write_cryscal_news_line(input_string,  '     # Particular format for .hkl file (h,k,l F2, sig) can be specified')
   call write_cryscal_news_line(input_string,  '       in the setting file in the [OPTIONS] section through the')
   call write_cryscal_news_line(input_string,  '       hkl_format keyword.')
   call write_cryscal_news_line(input_string,  '       example hkl_format = 3i4,2F15.2')
   call write_cryscal_news_line(input_string,  '       If not specified, default format is : 3I4,2F8.2 (SHELX format)')
   
   call write_cryscal_news_line(input_string,  '     # new argument for WRITE_SYMM keyword : if argument="SHELX"')
   call write_cryscal_news_line(input_string,  '       the list of symmetry operators is output in a SHELX format')
   call write_cryscal_news_line(input_string,  '     # news arguments for SITE_INFO keyword : ')
   call write_cryscal_news_line(input_string,  '        . if argument="PCR", the list of symetry equivalent atoms')
   call write_cryscal_news_line(input_string,  '          is output in a FullProf format (.PCR)')
   call write_cryscal_news_line(input_string,  '        . if argument="PCR_MAG", the list of magnetic atoms')
   call write_cryscal_news_line(input_string,  '          is output in a FullProf format (.PCR)')

  
   call write_cryscal_news_line(input_string,  '')
   call write_cryscal_news_line(input_string,  '   . Oct. 12 :')
   call write_cryscal_news_line(input_string,  '     # "CIF file for Pymol can be created by putting "PYMOL" as' )
   call write_cryscal_news_line(input_string,  '       argument of "READ_CIF", "READ_INS" and "READ_CEL"')
   call write_cryscal_news_line(input_string,  '       keywords (example: FILE file.cif pymol) or in the command line')
   call write_cryscal_news_line(input_string,  '       with a cif.file (example: d:\cryscal file.cif pymol')
   call write_cryscal_news_line(input_string,  '       "create_CIF_PYMOL" keyword (value = 0/1) can also be specified')
   call write_cryscal_news_line(input_string,  '       in the cryscal.ini setting file : file_pml.cif file is then')
   call write_cryscal_news_line(input_string,  '       automatically created after reading a CIF file.')
   

   call write_cryscal_news_line(input_string,  '     # "Skip_start_menu" keyword (value = 0/1) can be input in the cryscal.ini')
   call write_cryscal_news_line(input_string,  '       setting file to skip the starting main menu of CRYSCAL. ')

   call write_cryscal_news_line(input_string,  '     # HTML structural report: torsion angles values greater')
   call write_cryscal_news_line(input_string,  '      than CIF_torsion_limit are excluded. Default value')
   call write_cryscal_news_line(input_string,  '      for CIF_torsion_limit is 170.0 but can be defined in the')
   call write_cryscal_news_line(input_string,  '      cryscal.ini setting file in the [OPTIONS] section')
   
   call write_cryscal_news_line(input_string,  '     # Special format can be specified with the FILE keyword')
   call write_cryscal_news_line(input_string,  '      when reading .hkl file, with the FMT argument. ')
   call write_cryscal_news_line(input_string,  '       Example : FILE filename.hkl fmt=3I4,2F15.2')
   
   call write_cryscal_news_line(input_string,  '')
   call write_cryscal_news_line(input_string,  '   . Sept 12 :')
   call write_cryscal_news_line(input_string,  '     # new argument for BARY keyword')
   call write_cryscal_news_line(input_string,  '     # "HKL_statistics" keyword (value = 0/1) can be input in the cryscal.ini')
   call write_cryscal_news_line(input_string,  '       setting file to output or not statistics on hkl reflections. ')
     
   if(expert_mode) then
    call write_cryscal_news_line(input_string,  '     # Export mode can be specified in the setting file through the expert_mode')
    call write_cryscal_news_line(input_string,  '       string in the setting file. If active, this mode allows to enter new ')
    call write_cryscal_news_line(input_string,  '       specific keywords. This mode can also be activated through the ')
    call write_cryscal_news_line(input_string,  '       "EXPERT_MODE" keyword and put OFF with "USER_mode" keyword.')
    call write_cryscal_news_line(input_string,  '       Examples:')
    call write_cryscal_news_line(input_string,  '        FIC   : "FILE import.cif"')
    call write_cryscal_news_line(input_string,  '        ST25  : "SHELL THETA 2.5 25"')
    call write_cryscal_news_line(input_string,  '       MAN_EXPERT keyword has been added to output the list of instructions in ')
    call write_cryscal_news_line(input_string,  '       this expert mode.')
    call write_cryscal_news_line(input_string,  '       The list of expert mode keywords can be output through the "MAN_EXPERT" ')
    call write_cryscal_news_line(input_string,  '       keyword if this kind of mode is activated.')
	call write_cryscal_news_line(input_string,  '       [only in EXPERT mode]') 
   endif
  
   call write_cryscal_news_line(input_string,  '')
   call write_cryscal_news_line(input_string,  '   . July 12 :')
   call write_cryscal_news_line(input_string,  '     # FILE keyword: .COL file created by COLL5 (ILL / format =4)')
   call write_cryscal_news_line(input_string,  '                      can be read')
   call write_cryscal_news_line(input_string,  '     # FILE keyword: .INT file created by DATARED can be read')
   call write_cryscal_news_line(input_string,  '     # CELL keyword: .RED file for DATARED can be read')
   
   if(expert_mode) then   
   call write_cryscal_news_line(input_string,  '     # REPORT_LATEX argument can be specified when launching CRYSCAL')
   call write_cryscal_news_line(input_string,  '       for the command line. In such a case: ')
   call write_cryscal_news_line(input_string,  '       . structural_report.ltx file is created, in a LATEX format')   
   call write_cryscal_news_line(input_string,  '       . pdflatex is launched to create a .pdf file.')
   call write_cryscal_news_line(input_string,  '         If a .GIF file is present in the current folder for crystal')
   call write_cryscal_news_line(input_string,  '         structure visualisation, it is first converted in .png file')
   call write_cryscal_news_line(input_string,  '         to be included in the final pdf document.')
   call write_cryscal_news_line(input_string,  '       [only in EXPERT mode]') 
  endif  
   
   

   call write_cryscal_news_line(input_string,  "     # New OUT_n argument for FILE keyword, allowing to output every")
   call write_cryscal_news_line(input_string,  "       n reflection features (index, h,k,l,F2,sig)")
     
   call write_cryscal_news_line(input_string,  '')
   call write_cryscal_news_line(input_string,  '   . June 12 :')
   call write_cryscal_news_line(input_string,  "     # SHIFT_2TH keyword can now be followed by three values, ")
   call write_cryscal_news_line(input_string,  "       corresponding to a constant, cos and sin dependent shifts")
   call write_cryscal_news_line(input_string,  "       respectively.")
   
   call write_cryscal_news_line(input_string,  "     # css files for structural HTML report and user's guide")
   call write_cryscal_news_line(input_string,  "       are now available in the CRYSCAL folder (repertory that")
   call write_cryscal_news_line(input_string,  "       contains the crysal.ini setting file. If present, these" )
   call write_cryscal_news_line(input_string,  "       css files, called cryscal_report.css and cryscal.css")   
   call write_cryscal_news_line(input_string,  "       for report and user's guide respectively, can be edited")
   call write_cryscal_news_line(input_string,  "       and modified by the user. These css files contains")
   call write_cryscal_news_line(input_string,  "       styles that are used in the HTML documents.")
   

  
   call write_cryscal_news_line(input_string,  '')
   call write_cryscal_news_line(input_string,  '   . April 12 :')
   call write_cryscal_news_line(input_string,  '     # MOVE/TRANSLATE keyword accepts 4 arguments, as the MOVE')
   call write_cryscal_news_line(input_string,  '       instruction on SHELXL. Optional 4th argument corresponds to')
   call write_cryscal_news_line(input_string,  '       the sign to multiply atomic coordinates. New atomic' )
   call write_cryscal_news_line(input_string,  '       are then : sign*x + t_x, sign*y + t_z, sign*z + t_z')   
   call write_cryscal_news_line(input_string,  '       If input 3 arguments are given, they correspond to the')
   call write_cryscal_news_line(input_string,  '       t_x, t_y and t_z translation and the 4th argument is')
   call write_cryscal_news_line(input_string,  '       taken equal to +1.')

  
   call write_cryscal_news_line(input_string,  '')
   call write_cryscal_news_line(input_string,  '   . March 12 :')
   call write_cryscal_news_line(input_string,  '     # GET argument can be input with SEARCH_GROUP keyword:')   
   call write_cryscal_news_line(input_string,  '       the most probable space group is then considered')
   call write_cryscal_news_line(input_string,  '     # Cell parameters are deduced from UB matrix when P4P file or')
   call write_cryscal_news_line(input_string,  '       import.cif file contain this information. Use WRITE_CELL')
   call write_cryscal_news_line(input_string,  '       keyword to output these cell parameters.')


   call write_cryscal_news_line(input_string,  '')
   call write_cryscal_news_line(input_string,  '   . January 12 :')
   call write_cryscal_news_line(input_string,  '     # CRYSCAL has been compiled with the new CRYSFML library')   
   call write_cryscal_news_line(input_string,  '     # MOVE instruction for SHELXL (output of SG_INFO for acentric')
   call write_cryscal_news_line(input_string,  '       space group) is now correct for non conventional settings')
  endif


  if(news_year(1:3) == 'all' .or. news_year(1:2) == '11' .or. news_year(1:4) == '2011') then
  call write_cryscal_news_line(input_string,  '')
  call write_cryscal_news_line(input_string,  '   . December 11 :')
  call write_cryscal_news_line(input_string,  '     # Some minor changes have been performed in the code to be compiled ')
  call write_cryscal_news_line(input_string,  '       with Intel Fortran Compiler')
  call write_cryscal_news_line(input_string,  '     # HKL arrays are now dimensionned dynamically. Default dimension is')
  call write_cryscal_news_line(input_string,  '       500000 but can be defined by user in the setting file though the')
  call write_cryscal_news_line(input_string,  '       "hkl_reflections" keyword in the [ARRAYS DIMENSIONS] section.')  
  call write_cryscal_news_line(input_string,  '     # "LOCK_wave_value" field can be input in the cryscal.ini setting file to')
  call write_cryscal_news_line(input_string,  '       to define the lock the input wavelength to the value of the closer')
  call write_cryscal_news_line(input_string,  '       Xray target (Cu, Mo ...). if not present in the setting file, the default')
  call write_cryscal_news_line(input_string,  '       value for this field is 0.02.')
  call write_cryscal_news_line(input_string,  '       Examples : ')
  call write_cryscal_news_line(input_string,  '       - input wavelength = 1.53 and LOCK_wave_value = 0.02  : wave_length = 1.5406')
  call write_cryscal_news_line(input_string,  '       - input wavelength = 1.53 and LOCK_wave_value = 0.005 : wave_length = 1.53')
  call write_cryscal_news_line(input_string,  '' )  
  call write_cryscal_news_line(input_string,  '   . November 11 :')
  call write_cryscal_news_line(input_string,  '     # Minor corrections in the HTML report in the "symmetry transformations')
  call write_cryscal_news_line(input_string,  '       used to generate equivalent atoms" parts (distances, angles, torsion ')
  call write_cryscal_news_line(input_string,  '       angles and hydrogen bonds)')
  call write_cryscal_news_line(input_string,  '     # LST_SG keyword : ')
  call write_cryscal_news_line(input_string,  '       - "chiral" and "polar" arguments can se specified to output ')  
  call write_cryscal_news_line(input_string,  '         chiral and polar space groups respectively')
  call write_cryscal_news_line(input_string,  '     # SG_INFO keyword outputs the MOVE instruction for SHELXL')
  call write_cryscal_news_line(input_string,  '       in the case of acentric space groups.')
  call write_cryscal_news_line(input_string,  '     # CRYSCAL has been compiled with last version of CFML (5.00)')  
  call write_cryscal_news_line(input_string,  '      and changes in the space_group routine have been made to be ')  
  call write_cryscal_news_line(input_string,  '      to be in agreement with the CFML library.')
  call write_cryscal_news_line(input_string,  '')
  
  call write_cryscal_news_line(input_string,  '')
  call write_cryscal_news_line(input_string,  '   . October 11 :')
  call write_cryscal_news_line(input_string,  '     # LST_SG keyword : ')
  call write_cryscal_news_line(input_string,  '       - "enantio" argument can se specified to output ')  
  call write_cryscal_news_line(input_string,  '         enantiomorphic space goups')
  call write_cryscal_news_line(input_string,  '       - Point group is output')
  call write_cryscal_news_line(input_string,  '     # MU keyword : explicit keyword to perform absorption coefficient')  
  call write_cryscal_news_line(input_string,  '       calculation. Cell paramaters, wave and cell content has to be')  
  call write_cryscal_news_line(input_string,  '       known. This keyword can be useful after reading of parameters')  
  call write_cryscal_news_line(input_string,  '       from an external file as CIF or INS file.')  
  call write_cryscal_news_line(input_string,  '       ex : READ_CIF UAl2.cif')
  call write_cryscal_news_line(input_string,  '            WAVE X_cu')
  call write_cryscal_news_line(input_string,  '            MU')
  call write_cryscal_news_line(input_string,  '')

  call write_cryscal_news_line(input_string,  '     # DIAG keyword : diagonalization of a 3*3 matrix and ouput Eigen values')  
  call write_cryscal_news_line(input_string,  '                      and Eigen vectors')  
  call write_cryscal_news_line(input_string,  '     # THERM_SHELX keyword : ADP parameters are input in the following')
  call write_cryscal_news_line(input_string,  '       SHELX order, i.e. 11 22 33 23 13 12')
  call write_cryscal_news_line(input_string,  '')

  call write_cryscal_news_line(input_string,  '')
  call write_cryscal_news_line(input_string,  '   . July 11 :')
  call write_cryscal_news_line(input_string,  '     # Up to 5 extra matrices can be provided by the user in the cryscal.ini')
  call write_cryscal_news_line(input_string,  '       setting file in the [USER TRANSFORMATION MATRICES] section. These ')
  call write_cryscal_news_line(input_string,  '       matrices are defined through the "MAT_n" keyword followed by the 9')  
  call write_cryscal_news_line(input_string,  '       components of the matrix m11 m12 m13 m21 m22 m23 m31 m32 m33 .')
  call write_cryscal_news_line(input_string,  '       and a comment text.')
  call write_cryscal_news_line(input_string,  '       New "USER_MAT" keyword has been added to select a particular matrix')
  call write_cryscal_news_line(input_string,  '       provided by the user in the cryscal.ini setting file. ')  
  call write_cryscal_news_line(input_string,  '       The matrix to be selected can be input either by the numor preceded by')
  call write_cryscal_news_line(input_string,  '       the "# symbol, either the comment text preceded by the "$" symbol')
  call write_cryscal_news_line(input_string,  '       Examples : USER_MAT #1')
  call write_cryscal_news_line(input_string,  '                  USER_MAT $2a')
  
  
  call write_cryscal_news_line(input_string,  '     # "include_RES_file" field can be input in the cryscal.ini setting file to')
  call write_cryscal_news_line(input_string,  '       embed the contain of last .res SHELXL file in the archive_cryscal.cif file')
  call write_cryscal_news_line(input_string,  '       to avoid PLAT005_ALERT_5G alert in the CHECK CIF procedure. The SHELXL ')  
  call write_cryscal_news_line(input_string,  '       .res file name corresponds to the last project ID in WinGX.')
  call write_cryscal_news_line(input_string,  '     # After a matrix transformation of atomic coordinates, the list of atoms')
  call write_cryscal_news_line(input_string,  '       is updated with new coordinates.')
  call write_cryscal_news_line(input_string,  '     # Search_group procedure outputs only space groups those Bravais lattice')
  call write_cryscal_news_line(input_string,  '       corresponds to the Bravais lattice contained in the import.cif file')
  call write_cryscal_news_line(input_string,  '     # Include "_symmetry_space_group_name_H-M" string in the import.cif file')
  call write_cryscal_news_line(input_string,  '       created from .P4P and .HKL file')
  
  call write_cryscal_news_line(input_string,  '')
  call write_cryscal_news_line(input_string,  '   . June 11 :')
  call write_cryscal_news_line(input_string,  '     # CRYSCAL has been compiled with new version of CFML (5.00)')

  call write_cryscal_news_line(input_string,  '')
  call write_cryscal_news_line(input_string,  '   . May 11 :')
  call write_cryscal_news_line(input_string,  '     # Bug has been corrected in the structure factor calculation routine')
  call write_cryscal_news_line(input_string,  '     # Total number of electrons is output after CHEM keyword.')
  call write_cryscal_news_line(input_string,  '     # The matrix used for the hexagonal to rhomboedral system was corrupted.')

  call write_cryscal_news_line(input_string,  '')
  call write_cryscal_news_line(input_string,  '   . April 11 :')
  call write_cryscal_news_line(input_string,  '     # Some changes in the routine to get new space group after matrix')
  call write_cryscal_news_line(input_string,  '       transformation')
  call write_cryscal_news_line(input_string,  '     # Some changes in the monoclinic transformation matrix list')
  call write_cryscal_news_line(input_string,  '     # A non systematic bug in the bonds distribution list (CONN keyword)')
  call write_cryscal_news_line(input_string,  '       has been corrected')


  call write_cryscal_news_line(input_string,  '')
  call write_cryscal_news_line(input_string,  '   . Feb. 11 :')
  call write_cryscal_news_line(input_string,  '     # Stucture factors calculation can be performed for electrons')
  call write_cryscal_news_line(input_string,  '       diffraction (GEN_HKL and SF_HKL routines). This has to be')
  call write_cryscal_news_line(input_string,  '       specified by the BEAM keyword and "ELECTRONS" argument')
  call write_cryscal_news_line(input_string,  '     # Some examples of CFL input files can be downloaded from the')
  call write_cryscal_news_line(input_string,  '       CRYSCAL web site (www.cdifx.univ-rennes1.fr/cryscal)')
  call write_cryscal_news_line(input_string,  '     # Some changes in output files :')
  call write_cryscal_news_line(input_string,  '        . cryscal.log is renamed cryscal_debug.txt')
  call write_cryscal_news_line(input_string,  '        . cryscal.out is renamed cryscal.log')
  call write_cryscal_news_line(input_string,  '       LOG argument has been replaced by DEBUG argument')
  call write_cryscal_news_line(input_string,  '     # New PAT argument for GEN_HKL keyword allows to generate a')
  call write_cryscal_news_line(input_string,  '       diffraction pattern. PRF file is automatically plotted')
  call write_cryscal_news_line(input_string,  '       with the WinPLOTR program if installed.')
  call write_cryscal_news_line(input_string,  '     # I/Imax is now calculated in the GEN_HKL routine when working')
  call write_cryscal_news_line(input_string,  '       in the 2theta space and neutron or Cu_K_alpha1 X-ray radiation.')
  call write_cryscal_news_line(input_string,  '       Intensity is calculated as follows:')
  call write_cryscal_news_line(input_string,  '                        I=mult * Lp * F^2')
  call write_cryscal_news_line(input_string,  '       where : mult is the multicicity of the reflection')
  call write_cryscal_news_line(input_string,  '               Lp the Lorentz-polarization factor, calculated by:')
  call write_cryscal_news_line(input_string,  '               Lp=(1-K+K*CTHM*cos2(2theta)/(2sin2(theta)cos(theta)')
  call write_cryscal_news_line(input_string,  '                CTHM=cos2(2theta_monok) [CTHM=0.79]')
  call write_cryscal_news_line(input_string,  '                K=0.  for neutrons')
  call write_cryscal_news_line(input_string,  '                K=0.5 for unpolarized X-ray radiation')

  call write_cryscal_news_line(input_string,  '     # Cosmetic changes in the Fortran codes to allow the compilation')
  call write_cryscal_news_line(input_string,  '       with the free G95 Fortran compiler.')

  call write_cryscal_news_line(input_string,  '')
  call write_cryscal_news_line(input_string,  '   . Jan. 11 :')
  call write_cryscal_news_line(input_string,  '     # CREATE_FST keyword allows to create a .FST file for')
  call write_cryscal_news_line(input_string,  '       FullProf Studio after reading a CIF file.')
  call write_cryscal_news_line(input_string,  '     # "create_FST" field can be input in the "[COMMAND LINE ARGUMENTS]" part ')
  call write_cryscal_news_line(input_string,  '       in the setting file (cryscal.ini)')

  endif

  if(news_year(1:3) == 'all' .or. news_year(1:2) == '10' .or. news_year(1:4) == '2010') then
  call write_cryscal_news_line(input_string,  '')
  call write_cryscal_news_line(input_string,  '   . Dec. 10 :')
  call write_cryscal_news_line(input_string,  '     # New extinction rules for FIND_HKL_LIST keyword:')
  call write_cryscal_news_line(input_string,  '       . hhl with h+l=2n')
  call write_cryscal_news_line(input_string,  '       . hkk with k+h=2n')
  call write_cryscal_news_line(input_string,  '       . hkh with h+k=2n')
  call write_cryscal_news_line(input_string,  '     # Cosmetic changes in archive_cryscal.cif file: in the case')
  call write_cryscal_news_line(input_string,  '       of samples without H atoms, "_atom_sites_solution_hydrogens" and ')
  call write_cryscal_news_line(input_string,  '       "_refine_ls_hydrogen_tretament" cif field lines are removed')

  call write_cryscal_news_line(input_string,  '')
  call write_cryscal_news_line(input_string,  '   . Nov. 10 :')
  call write_cryscal_news_line(input_string,  '     # Connectivity calculations are followed by a bonds distribution list')
  call write_cryscal_news_line(input_string,  '     # Transformation matrix components can be input as fractional values')
  call write_cryscal_news_line(input_string,  '        Example : matrix 1/2 1/2 0.   -1/2 1/2 0. 0. 0. 1')
  call write_cryscal_news_line(input_string,  '     # Cosmetic changes in HTML structural report')
  call write_cryscal_news_line(input_string,  '')
  call write_cryscal_news_line(input_string,  '   . Oct. 10 :')
  call write_cryscal_news_line(input_string,  '     # A threshold value can be given as argument to the SEARCH_GROUP keyword')
  call write_cryscal_news_line(input_string,  '')
  call write_cryscal_news_line(input_string,  '   . Sept. 10 :')
  call write_cryscal_news_line(input_string,  '     # FIND_HKL_list argument value can be negative and allows to search')
  call write_cryscal_news_line(input_string,  '       reflections with opposite rule than for positive value.')
  call write_cryscal_news_line(input_string,  '     # SIR_TO_INS command line argument has been replaced by SOLVE_TO_INS')
  call write_cryscal_news_line(input_string,  '       and allows now to create INS file for SHELXL from SHELXS ouput file')
  call write_cryscal_news_line(input_string,  '       as well as SIRxx output file.)')
  call write_cryscal_news_line(input_string,  '     # CREATE_ACE keyword allows to create a .ACE file for CaRIne')
  call write_cryscal_news_line(input_string,  '       after reading a CIF file.')
  call write_cryscal_news_line(input_string,  '     # "create_CEL" field has been added in the "[COMMAND LINE ARGUMENTS]" part ')
  call write_cryscal_news_line(input_string,  '       in the setting file (cryscal.ini)')
  call write_cryscal_news_line(input_string,  '     # NIGGLI/NIGGLI_CELL keyword has been added and allows to determine')
  call write_cryscal_news_line(input_string,  '       the Niggli cell from any triclinic cell')
  call write_cryscal_news_line(input_string,  '     # [CREATE INS] section has been added in the crysal.ini setting file to')
  call write_cryscal_news_line(input_string,  '       define temperature and thermal parameter threshold to skip atoms')
  call write_cryscal_news_line(input_string,  '       This avoids to enter these values related to the CREATE_INS keyword')
  call write_cryscal_news_line(input_string,  '')
  call write_cryscal_news_line(input_string,  '   . June 10 :')
  call write_cryscal_news_line(input_string,  '     # Bugs in the FIND_HKL_LIST routine has been corrected')
  call write_cryscal_news_line(input_string,  '')
  call write_cryscal_news_line(input_string,  '   . April 10 :')
  call write_cryscal_news_line(input_string,  '     # Some items of the experimental part in the HTML structure report are now' &
                                              //' in italic,')
  call write_cryscal_news_line(input_string,  '       in agreement with published articles.')
  call write_cryscal_news_line(input_string,  '')
  call write_cryscal_news_line(input_string,  '   . March 10 :')
  call write_cryscal_news_line(input_string,  '     # WRITE_DEVICE keyword')
  call write_cryscal_news_line(input_string,  '     # WRITE_HKL keyword has been replaced by FIND_HKL_LIST.')
  call write_cryscal_news_line(input_string,  '       The SUPPRESS/REMOVE argument for FIND_HKL_LIST keyword')
  call write_cryscal_news_line(input_string,  '       has been added, leading to the creation of a new file free of ')
  call write_cryscal_news_line(input_string,  '       data obeying the current selection rule.')
  call write_cryscal_news_line(input_string,  '     # QVEC components can be input as fractionnal values.')
  call write_cryscal_news_line(input_string,  '       The following fractionnal absolute values are : ')
  call write_cryscal_news_line(input_string,  '       1/2, 1/3, 2/3, 1/4, 3/4, 1/5, 2/5, 3/5, 4/5, 1/6, 5/6,')
  call write_cryscal_news_line(input_string,  '       1/7, 2/7, 3/7, 4/7, 5/7, 6/7, 1/8, 3/8, 5/8, 7/8,')
  call write_cryscal_news_line(input_string,  '       1/9, 2/9, 4/9, 5/9, 7/9 and 8/9')
  call write_cryscal_news_line(input_string,  '     # GEN_HKL keyword leads to a structure factor calculation if atoms')
  call write_cryscal_news_line(input_string,  '       has been input.')
  call write_cryscal_news_line(input_string,  '     # SF_HKL keyword leads to a structure factor calculation for')
  call write_cryscal_news_line(input_string,  '       a given hkl reflection')
  call write_cryscal_news_line(input_string,  '     # New WRITE_BEAM and WRITE_QVEC keywords')
  call write_cryscal_news_line(input_string,  '')
  call write_cryscal_news_line(input_string,  '   . Feb. 10:')
  call write_cryscal_news_line(input_string,  '     # CREATE_CEL keyword allows to create a .CEL file for PowderCELL')
  call write_cryscal_news_line(input_string,  '       after reading a CIF file.')
  call write_cryscal_news_line(input_string,  '     # CREATE_INS keyword allows to create a .INS file for SHELXL')
  call write_cryscal_news_line(input_string,  '       after reading a CIF file.')
  call write_cryscal_news_line(input_string,  '     # CREATE_CFL keyword allows to create a .CFL file for CRYSCAL')
  call write_cryscal_news_line(input_string,  '       after reading a CIF file.')
  call write_cryscal_news_line(input_string,  '     # New "[COMMAND LINE ARGUMENTS]" part in the setting file (cryscal.ini)')
  call write_cryscal_news_line(input_string,  '       with the following fields :')
  call write_cryscal_news_line(input_string,  '        . create_CEL')
  call write_cryscal_news_line(input_string,  '        . create_INS')
  call write_cryscal_news_line(input_string,  '        . create_CFL')
  call write_cryscal_news_line(input_string,  '       Putting the corresponding values to 1 will create .CEL, .INS and .CFL')
  call write_cryscal_news_line(input_string,  '       respectively.')
  call write_cryscal_news_line(input_string,  '     # cryscal file.p4p: if crystal faces are present in the .P4P file,')
  call write_cryscal_news_line(input_string,  '        they are extracted and saved in the import.cif.')
  call write_cryscal_news_line(input_string,  '')
  call write_cryscal_news_line(input_string,  '   . Jan. 10:')
  call write_cryscal_news_line(input_string,  '     # Bug in _trans.HKL file has been corrected.')
  call write_cryscal_news_line(input_string,  '')
  endif

  if(news_year(1:3) == 'all' .or. news_year(1:2) == '09' .or. news_year(1:4) == '2009') then
  call write_cryscal_news_line(input_string,  '   . Nov. 09:')
  call write_cryscal_news_line(input_string,  '     # If a "platon_ortep.gif" file is present in the current folder, it is')
  call write_cryscal_news_line(input_string,  '       automatically incorporated in the HTML report file')
  call write_cryscal_news_line(input_string,  '     # If final.y file contains QVEC field and related parameters, ')
  call write_cryscal_news_line(input_string,  '       a hklm file is created')

  call write_cryscal_news_line(input_string,  '')
  call write_cryscal_news_line(input_string,  '   . Oct. 09:')
  call write_cryscal_news_line(input_string,  '     # If a hkl file is input, the transformed hkl file is')
  call write_cryscal_news_line(input_string,  '       loaded automatically after MATRIX keyword')
  call write_cryscal_news_line(input_string,  '     # Shannon table value for magnesium is corrected (Mg+2)')
  call write_cryscal_news_line(input_string,  "     # Cosmetic changes in the HTML documents (report and user's guide) created")
  call write_cryscal_news_line(input_string,  '       by CRYSCAL.')
  call write_cryscal_news_line(input_string,  '     # Space group number has been added in the HTML report')
  call write_cryscal_news_line(input_string,  '     # SHELX reference has been changed to : ')
  call write_cryscal_news_line(input_string,  '       G. M. Sheldrick, Acta Cryst A, 2008, A64, 112-122')
  call write_cryscal_news_line(input_string,  '')
  call write_cryscal_news_line(input_string,  '   . Sept. 09:')
  call write_cryscal_news_line(input_string,  '     # TWIN_PSEUDO_HEXA keyword')
  call write_cryscal_news_line(input_string,  '     # TWIN_HEXA keyword')
  call write_cryscal_news_line(input_string,  '     # Bugs in the routine to create the archive_cryscal.cif file has ')
  call write_cryscal_news_line(input_string,  '       been corrected, specially when the archive.cif file is created')
  call write_cryscal_news_line(input_string,  '       from the "create CIF / ACTA-C" procedure in WinGX, where the ')
  call write_cryscal_news_line(input_string,  '       order of some CIF fields is changed.')
  call write_cryscal_news_line(input_string,  '     # CRYSCAL has been compiled with new version of CFML (4.00)')
  call write_cryscal_news_line(input_string,  '     # Bugs in the connectivity calculation routine has been corrected')
  call write_cryscal_news_line(input_string,  '')
  call write_cryscal_news_line(input_string,  '   . Feb. 09:')
  call write_cryscal_news_line(input_string,  '     # CHECK_GROUP can now determine trigonal space group')
  call write_cryscal_news_line(input_string,  '     # SG_ALL keyword output sub-groups of the current space group')
  call write_cryscal_news_line(input_string,  '')
  call write_cryscal_news_line(input_string,  '   . Jan. 09:')
  call write_cryscal_news_line(input_string,  '     # .RAW file can be given as argument in the command line')
  call write_cryscal_news_line(input_string,  '       i.e. d:\> CRYSCAL my_file.RAW')
  call write_cryscal_news_line(input_string,  '       CRYSCAL is then reading my_file.RAW and will create a')
  call write_cryscal_news_line(input_string,  '       my_file_RAW.HKL file in a SHELX format. This file also contains')
  call write_cryscal_news_line(input_string,  '       dir. cos. for further absorption correction.')
  call write_cryscal_news_line(input_string,  '       Same behavior can be optained by associating a selected RAW file to')
  call write_cryscal_news_line(input_string,  '       CRYSCAL program in the Windows file folder')
  end if
  if(news_year(1:3) == 'all' .or. news_year(1:2) == '08' .or. news_year(1:4) == '2008') then
  call write_cryscal_news_line(input_string,  '')
  call write_cryscal_news_line(input_string,  '   . Nov. 08:')
  call write_cryscal_news_line(input_string,  '     # GEN_HKL accepts now Q_min and Q_max arguments')
  call write_cryscal_news_line(input_string,  '     # SEARCH_HKL arguments can be h, k or l letters.')
  call write_cryscal_news_line(input_string,  '       ex: SEARCH_HKL h 0 0')
  call write_cryscal_news_line(input_string,  '           SEARCH_HKL 1 k 0')
  call write_cryscal_news_line(input_string,  '     # SITE_INFO keyword gets constraints on anisotropic ADP, using the')
  call write_cryscal_news_line(input_string,  '       routine implemented in FullProf')
  call write_cryscal_news_line(input_string,  '     # new available arguments for CRYSCAL in command line:')
  call write_cryscal_news_line(input_string,  '       - LOG    : create a cryscal.log file')
  call write_cryscal_news_line(input_string,  '       - NO_OUT : no output information are written on screen')
 !call write_cryscal_news_line(input_string,  '       - CIFDEP : combined with ARCHIVE.CIF, author name and address'
 !call write_cryscal_news_line(input_string,  '                  are stored in the cryscal_archive.cif file')
 !call write_cryscal_news_line(input_string,  '       - ACTA   : combined with ARCHIVE.CIF, several CIF fields related')
 !call write_cryscal_news_line(input_string,  '                  to CIF file deposition are stored in the')
 !call write_cryscal_news_line(input_string,  '                  cryscal_archive.cif file')
  call write_cryscal_news_line(input_string,  '')
  call write_cryscal_news_line(input_string,  '   . oct. 08:')
  call write_cryscal_news_line(input_string,  '     # CRYSCAL archive.cif : for archive.cif files created with the new version of')
  call write_cryscal_news_line(input_string,  '       WinGX (sept. 2008), CRYSCAL is skipping the whole part of the cif file ')
  call write_cryscal_news_line(input_string,  '       containing programs references, to created the cryscal_archive.cif file')
  call write_cryscal_news_line(input_string,  ' ')
  call write_cryscal_news_line(input_string,  '     # new argument for CRYSCAL in command line : CRYSCAL CREATE_INS/SIR_TO_INS')
  call write_cryscal_news_line(input_string,  '       Create job.ins file from :')
  call write_cryscal_news_line(input_string,  '         . output.RES file created by SIR programs')
  call write_cryscal_news_line(input_string,  '         . struct.cif file created by WinGX')
  call write_cryscal_news_line(input_string,  '       This job.ins can be directly used for structure refinement with')
  call write_cryscal_news_line(input_string,  "       SHELXL, and contains right cell parameters and esd's, Mo wavelength")
  call write_cryscal_news_line(input_string,  '       and useful instructions such as ACTA, BOND$H, CONF, TEMP ...')
  call write_cryscal_news_line(input_string,  '')
  call write_cryscal_news_line(input_string,  '   . sept. 08:')
  call write_cryscal_news_line(input_string,  '     # CRYSCAL archive.cif : CRYSCAL is reading archive.cif and cryscal.cif')
  call write_cryscal_news_line(input_string,  '       files and creating completed archive_cryscal.cif file')
  call write_cryscal_news_line(input_string,  '')
  call write_cryscal_news_line(input_string,  '     # keyword PAUSE: pause in th execution of the requested commands')
  call write_cryscal_news_line(input_string,  '       This keyword can be useful when comands are executed from a CFL')
  call write_cryscal_news_line(input_string,  '       commands file')
  call write_cryscal_news_line(input_string,  '')
  call write_cryscal_news_line(input_string,  '   . july 08:')
  call write_cryscal_news_line(input_string,  '     # REPORT/REPORT_long: CIF fields can be independly in lower and')
  call write_cryscal_news_line(input_string,  '       upper cases')
  call write_cryscal_news_line(input_string,  '')
  call write_cryscal_news_line(input_string,  '')
  call write_cryscal_news_line(input_string,  '   . april 08:')
  call write_cryscal_news_line(input_string,  '     # CONN keyword: calculation of connectivity around a selected atom')
  call write_cryscal_news_line(input_string,  '       given as argument.')
  end if
  if(news_year(1:3) == 'all' .or. news_year(1:2) == '07' .or. news_year(1:4) == '2007') then
  call write_cryscal_news_line(input_string,  '')
  call write_cryscal_news_line(input_string,  '   . sept. 07:')
  call write_cryscal_news_line(input_string,  '     # SEARCH_SPGR keyword: search for a space group, given a hkl list and')
  call write_cryscal_news_line(input_string,  '       a given crystal system (Thanks to JRC for the CHECK_GROUP routine)')
  call write_cryscal_news_line(input_string,  '')
  call write_cryscal_news_line(input_string,  '   . july 07:')
  call write_cryscal_news_line(input_string,  '     # MATMUL keyword for 3*3 matrix multiplication')
  call write_cryscal_news_line(input_string,  '     # CIF file can be given as a second argument if "REPORT" or "REPORT_long"')
  call write_cryscal_news_line(input_string,  '       is given at first. A CIF_file_structural_report.HTML is then created')
  call write_cryscal_news_line(input_string,  '       ex: d:\cryscal report_long my_CIF_file.CIF')
  call write_cryscal_news_line(input_string,  '     # P4P file can be given as argument in the command line to run CRYSCAL,')
  call write_cryscal_news_line(input_string,  '       i.e. CRYSCAL my_file.P4P.')
  call write_cryscal_news_line(input_string,  '       CRYSCAL is then reading my_file.P4P and my_file.HKL to create')
  call write_cryscal_news_line(input_string,  '       import.CIF file for WinGX')
  call write_cryscal_news_line(input_string,  '       Same behavior can be optained by associating a selected P4P file to')
  call write_cryscal_news_line(input_string,  '       CRYSCAL program in the Windows file folder')
  call write_cryscal_news_line(input_string,  '')
  call write_cryscal_news_line(input_string,  '   . april 07:')
  call write_cryscal_news_line(input_string,  '     # MERGE keyword: merge equivalent reflections of the current HKL file')
  call write_cryscal_news_line(input_string,  '       ')
  call write_cryscal_news_line(input_string,  '     # REPORT keyword can be interpreted in command line:')
  call write_cryscal_news_line(input_string,  '       \> cryscal report')
  call write_cryscal_news_line(input_string,  '       CRYSCAL is looking in the current folder for the presence of a')
  call write_cryscal_news_line(input_string,  '       "archive.cif" file: "structural_report.html" file is then created ')
  call write_cryscal_news_line(input_string,  '       and contains text about the crystallographic study. The browser')
  call write_cryscal_news_line(input_string,  '       defined in the "cryscal.ini" file is then launch')
  call write_cryscal_news_line(input_string,  '')
  call write_cryscal_news_line(input_string,  '   . march 07:')
  call write_cryscal_news_line(input_string,  '     # .x file (created by DENZO) and .rmat file (created by DIRAX) can be')
  call write_cryscal_news_line(input_string,  '       passed as argument for CELL keyword')
  call write_cryscal_news_line(input_string,  '')
  call write_cryscal_news_line(input_string,  '   . feb. 07:')
  call write_cryscal_news_line(input_string,  '     # RESET keyword for input parameters and arrays initialization')
  call write_cryscal_news_line(input_string,  '')
  call write_cryscal_news_line(input_string,  '')
  call write_cryscal_news_line(input_string,  '  . jan. 07:')
  call write_cryscal_news_line(input_string,  '    # THERM keyword can performed conversion of anisotropic displacement '  &
                                            //'parameters:')
  call write_cryscal_news_line(input_string,  '      new available arguments: U_ij, B_ij, Beta_ij')
  call write_cryscal_news_line(input_string,  '    # DIR keyword has been added and corresponds to the DIR DOS command.')
  call write_cryscal_news_line(input_string,  '      Arguments may follow this keyword.')
  call write_cryscal_news_line(input_string,  '    # Wcryscal for Windows has been created.')
  call write_cryscal_news_line(input_string,  '')
  call write_cryscal_news_line(input_string,  '  . nov. 06:')
  call write_cryscal_news_line(input_string,  '    # X rays data for Ag, Fe and Cr have been tabulated')
  call write_cryscal_news_line(input_string,  '    # \> cryscal P4P:')
  call write_cryscal_news_line(input_string,  '       CRYSCAL is looking in the current folder, for a P4P file (created')
  call write_cryscal_news_line(input_string,  '       by SAINT) and a HKL file (created by SADABS). Import.cif file is then')
  call write_cryscal_news_line(input_string,  '       created and can be directly read by WinGX as a KappaCCD file')
  endif
  if(news_year(1:3) == 'all' .or. news_year(1:2) == '06' .or. news_year(1:4) == '2006') then
  call write_cryscal_news_line(input_string,  '')
  call write_cryscal_news_line(input_string,  '  . oct. 06:')
  call write_cryscal_news_line(input_string,  '    # MAG keyword:     output magnetic features for a 3d or 4f ion')
  call write_cryscal_news_line(input_string,  '    # SHANNON keyword: get effective ionic radii from Shannon article ' &
                                            //'(Acta Cryst. 1976, A32, 751)')
  call write_cryscal_news_line(input_string,  '    # P4P keyword:     read P4P file created by SAINT (Bruker-AXS)')
  call write_cryscal_news_line(input_string,  '')
  call write_cryscal_news_line(input_string,  '  . sept. 06:')
  call write_cryscal_news_line(input_string,  '    # FILE keyword: .m91 and .m95 files created by JANA can be read')
  call write_cryscal_news_line(input_string,  '    # CELL keyword: .m50 file can be read')
  call write_cryscal_news_line(input_string,  '')
  endif

 return
end subroutine write_cryscal_NEWS

!--------------------------------------------------------------------------------------------------
 subroutine write_cryscal_news_line(input_string, input_line)
  USE CRYSCAL_module, ONLY : HTML_unit, NEWS_unit
  USE IO_module,      ONLY : write_info
  USE Macros_module,  ONLY : l_case

  implicit none
   character (len=*), intent(in)    :: input_string
   character (len=*), intent(inout) :: input_line
   integer                          :: long_input_string
   logical                          :: input_screen, input_html, input_text
   
   input_screen = .false.
   input_html   = .false.
   input_text   = .false.
   
   long_input_string = len_trim(input_string)
   if(long_input_string == 4) then
    if(l_case(input_string(1:4)) == 'html') input_html = .true.
	if(l_case(input_string(1:4)) == 'text') input_text = .true.
   elseif(long_input_string == 6) then
    if(l_case(input_string(1:6)) == 'screen') input_screen = .true.   
   endif
   
  if(input_screen) then
   call write_info(trim(input_line))
  elseif(input_html) then
   write(HTML_unit, '(a)') trim(input_line)
  elseif(input_text) then
   write(2, '(a)') trim(input_line)
  end if

  return

 end subroutine write_cryscal_NEWS_line

!-----------------------------------------------------------------------------------------------------

!subroutine write_cryscal_CLA
! USE text_module
! USE IO_module,      ONLY : write_info
! implicit none
!  integer       :: i, k


!  call Def_command_line_arguments
!
!  call write_info('')
!  call write_info(' List of CRYSCAL command line arguments : ')
!
!  do i=1, CLA_nb
!   call write_info(trim(CLA_line(i,1)))
!   do k=2, CLA_lines_nb(i)
!    call write_info(TRIM(CLA_line(i,k)))
!   end do
!  end do
!  call write_info('')
!
! return
!end subroutine write_cryscal_CLA
