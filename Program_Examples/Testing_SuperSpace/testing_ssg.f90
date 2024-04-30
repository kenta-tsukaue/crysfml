    Program read_ssg_datafile
      use CFML_GlobalDeps, only: newline
      use CFML_ssg_datafile
      use CFML_SuperSpaceGroups
      use CFML_Rational_Arithmetic
      use CFML_Crystallographic_Symmetry
      use CFML_Propagation_vectors

      implicit none

      integer :: iclass,nmod,i,j,k,n,m,multip,Dd, i1,i2,i3, ng,nk
      character(len=20)  :: forma
      character(len=130) :: message,symb, Env,data_base_path
      logical :: ok
      type(SuperSpaceGroup_Type) :: SSpaceGroup
      type(SuperSpaceGroup_Type),   dimension(200) :: spg
      !type(Space_Group_Type) :: SpG,SpGk
      type(Group_k_type)     :: Gk
      type(SSym_Oper_Type), dimension(:), allocatable  :: gen
      type(rational),   dimension(:,:),allocatable :: Mat
      integer,          dimension(:,:),allocatable :: table
      character(len=40),dimension(:,:),allocatable :: matrix
      character(len=60) :: Operator_Symbol
      real, dimension(3,8) :: kv
      real :: tini,tfin,tpar

      Env="FULLPROF"
      call GET_ENVIRONMENT_VARIABLE(trim(Env),data_base_path)
      n=len_trim(data_base_path)
      if (n == 0) then
         
      write(unit=*,fmt="(a)") " => The "//trim(Env)//" environment variable is not defined! "//newline// &
                              "    This is needed for localizing the data bases"//newline// &
                              "    that should be within the %"//trim(Env)//"% directory"
         
      else
        data_base_path=trim(data_base_path)//OPS_SEP//"Databases"
      end if
         
      if (data_base_path(n:n) /= OPS_SEP) data_base_path=trim(data_base_path)//OPS_SEP
    
      call Read_SSG(data_base_path,ok,message)
      if(.not. ok) then
        write(*,"(a)") "   !!! "//message//" !!!"
        stop
      end if
      !
      open(unit=1,file=trim(data_base_path)//"class+group_pos.txt",status="replace",action="write")
      write(1,"(a,i6)") "Bravais Classes positions in database, Number of classes ",m_ncl
      write(1,"(10i7)") pos_class
      write(1,"(a,i6)") "Space Group positions in database, Number of groups ",m_ngs
      write(1,"(10i7)") pos_group
      !close(unit=1)
      !stop
      do

        !Testing the generation of a superspace group from a space group and propagation vectors
        !write(*,"(a)",advance="no")  " => Enter the space group (number or Hermann-Mauguin symbol): "
        !read(*,"(a)") symb
        !if(len_trim(symb) == 0) exit
        !write(*,"(a)",advance="no")  " => Enter the number of propagation vectors (nk > 0): "
        !read(*,*) nk
        !if(nk < 1) exit
  		  !do i=1,nk
  		  !	write(*,"(a,i2,a)",advance="no") " => Enter propagation vector # ",i," : "
  		  !	read(*,*) kv(:,i)
  		  !end do
        !
        !if(len_trim(symb) == 0) exit
        !call Set_SpaceGroup(symb,SpG)
        !call Write_SpaceGroup(SpG,full=.true.)
        !
        !write(*,"(//,a)") "  INTERSECTION SPACE GROUP"
        !write(*,"(a)")    "  ========================"
        !call Set_SSGs_from_Gkk(SpG,nk,kv(:,1:nk))

        !Dd=4+nk
        !if(allocated(mat)) deallocate(Mat)
        !allocate(Mat(Dd,Dd))
        !if(allocated(matrix)) deallocate(Matrix)
        !allocate(Matrix(Dd,Dd))
        !forma="( a8)"
        !write(forma(2:2),"(i1)") Dd
        !write(*,"(a,i2)")  " => You should enter the symbol of an extended matrix of dimension: ",Dd
        !write(*,"(a)")  " => Example for nk=1 :  x1-x2,x2+1/2,x3-x1+3/4,x4+1/2,-1 (the last symbol is time inversion) "
        !do
        !   write(*,"(a)",advance="no")  " => Enter the symbol of the operator: "
        !   read(*,"(a)") symb
        !   if(len_trim(symb) == 0) exit
        !   call Get_Mat_From_SSymSymb(Symb,Mat)
        !   matrix=print_rational(Mat)
        !   write(unit=*,fmt="(a)") "  Rational Matrix corresponding to "//trim(symb)
        !   do j=1,Dd
        !      write(unit=*,fmt=forma) (trim( Matrix(j,k))//" ",k=1,Dd)
        !   end do
        !   !Retransformation to a symbol
        !   write(unit=*,fmt="(a)")" "
        !   call Get_SSymSymb_from_Mat(Mat,Symb,"xyz")
        !   write(unit=*,fmt="(a)") "     xyz_type: "//trim(Symb)
        !   call Get_SSymSymb_from_Mat(Mat,Symb,"x1x2x3")
        !   write(unit=*,fmt="(a)") "  x1x2x3_type: "//trim(Symb)
        !   call Get_SSymSymb_from_Mat(Mat,Symb,"abc")
        !   write(unit=*,fmt="(a)") "     abc_type: "//trim(Symb)
        !end do
        !
        !cycle

        !---------------------------------------
        !Test access using the number of the SSG
        !---------------------------------------


        write(*,"(//,a)",advance="no") " => Enter the number of the SSG: "
        read(*,*) m
        if(m <= 0) exit
        if(m > 16697) then
          write(*,"(a)") " => There are only 16697 superspace groups in the database! "
          cycle
        end if
        call CPU_TIME(tini)
        !Call Read_single_SSG(m,ok,Message) !this gives access violation => read the full table at the beginning
        write(*,"(3(a,i5))") " Group number:",igroup_number(m), " Bravais class:",igroup_class(m), "  Basic Group #:",igroup_spacegroup(m)
        iclass=igroup_class(m)
        nmod=iclass_nmod(iclass)
        write(*,"(a,tr4,a)")  group_nlabel(m), group_label(m)
        write(*,"(a,i3)") " Number of operators:", igroup_nops(m)
        do k=1,igroup_nops(m)
          write(*,"(a,i3)") " Operator #",k
          forma="(  i4)"
          write(forma(2:3),"(i2)") nmod+4
          do i=1,nmod+4
            write(*,forma) igroup_ops(i,1:nmod+4,k,m)
          end do
        end do

        call Set_SSG_Reading_Database(data_base_path,m,SSpaceGroup,ok,message) !construct

        if(.not. ok) then
          write(*,"(a)") "   !!! "//message//" !!!"
          stop
        end if

        call Write_SSG(SSpaceGroup,full=.true.)
        Dd=size(SSpaceGroup%SymOp(1)%Mat,dim=1)
        if(SSpaceGroup%Centred == 2) then
          SSpaceGroup%SymOp(4)%Mat = -SSpaceGroup%SymOp(1)%Mat
          SSpaceGroup%SymOp(4)%Mat(Dd,Dd) = 1
        end if

        !Generate subgroups
        i1=0; i2=0; i3=0
        if(SSpaceGroup%Num_Lat > 1) then
          i1=SSpaceGroup%NumOps+1
          if(SSpaceGroup%Num_Lat > 2) then
            i2=2*SSpaceGroup%NumOps+1
            if(SSpaceGroup%Num_Lat > 3) then
              i3=3*SSpaceGroup%NumOps+1
            end if
          end if
        end if
        do i=1,200
          call Allocate_SSG_SymmOps(Dd-4,8*SSpaceGroup%multip,spg(i)%SymOp)
        end do
        ng=4
        do i=2,SSpaceGroup%numops-1
          spg(i)%SymOp(1)=SSpaceGroup%SymOp(1)

          spg(i)%SymOp(2)=SSpaceGroup%SymOp(i)
          spg(i)%SymOp(3)=SSpaceGroup%SymOp(i+1)
          spg(i)%SymOp(3)%time_inv=-1

          spg(i)%SymOp(4)=spg(i)%SymOp(1)  !Operator 4 is {1'|000...1/2}
          spg(i)%SymOp(4)%time_inv=-1
          spg(i)%SymOp(4)%Mat(Dd-1,Dd)=1//2

          if(SSpaceGroup%Num_Lat > 1) then
           spg(i)%SymOp(5)=SSpaceGroup%SymOp(i1)
           ng=4+1
           if(SSpaceGroup%Num_Lat > 2) then
             spg(i)%SymOp(6)=SSpaceGroup%SymOp(i2)
             ng=4+2
             if(SSpaceGroup%Num_Lat > 3) then
               spg(i)%SymOp(7)=SSpaceGroup%SymOp(i3)
               ng=4+3
             end if
           end if
          end if
          call CPU_TIME(tpar)
          Call Gen_Group(ng,spg(i)%SymOp,multip,table)
          if(Err_ssg) then
            write(*,"(a)") " => ERROR: "//trim(Err_ssg_mess)
            !cycle
          end if
        !Writing of the rational operator matrices
          Write(*,"(/,2(a,i4))") " Number of generated operators for subgroup # ",i,":",multip
        !if(allocated(matrix)) deallocate(Matrix)
        !allocate(Matrix(Dd,Dd))
        !forma="( a8)"
        !write(forma(2:2),"(i1)") Dd
          do j=1,multip
            call Get_SSymSymb_from_Mat(spg(i)%SymOp(j)%Mat,Operator_Symbol,"x1x2x3",spg(i)%SymOp(j)%time_inv)
            write(unit=*,fmt="(a,i3,a)") "  Operator # ",j,"  "//trim(Operator_Symbol)
            !matrix=print_rational(SSpaceGroup%SymOp(i)%Mat)
            !write(unit=*,fmt="(a,i3)") "  Rational Operator #",i
            !do j=1,Dd
            !   write(unit=*,fmt=forma) (trim( Matrix(j,k))//" ",k=1,Dd)
            !end do
          end do
         !write(unit=*,fmt="(/,a)") " Writing the multiplication table "
         !
         !do j=1,multip
         !  write(unit=*,fmt="(1024i4)") table(j,1:multip)
         !end do
         call CPU_TIME(tfin)
         write(*,"(/a,f12.4/)")   " => Partial CPU TIME: ",tfin-tpar
         write(*,"(/a,f12.4/)")   " => Total   CPU TIME: ",tfin-tini
        end do
        write(*,"(a,i3)") " Reflection conditions: ",igroup_nconditions(m)
        if(igroup_nconditions(m) > 0)then
         do k=1,igroup_nconditions(m)
           write(*,*)((igroup_condition1(i,j,k,m),i=1,nmod+3),j=1,nmod+3),(igroup_condition2(j,k,m),j=1,nmod+4)
         end do
        end if

        !----------------------------
        !Test access using the parent
        !----------------------------

        !write(*,"(//,a)",advance="no") " => Enter the number of the parent space group: "
        !read(*,*) m
        !if(m <= 0) exit
        !write(*,"(//,a)",advance="no") " => Enter the number of modulation vectors (<=3): "
        !read(*,*) nk
        !if(nk < 1) exit
        !do i=1,m_ngs
        !	symb=group_nlabel(i)
        !	j=index(symb,".")
        !	read(symb(1:j-1),*) k
        !	if(k /= m) cycle
        !  iclass=igroup_class(i)
        !	if(nk /= iclass_nmod(igroup_class(i))) cycle
        !	write(*,"(i6,a)") i, "  "//group_label(i)
        !end do
        !cycle

        !----------------------------
        !Test of the subroutine Gen_SSGroup(ngen,gen,SSG)
        !----------------------------


       !write(*,"(//,a)",advance="no")  " => Enter the number of modulation vectors: "
       !read(*,*) nk
       !Dd=4+nk
       !write(*,"(2(a,i2),a)")  " => Extended Matrices of dimension: ",Dd," corresponding to ",nk," mod. vectors"
       !write(*,"(a)",advance="no")  " => Enter the number of generators: "
       !read(*,*) ng
       !if(ng == 0) exit
       !
       !if(allocated(gen)) deallocate(gen)
       !allocate(gen(ng))
       !call Allocate_SSG_SymmOps(nk,ng,gen)
       !if(allocated(Matrix)) deallocate(Matrix)
       !allocate(Matrix(Dd,Dd))
       !forma="( a8)"
       !write(forma(2:2),"(i1)") Dd
       !do i=1,ng
       !   do
       !     write(*,"(a,i2,a)",advance="no")  " => Enter the symbol of the generator #",i," : "
       !     read(*,"(a)") symb
       !     if(len_trim(symb) == 0) exit
       !     call Get_Mat_From_SSymSymb(Symb,gen(i)%Mat)
       !     if(err_ssg) then
       !     	 write(*,"(a)") " => "//trim(err_ssg_mess)
       !     	 cycle
       !     else
       !     	 exit
       !     end if
       !   end do
       !   matrix=print_rational(gen(i)%Mat)
       !   write(unit=*,fmt="(a)") "  Rational Matrix corresponding to "//trim(symb)
       !   do j=1,Dd
       !      write(unit=*,fmt=forma) (trim( Matrix(j,k))//" ",k=1,Dd)
       !   end do
       !end do
       !
       !call Gen_SSGroup(ng,gen,SSpaceGroup,"xyz",table)
       !call Write_SSG(SSpaceGroup,full=.true.)
       !write(unit=*,fmt="(/,a)") " Writing the multiplication table "
       !
       !do j=1,SSpaceGroup%multip
       !  write(unit=*,fmt="(1024i4)") table(j,1:SSpaceGroup%multip)
       !end do

      end do

    End Program read_ssg_datafile
