
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
!! @brief Auto-generated cap module for the CCPP time_vary group
!!
!
module ccpp_FV3_GFS_2017_gfdlmp_regional_time_vary_cap

   use GFS_time_vary_pre, only: GFS_time_vary_pre_init
   use GFS_rrtmg_setup, only: GFS_rrtmg_setup_init
   use GFS_phys_time_vary, only: GFS_phys_time_vary_init
   use GFS_time_vary_pre, only: GFS_time_vary_pre_run
   use GFS_rrtmg_setup, only: GFS_rrtmg_setup_run
   use GFS_rad_time_vary, only: GFS_rad_time_vary_run
   use GFS_phys_time_vary, only: GFS_phys_time_vary_run
   use GFS_time_vary_pre, only: GFS_time_vary_pre_finalize
   use GFS_rrtmg_setup, only: GFS_rrtmg_setup_finalize
   use GFS_phys_time_vary, only: GFS_phys_time_vary_finalize


   implicit none

   private
   public :: FV3_GFS_2017_gfdlmp_regional_time_vary_init_cap, &
             FV3_GFS_2017_gfdlmp_regional_time_vary_run_cap, &
             FV3_GFS_2017_gfdlmp_regional_time_vary_finalize_cap

   logical, save :: initialized = .false.

   contains

   function FV3_GFS_2017_gfdlmp_regional_time_vary_init_cap(GFS_Interstitial,cdata,GFS_Data,GFS_Control) result(ierr)

      use GFS_typedefs, only: GFS_interstitial_type
      use ccpp_types, only: ccpp_t
      use GFS_typedefs, only: GFS_data_type
      use GFS_typedefs, only: GFS_control_type

      implicit none

      ! Error handling
      integer :: ierr

      type(GFS_interstitial_type), intent(inout) :: GFS_Interstitial(:)
      type(ccpp_t), intent(inout) :: cdata
      type(GFS_data_type), intent(inout) :: GFS_Data(:)
      type(GFS_control_type), intent(inout) :: GFS_Control

      ierr = 0


      if (initialized) return



      


      call GFS_time_vary_pre_init(errmsg=cdata%errmsg,errflg=cdata%errflg)



      if (cdata%errflg/=0) then
        cdata%errmsg = "An error occured in GFS_time_vary_pre_init: " // trim(cdata%errmsg)
        ierr=cdata%errflg
        return
      end if

    
      


      call GFS_rrtmg_setup_init(si=GFS_Control%si,levr=GFS_Control%levr,ictm=GFS_Control%ictm,isol=GFS_Control%isol, &
                  ico2=GFS_Control%ico2,iaer=GFS_Control%iaer,ialb=GFS_Control%ialb,iems=GFS_Control%iems, &
                  ntcw=GFS_Control%ntcw,num_p2d=GFS_Control%num_p2d,num_p3d=GFS_Control%num_p3d, &
                  npdf3d=GFS_Control%npdf3d,ntoz=GFS_Control%ntoz,iovr_sw=GFS_Control%iovr_sw, &
                  iovr_lw=GFS_Control%iovr_lw,isubc_sw=GFS_Control%isubc_sw,isubc_lw=GFS_Control%isubc_lw, &
                  icliq_sw=GFS_Control%icliq_sw,crick_proof=GFS_Control%crick_proof,ccnorm=GFS_Control%ccnorm, &
                  imp_physics=GFS_Control%imp_physics,norad_precip=GFS_Control%norad_precip, &
                  idate=GFS_Control%idate,iflip=GFS_Control%iflip,im=GFS_Control%ncols,faerlw=GFS_Interstitial(cdata%thrd_no)%faerlw, &
                  faersw=GFS_Interstitial(cdata%thrd_no)%faersw,aerodp=GFS_Interstitial(cdata%thrd_no)%aerodp, &
                  me=GFS_Control%me,errmsg=cdata%errmsg,errflg=cdata%errflg)



      if (cdata%errflg/=0) then
        cdata%errmsg = "An error occured in GFS_rrtmg_setup_init: " // trim(cdata%errmsg)
        ierr=cdata%errflg
        return
      end if

    
      


      call GFS_phys_time_vary_init(Data=GFS_Data,Model=GFS_Control,Interstitial=GFS_Interstitial,nthrds=GFS_Control%nthreads, &
                  errmsg=cdata%errmsg,errflg=cdata%errflg)



      if (cdata%errflg/=0) then
        cdata%errmsg = "An error occured in GFS_phys_time_vary_init: " // trim(cdata%errmsg)
        ierr=cdata%errflg
        return
      end if

    


      initialized = .true.


   end function FV3_GFS_2017_gfdlmp_regional_time_vary_init_cap

   function FV3_GFS_2017_gfdlmp_regional_time_vary_run_cap(cdata,GFS_Data,GFS_Control) result(ierr)

      use ccpp_types, only: ccpp_t
      use GFS_typedefs, only: GFS_data_type
      use GFS_typedefs, only: GFS_control_type

      implicit none

      ! Error handling
      integer :: ierr

      type(ccpp_t), intent(inout) :: cdata
      type(GFS_data_type), intent(inout) :: GFS_Data(:)
      type(GFS_control_type), intent(inout) :: GFS_Control

      ierr = 0


      if (.not.initialized) then
        write(cdata%errmsg,'(*(a))') 'time_vary_run called before time_vary_init'
        cdata%errflg = 1
        return
      end if



      


      call GFS_time_vary_pre_run(jdat=GFS_Control%jdat,idat=GFS_Control%idat,dtp=GFS_Control%dtp,lkm=GFS_Control%lkm, &
                  lsm=GFS_Control%lsm,lsm_noahmp=GFS_Control%lsm_noahmp,nsswr=GFS_Control%nsswr, &
                  nslwr=GFS_Control%nslwr,nhfrad=GFS_Control%nhfrad,idate=GFS_Control%idate, &
                  debug=GFS_Control%debug,me=GFS_Control%me,master=GFS_Control%master,nscyc=GFS_Control%nscyc, &
                  sec=GFS_Control%sec,phour=GFS_Control%phour,zhour=GFS_Control%zhour,fhour=GFS_Control%fhour, &
                  kdt=GFS_Control%kdt,julian=GFS_Control%julian,yearlen=GFS_Control%yearlen, &
                  ipt=GFS_Control%ipt,lprnt=GFS_Control%lprnt,lssav=GFS_Control%lssav,lsswr=GFS_Control%lsswr, &
                  lslwr=GFS_Control%lslwr,solhr=GFS_Control%solhr,errmsg=cdata%errmsg,errflg=cdata%errflg)



      if (cdata%errflg/=0) then
        cdata%errmsg = "An error occured in GFS_time_vary_pre_run: " // trim(cdata%errmsg)
        ierr=cdata%errflg
        return
      end if

    
      


      call GFS_rrtmg_setup_run(idate=GFS_Control%idat,jdate=GFS_Control%jdat,deltsw=GFS_Control%fhswr, &
                  deltim=GFS_Control%dtf,lsswr=GFS_Control%lsswr,me=GFS_Control%me,slag=GFS_Control%slag, &
                  sdec=GFS_Control%sdec,cdec=GFS_Control%cdec,solcon=GFS_Control%solcon,errmsg=cdata%errmsg, &
                  errflg=cdata%errflg)



      if (cdata%errflg/=0) then
        cdata%errmsg = "An error occured in GFS_rrtmg_setup_run: " // trim(cdata%errmsg)
        ierr=cdata%errflg
        return
      end if

    
      


      call GFS_rad_time_vary_run(Model=GFS_Control,Data=GFS_Data,nthrds=GFS_Control%nthreads,errmsg=cdata%errmsg, &
                  errflg=cdata%errflg)



      if (cdata%errflg/=0) then
        cdata%errmsg = "An error occured in GFS_rad_time_vary_run: " // trim(cdata%errmsg)
        ierr=cdata%errflg
        return
      end if

    
      


      call GFS_phys_time_vary_run(Data=GFS_Data,Model=GFS_Control,nthrds=GFS_Control%nthreads,first_time_step=GFS_Control%first_time_step, &
                  errmsg=cdata%errmsg,errflg=cdata%errflg)



      if (cdata%errflg/=0) then
        cdata%errmsg = "An error occured in GFS_phys_time_vary_run: " // trim(cdata%errmsg)
        ierr=cdata%errflg
        return
      end if

    



   end function FV3_GFS_2017_gfdlmp_regional_time_vary_run_cap

   function FV3_GFS_2017_gfdlmp_regional_time_vary_finalize_cap(cdata) result(ierr)

      use ccpp_types, only: ccpp_t

      implicit none

      ! Error handling
      integer :: ierr

      type(ccpp_t), intent(inout) :: cdata

      ierr = 0


      if (.not.initialized) return



      


      call GFS_time_vary_pre_finalize(errmsg=cdata%errmsg,errflg=cdata%errflg)



      if (cdata%errflg/=0) then
        cdata%errmsg = "An error occured in GFS_time_vary_pre_finalize: " // trim(cdata%errmsg)
        ierr=cdata%errflg
        return
      end if

    
      


      call GFS_rrtmg_setup_finalize(errmsg=cdata%errmsg,errflg=cdata%errflg)



      if (cdata%errflg/=0) then
        cdata%errmsg = "An error occured in GFS_rrtmg_setup_finalize: " // trim(cdata%errmsg)
        ierr=cdata%errflg
        return
      end if

    
      


      call GFS_phys_time_vary_finalize(errmsg=cdata%errmsg,errflg=cdata%errflg)



      if (cdata%errflg/=0) then
        cdata%errmsg = "An error occured in GFS_phys_time_vary_finalize: " // trim(cdata%errmsg)
        ierr=cdata%errflg
        return
      end if

    


      initialized = .false.


   end function FV3_GFS_2017_gfdlmp_regional_time_vary_finalize_cap

end module ccpp_FV3_GFS_2017_gfdlmp_regional_time_vary_cap
