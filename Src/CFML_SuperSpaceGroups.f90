  Module CFML_SuperSpaceGroups
    use CFML_GlobalDeps,       only: sp,dp,cp,tpi
    use CFML_String_Utilities, only: u_case,l_case,pack_string,get_separator_pos
    use CFML_Math_General,     only: sort, trace, iminloc, equal_vector
    use CFML_Crystal_Metrics,  only: Crystal_Cell_Type, ERR_Crys, ERR_Crys_mess, set_Crystal_Cell
    use CFML_Crystallographic_Symmetry, only: Space_Group_Type, Set_SpaceGroup,Get_Generators_From_SpGSymbol, &
                                              set_Intersection_SPG, Write_SpaceGroup, Magnetic_Space_Group_Type

    use CFML_Propagation_Vectors, only: K_Star, Set_Gk, Group_k_Type
    use CFML_IO_Formats,          only: Readn_Set_Magnetic_Space_Group
    use CFML_Rational_Arithmetic
    use CFML_Rational_Groups
    use CFML_ssg_datafile
    use CFML_Standard_Settings

    Implicit None
    private
    public :: Allocate_kvect_info,Set_SSG_Reading_Database, Write_SSG,    &
              Generate_Reflections, Set_SSGs_from_Gkk, k_SSG_compatible,  &
              Gen_SSGroup, Print_Matrix_SSGop, Readn_Set_SuperSpace_Group,&
              Get_Average_SPG,Allocate_sAtom_list, Get_h_info,            &
              Allocate_SSG_SymmOps, Gen_Group, Get_SSymSymb_from_Mat,     &
              Get_Mat_From_SSymSymb

    !!---- Type, public   :: SSym_Oper_Type
    !!----
    !!---- Rational matrix of special type dimension (3+d+1,3+d+1)
    !!---- The matrix of the superspace operator is extended with
    !!---- a column containing the translation in supespace plus
    !!---- a zero 3+d+1 row and + or -1 for time reversal at position
    !!---- (3+d+1,3+d+1). In order to limit the operators to the
    !!---- factor group the translations, a modulo-1 is applied
    !!---- in the multiplication of two operators.
    Type, public   :: SSym_Oper_Type
      integer                                     :: time_inv=1 !initializing here in case of not allocating al list
      Type(rational), allocatable, dimension(:,:) :: Mat
    End Type SSym_Oper_Type

    public :: operator (*)
    interface operator (*)
      module procedure multiply_ssg_symop
    end interface
    private :: multiply_ssg_symop

    Type, extends(Spg_Type), public :: SuperSpaceGroup_Type
      logical                             :: standard_setting=.true.  !true or false
      Character(len=60)                   :: SSG_symbol=" "
      Character(len=60)                   :: SSG_Bravais=" "
      Character(len=40)                   :: SSG_nlabel=" "
      Character(len=20)                   :: Parent_spg=" "
      Character(len=80)                   :: trn_from_parent=" "
      Character(len=80)                   :: trn_to_standard=" "
      character(len=80)                   :: Centre="Acentric" ! Alphanumeric information about the center of symmetry
      integer                             :: nk=0              !(nk=1,2,3, ...) number of q-vectors
      integer                             :: Parent_num=0  ! Number of the parent Group
      integer                             :: Bravais_num=0 ! Number of the Bravais class
      real,   allocatable,dimension(:,:)  :: kv            ! k-vectors (3,d)
      type(SSym_Oper_Type),allocatable, dimension(:)   :: SymOp         ! Crystallographic symmetry operators
    End Type SuperSpaceGroup_Type

    type,public, extends(SuperSpaceGroup_Type)   :: eSSGroup_Type
       real(kind=cp), allocatable,dimension(:,:,:):: Om     !Operator matrices (3+d+1,3+d+1,Multip)
    end type eSSGroup_Type


    !!----
    !!---- TYPE: sReflect_Type
    !!----
    !!---- Type, Public :: sReflect_Type
    !!----    integer,dimension(:),allocatable :: H       ! H
    !!----    integer                          :: Mult=0  ! mutiplicity
    !!----    real(kind=cp)                    :: S=0.0   ! Sin(Theta)/lambda=1/2d
    !!----    integer                          :: imag=0  !=0 nuclear reflection, 1=magnetic, 2=both
    !!----    integer                          :: p_coeff ! Pointer to the harmonic q_coeff
    !!---- End Type sReflect_Type
    !!----
    !!----

    Type, Public :: sReflect_Type
       integer,dimension(:),allocatable :: H       ! H
       integer                          :: Mult=0  ! mutiplicity
       real(kind=cp)                    :: S=0.0   ! Sin(Theta)/lambda=1/2d
       integer                          :: imag=0  ! =0 nuclear reflection, 1=magnetic, 2=both
       integer                          :: p_coeff ! Pointer to the harmonic q_coeff
    End Type sReflect_Type

    Type, Public, extends(sReflect_Type) :: sReflection_Type
       real(kind=cp)        :: Fo    ! Observed Structure Factor
       real(kind=cp)        :: Fc    ! Calculated Structure Factor
       real(kind=cp)        :: SFo   ! Sigma of  Fo
       real(kind=cp)        :: Phase ! Phase in degrees
       real(kind=cp)        :: A     ! real part of the Structure Factor
       real(kind=cp)        :: B     ! Imaginary part of the Structure Factor
    End Type sReflection_Type

    Type, Public, extends(sReflection_Type) :: gReflection_Type
       real(kind=cp)                    :: mIvo          ! Observed modulus of the Magnetic Interaction vector
       real(kind=cp)                    :: sigma_mIvo    ! Sigma of observed modulus of the Magnetic Interaction vector
       complex(kind=cp),dimension(3)    :: msF           ! Magnetic Structure Factor
       complex(kind=cp),dimension(3)    :: mIv           ! Magnetic Interaction vector
    End Type gReflection_Type

    !!----
    !!---- TYPE :: SREFLECTION_LIST_TYPE
    !!--..
    !!---- Type, public :: sReflection_List_Type
    !!----    integer                                        :: NRef ! Number of Reflections
    !!----    type(sReflect_Type),allocatable,dimension(:) :: Ref  ! Reflection List
    !!---- End Type sReflection_List_Type
    !!----
    !!---- Update: February - 2005
    !!
    Type, public :: sReflection_List_Type
       integer                                          :: NRef  ! Number of Reflections
       class(sReflect_Type),allocatable, dimension(:)   :: Ref   ! Reflection List
    End Type sReflection_List_Type

    !!----
    !!---- TYPE :: KVECT_INFO_TYPE
    !!--..
    !!---- Type, public :: KVECT_INFO_TYPE
    !!----   integer                                      :: nk        ! Number of independent k-vectors
    !!----   real(kind=cp),allocatable,dimension(:,:)     :: kv        ! k-vectors (3,nk)
    !!----   real(kind=cp),allocatable,dimension(:)       :: sintlim   ! sintheta/lambda limits (nk)
    !!----   integer,allocatable,dimension(:)             :: nharm     ! number of harmonics along each k-vector
    !!----   integer                                      :: nq        ! number of effective k-vectors > nk
    !!----   integer,allocatable,dimension(:,:)           :: q_coeff   ! number of q_coeff(nk,nq)
    !!---- End Type kvect_info_type
    !!----
    !!---- This type encapsulates information about modulation
    !!---- vectors irrespective of providing a superspace group
    !!----
    !!---- Created: January - 2019
    !!
    Type, public :: kvect_info_type
       integer                                      :: nk=0      ! Number of independent k-vectors
       real(kind=cp),allocatable,dimension(:,:)     :: kv        ! k-vectors (3,nk)
       real(kind=cp),allocatable,dimension(:)       :: sintlim   ! sintheta/lambda limits (nk)
       integer,allocatable,dimension(:)             :: nharm     ! number of harmonics along each k-vector
       integer                                      :: nq        ! number of effective set of Q_coeff >= nk
       integer,allocatable,dimension(:,:)           :: q_coeff   ! number of q_coeff(nk,nq)
    End Type kvect_info_type

    logical,            public :: Err_ssg
    character(len=180), public :: Err_ssg_mess

    Type, public :: Atom_Type
       character(len=20)                        :: Lab=" "
       character(len=2)                         :: ChemSymb=" "
       character(len=4)                         :: SfacSymb=" "
       integer                                  :: Mult=0
       logical                                  :: mag=.false.
       real(kind=cp),dimension(3)               :: X=0.0_cp
       real(kind=cp)                            :: Occ=0.0_cp
       real(kind=cp)                            :: Biso=0.0_cp
       character(len=4)                         :: Utype="beta"
       character(len=5)                         :: ThType="isotr"
       real(kind=cp)                            :: Ueq=0.0_cp
       real(kind=cp),dimension(6)               :: U=0.0_cp
       real(kind=cp),dimension(3)               :: Moment=0.0_cp
       integer, dimension(3)                    :: num_ff=0 !Number of form factor (Xray,b,Magff)
    End Type Atom_Type

    Type, public, extends(Atom_Type) :: Atom_std_type
       real(kind=cp),dimension(3)               :: X_std=0.0_cp
       real(kind=cp)                            :: Occ_std=0.0_cp
       real(kind=cp)                            :: Biso_std=0.0_cp
       real(kind=cp),dimension(6)               :: U_std=0.0_cp
       real(kind=cp),dimension(3)               :: Moment_std=0.0_cp
    End Type Atom_std_type

    Type, public, extends(Atom_std_type) :: sAtom_type
       character(len=3)                         :: wyck=" "
       integer                                  :: n_mc=0  !up to 8
       integer                                  :: n_dc=0
       real(kind=cp),dimension(6,8)             :: Mcs=0.0_cp !Mcos,Msin up to 8  (Mcx Mcy  Mcz , Msx  Msy  Msz)
       real(kind=cp),dimension(6,8)             :: Mcs_std=0.0_cp !Mcos,Msin up to 8  (Mcx Mcy  Mcz , Msx  Msy  Msz)
       real(kind=cp),dimension(6,8)             :: Dcs=0.0_cp !Dcos,Dsin up to 8  (Dcx Dcy  Dcz , Dsx  Dsy  Dsz)
       real(kind=cp),dimension(6,8)             :: Dcs_std=0.0_cp !Dcos,Dsin up to 8  (Dcx Dcy  Dcz , Dsx  Dsy  Dsz)
    End Type sAtom_type



    Type, public :: sAtom_List_Type
       integer                                   :: natoms
       type(sAtom_Type),dimension(:),allocatable :: atom
    End Type sAtom_List_Type

    real(kind=cp), parameter, private :: eps_ref  = 0.0002_cp
    integer,       parameter, private :: max_mult=4096


    interface Generate_Reflections
      module procedure Gen_SXtal_SReflections
      module procedure Gen_SReflections
    end interface Generate_Reflections
    Private :: Gen_SXtal_SReflections,Gen_SReflections

  Contains

    Subroutine Allocate_SSG_SymmOps(d,multip,SymOp)
      integer,                                        intent(in)      :: d,multip
      type(SSym_Oper_Type),allocatable, dimension(:), intent(in out)  :: SymOp
      integer :: i,Dd

      if(allocated(SymOp)) deallocate(SymOp)
      allocate(SymOp(multip))
      Dd=3+d+1
      do i=1,multip
        allocate(SymOp(i)%Mat(Dd,Dd))
        SymOp(i)%Mat=0_ik//1_ik
      end do
      SymOp(:)%time_inv=1
    End Subroutine Allocate_SSG_SymmOps

    Subroutine Allocate_sAtom_list(natoms, As)
      integer,               intent(in)     :: natoms
      class(sAtom_List_Type),intent(in out) :: As
      As%natoms=natoms
      if(allocated(As%atom)) deallocate(As%atom)
      allocate(As%atom(natoms))
    End Subroutine Allocate_sAtom_list

    Subroutine Allocate_kvect_info(nk,nq,kvect_info)
      integer,               intent(in)  :: nk,nq
      type(kvect_info_type), intent(out) :: kvect_info
      kvect_info%nk=nk
      kvect_info%nq=nq
      if(allocated(kvect_info%kv)) deallocate(kvect_info%kv)
      allocate(kvect_info%kv(3,nk))
      kvect_info%kv=0.0
      if(allocated(kvect_info%sintlim)) deallocate(kvect_info%sintlim)
      allocate(kvect_info%sintlim(nk))
      kvect_info%sintlim=0.5
      if(allocated(kvect_info%nharm)) deallocate(kvect_info%nharm)
      allocate(kvect_info%nharm(nk))
      kvect_info%nharm=1
      if(allocated(kvect_info%q_coeff)) deallocate(kvect_info%q_coeff)
      allocate(kvect_info%q_coeff(nk,nq))
      kvect_info%q_coeff=1
    End Subroutine Allocate_kvect_info

    !!---- function multiply_ssg_symop(Op1,Op2) result (Op3)
    !!----
    !!---- The arguments are two SSym_Oper_Type operators and the
    !!---- result is another SSym_Oper_Type operator. This implements
    !!---- the operator (*) between SSym_Oper_Type objects making the
    !!---- rational multiplications of the D+1 matrices and taking
    !!---- only positive translations modulo-1.
    !!----
    !!----   Created : February 2017 (JRC)
    function multiply_ssg_symop(Op1,Op2) result (Op3)
      type(SSym_Oper_Type), intent(in) :: Op1,Op2
      type(SSym_Oper_Type)             :: Op3
      integer :: n,d,i
      n=size(Op1%Mat,dim=1)
      allocate(Op3%Mat(n,n))  !needed for f95
      d=n-1
      Op3%Mat=matmul(Op1%Mat,Op2%Mat) !automatic allocation in f2003
      Op3%Mat(1:d,n)=mod(Op3%Mat(1:d,n),1_ik)
       do i=1,d
       	 do
            if(Op3%Mat(i,n) < 0_ik//1_ik) then
            	Op3%Mat(i,n) = Op3%Mat(i,n) + 1_ik
            else
            	exit
            end if
         end do
      end do
      Op3%time_inv=Op1%time_inv*Op2%time_inv
    end function multiply_ssg_symop

    !This subroutine assumes that Op contains the identity as the first operator, followed
    !by few non-equal generators. The value of ngen icludes also the identity
    Subroutine Gen_Group(ngen,Op,multip,table)
      integer,                                        intent(in)     :: ngen
      type(SSym_Oper_Type), dimension(:),             intent(in out) :: Op
      integer,                                        intent(out)    :: multip
      integer, dimension(:,:), allocatable, optional, intent(out)    :: table
      !--- Local variables ---!
      integer :: i,j,k,n, nt,max_op,Dd,D
      type(SSym_Oper_Type) :: Opt
      logical, dimension(size(Op),size(Op)) :: done
      integer, dimension(size(Op),size(Op)) :: tb
      max_op=size(Op)
      done=.false.
      done(1,:) = .true.
      done(:,1) = .true.
      tb(1,:) = [(i,i=1,max_op)]
      tb(:,1) = [(i,i=1,max_op)]
      nt=ngen
      Dd=size(Op(1)%Mat,dim=1)
      D=Dd-1
      Err_ssg=.false.
      Err_ssg_mess=" "

      do_ext:do
        n=nt
        do i=1,n
          do_j:do j=1,n
            if(done(i,j)) cycle
            Opt=Op(i)*Op(j)
            do k=1,nt
              if(equal_rational_matrix(Opt%Mat,Op(k)%Mat) .and. Opt%time_inv == Op(k)%time_inv) then
                tb(i,j)=k
                done(i,j)=.true.
                cycle do_j
              end if
            end do
            done(i,j)=.true.
            nt=nt+1
            if(nt > max_op) then
              nt=nt-1
              exit do_ext
            end if
            tb(i,j)=nt
            Op(nt)=Opt
          end do do_j
        end do
        if ( n == nt) exit do_ext
      end do do_ext
      if(any(done(1:nt,1:nt) .eqv. .false. ) ) then
        Err_ssg=.true.
        Err_ssg_mess="Table of SSG operators not exhausted! Increase the expected order of the group!"
      end if
      if(nt == max_op) then
        Err_ssg=.true.
        write(Err_ssg_mess,"(a,i5,a)") "Max_Order (",max_op,") reached! The provided generators may not form a group!"
      end if

      multip=nt
      if(present(table)) then
        allocate(Table(multip,multip))
        Table=tb
      end if
    End Subroutine Gen_Group

    Subroutine Gen_SSGroup(ngen,gen,SSG,x1x2x3_type,table)
      integer,                             intent(in)  :: ngen
      type(Symm_Oper_Type), dimension(:),  intent(in)  :: gen
      class(SuperSpaceGroup_Type),         intent(out) :: SSG
      character(len=*), optional,          intent(in)  :: x1x2x3_type
      integer, dimension(:,:), allocatable, optional, intent(out) :: table
      !--- Local variables ---!
      integer :: i,j,k, nt, Dd, Dex, ngeff, nlat,nalat, d
      type(Symm_Oper_Type), dimension(:), allocatable :: Op
      !type(Symm_Oper_Type) :: Opt
      integer, dimension(max_mult) :: ind_lat,ind_alat
      !logical :: esta
      character(len=15) :: xyz_typ

      nt=ngen
      Err_ssg=.false.
      Err_ssg_mess=" "
      SSG%standard_setting=.false.
      Dex=size(gen(1)%Mat,dim=1)
      Dd=Dex-1
      d=Dd-3
      SSG%nk= Dex-4
      call Allocate_Operators(d,max_mult,Op)
      call Set_Identity_Matrix(Dex)
      Op(1)%Mat=identity_matrix
      j=0
      do i=1,ngen
        if(equal_rational_matrix(gen(1)%Mat,identity_matrix)) then
            j=i
            exit
        end if
      end do
      k=1
      do i=1,ngen
        if(i == j) cycle
        k=k+1
        Op(k)=gen(i)
      end do
      ngeff=k
      nt=ngeff

      if(present(table)) then
        call Get_Group_From_Generators(ngeff,Op,nt,table)
      else
        call Get_Group_From_Generators(ngeff,Op,nt)
      end if

      if(Err_ssg) then
        write(unit=*,fmt="(a)") " => ERROR !  "//trim(Err_ssg_mess)
        return
      end if

      if(allocated(SSG%Op)) deallocate(SSG%Op)
      allocate(SSG%Op(nt))
      if(allocated(SSG%Symb_Op)) deallocate(SSG%Symb_Op)
      allocate(SSG%Symb_Op(nt))
      if(allocated(SSG%Centre_coord))  deallocate(SSG%Centre_coord)
      allocate(SSG%Centre_coord(Dd))
      SSG%Op(:)=Op(1:nt) !here there is a copy of the time inversion
      SSG%multip=nt
      xyz_typ="x1x2x3"
      if(present(x1x2x3_type)) xyz_typ=x1x2x3_type
      do i=1,nt
        call Get_Symb_Op_from_Mat(SSG%Op(i)%Mat,SSG%Symb_Op(i),xyz_typ,SSG%Op(i)%time_inv)
      end do

      !Search for an inversion centre
      j=0
      do i=2,nt
        if(equal_rational_matrix(SSG%Op(i)%Mat(1:Dd,1:Dd),-identity_matrix(1:Dd,1:Dd)) .and. SSG%Op(i)%time_inv == 1) then
            j=i
            exit
        end if
      end do
      SSG%Centre_coord=0_ik//1_ik
      if( j /= 0) then
        k=0
        do i=1,Dd
            if(SSG%Op(j)%Mat(Dex,i) /= 0_ik//1_ik) then
                k=i
                exit
            end if
        end do
        if(k == 0) then
            SSG%Centre="Centric with centre at origin"
            SSG%Centred=2
        else
            SSG%Centre="Centric with centre NOT at origin"
            SSG%Centred=0
            SSG%Centre_coord(:)=SSG%Op(k)%Mat(Dex,1:Dd)/2_ik
        end if
      else
        SSG%Centre="Acentric"
        SSG%Centred=1
      end if

      nlat=0
      nalat=0
      do i=2,nt
        if(equal_rational_matrix(SSG%Op(i)%Mat(1:Dd,1:Dd),identity_matrix(1:Dd,1:Dd))) then
          if(SSG%Op(i)%time_inv == 1) then
             nlat=nlat+1
             ind_lat(nlat)=i
          else
             nalat=nalat+1
             ind_alat(nalat)=i
          end if
        end if
      end do
      SSG%Num_Lat=nlat
      SSG%Num_aLat=nalat

      !Determine the type of magnetic group and select centring translations and anti-translations
      !if(any()) <- implement any for rational arrays
      if(nalat /= 0) then
         SSG%mag_type=4
         allocate(SSG%aLat_tr(Dd,nalat))
         SSG%aLat_tr=0_ik//1_ik
         do i=1,nalat
              j=ind_alat(i)
              SSG%aLat_tr(:,i)=SSG%Op(j)%Mat(1:Dd,Dex)
         end do
      else if(SSG%mag_type /= 1 ) then
         SSG%mag_type=3
      end if

      if(nlat /=  0) then
         SSG%SPG_Lat="X"
         allocate(SSG%Lat_tr(Dd,nlat))
         SSG%Lat_tr=0_ik//1_ik
         do i=1,nlat
              j=ind_lat(i)
              SSG%Lat_tr(:,i)=SSG%Op(j)%Mat(1:Dd,Dex)
         end do
      end if

    End Subroutine Gen_SSGroup

    Subroutine Set_SSGs_from_Gkk(SpG,nk,kv)!,ssg,nss)
      type(Space_Group_Type),                                intent(in)  :: SpG
      integer,                                               intent(in)  :: nk
      real(kind=cp),dimension(:,:),                          intent(in)  :: kv
      !class(SuperSpaceGroup_Type), dimension(:), allocatable, intent(out) :: ssg
      !integer,                                               intent(out) :: nss
      !--- Local variables ---!
      !character(len=132) :: line
      integer :: i,Dd
      type(Space_Group_Type),dimension(nk) :: Gkks !extended Little Groups
      type(Space_Group_Type)               :: Gkk  !extended Little Group (Intersection of Litte Groups for all nk)
      Type (Group_k_Type)                  :: Gk
        !Variables to be used in development
      !type(SuperSpaceGroup_Type)           :: trial_ssg
      !real(kind=cp), dimension(3+nk)       :: tr
      !integer,       dimension(3+nk,3+nk)  :: Mat

      !Initializing variables
      Err_ssg=.false.
      Err_ssg_mess=" "
      Dd=3+nk+1 !Dimension of the extended matrices of ssg

      !Determine the extended little Groups
      do i=1,nk
         call K_Star(kv(:,i),SpG,Gk,.true.)
         call Set_Gk(Gk,Gkks(i),.true.)
         call Write_Spacegroup(Gkks(i),Full=.true.)
      end do
      if(nk > 1) then !Determine the intersection of the space groups
        call set_Intersection_SPGt(Gkks,Gkk)
      else
        Gkk=Gkks(1)
      end if
      call Write_Spacegroup(Gkk,Full=.true.)
      !Derive possible superspace groups from Gkk
      !First: colorless groups of type 1
      !Second: black and white groups of type 3
      !Third: black and white groups of type 4

    End Subroutine Set_SSGs_from_Gkk


    Subroutine Set_Intersection_SPGt(SpGs,SpG)
      Type (Space_Group_Type),dimension(:), intent(in)   :: SpGs
      Type (Space_Group_Type),              intent(out)  :: SpG
      !--- Local Variables ---!
      integer :: i,j,k,ng,ipos,n
      character(len=40),dimension(192) :: gen
      logical,dimension(size(SpGs(:))) :: estak

      !write(*,"(/a/)") " => Entering subroutine Set_Intersection_SPGt "
      ipos=iminloc(SpGs(:)%multip)
      ng=1
      gen(1)="x,y,z"
      n=size(SpGs(:))
      estak=.false.
      estak(ipos)=.true.

      !write(*,"(3(a,i3))") " => Number of space groups: ",n, "  Position: ",ipos,"  Multiplicity:",SpGs(ipos)%multip

      do_ext:do i=2,SpGs(ipos)%multip
        ng=ng+1
        gen(ng)=SpGs(ipos)%SymopSymb(i)

        do j=1,n
           if(j == ipos) cycle
           estak(j)=.false.
           do k=2,SpGs(j)%multip
             !write(*,"(2i4,a,a)") k,ng, "   "//trim(gen(ng))//"   "//trim(SpGs(j)%SymopSymb(k))
             if(trim(SpGs(j)%SymopSymb(k)) == trim(gen(ng))) then
                 estak(j)=.true.
                 exit
             end if
           end do
        end do
        !write(*,*) estak
        k=count(estak(1:n))
        if(k /= n) then
          write(*,"(a,i3)") "  Operator: "//trim(gen(ng))//"  Discarded  ng=",ng-1
          ng=ng-1
          cycle
        end if
        !Passing here means that the operator is common to all space groups
        if(ng > 192) exit
      end do do_ext
      call Set_SpaceGroup(" ",SpG,gen,ng,Mode="GEN")

    End Subroutine Set_Intersection_SPGt

    Subroutine Set_SSG_Reading_Database(database_path,num,ssg,ok,Mess,x1x2x3_type)
      character(len=*),           intent(in)  :: database_path
      integer,                    intent(in)  :: num
      class(SuperSpaceGroup_Type),intent(out) :: ssg
      Logical,                    intent(out) :: ok
      character(len=*),           intent(out) :: Mess
      character(len=*),optional,  intent(in)  :: x1x2x3_type
      !
      integer :: i,j,nmod,Dd,D,iclass,m
      type(rational), dimension(:,:), allocatable :: Inv
      type(Symm_Oper_Type)                        :: transla
      character(len=15) :: xyz_typ !forma,
      logical :: inv_found

      if(.not. ssg_database_allocated)  then
         call Read_single_SSG(database_path,num,ok,Mess)
         if(.not. ok) then
           Err_ssg=.true.
           Err_ssg_mess=Mess
           return
         end if
      end if
      iclass=igroup_class(num)
      nmod=iclass_nmod(iclass)
      D=3+nmod
      Dd=D+1
      m=igroup_nops(num)* max(iclass_ncentering(iclass),1)
      call Allocate_Group(Dd,m,ssg)
      ssg%standard_setting=.true.
      ssg%SSG_symbol=group_label(num)
      ssg%SSG_Bravais=class_label(iclass)
      ssg%SSG_nlabel=group_nlabel(num)
      i=index(ssg%SSG_symbol,"(")
      ssg%Parent_spg=ssg%SSG_symbol(1:i-1)
      ssg%trn_from_parent="a,b,c;0,0,0"
      ssg%trn_to_standard="a,b,c;0,0,0"
      ssg%Centre="Acentric"                    ! Alphanumeric information about the center of symmetry
      ssg%nk=nmod                              !(d=1,2,3, ...) number of q-vectors
      ssg%Parent_num=igroup_spacegroup(num)    ! Number of the parent Group
      ssg%Bravais_num=igroup_class(num)        ! Number of the Bravais class
      ssg%Num_Lat=iclass_ncentering(iclass)-1  ! Number of centring points in a cell (notice that in the data base
                                               ! what is stored ins the number of lattice points per cell: Num_lat+1
      if( ssg%Num_Lat > 0 .and. ssg%SSG_symbol(1:1) == "P" ) then
        ssg%SPG_Lat="Z"
      else
        ssg%SPG_Lat=ssg%SSG_symbol(1:1)
      end if
      xyz_typ="xyz"
      if(present(x1x2x3_type)) xyz_typ=x1x2x3_type
      ssg%mag_type= 1                        ! No time-reversal is associated with the symmetry operators
      ssg%Num_aLat=0                         ! Number of anti-lattice points in a cell (here is always zero because the database if for crystallographic groups)
      ssg%Centred= 1                         ! Centric or Acentric [ =0 Centric(-1 no at origin),=1 Acentric,=2 Centric(-1 at origin)]
      ssg%NumOps=igroup_nops(num)            ! Number of reduced set of S.O. (removing lattice centring)
      ssg%Multip=m     ! General multiplicity

      if( ssg%Num_Lat > 0) then
        Allocate(ssg%Lat_tr(D,ssg%Num_Lat))
        ssg%Lat_tr=0_ik//1_ik
      end if
      Allocate(ssg%kv(3,nmod))
      Allocate(ssg%Centre_coord(D))
      ssg%kv=0.0;  ssg%Centre_coord=0_ik//1_ik
      !forma="(a,i3, i4)"
      !write(forma(7:7),"(i1)") Dd
      if( ssg%Num_Lat > 0) then
         do j=1,ssg%Num_Lat
            !write(*,forma) " Vector #",j, iclass_centering(1:Dd,j,iclass)
            ssg%Lat_tr(1:D,j)= rational_simplify(iclass_centering(1:D,j+1,iclass)//iclass_centering(Dd,j+1,iclass))
         end do
      end if
      do i=1,ssg%NumOps
         ssg%Op(i)%Mat= rational_simplify(igroup_ops(1:Dd,1:Dd,i,num)//igroup_ops(Dd,Dd,i,num))
         call Get_Symb_Op_from_Mat(ssg%Op(i)%Mat,ssg%Symb_Op(i),xyz_typ)
         !write(*,"(i4,a)") i,"  "//trim(ssg%Symb_Op(i))
      end do

      !Look for a centre of symmetry
      inv_found=.false.
      allocate(Inv(D,D),transla%Mat(Dd,Dd))
      Inv=0//1; transla%Mat=0//1
      do i=1,D
        Inv(i,i) = -1//1
      end do
      do i=1,Dd
        transla%Mat(i,i) = 1//1
      end do

      do i=1,ssg%NumOps
        if(equal_rational_matrix(Inv,ssg%Op(i)%Mat(1:D,1:D))) then
          if(sum(ssg%Op(i)%Mat(1:D,Dd)) == 0_ik//1_ik) then
            ssg%Centred=2
            ssg%Centre_coord=0_ik//1_ik
            ssg%Centre="Centrosymmetric with centre at origin"
          else
            ssg%Centred=0
            ssg%Centre_coord=ssg%Op(i)%Mat(1:D,Dd)/2_ik
            write(unit=ssg%Centre,fmt="(a)") "Centrosymmetric with centre at : "//print_rational(ssg%Centre_coord)
          end if
          exit
        end if
      end do
      !Extend the symmetry operator to the whole set of lattice centring
      !set the symmetry operators symbols
      m=ssg%NumOps
      do i=1,ssg%Num_Lat
        transla%Mat(1:D,Dd)=ssg%Lat_tr(1:D,i)
        do j=1,ssg%NumOps
           m=m+1
           ssg%Op(m)=ssg%Op(j)*transla
        end do
      end do
      if(m /= ssg%Multip) then
        Err_ssg=.true.
        Err_ssg_mess="Error extending the symmetry operators for a centred cell"
      end if
      !Adjust ssg%NumOps to remove the centre of symmetry if Exist
      if(ssg%Centred == 2 .or. ssg%Centred == 0) ssg%NumOps=ssg%NumOps/2
      !Get the symmetry symbols
      do i=1,ssg%Multip
        call Get_Symb_Op_from_Mat(ssg%Op(i)%Mat,ssg%Symb_Op(i),xyz_typ)
        !write(*,*) trim(ssg%Symb_Op(i))
      end do

    End Subroutine Set_SSG_Reading_Database

    Subroutine k_SSG_compatible(SSG,k_out)
      class(Spg_Type),  intent(in)  :: SSG
      !real(kind=cp), dimension(3,size(SSG%Op(1)%Mat,1)-4),intent(out) :: k_out
      real(kind=cp), dimension(3,6),intent(out) :: k_out
      !--- Local variables ---!
      real(kind=cp), dimension(3,6) :: kini
      real(kind=cp), dimension(3,  SSG%NumOps) :: kv
      real(kind=cp), dimension(3,3,SSG%NumOps) :: mat
      integer :: i,j
      kini(:,1)= [0.1234,0.4532,0.7512]
      kini(:,2)= [0.0000,0.4532,0.7512]
      kini(:,3)= [0.1234,0.0000,0.7512]
      kini(:,4)= [0.1234,0.4532,0.5000]
      kini(:,5)= [0.5000,0.4532,0.5000]
      kini(:,6)= [0.3333,0.5000,0.6666]

      do i=1,SSG%NumOps
        mat(:,:,i)=SSG%Op(i)%Mat(1:3,1:3)
      end do
      do j=1,6
        k_out(:,j)=0.0
        do i=1,SSG%NumOps
          kv(:,i)=matmul(kini(:,j),mat(:,:,i))
          k_out(:,j)=k_out(:,j)+kv(:,i)
        end do
      end do
    End Subroutine k_SSG_compatible

    Subroutine Write_SSG(SpaceGroup,iunit,full,x1x2x3_typ,kinfo)
      class(SuperSpaceGroup_Type),     intent(in) :: SpaceGroup
      integer,              optional, intent(in) :: iunit
      logical,              optional, intent(in) :: full
      logical,              optional, intent(in) :: x1x2x3_typ
      type(kvect_info_type),optional, intent(in) :: kinfo
      !---- Local variables ----!
      integer :: lun,i,j,D,Dd,nlines,nk
      character(len=40),dimension(:),  allocatable :: vector
      character(len=40),dimension(:,:),allocatable :: matrix
      character(len=20)                            :: forma,xyz_typ
      integer,  parameter                          :: max_lines=192
      character (len=100), dimension(max_lines)    :: texto
      logical                                      :: print_latt

      lun=6
      print_latt=.false.
      if (present(iunit)) lun=iunit
      if (present(full))  print_latt=.true.
      xyz_typ="xyz"
      if(present(x1x2x3_typ)) then
        xyz_typ="x1x2x3"
      end if
      nk=SpaceGroup%nk
      D=3+nk
      Dd=D+1
      allocate(vector(D),matrix(Dd,Dd))
      write(unit=lun,fmt="(/,a)")           "        Information on SuperSpace Group: "
      write(unit=lun,fmt="(a,/ )")          "        ------------------------------- "
      write(unit=lun,fmt="(a,a)")           " =>   Number of Space group: ", trim(SpaceGroup%SSG_nlabel)
      write(unit=lun,fmt="(a,a)")           " => SuperSpace Group Symbol: ", trim(SpaceGroup%SSG_symbol)
      write(unit=lun,fmt="(a,a)")           " =>    Bravais Class Symbol: ", trim(SpaceGroup%SSG_Bravais)
      write(unit=lun,fmt="(a,a)")           " =>      Parent Space Group: ", trim(SpaceGroup%Parent_spg)
      write(unit=lun,fmt="(a, a)")          " =>             Point group: ", trim(SpaceGroup%pg)
      write(unit=lun,fmt="(a, a)")          "                 Laue class: ", trim(SpaceGroup%laue)
      if(.not. SpaceGroup%standard_setting) then
        write(unit=lun,fmt="(a,a)")         " =>     Transf. from Parent: ", trim(SpaceGroup%trn_from_parent)
        write(unit=lun,fmt="(a,a)")         " =>     Transf. to Standard: ", trim(SpaceGroup%trn_to_standard)
      end if
      write(unit=lun,fmt="(a,i3)")          " =>           Magnetic Type: ", SpaceGroup%mag_type
      write(unit=lun,fmt="(a,a)")           " =>          Centrosymmetry: ", trim(SpaceGroup%Centre)
      write(unit=lun,fmt="(a,a)")           " =>         Bravais Lattice: ", "  "//trim(SpaceGroup%SPG_Lat)

      write(unit=lun,fmt="(a,i3)")          " => Number of  Parent Group: ", SpaceGroup%Parent_num
      write(unit=lun,fmt="(a,i3)")          " => Number of Bravais Class: ", SpaceGroup%Bravais_num
      write(unit=lun,fmt="(a,i3)")          " => Number of q-vectors (d): ", SpaceGroup%nk
      write(unit=lun,fmt="(a,i3)")          " =>   # of Centring Vectors: ", max(SpaceGroup%Num_Lat,0)
      write(unit=lun,fmt="(a,i3)")          " => # Anti-Centring Vectors: ", SpaceGroup%Num_aLat

      !write(unit=lun,fmt="(a,a)")           " =>          Crystal System: ", trim(SpaceGroup%CrystalSys)
      !write(unit=lun,fmt="(a,a)")           " =>              Laue Class: ", trim(SpaceGroup%Laue)
      !write(unit=lun,fmt="(a,a)")           " =>             Point Group: ", trim(SpaceGroup%Pg)


      write(unit=lun,fmt="(a,i3)")          " =>  Reduced Number of S.O.: ", SpaceGroup%NumOps
      write(unit=lun,fmt="(a,i3)")          " =>    General multiplicity: ", SpaceGroup%Multip
      !write(unit=lun,fmt="(a,i4)")          " =>  Generators (exc. -1&L): ", SpaceGroup%num_gen
      if (SpaceGroup%centred == 0) then
         do i=1,d
           texto(i)=print_rational(SpaceGroup%Centre_coord(i))
         end do
         write(texto(d+1),"(15a5)") "(",(trim(texto(i))//",",i=1,d-1),trim(texto(d))//")"
         texto(1)=pack_string(texto(d+1))
         write(unit=lun,fmt="(a)")      " =>               Centre at: "//trim(texto(1))
      end if
      if(present(kinfo) .and. SpaceGroup%nk > 0) then
         write(unit=lun,fmt="(a,i3)")       " => List Modulation vectors: ",kinfo%nk
         write(unit=lun,fmt="(a)") "    n      kx        ky        kz     nharm   sintl-max"
         do i=1,kinfo%nk
           write(unit=lun,fmt="(i5,3f10.5,i8,f12.5)")  i, kinfo%kv(:,i),kinfo%nharm(i),kinfo%sintlim(i)
         end do
         if(kinfo%nq > 0) then
         forma="(a,i2.2,a,  i2,a)"
         write(unit=forma(11:12),fmt="(i2)") nk
          write(unit=lun,fmt="(a,i3)")       " => List of q_coefficients (Harmonics): ",kinfo%nq
          do i=1,kinfo%nq
            write(unit=lun,fmt=forma)  "    q_",i,"  [", kinfo%q_coeff(1:nk,i)," ]"
          end do
         end if
         write(unit=lun,fmt="(a)") " "
      end if
      if (print_latt .and. max(SpaceGroup%Num_lat,0) > 0) then
         texto(:) (1:100) = " "
         forma="(a,i2,a,   a)"
         write(unit=forma(9:11),fmt="(i3)") D
         write(unit=lun,fmt="(a,i3)")       " =>        Centring vectors: ",SpaceGroup%Num_lat
         nlines=1
         do i=1,SpaceGroup%Num_lat
            vector=print_rational(SpaceGroup%Lat_tr(:,i))
            if (mod(i,2) == 0) then
               write(unit=texto(nlines)(51:100),fmt=forma) &
                                          " => Latt(",i,"): ",(trim(vector(j))//" ",j=1,D)
               nlines=nlines+1
            else
               write(unit=texto(nlines)( 1:50),fmt=forma)  &
                                          " => Latt(",i,"): ",(trim(vector(j))//" ",j=1,D)
            end if
         end do
         do i=1,nlines
            write(unit=lun,fmt="(a)") texto(i)
         end do
      end if
      !Writing of the rational operator matrices
      forma="( a8)"
      write(forma(2:2),"(i1)") Dd
      nlines=SpaceGroup%NumOps
      if(print_latt) nlines=SpaceGroup%Multip
      if(present(x1x2x3_typ)) then
         do i=1,nlines
           call Get_Symb_Op_from_Mat(SpaceGroup%Op(i)%Mat,texto(1),xyz_typ,SpaceGroup%Op(i)%time_inv)
           write(unit=lun,fmt="(a,i3,a)") "  Operator # ",i,"  "//trim(texto(1))
         end do
      else
         do i=1,nlines
           write(unit=lun,fmt="(a,i3,a)") "  Operator # ",i,"  "//trim(SpaceGroup%Symb_Op(i))
         end do
      end if
    End Subroutine Write_SSG

    Function H_S(hkl,Cell,nk,kv) result(s)
        integer, dimension(:),                  intent(in) :: hkl
        type(Crystal_Cell_Type),                intent(in) :: Cell
        integer, optional,                      intent(in) :: nk
        real(kind=cp),dimension(:,:), optional, intent(in) :: kv
        real(kind=cp)   :: s
        !--- Local variables ---!
        real(kind=cp), dimension(3) :: h
        integer :: i

        h=hkl(1:3)
        if(present(nk) .and. present(kv)) then
           do i=1,nk
                h=h+hkl(3+i)*kv(:,i)
           end do
        end if
      s= 0.5*sqrt( h(1)*h(1)*Cell%GR(1,1) +     h(2)*h(2)*Cell%GR(2,2) + &
                   h(3)*h(3)*Cell%GR(3,3) + 2.0*h(1)*h(2)*Cell%GR(1,2) + &
               2.0*h(1)*h(3)*Cell%GR(1,3) + 2.0*h(2)*h(3)*Cell%GR(2,3) )
    End Function H_S

    Function H_Equal(H,K) Result (Info)
       !---- Arguments ----!
       integer, dimension(:), intent(in) :: h,k
       logical                           :: info
       integer :: i

       info=.true.
       do i=1,size(h)
         if (h(i) /= k(i)) then
          info=.false.
          return
         end if
       end do

    End Function H_Equal

    Function H_Equiv(H,K,SSG,Friedel) Result (Info)
       !---- Arguments ----!
       integer, dimension(:),        intent(in)  :: h,k
       class(SuperSpaceGroup_Type),  intent(in)  :: SSG
       logical, optional,            intent(in)  :: Friedel
       logical                                   :: info

       !---- Local Variables ----!
       integer                                      :: i, nops,Dd
       integer, dimension(size(h))                  :: hh
       Integer, dimension(size(h),size(h))          :: Mat


       info=.false.
       nops= SSG%NumOps
       if(SSG%centred /= 1) nops=min(nops*2,SSG%Multip)

       Dd=size(h)
       do i=1,nops
          Mat=SSG%Op(i)%Mat(1:Dd,1:Dd)
          hh = matmul(h,Mat)
          if (H_equal(k,hh)) then
             info=.true.
             exit
          end if
          if (present(Friedel)) then
             if (Friedel) then
                if (h_equal(k,-hh)) then
                   info=.true.
                   exit
                end if
             end if
          end if
       end do

       return
    End Function H_Equiv

    Subroutine Print_Matrix_SSGop(SSop,lun)
       Type(Symm_Oper_Type), intent(in) :: SSop
       integer, optional,    intent(in) :: lun
       !
       character(len=8),dimension(size(SSop%Mat,dim=1),size(SSop%Mat,dim=2)) :: Matrix
       character(len=10) :: forma
       integer           :: Dd, j, k, iout,d_half

       iout=6
       if(present(lun)) iout=lun
       Dd=size(SSop%Mat,dim=1)
       d_half=Dd/2
       forma="( a8,a,i2)"
       write(forma(2:2),"(i1)") Dd
       matrix=print_rational(SSop%Mat)
       do j=1,d_half
          write(unit=iout,fmt=forma) (trim(Matrix(j,k)) //" ",k=1,Dd)
       end do
       write(unit=iout,fmt=forma) (trim(Matrix(d_half+1,k)) //" ",k=1,Dd),"  time_inv=",SSop%time_inv
       do j=d_half+2,Dd
          write(unit=iout,fmt=forma) (trim(Matrix(j,k)) //" ",k=1,Dd)
       end do
    End Subroutine Print_Matrix_SSGop

    Function H_Lat_Absent(h,Latt,n) result(info)
       integer,        dimension(:),  intent (in) :: h
       type(rational), dimension(:,:),intent (in) :: Latt
       integer,                       intent (in) :: n
       logical                                    :: info

       !---- Local Variables ----!
       integer                          :: k,i
       real(kind=cp),dimension(size(h)) :: Lat
       real(kind=cp)                    :: r1,r2

       info=.false.
       do i=1,n
          Lat=Latt(:,i)
          r1=dot_product(Lat,real(h,kind=cp))
          r2=nint(r1)
          k=nint(2.0*r1)
          if(mod(k,2) /= 0) info=.true.
          exit
       end do
       return
    End Function H_Lat_Absent

    Function H_Absent_SSG(H,SSG) Result(Info)
       !---- Arguments ----!
       integer, dimension(:),            intent (in) :: h
       class(SuperSpaceGroup_Type),      intent (in) :: SSG
       logical                                       :: info

       !---- Local Variables ----!
       integer, dimension(size(h))        :: k
       integer                            :: i,Dd
       real(kind=cp)                      :: r1,r2
       Integer,dimension(size(h),size(h)) :: Mat
       real(kind=cp),dimension(size(h))   :: tr

       info=.false.
       Dd=size(h)
       do i=1,SSG%multip
          Mat=SSG%Op(i)%Mat(1:Dd,1:Dd)
          k = matmul(h,Mat)
          if (h_equal(h,k)) then
             tr=SSG%Op(i)%Mat(1:Dd,Dd+1)
             r1=dot_product(tr,real(h,kind=cp))
             r2=nint(r1)
             if (abs(r1-r2) > eps_ref) then
                info=.true.
                exit
             end if
          end if
       end do
    End Function H_Absent_SSG

    Function mH_Absent_SSG(H,SSG) Result(Info)
       !---- Arguments ----!
       integer, dimension(:),       intent (in) :: h
       class(SuperSpaceGroup_Type), intent (in) :: SSG
       logical                                  :: info

       !---- Local Variables ----!
       integer,       dimension(size(h))        :: k
       integer,       dimension(size(h),size(h)):: Mat
       real(kind=cp), dimension(size(h))        :: tr
       integer                                  :: i,n_id,Dd
       real(kind=cp)                            :: r1 !,r2

       info=.false.
       Dd=size(h)
       Select Case(SSG%mag_type)
         Case(1,3)
           n_id=0
           do i=1,SSG%Multip
              Mat=SSG%Op(i)%Mat(1:Dd,1:Dd)
              tr= SSG%Op(i)%Mat(1:Dd,Dd+1)
              k = matmul(h,Mat)
              if (h_equal(h,k)) then
                 r1=cos(tpi*dot_product(Tr,real(h)))
                 n_id=n_id+Trace(Mat*nint(r1))
              end if
           end do
           if(n_id == 0) info=.true.
         Case(2)
           info=.true.
         Case(4)
           info=.true.
           do i=1,SSG%Num_aLat
              tr=SSG%aLat_tr(:,i)
              r1=cos(tpi*dot_product(tr,real(h)))
              if(nint(r1) == -1) info=.false.
           end do
       End Select
    End Function mH_Absent_SSG

    !!----
    !!---- Function  H_Mult(H, Spacegroup,Friedel)
    !!----    integer, dimension(:),       intent(in) :: h
    !!----    class(SuperSpaceGroup_Type), intent(in) :: SpaceGroup
    !!----    Logical,                     intent(in) :: Friedel
    !!----
    !!----    Calculate the multiplicity of the reflection
    !!----
    !!----    Created: June - 2017
    !!
    Function H_Mult(H,Spacegroup,Friedel) Result(N)
       !---- Arguments ----!
       integer, dimension(:),       intent (in)  :: h
       class(SuperSpaceGroup_Type), intent (in)  :: SpaceGroup
       Logical,                     intent (in)  :: Friedel
       integer                                   :: N

       !---- Local Variables ----!
       logical                                      :: esta
       integer, dimension(size(h))                  :: k
       integer, dimension(size(h),size(h))          :: Mat
       integer                                      :: i,j,ng,Dd
       integer, dimension(size(h),SpaceGroup%numops):: klist

       ng=SpaceGroup%numops
       n=1
       Dd=size(h)
       if (ng > 1) then
           klist(:,1)=h(:)

           do i=2,ng
              Mat=SpaceGroup%Op(i)%Mat(1:Dd,1:Dd)
              k = matmul(h,Mat)
              esta=.false.
              do j=1,n
                 if (h_equal(k,klist(:,j)) .or. h_equal(-k,klist(:,j))) then
                    esta=.true.
                    exit
                 end if
              end do
              if (esta) cycle
              n=n+1
              klist(:,n) = k
           end do
       end if
       if (Friedel .or. SpaceGroup%centred == 2) then
           n=n*2
       end if

       return
    End Function H_Mult

    Subroutine Get_h_info(h,SSG,mag,info)
       integer, dimension(:),      intent (in) :: h
       class(SuperSpaceGroup_Type),intent (in) :: SSG
       logical,                    intent (in) :: mag
       integer, dimension(4),      intent(out) :: info

       info=0  !Reflection allowed (lattice, Nuclear, Magnetic, Ref-character)
               ! For the three initial componentes 0:allowed, 1:absent
               ! Ref-character: 0:pure nuclear, 1:pure magnetic, 2:nuclear+magnetic

       if(SSG%Num_Lat > 0) then
         if (H_Lat_Absent(h,SSG%Lat_tr,SSG%Num_Lat)) then
           info(1:3)=1  !lattice absence and, as a consequence, nuclear and magnetic absence
           return
         end if
       end if
       if(H_Absent_SSG(h,SSG)) then
         info(2)=1  !Nuclear absence
         if(SSG%Mag_type /= 2 .and. mag) then
           if(mH_Absent_SSG(h,SSG)) then
             info(3)=1 !Magnetic absence
           else
             info(4)=1   !Pure magnetic
           end if
         end if
       else
         info(2)=0
         if(SSG%Mag_type /= 2) then
           if(mH_Absent_SSG(h,SSG)) then
             info(4)=0  !pure nuclear
           else
             info(4)=2
           end if
         end if
       end if
    End Subroutine Get_h_info

    !!---- Subroutine Get_Mat_From_SSymSymb(Symb,Mat,invt)
    !!----   character(len=*),                intent(in)  :: Symb
    !!----   type(rational),dimension(:,:),   intent(out) :: Mat
    !!----   integer, optional                            :: invt
    !!----
    !!----  This subroutine provides the rational matrix Mat in standard
    !!----  form (all translation components positive) corresponding to the
    !!----  operator symbol Symb in Jone's faithfull notation.
    !!----  The symbol is not modified but the matrix contain reduced translation.
    !!----  Some checking on the correctness of the symbol is performed
    !!----
    !!----  Created: June 2017 (JRC)
    !!----
    Subroutine Get_Mat_From_SSymSymb(Symb,Mat,invt)
      character(len=*),                intent(in)  :: Symb
      type(rational),dimension(:,:),   intent(out) :: Mat
      integer, optional                            :: invt
      !---- local variables ----!
      type(rational) :: det
      integer :: i,j,k,Dd, d, np,ns, n,m,inv,num,den,ind,ier
      character(len=*),dimension(10),parameter :: xyz=(/"x","y","z","t","u","v","w","p","q","r"/)
      character(len=*),dimension(10),parameter :: x1x2x3=(/"x1 ","x2 ","x3 ","x4 ","x5 ","x6 ","x7 ","x8 ","x9 ","x10"/)
      character(len=*),dimension(10),parameter :: abc=(/"a","b","c","d","e","f","g","h","i","j"/)
      character(len=3),dimension(10)           :: x_typ
      character(len=len(Symb)), dimension(size(Mat,dim=1))  :: split
      character(len=len(Symb))                              :: string,pSymb,translation,transf
      character(len=10),        dimension(size(Mat,dim=1))  :: subst
      integer,                  dimension(size(Mat,dim=1)-1):: pos,pn
      logical                                               :: abc_transf

      err_ssg=.false.
      err_ssg_mess=" "
      Dd=size(Mat,dim=1)
      d=Dd-1
      abc_transf=.false.
      x_typ=xyz
      i=index(Symb,"x2")
      if(i /= 0) x_typ=x1x2x3
      i=index(Symb,"b")
      if(i /= 0) then
        x_typ=abc
        abc_transf=.true.
      end if
      Mat=0//1
      if(abc_transf) then
        i=index(Symb,";")
        if(i == 0) return !check for errors
        translation=pack_string(Symb(i+1:)//",0")
        pSymb=pack_string(Symb(1:i-1)//",1")
        call Get_Separator_Pos(translation,",",pos,np)
        if(np /= d-1) then
          err_ssg=.true.
          err_ssg_mess="Error in the origin coordinates"
          return
        end if
        j=1
        do i=1,d
          split(i)=translation(j:pos(i)-1)
          j=pos(i)+1
        end do

        do i=1,d
            k=index(split(i),"/")
            if(k /= 0) then
              read(unit=split(i)(1:k-1),fmt=*) num
              read(unit=split(i)(k+1:),fmt=*) den
            else
              den=1
              read(unit=split(i),fmt=*) num
            end if
            Mat(i,Dd)= num//den
        end do
        split=" "

      else

        pSymb=pack_string(Symb)

      end if

      if(index(pSymb,"=") /= 0) then
          err_ssg=.true.
          err_ssg_mess="Error in the symbol of the operator: symbol '=' is forbidden!"
          return
      end if

      if(index(pSymb,";") /= 0) then
          err_ssg=.true.
          err_ssg_mess="Error in the symbol of the operator: symbol ';' is forbidden!"
          return
      end if

      if(index(pSymb,".") /= 0) then
          err_ssg=.true.
          err_ssg_mess="Error in the symbol of the operator: symbol '.' is forbidden!"
          return
      end if

      pos=0
      call Get_Separator_Pos(pSymb,",",pos,np)
      if(np /= d) then
      	if(np == d-1) then
      		do i=1,d
      			j=index(pSymb,trim(x_typ(i)))
      			if(j == 0) then !error in the symbol
              err_ssg=.true.
              err_ssg_mess="Error in the symbol of the operator: Missing ( "//trim(x_typ(i))//" )"
              return
      			end if
      		end do
      		pSymb=trim(pSymb)//",1"
      		np=np+1
      		pos(np)=len_trim(pSymb)-1
        else
          err_ssg=.true.
          err_ssg_mess="Error in the symbol of the operator"
          return
        end if
      else !Check the presence of all symbols
      	do i=1,d
      		j=index(pSymb(1:pos(np)),trim(x_typ(i)))
      		if(j == 0) then !error in the symbol
            err_ssg=.true.
            err_ssg_mess="Error in the symbol of the operator: Missing ( "//trim(x_typ(i))//" )"
            return
      		end if
      	end do
      end if

      read(unit=pSymb(pos(np)+1:),fmt=*,iostat=ier) inv
      if(ier == 0) then
        Mat(Dd,Dd)=1//1
        if (present(invt)) invt = inv
      else
        Mat(Dd,Dd)=1//1
        if (present(invt)) invt = 1
      end if
      j=1
      do i=1,d
        split(i)=pSymb(j:pos(i)-1)
        j=pos(i)+1
        !write(*,"(i3,a)")  i, "  "//trim(split(i))
      end do
      !Analysis of each item
                      !   |     |  |  |  <- pos(i)
      !items of the form  -x1+3/2x2-x3+x4+1/2
                      !   |  |     |  |  |  <- pn(m)
                      !   -  +3/2  -  +  +1/2
      do i=1,d
        string=split(i)
        pn=0; m=0
        do j=1,len_trim(string)
          if(string(j:j) == "+" .or. string(j:j) == "-" ) then
            m=m+1
            pn(m)=j
          end if
        end do
        if(m /= 0) then
          if(pn(1) == 1) then
            n=0
          else
            subst(1)=string(1:pn(1)-1)
            n=1
          end if
          do k=1,m-1
            n=n+1
            subst(n)=string(pn(k):pn(k+1)-1)
          end do
          if(pn(m) < len_trim(string)) then
            n=n+1
            subst(n)=string(pn(m):)
          end if
        else
          n=1
          subst(1)=string
        end if

        !write(*,"(11a)") " ---->  "//trim(string),("  "//trim(subst(k)),k=1,n)

        ! Now we have n substrings of the form +/-p/qXn  or +/-p/q or +/-pXn/q or Xn or -Xn
        ! Look for each substring the item x_typ and replace it by 1 or nothing
        ! m is reusable now
        do j=1,n
          k=0
          do m=1,d
             k=index(subst(j),trim(x_typ(m)))
             if(k /= 0) then
               ind=m
               exit
             end if
          end do
          if(k == 0) then !pure translation
            k=index(subst(j),"/")
            if(k /= 0) then
              read(unit=subst(j)(1:k-1),fmt=*) num
              read(unit=subst(j)(k+1:),fmt=*) den
            else
              den=1
              read(unit=subst(j),fmt=*) num
            end if
            Mat(i,Dd)= num//den
          else  !Component m of the row_vector
            !suppress the symbol
            subst(j)(k:k+len_trim(x_typ(ind))-1)=" "
            if( k == 1 ) then
              subst(j)(1:1)="1"
            else if(subst(j)(k-1:k-1) == "+" .or. subst(j)(k-1:k-1) == "-") then
              subst(j)(k:k)="1"
            else
              subst(j)=pack_string(subst(j))
            end if
            !Now read the integer or the rational
            k=index(subst(j),"/")
            if( k /= 0) then
              read(unit=subst(j)(1:k-1),fmt=*) num
              read(unit=subst(j)(k+1:),fmt=*) den
            else
              den=1
              read(unit=subst(j),fmt=*) num
            end if
            Mat(i,ind)=num//den
          end if
        end do
      end do

      !Put the generator in standard form with positive translations
      call reduced_translation(Mat)

      !Final check that the determinant of the rotational matrix is integer
      det=rational_determinant(Mat)
      if(det%denominator /= 1) then
         err_ssg=.true.
         err_ssg_mess="The determinant of the matrix is not integer! -> "//print_rational(det)
      end if
      if(det%numerator == 0) then
         err_ssg=.true.
         err_ssg_mess="The matrix of the operator is singular! -> det="//print_rational(det)
      end if
    End Subroutine Get_Mat_From_SSymSymb

    Subroutine Get_SSymSymb_from_Mat(Mat,Symb,x1x2x3_type,invt)
       !---- Arguments ----!
       type(rational),dimension(:,:), intent( in) :: Mat
       integer, optional,             intent( in) :: invt
       character (len=*),             intent(out) :: symb
       character(len=*), optional,    intent( in) :: x1x2x3_type

       !---- Local Variables ----!
       character(len=*),dimension(10),parameter :: xyz=(/"x","y","z","t","u","v","w","p","q","r"/)
       character(len=*),dimension(10),parameter :: x1x2x3=(/"x1 ","x2 ","x3 ","x4 ","x5 ","x6 ","x7 ","x8 ","x9 ","x10"/)
       character(len=*),dimension(10),parameter :: abc=(/"a","b","c","d","e","f","g","h","i","j"/)
       character(len=3),dimension(10)   :: x_typ
       character(len= 15)               :: car
       character(len= 40)               :: translation
       character(len= 40),dimension(10) :: sym
       integer                          :: i,j,Dd,d,k
       logical                          :: abc_type
       Dd=size(Mat,dim=1)
       d=Dd-1
       x_typ=xyz
       abc_type=.false.
       if(present(x1x2x3_type)) then
         Select Case (trim(x1x2x3_type))
          Case("xyz")
            x_typ=xyz
          Case("x1x2x3")
            x_typ=x1x2x3
          Case("abc")
            x_typ=abc
            abc_type=.true.
          Case Default
          	x_typ=xyz
         End Select
       end if
       !---- Main ----!
       symb=" "
       translation=" "
       do i=1,d
          sym(i)=" "
          do j=1,d
             if(Mat(i,j) == 1_ik) then
                sym(i) = trim(sym(i))//"+"//trim(x_typ(j))
             else if(Mat(i,j) == -1_ik) then
                sym(i) =  trim(sym(i))//"-"//trim(x_typ(j))
             else if(Mat(i,j) /= 0_ik) then
               car=adjustl(print_rational(Mat(i,j)))
               k=index(car,"/")
               if(k /= 0) then
                 if(car(1:1) == "1") then
                   car=trim(x_typ(j))//car(k:)
                 else if(car(1:2) == "-1") then
                   car="-"//trim(x_typ(j))//car(k:)
                 else
                   car=car(1:k-1)//trim(x_typ(j))//car(k:)
                 end if
               else
                 car=trim(car)//trim(x_typ(j))
               end if
               !write(unit=car,fmt="(i3,a)") int(Mat(i,j)),trim(x_typ(j))
               if(Mat(i,j) > 0_ik) car="+"//trim(car)
               sym(i)=trim(sym(i))//pack_string(car)
             end if
          end do
          !Write here the translational part for each component
          if (Mat(i,Dd) /= 0_ik) then
            car=adjustl(print_rational(Mat(i,Dd)))
            if(abc_type) then
              translation=trim(translation)//","//trim(car)
            else
               if(car(1:1) == "-") then
                  sym(i)=trim(sym(i))//trim(car)
               else
                  sym(i)=trim(sym(i))//"+"//trim(car)
               end if
            end if
          else
            if(abc_type) translation=trim(translation)//",0"
          end if
          sym(i)=adjustl(sym(i))
          if(sym(i)(1:1) == "+")  then
            sym(i)(1:1) = " "
            sym(i)=adjustl(sym(i))
          end if
          sym(i)=pack_string(sym(i))
       end do
       symb=sym(1)
       do i=2,d
         symb=trim(symb)//","//trim(sym(i))
       end do
       if(abc_type)then
          symb=trim(symb)//";"//trim(translation(2:))
       else
         if(present(invt)) then
           write(unit=car,fmt="(i2)") invt !print_rational(Mat(Dd,Dd))
           car=adjustl(car)
           symb=trim(symb)//","//trim(car)
         end if
       end if
    End Subroutine Get_SSymSymb_from_Mat

    Subroutine Get_Average_SPG(ssg, SpG)
      class(SuperSpaceGroup_Type),     intent (in) :: ssg
      type (Space_Group_Type),         intent(out) :: SpG
      !Local variables
      integer :: i, j, k, ngen,tim, d
      type(SuperSpaceGroup_Type)   :: group
      character(len=:),allocatable :: gengroup
      character(len=2)  :: ty
      character(len=40) :: aux
      character(len=40), dimension(:),allocatable :: gen
      character(len=6) :: x1x2x3_type
      gengroup="  "
      gengroup=ssg%generators_list
      !Modify the operators to eliminate internal space parts and time inversion
      call Get_Operators_From_String(ssg%generators_list,d,ngen,gen)
      gengroup="                                                   "
      ty="x4"
      x1x2x3_type="x1x2x3"
      j=index(gen(1),"x4")
      if(j == 0) then
        ty="t"
        x1x2x3_type="xyz"
      end if
      do i=1,ngen
        aux=gen(i)
        j=index(aux,trim(ty))
        k=index(aux,",",back=.true.)
        read(unit=aux(k+1:),fmt=*) tim
        aux=aux(1:j-1)
        k=index(aux,",",back=.true.)
        write(unit=aux(k+1:),fmt="(i1)") abs(tim)
        gengroup=trim(gengroup)//trim(aux)//";"
      end do

      call Group_Constructor(gengroup,group)
       !Copy the elements of group into SpG
       SpG%Num_gen=ngen
       SpG%NumLat = group%num_lat+1
       allocate(SpG%Latt_trans(3,SpG%NumLat))
       SpG%Latt_trans=0.0
       do i=1,group%num_lat
         SpG%Latt_trans(:,i+1)=group%Lat_tr(:,i)
       end do
       SpG%Numops = group%Numops
       SpG%Centred= group%centred
       SpG%Centre= group%Centre
       if(allocated(group%Centre_coord)) SpG%Centre_coord= group%Centre_coord
       SpG%Multip = group%multip
       allocate(SpG%SymopSymb(SpG%Multip),SpG%Symop(SpG%Multip))
       do i=1,SpG%Multip
         j=index(group%Symb_Op(i),",",back=.true.)
         SpG%SymopSymb(i)  = group%Symb_Op(i)(1:j-1)
         SpG%Symop(i)%Rot  = group%Op(i)%Mat(1:3,1:3)
         SpG%Symop(i)%tr   = group%Op(i)%Mat(1:3,4)
       end do

    End Subroutine Get_Average_SPG


    !!----
    !!---- Subroutine  Gen_SReflections(Cell,sintlmax,Num_Ref,Reflex,mag,kinfo,order,SSG,powder,mag_only)
    !!----   type (Crystal_Cell_Type),                        intent(in)     :: Cell
    !!----   real(kind=cp),                                   intent(in)     :: sintlmax
    !!----   integer,                                         intent(out)    :: num_ref
    !!----   class (sReflect_Type), dimension(:), allocatable,intent(out)    :: reflex
    !!----   logical,                                         intent(in)     :: mag
    !!----   type(kvect_info_type),         optional,         intent(in)     :: kinfo
    !!----   character(len=*),              optional,         intent(in)     :: order
    !!----   class(SuperSpaceGroup_Type) ,  optional,         intent(in)     :: SSG
    !!----   logical,                       optional,         intent(in)     :: powder,mag_only
    !!----
    !!----    Calculate unique reflections between two values of
    !!----    sin_theta/lambda.  The output is not ordered.
    !!----
    !!---- Created: June 2017
    !!

    Subroutine Gen_SReflections(Cell,sintlmax,Num_Ref,Reflex,mag,kinfo,order,SSG,powder,mag_only)
       !---- Arguments ----!
       type (Crystal_Cell_Type),                        intent(in)     :: Cell
       real(kind=cp),                                   intent(in)     :: sintlmax
       integer,                                         intent(out)    :: num_ref
       class(sReflect_Type), dimension(:), allocatable, intent(out)    :: reflex
       logical,                                         intent(in)     :: mag
       type(kvect_info_type),         optional,         intent(in)     :: kinfo
       character(len=*),              optional,         intent(in)     :: order
       class(SuperSpaceGroup_Type) ,  optional,         intent(in)     :: SSG
       logical,                       optional,         intent(in)     :: powder,mag_only

       !---- Local variables ----!
       real(kind=cp)         :: sval,max_s !,vmin,vmax
       real(kind=cp)         :: epsr=0.00001, delt=0.0001
       integer               :: h,k,l,hmin,kmin,lmin,hmax,kmax,lmax, maxref,i,j,indp,indj, &
                                maxpos, mp, iprev,Dd, nf, ia, i0, nk, nharm,n
       integer,      dimension(4)                :: info
       integer,      dimension(:),   allocatable :: hh,kk,nulo
       integer,      dimension(:,:), allocatable :: hkl,hklm
       integer,      dimension(:),   allocatable :: indx,indtyp,ind,ini,fin,itreat
       real(kind=cp),dimension(:),   allocatable :: sv,sm
       logical :: kvect,ordering,magg

       Dd=3
       ordering=.false.
       kvect=.false.
       magg=.false.
       if(present(mag_only)) magg=mag_only
       if(present(order) .or. present(powder)) ordering=.true.
       if(present(kinfo)) then
         nk=kinfo%nk
         nharm=kinfo%nq
         kvect=.true.
       end if
       if(kvect) Dd=3+nk             !total dimension of the reciprocal space

       hmax=nint(Cell%cell(1)*2.0*sintlmax+1.0)
       kmax=nint(Cell%cell(2)*2.0*sintlmax+1.0)
       lmax=nint(Cell%cell(3)*2.0*sintlmax+1.0)
       hmin=-hmax; kmin=-kmax; lmin= -lmax
       maxref= (2*hmax+1)*(2*kmax+1)*(2*lmax+1)
       if(kvect) then
          do k=1,nk
                 maxref=maxref*2*nharm
          end do
          !allocate(max_s(nk))
          if(present(kinfo)) then
            max_s=maxval(kinfo%sintlim)
          else
            max_s=sintlmax
          end if
       end if
       allocate(hkl(Dd,maxref),indx(maxref),indtyp(maxref),ind(maxref),sv(maxref),hh(Dd),kk(Dd),nulo(Dd))
       nulo=0
       indtyp=0
       num_ref=0
       !Generation of fundamental reflections
       i0=0
       ext_do: do h=hmin,hmax
          do k=kmin,kmax
             do l=lmin,lmax
                hh=0
                hh(1:3)=[h,k,l]
                sval=H_s(hh,Cell)
                if (sval > sintlmax) cycle
                num_ref=num_ref+1
                if(num_ref > maxref) then
                   num_ref=maxref
                   exit ext_do
                end if
                if(sval < epsr) i0=num_ref !localization of 0 0 0  reflection
                sv(num_ref)=sval
                hkl(:,num_ref)=hh
             end do
          end do
       end do ext_do

       !Generation of satellites
       !The generated satellites corresponds to those obtained from the list
       ! of +/-kinfo%q_qcoeff
       nf=num_ref
       if(kvect) then
         do_ex: do n=1,kinfo%nq
              do i=1,nf
                 hh=hkl(:,i)
                 do ia=-1,1,2
                   hh(4:3+nk)=ia*kinfo%q_coeff(1:nk,n)
                   sval=H_s(hh,Cell,nk,kinfo%kv)
                   !write(*,*) hh(1:3+nk),sval,max_s
                   if (sval > max_s) cycle
                   num_ref=num_ref+1
                   if(num_ref > maxref) then
                      num_ref=maxref
                      exit do_ex
                   end if
                   sv(num_ref)=sval
                   hkl(:,num_ref)=hh
                   end do !ia
              end do  !i
         end do do_ex
       end if
       do i=i0+1,num_ref  !elimination of the reflection (0000..)
         sv(i-1)=sv(i)
         hkl(:,i-1)=hkl(:,i)
       end do
       num_ref=num_ref-1
       !Determination of reflection character and extinctions (Lattice + others)
       n=0
       do i=1,num_ref
          hh=hkl(:,i)
          mp=0
          if(present(SSG)) then
             call Get_h_info(hh,SSG,mag,info)
             if(info(1) == 1) cycle
             if(info(2) == 1 .and. info(3) == 1) Cycle
             if(magg .and. info(4) == 0) cycle
             mp=info(4) !Reflection character (0:nuclear,1:magnetic,2:nuclear+magnetic)
          end if
          n=n+1
          hkl(:,n)=hkl(:,i)
          sv(n)=sv(i)
          indtyp(n)=mp
       end do
       num_ref=n

       if(ordering) then
          call sort(sv,num_ref,indx)
          allocate(hklm(Dd,num_ref),sm(num_ref))
          do i=1,num_ref
            j=indx(i)
            hklm(:,i)=hkl(:,j)
            sm(i)=sv(j)
            ind(i)=indtyp(j)
          end do
          indtyp(1:num_ref)=ind(1:num_ref) !contains now the type of reflection in the proper order
          hkl(:,1:num_ref)=hklm(:,1:num_ref)
          sv(1:num_ref)=sm(1:num_ref)
          if(present(SSG) .and. present(powder)) then
            deallocate(hkl,sv,indx,ind)
            allocate(ini(num_ref),fin(num_ref),itreat(num_ref))
            itreat=0; ini=0; fin=0
            indp=0
            do i=1,num_ref       !Loop over all reflections
              !write(*,"(i6,3i5,i8)") i, hklm(:,i),itreat(i)
              if(itreat(i) == 0) then   !If not yet treated do the following
                hh(:)=hklm(:,i)
                indp=indp+1  !update the number of independent reflections
                itreat(i)=i  !Make this reflection treated
                ini(indp)=i  !put pointers for initial and final equivalent reflections
                fin(indp)=i
                do j=i+1,num_ref  !look for equivalent reflections to the current (i) in the list
                    if(abs(sm(i)-sm(j)) > delt) exit
                    kk=hklm(:,j)
                    if(h_equiv(hh,kk,SSG,.true.)) then ! if  hh eqv kk Friedel law assumed
                      itreat(j) = i                    ! add kk to the list equivalent to i
                      fin(indp) = j
                    end if
                end do
              end if !itreat
            end do

            !Selection of the most convenient independent reflections
            allocate(hkl(Dd,indp),sv(indp),ind(indp))
            do i=1,indp
              maxpos=0
              indj=ini(i)
              iprev=itreat(indj)
              do j=ini(i),fin(i)
                if(iprev /= itreat(j)) cycle
                hh=hklm(:,j)
                mp=count(hh > 0)
                if(mp > maxpos) then
                  indj=j
                  maxpos=mp
                end if
              end do !j
              hkl(:,i)=hklm(:,indj)
              if(hkl(1,i) < 0) hkl(:,i)=-hkl(:,i)
              sv(i)=sm(indj)
              ind(i)=indtyp(indj)
            end do
            indtyp(1:indp)=ind(1:indp)
            num_ref=indp
          end if  !SSG and Powder
       end if !present "order"

       !Final assignments
       if(allocated(reflex)) deallocate(reflex)
       allocate(reflex(num_ref))
       do i=1,num_ref
         allocate(reflex(i)%h(Dd)) !needed in f95
         reflex(i)%h      = hkl(:,i)
         kk               = abs(hkl(4:3+nk,i))
         reflex(i)%p_coeff= 0 !Fundamental reflections point to the Fourier coefficient [00...]
         do n=1,kinfo%nq
             if(equal_vector(kk(1:nk),abs(kinfo%q_coeff(1:nk,n))))  then
               reflex(i)%p_coeff=n
               exit
             end if
         end do
         reflex(i)%s      = sv(i)
         if(present(SSG)) then
           reflex(i)%mult = h_mult(reflex(i)%h,SSG,.true.)
         else
           reflex(i)%mult = 1
         end if
         reflex(i)%imag = indtyp(i)
       end do
       return
    End Subroutine Gen_SReflections

    Subroutine Gen_SXtal_SReflections(Cell,sintlmax,Reflex,mag,kinfo,order,SSG)
       !---- Arguments ----!
       type (Crystal_Cell_Type),                        intent(in)     :: Cell
       real(kind=cp),                                   intent(in)     :: sintlmax
       class (sReflection_List_Type),                   intent(out)    :: reflex
       logical,                                         intent(in)     :: mag
       type(kvect_info_type),         optional,         intent(in)     :: kinfo
       character(len=*),              optional,         intent(in)     :: order
       class(SuperSpaceGroup_Type) ,  optional,         intent(in)     :: SSG

       !---- Local variables ----!
       real(kind=cp)         :: sval,max_s !,vmin,vmax
       real(kind=cp)         :: epsr=0.00000001 !, delt=0.000001
       integer               :: h,k,l,hmin,kmin,lmin,hmax,kmax,lmax, maxref,i,j, & !,maxpos,iprev,indp,indj
                                 mp, Dd, nf, ia, i0, nk, num_ref, n, nharm
       integer,       dimension(4)                :: info
       integer,       dimension(:),   allocatable :: hh,kk,nulo
       integer,       dimension(:,:), allocatable :: hkl
       integer,       dimension(:),   allocatable :: indx,indtyp
       real(kind=cp), dimension(:),   allocatable :: sv
       logical :: kvect,ordering

       Dd=3
       ordering=.false.
       kvect=.false.
       if(present(order)) ordering=.true.
       if(present(kinfo)) then
         nk=kinfo%nk
         nharm=kinfo%nq
         if(nk > 0) kvect=.true.
       end if
       if(kvect) Dd=3+nk             !total dimension of the reciprocal space

       hmax=nint(Cell%cell(1)*2.0*sintlmax+1.0)
       kmax=nint(Cell%cell(2)*2.0*sintlmax+1.0)
       lmax=nint(Cell%cell(3)*2.0*sintlmax+1.0)
       hmin=-hmax; kmin=-kmax; lmin= -lmax
       maxref= (2*hmax+1)*(2*kmax+1)*(2*lmax+1)
       if(kvect) then
          do k=1,nk
                 maxref=maxref*2*nharm
          end do
          if(present(kinfo)) then
            max_s=maxval(kinfo%sintlim)
          else
            max_s=sintlmax
          end if
       end if
       allocate(hkl(Dd,maxref),indtyp(maxref),sv(maxref),hh(Dd),kk(Dd),nulo(Dd))
       nulo=0
       indtyp=0
       num_ref=0
       !Generation of fundamental reflections
       i0=0
       ext_do: do h=hmin,hmax
          do k=kmin,kmax
             do l=lmin,lmax
                hh=0
                hh(1:3)=[h,k,l]
                sval=H_s(hh,Cell)
                if (sval > sintlmax) cycle
                num_ref=num_ref+1
                if(num_ref > maxref) then
                   num_ref=maxref
                   exit ext_do
                end if
                if(sval < epsr) i0=num_ref !localization of 0 0 0  reflection
                sv(num_ref)=sval
                hkl(:,num_ref)=hh
             end do
          end do
       end do ext_do

       !Generation of satellites
       !The generated satellites corresponds to those obtained from the list
       ! of +/-kinfo%q_qcoeff
       nf=num_ref
       if(kvect) then
         do_ex: do n=1,kinfo%nq
              do i=1,nf
                 hh=hkl(:,i)
                 do ia=-1,1,2
                   hh(4:3+nk)=ia*kinfo%q_coeff(1:nk,n)
                   sval=H_s(hh,Cell,nk,kinfo%kv)
                   !write(*,*) hh(1:3+nk),sval,max_s
                   if (sval > max_s) cycle
                   num_ref=num_ref+1
                   if(num_ref > maxref) then
                      num_ref=maxref
                      exit do_ex
                   end if
                   sv(num_ref)=sval
                   hkl(:,num_ref)=hh
                   end do !ia
              end do  !i
         end do do_ex
       end if
       do i=i0+1,num_ref  !elimination of the reflection (0000..)
         sv(i-1)=sv(i)
         hkl(:,i-1)=hkl(:,i)
       end do
       num_ref=num_ref-1
       !Determination of reflection character and extinctions (Lattice + others)
       n=0
       do i=1,num_ref
          hh=hkl(:,i)
          mp=0
          if(present(SSG)) then
             call Get_h_info(hh,SSG,mag,info)
             if(info(1) == 1) cycle
             if(info(2) == 1 .and. info(3) == 1) Cycle
             mp=info(4)
          end if
          n=n+1
          hkl(:,n)=hkl(:,i)
          sv(n)=sv(i)
          indtyp(n)=mp
       end do
       num_ref=n

       allocate(indx(num_ref))
       indx=[(i,i=1,num_ref)]
       if(ordering) call sort(sv,num_ref,indx)

       !Final assignments
       if(allocated(Reflex%Ref)) deallocate(Reflex%Ref)
       allocate(Reflex%Ref(num_ref))
       Reflex%Nref=num_ref
       do i=1,num_ref
         j=indx(i)
         allocate(Reflex%Ref(i)%h(Dd)) !needed in f95
         Reflex%Ref(i)%h      = hkl(:,j)
         Reflex%Ref(i)%s      = sv(j)
         Reflex%Ref(i)%p_coeff= 0 !Fundamental reflections point to the Fourier coefficient [00...]
         kk                   = abs(hkl(4:3+nk,j))
         do n=1,kinfo%nq
           if(equal_vector(kk(1:nk),abs(kinfo%q_coeff(1:nk,n))))  then
             Reflex%Ref(i)%p_coeff=n
             exit
           end if
         end do
         if(present(SSG)) then
           Reflex%Ref(i)%mult = h_mult(Reflex%Ref(i)%h,SSG,.true.)
         else
           Reflex%Ref(i)%mult = 1
         end if
         Reflex%Ref(i)%imag = indtyp(j)
         Select Type(myRef => reflex%Ref)
           type is(sReflect_Type)

           type is(sReflection_Type)
             myRef(i)%Fo=0.0
             myRef(i)%Fc=0.0
             myRef(i)%SFo=0.0
             myRef(i)%Phase=0.0
             myRef(i)%A=0.0
             myRef(i)%B=0.0

           class is(gReflection_Type)
             myRef(i)%Fo=0.0
             myRef(i)%Fc=0.0
             myRef(i)%SFo=0.0
             myRef(i)%Phase=0.0
             myRef(i)%A=0.0
             myRef(i)%B=0.0

             myRef(i)%mIvo=0.0         ! Observed modulus of the Magnetic Interaction vector
             myRef(i)%sigma_mIvo=0.0   ! Sigma of observed modulus of the Magnetic Interaction vector
             myRef(i)%msF=0.0          ! Magnetic Structure Factor
             myRef(i)%mIv=0.0          ! Magnetic Interaction vector
         End Select
       end do
       return
    End Subroutine Gen_SXtal_SReflections

    Subroutine Readn_Set_SuperSpace_Group(database_path,file_line,SSG,cell,kinfo,x1x2x3_type)
       character(len=*), intent(in)                 :: database_path
       character(len=*),dimension(:),   intent(in)  :: file_line
       class(SuperSpaceGroup_Type),     intent(out) :: SSG
       type(Crystal_Cell_Type),optional,intent(out) :: cell
       type(kvect_info_type),  optional,intent(out) :: kinfo
       character(len=*),       optional,intent(in)  :: x1x2x3_type
       !
       ! --- Local variables ---!
       integer                             :: i,j,k,ind, num_gen,n,ier,n_end, num_group, nq
       character(len=132)                  :: line,generators_string
       character(len=20)                   :: spg_symb,shub_symb
       integer, parameter                  :: max_gen=10
       character(len=40),dimension(max_gen):: gen
       character(len=80),dimension(4)      :: filelines
       type(Space_Group_Type)              :: SpG
       type(Magnetic_Space_Group_Type)     :: mSpG
       real(kind=cp), dimension(3)         :: cell_par,cell_ang
       logical                             :: cell_given=.false.

       num_gen=0
       num_group=0
       SSG%nk=0
       nq=0
       generators_string=" "
       gen=" "
       spg_symb=" "
       shub_symb=" "
       n_end=size(file_line)
       filelines=" "

       do i=1,n_end
         line=adjustl(file_line(i))
         if(line(1:1) =="!" .or. line(1:1) =="#" .or. len_trim(line) == 0) cycle
         ind=index(line," ")-1
         line(1:ind)=u_case(line(1:ind))
         Select Case(line(1:ind))

           Case("SSG_NUM") !Generate the group from the database
             read(unit=line(ind+1:),fmt=*,iostat=ier) num_group
              if(ier /= 0) then
                Err_ssg=.true.
                Err_ssg_Mess=" Error reading the number of the group SSG"
                return
              end if

           Case("SPGR") !Conventional space group
              spg_symb=adjustl(line(ind+1:))

           Case("SHUBGR") !Conventional Shubnikov space group
              shub_symb=adjustl(line(ind+1:))

           Case("DIMD","N_KV")
              read(unit=line(ind+1:),fmt=*,iostat=ier) SSG%nk
              if(ier /= 0) then
                Err_ssg=.true.
                Err_ssg_Mess=" The d-value (3+d) was not properly read in the instruction 'DIM  d' !"
                return
              else
                if(allocated(SSG%kv)) deallocate(SSG%kv)
                allocate(SSG%kv(3,SSG%nk))
                SSG%kv=0.0
                n=0
                if(present(kinfo) .and. nq /= 0) then
                   call Allocate_kvect_info(SSG%nk,nq,kinfo)
                end if
              end if

           Case("N_QC")
              read(unit=line(ind+1:),fmt=*,iostat=ier) nq
              !write(*,*) " N_QC =",nq
              if(ier /= 0) then
                Err_ssg=.true.
                Err_ssg_Mess=" The number of Q_coeff was not properly read in the instruction 'DIM  d' !"
                return
              else
                if(present(kinfo)) then
                   if (SSG%nk /= 0) then
                     call Allocate_kvect_info(SSG%nk,nq,kinfo)
                   end if
                end if
              end if

           Case("CELL")
              if(.not. present(cell)) cycle
              read(unit=line(ind+1:),fmt=*,iostat=ier) cell_par,cell_ang
              call Set_Crystal_Cell(cell_par,cell_ang,Cell)
              if(ERR_Crys) then
                Err_ssg=.true.
                Err_ssg_Mess=ERR_Crys_mess
                return
              else
                cell_given=.true.
              end if

           Case("KVEC")
              n=n+1
              if(n > SSG%nk) then
                Err_ssg=.true.
                Err_ssg_Mess=" The number of k-vector exceed the d-value provided in DIM instruction"
                return
              end if
              if(present(kinfo)) then
                 read(unit=line(ind+1:),fmt=*,iostat=ier) kinfo%kv(:,n),kinfo%nharm(n),kinfo%sintlim(n)
                 if( ier /= 0) then
                   Err_ssg=.true.
                   write(unit=Err_ssg_Mess,fmt="(a,i2,a)") " The k-vector #",n,"  was not properly read in the instruction 'KVEC  kx ky kz   nharm  sintl-max' !"
                   return
                 end if
                 SSG%kv(:,n)=kinfo%kv(:,n)
              else
                 read(unit=line(ind+1:),fmt=*,iostat=ier) SSG%kv(:,n)
                 if( ier /= 0) then
                   Err_ssg=.true.
                   write(unit=Err_ssg_Mess,fmt="(a,i2,a)") " The k-vector #",n,"  was not properly read in the instruction 'KVEC  kx ky kz' !"
                   return
                 end if
              end if

           Case("Q_COEFF") !Must be provided once all propagation vectors are read
              if(present(kinfo)) then
                k=0
                do j=i+1,i+nq
                  k=k+1
                  read(unit=file_line(j),fmt=*,iostat=ier) kinfo%q_coeff(1:SSG%nk,k)
                  if(ier /= 0) then
                    Err_ssg=.true.
                    write(unit=Err_ssg_Mess,fmt="(a,i2,a)") " The q_coeff #",k,"  was not properly read after the instruction 'Q_COEFF' !"
                    return
                  Else
                    !write(*,*) kinfo%q_coeff(1:SSG%nk,k)
                  end if
                end do
              end if

           Case("GENR")
              num_gen=num_gen+1
              if(num_gen > max_gen) num_gen = max_gen
              gen(num_gen)=adjustl(line(ind+1:))

           Case("GENERATORS")
              generators_string=adjustl(line(ind+1:))

         End Select

       end do

       if(len_trim(generators_string) /= 0) then
          call Group_Constructor(generators_string,SSG)
          if(Err_group .or. Err_ssg) then
            Err_ssg=.true.
            Err_ssg_Mess= " Error in generating SSG: "//trim(Err_group_mess)//" from the generators: "//trim(generators_string)
            return
          end if
          if(SSG%centred /= 1) SSG%Centre="Centrosymmetric"
          SSG%nk=SSG%d-4
          if(SSG%Num_Lat > 0) then
             SSG%SPG_Lat="Z"
          end if
       else if(num_gen > 0) then
          call Group_Constructor(gen(1:num_gen),SSG)
          if(Err_group .or. Err_ssg) then
            Err_ssg=.true.
            write(unit=Err_ssg_Mess,fmt="(a,30a)") " Error in generating SSG: "//trim(Err_group_mess)//" from the generators: ", &
                                               (trim(gen(i))//"; ",i=1,num_gen)
            return
          end if
          if(SSG%centred /= 1) SSG%Centre="Centrosymmetric"
          SSG%nk=SSG%d-4
          if(SSG%Num_Lat > 0) then
             SSG%SPG_Lat="Z"
          end if
       else if(num_group /= 0) then
          if(present(x1x2x3_type)) then
            call Set_SSG_Reading_Database(database_path,num_group,ssg,Err_ssg,Err_ssg_Mess,x1x2x3_type)
          else
            call Set_SSG_Reading_Database(database_path,num_group,ssg,Err_ssg,Err_ssg_Mess)
          end if
          if(Err_ssg) then
            Err_ssg_Mess= " Error in generating SSG: "//trim(Err_ssg_Mess)//" from the database"
            return
          end if
       else if(len_trim(spg_symb) /= 0) then
         call Set_SpaceGroup(spg_symb,SpG)
         call copy_SpG_to_SSG(SpG,SSG)
       else if(len_trim(shub_symb) /= 0) then
         filelines(1) = trim(shub_symb)//"   number:   <--Magnetic Space Group"
         filelines(2) = "Transform to standard:  a,b,c;0,0,0    <--"
         filelines(3) = "Parent Space Group:       IT_number:   <--"
         filelines(4) = "Transform from Parent:  a,b,c;0,0,0    <--"
         call Readn_Set_Magnetic_Space_Group(filelines,1,4,mSpG,"database")
         call copy_mSpG_to_SSG(mSpG,SSG)
       else
         Err_ssg=.true.
         Err_ssg_Mess= " Error in some of the keywords for generating the group "
         return
       end if

       !Complete the type with the point group,Laue class and Lattice type
       call Identify_Crystallographic_Point_Group(ssg)
       call Identify_Laue_Class(ssg)
       ssg%SPG_Lat="P"
       if(ssg%Num_Lat > 1) then
         call Get_Lattice_Type(ssg%Num_Lat, ssg%Lat_tr(1:3,:),ssg%SPG_Lat)
       end if
       do i=1,n_end
        line=adjustl(file_line(i))
        if(line(1:1) =="!" .or. line(1:1) =="#" .or. len_trim(line) == 0) cycle
        k=index(line,"<--")
        if(k /= 0) then
          j=index(line," ")
          ssg%SSG_symbol=line(1:j)
          ssg%SSG_nlabel=adjustl(line(j:k-1))
          exit
        end if
       end do

       Select Type(myssg => SSG)
         Type is (eSSGroup_Type)
           n=myssg%d
           allocate(myssg%Om(n,n,myssg%Multip))
           do i=1,myssg%Multip
            myssg%Om(:,:,i)=myssg%Op(i)%Mat
           end do
         Type is (SuperSpaceGroup_Type)
           return
         Class default
           Err_ssg=.true.
           Err_ssg_Mess= " Error in Readn_set_SuperSpace_Group: Unknown type of group "
           return
       End Select

    End Subroutine Readn_Set_SuperSpace_Group

    Subroutine copy_SpG_to_SSG(SpG,SSG)
      type(Space_Group_Type),      intent(in)  :: SpG
      class(SuperSpaceGroup_Type), intent(out) :: SSG
      integer :: i

      SSG%NumSpg     = SpG%NumSpg
      SSG%PG         = SpG%PG
      SSG%Laue       = SpG%Laue
      SSG%SSG_symbol = SpG%SpG_symb
      SSG%SSG_Bravais= SpG%Bravais
      SSG%Centre     = SpG%Centre
      SSG%SPG_Lat    = SpG%SPG_Lat
      SSG%SSG_nlabel=" "
      SSG%Parent_spg=" "
      SSG%trn_from_parent=" "
      SSG%trn_to_standard=" "
      SSG%nk=0
      SSG%Parent_num=0
      SSG%Bravais_num=0
      SSG%standard_setting=.false.
      SSG%d=4  !Dimension of operator matrices (for 2D, d=3, for 3D, d=4, etc.)
      SSG%Multip=SpG%Multip
      SSG%Numops=SpG%Numops
      SSG%centred=SpG%centred
      SSG%mag_type=2
      SSG%num_lat=SpG%NumLat-1
      SSG%num_alat=0
      allocate(SSG%centre_coord(3))
      SSG%centre_coord=SpG%centre_coord
      if(SSG%num_lat > 0) then
        allocate(SSG%Lat_tr(3,SSG%num_lat))
        SSG%Lat_tr(:,1:SSG%num_lat)=SpG%Latt_trans(:,2:SpG%NumLat)
      end if
      call Allocate_Operators(SSG%d,SSG%multip,SSG%Op)
      allocate(SSG%Symb_Op(SSG%multip))
      do i=1,SSG%multip
        SSG%Symb_Op(i)=SpG%SymopSymb(i)
        SSG%Op(i)=Operator_from_Symbol(SSG%Symb_Op(i))
      end do

    End Subroutine copy_SpG_to_SSG

    Subroutine copy_mSpG_to_SSG(mSpG,SSG)
      type(Magnetic_Space_Group_Type),intent(in)  :: mSpG
      class(SuperSpaceGroup_Type),    intent(out) :: SSG
      integer :: i

      SSG%NumSpg     = mSpG%Sh_number
      SSG%PG         = mSpG%PG_symbol
      SSG%Laue       = " "
      SSG%SSG_symbol = mSpG%BNS_symbol
      SSG%SSG_Bravais= mSpG%SPG_latsy
      SSG%Centre     = mSpG%Centre
      SSG%SPG_Lat    = mSpG%SPG_lat
      SSG%SSG_nlabel=" "
      SSG%Parent_spg=" "
      SSG%trn_from_parent=" "
      SSG%trn_to_standard=" "
      SSG%nk=0
      SSG%Parent_num=0
      SSG%Bravais_num=0
      SSG%standard_setting=.false.
      SSG%d=4  !Dimension of operator matrices (for 2D, d=3, for 3D, d=4, etc.)
      SSG%Multip=mSpG%Multip
      SSG%Numops=mSpG%Numops
      SSG%centred=mSpG%centred
      SSG%mag_type=2
      SSG%num_lat=mSpG%Num_Lat-1
      SSG%num_alat=mSpG%Num_aLat
      allocate(SSG%centre_coord(3))
      SSG%centre_coord=mSpG%centre_coord  !Transform to rational
      if(SSG%num_lat > 0) then
        allocate(SSG%Lat_tr(3,SSG%num_lat))
        SSG%Lat_tr(:,1:SSG%num_lat)=mSpG%Latt_trans(:,2:mSpG%Num_Lat)  !Transform to rational
      end if
      if(SSG%num_alat > 0) then
        allocate(SSG%aLat_tr(3,SSG%num_alat))
        SSG%aLat_tr(:,1:SSG%num_alat)=mSpG%aLatt_trans(:,2:mSpG%Num_aLat)
      end if
      call Allocate_Operators(SSG%d,SSG%multip,SSG%Op)
      allocate(SSG%Symb_Op(SSG%multip))
      do i=1,SSG%multip
        if(mSpG%MSymOp(i)%phas > 0.0) then
          SSG%Symb_Op(i)=trim(mSpG%SymopSymb(i))//",1"
        else
          SSG%Symb_Op(i)=trim(mSpG%SymopSymb(i))//",-1"
        end if
        SSG%Op(i)=Operator_from_Symbol(SSG%Symb_Op(i))
      end do
    End Subroutine copy_mSpG_to_SSG

  End Module CFML_SuperSpaceGroups
