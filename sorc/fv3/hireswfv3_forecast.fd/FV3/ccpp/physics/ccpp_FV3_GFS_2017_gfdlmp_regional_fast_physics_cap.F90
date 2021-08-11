
!
! This work (Common Community Physics Package), identified by NOAA, NCAR,
! CU/CIRES, is free of known copyright restrictions and is placed in the
! public domain.
!
! THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
! IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
! FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL
! THE AUTHORS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER
! IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
! CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
!

!>
!! @brief Auto-generated cap module for the CCPP fast_physics group
!!
!
module ccpp_FV3_GFS_2017_gfdlmp_regional_fast_physics_cap

   use fv_sat_adj, only: fv_sat_adj_init
   use fv_sat_adj, only: fv_sat_adj_run
   use fv_sat_adj, only: fv_sat_adj_finalize


   implicit none

   private
   public :: FV3_GFS_2017_gfdlmp_regional_fast_physics_init_cap, &
             FV3_GFS_2017_gfdlmp_regional_fast_physics_run_cap, &
             FV3_GFS_2017_gfdlmp_regional_fast_physics_finalize_cap

   logical, save :: initialized = .false.

   contains

   function FV3_GFS_2017_gfdlmp_regional_fast_physics_init_cap(cdata,CCPP_interstitial) result(ierr)

      use ccpp_types, only: ccpp_t
      use CCPP_typedefs, only: CCPP_interstitial_type

      implicit none

      ! Error handling
      integer :: ierr

      type(ccpp_t), intent(inout) :: cdata
      type(CCPP_interstitial_type), intent(in) :: CCPP_interstitial

      ierr = 0


      if (initialized) return



      


      call fv_sat_adj_init(do_sat_adj=CCPP_interstitial%do_sat_adj,kmp=CCPP_interstitial%kmp,nwat=CCPP_interstitial%nwat, &
                  ngas=CCPP_interstitial%ngas,rilist=CCPP_interstitial%rilist,cpilist=CCPP_interstitial%cpilist, &
                  mpirank=CCPP_interstitial%mpirank,mpiroot=CCPP_interstitial%mpiroot,errmsg=cdata%errmsg, &
                  errflg=cdata%errflg)



      if (cdata%errflg/=0) then
        cdata%errmsg = "An error occured in fv_sat_adj_init: " // trim(cdata%errmsg)
        ierr=cdata%errflg
        return
      end if

    


      initialized = .true.


   end function FV3_GFS_2017_gfdlmp_regional_fast_physics_init_cap

   function FV3_GFS_2017_gfdlmp_regional_fast_physics_run_cap(cdata,CCPP_interstitial) result(ierr)

      use ccpp_types, only: ccpp_t
      use CCPP_typedefs, only: CCPP_interstitial_type

      implicit none

      ! Error handling
      integer :: ierr

      type(ccpp_t), intent(inout) :: cdata
      type(CCPP_interstitial_type), intent(inout) :: CCPP_interstitial

      ierr = 0


      if (.not.initialized) then
        write(cdata%errmsg,'(*(a))') 'fast_physics_run called before fast_physics_init'
        cdata%errflg = 1
        return
      end if



      


      call fv_sat_adj_run(mdt=CCPP_interstitial%mdt,zvir=CCPP_interstitial%zvir,is=CCPP_interstitial%is, &
                  ie=CCPP_interstitial%ie,isd=CCPP_interstitial%isd,ied=CCPP_interstitial%ied, &
                  kmp=CCPP_interstitial%kmp,km=CCPP_interstitial%npz,kmdelz=CCPP_interstitial%npzdelz, &
                  js=CCPP_interstitial%js,je=CCPP_interstitial%je,jsd=CCPP_interstitial%jsd, &
                  jed=CCPP_interstitial%jed,ng=CCPP_interstitial%ng,hydrostatic=CCPP_interstitial%hydrostatic, &
                  fast_mp_consv=CCPP_interstitial%fast_mp_consv,te0_2d=CCPP_interstitial%te0_2d, &
                  te0=CCPP_interstitial%te0,ngas=CCPP_interstitial%ngas,qvi=CCPP_interstitial%qvi, &
                  qv=CCPP_interstitial%qv,ql=CCPP_interstitial%ql,qi=CCPP_interstitial%qi, &
                  qr=CCPP_interstitial%qr,qs=CCPP_interstitial%qs,qg=CCPP_interstitial%qg, &
                  hs=CCPP_interstitial%phis,peln=CCPP_interstitial%peln,delz=CCPP_interstitial%delz, &
                  delp=CCPP_interstitial%delp,pt=CCPP_interstitial%pt,pkz=CCPP_interstitial%pkz, &
                  q_con=CCPP_interstitial%q_con,akap=CCPP_interstitial%akap,cappa=CCPP_interstitial%cappa, &
                  area=CCPP_interstitial%area,dtdt=CCPP_interstitial%dtdt,out_dt=CCPP_interstitial%out_dt, &
                  last_step=CCPP_interstitial%last_step,do_qa=CCPP_interstitial%do_qa,qa=CCPP_interstitial%qc, &
                  nthreads=CCPP_interstitial%nthreads,errmsg=cdata%errmsg,errflg=cdata%errflg)



      if (cdata%errflg/=0) then
        cdata%errmsg = "An error occured in fv_sat_adj_run: " // trim(cdata%errmsg)
        ierr=cdata%errflg
        return
      end if

    



   end function FV3_GFS_2017_gfdlmp_regional_fast_physics_run_cap

   function FV3_GFS_2017_gfdlmp_regional_fast_physics_finalize_cap(cdata) result(ierr)

      use ccpp_types, only: ccpp_t

      implicit none

      ! Error handling
      integer :: ierr

      type(ccpp_t), intent(inout) :: cdata

      ierr = 0


      if (.not.initialized) return



      


      call fv_sat_adj_finalize(errmsg=cdata%errmsg,errflg=cdata%errflg)



      if (cdata%errflg/=0) then
        cdata%errmsg = "An error occured in fv_sat_adj_finalize: " // trim(cdata%errmsg)
        ierr=cdata%errflg
        return
      end if

    


      initialized = .false.


   end function FV3_GFS_2017_gfdlmp_regional_fast_physics_finalize_cap

end module ccpp_FV3_GFS_2017_gfdlmp_regional_fast_physics_cap
