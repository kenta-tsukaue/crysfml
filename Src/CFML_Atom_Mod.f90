!!-------------------------------------------------------
!!---- Crystallographic Fortran Modules Library (CrysFML)
!!-------------------------------------------------------
!!---- The CrysFML project is distributed under LGPL. In agreement with the
!!---- Intergovernmental Convention of the ILL, this software cannot be used
!!---- in military applications.
!!----
!!---- Copyright (C) 1999-2012  Institut Laue-Langevin (ILL), Grenoble, FRANCE
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
!!---- MODULE: CFML_Atom_TypeDef
!!----   INFO: Subroutines related to Atoms definitions
!!----
!!---- HISTORY
!!----    Update: 06/03/2011
!!----
!!----
!!---- DEPENDENCIES
!!----
!!--++    Use CFML_GlobalDeps,                only: Cp, Pi
!!--++    Use CFML_Math_General,              only: Modulo_Lat, Equal_Vector
!!--++    Use CFML_Math_3D,                   only: matrix_diageigen
!!--++    Use CFML_String_Utilities,          only: setnum_std
!!--++    Use CFML_Crystal_Metrics,           only: Crystal_Cell_Type, convert_b_betas,    &
!!--++                                              convert_b_u, convert_betas_b,          &
!!--++                                              convert_betas_u, convert_u_b,          &
!!--++                                              convert_u_betas, u_equiv
!!--++    Use CFML_Crystallographic_Symmetry, only: Space_Group_Type, ApplySo, Lattice_Trans, &
!!--++                                              Get_Multip_Pos
!!--++
!!----
!!---- VARIABLES
!!----    ATOM_TYPE
!!----    ATOMS_CELL_TYPE
!!----    ATOM_LIST_TYPE
!!----    MATOM_TYPE
!!----    MATOM_LIST_TYPE
!!----    ERR_ATMD
!!----    ERR_ATMD_MESS
!!--++    R_ATOM           [Private]
!!----
!!---- PROCEDURES
!!----    Functions:
!!----       EQUIV_ATM
!!----       WRT_LAB
!!----
!!----    Subroutines:
!!----       ALLOCATE_ATOMS_CELL
!!----       ALLOCATE_ATOM_LIST
!!----       ALLOCATE_MATOM_LIST
!!----       ATLIST1_EXTENCELL_ATLIST2
!!----       ATOMS_CELL_TO_LIST
!!----       ATOM_LIST_TO_CELL
!!----       ATOM_UEQUI_LIST
!!----       COPY_ATOM_LIST
!!----       DEALLOCATE_ATOMS_CELL
!!----       DEALLOCATE_ATOM_LIST
!!----       DEALLOCATE_MATOM_LIST
!!----       INIT_ATOM_TYPE
!!----       INIT_ERR_ATMD
!!----       MERGE_ATOMS_PEAKS
!!----       MULTI
!!----       READ_BIN_ATOM_LIST
!!----       WRITE_ATOM_LIST
!!----       WRITE_ATOMS_CFL
!!----       WRITE_BIN_ATOM_LIST
!!----       WRITE_CFL
!!----
!!
 Module CFML_Atom_TypeDef

    !---- Use Files ----!
    Use CFML_GlobalDeps,                only: Cp, Pi
    Use CFML_Math_General,              only: Modulo_Lat, Equal_Vector
    Use CFML_String_Utilities,          only: setnum_std
    Use CFML_Math_3D,                   only: matrix_diageigen
    Use CFML_Crystal_Metrics,           only: Crystal_Cell_Type, convert_b_betas,    &
                                              Convert_b_u, convert_betas_b,          &
                                              convert_betas_u, convert_u_b,          &
                                              convert_u_betas, u_equiv
    Use CFML_Crystallographic_Symmetry, only: Space_Group_Type, ApplySo, Lattice_Trans, &
                                              Get_Multip_Pos

    !---- Variables ----!
    implicit none

    private

    !---- List of public functions ----!
    public :: Equiv_Atm, Wrt_Lab

    !---- List of public subroutines ----!
    public :: Allocate_Atoms_Cell, Allocate_Atom_List, Atlist1_Extencell_Atlist2,     &
              Atoms_Cell_To_List, Atom_List_To_Cell, Atom_Uequi_List, Copy_Atom_list, &
              Deallocate_Atoms_Cell, Deallocate_Atom_List, Init_Atom_Type,            &
              Init_Err_Atmd, Merge_Atoms_Peaks, Multi, Write_Atom_List,               &
              Write_Atoms_CFL, Write_CFL, Allocate_mAtom_list, Deallocate_mAtom_list, &
              Init_mAtom_Type, Read_Bin_Atom_List, Write_Bin_Atom_List

    !---- Definitions ----!

    !!----
    !!---- TYPE :: ATOM_TYPE
    !!--..
    !!---- Type, public :: Atom_Type
    !!----    character(len=20)                       :: Lab           ! Label
    !!----    character(len=2)                        :: ChemSymb      ! Chemical Symbol
    !!----    character(len=4)                        :: SfacSymb      ! Chemical Symbol for SF
    !!----    logical                                 :: active        ! Control for different purposes
    !!----    integer                                 :: Z             ! Atomic number
    !!----    integer                                 :: mult          ! multiplicity of the site
    !!----    real(kind=cp),dimension(3)              :: x             ! Fractional coordinates
    !!----    real(kind=cp),dimension(3)              :: x_std         ! Standard deviations
    !!----    real(kind=cp),dimension(3)              :: mx            ! Multiplier parameters of coordinates
    !!----    integer,      dimension(3)              :: lx            ! Numbers of LSQ parameters for coordinates
    !!----    real(kind=cp)                           :: occ           ! occupation factor
    !!----    real(kind=cp)                           :: occ_std       ! Standard deviation of occupation factor
    !!----    real(kind=cp)                           :: mOcc          !
    !!----    integer                                 :: lOcc          !
    !!----    real(kind=cp)                           :: Biso          ! Isotropic B-factor
    !!----    real(kind=cp)                           :: Biso_std      ! Standard deviation of Isotropic B-factor
    !!----    real(kind=cp)                           :: mBiso         !
    !!----    integer                                 :: lBiso         !
    !!----    character(len=4)                        :: utype         ! type of anisotropic thermal parameters: u_ij, b_ij, beta, none
    !!----    character(len=5)                        :: thtype        ! "isotr","aniso","other"
    !!----    real(kind=cp),dimension(6)              :: U             ! U11, U22, U33, U12, U13, U23
    !!----    real(kind=cp),dimension(6)              :: U_std         ! Standar_Deviations of U"s
    !!----    real(kind=cp)                           :: Ueq           ! Uequiv
    !!----    real(kind=cp),dimension(6)              :: mU            !
    !!----    integer,dimension(6)                    :: lU            !
    !!----    real(kind=cp)                           :: Charge        ! Charge
    !!----    real(kind=cp)                           :: Moment        ! Moment
    !!----    integer, dimension(5)                   :: Ind           ! Index for different purposes
    !!----    integer                                 :: Nvar          !
    !!----    real(kind=cp),dimension(10)             :: VarF          ! Free variables used for different purposes
    !!----    character(len=40)                       :: AtmInfo       ! Information string
    !!---- End Type Atom_Type
    !!----
    !!---- Update: May - 2009
    !!
    Type, public :: Atom_Type
       character(len=20)                        :: Lab
       character(len=2)                         :: ChemSymb
       character(len=4)                         :: SfacSymb
       logical                                  :: Active
       integer                                  :: Z
       integer                                  :: Mult
       real(kind=cp),dimension(3)               :: X
       real(kind=cp),dimension(3)               :: X_Std
       real(kind=cp),dimension(3)               :: MX
       integer,      dimension(3)               :: LX
       real(kind=cp)                            :: Occ
       real(kind=cp)                            :: Occ_Std
       real(kind=cp)                            :: MOcc
       integer                                  :: LOcc
       real(kind=cp)                            :: Biso
       real(kind=cp)                            :: Biso_std
       real(kind=cp)                            :: MBiso
       integer                                  :: LBiso
       character(len=4)                         :: Utype
       character(len=5)                         :: ThType
       real(kind=cp),dimension(6)               :: U
       real(kind=cp),dimension(6)               :: U_std
       real(kind=cp)                            :: Ueq
       real(kind=cp),dimension(6)               :: MU
       integer,      dimension(6)               :: LU
       real(kind=cp)                            :: Charge
       real(kind=cp)                            :: Moment
       integer, dimension(5)                    :: Ind
       integer                                  :: NVar
       real(kind=cp),dimension(10)              :: VarF
       character(len=40)                        :: AtmInfo
    End Type Atom_Type

    !!----
    !!---- TYPE :: atoms_cell_type
    !!--..
    !!---- Type, public :: atoms_cell_type
    !!----    integer                                      :: nat         ! -> Total number of atoms
    !!----    character(len=20), dimension(:), allocatable :: noms        ! -> Name of atoms   (nat)
    !!----    real(kind=cp),   dimension(:,:), allocatable :: xyz         ! -> Fractional coordinates (3,nat)
    !!----    real(kind=cp),     dimension(:), allocatable :: charge
    !!----    real(kind=cp),     dimension(:), allocatable :: moment
    !!----    real(kind=cp),   dimension(:,:), allocatable :: Var_free    ! -> Free variables (10,nat)
    !!----    integer,           dimension(:), allocatable :: neighb      ! -> Number of neighbours (nat)
    !!----    integer,        dimension( :,:), allocatable :: neighb_atom ! -> Ptr.->neighbour (# in list)(nat,idp)
    !!----    real(kind=cp),  dimension( :,:), allocatable :: distance    ! -> Corresponding distances (nat,idp)
    !!----    real(kind=cp),dimension(:, :,:), allocatable :: trans       ! -> Lattice translations   (3,nat,idp)
    !!----    integer                                      :: ndist       ! -> Number of distinct distances
    !!----    real(kind=cp),     dimension(:), allocatable :: ddist       ! -> List of distinct distances(nat*idp)
    !!----    character (len=20), dimension(:), allocatable :: ddlab       ! -> Labels of atoms at ddist (nat*idp)
    !!---- End Type atoms_cell_type
    !!----
    !!---- This type is mostly used for distance-angle and Bond-valence calculations.
    !!---- It holds the position and coordination of all the atoms in the conventional
    !!---- unit cell as well as their distances to neighbours atoms.
    !!----
    !!---- Update: February - 2005
    !!
    Type, public :: atoms_cell_type
       integer                                            :: nat
       character (len=20),      dimension(:), allocatable :: noms
       real(kind=cp),         dimension(:,:), allocatable :: xyz
       real(kind=cp),           dimension(:), allocatable :: charge
       real(kind=cp),           dimension(:), allocatable :: moment
       real(kind=cp),         dimension(:,:), allocatable :: var_free
       integer,                 dimension(:), allocatable :: neighb
       integer,              dimension( :,:), allocatable :: neighb_atom
       real(kind=cp),        dimension( :,:), allocatable :: distance
       real(kind=cp),      dimension(:, :,:), allocatable :: trans
       integer                                            :: ndist
       real(kind=cp),           dimension(:), allocatable :: ddist
       character (len=20),      dimension(:), allocatable :: ddlab
    End Type atoms_cell_type

    !!----
    !!---- TYPE :: ATOM_LIST_TYPE
    !!--..
    !!---- Type, public :: atom_list_type
    !!----    integer                                    :: natoms  ! total number of atoms in the list
    !!----    type(Atom_Type),dimension(:),allocatable   :: atom    ! individual atoms
    !!---- End Type atom_list_type
    !!----
    !!---- Update: February - 2005
    !!
    Type, public :: Atom_List_Type
       integer                                  :: natoms
       type(Atom_Type),dimension(:),allocatable :: atom
    End type Atom_List_Type

    !!----
    !!---- TYPE :: MATOM_TYPE
    !!--..
    !!---- Type, public :: mAtom_Type
    !!----    character(len=10)                       :: Lab           ! Label
    !!----    character(len=2)                        :: ChemSymb      ! Chemical Symbol
    !!----    character(len=4)                        :: SfacSymb      ! Chemical Symbol for SF
    !!----    logical                                 :: active        ! Control for different purposes
    !!----    integer                                 :: Z             ! Atomic number
    !!----    integer                                 :: mult          ! multiplicity of the site
    !!----    real(kind=cp),dimension(3)              :: x             ! Fractional coordinates
    !!----    real(kind=cp),dimension(3)              :: x_std         ! Standar deviations
    !!----    real(kind=cp),dimension(3)              :: mx            ! Multiplier parameters of coordinates
    !!----    integer,      dimension(3)              :: lx            ! Numbers of LSQ parameters for coordinates
    !!----    real(kind=cp)                           :: occ           ! occupation factor
    !!----    real(kind=cp)                           :: occ_std       ! Standard deviation of occupation factor
    !!----    real(kind=cp)                           :: mOcc          !
    !!----    integer                                 :: lOcc          !
    !!----    real(kind=cp)                           :: Biso          ! Isotropic B-factor
    !!----    real(kind=cp)                           :: Biso_std      ! Standard deviation of Isotropic B-factor
    !!----    real(kind=cp)                           :: mBiso         !
    !!----    integer                                 :: lBiso         !
    !!----    character(len=4)                        :: utype         ! type of anisotropic thermal parameters: u_ij, b_ij, beta, none
    !!----    character(len=5)                        :: thtype        ! "isotr","aniso","other"
    !!----    real(kind=cp),dimension(6)              :: U             ! U11, U22, U33, U12, U13, U23
    !!----    real(kind=cp),dimension(6)              :: U_std         ! Standar_Deviations of U"s
    !!----    real(kind=cp)                           :: Ueq           ! Uequiv
    !!----    real(kind=cp),dimension(6)              :: mU            !
    !!----    real(kind=cp),dimension(6)              :: lU            !
    !!----    real(kind=cp)                           :: Charge        ! Charge
    !!----    real(kind=cp)                           :: Moment        ! Moment
    !!----    integer, dimension(5)                   :: Ind           ! Index for different purposes
    !!----    integer                                 :: Nvar          !
    !!----    real(kind=cp),dimension(10)             :: VarF          ! Free parameters to load
    !!----    character(len=40)                       :: AtmInfo       ! Information string
    !!----                           ===================
    !!----                           Magnetic parameters
    !!----                           ===================
    !!----    integer                                 :: nvk           ! Number of propagation vectors (excluding -k)
    !!----    integer,      dimension(12)             :: imat          ! Number of the magnetic matrices/irrep set to be applied
    !!----    real(kind=cp),dimension(3,12)           :: SkR           ! Real part of Fourier Coefficient
    !!----    real(kind=cp),dimension(3,12)           :: SkR_std       ! Standard deviations of the Real part of Fourier Coefficient
    !!----    real(kind=cp),dimension(3,12)           :: Spher_SkR     ! Real part of Fourier Coefficient in spherical components
    !!----    real(kind=cp),dimension(3,12)           :: Spher_SkR_std ! Standard deviations of Real part of Fourier Coefficient in spherical components
    !!----    real(kind=cp),dimension(3,12)           :: mSkR          ! Multipliers for the real part of Fourier coefficients
    !!----    integer,      dimension(3,12)           :: lskr          ! Numbers in the list of LSQ parameters
    !!----    real(kind=cp),dimension(3,12)           :: SkI           ! Imaginary part of Fourier Coefficient
    !!----    real(kind=cp),dimension(3,12)           :: SkI_std       ! Standard deviations of Imaginary part of Fourier Coefficient
    !!----    real(kind=cp),dimension(3,12)           :: Spher_SkI     ! Imaginary part of Fourier Coefficient in spherical components
    !!----    real(kind=cp),dimension(3,12)           :: Spher_SkI_std ! Standard deviations of Imaginary part of Fourier Coefficient in spherical components
    !!----    real(kind=cp),dimension(3,12)           :: mSki          ! Multipliers for the imaginary part of Fourier coefficients
    !!----    integer,      dimension(3,12)           :: lski          ! Numbers in the list of LSQ parameters
    !!----    real(kind=cp),dimension(12)             :: mphas         ! Magnetic Phase in fractions of 2pi
    !!----    real(kind=cp),dimension(12)             :: mphas_std     ! Standard deviations of Magnetic Phase in fractions of 2pi
    !!----    real(kind=cp),dimension(12)             :: mmphas        ! Multiplier for the magnetic phase
    !!----    integer,dimension(12)                   :: lmphas        ! Number in the list of LSQ parameters
    !!----    real(kind=cp),dimension(12,12)          :: cbas          ! Coefficients of the basis functions of irreps, the second index is 1:nvk
    !!----    real(kind=cp),dimension(12,12)          :: cbas_std      ! Standard deviations of Coefficients of the basis functions of irreps, the second index is 1:nvk
    !!----    real(kind=cp),dimension(12,12)          :: mbas          ! multiplier for the coefficients of the basis functions of irreps
    !!----    integer,dimension(12,12)                :: lbas          ! Numbers in the list of LSQ parameters
    !!---- End Type mAtom_Type
    !!----
    !!---- Updated: April - 2005
    !!---- Updated: November 3, 2013 (include standar deviations of magnetic parameters,JRC)
    !!
    Type, public :: mAtom_Type
       character(len=10)                        :: Lab
       character(len=2)                         :: ChemSymb
       character(len=4)                         :: SfacSymb
       logical                                  :: Active
       integer                                  :: Z
       integer                                  :: Mult
       real(kind=cp),dimension(3)               :: X
       real(kind=cp),dimension(3)               :: X_Std
       real(kind=cp),dimension(3)               :: MX
       integer,      dimension(3)               :: LX
       real(kind=cp)                            :: Occ
       real(kind=cp)                            :: Occ_Std
       real(kind=cp)                            :: MOcc
       integer                                  :: LOcc
       real(kind=cp)                            :: Biso
       real(kind=cp)                            :: Biso_std
       real(kind=cp)                            :: MBiso
       integer                                  :: LBiso
       character(len=4)                         :: Utype
       character(len=5)                         :: ThType
       real(kind=cp),dimension(6)               :: U
       real(kind=cp),dimension(6)               :: U_std
       real(kind=cp)                            :: Ueq
       real(kind=cp),dimension(6)               :: MU
       integer,      dimension(6)               :: LU
       real(kind=cp)                            :: Charge
       real(kind=cp)                            :: Moment
       integer, dimension(5)                    :: Ind
       integer                                  :: NVar
       real(kind=cp),dimension(10)              :: VarF
       character(len=40)                        :: AtmInfo

       integer                                 :: nvk
       integer,      dimension(12)             :: imat

       real(kind=cp),dimension(3,12)           :: SkR
       real(kind=cp),dimension(3,12)           :: SkR_std
       real(kind=cp),dimension(3,12)           :: Spher_SkR
       real(kind=cp),dimension(3,12)           :: Spher_SkR_std
       real(kind=cp),dimension(3,12)           :: mSkR
       integer,      dimension(3,12)           :: lskr

       real(kind=cp),dimension(3,12)           :: SkI
       real(kind=cp),dimension(3,12)           :: SkI_std
       real(kind=cp),dimension(3,12)           :: Spher_SkI
       real(kind=cp),dimension(3,12)           :: Spher_SkI_std
       real(kind=cp),dimension(3,12)           :: mSki
       integer,      dimension(3,12)           :: lski

       real(kind=cp),dimension(12)             :: mphas
       real(kind=cp),dimension(12)             :: mphas_std
       real(kind=cp),dimension(12)             :: mmphas
       integer,dimension(12)                   :: lmphas

       real(kind=cp),dimension(12,12)          :: cbas
       real(kind=cp),dimension(12,12)          :: cbas_std
       real(kind=cp),dimension(12,12)          :: mbas
       integer,dimension(12,12)                :: lbas

    End Type mAtom_Type

    !!----
    !!---- TYPE :: MATOM_LIST_TYPE
    !!--..
    !!---- Type, public :: mAtom_list_type
    !!----    integer                                     :: natoms  ! total number of atoms in the list
    !!----    type(mAtom_Type),dimension(:),allocatable   :: Atom    ! individual atoms
    !!---- End Type mAtom_list_type
    !!----
    !!---- Update: April - 2005
    !!
    Type, public :: mAtom_List_Type
       integer                                   :: natoms
       type(mAtom_Type),dimension(:),allocatable :: Atom
    End type mAtom_List_Type

    !!----
    !!---- ERR_ATMD
    !!----    logical, public  :: err_atmd
    !!----
    !!----    Logical Variable taking the value .true. if an error in the module ATOM_DISTANCES occurs.
    !!----
    !!---- Update: February - 2005
    !!
    logical, public  :: ERR_Atmd

    !!----
    !!---- ERR_ATMD_MESS
    !!----    character(len=150), public:: Err_Atmd_Mess
    !!----
    !!----    String containing information about the last error
    !!----
    !!---- Update: February - 2005
    !!
    character(len=150), public :: Err_Atmd_Mess

    !!--++
    !!--++ R_ATOM
    !!--++    real(kind=cp), parameter, private :: r_atom=1.1
    !!--++
    !!--++    (PRIVATE)
    !!--++    Average atomic radius. Value taken for internal calculations.
    !!--++
    !!--++ Update: February - 2005
    !!
    real(kind=cp), parameter, private :: r_atom=1.1

 Contains

    !---- Functions ----!

    !!----
    !!---- Logical Function Equiv_Atm(Nam1,Nam2,NameAt) Result(Equiv_Atom)
    !!----    character (len=*), intent (in) :: nam1       !  In -> Atom Nam1
    !!----    character (len=*), intent (in) :: nam2       !  In -> Atom Nam2
    !!----    character (len=*), intent (in) :: NameAt     !  In -> String containing atom names
    !!----    logical                        :: equiv_atom !  Result .true. or .false.
    !!----
    !!----    Determine whether the atoms of names "nam1" and "nam2" are included in
    !!----    the longer string "name" (constructed by function "wrt_lab").
    !!----
    !!---- Update: February - 2005
    !!
    Function Equiv_Atm(Nam1,Nam2,NameAt) Result(Equiv_Atom)
       !---- Arguments ----!
       character (len=*), intent (in) :: nam1,nam2
       character (len=*), intent (in) :: NameAt
       logical                        :: equiv_atom

       !---- Local variables ----!
       integer :: i1,i2

       equiv_atom = .false.

       i1=index(nam1,"_")-1
       i2=index(nam2,"_")-1
       if (i1 < 0 .or. i2 < 0 ) return
       if (nam1(1:i1) == nameat(1:i1) .and. nam2(1:i2) == nameat(5:4+i2) ) then
          equiv_atom = .true.
       else if(nam1(1:i1) == nameat(5:4+i1) .and. nam2(1:i2) == nameat(1:i2) ) then
          equiv_atom = .true.
       end if

       return
    End Function Equiv_Atm

    !!----
    !!---- Function Wrt_Lab(Nam1,Nam2) Result(Bilabel)
    !!----    character (len=*), intent (in) :: nam1     !  In -> Atom name 1
    !!----    character (len=*), intent (in) :: nam2     !  In -> Atom name 2
    !!----    character (len=8)              :: bilabel  ! Result -> Composed string with underscores
    !!----
    !!----    Character function merging the main part of the labels
    !!----    (before underscore "_") of the atoms "nam1" and "nam2" into
    !!----    the string "bilabel"
    !!----
    !!---- Update: February - 2005
    !!
    Function Wrt_Lab(Nam1,Nam2) Result(Bilabel)
       !---- Arguments ----!
       character (len=*), intent (in) :: nam1,nam2
       character (len=8)              :: bilabel

       !---- Local variables ----!
       integer :: i1,i2

       bilabel=" "

       i1=index(nam1,"_")-1
       i2=index(nam2,"_")-1
       if (i1 < 0 ) then
          bilabel(1:4) = nam1(1:4)
       else
          bilabel(1:i1) = nam1(1:i1)
       end if

       if (i2 < 0 ) then
          bilabel(5:8) = nam2(1:4)
       else
          bilabel(5:4+i2) = nam2(1:i2)
       end if

       return
    End Function Wrt_Lab

    !---- Subroutines ----!

    !!----
    !!---- Subroutine Allocate_Atoms_Cell(Nasu,Mul,Dmax,Ac)
    !!----    integer, intent(in)                      :: nasu    !  In -> Number of atoms in asymmetric unit
    !!----    integer, intent(in)                      :: mul     !  In -> General multiplicity of the Space Group
    !!----    real(kind=cp),    intent(in)             :: dmax    !  In -> Maximun distance to be calculated
    !!----    type (atoms_cell_type), intent(in out)   :: Ac      !  In -> Object of type atoms_cell_type
    !!----                                                          Out -> Allocated and initialized object Ac
    !!----
    !!----    Allocation of objet "Ac" of type Atoms_Cell. "Ac" contains
    !!----    components with ALLOCATABLE attribute with dimension depending
    !!----    on the input arguments "Nasu", "Mul" and "Dmax". The variables used for calculating the
    !!----    de dimensions are:
    !!--<<
    !!----          natcel=nasu*mul       and      id=idp=nint(0.74048*(dmax/r_atom)**3)
    !!-->>
    !!----    This subroutine should be called before using the subroutines of this module with
    !!----    dummy arguments of type Atoms_Cell.
    !!----
    !!---- Update: February - 2005
    !!
    Subroutine Allocate_Atoms_Cell(Nasu,Mul,Dmax,Ac)
       !---- Arguments ----!
       integer,                intent(in)     :: nasu
       integer,                intent(in)     :: mul
       real(kind=cp),          intent(in)     :: dmax
       type (atoms_cell_type), intent(in out) :: Ac

       !---- local variables ----!
       integer :: natcel,id

       natcel=nasu*mul
       id=nint(0.74048*(dmax/r_atom)**3)
       id=max(id,natcel)

       if (.not. allocated(Ac%noms        ))   allocate (Ac%noms          (natcel))
       if (.not. allocated(Ac%xyz         ))   allocate (Ac%xyz         (3,natcel))
       if (.not. allocated(Ac%charge      ))   allocate (Ac%charge        (natcel))
       if (.not. allocated(Ac%moment      ))   allocate (Ac%moment        (natcel))
       if (.not. allocated(Ac%var_free    ))   allocate (Ac%var_free   (10,natcel))
       if (.not. allocated(Ac%neighb      ))   allocate (Ac%neighb        (natcel))
       if (.not. allocated(Ac%neighb_atom ))   allocate (Ac%neighb_atom(id,natcel))
       if (.not. allocated(Ac%distance    ))   allocate (Ac%distance   (id,natcel))
       if (.not. allocated(Ac%trans       ))   allocate (Ac%trans    (3,id,natcel))
       if (.not. allocated(Ac%ddist       ))   allocate (Ac%ddist      (natcel*id))
       if (.not. allocated(Ac%ddlab       ))   allocate (Ac%ddlab      (natcel*id))

       Ac%nat         = natcel
       Ac%noms        = " "
       Ac%xyz         = 0.0
       Ac%charge      = 0.0
       Ac%moment      = 0.0
       Ac%var_free    = 0.0
       Ac%neighb      = 0
       Ac%neighb_atom = 0
       Ac%distance    = 0.0
       Ac%trans       = 0
       Ac%ddist       = 0.0
       Ac%ddlab       = " "

       return
    End Subroutine Allocate_Atoms_Cell

    !!----
    !!---- Subroutine Allocate_Atom_List(N,A, Fail)
    !!----    integer, intent(in)                    :: n    !  In -> Number of elements of A
    !!----    type (atom_list_type), intent(in out)  :: A    !  In -> Objet to be allocated
    !!----    logical, optional,     intent(out)     :: fail
    !!----
    !!----    Allocation of objet A of type atom_list. This subroutine
    !!----    should be called before using an object of type atom_list.
    !!----
    !!---- Update: March - 2005
    !!
    Subroutine Allocate_Atom_List(N,A,Fail)
       !---- Arguments ----!
       integer,               intent(in)       :: n  !# atoms in asymmetric unit
       type (atom_list_type), intent(in out)   :: A  !Objet to be allocated
       logical, optional,     intent(out)      :: fail

       !---- Local Variables ----!
       integer :: i,ier

       A%natoms = n
       if (present(fail)) fail=.false.
       if (allocated(A%Atom)) deallocate(A%Atom)
       allocate (A%atom(n),stat=ier)
       if (ier /= 0) then
          A%natoms = 0
          if (present(fail)) fail=.true.
          return
       end if
       do i=1,n
          call init_atom_type(A%atom(i))
       end do

       return
    End Subroutine Allocate_atom_list

    !!----
    !!---- Subroutine Allocate_Matom_List(N,A)
    !!----    integer, intent(in)                    :: n    !  In -> Number of elements of A
    !!----    type (mAtom_list_type), intent(in out) :: A    !  In -> Objet to be allocated
    !!----
    !!----    Allocation of objet A of type mAtom_list. This subroutine
    !!----    should be called before using an object of type mAtom_list.
    !!----
    !!---- Update: April - 2005
    !!
    Subroutine Allocate_Matom_List(N,A)
       !---- Arguments ----!
       integer,                intent(in)     :: n  !# atoms in asymmetric magnetic unit
       type (mAtom_list_type), intent(in out) :: A  !Objet to be allocated

       !---- Local Variables ----!
       integer :: i

       A%natoms = n
       if (allocated(A%Atom)) deallocate(A%Atom)
       allocate (A%Atom(n))

       do i=1,n
          call init_mAtom_type(A%Atom(i))
       end do

       return
    End Subroutine Allocate_mAtom_list

    !!----
    !!---- Subroutine Atlist1_Extencell_Atlist2(Spg,A,B,Conven)
    !!----    type(Space_Group_Type), intent(in)     :: SpG       !  In -> Space Group Information
    !!----    type(atom_list_type),  intent(in)      :: A         !  In -> Atom List (asymmetric unit)
    !!----    type(atom_list_type),  intent(out)     :: B         ! Out -> Atoms in unit cell
    !!----    logical,                intent(in)     :: conven    !  In -> .true. for using the whole conventional unit cell
    !!----
    !!----    Subroutine to generate atoms in the primitive (conven=.false.) or the conventional
    !!----    unit cell (conven=.true.)
    !!----
    !!---- Update: February - 2005
    !!
    Subroutine AtList1_ExtenCell_AtList2(Spg,A,C,Conven)
       !---- Arguments ----!
       type(Space_Group_Type), intent(in)     :: SpG
       type(atom_list_type),   intent(in)     :: A
       type(atom_list_type),   intent(out)    :: C
       logical,                intent(in)     :: Conven

       !---- Local Variables ----!
       type(atom_list_type)                  :: b
       real(kind=cp),dimension(3)            :: xo,xx
       real(kind=cp),dimension(3,Spg%multip) :: u
       integer                               :: k,j,l,nt,npeq,n
       character(len=4)                      :: fmm

       npeq=SpG%numops
       if (SpG%centred == 2) npeq=npeq*2
       if (conven) npeq=SpG%multip

       !---- Init proccess ----!
       call allocate_atom_list(npeq*A%natoms,b)

       n=0
       do k=1,A%natoms
          if (.not. A%atom(k)%active) cycle
          l=1
          n=n+1
          B%Atom(n)=A%Atom(k)
          xo    = modulo_lat(A%atom(k)%x)
          u(:,l)= xo
          B%Atom(n)%x=xo

          do_eq:do j=2,npeq
             xx=ApplySO(SpG%SymOp(j),xo)
             xx=modulo_lat(xx)
             do nt=1,l
                if (equal_vector(u(:,nt),xx,3)) then
                   B%atom(n-(l-nt))%occ=B%atom(n-(l-nt))%occ+A%atom(k)%occ
                   cycle do_eq
                end if
             end do
             l=l+1
             u(:,l)=xx(:)
             n=n+1
             select case (l)
                case(:9)
                   write(unit=fmm,fmt="(i1)") l
                case(10:99)
                   write(unit=fmm,fmt="(i2)") l
                case(100:999)
                   write(unit=fmm,fmt="(i3)") l
             end select
             B%Atom(n)=A%Atom(k)

             B%Atom(n)%lab      =trim(A%Atom(k)%lab)//"_"//adjustl(fmm)
             B%Atom(n)%x        =xx
             B%Atom(n)%active   =.true.
             B%Atom(n)%Mult     =1.0

          end do do_eq
       end do

       B%natoms=n

       call allocate_atom_list(n,C)

       C%natoms=n
       C%atom(1:n)=B%atom(1:n)

       call deallocate_atom_list(B)

       return
    End Subroutine AtList1_ExtenCell_AtList2

    !!----
    !!---- Subroutine Atoms_Cell_To_List(Ac,A)
    !!----    Type(atoms_cell_type),  Intent(In)        :: Ac   !  In -> instance of atoms_cell_type
    !!----    type(atom_list_type),   intent(in out)    :: A    !  In -> instance of atom_list_type
    !!----                                                         Out-> Initialize atom_list_type components
    !!----
    !!----    Subroutine to construct an Atom List object "A" from an Atoms_Cell
    !!----    object "Ac". It is supposed that both objects have been previouly
    !!----    allocated using the appropriate procedures: direct allocation
    !!----    for A and call to Allocate_Atoms_Cell for Ac.
    !!----
    !!---- Update: February - 2005
    !!
    Subroutine Atoms_Cell_To_List(Ac,A)
       !---- Arguments ----!
       type(atoms_cell_type), intent(in)       :: Ac
       type(atom_list_type),  intent(in out)   :: A

       !---- Local Variables ----!
       integer :: i

       A%natoms=Ac%nat
       do i=1,Ac%nat
          A%atom(i)%Lab      = Ac%noms(i)
          A%atom(i)%ChemSymb = Ac%noms(i)(1:2)
          A%atom(i)%x(:)     = Ac%xyz(:,i)
          A%atom(i)%occ      = 1.0
          A%atom(i)%Biso     = 0.0
          A%atom(i)%mult     = 1.0
          A%atom(i)%Z        = 0
          A%atom(i)%varf     = Ac%var_free(:,i)
          A%atom(i)%charge   = Ac%charge(i)
          A%atom(i)%moment   = Ac%moment(i)
       end do

       return
    End Subroutine Atoms_Cell_To_List

    !!----
    !!---- Subroutine atom_list_To_Cell(A,Ac)
    !!----    type(atom_list_type),  intent(in)         :: A    !  In -> instance of atom_list_type
    !!----    type(atoms_cell_type),  intent(in out)    :: Ac   !  In -> instance of atoms_cell_type
    !!----                                                         Out-> Initialize atoms_cell_type components
    !!----
    !!----    Subroutine to construct an Atom Cell object "Ac" from an atom_list
    !!----    object "A". It is supposed that both objects have been previouly
    !!----    allocated using the appropriate procedures.
    !!----
    !!---- Update: February - 2005
    !!
    Subroutine Atom_List_To_Cell(A,Ac)
       !---- Arguments ----!
       type(atom_list_type),  intent(in)        :: A
       type(atoms_cell_type), intent(in out)    :: Ac

       !---- Local Variables ----!
       integer :: i

       Ac%nat=A%natoms
       do i=1,Ac%nat
          Ac%noms(i)        = A%atom(i)%lab
          Ac%xyz (:,i)      = A%Atom(i)%x
          Ac%var_free(:,i)  = A%Atom(i)%varf
       end do

       return
    End Subroutine atom_list_To_Cell

    !!----
    !!---- Subroutine Atom_Uequi_List(Cell, Ac)
    !!----    type(Crystal_Cell_Type), intent(in)    :: Cell    !  In -> Cell variable
    !!----    type(atom_list_type),   intent(in out) :: Ac      !  In -> Atom list
    !!----                                                         Out ->
    !!----
    !!----    Subroutine to obtain the U equiv from U11 U22 U33 U12 U13 U23
    !!----
    !!---- Update: February - 2005
    !!
    Subroutine Atom_Uequi_List(Cell, Ac)
       !---- Arguments ----!
       type (Crystal_cell_type), intent(in)       :: Cell
       type (atom_list_type),    intent(in out)   :: Ac

       !---- Local variables ----!
       integer                    :: i
       real(kind=cp),dimension(6) :: u

       do i=1,Ac%natoms
          u=Ac%atom(i)%u(1:6)
          Ac%atom(i)%Ueq = U_Equiv(Cell,u)
       end do

       return
    End Subroutine Atom_Uequi_List

    !!----
    !!---- Subroutine Copy_Atom_List(A, Ac)
    !!----    type(atom_list_type),   intent(in)  :: A      !  In -> Atom list
    !!----    type(atom_list_type),   intent(out) :: Ac     !   Out -> Atom list
    !!----
    !!----
    !!----    Subroutine to copy an atom list to another one
    !!----
    !!---- Update: May - 2009
    !!
    Subroutine Copy_Atom_List(A, Ac)
       !---- Arguments ----!
       type (atom_list_type),    intent(in)   :: A
       type (atom_list_type),    intent(out)  :: Ac

       !---- Local variables ----!
       integer                    :: n

       n=A%natoms
       call Allocate_Atom_List(n,Ac)
       Ac%atom(1:n)=A%atom(1:n)
       return
    End Subroutine Copy_Atom_List

    !!----
    !!---- Subroutine Deallocate_Atoms_Cell(Ac)
    !!----    type (atoms_cell_type), intent(in out)   :: Ac   !  In -> Object of atoms_cell_type
    !!----                                                     ! Out -> The object is removed from memory.
    !!----
    !!----    Deallocation of objet Ac of type Atoms_Cell.  Ac contains
    !!----    components with ALLOCATABLE attribute. This subroutine should
    !!----    be called after using this module.
    !!----
    !!---- Update: February - 2003
    !!
    Subroutine Deallocate_Atoms_Cell(Ac)
       !---- Arguments ----!
       type (atoms_cell_type), intent(in out)   :: Ac

       if (allocated(Ac%noms)       )   deallocate (Ac%noms)
       if (allocated(Ac%xyz)        )   deallocate (Ac%xyz)
       if (allocated(Ac%var_free)   )   deallocate (Ac%var_free)
       if (allocated(Ac%neighb)     )   deallocate (Ac%neighb)
       if (allocated(Ac%neighb_atom))   deallocate (Ac%neighb_atom)
       if (allocated(Ac%distance)   )   deallocate (Ac%distance)
       if (allocated(Ac%trans)      )   deallocate (Ac%trans)
       if (allocated(Ac%ddist)      )   deallocate (Ac%ddist)
       if (allocated(Ac%ddlab)      )   deallocate (Ac%ddlab)

       return
    End Subroutine Deallocate_Atoms_Cell

    !!----
    !!---- Subroutine Deallocate_atom_list(A)
    !!----    type (atom_list_type), intent(in out)   :: A  ! In/ Out -> Objet to be deallocated
    !!----
    !!----    De-allocation of objet A of type atom_list. This subroutine
    !!----    should be after using an object of type atom_list that is no
    !!----    more needed.
    !!----
    !!---- Update: February - 2003
    !!
    Subroutine Deallocate_atom_list(A)
       !---- Arguments ----!
       type (atom_list_type), intent(in out)   :: A  !Objet to be deallocated

       if (allocated(A%atom)) deallocate (A%atom)

       return
    End Subroutine Deallocate_atom_list

    !!----
    !!---- Subroutine Deallocate_mAtom_list(A)
    !!----    type (mAtom_list_type), intent(in out)   :: A  ! In/ Out -> Objet to be deallocated
    !!----
    !!----    De-allocation of objet A of type atom_list. This subroutine
    !!----    should be invoked after using an object of type mAtom_list
    !!----    that is no more needed.
    !!----
    !!---- Update: April - 2005
    !!
    Subroutine Deallocate_mAtom_list(A)
       !---- Arguments ----!
       type (mAtom_list_type), intent(in out)   :: A  !Objet to be deallocated

       if (allocated(A%Atom)) deallocate (A%Atom)

       return
    End Subroutine Deallocate_mAtom_list

    !!----
    !!---- Subroutine Init_Atom_Type(A)
    !!----    type (Atom_Type),  intent(in out) :: A   ! In / Out -> Atom type
    !!----
    !!----    Initialize Atom_Type
    !!----
    !!---- Update: March - 2005
    !!
    Subroutine Init_Atom_Type(A)
       !---- Arguments ----!
       type (Atom_Type), intent(in out)   :: A

       A%Lab      =" "
       A%ChemSymb =" "
       A%SfacSymb =" "
       A%Active   =.true.
       A%Z        =0
       A%Mult     =1
       A%X        =0.0
       A%X_Std    =0.0
       A%MX       =0.0
       A%LX       =0
       A%Occ      =0.0
       A%Occ_Std  =0.0
       A%MOcc     =0.0
       A%LOcc     =0
       A%Biso     =0.0
       A%Biso_std =0.0
       A%MBiso    =0.0
       A%LBiso    =0
       A%Utype    ="none"
       A%ThType   ="isotr"
       A%U        =0.0
       A%U_std    =0.0
       A%Ueq      =0.0
       A%MU       =0.0
       A%LU       =0
       A%Charge   =0.0
       A%Moment   =0.0
       A%Ind      =0
       A%NVar     =0
       A%VarF     =0.0
       A%AtmInfo  ="None"
       return
    End Subroutine Init_Atom_Type

    !!----
    !!---- Subroutine Init_mAtom_Type(A)
    !!----    type (mAtom_Type),  intent(in out) :: A   ! In / Out -> mAtom type
    !!----
    !!----    Initialize mAtom_Type
    !!----
    !!---- Updated: November 3 - 2013
    !!
    Subroutine Init_mAtom_Type(A)
       !---- Arguments ----!
       type (mAtom_Type), intent(in out)   :: A

       A%Lab      =" "
       A%ChemSymb =" "
       A%SfacSymb =" "
       A%Active   =.true.
       A%Z =0; A%Mult=1
       A%X=0.0; A%X_Std=0.0; A%MX=0.0; A%LX=0
       A%Occ=0.0; A%Occ_Std=0.0; A%MOcc=0.0; A%LOcc=0
       A%Biso=0.0; A%Biso_std=0.0; A%MBiso=0.0; A%LBiso=0
       A%Utype    ="none"
       A%ThType   ="isotr"
       A%U=0.0; A%U_std=0.0; A%Ueq=0.0; A%MU=0.0; A%LU=0
       A%Charge=0.0; A%Moment=0.0
       A%Ind=0
       A%NVar=0; A%VarF=0.0
       A%AtmInfo  =" "
       !Magnetic parameters
       A%nvk =0
       A%imat=0
       A%SkR=0.0; A%SkR_std=0.0; A%Spher_SkR=0.0; A%Spher_SkR_std=0.0; A%mSkR=0.0; A%lSkR=0
       A%SkI=0.0; A%SkI_std=0.0; A%Spher_SkI=0.0; A%Spher_SkI_std=0.0; A%mSkI=0.0; A%lSkI=0
       A%mphas=0.0; A%mphas_std=0.0; A%mmphas=0.0; A%lmphas=0
       A%cbas=0.0; A%cbas_std=0.0; A%mbas=0.0; A%lbas=0

       return
    End Subroutine Init_mAtom_Type

    !!----
    !!---- Subroutine Init_Err_Atmd()
    !!----
    !!----    Initialize the errors flags in this Module
    !!----
    !!---- Update: February - 2003
    !!
    Subroutine Init_Err_Atmd()

       ERR_Atmd=.false.
       ERR_Atmd_Mess=" "

       return
    End Subroutine Init_Err_Atmd

    !!----
    !!---- Subroutine Merge_Atoms_Peaks(Cell,Atm,Npks,Pks,Grp,NAtm)
    !!----    type(Crystal_Cell_Type),        intent(in) :: Cell  ! Cell object
    !!----    type(atom_list_type),           intent(in) :: Atm   ! Atoms List
    !!----    integer,                        intent(in) :: Npks  ! Number of Peaks on Pks
    !!----    real(kind=cp), dimension(:,:),  intent(in) :: Pks   ! Lis of Peaks
    !!----    type(Space_Group_Type),         intent(in) :: Grp   ! Space Group Information
    !!----    type(atom_list_type),           intent(out):: NAtm  ! New Atoms+Peaks List
    !!----
    !!----    This routine merge atoms and peaks on a new List.
    !!--<<        Atom        Peak    -->        Label      Symb
    !!----    ------------------------------------------------------
    !!----         *            *                Atom       "Pk"
    !!----         *            -                 Atom information
    !!----         -            *                "Pks"        "**"
    !!-->>
    !!---- Update: February - 2005
    !!
    Subroutine Merge_Atoms_Peaks(Cell,Atm,Npks,Pks,Grp,NAtm)
       !---- Arguments ----!
       type(Crystal_Cell_Type),       intent(in) :: Cell
       type(atom_list_type),          intent(in) :: Atm
       integer,                       intent(in) :: Npks
       real(kind=cp), dimension(:,:), intent(in) :: Pks
       type(Space_Group_Type),        intent(in) :: Grp
       type(atom_list_type),          intent(out):: NAtm

       !---- Local variables ----!
       character(len=4)                   :: car
       integer                            :: i,j,k,nc,ntot,ier
       integer, dimension(:), allocatable :: np
       real(kind=cp)                      :: dis
       real(kind=cp), dimension(3)        :: pto1,pto2,xr

       !---- Calculating the new dimension for NAtm ----!
       if (allocated(np)) deallocate(np)
       if (atm%natoms > 0) then
          allocate(np(atm%natoms))
          np=0
       end if

       nc=0
       do i=1,atm%natoms
          pto1=mod(atm%atom(i)%x+10.0_cp,1.0_cp)
          do j=1,npks
             do k=1,grp%multip
                pto2=ApplySO(grp%Symop(k),pks(1:3,j))
                pto2=mod(pto2+10.0_cp,1.0_cp)
                xr = matmul(cell%Cr_Orth_cel,pto2-pto1)
                dis=sqrt(dot_product(xr,xr))
                if (dis <= 0.25_cp) then
                   nc=nc+1
                   np(i)=j
                   exit
                end if
             end do
          end do
       end do

       ntot=0
       if (atm%natoms > 0) then   !New way to calculate ntot
         ntot=atm%natoms          !in order to avoid that nc>ntot below
         do i=1,npks
            k=0
            do j=1,atm%natoms
               if (np(j)==i) k=j
            end do
            if (k /= 0) cycle
            ntot=ntot+1
         end do
       else
         ntot=npks
       end if

       call Deallocate_atom_list(NAtm)
       call Allocate_atom_list(ntot,NAtm)

       nc=0
       if (atm%natoms > 0) then
         !---- Atoms & Peak Information ----!
          do i=1,atm%natoms
             if (np(i) == 0) cycle
             nc=nc+1
             Natm%atom(nc)=atm%atom(i)
             write(unit=Natm%atom(nc)%ChemSymb,fmt="(i2)",iostat=ier) np(i)
             if(ier /= 0) cycle
          end do

          !---- Only Atoms Information ----!
          do i=1,atm%natoms
             if (np(i) /= 0) cycle
             nc=nc+1
             Natm%atom(nc)=atm%atom(i)
          end do

          !---- Only Peaks Information ----!
          do i=1,npks
             k=0
             do j=1,atm%natoms
                if (np(j)==i) k=j
             end do
             if (k /= 0) cycle
             nc=nc+1
             write(unit=car,fmt="(i4)") nc
             natm%atom(nc)%lab="Pk_"//adjustl(car)
             natm%atom(nc)%ChemSymb="**"
             natm%atom(nc)%x=pks(1:3,i)
             natm%atom(nc)%occ=pks(4,i)
             natm%atom(nc)%active=.true.
             natm%atom(nc)%Mult=Get_Multip_Pos(pks(1:3,i),Grp)
          end do
       else
          do i=1,npks
             nc=nc+1
             write(unit=car,fmt="(i4)") nc
             natm%atom(nc)%lab="Pk_"//adjustl(car)
             natm%atom(nc)%ChemSymb="**"
             natm%atom(nc)%x=pks(1:3,i)
             natm%atom(nc)%occ=pks(4,i)
             natm%atom(nc)%active=.true.
             natm%atom(nc)%Mult=Get_Multip_Pos(pks(1:3,i),Grp)
          end do
       end if

       return
    End Subroutine Merge_Atoms_Peaks

    !!----
    !!---- Subroutine Multi(Lun,Iprin,Conven,Spg,A,Ac)
    !!----    integer,                intent(in)     :: lun     !  In -> Logical Unit for writing
    !!----    logical,                intent(in)     :: iprin   !  In -> .true. for writing in Lun
    !!----    logical,                intent(in)     :: conven  !  In -> .true. for using the whole conventional unit cell
    !!----    type(Space_Group_Type), intent(in)     :: SpG     !  In -> Space Group Information
    !!----    type(atom_list_type),  intent(in out) :: A        !  In -> Atom List (asymmetric unit)
    !!----                                                        Out -> Updated Atom List (multiplicity of sites)
    !!----    type(atoms_cell_type),  intent(out)    :: Ac      ! Out -> Atoms in unit cell
    !!----
    !!----    Subroutine to obtain multiplicities and coordinates of all atoms in
    !!----    the conventional unit cell. Calculates  "A%At(k)%mult" and constructs,
    !!----    partially, the object "Ac" of type "Atoms_Cell". The generated atoms constitute the
    !!----    content of the primitive (conven=.false.) or the conventional unit cell (conven=.true.).
    !!----
    !!---- Update: February - 2003
    !!
    Subroutine Multi(Lun,Iprin,Conven,Spg,A,Ac)
       !---- Arguments ----!
       integer,                intent(in)     :: lun
       logical,                intent(in)     :: iprin,conven
       type(Space_Group_Type), intent(in)     :: SpG
       type(atom_list_type),   intent(in out) :: A
       type(atoms_cell_type),  intent(in out) :: Ac

       !---- Local Variables ----!
       real(kind=cp),dimension(3)            :: xx,xo,v
       integer                               :: k,j,l,nt,npeq,n
       character (len=6)                     :: fmm
       character (len=5)                     :: nam, namn, nami
       real(kind=cp)                         :: qc, mom, qcn, momn
       real(kind=cp),dimension(3,Spg%multip) :: u

       npeq=SpG%numops
       if (SpG%centred == 2) npeq=npeq*2
       if (conven) npeq=SpG%multip
       n=0
       if (iprin)  then
          if (conven) then
             write(unit=lun,fmt="(/,a)") "     LIST OF ATOMS INSIDE THE CONVENTIONAL UNIT CELL "
             write(unit=lun,fmt="(a,/)") "     =============================================== "
          else
             write(unit=lun,fmt="(/,a)") "     LIST OF ATOMS CONTAINED IN A PRIMITIVE CELL "
             write(unit=lun,fmt="(a,/)") "     =========================================== "
          end if
       end if
       do k=1,A%natoms
          L=1
          n=n+1
          u(:,L)=a%atom(k)%x
          xo(:)=A%atom(k)%x(:)
          nami=A%atom(k)%lab
          if (iprin) write(unit=lun,fmt="(/,a,a)") " => Equivalent positions of atom: ",nami
          mom=A%atom(k)%moment
          qc=A%atom(k)%charge
          fmm="(a,i1)"
          write(unit=Ac%noms(n),fmt=fmm) trim(A%Atom(k)%lab)//"_",L
          nam= Ac%noms(n)
          if (iprin) write(unit=lun,fmt="(a,a,a,3f10.5,2(a,f6.3))")"       ",   &
                           nam,"  ", xo(:), "   M = ", mom ," Q = ", qc
          Ac%xyz(:,n)=xo(:)
          Ac%charge(n)=qc
          Ac%moment(n)=mom
          do_eq:DO j=2,npeq
             xx=ApplySO(SpG%SymOp(j),xo)
             xx=modulo_lat(xx)
             DO nt=1,L
                v=u(:,nt)-xx(:)
                if (Lattice_trans(v,SpG%spg_lat)) cycle do_eq
             END DO
             L=L+1
             u(:,L)=xx(:)
             n=n+1
             if ( L > 9) fmm="(a,i2)"
             write(unit=Ac%noms(n),fmt=fmm) trim(A%Atom(k)%lab)//"_",L
             Ac%xyz(:,n)=xx(:)
             Ac%charge(n)=A%Atom(k)%charge
             Ac%moment(n)=A%Atom(k)%moment
             namn=Ac%noms(n)
             momn=Ac%moment(n)
             qcn=Ac%charge(n)
             if (iprin) WRITE(unit=lun,fmt="(a,a,a,3f10.5,2(a,f6.3))")"       ",   &
                              namn, "  ", xx(:), "   M = ", momn ," Q = ", qcn
          end do do_eq
          A%Atom(k)%mult=L
       end do
       if (iprin)  write(unit=lun,fmt="(/)")
       Ac%nat=n

       return
    End Subroutine Multi

    !!----
    !!---- Subroutine Read_Bin_Atom_List(Ats,Lun,ok)
    !!----    Type (atom_list_type),dimension(:),  intent(in out) :: Ats     !  In out -> Atom List
    !!----    integer,                             intent(in)     :: lun     !  In -> Unit to write
    !!----    logical,                             intent(out)    :: ok      ! True is everything is OK!
    !!----
    !!----    Reads the atoms in the asymmetric unit in a binary file of logical unit Lun.
    !!----    The file should have been opened with the access="stream" attribute. The procedure
    !!----    reads in the given order a series of bytes corresponding to the components of the
    !!----    type Ats. The full structure is re-allocated inside the procedure before reading the
    !!----    components. The number of atoms is the first element read in the file.
    !!----
    !!---- Update: February - 2013
    !!
    Subroutine Read_Bin_Atom_List(Ats,Lun,ok)
       !---- Arguments ----!
       type (atom_list_type),            intent(in out) :: Ats
       integer,                          intent(in)     :: Lun
       logical,                          intent(out)    :: ok
       !---- Local Variables ----!
       integer                        :: i,ier
       logical                        :: Fail

       ok=.true.
       read(unit=lun,iostat=ier) Ats%natoms    !Number of atoms in the list
       if(ier /= 0) then
         ok=.false.
         return
       end if
       if( Ats%natoms == 0) return
       call Allocate_Atom_List(ats%natoms,Ats,Fail)
       if(Fail) then
        ok=.false.
        return
       end if
       do i=1,ats%natoms
         read(unit=lun,iostat=ier)     &
           Ats%atom(i)%Lab,            &
           Ats%atom(i)%ChemSymb,       &
           Ats%atom(i)%SfacSymb,       &
           Ats%atom(i)%Active,         &
           Ats%atom(i)%Z,              &
           Ats%atom(i)%Mult,           &
           Ats%atom(i)%X,              &
           Ats%atom(i)%X_Std,          &
           Ats%atom(i)%MX,             &
           Ats%atom(i)%LX,             &
           Ats%atom(i)%Occ,            &
           Ats%atom(i)%Occ_Std,        &
           Ats%atom(i)%MOcc,           &
           Ats%atom(i)%LOcc,           &
           Ats%atom(i)%Biso,           &
           Ats%atom(i)%Biso_std,       &
           Ats%atom(i)%MBiso,          &
           Ats%atom(i)%LBiso,          &
           Ats%atom(i)%Utype,          &
           Ats%atom(i)%ThType,         &
           Ats%atom(i)%U,              &
           Ats%atom(i)%U_std,          &
           Ats%atom(i)%Ueq,            &
           Ats%atom(i)%MU,             &
           Ats%atom(i)%LU,             &
           Ats%atom(i)%Charge,         &
           Ats%atom(i)%Moment,         &
           Ats%atom(i)%Ind,            &
           Ats%atom(i)%NVar,           &
           Ats%atom(i)%VarF,           &
           Ats%atom(i)%AtmInfo
           if(ier /= 0) then
             ok=.false.
             return
           end if
       end do
       return
    End Subroutine Read_Bin_atom_list

    !!----
    !!---- Subroutine Write_Atom_List(Ats,Level,Lun,Cell)
    !!----    Type (atom_list_type),dimension(:),  intent(in) :: Ats     !  In -> Atom List
    !!----    integer, optional,                   intent(in) :: Level   !  In -> Level of printed information
    !!----    integer, optional,                   intent(in) :: lun     !  In -> Unit to write
    !!----    Type(Crystal_Cell_Type), optional,   intent(in) :: Cell    !  In -> Transform to thermal parameters
    !!----
    !!----    Write the atoms in the asymmetric unit
    !!----
    !!---- Update: February - 2003
    !!
    Subroutine Write_Atom_List(Ats,Level,Lun,Cell)
       !---- Arguments ----!
       type (atom_list_type),            intent(in) :: Ats
       integer, optional,                intent(in) :: Level
       integer, optional,                intent(in) :: Lun
       Type(Crystal_Cell_Type), optional,intent(in) :: Cell

       !---- Local Variables ----!
       character(len=1)               :: car
       integer                        :: i, j, lv,iunit
       real(kind=cp)                  :: biso
       real(kind=cp), dimension(3)    :: rms
       real(kind=cp), dimension(6)    :: u,b,bet
       real(kind=cp), dimension(3,3)  :: beta,eigen
       logical                        :: aniso


       iunit=6
       if (present(lun)) iunit=lun
       if(ats%natoms == 0) then
         write(unit=iunit,fmt="(/,a,/)") "  => No atoms provided!"
         return
       end if

       lv=0
       if (present(level)) lv=level
       write(unit=iunit,fmt="(/,a)")    "        Atoms information:"
       write(unit=iunit,fmt="(a,/)")    "        ------------------"

       select case (lv)
          case (0)
             write (unit=iunit,fmt="(T5,a)") &
                   "Atom      Chem        x/a       y/b       z/c       Biso     Occ       Mult"
             write (unit=iunit,fmt="(T5,a)") &
                   "==========================================================================="
          case (1)
             write (unit=iunit,fmt="(T5,a)") &
                   "Atom      Chem        x/a       y/b       z/c       Biso      Occ     Moment    Charge   Active   Mult"
             write (unit=iunit,fmt="(T5,a)") &
                   "======================================================================================================"
       end select

       aniso=.false.
       do i=1,ats%natoms
          car=" "
          if (.not. ats%atom(i)%active) car="-"
          if(ats%atom(i)%thtype == "aniso") aniso=.true.
          select case (lv)
             case (0)
                write(unit=iunit,fmt="(T5,a,T16,a,T21,5f10.4,i9,a)") &
                     ats%atom(i)%lab, ats%atom(i)%chemsymb, ats%atom(i)%x, &
                     ats%atom(i)%biso,ats%atom(i)%occ,ats%atom(i)%mult,trim("  "//ats%atom(i)%AtmInfo)
             case (1)
                write(unit=iunit,fmt="(T5,a,T16,a,T21,7f10.4,T96,a,t97,i9,a)") &
                     ats%atom(i)%lab, ats%atom(i)%chemsymb, ats%atom(i)%x, &
                     ats%atom(i)%biso,ats%atom(i)%occ,ats%atom(i)%moment,ats%atom(i)%charge,&
                     car,ats%atom(i)%mult,trim("  "//ats%atom(i)%AtmInfo)
          end select
       end do

       if (aniso) then
          write(unit=iunit,fmt="(/,/,T5,a)") &
               "Atom       Type      T_11        T_22        T_33        T_12        T_13        T_23"
          write (unit=iunit,fmt="(T5,a)") &
               "====================================================================================="
          do i=1,ats%natoms
             if (ats%atom(i)%thtype == "aniso") then

                if (ats%atom(i)%utype == "beta") then
                   bet=ats%atom(i)%u(1:6)
                   write(unit=iunit,fmt="(T5,a,t16,a,6f12.6)") ats%atom(i)%lab,ats%atom(i)%utype, bet
                   if (present(Cell)) then
                      u=convert_betas_u(bet,cell)
                      write(unit=iunit,fmt="(T16,a,6f12.6)") "U_ij", u
                      b=convert_betas_b(bet,cell)
                      write(unit=iunit,fmt="(T16,a,6f12.6)") "B_ij", b
                   end if
                else if(ats%atom(i)%thtype == "u_ij") then
                   u=ats%atom(i)%u(1:6)
                   write(unit=iunit,fmt="(T5,a,t16,a,6f12.6)") ats%atom(i)%lab,ats%atom(i)%utype, u
                   b=convert_u_b(u)
                   write(unit=iunit,fmt="(T16,a,6f12.6,a)") "B_ij", b
                   if (present(Cell)) then
                      bet=convert_u_betas(u,cell)
                      write(unit=iunit,fmt="(T16,a,6f12.6,a)") "Beta", bet
                   end if
                else if(ats%atom(i)%thtype == "b_ij") then
                   b=ats%atom(i)%u(1:6)
                   write(unit=iunit,fmt="(T5,a,t16,a,6f12.6)") ats%atom(i)%lab,ats%atom(i)%utype, b
                   u=convert_b_u(b)
                   write(unit=iunit,fmt="(T16,a,6f12.6,a)") "U_ij", u
                   if (present(Cell)) then
                      bet=convert_b_betas(b,cell)
                      write(unit=iunit,fmt="(T16,a,6f12.6,a)") "Beta", bet
                   end if
                end if

                if (present(cell)) then
                  beta=reshape((/bet(1),bet(4),bet(5), bet(4),bet(2),bet(6), bet(5),bet(6),bet(3) /),(/3,3/))
                   beta=beta*0.5/pi/pi
                   beta=matmul(matmul(Cell%Cr_Orth_cel,beta),transpose(Cell%Cr_Orth_cel))
                   call matrix_diageigen(beta,rms,eigen)
                   write(unit=lun,fmt="(a)")  &
                        "               U-Eigen Value(A**2) ----       Eigen vector(Orth. syst.)     R.M.S (Angstroms)"
                   do j =1,3
                      if (rms(j) < 0.0)  then
                         write(unit=iunit,fmt="((t16,f10.5,a,3(tr1,f10.5),a))")     rms(j), &
                              "          --- ", eigen(:,j),"   -> Matrix U non-positive definite!"
                      else
                         write(unit=iunit,fmt="((t16,f10.5,a,3(tr1,f10.5),a,f14.5))") rms(j),&
                              "          ---(", eigen(:,j),")", sqrt(rms(j))
                      end if
                   end do
                   biso=sum(rms)/3.0
                   write(unit=iunit,fmt="(a,f8.4)") "               Isotropic temperature factor Uequiv(A**2): ",biso
                   biso=biso*8.0*pi*pi
                   write(unit=iunit,fmt="(a,f8.4,/)") "               Isotropic temperature factor Bequiv(A**2): ",biso
                end if

             end if
          end do
       end if

       return
    End Subroutine Write_atom_list

    !!----
    !!---- Subroutine Write_Atoms_CFL(Ats,Lun,Cell)
    !!----    Type (atom_list_type),dimension(:),  intent(in) :: Ats     !  In -> Atom List
    !!----    integer, optional,                   intent(in) :: lun     !  In -> Unit to write
    !!----    Type(Crystal_Cell_Type), optional,   intent(in) :: Cell    !  In -> Transform to thermal parameters
    !!----
    !!----    Write the atoms in the asymmetric unit for a CFL file
    !!----
    !!---- Update: February - 2003
    !!
    Subroutine Write_Atoms_CFL(Ats,Lun,cell)
       !---- Arguments ----!
       type (atom_list_type),            intent(in) :: Ats
       integer, optional,                intent(in) :: Lun
       Type(Crystal_Cell_Type), optional,intent(in) :: Cell

       !---- Local Variables ----!
       character(len=30),dimension(6) :: text
       character(len=36)              :: forma,fom
       integer                        :: i, j, iunit, leng, maxl,ish
       real(kind=cp), dimension(6)    :: u,bet,sb

       iunit=6
       if (present(lun)) iunit=lun

       if(ats%natoms == 0) then
         write (unit=iunit,fmt="(a)") "!  No atoms ..."
         return
       end if
       !Determine the maximum length of the atom labels
       maxl=0
       do i=1,ats%natoms
         leng=len_trim(ats%atom(i)%lab)
         if(leng > maxl) maxl=leng
       end do
       maxl=max(maxl,4)+1
       ish=maxl-4
       fom   ="(a,tr  ,a)"
       Select Case(ish)
          Case(:9)
            write(unit=fom(6:6),fmt="(i1)") ish
          Case(10:)
            write(unit=fom(6:7),fmt="(i2)") ish
       End Select
       forma="(a,a  ,tr2,a,tr3,5a14,2f8.2,tr3,a)"
       Select Case(maxl)
         Case(:9)
             write(unit=forma(5:5),fmt="(i1)") maxl
         Case(10:)
             write(unit=forma(5:6),fmt="(i2)") maxl
       End Select
       write (unit=iunit,fmt=fom) "!     ", &
             "Atom  Type     x/a           y/b           z/c           Biso          Occ           Spin    Charge    Info"
       do i=1,ats%natoms

          do j=1,3
             call SetNum_Std(ats%atom(i)%x(j), ats%atom(i)%x_std(j), text(j))
          end do
          call SetNum_Std(ats%atom(i)%Biso, ats%atom(i)%Biso_std, text(4))
          call SetNum_Std(ats%atom(i)%Occ, ats%atom(i)%Occ_std, text(5))

          write (unit=iunit,fmt=forma) &
                "Atom   ",trim(ats%atom(i)%lab),ats%atom(i)%chemsymb, (text(j),j=1,5), &
                 ats%atom(i)%moment,ats%atom(i)%charge,"# "//ats%atom(i)%AtmInfo

          if (ats%atom(i)%thtype == "aniso") then

             if (ats%atom(i)%utype == "beta") then
                bet=ats%atom(i)%u(1:6)
                sb=ats%atom(i)%u_std(1:6)
                do j=1,6
                   call SetNum_Std(bet(j), sb(j), text(j))
                end do
                write (unit=iunit,fmt="(a,tr1,6a14)") "Beta  ", text
                if (present(Cell)) then
                   u=convert_betas_u(bet,cell)
                   sb=convert_betas_u(ats%atom(i)%u_std,cell)
                   do j=1,6
                      call SetNum_Std(u(j), sb(j), text(j))
                   end do
                   write(unit=iunit,fmt="(a,6a14)") "!U_ij  ", text
                end if

             else if(ats%atom(i)%thtype == "u_ij") then
                u=ats%atom(i)%u(1:6)
                sb=ats%atom(i)%u_std(1:6)
                do j=1,6
                   call SetNum_Std(u(j), sb(j), text(j))
                end do
                write(unit=iunit,fmt="(a,6a14)") "U_ij  ", text
                if (present(Cell)) then
                   bet=convert_u_betas(u,cell)
                   sb=convert_u_betas(ats%atom(i)%u_std,cell)
                   do j=1,6
                      call SetNum_Std(bet(j), sb(j), text(j))
                   end do
                   write(unit=iunit,fmt="(a,6a14)") "!Beta  ", text
                end if
             end if

          end if
       end do

       return
    End Subroutine Write_Atoms_CFL

    !!----
    !!---- Subroutine Write_Bin_Atom_List(Ats,Lun)
    !!----    Type (atom_list_type),dimension(:),  intent(in) :: Ats     !  In -> Atom List
    !!----    integer,                             intent(in) :: lun     !  In -> Unit to write
    !!----
    !!----    Write the atoms in the asymmetric unit in a binary file of logical unit Lun.
    !!----    The file should have been opened with the access="stream" attribute. The procedure
    !!----    writes in the given order a series of bytes corresponding to the components of the
    !!----    type Ats. For reading back an atom list from a binary file the subroutine Read_Bin_Atom_List
    !!----    has to be used.
    !!----
    !!---- Update: February - 2013
    !!
    Subroutine Write_Bin_Atom_List(Ats,Lun)
       !---- Arguments ----!
       type (atom_list_type),            intent(in) :: Ats
       integer,                          intent(in) :: Lun
       !---- Local Variables ----!
       integer                        :: i

       write(unit=lun) ats%natoms    !Number of atoms in the list
       do i=1,ats%natoms
         write(unit=lun)               &
           ats%atom(i)%Lab,            &
           ats%atom(i)%ChemSymb,       &
           ats%atom(i)%SfacSymb,       &
           ats%atom(i)%Active,         &
           ats%atom(i)%Z,              &
           ats%atom(i)%Mult,           &
           ats%atom(i)%X,              &
           ats%atom(i)%X_Std,          &
           ats%atom(i)%MX,             &
           ats%atom(i)%LX,             &
           ats%atom(i)%Occ,            &
           ats%atom(i)%Occ_Std,        &
           ats%atom(i)%MOcc,           &
           ats%atom(i)%LOcc,           &
           ats%atom(i)%Biso,           &
           ats%atom(i)%Biso_std,       &
           ats%atom(i)%MBiso,          &
           ats%atom(i)%LBiso,          &
           ats%atom(i)%Utype,          &
           ats%atom(i)%ThType,         &
           ats%atom(i)%U,              &
           ats%atom(i)%U_std,          &
           ats%atom(i)%Ueq,            &
           ats%atom(i)%MU,             &
           ats%atom(i)%LU,             &
           ats%atom(i)%Charge,         &
           ats%atom(i)%Moment,         &
           ats%atom(i)%Ind,            &
           ats%atom(i)%NVar,           &
           ats%atom(i)%VarF,           &
           ats%atom(i)%AtmInfo
       end do
       return
    End Subroutine Write_Bin_atom_list

    !!----
    !!---- Subroutine Write_CFL(lun,Cel,SpG,Atm,comment)
    !!----    integer,                  intent(in)    :: lun
    !!----    type (Space_Group_Type),  intent(in)    :: SpG
    !!----    type (Crystal_Cell_Type), intent(in)    :: Cel
    !!----    type (atom_list_type),    intent(in)    :: Atm
    !!----    character(len=*),optional,intent(in)    :: comment
    !!----
    !!----    Write a file CFL
    !!----
    !!---- Update: May - 2009
    !!
    Subroutine Write_CFL(lun,Cel,SpG,Atm,comment)
       !---- Arguments ----!
       integer,                  intent(in)    :: lun
       type (Space_Group_Type),  intent(in)    :: SpG
       type (Crystal_Cell_Type), intent(in)    :: Cel
       type (atom_list_type),    intent(in)    :: Atm
       character(len=*),optional,intent(in)    :: comment

       !----- Local variables -----!
       integer                         :: j !,loc
       real(kind=cp), dimension(6)     :: a,sa
       character(len=30), dimension(6) :: text

       if(present(comment)) write(unit=lun,fmt="(a)") "TITLE "//trim(comment)
       write(unit=lun,fmt="(a)") "!  Automatically generated CFL file (Write_CFL)"
       write(unit=lun,fmt="(a)") "!  "

       a(1:3)=Cel%Cell
       a(4:6)=Cel%ang
       sa(1:3)=Cel%Cell_std
       sa(4:6)=Cel%ang_std
       do j=1,6
          call SetNum_Std(a(j), sa(j), text(j))
       end do
       write(unit=lun,fmt="(a,6a12)") "Cell ",text
       write(unit=lun,fmt="(a,a)") "Spgr  ",SpG%SPG_Symb
       call Write_Atoms_CFL(Atm,Lun,cel)

       return
    End Subroutine Write_CFL

 End Module CFML_Atom_TypeDef
