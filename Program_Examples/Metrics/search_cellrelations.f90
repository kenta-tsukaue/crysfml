  Program Cell_Relations
    use CFML_Crystal_Metrics,  only: Crystal_Cell_Type, Err_Crys, Err_Crys_Mess, Init_err_crys,  &
                                     Change_Setting_Cell,Set_Crystal_Cell, Write_Crystal_Cell,   &
                                     get_primitive_cell
    use CFML_String_utilities, only: l_case
    use CFML_Math_3D,          only: Invert_A
    use CFML_Math_General,     only: acosd
    implicit none
    real,    dimension(3)       :: cel1,ang1,cel2,ang2,cel,ang,pcel2,pang2
    real,    dimension(6)       :: bestsol
    integer, dimension(3,3)     :: mat,bestmat
    real,    dimension(3,3)     :: base,trans,newc,gn,tp,stp,itp,istp
    character(len=1)            :: lat_type,slat_type
    type (Crystal_Cell_Type)    :: cell, supercell, pcell, psupercell
    logical :: possible,centred,scentred

    !Use the information about the centring lattice to obtain the primitive cell
    !of the original sublattice. Generates supercells by integer linear combinations
    !Take the primitive lattice of the target supercell and get the reduced cell parameters
    !Compare the generated cells with the target supercell within a tolerance for each cell
    !parameter and each angle. Output the matrices giving cells within tolerance.

    character(len=256) :: fileinp, fileout, line
    integer :: i,j,lun=1,lout=2, ier,i1,i2,i3,i4,i5,i6,i7,i8,i9,iratio,n,irvol
    integer :: ia1,ia2,ib1,ib2,ic1,ic2, iargc,narg,isol,nn,im, neq
    real    :: tol1,tol2,rvol,rfac,bestr,sm,start,fin


    narg=iargc()
    if(narg /= 0) then
      CALL getarg(1,fileinp)
      open(unit=lun,file=trim(fileinp),status="old",action="read",position="rewind",iostat=ier)
      CALL getarg(2,fileout)
    end if
    if(ier /=0 .or. narg == 0) then
    ! reading data
      do
        write(unit=*,fmt="(a)") " => Enter the name of the input file: "
        read(unit=*,fmt="(a)") fileinp
        open(unit=lun,file=trim(fileinp),status="old",action="read",position="rewind",iostat=ier)
        if(ier /= 0) cycle
        exit
      end do
      write(unit=*,fmt="(a)") " => Enter the name of the output file: "
      read(unit=*,fmt="(a)") fileout
    end if

    open(unit=lout,file=trim(fileout),status="replace",action="write")
    do
      read(unit=lun,fmt="(a)",iostat=ier) line
      if(ier /= 0) exit
      line=l_case(line)
      i=index(line,"cell")
      if( i /= 0) read(unit=line(5:),fmt=*) cel1,ang1, lat_type
      i=index(line,"super")
      if( i /= 0) read(unit=line(6:),fmt=*) cel2,ang2, slat_type
      i=index(line,"tol")
      if( i /= 0) read(unit=line(4:),fmt=*) tol1,tol2
      i=index(line,"indices")
      if( i /= 0) read(unit=line(8:),fmt=*) ia1,ia2,ib1,ib2,ic1,ic2
    end do
    centred=.true.
    scentred=.true.
    if(lat_type == "P" .or. lat_type == "p") centred=.false.
    if(slat_type == "P" .or. slat_type == "p") scentred=.false.
    call Set_Crystal_Cell(cel1,ang1,Cell)
    write(unit=lout,fmt="(a)") "  ------------------------------"
    write(unit=lout,fmt="(a)") "  PROGRAM: Search_Cell_Relations"
    write(unit=lout,fmt="(a)") "  ------------------------------"
    write(unit=lout,fmt="(/,a)") "  => INPUT SUBCELL DATA"
    call Write_Crystal_Cell(Cell,Lout)
    call Get_Primitive_Cell(lat_type,cell,pcell,tp)
    if(centred) then
      itp=invert_a(tp)
      write(unit=lout,fmt="(/,a)") "  => Input subcell data in primitive setting"
      write(unit=lout,fmt="(/,a)") "  => Transformation matrix to primitive cell and inverse:"
      do i=1,3
         write(unit=lout,fmt="(2(a,3f10.4))")"                 ",tp(i,:),"                 ",itp(i,:)
      end do
      call Write_Crystal_Cell(pCell,Lout)
    else
      itp=tp
    end if
    base=transpose(pCell%Cr_Orth_cel)   !Provides a matrix with rows equal to the basis vectors in cartesian components
    call Set_Crystal_Cell(cel2,ang2,SuperCell)   !SuperCell%Cr_Orth_cel
    write(unit=lout,fmt="(/,a)") "  => INPUT SUPERCELL DATA"
    call Write_Crystal_Cell(SuperCell,Lout)
    call Get_Primitive_Cell(slat_type,SuperCell,pSuperCell,stp)
    if(scentred) then
      istp=invert_a(stp)
      write(unit=lout,fmt="(/,a)") "  => Input supercell data in primitive setting"
      write(unit=lout,fmt="(/,a)") "  => Transformation matrix to primitive cell and inverse:"
      do i=1,3
         write(unit=lout,fmt="(2(a,3f10.4))")"                 ",stp(i,:),"                 ",istp(i,:)
      end do
      call Write_Crystal_Cell(pSuperCell,Lout)
    else
      istp=stp
    end if
    pcel2=pSuperCell%cell
    pang2=pSuperCell%ang
    rvol=pSuperCell%CellVol/pcell%CellVol
    irvol=nint(rvol)
    iratio= (ia2-ia1+1)*(ia2-ia1+1)*(ia2-ia1+1)*(ib2-ib1+1)*(ib2-ib1+1)*(ib2-ib1+1)*(ic2-ic1+1)*(ic2-ic1+1)*(ic2-ic1+1)
    write(unit=*,fmt="(a,i3)")  " => The volume  ratio between cells is ",irvol
    write(unit=*,fmt="(a,i10)") " => The maximum number of cell calculations is ",iratio
    im=iratio/2000
    n=0
    bestr=1000000.0
    nn=0
    call cpu_time(start)
    do i1=ia1,ia2                        !         |i1  i2  i3|
     do i2=ib1,ib2                       ! Trans = |i4  i5  i6|  = mat
      do i3=ic1,ic2                      !         |i7  i8  i9|
       do i4=ia1,ia2
        do i5=ib1,ib2                    !   |A|   |i1  i2  i3| |a|
         do i6=ic1,ic2                   !   |B| = |i4  i5  i6| |b|
          do i7=ia1,ia2                  !   |C|   |i7  i8  i9| |c|
           do i8=ib1,ib2
            do i9=ic1,ic2
             j=i1*i5*i9+i4*i8*i3+i2*i6*i7-i3*i5*i7-i8*i6*i1-i2*i4*i9     !determinant (much faster than calling determ_A)
             !if( j /= irvol) cycle
             if( abs(j-irvol) > 1) cycle
             mat=transpose(reshape((/i1,i2,i3,i4,i5,i6,i7,i8,i9/),(/3,3/)))
             trans=real(mat)
             newc=matmul(trans,base)
             gn=matmul(newc,transpose(newc)) !Metric tensor
             possible=.true.
             rfac=0.0
             !---- Calculate new cell parameters from the new metric tensor
             do i=1,3
                Cel(i)=sqrt(gn(i,i))
                sm=abs(cel(i)-pcel2(i))
                rfac=rfac+sm
                if( sm > tol1) possible=.false.
             end do
             nn=nn+1
             if(mod(nn,im) == 0)  write(unit=*,fmt="(a)",advance="no") "."
             if(.not. possible) cycle
             ang(1)=acosd(Gn(2,3)/(cel(2)*cel(3)))
             ang(2)=acosd(Gn(1,3)/(cel(1)*cel(3)))
             ang(3)=acosd(Gn(1,2)/(cel(1)*cel(2)))

             do i=1,3
               sm=abs(ang(i)-pang2(i))
               rfac=rfac+sm
               if( sm > tol2) possible=.false.
             end do
             rfac=rfac/6.0
             if(possible) then  !Found a candidate to the good cell
               n=n+1

               if(rfac < bestr) then
                 neq=0
                 bestr=rfac
                 bestsol(1:3)=cel
                 bestsol(4:6)=ang
                 isol=n
                 bestmat=mat
                 write(unit=*,fmt="(/,a,i10,a,f10.5)") " => The best solution for the moment is for the calculation number ",nn,&
                                                    " with average deviation: ",rfac
                 write(unit=*,fmt="(a)") " => The transformation matrix between primitive cells is: "
                 do i=1,3
                   write(unit=*,fmt="(a, 3i4)") "                           ",mat(i,:)
                 end do
                 write(unit=*,fmt="(a,3f8.4,3f8.2)") " => Observed   primitive super cell: ",pcel2,pang2
                 write(unit=*,fmt="(a,3f8.4,3f8.2)") " => Calculated primitive unit  cell: ",cel,ang
               else if(rfac == bestr) then
                 neq=neq+1
                 write(unit=*,fmt="(/,a,i3,a,i10)") " => Another equivalent to the best solution",neq, " calculation number: ",nn
               end if

               write(unit=lout,fmt="(/,a,i4)") " => Solution number:",n
               write(unit=lout,fmt="(a)") " => Transformation matrix between primitive cells: "
               do i=1,3
                 write(unit=lout,fmt="(a, 3i4)") "                           ",mat(i,:)
               end do
               write(unit=lout,fmt="(a,3f8.4,3f8.2)") " => Observed   primitive super cell: ",pcel2,pang2
               write(unit=lout,fmt="(a,3f8.4,3f8.2)") " => Calculated primitive unit  cell: ",cel,ang
               write(unit=lout,fmt="(a,f10.5)")       " => Average deviation: ",rfac
               if(scentred .or. centred) then
                 write(unit=lout,fmt="(a)") " => Transformation matrix between conventional cells: "
                 gn=matmul(istp,matmul(trans,tp))
                 do i=1,3
                   write(unit=lout,fmt="(a, 3i4)") "                           ",nint(gn(i,:))
                 end do
               end if
               write(unit=lout,fmt="(a)") "    ----------------------------------------------------------------------"
             end if
            end do    !i9
           end do     !i8
          end do      !i7
         end do       !i6
        end do        !i5
       end do         !i4
      end do          !i3
     end do           !i2
    end do            !i1
    write(unit=lout,fmt="(a,i6,a,f10.5)") " => The best solution is the number ",isol,&
                                                     " with average deviation: ",bestr
    write(unit=lout,fmt="(a,i3,a)")  " => There are other ",neq," equivalent solutions in the list"
    write(unit=lout,fmt="(a,3f8.4,3f8.2)")  " => The corresponding primitive cell parameters are: ",bestsol
    write(unit=lout,fmt="(a,3f8.4,3f8.2)")  " => The observed      primitive cell parameters are: ",pcel2,pang2
    call Set_Crystal_Cell(bestsol(1:3),bestsol(4:6),pSuperCell) !use primitive for convenience
    base=transpose(pSuperCell%Cr_Orth_cel)  !basis vectors of the primitive cell
    newc=matmul(real(istp),base)            !Transformation to conventional cell
    gn=matmul(newc,transpose(newc))         !Metric tensor of the conventional cell
    do i=1,3
       Cel(i)=sqrt(gn(i,i))
    end do
    ang(1)=acosd(Gn(2,3)/(cel(2)*cel(3)))
    ang(2)=acosd(Gn(1,3)/(cel(1)*cel(3)))
    ang(3)=acosd(Gn(1,2)/(cel(1)*cel(2)))

    write(unit=lout,fmt="(a,3f8.4,3f8.2)")  " => The corresponding conventional cell parameters are: ",cel,ang
    write(unit=lout,fmt="(a,3f8.4,3f8.2)")  " => The observed      conventional cell parameters are: ",cel2,ang2
    write(unit=lout,fmt="(a)") " => Transformation matrix between conventional cells: "

    gn=matmul(istp,matmul(real(bestmat),tp))
    do i=1,3
      write(unit=lout,fmt="(a, 3i4)") "                           ",nint(gn(i,:))
    end do
    call cpu_time(fin)
    write(unit=*,fmt="(/,a,f10.2,a)")  "  CPU-Time: ", fin-start," seconds"
    stop
  End Program Cell_Relations
