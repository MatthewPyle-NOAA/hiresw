
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
!! @brief Auto-generated cap module for the CCPP suite
!!
!
module ccpp_FV3_GFS_2017_gfdlmp_regional_c768_cap

   use ccpp_FV3_GFS_2017_gfdlmp_regional_c768_fast_physics_cap, only: FV3_GFS_2017_gfdlmp_regional_c768_fast_physics_init_cap
   use ccpp_FV3_GFS_2017_gfdlmp_regional_c768_fast_physics_cap, only: FV3_GFS_2017_gfdlmp_regional_c768_fast_physics_run_cap
   use ccpp_FV3_GFS_2017_gfdlmp_regional_c768_fast_physics_cap, only: FV3_GFS_2017_gfdlmp_regional_c768_fast_physics_finalize_cap
   use ccpp_FV3_GFS_2017_gfdlmp_regional_c768_time_vary_cap, only: FV3_GFS_2017_gfdlmp_regional_c768_time_vary_init_cap
   use ccpp_FV3_GFS_2017_gfdlmp_regional_c768_time_vary_cap, only: FV3_GFS_2017_gfdlmp_regional_c768_time_vary_run_cap
   use ccpp_FV3_GFS_2017_gfdlmp_regional_c768_time_vary_cap, only: FV3_GFS_2017_gfdlmp_regional_c768_time_vary_finalize_cap
   use ccpp_FV3_GFS_2017_gfdlmp_regional_c768_radiation_cap, only: FV3_GFS_2017_gfdlmp_regional_c768_radiation_init_cap
   use ccpp_FV3_GFS_2017_gfdlmp_regional_c768_radiation_cap, only: FV3_GFS_2017_gfdlmp_regional_c768_radiation_run_cap
   use ccpp_FV3_GFS_2017_gfdlmp_regional_c768_radiation_cap, only: FV3_GFS_2017_gfdlmp_regional_c768_radiation_finalize_cap
   use ccpp_FV3_GFS_2017_gfdlmp_regional_c768_physics_cap, only: FV3_GFS_2017_gfdlmp_regional_c768_physics_init_cap
   use ccpp_FV3_GFS_2017_gfdlmp_regional_c768_physics_cap, only: FV3_GFS_2017_gfdlmp_regional_c768_physics_run_cap
   use ccpp_FV3_GFS_2017_gfdlmp_regional_c768_physics_cap, only: FV3_GFS_2017_gfdlmp_regional_c768_physics_finalize_cap
   use ccpp_FV3_GFS_2017_gfdlmp_regional_c768_stochastics_cap, only: FV3_GFS_2017_gfdlmp_regional_c768_stochastics_init_cap
   use ccpp_FV3_GFS_2017_gfdlmp_regional_c768_stochastics_cap, only: FV3_GFS_2017_gfdlmp_regional_c768_stochastics_run_cap
   use ccpp_FV3_GFS_2017_gfdlmp_regional_c768_stochastics_cap, only: FV3_GFS_2017_gfdlmp_regional_c768_stochastics_finalize_cap


   implicit none

   private
   public :: FV3_GFS_2017_gfdlmp_regional_c768_init_cap, &
             FV3_GFS_2017_gfdlmp_regional_c768_run_cap, &
             FV3_GFS_2017_gfdlmp_regional_c768_finalize_cap

   contains

   function FV3_GFS_2017_gfdlmp_regional_c768_init_cap(GFS_Data,GFS_Control,CCPP_interstitial,con_p0,GFS_Interstitial,cdata) result(ierr)

      use GFS_typedefs, only: GFS_data_type
      use GFS_typedefs, only: GFS_control_type
      use CCPP_typedefs, only: CCPP_interstitial_type
      use machine, only: kind_phys
      use GFS_typedefs, only: GFS_interstitial_type
      use ccpp_types, only: ccpp_t

      implicit none

      integer :: ierr
      type(GFS_data_type), intent(inout) :: GFS_Data(:)
      type(GFS_control_type), intent(inout) :: GFS_Control
      type(CCPP_interstitial_type), intent(in) :: CCPP_interstitial
      real(kind_phys), intent(in) :: con_p0
      type(GFS_interstitial_type), intent(inout) :: GFS_Interstitial(:)
      type(ccpp_t), intent(inout) :: cdata

      ierr = 0


      ierr = FV3_GFS_2017_gfdlmp_regional_c768_fast_physics_init_cap(cdata=cdata,CCPP_interstitial=CCPP_interstitial)
      if (ierr/=0) return

      ierr = FV3_GFS_2017_gfdlmp_regional_c768_time_vary_init_cap(GFS_Interstitial=GFS_Interstitial,cdata=cdata,GFS_Data=GFS_Data,GFS_Control=GFS_Control)
      if (ierr/=0) return

      ierr = FV3_GFS_2017_gfdlmp_regional_c768_radiation_init_cap()
      if (ierr/=0) return

      ierr = FV3_GFS_2017_gfdlmp_regional_c768_physics_init_cap(con_p0=con_p0,cdata=cdata,GFS_Control=GFS_Control)
      if (ierr/=0) return

      ierr = FV3_GFS_2017_gfdlmp_regional_c768_stochastics_init_cap()
      if (ierr/=0) return


   end function FV3_GFS_2017_gfdlmp_regional_c768_init_cap

   function FV3_GFS_2017_gfdlmp_regional_c768_run_cap(con_t0c,con_rd,LTP,rlapse,con_hvap,con_eps,GFS_Data,con_g,con_pi,cimin, &
                  con_epsm1,huge,GFS_Interstitial,con_hfus,con_cp,con_rocp,cdata,con_tice, &
                  GFS_Control,CCPP_interstitial,con_rog,con_rv,con_jcal,con_fvirt,con_sbc, &
                  con_rhw0) result(ierr)

      use machine, only: kind_phys
      use GFS_typedefs, only: GFS_data_type
      use GFS_typedefs, only: GFS_interstitial_type
      use ccpp_types, only: ccpp_t
      use GFS_typedefs, only: GFS_control_type
      use CCPP_typedefs, only: CCPP_interstitial_type

      implicit none

      integer :: ierr
      real(kind_phys), intent(in) :: con_t0c
      real(kind_phys), intent(in) :: con_rd
      integer, intent(in) :: LTP
      real(kind_phys), intent(in) :: rlapse
      real(kind_phys), intent(in) :: con_hvap
      real(kind_phys), intent(in) :: con_eps
      type(GFS_data_type), intent(inout) :: GFS_Data(:)
      real(kind_phys), intent(in) :: con_g
      real(kind_phys), intent(in) :: con_pi
      real(kind_phys), intent(in) :: cimin
      real(kind_phys), intent(in) :: con_epsm1
      real(kind_phys), intent(in) :: huge
      type(GFS_interstitial_type), intent(inout) :: GFS_Interstitial(:)
      real(kind_phys), intent(in) :: con_hfus
      real(kind_phys), intent(in) :: con_cp
      real(kind_phys), intent(in) :: con_rocp
      type(ccpp_t), intent(inout) :: cdata
      real(kind_phys), intent(in) :: con_tice
      type(GFS_control_type), intent(inout) :: GFS_Control
      type(CCPP_interstitial_type), intent(inout) :: CCPP_interstitial
      real(kind_phys), intent(in) :: con_rog
      real(kind_phys), intent(in) :: con_rv
      real(kind_phys), intent(in) :: con_jcal
      real(kind_phys), intent(in) :: con_fvirt
      real(kind_phys), intent(in) :: con_sbc
      real(kind_phys), intent(in) :: con_rhw0

      ierr = 0


      ierr = FV3_GFS_2017_gfdlmp_regional_c768_fast_physics_run_cap(cdata=cdata,CCPP_interstitial=CCPP_interstitial)
      if (ierr/=0) return

      ierr = FV3_GFS_2017_gfdlmp_regional_c768_time_vary_run_cap(cdata=cdata,GFS_Data=GFS_Data,GFS_Control=GFS_Control)
      if (ierr/=0) return

      ierr = FV3_GFS_2017_gfdlmp_regional_c768_radiation_run_cap(GFS_Data=GFS_Data,GFS_Control=GFS_Control,con_epsm1=con_epsm1,con_rog=con_rog, &
                  GFS_Interstitial=GFS_Interstitial,con_rd=con_rd,LTP=LTP,con_rocp=con_rocp, &
                  con_eps=con_eps,cdata=cdata,con_fvirt=con_fvirt)
      if (ierr/=0) return

      ierr = FV3_GFS_2017_gfdlmp_regional_c768_physics_run_cap(con_t0c=con_t0c,con_rd=con_rd,rlapse=rlapse,con_hvap=con_hvap,con_eps=con_eps, &
                  GFS_Control=GFS_Control,con_g=con_g,con_pi=con_pi,con_sbc=con_sbc,con_epsm1=con_epsm1, &
                  huge=huge,GFS_Interstitial=GFS_Interstitial,con_hfus=con_hfus,con_cp=con_cp, &
                  cdata=cdata,cimin=cimin,GFS_Data=GFS_Data,con_rv=con_rv,con_jcal=con_jcal, &
                  con_fvirt=con_fvirt,con_tice=con_tice,con_rhw0=con_rhw0)
      if (ierr/=0) return

      ierr = FV3_GFS_2017_gfdlmp_regional_c768_stochastics_run_cap(cdata=cdata,GFS_Data=GFS_Data,GFS_Control=GFS_Control)
      if (ierr/=0) return


   end function FV3_GFS_2017_gfdlmp_regional_c768_run_cap

   function FV3_GFS_2017_gfdlmp_regional_c768_finalize_cap(cdata) result(ierr)

      use ccpp_types, only: ccpp_t

      implicit none

      integer :: ierr
      type(ccpp_t), intent(inout) :: cdata

      ierr = 0


      ierr = FV3_GFS_2017_gfdlmp_regional_c768_fast_physics_finalize_cap(cdata=cdata)
      if (ierr/=0) return

      ierr = FV3_GFS_2017_gfdlmp_regional_c768_time_vary_finalize_cap(cdata=cdata)
      if (ierr/=0) return

      ierr = FV3_GFS_2017_gfdlmp_regional_c768_radiation_finalize_cap()
      if (ierr/=0) return

      ierr = FV3_GFS_2017_gfdlmp_regional_c768_physics_finalize_cap(cdata=cdata)
      if (ierr/=0) return

      ierr = FV3_GFS_2017_gfdlmp_regional_c768_stochastics_finalize_cap()
      if (ierr/=0) return


   end function FV3_GFS_2017_gfdlmp_regional_c768_finalize_cap

end module ccpp_FV3_GFS_2017_gfdlmp_regional_c768_cap
