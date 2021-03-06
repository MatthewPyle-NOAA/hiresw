












      subroutine jpcpack(fld,width,height,idrstmpl,cpack,lcpack)
!$$$  SUBPROGRAM DOCUMENTATION BLOCK
!                .      .    .                                       .
! SUBPROGRAM:    jpcpack
!   PRGMMR: Gilbert          ORG: W/NP11    DATE: 2002-12-17
!
! ABSTRACT: This subroutine packs up a data field into a JPEG2000 code stream.
!   After the data field is scaled, and the reference value is subtracted out,
!   it is treated as a grayscale image and passed to a JPEG2000 encoder.
!   It also fills in GRIB2 Data Representation Template 5.40 or 5.40000 with the
!   appropriate values.
!
! PROGRAM HISTORY LOG:
! 2002-12-17  Gilbert
! 2004-07-19  Gilbert - Added check on whether the jpeg2000 encoding was
!                       successful.  If not, try again with different encoder
!                       options.
!
! USAGE:    CALL jpcpack(fld,width,height,idrstmpl,cpack,lcpack)
!   INPUT ARGUMENT LIST:
!     fld()    - Contains the data values to pack
!     width    - number of points in the x direction
!     height   - number of points in the y direction
!     idrstmpl - Contains the array of values for Data Representation
!                Template 5.40 or 5.40000
!                (1) = Reference value - ignored on input
!                (2) = Binary Scale Factor
!                (3) = Decimal Scale Factor
!                (4) = number of bits for each data value - ignored on input
!                (5) = Original field type - currently ignored on input
!                      Data values assumed to be reals.
!                (6) = 0 - use lossless compression
!                    = 1 - use lossy compression
!                (7) = Desired compression ratio, if idrstmpl(6)=1.
!                      Set to 255, if idrstmpl(6)=0.
!     lcpack   - size of array cpack().
!
!   OUTPUT ARGUMENT LIST: 
!     idrstmpl - Contains the array of values for Data Representation
!                Template 5.0
!                (1) = Reference value - set by jpcpack routine.
!                (2) = Binary Scale Factor - unchanged from input
!                (3) = Decimal Scale Factor - unchanged from input
!                (4) = Number of bits containing each grayscale pixel value
!                (5) = Original field type - currently set = 0 on output.
!                      Data values assumed to be reals.
!                (6) = 0 - use lossless compression
!                    = 1 - use lossy compression
!                (7) = Desired compression ratio, if idrstmpl(6)=1
!     cpack    - The packed data field (character*1 array)
!     lcpack   - length of packed field in cpack().
!
! REMARKS: None
!
! ATTRIBUTES:
!   LANGUAGE: XL Fortran 90
!   MACHINE:  IBM SP
!
!$$$

      integer,intent(in) :: width,height
      real,intent(in) :: fld(width*height)
      character(len=1),intent(out) :: cpack(*)
      integer,intent(inout) :: idrstmpl(*)
      integer,intent(inout) :: lcpack

      real(4) :: ref,rmin4
      real(8) :: rmin,rmax
      integer(4) :: iref
      integer :: ifld(width*height),retry
      integer,parameter :: zero=0
      integer :: enc_jpeg2000
      character(len=1),allocatable :: ctemp(:)
      
      ndpts=width*height
      bscale=2.0**real(-idrstmpl(2))
      dscale=10.0**real(idrstmpl(3))
!
!  Find max and min values in the data
!
      rmax=fld(1)
      rmin=fld(1)
      do j=2,ndpts
        if (fld(j).gt.rmax) rmax=fld(j)
        if (fld(j).lt.rmin) rmin=fld(j)
      enddo
      if (idrstmpl(2).eq.0) then
         maxdif=nint(rmax*dscale)-nint(rmin*dscale)
      else
         maxdif=nint((rmax-rmin)*dscale*bscale)
      endif
!
!  If max and min values are not equal, pack up field.
!  If they are equal, we have a constant field, and the reference
!  value (rmin) is the value for each point in the field and
!  set nbits to 0.
!
      if (rmin.ne.rmax .AND. maxdif.ne.0) then
        !
        !  Determine which algorithm to use based on user-supplied 
        !  binary scale factor and number of bits.
        !
        if (idrstmpl(2).eq.0) then
           !
           !  No binary scaling and calculate minimum number of 
           !  bits in which the data will fit.
           !
           imin=nint(rmin*dscale)
           imax=nint(rmax*dscale)
           maxdif=imax-imin
           temp=alog(real(maxdif+1))/alog(2.0)
           nbits=ceiling(temp)
           rmin=real(imin)
           !   scale data
           do j=1,ndpts
             ifld(j)=nint(fld(j)*dscale)-imin
           enddo
        else
           !
           !  Use binary scaling factor and calculate minimum number of 
           !  bits in which the data will fit.
           !
           rmin=rmin*dscale
           rmax=rmax*dscale
           maxdif=nint((rmax-rmin)*bscale)
           temp=alog(real(maxdif+1))/alog(2.0)
           nbits=ceiling(temp)
           !   scale data
           do j=1,ndpts
             ifld(j)=nint(((fld(j)*dscale)-rmin)*bscale)
           enddo
        endif
        !
        !  Pack data into full octets, then do JPEG2000 encode.
        !  and calculate the length of the packed data in bytes
        !
        retry=0
        nbytes=(nbits+7)/8
        nsize=lcpack      ! needed for input to enc_jpeg2000
        allocate(ctemp(nbytes*ndpts))
        call sbytes(ctemp,ifld,0,nbytes*8,0,ndpts)
        lcpack=enc_jpeg2000(ctemp,width,height,nbits,idrstmpl(6), &
     &                      idrstmpl(7),retry,cpack,nsize)
        if (lcpack.le.0) then
           print *,'jpcpack: ERROR Packing JPC=',lcpack
           if (lcpack.eq.-3) then
              retry=1
              print *,'jpcpack: Retrying....'
              lcpack=enc_jpeg2000(ctemp,width,height,nbits, & 
     &             idrstmpl(6),idrstmpl(7),retry,cpack,nsize)
              if (lcpack.le.0) then
                 print *,'jpcpack: Retry Failed.'
              else
                 print *,'jpcpack: Retry Successful.'
              endif
           endif
        endif
        deallocate(ctemp)

      else
        nbits=0
        lcpack=0
      endif

!
!  Fill in ref value and number of bits in Template 5.0
!
      rmin4 = rmin
      call mkieee(rmin4,ref,1)   ! ensure reference value is IEEE format
!      call gbyte(ref,idrstmpl(1),0,32)
      iref=transfer(ref,iref)
      idrstmpl(1)=iref
      idrstmpl(4)=nbits
      idrstmpl(5)=0         ! original data were reals
      if (idrstmpl(6).eq.0) idrstmpl(7)=255       ! lossy not used

      return
      end
