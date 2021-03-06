      subroutine assignnemsiovar(im,jsta,jend,jsta_2l,jend_2u &
      ,l,nrec,fldsize &
      ,spval,tmp,recname,reclevtyp,reclev,VarName,VcoordName &
      ,buf)
!      
      implicit none
      INCLUDE "mpif.h"
!
      integer,intent(in) :: im,jsta,jend,jsta_2l,jend_2u,l,nrec,fldsize
      integer,intent(in) :: reclev(nrec)
      real,intent(in) :: spval,tmp(fldsize*nrec)
      character*8,intent(in) :: recname(nrec)
      character*16,intent(in) :: reclevtyp(nrec)
      character(len=20),intent(in) :: VarName,VcoordName
      real,intent(out) :: buf(im,jsta_2l:jend_2u)
      integer :: fldst,recn,js,j,i 
      
      call getrecn(recname,reclevtyp,reclev,nrec,varname(1:8),VcoordName,l,recn)
      if(recn/=0) then
        fldst=(recn-1)*fldsize
        do j=jsta,jend
          js=(j-jsta)*im
          do i=1,im
            buf(i,j)=tmp(i+js+fldst)
          enddo
        enddo
      else
        print*,'fail to read ', varname, ' assign missing value'
        buf=spval
      endif


      RETURN
      END   

!-----------------------------------------------------------------------
!#######################################################################
!-----------------------------------------------------------------------
!
      SUBROUTINE getrecn(recname,reclevtyp,reclev,nrec,fldname,          &
                         fldlevtyp,fldlev,recn)
!-----------------------------------------------------------------------
!-- this subroutine searches the field list to find out a specific field,
!-- and return the field number for that field
!-----------------------------------------------------------------------
!
        implicit none
!
        integer,intent(in)      :: nrec
        character(*),intent(in) :: recname(nrec)
        character(*),intent(in) :: reclevtyp(nrec)
        integer,intent(in)      :: reclev(nrec)
        character(*),intent(in) :: fldname
        character(*),intent(in) :: fldlevtyp
        integer,intent(in)      :: fldlev
        integer,intent(out)     :: recn
!
        integer i
!
        recn=0
        do i=1,nrec
          if(trim(recname(i))==trim(fldname).and.                        &
            trim(reclevtyp(i))==trim(fldlevtyp) .and.                    &
            reclev(i)==fldlev) then
            recn=i
            return
          endif
        enddo
!
        if(recn==0) print *,'WARNING: field ',trim(fldname),' ',         &
          trim(fldlevtyp),' ',fldlev,' is not in the nemsio file!'
!
!-----------------------------------------------------------------------
!
      END SUBROUTINE getrecn 
