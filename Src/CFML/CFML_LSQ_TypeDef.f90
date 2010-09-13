!!----
!!---- Copyleft(C) 1999-2010,              Version: 4.1
!!---- Juan Rodriguez-Carvajal & Javier Gonzalez-Platas
!!----
!!---- MODULE: CFML_LSQ_TypeDef
!!----   INFO: Type definitions for LSQ Routines
!!----
!!---- HISTORY
!!--..    Update: January - 2010
!!--..
!!---- VARIABLES
!!----    MAX_FREE_PAR
!!----    LSQ_CONDITIONS_TYPE
!!----    LSQ_DATA_TYPE
!!----    LSQ_STATE_VECTOR_TYPE
!!----
!!
Module CFML_LSQ_TypeDef
   !---- Use Files ----!
   Use CFML_GlobalDeps,   only: Cp, Dp

   !---- Variables ----!
   implicit None

   !---- Definitions ----!

   !!----
   !!---- MAX_FREE_PAR
   !!----    integer, parameter, public  :: Max_Free_Par
   !!----
   !!----    Maximum number of free parameters (809)
   !!----    (it may be changed at will!)
   !!----
   !!---- Update: August - 2010
   !!
   integer, parameter, public   :: Max_Free_Par=809   !Maximum number of free parameters


   !!----
   !!---- TYPE :: LSQ_CONDITIONS_TYPE
   !!--..
   !!----  Type, public :: LSQ_Conditions_type
   !!----     logical          :: constr          ! if true box constraint of percent% are applied to parameters
   !!----     logical          :: reached         ! if true convergence was reached in the algorithm
   !!----     integer          :: corrmax         ! value of correlation in % to output
   !!----     integer          :: nfev            ! number of function evaluations (output component, useful for assessing LM algorithm)
   !!----     integer          :: njev            ! number of Jacobian evaluations                 "
   !!----     integer          :: icyc            ! number of cycles of refinement or maximum number of function evaluations in LM
   !!----                                         ! In LM procedures the default value is icyc = maxfev = 100(npvar+1)
   !!----     integer          :: npvar           ! number of effective free parameters of the model
   !!----     integer          :: iw              ! indicator for weighting scheme (if iw=1 => w=1/yc)
   !!----     real(kind=cp)    :: tol             ! tolerance value for applying stopping criterion in LM algorithm
   !!----     real(kind=cp)    :: percent         ! %value of maximum variation of a parameter w.r.t.
   !!----                                         ! the intial value before fixing it
   !!----  End Type LSQ_Conditions_type
   !!----
   !!----  Derived type encapsulating all necessary conditions for running the LSQ algorithm
   !!----
   !!---- Update: August - 2009
   !!
   Type, public :: LSQ_Conditions_Type
      logical          :: constr=.false.  ! if true box constraint of percent% are applied to parameters
      logical          :: reached=.false. ! if true convergence was reached in the algorithm
      integer          :: corrmax=50.0    ! value of correlation in % to output
      integer          :: nfev=0          ! number of function evaluations (output component, useful for assessing LM algorithm)
      integer          :: njev=0          ! number of Jacobian evaluations                 "
      integer          :: icyc=0          ! number of cycles of refinement or maximum number of function evaluations in LM
                                          ! In LM procedures the default value is icyc = maxfev = 100(npvar+1)
      integer          :: npvar=0         ! number of effective free parameters of the model
      integer          :: iw=0            ! indicator for weighting scheme (if iw=1 => w=1/yc)
      real(kind=cp)    :: tol=0.0         ! tolerance value for applying stopping criterion in LM algorithm
      real(kind=cp)    :: percent=0.0     ! %value of maximum variation of a parameter w.r.t.
                                          ! the intial value before fixing it
   End Type LSQ_Conditions_Type

   !!----
   !!---- TYPE :: LSQ_DATA_TYPE
   !!--..
   !!----
   !!----  Type, public :: LSQ_Data_Type
   !!----     integer                                    :: nobs  !total number of observations
   !!----     integer                                    :: iw    !Indicator for type of values contained in component sig
   !!----     real(kind=cp),    dimension(:),allocatable :: x     !Vector containing a relevant quantity for each observation (x-coordinate ...)
   !!----     real(kind=cp),    dimension(:),allocatable :: y     !Vector containing the observed values
   !!----     real(kind=cp),    dimension(:),allocatable :: sw    !Vector containing the standard deviation of observations if iw=0
   !!----                                                         !or the weight factors for least squares refinement if iw=1
   !!----     real(kind=cp),    dimension(:),allocatable :: yc    !Vector containing the calculated values
   !!----  End Type LSQ_Data_type
   !!----
   !!----  Derived type encapsulating the observed and calculated data as well as the
   !!----  weighting factors, a variable related with each observed value and the
   !!----  total number of observations. It is responsibility of the calling program to
   !!----  allocate the components before calling the Marquardt_fit procedure.
   !!----
   !!---- Update: August - 2009
   !!
   Type, public :: LSQ_Data_Type
      integer                                    :: nobs  !total number of observations
      integer                                    :: iw    !Indicator for type of values contained in component sw
      real(kind=cp),    dimension(:),allocatable :: x     !Vector containing a relevant quantity for each observation (x-coordinate ...)
      real(kind=cp),    dimension(:),allocatable :: y     !Vector containing the observed values
      real(kind=cp),    dimension(:),allocatable :: sw    !Vector containing the standard deviation of observations if iw=0
                                                          !or the weight factors for least squares refinement if iw=1
      real(kind=cp),    dimension(:),allocatable :: yc    !Vector containing the calculated values
   End Type LSQ_Data_type

   !!----
   !!---- TYPE :: LSQ_STATE_VECTOR_TYPE
   !!--..
   !!----
   !!----  Type, public :: LSQ_State_Vector_Type
   !!----     integer                                    :: np         !total number of model parameters <= Max_Free_Par
   !!----     real(kind=cp),     dimension(Max_Free_Par) :: pv         !Vector of parameters
   !!----     real(kind=cp),     dimension(Max_Free_Par) :: spv        !Vector of standard deviations
   !!----     real(kind=cp),     dimension(Max_Free_Par) :: dpv        !Vector of derivatives at a particular point
   !!----     integer,           dimension(Max_Free_Par) :: code       !pointer for selecting variable parameters
   !!----     character(len=25), dimension(Max_Free_Par) :: nampar     !Names of parameters
   !!----  End Type LSQ_State_Vector_Type
   !!----
   !!----  Derived type encapsulating the vector state defining a set of parameter
   !!----  for calculating the model function and running the LSQ algorithm.
   !!----
   !!---- Update: August - 2009
   !!
   Type, public :: LSQ_State_Vector_Type
      integer                                    :: np         !total number of model parameters <= Max_Free_Par
      real(kind=cp),     dimension(Max_Free_Par) :: pv         !Vector of parameters
      real(kind=cp),     dimension(Max_Free_Par) :: spv        !Vector of standard deviations
      real(kind=cp),     dimension(Max_Free_Par) :: dpv        !Vector of derivatives at a particular point
      integer,           dimension(Max_Free_Par) :: code       !pointer for selecting variable parameters
      character(len=25), dimension(Max_Free_Par) :: nampar     !Names of parameters
   End Type LSQ_State_Vector_type

End Module CFML_LSQ_TypeDef
