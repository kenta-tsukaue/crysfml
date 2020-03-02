  Module DataRed_Mod
    Use CFML_GlobalDeps
    Use CFML_gSpaceGroups
    Use CFML_IOForm, only : Read_CFL_SpG,Read_CFL_Cell,Read_kinfo
    Use CFML_Metrics
    Use CFML_Strings, only: File_Type, Reading_File,u_case
    Use CFML_Reflections
    Use CFML_Propagation_Vectors
    Use Twin_Mod
    Implicit None

    Private
    Public :: Read_DataRed_File, Header_Output, Write_Conditions

    Type, public :: Conditions_Type
      logical :: Friedel      = .true.
      logical :: prop         = .false.
      logical :: filout_given = .false.
      logical :: filhkl_given = .false.
      logical :: cell_given   = .false.
      logical :: SpG_given    = .false.
      logical :: twinned      = .false.
      logical :: wave_given   = .false.
      logical :: powder       = .false.
      logical :: domain       = .false.
      logical :: transf_ind   = .false.
      logical :: hkl_real     = .false.
      logical :: eps_given    = .false.
      logical :: statistics   = .false.
      logical :: absent       = .false.
      logical :: lauetof      = .false.
      logical :: scale_given  = .false.
      character(len=:), allocatable :: title,forma
      character(len=:), allocatable :: filhkl
      character(len=:), allocatable :: fileout
      integer                       :: hkl_type
      real(kind=cp), dimension(3,3) :: transhkl
      real(kind=cp), dimension(3)   :: cel,ang
      real(kind=cp)                 :: epsg, wavel
      real(kind=cp)                 :: warning=0.25  ! 25% error for warning equivalent reflections
      real(kind=cp)                 :: scal_fact=1.0
    End Type Conditions_Type

    !Type(Group_k_Type)          :: Gk


    contains

    Subroutine Read_DataRed_File(cfl,cond,kinfo,twins,SpG,Cell)
      type(File_Type),       intent(in)  :: cfl
      type(Conditions_Type), intent(out) :: cond
      type(kvect_info_Type), intent(out) :: kinfo
      type(Twin_Type),       intent(out) :: twins
      class(SPG_Type),       intent(out) :: SpG
      class(Cell_G_Type),    intent(out) :: Cell
      !--- Local variables ---!
      integer :: i,j,k,ier
      character(len=:), allocatable :: keyw
      character(len=:), allocatable :: line

      ! First read crystallographic information from the input Data

      call Read_CFL_Cell(Cfl,Cell)
      if(Err_CFML%Ierr /= 0) return
      cond%cell_given=.true.

      call Read_CFL_SpG(Cfl,SpG)
      if(Err_CFML%Ierr /= 0) return
      cond%spg_given=.true.

      call Read_kinfo(Cfl,kinfo)
      if(Err_CFML%Ierr /= 0) return
      if(kinfo%nk > 0) cond%prop=.true.

      do i=1,cfl%nlines
         line=adjustl(cfl%line(i)%str)
         if(len_trim(line) == 0) cycle
         if(line(1:1) == "!" .or. line(1:1) == "#") cycle
         j=index(line," ")
         if(j == 0) then
           keyw=u_case(trim(line))
         else
           keyw=u_case(trim(line(1:j-1)))
         end if

         Select Case(keyw)

            Case("TITLE")
              cond%title=adjustl(line(j:))

            Case("INPFIL")
              cond%filhkl=adjustl(line(j:))
              cond%filhkl_given=.true.

            Case("OUTFIL")
              cond%fileout=adjustl(line(j:))
              cond%filout_given=.true.

            Case("TRANS")
              cond%transf_ind=.true.
              read(unit=line(j:),fmt=*)  ((cond%transhkl(k,j),j=1,3),k=1,3)

            Case("SCALE")
              read(unit=line(j:),fmt=*,iostat=ier)  cond%scal_fact
              if(ier /= 0) cond%scal_fact=1.0_cp
              cond%scale_given=.true.

            Case("STATISTICS")
              cond%statistics=.true.

            Case("EPSIL")
               read(unit=line(j:),fmt=*)  cond%epsg
               cond%eps_given=.true.

            Case("NFRDL")
               cond%Friedel=.false.

            Case("WAVE")
               read(unit=line(j:),fmt=*)  cond%wavel
               cond%wave_given=.true.

            Case("HKL_T")
               read(unit=line(j:),fmt=*)  cond%hkl_type

            Case("WARN")
               read(unit=line(j:),fmt=*)  cond%warning

            Case("POWDER")
               cond%powder=.true.

            Case("TWIN")
              call read_twinlaw(cfl,Twins)
              cond%twinned=.true.
              if(Twins%iubm) lambda=cond%wavel

            Case("DOMAIN")
              cond%domain=.true.

         End Select

      end do

    End Subroutine Read_DataRed_File

    Subroutine Header_Output(lun)
       integer,optional, intent(in) :: lun
       integer :: iou
       iou=6
       if(present(lun)) iou=lun
       write(unit=iou,fmt="(/,a)") "       ==============================="
       write(unit=iou,fmt="(a)")   "       DATA REDUCTION PROGRAM: DataRed"
       write(unit=iou,fmt="(a)")   "       ==============================="
       write(unit=iou,fmt="(a,/)") "          JRC-ILL version:30-2-2020"
    End Subroutine Header_Output

    Subroutine Write_Conditions(cfl,cond,Cell,SpG,kinfo,tw,forma,lun,Gk)
      Type(File_Type),                           intent(in)     :: cfl
      Type(Conditions_Type),                     intent(in out) :: cond
      Type(Cell_G_Type),                         intent(in)     :: Cell
      class(SpG_Type),                           intent(in)     :: SpG
      Type(kvect_info_Type),                     intent(in out) :: kinfo
      Type(Twin_Type),                           intent(in out) :: Tw
      character(len=*),                          intent(in)     :: forma
      integer, optional,                         intent(in)     :: lun
      Type(Group_k_Type),dimension(:), optional, intent(in)     :: Gk
      integer :: i,iou
      character(len=10)  :: fm = "(a,  i3,a)"

      iou=6
      if(present(lun)) iou=lun
       write(unit=iou,fmt="(a,a)")   " Input        Control  file: ", trim(cfl%fname)
       write(unit=iou,fmt="(a,a)")   " Input    Reflections  file: ", trim(cond%filhkl)
       write(unit=iou,fmt="(a,a)")   " Averaged Reflections  file: ", trim(cond%fileout)//".int"
       write(unit=iou,fmt="(a,a//)") " Rejected Reflections  file: ", trim(cond%fileout)//".rej"
       write(unit=iou,fmt="(a,a)")   " General       Output  file: ", trim(cond%fileout)//".out"

       Select Case(cond%hkl_type)
         Case(0)       !Shelx-like input file (3i4,2f8.2)
            write(unit=iou,fmt="(a/)") " Format of the reflections file =>  ShelX-like format h k l intens sigma (3i4,2f8.2)"
         case(1)
            write(unit=iou,fmt="(a/)") " Format of the reflections file =>  FREE format:  h k l intens sigma "
         case(2)
            write(unit=iou,fmt="(a)")  " Data from COLL5 (two lines per reflection) *.fsq           "
            write(unit=iou,fmt="(a)")  " Format of the reflections file =>  (i6,3f7.3,2f10.2,3f8.2) "
            write(unit=iou,fmt="(a/)") " For reading the items: Numor, h k l Int Sigma gamma nu phi"
         case(3)
            write(unit=iou,fmt="(a)")  " Data in FullProf *.int format           "
            write(unit=iou,fmt="(a)")  " Format of the reflections read in the file "
            write(unit=iou,fmt="(a/)") " For reading the items:  h k l Int Sigma angles(1:4)"
         case(4)
            write(unit=iou,fmt="(a)")  " Data from COLL5 (1 line per reflection) *.col (hkl-integer)      "
            write(unit=iou,fmt="(a)")  " Format of the reflections file =>  (i6,3i4,2f10.2,4f8.2) "
            write(unit=iou,fmt="(a/)") " For reading the items: Numor, h k l Int Sigma theta omega chi phi"
         case(5)
            write(unit=iou,fmt="(a)")  " Data from COLL5 (1 line per reflection) *.col (hkl-real)"
            write(unit=iou,fmt="(a)")  " Format of the reflections file =>  "//trim(forma)
            write(unit=iou,fmt="(a/)") " For reading the items: Numor, h k l Int Sigma theta omega chi phi"
         case(6)
            write(unit=iou,fmt="(a)")  " Data from COLL5 (1 line per reflection) *.col (hkl-real) 6T2-LLB"
            write(unit=iou,fmt="(a)")  " Format of the reflections file =>  (i4,3f6.2,2f10.2,4f8.2) "
            write(unit=iou,fmt="(a/)") " For reading the items: Numor, h k l Int Sigma theta omega chi phi"
         case(7)
            write(unit=iou,fmt="(a)")  " Data from SXD in format adequate for FullProf"
            write(unit=iou,fmt="(a,a)")" Format of the reflections file => " , trim(forma)
            if(cond%prop) then
                write(unit=iou,fmt="(a/)") " For reading:  h k l ivk Fsqr s(Fsqr) Cod  Lambda Twotheta Absorpt. Tbar "
            else
                write(unit=iou,fmt="(a/)") " For reading:  h k l Fsqr s(Fsqr) Cod  Lambda Twotheta Absorpt. Tbar "
            end if
         case(8)
            write(unit=iou,fmt="(a)")  " Data from D3 file (1 line per reflection) *.bpbres (hkl-real) D3-ILL"
            write(unit=iou,fmt="(a)")  " (Warning: if the orientation of the crytal is not in a  "
            write(unit=iou,fmt="(a)")  "  symmetry direction, use 'P 1' as space group)"
            write(unit=iou,fmt="(a)")  " Format of the Flipping Ratio reflections file =>  (i8,6f8.3,2f10.2) "
            write(unit=iou,fmt="(a/)") " For reading the items: Numor, h k l omega gamma nu R Sigma(R) "
         case(9)
            write(unit=iou,fmt="(a)")  " Data from Modified COLL5 (1 line per reflection) *.col (hkl-real)"
            write(unit=iou,fmt="(a)")  " Format of the reflections file =>  (i6,3f10.4,2f10.2,4f8.2) "
            write(unit=iou,fmt="(a/)") " For reading the items: Numor, h k l Int Sigma theta omega chi phi"
         case(10)
            write(unit=iou,fmt="(a)")  " Data from SHELX HKLF5-format (domains have been treated outside DataRed)"
            write(unit=iou,fmt="(a)")  " Format of the reflections file =>  (3i4,2f8.0,i4) "
            write(unit=iou,fmt="(a/)") " For reading the items: h k l Int Sigma domain_code"
       End Select


       !write(unit=iou,fmt="(a,i6)") " => Number of reflections read: ",nr

       if(cond%scale_given) then
         write(unit=iou,fmt="(a,f8.4,a)") " => A scale factor ",cond%scal_fact," has been applied to intensities and sigmas "
         !intens(1:nr)=intens(1:nr)*scal_fact
         !sigma(1:nr)= sigma(1:nr)*scal_fact
       end if

       if(cond%hkl_real) then
          write(unit=*,fmt="(a)")   " => hkl indices will be treated as real numbers "
          write(unit=iou,fmt="(a)") " => hkl indices will be treated as real numbers "
       end if

       if(cond%prop) then
         write(unit=iou,fmt="(/,a,i4)")                   "  Number of modulation vectors: ",kinfo%nk
         write(unit=iou,fmt="(a)")                        "  Q-vectors & harmonics & maximum SinTheta/Lambda: "
         do i=1,kinfo%nk
            write(unit=iou,fmt="(a,3f10.4,a,i3,f10.4)")   "       [",kinfo%kv(:,i)," ]:   ",kinfo%nharm(i), kinfo%sintlim(i)
         end do
         write(unit=fm(4:5),fmt="(i2)") kinfo%nk
         write(unit=iou,fmt="(a,i4)")                     "     Number of  Q-coefficients: ",kinfo%nq
         write(unit=iou,fmt="(a )")                       "                Q-coefficients: "
         do i=1,kinfo%nq  !Q_coeff(nk,nq)
            write(unit=iou,fmt=fm)                     "                               [ ",kinfo%q_coeff(:,i)," ]"
         end do
       end if

       if(cond%hkl_type /= 10) then
         if(cond%statistics) then
            write(unit=*,fmt="(a)")   &
            " => Statistical errors are considered for sigmas of average intensisites (propagation error formula)"
            write(unit=iou,fmt="(a)") &
            " => Statistical errors are considered for sigmas of average intensisites (propagation error formula)"
         else
            write(unit=*,fmt="(a)")   &
            " => Statistics is NOT considered for sigmas of average intensities: exp. variance weighted with 1/sigmas^2"
            write(unit=iou,fmt="(a)") &
            " => Statistics is NOT considered for sigmas of average intensities: exp. variance weighted with 1/sigmas^2"
         end if
       end if

       if(cond%transf_ind) then
          write(unit=iou,fmt="(a)") " => Input indices trasformed with matrix: "
          write(unit=iou,fmt="(a,3f7.2,a)") "         (Hnew)     (",cond%transhkl(1,:)," )   (Hold)"
          write(unit=iou,fmt="(a,3f7.2,a)") "         (Knew)  =  (",cond%transhkl(2,:)," )   (Kold)"
          write(unit=iou,fmt="(a,3f7.2,a)") "         (Lnew)     (",cond%transhkl(3,:)," )   (Lold)"

          if(cond%prop) then
            do i=1,kinfo%nk
              kinfo%kv(:,i)=matmul(cond%transhkl,kinfo%kv(:,i))
              write(unit=iou,fmt="(a,i3,a,3f8.4,a)") " => Transformed propagation vector # ", i,"  [",kinfo%kv(:,i),"]"
            end do
          end if
       end if

       if(cond%cell_given) then
         call Write_Crystal_Cell(Cell, iou)
       end if

       if(cond%spg_given) then
         write(unit=iou,fmt="(/,a)")  !Create two spaces
         call Write_SpaceGroup_Info(SpG,iou)
       end if

       if(cond%twinned) then
         call write_twinlaw(iou,tw,cell)
       end if

       if(present(Gk)) then
         do i=1,kinfo%nk
           call Write_Group_k(Gk(i),iou)
         end do
       end if

    End Subroutine Write_Conditions

  End Module DataRed_Mod
