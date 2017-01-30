!!-------------------------------------------------------
!!---- Crystallographic Fortran Modules Library (CrysFML)
!!-------------------------------------------------------
!!---- The CrysFML project is distributed under LGPL. In agreement with the
!!---- Intergovernmental Convention of the ILL, this software cannot be used
!!---- in military applications.
!!----
!!---- Copyright (C) 1999-2017  Institut Laue-Langevin (ILL), Grenoble, FRANCE
!!----                          Universidad de La Laguna (ULL), Tenerife, SPAIN
!!----                          Laboratoire Leon Brillouin(LLB), Saclay, FRANCE
!!----
!!---- Authors: Juan Rodriguez-Carvajal (ILL)
!!----          Javier Gonzalez-Platas  (ULL)
!!----
!!---- Contributors: Laurent Chapon     (ILL)
!!----               Marc Janoschek     (Los Alamos National Laboratory, USA)
!!----               Oksana Zaharko     (Paul Scherrer Institute, Switzerland)
!!----               Tierry Roisnel     (CDIFX,Rennes France)
!!----               Eric Pellegrini    (ILL)
!!----
!!---- This library is free software; you can redistribute it and/or
!!---- modify it under the terms of the GNU Lesser General Public
!!---- License as published by the Free Software Foundation; either
!!---- version 3.0 of the License, or (at your option) any later version.
!!----
!!---- This library is distributed in the hope that it will be useful,
!!---- but WITHOUT ANY WARRANTY; without even the implied warranty of
!!---- MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
!!---- Lesser General Public License for more details.
!!----
!!---- You should have received a copy of the GNU Lesser General Public
!!---- License along with this library; if not, see <http://www.gnu.org/licenses/>.
!!----
!!----
!!---- MODULE: CFML_GlobalDeps (Windows version)
!!----   INFO: Precision for CrysFML library and Operating System information
!!----         All the global variables defined in this module are implicitly public.
!!----
!!----
!!
Module CFML_DefPar
   !---- Use Modules ----!
   use CFML_GlobalDeps

   !---- Local Variables ----!
   implicit none

   !-------------------!
   !---- PARAMETER ----!
   !-------------------!
   integer, parameter                  :: MAX_FREE_PAR=3000                                 ! Maximum number of free parameters
   integer, parameter, dimension(1000) :: PRIMES =                                        & ! List of the first 1000 prime numbers
           (/ 2,      3,      5,      7,     11,     13,     17,     19,     23,     29,  &
             31,     37,     41,     43,     47,     53,     59,     61,     67,     71,  &
             73,     79,     83,     89,     97,    101,    103,    107,    109,    113,  &
            127,    131,    137,    139,    149,    151,    157,    163,    167,    173,  &
            179,    181,    191,    193,    197,    199,    211,    223,    227,    229,  &
            233,    239,    241,    251,    257,    263,    269,    271,    277,    281,  &
            283,    293,    307,    311,    313,    317,    331,    337,    347,    349,  &
            353,    359,    367,    373,    379,    383,    389,    397,    401,    409,  &
            419,    421,    431,    433,    439,    443,    449,    457,    461,    463,  &
            467,    479,    487,    491,    499,    503,    509,    521,    523,    541,  &
            547,    557,    563,    569,    571,    577,    587,    593,    599,    601,  &
            607,    613,    617,    619,    631,    641,    643,    647,    653,    659,  &
            661,    673,    677,    683,    691,    701,    709,    719,    727,    733,  &
            739,    743,    751,    757,    761,    769,    773,    787,    797,    809,  &
            811,    821,    823,    827,    829,    839,    853,    857,    859,    863,  &
            877,    881,    883,    887,    907,    911,    919,    929,    937,    941,  &
            947,    953,    967,    971,    977,    983,    991,    997,   1009,   1013,  &
           1019,   1021,   1031,   1033,   1039,   1049,   1051,   1061,   1063,   1069,  &
           1087,   1091,   1093,   1097,   1103,   1109,   1117,   1123,   1129,   1151,  &
           1153,   1163,   1171,   1181,   1187,   1193,   1201,   1213,   1217,   1223,  &
           1229,   1231,   1237,   1249,   1259,   1277,   1279,   1283,   1289,   1291,  &
           1297,   1301,   1303,   1307,   1319,   1321,   1327,   1361,   1367,   1373,  &
           1381,   1399,   1409,   1423,   1427,   1429,   1433,   1439,   1447,   1451,  &
           1453,   1459,   1471,   1481,   1483,   1487,   1489,   1493,   1499,   1511,  &
           1523,   1531,   1543,   1549,   1553,   1559,   1567,   1571,   1579,   1583,  &
           1597,   1601,   1607,   1609,   1613,   1619,   1621,   1627,   1637,   1657,  &
           1663,   1667,   1669,   1693,   1697,   1699,   1709,   1721,   1723,   1733,  &
           1741,   1747,   1753,   1759,   1777,   1783,   1787,   1789,   1801,   1811,  &
           1823,   1831,   1847,   1861,   1867,   1871,   1873,   1877,   1879,   1889,  &
           1901,   1907,   1913,   1931,   1933,   1949,   1951,   1973,   1979,   1987,  &
           1993,   1997,   1999,   2003,   2011,   2017,   2027,   2029,   2039,   2053,  &
           2063,   2069,   2081,   2083,   2087,   2089,   2099,   2111,   2113,   2129,  &
           2131,   2137,   2141,   2143,   2153,   2161,   2179,   2203,   2207,   2213,  &
           2221,   2237,   2239,   2243,   2251,   2267,   2269,   2273,   2281,   2287,  &
           2293,   2297,   2309,   2311,   2333,   2339,   2341,   2347,   2351,   2357,  &
           2371,   2377,   2381,   2383,   2389,   2393,   2399,   2411,   2417,   2423,  &
           2437,   2441,   2447,   2459,   2467,   2473,   2477,   2503,   2521,   2531,  &
           2539,   2543,   2549,   2551,   2557,   2579,   2591,   2593,   2609,   2617,  &
           2621,   2633,   2647,   2657,   2659,   2663,   2671,   2677,   2683,   2687,  &
           2689,   2693,   2699,   2707,   2711,   2713,   2719,   2729,   2731,   2741,  &
           2749,   2753,   2767,   2777,   2789,   2791,   2797,   2801,   2803,   2819,  &
           2833,   2837,   2843,   2851,   2857,   2861,   2879,   2887,   2897,   2903,  &
           2909,   2917,   2927,   2939,   2953,   2957,   2963,   2969,   2971,   2999,  &
           3001,   3011,   3019,   3023,   3037,   3041,   3049,   3061,   3067,   3079,  &
           3083,   3089,   3109,   3119,   3121,   3137,   3163,   3167,   3169,   3181,  &
           3187,   3191,   3203,   3209,   3217,   3221,   3229,   3251,   3253,   3257,  &
           3259,   3271,   3299,   3301,   3307,   3313,   3319,   3323,   3329,   3331,  &
           3343,   3347,   3359,   3361,   3371,   3373,   3389,   3391,   3407,   3413,  &
           3433,   3449,   3457,   3461,   3463,   3467,   3469,   3491,   3499,   3511,  &
           3517,   3527,   3529,   3533,   3539,   3541,   3547,   3557,   3559,   3571,  &
           3581,   3583,   3593,   3607,   3613,   3617,   3623,   3631,   3637,   3643,  &
           3659,   3671,   3673,   3677,   3691,   3697,   3701,   3709,   3719,   3727,  &
           3733,   3739,   3761,   3767,   3769,   3779,   3793,   3797,   3803,   3821,  &
           3823,   3833,   3847,   3851,   3853,   3863,   3877,   3881,   3889,   3907,  &
           3911,   3917,   3919,   3923,   3929,   3931,   3943,   3947,   3967,   3989,  &
           4001,   4003,   4007,   4013,   4019,   4021,   4027,   4049,   4051,   4057,  &
           4073,   4079,   4091,   4093,   4099,   4111,   4127,   4129,   4133,   4139,  &
           4153,   4157,   4159,   4177,   4201,   4211,   4217,   4219,   4229,   4231,  &
           4241,   4243,   4253,   4259,   4261,   4271,   4273,   4283,   4289,   4297,  &
           4327,   4337,   4339,   4349,   4357,   4363,   4373,   4391,   4397,   4409,  &
           4421,   4423,   4441,   4447,   4451,   4457,   4463,   4481,   4483,   4493,  &
           4507,   4513,   4517,   4519,   4523,   4547,   4549,   4561,   4567,   4583,  &
           4591,   4597,   4603,   4621,   4637,   4639,   4643,   4649,   4651,   4657,  &
           4663,   4673,   4679,   4691,   4703,   4721,   4723,   4729,   4733,   4751,  &
           4759,   4783,   4787,   4789,   4793,   4799,   4801,   4813,   4817,   4831,  &
           4861,   4871,   4877,   4889,   4903,   4909,   4919,   4931,   4933,   4937,  &
           4943,   4951,   4957,   4967,   4969,   4973,   4987,   4993,   4999,   5003,  &
           5009,   5011,   5021,   5023,   5039,   5051,   5059,   5077,   5081,   5087,  &
           5099,   5101,   5107,   5113,   5119,   5147,   5153,   5167,   5171,   5179,  &
           5189,   5197,   5209,   5227,   5231,   5233,   5237,   5261,   5273,   5279,  &
           5281,   5297,   5303,   5309,   5323,   5333,   5347,   5351,   5381,   5387,  &
           5393,   5399,   5407,   5413,   5417,   5419,   5431,   5437,   5441,   5443,  &
           5449,   5471,   5477,   5479,   5483,   5501,   5503,   5507,   5519,   5521,  &
           5527,   5531,   5557,   5563,   5569,   5573,   5581,   5591,   5623,   5639,  &
           5641,   5647,   5651,   5653,   5657,   5659,   5669,   5683,   5689,   5693,  &
           5701,   5711,   5717,   5737,   5741,   5743,   5749,   5779,   5783,   5791,  &
           5801,   5807,   5813,   5821,   5827,   5839,   5843,   5849,   5851,   5857,  &
           5861,   5867,   5869,   5879,   5881,   5897,   5903,   5923,   5927,   5939,  &
           5953,   5981,   5987,   6007,   6011,   6029,   6037,   6043,   6047,   6053,  &
           6067,   6073,   6079,   6089,   6091,   6101,   6113,   6121,   6131,   6133,  &
           6143,   6151,   6163,   6173,   6197,   6199,   6203,   6211,   6217,   6221,  &
           6229,   6247,   6257,   6263,   6269,   6271,   6277,   6287,   6299,   6301,  &
           6311,   6317,   6323,   6329,   6337,   6343,   6353,   6359,   6361,   6367,  &
           6373,   6379,   6389,   6397,   6421,   6427,   6449,   6451,   6469,   6473,  &
           6481,   6491,   6521,   6529,   6547,   6551,   6553,   6563,   6569,   6571,  &
           6577,   6581,   6599,   6607,   6619,   6637,   6653,   6659,   6661,   6673,  &
           6679,   6689,   6691,   6701,   6703,   6709,   6719,   6733,   6737,   6761,  &
           6763,   6779,   6781,   6791,   6793,   6803,   6823,   6827,   6829,   6833,  &
           6841,   6857,   6863,   6869,   6871,   6883,   6899,   6907,   6911,   6917,  &
           6947,   6949,   6959,   6961,   6967,   6971,   6977,   6983,   6991,   6997,  &
           7001,   7013,   7019,   7027,   7039,   7043,   7057,   7069,   7079,   7103,  &
           7109,   7121,   7127,   7129,   7151,   7159,   7177,   7187,   7193,   7207,  &
           7211,   7213,   7219,   7229,   7237,   7243,   7247,   7253,   7283,   7297,  &
           7307,   7309,   7321,   7331,   7333,   7349,   7351,   7369,   7393,   7411,  &
           7417,   7433,   7451,   7457,   7459,   7477,   7481,   7487,   7489,   7499,  &
           7507,   7517,   7523,   7529,   7537,   7541,   7547,   7549,   7559,   7561,  &
           7573,   7577,   7583,   7589,   7591,   7603,   7607,   7621,   7639,   7643,  &
           7649,   7669,   7673,   7681,   7687,   7691,   7699,   7703,   7717,   7723,  &
           7727,   7741,   7753,   7757,   7759,   7789,   7793,   7817,   7823,   7829,  &
           7841,   7853,   7867,   7873,   7877,   7879,   7883,   7901,   7907,   7919 /)


   !---------------!
   !---- TYPES ----!
   !---------------!

   !!----
   !!---- TYPE :: Points_Interval_Type
   !!--..
   !!---- Type used for FFT routines
   !!----
   !!
   Type :: Points_Interval_Type
      integer       :: Np   = 0              ! Number of Points
      real(kind=cp) :: Low  = 0.0            ! Lower range value
      real(kind=cp) :: High = 0.0            ! Upper range value
   End Type Points_Interval_Type

   !!----
   !!---- TYPE :: OPT_CONDITIONS_TYPE
   !!----
   !!----    This TYPE has been introduced to simplify the call to optimization
   !!----    procedures. It contains the optimization parameters useful for different
   !!----    algorithms.
   !!----
   !!----    All integer components are initialized to zero and the real components
   !!----    are initilized as indicated below.
   !!----    A variable of this type should be defined by the user and all their
   !!----    input parameters (in) must be provided before calling the procedures.
   !!----    On output from the procedure the (out) items are provided for checking.
   !!----
   !!
   Type :: Opt_Conditions_Type
      character(len=20) :: method = " "    ! Name of the method
      integer           :: nmeth  = 0      ! 0= conjugate gradient, 1= BFGS method
      integer           :: npar   = 0      ! Number of free parameters
      integer           :: mxfun  = 0      ! Maximum number function calls
      integer           :: loops  = 0      ! Useful for SIMPLEX method: = 0
      integer           :: iquad  = 0      ! For SIMPLEX, if iquad/= 0 fitting to a quadratic
      integer           :: iout   = 0      ! =0 no printing for Quasi_Newton & Conjugate Gradient. Partial printing for Simplex (<0 no printing).
                                           ! > 0 printing each iout iterations/evaluations
      integer           :: nflag  = 0      ! Flag value states which condition caused the exit of the optimization subroutine
                                           !       If NFLAG=0, the algorithm has converged.
                                           !       If NFLAG=1, the maximum number of function
                                           !          evaluations have been used.
                                           !       If NFLAG=2, the linear search has failed to
                                           !          improve the function value. This is the
                                           !          usual exit if either the function or the
                                           !          gradient is incorrectly coded.
                                           !       If NFLAG=3, The search vector was not
                                           !          a descent direction. This can only be caused
                                           !          by roundoff,and may suggest that the
                                           !          convergence criterion is too strict.
      integer           :: ifun   = 0      ! Total number of function and gradient evaluations
      integer           :: iter   = 0      ! Total number of search directions used in the algorithm
      real(kind=cp)     :: eps    = 0.0    ! Convergence occurs when the norm of the gradient is less than or equal to EPS times the maximum
                                           ! of one and the norm of the vector X. Initialized to 1.0E-6
      real(kind=cp)     :: acc    = 0.0    ! ACC is a user supplied estimate of machine accuracy ACC=10.0E-20 has proved satisfactory
                                           ! For simplex method this should be changed to 1.0e-6
   End Type Opt_Conditions_Type

   !!----
   !!---- TYPE :: LSQ_CONDITIONS_TYPE
   !!--..
   !!----  Derived type encapsulating all necessary conditions for running the LSQ algorithm
   !!----
   !!
   Type :: LSQ_Conditions_Type
      logical          :: constr  =.false.   ! if true box constraint of percent% are applied to parameters
      logical          :: reached =.false.   ! if true convergence was reached in the algorithm
      integer          :: corrmax =50        ! value of correlation in % to output
      integer          :: nfev    =0         ! number of function evaluations (output component, useful for assessing LM algorithm)
      integer          :: njev    =0         ! number of Jacobian evaluations                 "
      integer          :: icyc    =0         ! number of cycles of refinement or maximum number of function evaluations in LM
                                             ! In LM procedures the default value is icyc = maxfev = 100(npvar+1)
      integer          :: npvar   =0         ! number of effective free parameters of the model
      integer          :: iw      =0         ! indicator for weighting scheme (if iw=1 => w=1/yc)
      integer          :: nprint  =0         ! indicator for printing during iterations, if nprint > 0 printing each nprint iterations
      real(kind=cp)    :: tol     =0.0       ! tolerance value for applying stopping criterion in LM algorithm
      real(kind=cp)    :: percent =0.0       ! %value of maximum variation of a parameter w.r.t.
                                             ! the intial value before fixing it
   End Type LSQ_Conditions_Type

   !!----
   !!---- TYPE :: LSQ_DATA_TYPE
   !!--..
   !!----
   !!----  Derived type encapsulating the observed and calculated data as well as the
   !!----  weighting factors, a variable related with each observed value and the
   !!----  total number of observations. It is responsibility of the calling program to
   !!----  allocate the components before calling the Marquardt_fit procedure.
   !!----
   !!---- Update: 11/07/2015
   !!
   Type :: LSQ_Data_Type
      integer                                 :: nobs=0  !total number of observations
      integer                                 :: iw  =0  !Indicator for type of values contained in component sw
      real(kind=cp), dimension(:),allocatable :: x       !Vector containing a relevant quantity for each observation (x-coordinate ...)
      real(kind=cp), dimension(:),allocatable :: y       !Vector containing the observed values
      real(kind=cp), dimension(:),allocatable :: sw      !Vector containing the standard deviation of observations if iw=0
                                                         !or the weight factors for least squares refinement if iw=1
      real(kind=cp), dimension(:),allocatable :: yc      !Vector containing the calculated values
   End Type LSQ_Data_type

   !!----
   !!---- TYPE :: LSQ_STATE_VECTOR_TYPE
   !!--..
   !!----  Derived type encapsulating the vector state defining a set of parameter
   !!----  for calculating the model function and running the LSQ algorithm.
   !!----  Now, with the introduction of code_comp and mul, the codes may be also interpreted
   !!----  as the ordinal number in the LSQ list of independent parameters. Depending on the
   !!----  the way the user program attributes codes and constraints a call to the subroutine
   !!----  Modify_Codes_State_Vector (see below)
   !!----
   !!---- Update: 11/07/2015
   !!
   Type :: LSQ_State_Vector_Type
      integer                                    :: np        = 0       !total number of model parameters <= Max_Free_Par
      logical                                    :: code_comp = .false. !If .true. the codes are interpreted as number in the LSQ list
      integer(kind=2)                            :: code_max  = 0       !Maximum code number (used in case of code_comp=.true.)
      real(kind=cp),     dimension(Max_Free_Par) :: mul       = 1.0     !Vector of multipliers (used in case of code_comp=.true.)
      real(kind=cp),     dimension(Max_Free_Par) :: pv        = 0.0     !Vector of parameters
      real(kind=cp),     dimension(Max_Free_Par) :: spv       = 0.0     !Vector of standard deviations
      real(kind=cp),     dimension(Max_Free_Par) :: dpv       = 0.0     !Vector of derivatives at a particular point
      integer(kind=2),   dimension(Max_Free_Par) :: code      = 0       !pointer for selecting variable parameters
      character(len=40), dimension(Max_Free_Par) :: nampar    =" "      !Names of parameters
   End Type LSQ_State_Vector_type

   !!----
   !!---- TYPE :: ERR_TEXT_TYPE
   !!--..
   !!---- Update: February - 2005
   !!
   Type :: Err_Text_Type
      integer :: nlines
      character (len=132), dimension(5) :: txt
   End Type Err_Text_Type

   !!----
   !!---- TYPE :: DERIV_TOF_TYPE
   !!--..
   !!---- Type Definition for TOF Profiles
   !!----
   !!---- Update: 11/07/2015
   !!
   Type :: Deriv_TOF_Type
      real(kind=cp) :: alfa  = 0.0    ! omega_a  DOmega/Dalpha
      real(kind=cp) :: beta  = 0.0    ! omega_b  DOmega/Dbeta
      real(kind=cp) :: dt    = 0.0    ! omega_t  DOmega/Ddt      (dt=TOFi-TOF(Bragg))
      real(kind=cp) :: sigma = 0.0    ! omega_s  DOmega/Dsigma   (for tof_Jorgensen function)
      real(kind=cp) :: gamma = 0.0    ! omega_g  DOmega/Dgamma   (for tof_Jorgensen_VonDreele function)
      real(kind=cp) :: eta   = 0.0    ! omega_e  DOmega/Deta                     "
      real(kind=cp) :: kappa = 0.0    ! omega_e  DOmega/kappa    (for tof_Carpenter function)
   End Type Deriv_TOF_Type


   !-------------------!
   !---- VARIABLES ----!
   !-------------------!

   logical            :: ERR_MathGen =.false.          ! Error flag in CFML_Math_General module
   logical            :: ERR_Random  =.false.          ! Error flag in CFML_Random_Generators module
   logical            :: ERR_Spher   =.false.          ! Error flag in CFML_Spherical_Harmonics module
   logical            :: ERR_String  =.false.          ! Error flag in CFML_String_Utilities module
   logical            :: ERR_Math3D  =.false.          ! Error flag in CFML_Math_3D module
   logical            :: ERR_Optim   =.false.          ! Error flag in CFML_Optimization_General module
   logical            :: ERR_LSQ     =.false.          ! Error flag in CFML_Optimization_LSQ module

   logical            :: Init_ProfVal=.false.
   logical            :: Lorcomp     =.false.          ! .true. if there are Lorentzian components

   character(len=256) :: ERR_MathGen_Mess = " "        ! String containing information about the last error
   character(len=256) :: ERR_Random_Mess  = " "        ! String containing information about the last error
   character(len=256) :: Err_Spher_Mess   = " "        ! String containing information about the last error
   character(len=256) :: Err_String_Mess  = " "        ! String containing information about the last error
   character(len=256) :: Err_Math3D_Mess  = " "        ! String containing information about the last error
   character(len=256) :: ERR_Optim_Mess   = " "        ! String containing information about the last error
   character(len=256) :: ERR_LSQ_Mess     = " "        ! String containing information about the last error

   character(len=150) :: Info_Lsq_Mess    = " "        ! Information in Levenberg_Marquardt_Fit procedure

   integer            :: win_console = -1              ! Code number for Scroll Window (Variable only in use for Winteracter code)

   integer            :: iErr_fmt    = 0               ! Integer signaling if an error has occurred (/=0) in using the procedure findFMT


   Type (Err_Text_Type)  :: Mess_FindFMT = &           ! Text composed of a maximum of 5 lines to inform about position or error (findFMT)
        Err_Text_Type(0,(/" "," "," "," "," "/))


End Module CFML_DefPar
