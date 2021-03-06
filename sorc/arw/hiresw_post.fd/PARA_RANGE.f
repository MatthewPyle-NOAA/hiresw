      SUBROUTINE PARA_RANGE (N1,N2,NPROCS,IRANK,ISTA,IEND)
!$$$  SUBPROGRAM DOCUMENTATION BLOCK
!                .      .    .
! SUBPROGRAM:    PARA_RANGE  SET UP DECOMPOSITION VALUES
!   PRGRMMR: TUCCILLO        ORG: IBM
!
! ABSTRACT:
!     SETS UP DECOMOSITION VALUES
!   .
!
! PROGRAM HISTORY LOG:
!   00-01-06  TUCCILLO - ORIGINAL
!
! USAGE:    CALL COLLECT(A)
!   INPUT ARGUMENT LIST:
!     N1 - FIRST INTERATE VALUE
!     N2 - LAST INTERATE VALUE
!     NPROCS - NUMBER OF MPI TASKS
!     IRANK - MY TAKS ID
!
!   OUTPUT ARGUMENT LIST:
!     ISTA - FIRST LOOP VALUE
!     IEND - LAST LOOP VALUE
!
!   OUTPUT FILES:
!     STDOUT  - RUN TIME STANDARD OUT.
!
!   SUBPROGRAMS CALLED:
!     UTILITIES:
!       NONE
!     LIBRARY:
!
!   ATTRIBUTES:
!     LANGUAGE: FORTRAN
!     MACHINE : IBM RS/6000 SP
!$$$
      implicit none
      integer,intent(in) ::  n1,n2,nprocs,irank
      integer,intent(out) ::  ista,iend
      integer iwork1, iwork2
      iwork1 = ( n2 - n1 + 1 ) / nprocs
      iwork2 = mod ( n2 - n1 + 1, nprocs )
      ista = irank * iwork1 + n1 + min ( irank, iwork2 )
      iend = ista + iwork1 - 1
      if ( iwork2 .gt. irank ) iend = iend + 1
      end

      SUBROUTINE PARA_RANGE_OFFSET (N1,N2,OFFSET,NPROCS,IRANK,ISTA,IEND)
!$$$  SUBPROGRAM DOCUMENTATION BLOCK
!                .      .    .
! SUBPROGRAM:    PARA_RANGE  SET UP DECOMPOSITION VALUES
!   PRGRMMR: TUCCILLO        ORG: IBM
!
! ABSTRACT:
!     SETS UP DECOMOSITION VALUES
!   .
!
! PROGRAM HISTORY LOG:
!   00-01-06  TUCCILLO - ORIGINAL
!
! USAGE:    CALL COLLECT(A)
!   INPUT ARGUMENT LIST:
!     N1 - FIRST INTERATE VALUE
!     N2 - LAST INTERATE VALUE
!     NPROCS - NUMBER OF MPI TASKS
!     IRANK - MY TAKS ID
!
!   OUTPUT ARGUMENT LIST:
!     ISTA - FIRST LOOP VALUE
!     IEND - LAST LOOP VALUE
!
!   OUTPUT FILES:
!     STDOUT  - RUN TIME STANDARD OUT.
!
!   SUBPROGRAMS CALLED:
!     UTILITIES:
!       NONE
!     LIBRARY:
!
!   ATTRIBUTES:
!     LANGUAGE: FORTRAN
!     MACHINE : IBM RS/6000 SP
!$$$
      implicit none
      integer,intent(in) ::  n1,n2,nprocs,irank,OFFSET
      integer,intent(out) ::  ista,iend
      integer iwork1, iwork2
      iwork1 = ( n2 - n1 + 1 ) / nprocs
      iwork2 = mod ( n2 - n1 + 1, nprocs )
      ista = irank * iwork1 + n1 + min ( irank, iwork2 )
      iend = ista + iwork1 - 1
      if ( iwork2 .gt. irank ) iend = iend + 1

!	write(0,*) 'irank, nprocs: ', irank, nprocs

	if (irank .gt. 0 .and. irank .lt. nprocs-1) then
           ista=ista-OFFSET
           iend=iend+OFFSET
        else if (irank .eq. (nprocs-1)) then
!	write(0,*) 'in irank equals nprocs block'
           ista=ista-OFFSET
        else if (irank .eq. 0) then
           iend=iend+OFFSET
	endif

      
      end
