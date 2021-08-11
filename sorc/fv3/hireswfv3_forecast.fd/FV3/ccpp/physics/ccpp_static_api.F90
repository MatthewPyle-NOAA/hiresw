
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
!! @brief Auto-generated API for the CCPP static build
!!
!
module ccpp_static_api

   use ccpp_FV3_GFS_2017_gfdlmp_regional_cap, only: FV3_GFS_2017_gfdlmp_regional_init_cap
   use ccpp_FV3_GFS_2017_gfdlmp_regional_cap, only: FV3_GFS_2017_gfdlmp_regional_run_cap
   use ccpp_FV3_GFS_2017_gfdlmp_regional_cap, only: FV3_GFS_2017_gfdlmp_regional_finalize_cap
   use ccpp_FV3_GFS_2017_gfdlmp_regional_fast_physics_cap, only: FV3_GFS_2017_gfdlmp_regional_fast_physics_init_cap
   use ccpp_FV3_GFS_2017_gfdlmp_regional_fast_physics_cap, only: FV3_GFS_2017_gfdlmp_regional_fast_physics_run_cap
   use ccpp_FV3_GFS_2017_gfdlmp_regional_fast_physics_cap, only: FV3_GFS_2017_gfdlmp_regional_fast_physics_finalize_cap
   use ccpp_FV3_GFS_2017_gfdlmp_regional_time_vary_cap, only: FV3_GFS_2017_gfdlmp_regional_time_vary_init_cap
   use ccpp_FV3_GFS_2017_gfdlmp_regional_time_vary_cap, only: FV3_GFS_2017_gfdlmp_regional_time_vary_run_cap
   use ccpp_FV3_GFS_2017_gfdlmp_regional_time_vary_cap, only: FV3_GFS_2017_gfdlmp_regional_time_vary_finalize_cap
   use ccpp_FV3_GFS_2017_gfdlmp_regional_radiation_cap, only: FV3_GFS_2017_gfdlmp_regional_radiation_init_cap
   use ccpp_FV3_GFS_2017_gfdlmp_regional_radiation_cap, only: FV3_GFS_2017_gfdlmp_regional_radiation_run_cap
   use ccpp_FV3_GFS_2017_gfdlmp_regional_radiation_cap, only: FV3_GFS_2017_gfdlmp_regional_radiation_finalize_cap
   use ccpp_FV3_GFS_2017_gfdlmp_regional_physics_cap, only: FV3_GFS_2017_gfdlmp_regional_physics_init_cap
   use ccpp_FV3_GFS_2017_gfdlmp_regional_physics_cap, only: FV3_GFS_2017_gfdlmp_regional_physics_run_cap
   use ccpp_FV3_GFS_2017_gfdlmp_regional_physics_cap, only: FV3_GFS_2017_gfdlmp_regional_physics_finalize_cap
   use ccpp_FV3_GFS_2017_gfdlmp_regional_stochastics_cap, only: FV3_GFS_2017_gfdlmp_regional_stochastics_init_cap
   use ccpp_FV3_GFS_2017_gfdlmp_regional_stochastics_cap, only: FV3_GFS_2017_gfdlmp_regional_stochastics_run_cap
   use ccpp_FV3_GFS_2017_gfdlmp_regional_stochastics_cap, only: FV3_GFS_2017_gfdlmp_regional_stochastics_finalize_cap
   use ccpp_FV3_GFS_2017_gfdlmp_regional_c768_cap, only: FV3_GFS_2017_gfdlmp_regional_c768_init_cap
   use ccpp_FV3_GFS_2017_gfdlmp_regional_c768_cap, only: FV3_GFS_2017_gfdlmp_regional_c768_run_cap
   use ccpp_FV3_GFS_2017_gfdlmp_regional_c768_cap, only: FV3_GFS_2017_gfdlmp_regional_c768_finalize_cap
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
   use CCPP_data, only: GFS_Data
   use CCPP_data, only: GFS_Control
   use CCPP_data, only: CCPP_interstitial
   use GFS_typedefs, only: con_p0
   use CCPP_data, only: GFS_Interstitial
   use GFS_typedefs, only: con_t0c
   use GFS_typedefs, only: con_rd
   use GFS_typedefs, only: LTP
   use GFS_typedefs, only: rlapse
   use GFS_typedefs, only: con_hvap
   use GFS_typedefs, only: con_eps
   use GFS_typedefs, only: con_g
   use GFS_typedefs, only: con_pi
   use GFS_typedefs, only: cimin
   use GFS_typedefs, only: con_epsm1
   use GFS_typedefs, only: huge
   use GFS_typedefs, only: con_hfus
   use GFS_typedefs, only: con_cp
   use GFS_typedefs, only: con_rocp
   use GFS_typedefs, only: con_tice
   use GFS_typedefs, only: con_rog
   use GFS_typedefs, only: con_rv
   use GFS_typedefs, only: con_jcal
   use GFS_typedefs, only: con_fvirt
   use GFS_typedefs, only: con_sbc
   use GFS_typedefs, only: con_rhw0

   implicit none

   private
   public :: ccpp_physics_init,ccpp_physics_run,ccpp_physics_finalize

   contains

   subroutine ccpp_physics_init(cdata, suite_name, group_name, ierr)

      use ccpp_types, only : ccpp_t

      implicit none

      type(ccpp_t),               intent(inout) :: cdata
      character(len=*),           intent(in)    :: suite_name
      character(len=*), optional, intent(in)    :: group_name
      integer,                    intent(out)   :: ierr

      ierr = 0


      if (trim(suite_name)=="FV3_GFS_2017_gfdlmp_regional") then

         if (present(group_name)) then

            if (trim(group_name)=="fast_physics") then
               ierr = FV3_GFS_2017_gfdlmp_regional_fast_physics_init_cap(cdata=cdata,CCPP_interstitial=CCPP_interstitial)
            else if (trim(group_name)=="time_vary") then
               ierr = FV3_GFS_2017_gfdlmp_regional_time_vary_init_cap(GFS_Interstitial=GFS_Interstitial,cdata=cdata,GFS_Data=GFS_Data,GFS_Control=GFS_Control)
            else if (trim(group_name)=="radiation") then
               ierr = FV3_GFS_2017_gfdlmp_regional_radiation_init_cap()
            else if (trim(group_name)=="physics") then
               ierr = FV3_GFS_2017_gfdlmp_regional_physics_init_cap(con_p0=con_p0,cdata=cdata,GFS_Control=GFS_Control)
            else if (trim(group_name)=="stochastics") then
               ierr = FV3_GFS_2017_gfdlmp_regional_stochastics_init_cap()
            else
               write(cdata%errmsg, '(*(a))') 'Group ' // trim(group_name) // ' not found'
               ierr = 1
            end if

         else

           ierr = FV3_GFS_2017_gfdlmp_regional_init_cap(GFS_Data=GFS_Data,GFS_Control=GFS_Control,CCPP_interstitial=CCPP_interstitial, &
                  con_p0=con_p0,GFS_Interstitial=GFS_Interstitial,cdata=cdata)

         end if

      else if (trim(suite_name)=="FV3_GFS_2017_gfdlmp_regional_c768") then

         if (present(group_name)) then

            if (trim(group_name)=="fast_physics") then
               ierr = FV3_GFS_2017_gfdlmp_regional_c768_fast_physics_init_cap(cdata=cdata,CCPP_interstitial=CCPP_interstitial)
            else if (trim(group_name)=="time_vary") then
               ierr = FV3_GFS_2017_gfdlmp_regional_c768_time_vary_init_cap(GFS_Interstitial=GFS_Interstitial,cdata=cdata,GFS_Data=GFS_Data,GFS_Control=GFS_Control)
            else if (trim(group_name)=="radiation") then
               ierr = FV3_GFS_2017_gfdlmp_regional_c768_radiation_init_cap()
            else if (trim(group_name)=="physics") then
               ierr = FV3_GFS_2017_gfdlmp_regional_c768_physics_init_cap(con_p0=con_p0,cdata=cdata,GFS_Control=GFS_Control)
            else if (trim(group_name)=="stochastics") then
               ierr = FV3_GFS_2017_gfdlmp_regional_c768_stochastics_init_cap()
            else
               write(cdata%errmsg, '(*(a))') 'Group ' // trim(group_name) // ' not found'
               ierr = 1
            end if

         else

           ierr = FV3_GFS_2017_gfdlmp_regional_c768_init_cap(GFS_Data=GFS_Data,GFS_Control=GFS_Control,CCPP_interstitial=CCPP_interstitial, &
                  con_p0=con_p0,GFS_Interstitial=GFS_Interstitial,cdata=cdata)

         end if

      else

         write(cdata%errmsg,'(*(a))') 'Invalid suite ' // trim(suite_name)
         ierr = 1

      end if

      cdata%errflg = ierr

   end subroutine ccpp_physics_init

   subroutine ccpp_physics_run(cdata, suite_name, group_name, ierr)

      use ccpp_types, only : ccpp_t

      implicit none

      type(ccpp_t),               intent(inout) :: cdata
      character(len=*),           intent(in)    :: suite_name
      character(len=*), optional, intent(in)    :: group_name
      integer,                    intent(out)   :: ierr

      ierr = 0


      if (trim(suite_name)=="FV3_GFS_2017_gfdlmp_regional") then

         if (present(group_name)) then

            if (trim(group_name)=="fast_physics") then
               ierr = FV3_GFS_2017_gfdlmp_regional_fast_physics_run_cap(cdata=cdata,CCPP_interstitial=CCPP_interstitial)
            else if (trim(group_name)=="time_vary") then
               ierr = FV3_GFS_2017_gfdlmp_regional_time_vary_run_cap(cdata=cdata,GFS_Data=GFS_Data,GFS_Control=GFS_Control)
            else if (trim(group_name)=="radiation") then
               ierr = FV3_GFS_2017_gfdlmp_regional_radiation_run_cap(GFS_Data=GFS_Data,GFS_Control=GFS_Control,con_epsm1=con_epsm1,con_rog=con_rog, &
                  GFS_Interstitial=GFS_Interstitial,con_rd=con_rd,LTP=LTP,con_rocp=con_rocp, &
                  con_eps=con_eps,cdata=cdata,con_fvirt=con_fvirt)
            else if (trim(group_name)=="physics") then
               ierr = FV3_GFS_2017_gfdlmp_regional_physics_run_cap(con_t0c=con_t0c,con_rd=con_rd,rlapse=rlapse,con_hvap=con_hvap,con_eps=con_eps, &
                  GFS_Control=GFS_Control,con_g=con_g,con_pi=con_pi,con_sbc=con_sbc,con_epsm1=con_epsm1, &
                  huge=huge,GFS_Interstitial=GFS_Interstitial,con_hfus=con_hfus,con_cp=con_cp, &
                  cdata=cdata,cimin=cimin,GFS_Data=GFS_Data,con_rv=con_rv,con_jcal=con_jcal, &
                  con_fvirt=con_fvirt,con_tice=con_tice,con_rhw0=con_rhw0)
            else if (trim(group_name)=="stochastics") then
               ierr = FV3_GFS_2017_gfdlmp_regional_stochastics_run_cap(cdata=cdata,GFS_Data=GFS_Data,GFS_Control=GFS_Control)
            else
               write(cdata%errmsg, '(*(a))') 'Group ' // trim(group_name) // ' not found'
               ierr = 1
            end if

         else

           ierr = FV3_GFS_2017_gfdlmp_regional_run_cap(con_t0c=con_t0c,con_rd=con_rd,LTP=LTP,rlapse=rlapse,con_hvap=con_hvap,con_eps=con_eps, &
                  GFS_Data=GFS_Data,con_g=con_g,con_pi=con_pi,cimin=cimin,con_epsm1=con_epsm1, &
                  huge=huge,GFS_Interstitial=GFS_Interstitial,con_hfus=con_hfus,con_cp=con_cp, &
                  con_rocp=con_rocp,cdata=cdata,con_tice=con_tice,GFS_Control=GFS_Control, &
                  CCPP_interstitial=CCPP_interstitial,con_rog=con_rog,con_rv=con_rv,con_jcal=con_jcal, &
                  con_fvirt=con_fvirt,con_sbc=con_sbc,con_rhw0=con_rhw0)

         end if

      else if (trim(suite_name)=="FV3_GFS_2017_gfdlmp_regional_c768") then

         if (present(group_name)) then

            if (trim(group_name)=="fast_physics") then
               ierr = FV3_GFS_2017_gfdlmp_regional_c768_fast_physics_run_cap(cdata=cdata,CCPP_interstitial=CCPP_interstitial)
            else if (trim(group_name)=="time_vary") then
               ierr = FV3_GFS_2017_gfdlmp_regional_c768_time_vary_run_cap(cdata=cdata,GFS_Data=GFS_Data,GFS_Control=GFS_Control)
            else if (trim(group_name)=="radiation") then
               ierr = FV3_GFS_2017_gfdlmp_regional_c768_radiation_run_cap(GFS_Data=GFS_Data,GFS_Control=GFS_Control,con_epsm1=con_epsm1,con_rog=con_rog, &
                  GFS_Interstitial=GFS_Interstitial,con_rd=con_rd,LTP=LTP,con_rocp=con_rocp, &
                  con_eps=con_eps,cdata=cdata,con_fvirt=con_fvirt)
            else if (trim(group_name)=="physics") then
               ierr = FV3_GFS_2017_gfdlmp_regional_c768_physics_run_cap(con_t0c=con_t0c,con_rd=con_rd,rlapse=rlapse,con_hvap=con_hvap,con_eps=con_eps, &
                  GFS_Control=GFS_Control,con_g=con_g,con_pi=con_pi,con_sbc=con_sbc,con_epsm1=con_epsm1, &
                  huge=huge,GFS_Interstitial=GFS_Interstitial,con_hfus=con_hfus,con_cp=con_cp, &
                  cdata=cdata,cimin=cimin,GFS_Data=GFS_Data,con_rv=con_rv,con_jcal=con_jcal, &
                  con_fvirt=con_fvirt,con_tice=con_tice,con_rhw0=con_rhw0)
            else if (trim(group_name)=="stochastics") then
               ierr = FV3_GFS_2017_gfdlmp_regional_c768_stochastics_run_cap(cdata=cdata,GFS_Data=GFS_Data,GFS_Control=GFS_Control)
            else
               write(cdata%errmsg, '(*(a))') 'Group ' // trim(group_name) // ' not found'
               ierr = 1
            end if

         else

           ierr = FV3_GFS_2017_gfdlmp_regional_c768_run_cap(con_t0c=con_t0c,con_rd=con_rd,LTP=LTP,rlapse=rlapse,con_hvap=con_hvap,con_eps=con_eps, &
                  GFS_Data=GFS_Data,con_g=con_g,con_pi=con_pi,cimin=cimin,con_epsm1=con_epsm1, &
                  huge=huge,GFS_Interstitial=GFS_Interstitial,con_hfus=con_hfus,con_cp=con_cp, &
                  con_rocp=con_rocp,cdata=cdata,con_tice=con_tice,GFS_Control=GFS_Control, &
                  CCPP_interstitial=CCPP_interstitial,con_rog=con_rog,con_rv=con_rv,con_jcal=con_jcal, &
                  con_fvirt=con_fvirt,con_sbc=con_sbc,con_rhw0=con_rhw0)

         end if

      else

         write(cdata%errmsg,'(*(a))') 'Invalid suite ' // trim(suite_name)
         ierr = 1

      end if

      cdata%errflg = ierr

   end subroutine ccpp_physics_run

   subroutine ccpp_physics_finalize(cdata, suite_name, group_name, ierr)

      use ccpp_types, only : ccpp_t

      implicit none

      type(ccpp_t),               intent(inout) :: cdata
      character(len=*),           intent(in)    :: suite_name
      character(len=*), optional, intent(in)    :: group_name
      integer,                    intent(out)   :: ierr

      ierr = 0


      if (trim(suite_name)=="FV3_GFS_2017_gfdlmp_regional") then

         if (present(group_name)) then

            if (trim(group_name)=="fast_physics") then
               ierr = FV3_GFS_2017_gfdlmp_regional_fast_physics_finalize_cap(cdata=cdata)
            else if (trim(group_name)=="time_vary") then
               ierr = FV3_GFS_2017_gfdlmp_regional_time_vary_finalize_cap(cdata=cdata)
            else if (trim(group_name)=="radiation") then
               ierr = FV3_GFS_2017_gfdlmp_regional_radiation_finalize_cap()
            else if (trim(group_name)=="physics") then
               ierr = FV3_GFS_2017_gfdlmp_regional_physics_finalize_cap(cdata=cdata)
            else if (trim(group_name)=="stochastics") then
               ierr = FV3_GFS_2017_gfdlmp_regional_stochastics_finalize_cap()
            else
               write(cdata%errmsg, '(*(a))') 'Group ' // trim(group_name) // ' not found'
               ierr = 1
            end if

         else

           ierr = FV3_GFS_2017_gfdlmp_regional_finalize_cap(cdata=cdata)

         end if

      else if (trim(suite_name)=="FV3_GFS_2017_gfdlmp_regional_c768") then

         if (present(group_name)) then

            if (trim(group_name)=="fast_physics") then
               ierr = FV3_GFS_2017_gfdlmp_regional_c768_fast_physics_finalize_cap(cdata=cdata)
            else if (trim(group_name)=="time_vary") then
               ierr = FV3_GFS_2017_gfdlmp_regional_c768_time_vary_finalize_cap(cdata=cdata)
            else if (trim(group_name)=="radiation") then
               ierr = FV3_GFS_2017_gfdlmp_regional_c768_radiation_finalize_cap()
            else if (trim(group_name)=="physics") then
               ierr = FV3_GFS_2017_gfdlmp_regional_c768_physics_finalize_cap(cdata=cdata)
            else if (trim(group_name)=="stochastics") then
               ierr = FV3_GFS_2017_gfdlmp_regional_c768_stochastics_finalize_cap()
            else
               write(cdata%errmsg, '(*(a))') 'Group ' // trim(group_name) // ' not found'
               ierr = 1
            end if

         else

           ierr = FV3_GFS_2017_gfdlmp_regional_c768_finalize_cap(cdata=cdata)

         end if

      else

         write(cdata%errmsg,'(*(a))') 'Invalid suite ' // trim(suite_name)
         ierr = 1

      end if

      cdata%errflg = ierr

   end subroutine ccpp_physics_finalize

end module ccpp_static_api
