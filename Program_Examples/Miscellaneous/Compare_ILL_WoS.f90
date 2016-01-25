!!---- Program to compare ISI Web files founds with the ILL data base.
!!---- The articles from the ILL database not found in the WoS are flagged and output
!!---- to a file. Moreover the spurious publications not existing in the ILL database
!!---- but "found" by the WoS are also flagged and output to spurious papers file.
!!---- Author: Juan Rodriguez-Carvajal (ILL)
  Program Compare_ILL_WoS
   use CFML_String_Utilities, only: l_case,get_separator_pos
   use Data_Articles_Mod,     only: article,articles,comma,tab
   implicit none
   character(len=1024)     :: line 
   character(len=80)       :: fileinf,file_wos 

   integer :: ier,n,i,j, nart, nlog, n_wos,n_doi,nwos,n_both
   integer :: narg,iart=1,iwos=2,i_str
   logical :: esta,ok 
   logical, dimension(:), allocatable :: esta_ill,esta_wos 
   integer, dimension(:), allocatable :: point_to_wos 
   Type(article), dimension(:), allocatable :: artic_wos


   open(newunit=i_str,file="ILL_Pubs_Compare.log",status="replace",action="write")

   write(unit=*,fmt="(/a)") "----------------------------------------------------------------------"
   write(unit=*,fmt="( a)") " Program to compare the result of the Web of Science using the string "
   write(unit=*,fmt="( a)") " generated by ILL_Pubs_WoS with the file from the ILL database ."
   write(unit=*,fmt="( a)") "                     January 2016, JRC -ILL"
   write(unit=*,fmt="( a)") "      Usage: -> Compare_ILL_WoS ILL_file WoS_file  "
   write(unit=*,fmt="(a/)") "----------------------------------------------------------------------"

   write(unit=i_str,fmt="(/a)") "----------------------------------------------------------------------"
   write(unit=i_str,fmt="( a)") " Program to compare the result of the Web of Science using the string "
   write(unit=i_str,fmt="( a)") " generated by ILL_Pubs_WoS with the file from the ILL database ."
   write(unit=i_str,fmt="( a)") "                     January 2016, JRC -ILL"
   write(unit=i_str,fmt="( a)") "      Usage: -> Compare_ILL_WoS ILL_file WoS_file  "
   write(unit=i_str,fmt="(a/)") "----------------------------------------------------------------------"

   narg= COMMAND_ARGUMENT_COUNT()

   if( narg <= 1) then

     write(unit=*,fmt="(a)") " => The program 'Compare_ILL_WoS' should be invoked with two arguments as indicated above"
     write(unit=*,fmt="(a)") "    The two arguments are: "
     write(unit=*,fmt="(a)") "     1: the name of the saved file from the ILL database "
     write(unit=*,fmt="(a)") "     2: the name of the file (Plain text) saved from the WoS with the found publications "
     write(unit=*,fmt="(a)") "    "
     stop

   else

     call GET_COMMAND_ARGUMENT(1, fileinf)
     call GET_COMMAND_ARGUMENT(2, file_wos)

   end if
   inquire(file=fileinf,exist=esta)
   if(.not. esta) then
     write(unit=*,fmt="(a)")    " => The input file: "//trim(fileinf)//" doesn't exist!"
     stop
   end if
   inquire(file=file_wos,exist=esta)
   if(.not. esta) then
     write(unit=*,fmt="(a)")    " => The input file: "//trim(file_wos)//" doesn't exist!"
     stop
   end if

   open(unit=iart,file=fileinf,status="old",action="read", position="rewind")
   nart=0
   !Determine the number of papers in the ILL file
   do
     read(unit=iart,fmt="(a)",iostat=ier)  line
     if(ier /= 0) exit
     if(len_trim(line) == 0) cycle
     if(line(1:6) =="Number") nart=nart+1
   end do
   rewind(unit=iart)
   allocate(articles(nart),esta_ill(nart),point_to_wos(nart))
   esta_ill=.false.
   n=0
   n_doi=0; nwos=0
   do
     read(unit=iart,fmt="(a)",iostat=ier)  line
     if(ier /= 0) then
       write(unit=*,fmt="(a,i7,a)") " => Number of ILL-Articles read: ",n,"   -> Last article: "//trim(articles(n)%Numb)
       exit
     end if
     if(len_trim(line) == 0) cycle
     j=index(line,tab)
     Select Case(line(1:j-1))
       Case("Number")
         n=n+1
         articles(n)%Numb= line(j+1:)       !<  1  Numero
         articles(n)%instrument(1)= "Instr"
       Case("Author")
         articles(n)%Authors= line(j+1:)    !<  2  Auteurs
       Case("Title")
         articles(n)%Title= line(j+1:)      !<  3  Titre
       Case("Journal title")
         articles(n)%Journal= line(j+1:)    !<  4  Journal
       Case("ISBN")
         articles(n)%ISBN= line(j+1:)       !<  5  Journal
       Case("Volume")
         articles(n)%Volume= line(j+1:)     !<  6  Volume
       Case("Pages")
         articles(n)%Pages= line(j+1:)      !<  7  Pages
       Case("WoS number")
            articles(n)%WOS= adjustl(line(j+1:))  !< 8 WOS
            nwos=nwos+1
       Case("DOI","DOI added")
         i=index(line,"Keyword")
         if( i /= 0) then
            articles(n)%DOI= line(j+1:i-1)     !<  9  DOI
         else
            articles(n)%DOI= line(j+1:)        !<  9  DOI
         end if
         n_doi=n_doi+1
       Case("Year")
         read (unit=line(j+1:),fmt=*,iostat=ier) articles(n)%year  !< 10 Annee
         if(ier /= 0) then
           if(len_trim(articles(n)%DOI) == 0 .and. len_trim(articles(n)%WOS) == 0) then
             write(unit=*,fmt="(a,a)")  " => Error reading the year in the article: "//trim(articles(n)%Numb), &
             " ... The document "//trim(articles(n)%Numb)//" is discarded"
             write(unit=i_str,fmt="(a,a)")  " => Error reading the year in the article: "//trim(articles(n)%Numb), &
             " ... The document "//trim(articles(n)%Numb)//" is discarded"
             n=n-1
             cycle
           else
             articles(n)%year=0
           end if
         end if
       Case Default
         cycle
     End Select
     articles(n)%typ=1
   end do
   close(unit=iart)
   nart=n


   open(unit=iwos,file=trim(file_wos),status="old",action="read")
   n_wos=0
   !Determine the number of papers in the file_wos
   do
     read(unit=iwos,fmt="(a)",iostat=ier)  line
     if(ier /= 0) exit
     if(len_trim(line) == 0) cycle
     if(line(1:3) =="ER ") n_wos=n_wos+1
   end do
   rewind(unit=iwos)
   allocate(artic_wos(n_wos),esta_wos(n_wos))
   esta_wos=.false.
   n=0

   do
     read(unit=iwos,fmt="(a)",iostat=ier)  line
     if(ier /= 0) then
       write(unit=*,fmt="(a,i7,a)") " => Number of WoS-Articles read: ",n,"   -> Last article: "//trim(artic_wos(n)%Numb)
       exit
     end if
     if(len_trim(line) == 0) cycle
     
     Select Case(line(1:2))
       
       Case("PT")
         n=n+1
         write(unit=artic_wos(n)%Numb,fmt="(i4)") n
       
       Case("AU")
         line=line(4:)
         i=index(line,",")
         line=line(1:i-1)//line(i+1:)
         artic_wos(n)%Authors= trim(line)//","    !<  2  Auteurs
         do
           read(unit=iwos,fmt="(a)",iostat=ier)  line
           if(line(1:2) == "AF") exit
           line=adjustl(line)
           i=index(line,",")
           line=line(1:i-1)//line(i+1:)         
           artic_wos(n)%Authors=trim(artic_wos(n)%Authors)//" "//trim(line)//","
         end do
         i=len_trim(artic_wos(n)%Authors)
         artic_wos(n)%Authors=artic_wos(n)%Authors(1:i-1)
         
       Case("TI")
         artic_wos(n)%Title= line(4:)      !<  3  Titre
         read(unit=iwos,fmt="(a)",iostat=ier)  line 
         if(line(1:2) == "  ") then
            artic_wos(n)%Title=trim(artic_wos(n)%Title)//" "//trim(adjustl(line))
         else
            backspace(unit=iwos)
         end if
                 
       Case("SO")
         artic_wos(n)%Journal= line(4:)    !<  4  Journal
       
       Case("NR")
         artic_wos(n)%Volume= line(4:)     !<  5  Volume
       
       Case("BP")
         artic_wos(n)%Pages= line(4:)      !<  6  Pages
       
       Case("EP")
         artic_wos(n)%Pages=trim(artic_wos(n)%Pages)//"-"//line(4:)      !<  6  Pages
      
       Case("UT")
            artic_wos(n)%WOS= adjustl(line(4:))
       
       Case("DI")
             artic_wos(n)%DOI= line(4:)     !<  6  DOI
       
       Case("PY")
         read (unit=line(4:),fmt=*,iostat=ier) artic_wos(n)%year  !< 7 Annee
         if(ier /= 0) then
           write(unit=*,fmt="(a,a)")  " => Error reading the year in the article: "//trim(articles(n)%Numb), &
           " ... The document "//trim(artic_wos(n)%Numb)//" is discarded"
           write(unit=i_str,fmt="(a,a)")  " => Error reading the year in the article: "//trim(articles(n)%Numb), &
           " ... The document "//trim(artic_wos(n)%Numb)//" is discarded"
           n=n-1
           cycle
         end if
      
       Case Default
         cycle
     End Select
     artic_wos(n)%typ=1
   end do
   close(unit=iwos)
   n_wos=n

!------------------------------------------------------------------

   n=0; n_both=0
   do j=1,nart
     if(len_trim(articles(j)%DOI) /=0 .and. len_trim(articles(j)%WOS) /=0) n_both=n_both+1
     do i=1,n_wos
       call compare_articles(articles(j),artic_wos(i),ok)
       if(ok) then
          esta_ill(j)=ok
          esta_wos(i)=ok
          point_to_wos(j)=i
          n=n+1
          exit
       end if       
     end do
   end do

   write(unit=i_str,fmt="(a,i4)") " => Number of articles with DOI      in the ILL-database  : ",n_doi  
   write(unit=i_str,fmt="(a,i4)") " => Number of articles with WoS      in the ILL-database  : ",nwos
   write(unit=i_str,fmt="(a,i4)") " => Number of articles with DOI+WoS  in the ILL-database  : ",n_both
   write(unit=*,fmt="(a,i4)")     " => Number of articles with DOI      in the ILL-database  : ",n_doi  
   write(unit=*,fmt="(a,i4)")     " => Number of articles with WoS      in the ILL-database  : ",nwos
   write(unit=*,fmt="(a,i4)")     " => Number of articles with DOI+WoS  in the ILL-database  : ",n_both
    
   write(unit=i_str,fmt="(//,a)") "    ARTICLES NOT FOUND IN THE WEB OF SCIENCE"
   write(unit=i_str,fmt="(a)")    "    ========================================"
   n=0
   do j=1,nart
     if(esta_ill(j)) cycle
     n=n+1
     write(unit=i_str,fmt="(a)")    "  Number  : "//trim(articles(j)%Numb)
     write(unit=i_str,fmt="(a)")    "  Title   : "//trim(articles(j)%title)
     write(unit=i_str,fmt="(a)")    "  Authors : "//trim(articles(j)%Authors)
     write(unit=i_str,fmt="(a)")    "  Journal : "//trim(articles(j)%journal)
     write(unit=i_str,fmt="(a)")    "  Volume  : "//trim(articles(j)%volume)
     write(unit=i_str,fmt="(a)")    "  Pages   : "//trim(articles(j)%pages)
     write(unit=i_str,fmt="(a)")    "  DOI     : "//trim(articles(j)%DOI)
     write(unit=i_str,fmt="(a)")    "  WOS     : "//trim(articles(j)%WOS)
     write(unit=i_str,fmt="(a,i4)") "  Year    : ",articles(j)%year
     write(unit=i_str,fmt="(a)") "   " 
   end do
   write(unit=i_str,fmt="(/a,i4)") " => Number of ILL-articles not found in the WoS           : ",n 
   write(unit=*,fmt="(a,i4)") " => Number of ILL-articles not found in the WoS           : ",n 
   write(unit=i_str,fmt="(//,a)") "    ARTICLES FOUND IN THE WEB OF SCIENCE NOT IN ILL DATABASE"
   write(unit=i_str,fmt="(a)")    "    ========================================================"
   n=0
   do i=1,n_wos
     if(esta_wos(i)) cycle
     n=n+1
     write(unit=i_str,fmt="(a)")    "  Number  : "//trim(artic_wos(i)%Numb)
     write(unit=i_str,fmt="(a)")    "  Title   : "//trim(artic_wos(i)%title)
     write(unit=i_str,fmt="(a)")    "  Authors : "//trim(artic_wos(i)%Authors)
     write(unit=i_str,fmt="(a)")    "  Journal : "//trim(artic_wos(i)%journal)
     write(unit=i_str,fmt="(a)")    "  Volume  : "//trim(artic_wos(i)%volume)
     write(unit=i_str,fmt="(a)")    "  Pages   : "//trim(artic_wos(i)%pages)
     write(unit=i_str,fmt="(a)")    "  DOI     : "//trim(artic_wos(i)%DOI)
     write(unit=i_str,fmt="(a)")    "  WOS     : "//trim(artic_wos(i)%WOS)
     write(unit=i_str,fmt="(a,i4)") "  Year    : ",artic_wos(i)%year
     write(unit=i_str,fmt="(a)") "   " 
   end do

   write(unit=i_str,fmt="(/a,i4)") " => Number of WoS-articles not found in the ILL-database  : ",n 
   write(unit=*,fmt="(a,i4)") " => Number of WoS-articles not found in the ILL-database  : ",n 

   contains
    
     subroutine compare_articles(art_ill,art_wos,ok)
       type(article), intent(in) :: art_ill
       type(article), intent(in) :: art_wos
       logical,       intent(out):: ok
       !--- Local variables ---!
       character(len=256)              :: str_ill,str_wos
       logical                         :: ok_aut,ok_year,ok_title
       integer, dimension(60)          :: pos
       integer                         :: ncar,nau,ncoi,i,j
       character(len=20),dimension(30) :: author
       ok=.false.
       ok_year=.false.; ok_title=.true.; ok_aut=.true.
       if(art_ill%year == art_wos%year) ok_year=.true.
       !Test WOS
       str_ill=l_case(art_ill%WOS)
       str_wos=l_case(art_wos%WOS)
       if(index(str_ill,str_wos) /= 0) then
         ok=.true.
         return
       end if
       !Test DOI
       str_ill=l_case(art_ill%DOI)
       str_wos=l_case(art_wos%DOI)
       if(index(str_ill,str_wos) /= 0) then
         ok=.true.
         return
       end if
       !Test Title+Authors+year
       !Treat the name of the authors having blanks
       !write(*,*) trim(art_wos%authors)
       call get_separator_pos(trim(art_wos%authors),comma,pos,ncar)
       nau=ncar+1
       if(nau > 1) then
         author(nau)=adjustl(art_wos%authors(pos(ncar)+1:))
         j=0
         do i=1,ncar
           author(i)= adjustl(art_wos%authors(j+1:pos(i)-1))
           j=pos(i)
         end do
       else
         author(1)=adjustl(art_wos%authors)
       end if
       str_ill=l_case(art_ill%authors)
       ncoi=0
       do i=1,nau
         j=index(author(i)," ")
         author(i)=author(i)(1:j-1)
         if(index(str_ill,trim(author(i))) == 0) then
           ncoi=ncoi+1
         end if
       end do 
       if(ncoi >= 1) ok_aut=.false.
       if(ok_aut .and. ok_year .and. ok_title) ok=.true.
       return
      end subroutine compare_articles
      
  End Program Compare_ILL_WoS
