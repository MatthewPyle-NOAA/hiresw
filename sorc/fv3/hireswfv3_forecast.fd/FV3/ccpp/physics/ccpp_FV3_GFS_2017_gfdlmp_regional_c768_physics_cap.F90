
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
!! @brief Auto-generated cap module for the CCPP physics group
!!
!
module ccpp_FV3_GFS_2017_gfdlmp_regional_c768_physics_cap

   use lsm_noah, only: lsm_noah_init
   use hedmf, only: hedmf_init
   use cires_ugwp, only: cires_ugwp_init
   use ozphys_2015, only: ozphys_2015_init
   use gfdl_cloud_microphys, only: gfdl_cloud_microphys_init
   use GFS_suite_interstitial_phys_reset, only: GFS_suite_interstitial_phys_reset_run
   use GFS_suite_stateout_reset, only: GFS_suite_stateout_reset_run
   use get_prs_fv3, only: get_prs_fv3_run
   use GFS_suite_interstitial_1, only: GFS_suite_interstitial_1_run
   use GFS_surface_generic_pre, only: GFS_surface_generic_pre_run
   use GFS_surface_composites_pre, only: GFS_surface_composites_pre_run
   use dcyc2t3, only: dcyc2t3_run
   use GFS_surface_composites_inter, only: GFS_surface_composites_inter_run
   use GFS_suite_interstitial_2, only: GFS_suite_interstitial_2_run
   use sfc_diff, only: sfc_diff_run
   use GFS_surface_loop_control_part1, only: GFS_surface_loop_control_part1_run
   use sfc_nst_pre, only: sfc_nst_pre_run
   use sfc_nst, only: sfc_nst_run
   use sfc_nst_post, only: sfc_nst_post_run
   use lsm_noah, only: lsm_noah_run
   use sfc_sice, only: sfc_sice_run
   use GFS_surface_loop_control_part2, only: GFS_surface_loop_control_part2_run
   use GFS_surface_composites_post, only: GFS_surface_composites_post_run
   use sfc_diag, only: sfc_diag_run
   use sfc_diag_post, only: sfc_diag_post_run
   use GFS_surface_generic_post, only: GFS_surface_generic_post_run
   use GFS_PBL_generic_pre, only: GFS_PBL_generic_pre_run
   use hedmf, only: hedmf_run
   use GFS_PBL_generic_post, only: GFS_PBL_generic_post_run
   use GFS_GWD_generic_pre, only: GFS_GWD_generic_pre_run
   use cires_ugwp, only: cires_ugwp_run
   use cires_ugwp_post, only: cires_ugwp_post_run
   use GFS_GWD_generic_post, only: GFS_GWD_generic_post_run
   use rayleigh_damp, only: rayleigh_damp_run
   use GFS_suite_stateout_update, only: GFS_suite_stateout_update_run
   use ozphys_2015, only: ozphys_2015_run
   use h2ophys, only: h2ophys_run
   use get_phi_fv3, only: get_phi_fv3_run
   use GFS_suite_interstitial_3, only: GFS_suite_interstitial_3_run
   use GFS_DCNV_generic_pre, only: GFS_DCNV_generic_pre_run
   use GFS_DCNV_generic_post, only: GFS_DCNV_generic_post_run
   use GFS_SCNV_generic_pre, only: GFS_SCNV_generic_pre_run
   use GFS_SCNV_generic_post, only: GFS_SCNV_generic_post_run
   use GFS_suite_interstitial_4, only: GFS_suite_interstitial_4_run
   use GFS_MP_generic_pre, only: GFS_MP_generic_pre_run
   use gfdl_cloud_microphys, only: gfdl_cloud_microphys_run
   use GFS_MP_generic_post, only: GFS_MP_generic_post_run
   use maximum_hourly_diagnostics, only: maximum_hourly_diagnostics_run
   use lsm_noah, only: lsm_noah_finalize
   use cires_ugwp, only: cires_ugwp_finalize
   use gfdl_cloud_microphys, only: gfdl_cloud_microphys_finalize


   implicit none

   private
   public :: FV3_GFS_2017_gfdlmp_regional_c768_physics_init_cap, &
             FV3_GFS_2017_gfdlmp_regional_c768_physics_run_cap, &
             FV3_GFS_2017_gfdlmp_regional_c768_physics_finalize_cap

   logical, save :: initialized = .false.

   contains

   function FV3_GFS_2017_gfdlmp_regional_c768_physics_init_cap(con_p0,cdata,GFS_Control) result(ierr)

      use machine, only: kind_phys
      use ccpp_types, only: ccpp_t
      use GFS_typedefs, only: GFS_control_type

      implicit none

      ! Error handling
      integer :: ierr

      real(kind_phys), intent(in) :: con_p0
      type(ccpp_t), intent(inout) :: cdata
      type(GFS_control_type), intent(in) :: GFS_Control

      ierr = 0


      if (initialized) return



      


      call lsm_noah_init(me=GFS_Control%me,isot=GFS_Control%isot,ivegsrc=GFS_Control%ivegsrc,nlunit=GFS_Control%nlunit, &
                  errmsg=cdata%errmsg,errflg=cdata%errflg)



      if (cdata%errflg/=0) then
        cdata%errmsg = "An error occured in lsm_noah_init: " // trim(cdata%errmsg)
        ierr=cdata%errflg
        return
      end if

    
      


      call hedmf_init(moninq_fac=GFS_Control%moninq_fac,errmsg=cdata%errmsg,errflg=cdata%errflg)



      if (cdata%errflg/=0) then
        cdata%errmsg = "An error occured in hedmf_init: " // trim(cdata%errmsg)
        ierr=cdata%errflg
        return
      end if

    
      


      call cires_ugwp_init(me=GFS_Control%me,master=GFS_Control%master,nlunit=GFS_Control%nlunit,input_nml_file=GFS_Control%input_nml_file, &
                  logunit=GFS_Control%logunit,fn_nml2=GFS_Control%fn_nml,lonr=GFS_Control%lonr, &
                  latr=GFS_Control%latr,levs=GFS_Control%levs,ak=GFS_Control%ak,bk=GFS_Control%bk, &
                  dtp=GFS_Control%dtp,cdmbgwd=GFS_Control%cdmbgwd,cgwf=GFS_Control%cgwf,pa_rf_in=GFS_Control%prslrd0, &
                  tau_rf_in=GFS_Control%ral_ts,con_p0=con_p0,do_ugwp=GFS_Control%do_ugwp, &
                  errmsg=cdata%errmsg,errflg=cdata%errflg)



      if (cdata%errflg/=0) then
        cdata%errmsg = "An error occured in cires_ugwp_init: " // trim(cdata%errmsg)
        ierr=cdata%errflg
        return
      end if

    
      


      call ozphys_2015_init(oz_phys_2015=GFS_Control%oz_phys_2015,errmsg=cdata%errmsg,errflg=cdata%errflg)



      if (cdata%errflg/=0) then
        cdata%errmsg = "An error occured in ozphys_2015_init: " // trim(cdata%errmsg)
        ierr=cdata%errflg
        return
      end if

    
      


      call gfdl_cloud_microphys_init(me=GFS_Control%me,master=GFS_Control%master,nlunit=GFS_Control%nlunit,input_nml_file=GFS_Control%input_nml_file, &
                  logunit=GFS_Control%logunit,fn_nml=GFS_Control%fn_nml,imp_physics=GFS_Control%imp_physics, &
                  imp_physics_gfdl=GFS_Control%imp_physics_gfdl,do_shoc=GFS_Control%do_shoc, &
                  errmsg=cdata%errmsg,errflg=cdata%errflg)



      if (cdata%errflg/=0) then
        cdata%errmsg = "An error occured in gfdl_cloud_microphys_init: " // trim(cdata%errmsg)
        ierr=cdata%errflg
        return
      end if

    


      initialized = .true.


   end function FV3_GFS_2017_gfdlmp_regional_c768_physics_init_cap

   function FV3_GFS_2017_gfdlmp_regional_c768_physics_run_cap(con_t0c,con_rd,rlapse,con_hvap,con_eps,GFS_Control,con_g,con_pi,con_sbc, &
                  con_epsm1,huge,GFS_Interstitial,con_hfus,con_cp,cdata,cimin,GFS_Data,con_rv, &
                  con_jcal,con_fvirt,con_tice,con_rhw0) result(ierr)

      use machine, only: kind_phys
      use GFS_typedefs, only: GFS_control_type
      use GFS_typedefs, only: GFS_interstitial_type
      use ccpp_types, only: ccpp_t
      use GFS_typedefs, only: GFS_data_type

      implicit none

      ! Error handling
      integer :: ierr

      real(kind_phys), intent(in) :: con_t0c
      real(kind_phys), intent(in) :: con_rd
      real(kind_phys), intent(in) :: rlapse
      real(kind_phys), intent(in) :: con_hvap
      real(kind_phys), intent(in) :: con_eps
      type(GFS_control_type), intent(in) :: GFS_Control
      real(kind_phys), intent(in) :: con_g
      real(kind_phys), intent(in) :: con_pi
      real(kind_phys), intent(in) :: con_sbc
      real(kind_phys), intent(in) :: con_epsm1
      real(kind_phys), intent(in) :: huge
      type(GFS_interstitial_type), intent(inout) :: GFS_Interstitial(:)
      real(kind_phys), intent(in) :: con_hfus
      real(kind_phys), intent(in) :: con_cp
      type(ccpp_t), intent(inout) :: cdata
      real(kind_phys), intent(in) :: cimin
      type(GFS_data_type), intent(inout) :: GFS_Data(:)
      real(kind_phys), intent(in) :: con_rv
      real(kind_phys), intent(in) :: con_jcal
      real(kind_phys), intent(in) :: con_fvirt
      real(kind_phys), intent(in) :: con_tice
      real(kind_phys), intent(in) :: con_rhw0

      ierr = 0


      if (.not.initialized) then
        write(cdata%errmsg,'(*(a))') 'physics_run called before physics_init'
        cdata%errflg = 1
        return
      end if



      


      call GFS_suite_interstitial_phys_reset_run(Interstitial=GFS_Interstitial(cdata%thrd_no),Model=GFS_Control,errmsg=cdata%errmsg, &
                  errflg=cdata%errflg)



      if (cdata%errflg/=0) then
        cdata%errmsg = "An error occured in GFS_suite_interstitial_phys_reset_run: " // trim(cdata%errmsg)
        ierr=cdata%errflg
        return
      end if

    
      


      call GFS_suite_stateout_reset_run(im=GFS_Control%blksz(cdata%blk_no),levs=GFS_Control%levs,ntrac=GFS_Control%ntrac, &
                  tgrs=GFS_Data(cdata%blk_no)%Statein%tgrs,ugrs=GFS_Data(cdata%blk_no)%Statein%ugrs, &
                  vgrs=GFS_Data(cdata%blk_no)%Statein%vgrs,qgrs=GFS_Data(cdata%blk_no)%Statein%qgrs, &
                  gt0=GFS_Data(cdata%blk_no)%Stateout%gt0,gu0=GFS_Data(cdata%blk_no)%Stateout%gu0, &
                  gv0=GFS_Data(cdata%blk_no)%Stateout%gv0,gq0=GFS_Data(cdata%blk_no)%Stateout%gq0, &
                  errmsg=cdata%errmsg,errflg=cdata%errflg)



      if (cdata%errflg/=0) then
        cdata%errmsg = "An error occured in GFS_suite_stateout_reset_run: " // trim(cdata%errmsg)
        ierr=cdata%errflg
        return
      end if

    
      


      call get_prs_fv3_run(ix=GFS_Control%blksz(cdata%blk_no),levs=GFS_Control%levs,phii=GFS_Data(cdata%blk_no)%Statein%phii, &
                  prsi=GFS_Data(cdata%blk_no)%Statein%prsi,tgrs=GFS_Data(cdata%blk_no)%Statein%tgrs, &
                  qgrs1=GFS_Data(cdata%blk_no)%Statein%qgrs(:,:,GFS_Control%ntqv),del=GFS_Interstitial(cdata%thrd_no)%del, &
                  del_gz=GFS_Interstitial(cdata%thrd_no)%del_gz,errmsg=cdata%errmsg,errflg=cdata%errflg)



      if (cdata%errflg/=0) then
        cdata%errmsg = "An error occured in get_prs_fv3_run: " // trim(cdata%errmsg)
        ierr=cdata%errflg
        return
      end if

    
      


      call GFS_suite_interstitial_1_run(im=GFS_Control%blksz(cdata%blk_no),levs=GFS_Control%levs,ntrac=GFS_Control%ntrac, &
                  dtf=GFS_Control%dtf,dtp=GFS_Control%dtp,slmsk=GFS_Data(cdata%blk_no)%Sfcprop%slmsk, &
                  area=GFS_Data(cdata%blk_no)%Grid%area,dxmin=GFS_Control%dxmin,dxinv=GFS_Control%dxinv, &
                  pgr=GFS_Data(cdata%blk_no)%Statein%pgr,islmsk=GFS_Interstitial(cdata%thrd_no)%islmsk, &
                  work1=GFS_Interstitial(cdata%thrd_no)%work1,work2=GFS_Interstitial(cdata%thrd_no)%work2, &
                  psurf=GFS_Data(cdata%blk_no)%Intdiag%psurf,dudt=GFS_Interstitial(cdata%thrd_no)%dudt, &
                  dvdt=GFS_Interstitial(cdata%thrd_no)%dvdt,dtdt=GFS_Interstitial(cdata%thrd_no)%dtdt, &
                  dtdtc=GFS_Interstitial(cdata%thrd_no)%dtdtc,dqdt=GFS_Interstitial(cdata%thrd_no)%dqdt, &
                  errmsg=cdata%errmsg,errflg=cdata%errflg)



      if (cdata%errflg/=0) then
        cdata%errmsg = "An error occured in GFS_suite_interstitial_1_run: " // trim(cdata%errmsg)
        ierr=cdata%errflg
        return
      end if

    
      


      call GFS_surface_generic_pre_run(im=GFS_Control%blksz(cdata%blk_no),levs=GFS_Control%levs,vfrac=GFS_Data(cdata%blk_no)%Sfcprop%vfrac, &
                  islmsk=GFS_Interstitial(cdata%thrd_no)%islmsk,isot=GFS_Control%isot,ivegsrc=GFS_Control%ivegsrc, &
                  stype=GFS_Data(cdata%blk_no)%Sfcprop%stype,vtype=GFS_Data(cdata%blk_no)%Sfcprop%vtype, &
                  slope=GFS_Data(cdata%blk_no)%Sfcprop%slope,prsik_1=GFS_Data(cdata%blk_no)%Statein%prsik(:,1), &
                  prslk_1=GFS_Data(cdata%blk_no)%Statein%prslk(:,1),tsfc=GFS_Data(cdata%blk_no)%Sfcprop%tsfc, &
                  phil=GFS_Data(cdata%blk_no)%Statein%phil,con_g=con_g,sigmaf=GFS_Interstitial(cdata%thrd_no)%sigmaf, &
                  soiltyp=GFS_Interstitial(cdata%thrd_no)%soiltype,vegtype=GFS_Interstitial(cdata%thrd_no)%vegtype, &
                  slopetyp=GFS_Interstitial(cdata%thrd_no)%slopetype,work3=GFS_Interstitial(cdata%thrd_no)%work3, &
                  tsurf=GFS_Interstitial(cdata%thrd_no)%tsurf,zlvl=GFS_Data(cdata%blk_no)%Intdiag%zlvl, &
                  do_sppt=GFS_Control%do_sppt,ca_global=GFS_Control%ca_global,dtdtr=GFS_Data(cdata%blk_no)%Tbd%dtdtr, &
                  drain_cpl=GFS_Data(cdata%blk_no)%Tbd%drain_cpl,dsnow_cpl=GFS_Data(cdata%blk_no)%Tbd%dsnow_cpl, &
                  rain_cpl=GFS_Data(cdata%blk_no)%Coupling%rain_cpl,snow_cpl=GFS_Data(cdata%blk_no)%Coupling%snow_cpl, &
                  lndp_type=GFS_Control%lndp_type,n_var_lndp=GFS_Control%n_var_lndp,sfc_wts=GFS_Data(cdata%blk_no)%Coupling%sfc_wts, &
                  lndp_prt_list=GFS_Control%lndp_prt_list,lndp_var_list=GFS_Control%lndp_var_list, &
                  z01d=GFS_Interstitial(cdata%thrd_no)%z01d,zt1d=GFS_Interstitial(cdata%thrd_no)%zt1d, &
                  bexp1d=GFS_Interstitial(cdata%thrd_no)%bexp1d,xlai1d=GFS_Interstitial(cdata%thrd_no)%xlai1d, &
                  vegf1d=GFS_Interstitial(cdata%thrd_no)%vegf1d,lndp_vgf=GFS_Interstitial(cdata%thrd_no)%lndp_vgf, &
                  cplflx=GFS_Control%cplflx,flag_cice=GFS_Interstitial(cdata%thrd_no)%flag_cice, &
                  islmsk_cice=GFS_Interstitial(cdata%thrd_no)%islmsk_cice,slimskin_cpl=GFS_Data(cdata%blk_no)%Coupling%slimskin_cpl, &
                  tisfc=GFS_Data(cdata%blk_no)%Sfcprop%tisfc,tsfco=GFS_Data(cdata%blk_no)%Sfcprop%tsfco, &
                  fice=GFS_Data(cdata%blk_no)%Sfcprop%fice,hice=GFS_Data(cdata%blk_no)%Sfcprop%hice, &
                  wind=GFS_Interstitial(cdata%thrd_no)%wind,u1=GFS_Data(cdata%blk_no)%Statein%ugrs(:,1), &
                  v1=GFS_Data(cdata%blk_no)%Statein%vgrs(:,1),cnvwind=GFS_Data(cdata%blk_no)%Tbd%phy_f2d(:,GFS_Control%num_p2d), &
                  smcwlt2=GFS_Data(cdata%blk_no)%Intdiag%smcwlt2,smcref2=GFS_Data(cdata%blk_no)%Intdiag%smcref2, &
                  errmsg=cdata%errmsg,errflg=cdata%errflg)



      if (cdata%errflg/=0) then
        cdata%errmsg = "An error occured in GFS_surface_generic_pre_run: " // trim(cdata%errmsg)
        ierr=cdata%errflg
        return
      end if

    
      


      call GFS_surface_composites_pre_run(im=GFS_Control%blksz(cdata%blk_no),lkm=GFS_Control%lkm,frac_grid=GFS_Control%frac_grid, &
                  flag_cice=GFS_Interstitial(cdata%thrd_no)%flag_cice,cplflx=GFS_Control%cplflx, &
                  cplwav2atm=GFS_Control%cplwav2atm,landfrac=GFS_Data(cdata%blk_no)%Sfcprop%landfrac, &
                  lakefrac=GFS_Data(cdata%blk_no)%Sfcprop%lakefrac,lakedepth=GFS_Data(cdata%blk_no)%Sfcprop%lakedepth, &
                  oceanfrac=GFS_Data(cdata%blk_no)%Sfcprop%oceanfrac,frland=GFS_Interstitial(cdata%thrd_no)%frland, &
                  dry=GFS_Interstitial(cdata%thrd_no)%dry,icy=GFS_Interstitial(cdata%thrd_no)%icy, &
                  lake=GFS_Interstitial(cdata%thrd_no)%lake,ocean=GFS_Interstitial(cdata%thrd_no)%ocean, &
                  wet=GFS_Interstitial(cdata%thrd_no)%wet,cice=GFS_Data(cdata%blk_no)%Sfcprop%fice, &
                  cimin=cimin,zorl=GFS_Data(cdata%blk_no)%Sfcprop%zorl,zorlo=GFS_Data(cdata%blk_no)%Sfcprop%zorlo, &
                  zorll=GFS_Data(cdata%blk_no)%Sfcprop%zorll,zorli=GFS_Data(cdata%blk_no)%Sfcprop%zorli, &
                  zorl_wat=GFS_Interstitial(cdata%thrd_no)%zorl_ocean,zorl_lnd=GFS_Interstitial(cdata%thrd_no)%zorl_land, &
                  zorl_ice=GFS_Interstitial(cdata%thrd_no)%zorl_ice,snowd=GFS_Data(cdata%blk_no)%Sfcprop%snowd, &
                  snowd_wat=GFS_Interstitial(cdata%thrd_no)%snowd_ocean,snowd_lnd=GFS_Interstitial(cdata%thrd_no)%snowd_land, &
                  snowd_ice=GFS_Interstitial(cdata%thrd_no)%snowd_ice,tprcp=GFS_Data(cdata%blk_no)%Sfcprop%tprcp, &
                  tprcp_wat=GFS_Interstitial(cdata%thrd_no)%tprcp_ocean,tprcp_lnd=GFS_Interstitial(cdata%thrd_no)%tprcp_land, &
                  tprcp_ice=GFS_Interstitial(cdata%thrd_no)%tprcp_ice,uustar=GFS_Data(cdata%blk_no)%Sfcprop%uustar, &
                  uustar_wat=GFS_Interstitial(cdata%thrd_no)%uustar_ocean,uustar_lnd=GFS_Interstitial(cdata%thrd_no)%uustar_land, &
                  uustar_ice=GFS_Interstitial(cdata%thrd_no)%uustar_ice,weasd=GFS_Data(cdata%blk_no)%Sfcprop%weasd, &
                  weasd_wat=GFS_Interstitial(cdata%thrd_no)%weasd_ocean,weasd_lnd=GFS_Interstitial(cdata%thrd_no)%weasd_land, &
                  weasd_ice=GFS_Interstitial(cdata%thrd_no)%weasd_ice,ep1d_ice=GFS_Interstitial(cdata%thrd_no)%ep1d_ice, &
                  tsfc=GFS_Data(cdata%blk_no)%Sfcprop%tsfc,tsfco=GFS_Data(cdata%blk_no)%Sfcprop%tsfco, &
                  tsfcl=GFS_Data(cdata%blk_no)%Sfcprop%tsfcl,tsfc_wat=GFS_Interstitial(cdata%thrd_no)%tsfc_ocean, &
                  tsfc_lnd=GFS_Interstitial(cdata%thrd_no)%tsfc_land,tsfc_ice=GFS_Interstitial(cdata%thrd_no)%tsfc_ice, &
                  tisfc=GFS_Data(cdata%blk_no)%Sfcprop%tisfc,tice=GFS_Interstitial(cdata%thrd_no)%tice, &
                  tsurf=GFS_Interstitial(cdata%thrd_no)%tsurf,tsurf_wat=GFS_Interstitial(cdata%thrd_no)%tsurf_ocean, &
                  tsurf_lnd=GFS_Interstitial(cdata%thrd_no)%tsurf_land,tsurf_ice=GFS_Interstitial(cdata%thrd_no)%tsurf_ice, &
                  gflx_ice=GFS_Interstitial(cdata%thrd_no)%gflx_ice,tgice=con_tice,islmsk=GFS_Interstitial(cdata%thrd_no)%islmsk, &
                  semis_rad=GFS_Data(cdata%blk_no)%Radtend%semis,semis_wat=GFS_Interstitial(cdata%thrd_no)%semis_ocean, &
                  semis_lnd=GFS_Interstitial(cdata%thrd_no)%semis_land,semis_ice=GFS_Interstitial(cdata%thrd_no)%semis_ice, &
                  qss=GFS_Data(cdata%blk_no)%Sfcprop%qss,qss_wat=GFS_Interstitial(cdata%thrd_no)%qss_ocean, &
                  qss_lnd=GFS_Interstitial(cdata%thrd_no)%qss_land,qss_ice=GFS_Interstitial(cdata%thrd_no)%qss_ice, &
                  hflx=GFS_Data(cdata%blk_no)%Sfcprop%hflx,hflx_wat=GFS_Interstitial(cdata%thrd_no)%hflx_ocean, &
                  hflx_lnd=GFS_Interstitial(cdata%thrd_no)%hflx_land,hflx_ice=GFS_Interstitial(cdata%thrd_no)%hflx_ice, &
                  min_lakeice=GFS_Control%min_lakeice,min_seaice=GFS_Control%min_seaice,errmsg=cdata%errmsg, &
                  errflg=cdata%errflg)



      if (cdata%errflg/=0) then
        cdata%errmsg = "An error occured in GFS_surface_composites_pre_run: " // trim(cdata%errmsg)
        ierr=cdata%errflg
        return
      end if

    
      


      call dcyc2t3_run(solhr=GFS_Control%solhr,slag=GFS_Control%slag,sdec=GFS_Control%sdec,cdec=GFS_Control%cdec, &
                  sinlat=GFS_Data(cdata%blk_no)%Grid%sinlat,coslat=GFS_Data(cdata%blk_no)%Grid%coslat, &
                  xlon=GFS_Data(cdata%blk_no)%Grid%xlon,coszen=GFS_Data(cdata%blk_no)%Radtend%coszen, &
                  tsfc_lnd=GFS_Interstitial(cdata%thrd_no)%tsfc_land,tsfc_wat=GFS_Interstitial(cdata%thrd_no)%tsfc_ocean, &
                  tsfc_ice=GFS_Interstitial(cdata%thrd_no)%tsfc_ice,tf=GFS_Data(cdata%blk_no)%Statein%tgrs(:,1), &
                  tsflw=GFS_Data(cdata%blk_no)%Radtend%tsflw,sfcemis_lnd=GFS_Interstitial(cdata%thrd_no)%semis_land, &
                  sfcemis_ice=GFS_Interstitial(cdata%thrd_no)%semis_ice,sfcemis_wat=GFS_Interstitial(cdata%thrd_no)%semis_ocean, &
                  sfcdsw=GFS_Data(cdata%blk_no)%Coupling%sfcdsw,sfcnsw=GFS_Data(cdata%blk_no)%Coupling%sfcnsw, &
                  sfcdlw=GFS_Data(cdata%blk_no)%Coupling%sfcdlw,swh=GFS_Data(cdata%blk_no)%Radtend%htrsw, &
                  swhc=GFS_Data(cdata%blk_no)%Radtend%swhc,hlw=GFS_Data(cdata%blk_no)%Radtend%htrlw, &
                  hlwc=GFS_Data(cdata%blk_no)%Radtend%lwhc,sfcnirbmu=GFS_Data(cdata%blk_no)%Coupling%nirbmui, &
                  sfcnirdfu=GFS_Data(cdata%blk_no)%Coupling%nirdfui,sfcvisbmu=GFS_Data(cdata%blk_no)%Coupling%visbmui, &
                  sfcvisdfu=GFS_Data(cdata%blk_no)%Coupling%visdfui,sfcnirbmd=GFS_Data(cdata%blk_no)%Coupling%nirbmdi, &
                  sfcnirdfd=GFS_Data(cdata%blk_no)%Coupling%nirdfdi,sfcvisbmd=GFS_Data(cdata%blk_no)%Coupling%visbmdi, &
                  sfcvisdfd=GFS_Data(cdata%blk_no)%Coupling%visdfdi,im=GFS_Control%blksz(cdata%blk_no), &
                  levs=GFS_Control%levs,deltim=GFS_Control%dtf,fhswr=GFS_Control%fhswr,dry=GFS_Interstitial(cdata%thrd_no)%dry, &
                  icy=GFS_Interstitial(cdata%thrd_no)%icy,wet=GFS_Interstitial(cdata%thrd_no)%wet, &
                  dtdt=GFS_Interstitial(cdata%thrd_no)%dtdt,dtdtc=GFS_Interstitial(cdata%thrd_no)%dtdtc, &
                  adjsfcdsw=GFS_Data(cdata%blk_no)%Intdiag%dswsfci,adjsfcnsw=GFS_Data(cdata%blk_no)%Intdiag%nswsfci, &
                  adjsfcdlw=GFS_Data(cdata%blk_no)%Intdiag%dlwsfci,adjsfculw_lnd=GFS_Interstitial(cdata%thrd_no)%adjsfculw_land, &
                  adjsfculw_ice=GFS_Interstitial(cdata%thrd_no)%adjsfculw_ice,adjsfculw_wat=GFS_Interstitial(cdata%thrd_no)%adjsfculw_ocean, &
                  xmu=GFS_Interstitial(cdata%thrd_no)%xmu,xcosz=GFS_Interstitial(cdata%thrd_no)%xcosz, &
                  adjnirbmu=GFS_Interstitial(cdata%thrd_no)%adjnirbmu,adjnirdfu=GFS_Interstitial(cdata%thrd_no)%adjnirdfu, &
                  adjvisbmu=GFS_Interstitial(cdata%thrd_no)%adjvisbmu,adjvisdfu=GFS_Interstitial(cdata%thrd_no)%adjvisdfu, &
                  adjnirbmd=GFS_Interstitial(cdata%thrd_no)%adjnirbmd,adjnirdfd=GFS_Interstitial(cdata%thrd_no)%adjnirdfd, &
                  adjvisbmd=GFS_Interstitial(cdata%thrd_no)%adjvisbmd,adjvisdfd=GFS_Interstitial(cdata%thrd_no)%adjvisdfd, &
                  errmsg=cdata%errmsg,errflg=cdata%errflg)



      if (cdata%errflg/=0) then
        cdata%errmsg = "An error occured in dcyc2t3_run: " // trim(cdata%errmsg)
        ierr=cdata%errflg
        return
      end if

    
      


      call GFS_surface_composites_inter_run(im=GFS_Control%blksz(cdata%blk_no),dry=GFS_Interstitial(cdata%thrd_no)%dry, &
                  icy=GFS_Interstitial(cdata%thrd_no)%icy,wet=GFS_Interstitial(cdata%thrd_no)%wet, &
                  semis_wat=GFS_Interstitial(cdata%thrd_no)%semis_ocean,semis_lnd=GFS_Interstitial(cdata%thrd_no)%semis_land, &
                  semis_ice=GFS_Interstitial(cdata%thrd_no)%semis_ice,adjsfcdlw=GFS_Data(cdata%blk_no)%Intdiag%dlwsfci, &
                  gabsbdlw_lnd=GFS_Interstitial(cdata%thrd_no)%gabsbdlw_land,gabsbdlw_ice=GFS_Interstitial(cdata%thrd_no)%gabsbdlw_ice, &
                  gabsbdlw_wat=GFS_Interstitial(cdata%thrd_no)%gabsbdlw_ocean,adjsfcusw=GFS_Data(cdata%blk_no)%Intdiag%uswsfci, &
                  adjsfcdsw=GFS_Data(cdata%blk_no)%Intdiag%dswsfci,adjsfcnsw=GFS_Data(cdata%blk_no)%Intdiag%nswsfci, &
                  errmsg=cdata%errmsg,errflg=cdata%errflg)



      if (cdata%errflg/=0) then
        cdata%errmsg = "An error occured in GFS_surface_composites_inter_run: " // trim(cdata%errmsg)
        ierr=cdata%errflg
        return
      end if

    
      


      call GFS_suite_interstitial_2_run(im=GFS_Control%blksz(cdata%blk_no),levs=GFS_Control%levs,lssav=GFS_Control%lssav, &
                  ldiag3d=GFS_Control%ldiag3d,lsidea=GFS_Control%lsidea,cplflx=GFS_Control%cplflx, &
                  flag_cice=GFS_Interstitial(cdata%thrd_no)%flag_cice,shal_cnv=GFS_Control%shal_cnv, &
                  old_monin=GFS_Control%old_monin,mstrat=GFS_Control%mstrat,do_shoc=GFS_Control%do_shoc, &
                  frac_grid=GFS_Control%frac_grid,imfshalcnv=GFS_Control%imfshalcnv,dtf=GFS_Control%dtf, &
                  xcosz=GFS_Interstitial(cdata%thrd_no)%xcosz,adjsfcdsw=GFS_Data(cdata%blk_no)%Intdiag%dswsfci, &
                  adjsfcdlw=GFS_Data(cdata%blk_no)%Intdiag%dlwsfci,cice=GFS_Data(cdata%blk_no)%Sfcprop%fice, &
                  pgr=GFS_Data(cdata%blk_no)%Statein%pgr,ulwsfc_cice=GFS_Data(cdata%blk_no)%Coupling%ulwsfcin_cpl, &
                  lwhd=GFS_Data(cdata%blk_no)%Radtend%lwhd,htrsw=GFS_Data(cdata%blk_no)%Radtend%htrsw, &
                  htrlw=GFS_Data(cdata%blk_no)%Radtend%htrlw,xmu=GFS_Interstitial(cdata%thrd_no)%xmu, &
                  ctei_rm=GFS_Control%ctei_rm,work1=GFS_Interstitial(cdata%thrd_no)%work1, &
                  work2=GFS_Interstitial(cdata%thrd_no)%work2,prsi=GFS_Data(cdata%blk_no)%Statein%prsi, &
                  tgrs=GFS_Data(cdata%blk_no)%Statein%tgrs,prsl=GFS_Data(cdata%blk_no)%Statein%prsl, &
                  qgrs_water_vapor=GFS_Data(cdata%blk_no)%Statein%qgrs(:,:,GFS_Control%ntqv), &
                  qgrs_cloud_water=GFS_Data(cdata%blk_no)%Statein%qgrs(:,:,GFS_Control%ntcw), &
                  cp=con_cp,hvap=con_hvap,prslk=GFS_Data(cdata%blk_no)%Statein%prslk,suntim=GFS_Data(cdata%blk_no)%Intdiag%suntim, &
                  adjsfculw=GFS_Data(cdata%blk_no)%Intdiag%ulwsfci,adjsfculw_lnd=GFS_Interstitial(cdata%thrd_no)%adjsfculw_land, &
                  adjsfculw_ice=GFS_Interstitial(cdata%thrd_no)%adjsfculw_ice,adjsfculw_wat=GFS_Interstitial(cdata%thrd_no)%adjsfculw_ocean, &
                  dlwsfc=GFS_Data(cdata%blk_no)%Intdiag%dlwsfc,ulwsfc=GFS_Data(cdata%blk_no)%Intdiag%ulwsfc, &
                  psmean=GFS_Data(cdata%blk_no)%Intdiag%psmean,dt3dt_lw=GFS_Data(cdata%blk_no)%Intdiag%dt3dt(:,:,1), &
                  dt3dt_sw=GFS_Data(cdata%blk_no)%Intdiag%dt3dt(:,:,2),dt3dt_pbl=GFS_Data(cdata%blk_no)%Intdiag%dt3dt(:,:,3), &
                  dt3dt_dcnv=GFS_Data(cdata%blk_no)%Intdiag%dt3dt(:,:,4),dt3dt_scnv=GFS_Data(cdata%blk_no)%Intdiag%dt3dt(:,:,5), &
                  dt3dt_mp=GFS_Data(cdata%blk_no)%Intdiag%dt3dt(:,:,6),ctei_rml=GFS_Interstitial(cdata%thrd_no)%ctei_rml, &
                  ctei_r=GFS_Interstitial(cdata%thrd_no)%ctei_r,kinver=GFS_Interstitial(cdata%thrd_no)%kinver, &
                  dry=GFS_Interstitial(cdata%thrd_no)%dry,icy=GFS_Interstitial(cdata%thrd_no)%icy, &
                  wet=GFS_Interstitial(cdata%thrd_no)%wet,frland=GFS_Interstitial(cdata%thrd_no)%frland, &
                  huge=huge,use_GP_jacobian=GFS_Control%use_LW_jacobian,skt=GFS_Data(cdata%blk_no)%Statein%tgrs(:,1), &
                  sktp1r=GFS_Interstitial(cdata%thrd_no)%sktp1r,fluxlwUP=GFS_Interstitial(cdata%thrd_no)%fluxlwUP_allsky, &
                  fluxlwUP_jac=GFS_Interstitial(cdata%thrd_no)%fluxlwUP_jac,errmsg=cdata%errmsg, &
                  errflg=cdata%errflg)



      if (cdata%errflg/=0) then
        cdata%errmsg = "An error occured in GFS_suite_interstitial_2_run: " // trim(cdata%errmsg)
        ierr=cdata%errflg
        return
      end if

    
      associate(cnt => cdata%loop_cnt)
      do cnt=1,2


      


      call sfc_diff_run(im=GFS_Control%blksz(cdata%blk_no),rvrdm1=con_fvirt,eps=con_eps,epsm1=con_epsm1, &
                  grav=con_g,ps=GFS_Data(cdata%blk_no)%Statein%pgr,t1=GFS_Data(cdata%blk_no)%Statein%tgrs(:,1), &
                  q1=GFS_Data(cdata%blk_no)%Statein%qgrs(:,1,GFS_Control%ntqv),z1=GFS_Data(cdata%blk_no)%Intdiag%zlvl, &
                  wind=GFS_Interstitial(cdata%thrd_no)%wind,prsl1=GFS_Data(cdata%blk_no)%Statein%prsl(:,1), &
                  prslki=GFS_Interstitial(cdata%thrd_no)%work3,prsik1=GFS_Data(cdata%blk_no)%Statein%prsik(:,1), &
                  prslk1=GFS_Data(cdata%blk_no)%Statein%prslk(:,1),sigmaf=GFS_Interstitial(cdata%thrd_no)%sigmaf, &
                  vegtype=GFS_Interstitial(cdata%thrd_no)%vegtype,shdmax=GFS_Data(cdata%blk_no)%Sfcprop%shdmax, &
                  ivegsrc=GFS_Control%ivegsrc,z0pert=GFS_Interstitial(cdata%thrd_no)%z01d, &
                  ztpert=GFS_Interstitial(cdata%thrd_no)%zt1d,flag_iter=GFS_Interstitial(cdata%thrd_no)%flag_iter, &
                  redrag=GFS_Control%redrag,u10m=GFS_Data(cdata%blk_no)%Intdiag%u10m,v10m=GFS_Data(cdata%blk_no)%Intdiag%v10m, &
                  sfc_z0_type=GFS_Control%sfc_z0_type,wet=GFS_Interstitial(cdata%thrd_no)%wet, &
                  dry=GFS_Interstitial(cdata%thrd_no)%dry,icy=GFS_Interstitial(cdata%thrd_no)%icy, &
                  tskin_wat=GFS_Interstitial(cdata%thrd_no)%tsfc_ocean,tskin_lnd=GFS_Interstitial(cdata%thrd_no)%tsfc_land, &
                  tskin_ice=GFS_Interstitial(cdata%thrd_no)%tsfc_ice,tsurf_wat=GFS_Interstitial(cdata%thrd_no)%tsurf_ocean, &
                  tsurf_lnd=GFS_Interstitial(cdata%thrd_no)%tsurf_land,tsurf_ice=GFS_Interstitial(cdata%thrd_no)%tsurf_ice, &
                  snwdph_wat=GFS_Interstitial(cdata%thrd_no)%snowd_ocean,snwdph_lnd=GFS_Interstitial(cdata%thrd_no)%snowd_land, &
                  snwdph_ice=GFS_Interstitial(cdata%thrd_no)%snowd_ice,z0rl_wat=GFS_Interstitial(cdata%thrd_no)%zorl_ocean, &
                  z0rl_lnd=GFS_Interstitial(cdata%thrd_no)%zorl_land,z0rl_ice=GFS_Interstitial(cdata%thrd_no)%zorl_ice, &
                  z0rl_wav=GFS_Data(cdata%blk_no)%Sfcprop%zorlw,ustar_wat=GFS_Interstitial(cdata%thrd_no)%uustar_ocean, &
                  ustar_lnd=GFS_Interstitial(cdata%thrd_no)%uustar_land,ustar_ice=GFS_Interstitial(cdata%thrd_no)%uustar_ice, &
                  cm_wat=GFS_Interstitial(cdata%thrd_no)%cd_ocean,cm_lnd=GFS_Interstitial(cdata%thrd_no)%cd_land, &
                  cm_ice=GFS_Interstitial(cdata%thrd_no)%cd_ice,ch_wat=GFS_Interstitial(cdata%thrd_no)%cdq_ocean, &
                  ch_lnd=GFS_Interstitial(cdata%thrd_no)%cdq_land,ch_ice=GFS_Interstitial(cdata%thrd_no)%cdq_ice, &
                  rb_wat=GFS_Interstitial(cdata%thrd_no)%rb_ocean,rb_lnd=GFS_Interstitial(cdata%thrd_no)%rb_land, &
                  rb_ice=GFS_Interstitial(cdata%thrd_no)%rb_ice,stress_wat=GFS_Interstitial(cdata%thrd_no)%stress_ocean, &
                  stress_lnd=GFS_Interstitial(cdata%thrd_no)%stress_land,stress_ice=GFS_Interstitial(cdata%thrd_no)%stress_ice, &
                  fm_wat=GFS_Interstitial(cdata%thrd_no)%ffmm_ocean,fm_lnd=GFS_Interstitial(cdata%thrd_no)%ffmm_land, &
                  fm_ice=GFS_Interstitial(cdata%thrd_no)%ffmm_ice,fh_wat=GFS_Interstitial(cdata%thrd_no)%ffhh_ocean, &
                  fh_lnd=GFS_Interstitial(cdata%thrd_no)%ffhh_land,fh_ice=GFS_Interstitial(cdata%thrd_no)%ffhh_ice, &
                  fm10_wat=GFS_Interstitial(cdata%thrd_no)%fm10_ocean,fm10_lnd=GFS_Interstitial(cdata%thrd_no)%fm10_land, &
                  fm10_ice=GFS_Interstitial(cdata%thrd_no)%fm10_ice,fh2_wat=GFS_Interstitial(cdata%thrd_no)%fh2_ocean, &
                  fh2_lnd=GFS_Interstitial(cdata%thrd_no)%fh2_land,fh2_ice=GFS_Interstitial(cdata%thrd_no)%fh2_ice, &
                  errmsg=cdata%errmsg,errflg=cdata%errflg)



      if (cdata%errflg/=0) then
        cdata%errmsg = "An error occured in sfc_diff_run: " // trim(cdata%errmsg)
        ierr=cdata%errflg
        return
      end if

    
      


      call GFS_surface_loop_control_part1_run(im=GFS_Control%blksz(cdata%blk_no),iter=cdata%loop_cnt,wind=GFS_Interstitial(cdata%thrd_no)%wind, &
                  flag_guess=GFS_Interstitial(cdata%thrd_no)%flag_guess,errmsg=cdata%errmsg, &
                  errflg=cdata%errflg)



      if (cdata%errflg/=0) then
        cdata%errmsg = "An error occured in GFS_surface_loop_control_part1_run: " // trim(cdata%errmsg)
        ierr=cdata%errflg
        return
      end if

    
      


      call sfc_nst_pre_run(im=GFS_Control%blksz(cdata%blk_no),wet=GFS_Interstitial(cdata%thrd_no)%wet, &
                  tsfc_wat=GFS_Interstitial(cdata%thrd_no)%tsfc_ocean,tsurf_wat=GFS_Interstitial(cdata%thrd_no)%tsurf_ocean, &
                  tseal=GFS_Interstitial(cdata%thrd_no)%tseal,xt=GFS_Data(cdata%blk_no)%Sfcprop%xt, &
                  xz=GFS_Data(cdata%blk_no)%Sfcprop%xz,dt_cool=GFS_Data(cdata%blk_no)%Sfcprop%dt_cool, &
                  z_c=GFS_Data(cdata%blk_no)%Sfcprop%z_c,tref=GFS_Data(cdata%blk_no)%Sfcprop%tref, &
                  cplflx=GFS_Control%cplflx,oceanfrac=GFS_Data(cdata%blk_no)%Sfcprop%oceanfrac, &
                  nthreads=GFS_Control%nthreads,errmsg=cdata%errmsg,errflg=cdata%errflg)



      if (cdata%errflg/=0) then
        cdata%errmsg = "An error occured in sfc_nst_pre_run: " // trim(cdata%errmsg)
        ierr=cdata%errflg
        return
      end if

    
      


      call sfc_nst_run(im=GFS_Control%blksz(cdata%blk_no),hvap=con_hvap,cp=con_cp,hfus=con_hfus, &
                  jcal=con_jcal,eps=con_eps,epsm1=con_epsm1,rvrdm1=con_fvirt,rd=con_rd,rhw0=con_rhw0, &
                  sbc=con_sbc,pi=con_pi,ps=GFS_Data(cdata%blk_no)%Statein%pgr,u1=GFS_Data(cdata%blk_no)%Statein%ugrs(:,1), &
                  v1=GFS_Data(cdata%blk_no)%Statein%vgrs(:,1),t1=GFS_Data(cdata%blk_no)%Statein%tgrs(:,1), &
                  q1=GFS_Data(cdata%blk_no)%Statein%qgrs(:,1,GFS_Control%ntqv),tref=GFS_Data(cdata%blk_no)%Sfcprop%tref, &
                  cm=GFS_Interstitial(cdata%thrd_no)%cd_ocean,ch=GFS_Interstitial(cdata%thrd_no)%cdq_ocean, &
                  prsl1=GFS_Data(cdata%blk_no)%Statein%prsl(:,1),prslki=GFS_Interstitial(cdata%thrd_no)%work3, &
                  prsik1=GFS_Data(cdata%blk_no)%Statein%prsik(:,1),prslk1=GFS_Data(cdata%blk_no)%Statein%prslk(:,1), &
                  wet=GFS_Interstitial(cdata%thrd_no)%wet,xlon=GFS_Data(cdata%blk_no)%Grid%xlon, &
                  sinlat=GFS_Data(cdata%blk_no)%Grid%sinlat,stress=GFS_Interstitial(cdata%thrd_no)%stress_ocean, &
                  sfcemis=GFS_Interstitial(cdata%thrd_no)%semis_ocean,dlwflx=GFS_Interstitial(cdata%thrd_no)%gabsbdlw_ocean, &
                  sfcnsw=GFS_Data(cdata%blk_no)%Intdiag%nswsfci,rain=GFS_Interstitial(cdata%thrd_no)%tprcp_ocean, &
                  timestep=GFS_Control%dtf,kdt=GFS_Control%kdt,solhr=GFS_Control%solhr,xcosz=GFS_Interstitial(cdata%thrd_no)%xcosz, &
                  wind=GFS_Interstitial(cdata%thrd_no)%wind,flag_iter=GFS_Interstitial(cdata%thrd_no)%flag_iter, &
                  flag_guess=GFS_Interstitial(cdata%thrd_no)%flag_guess,nstf_name1=GFS_Control%nstf_name(1), &
                  nstf_name4=GFS_Control%nstf_name(4),nstf_name5=GFS_Control%nstf_name(5), &
                  lprnt=GFS_Control%lprnt,ipr=GFS_Interstitial(cdata%thrd_no)%ipr,tskin=GFS_Interstitial(cdata%thrd_no)%tseal, &
                  tsurf=GFS_Interstitial(cdata%thrd_no)%tsurf_ocean,xt=GFS_Data(cdata%blk_no)%Sfcprop%xt, &
                  xs=GFS_Data(cdata%blk_no)%Sfcprop%xs,xu=GFS_Data(cdata%blk_no)%Sfcprop%xu, &
                  xv=GFS_Data(cdata%blk_no)%Sfcprop%xv,xz=GFS_Data(cdata%blk_no)%Sfcprop%xz, &
                  zm=GFS_Data(cdata%blk_no)%Sfcprop%zm,xtts=GFS_Data(cdata%blk_no)%Sfcprop%xtts, &
                  xzts=GFS_Data(cdata%blk_no)%Sfcprop%xzts,dt_cool=GFS_Data(cdata%blk_no)%Sfcprop%dt_cool, &
                  z_c=GFS_Data(cdata%blk_no)%Sfcprop%z_c,c_0=GFS_Data(cdata%blk_no)%Sfcprop%c_0, &
                  c_d=GFS_Data(cdata%blk_no)%Sfcprop%c_d,w_0=GFS_Data(cdata%blk_no)%Sfcprop%w_0, &
                  w_d=GFS_Data(cdata%blk_no)%Sfcprop%w_d,d_conv=GFS_Data(cdata%blk_no)%Sfcprop%d_conv, &
                  ifd=GFS_Data(cdata%blk_no)%Sfcprop%ifd,qrain=GFS_Data(cdata%blk_no)%Sfcprop%qrain, &
                  qsurf=GFS_Interstitial(cdata%thrd_no)%qss_ocean,gflux=GFS_Interstitial(cdata%thrd_no)%gflx_ocean, &
                  cmm=GFS_Interstitial(cdata%thrd_no)%cmm_ocean,chh=GFS_Interstitial(cdata%thrd_no)%chh_ocean, &
                  evap=GFS_Interstitial(cdata%thrd_no)%evap_ocean,hflx=GFS_Interstitial(cdata%thrd_no)%hflx_ocean, &
                  ep=GFS_Interstitial(cdata%thrd_no)%ep1d_ocean,errmsg=cdata%errmsg,errflg=cdata%errflg)



      if (cdata%errflg/=0) then
        cdata%errmsg = "An error occured in sfc_nst_run: " // trim(cdata%errmsg)
        ierr=cdata%errflg
        return
      end if

    
      


      call sfc_nst_post_run(im=GFS_Control%blksz(cdata%blk_no),rlapse=rlapse,tgice=con_tice,wet=GFS_Interstitial(cdata%thrd_no)%wet, &
                  icy=GFS_Interstitial(cdata%thrd_no)%icy,oro=GFS_Data(cdata%blk_no)%Sfcprop%oro, &
                  oro_uf=GFS_Data(cdata%blk_no)%Sfcprop%oro_uf,nstf_name1=GFS_Control%nstf_name(1), &
                  nstf_name4=GFS_Control%nstf_name(4),nstf_name5=GFS_Control%nstf_name(5), &
                  xt=GFS_Data(cdata%blk_no)%Sfcprop%xt,xz=GFS_Data(cdata%blk_no)%Sfcprop%xz, &
                  dt_cool=GFS_Data(cdata%blk_no)%Sfcprop%dt_cool,z_c=GFS_Data(cdata%blk_no)%Sfcprop%z_c, &
                  tref=GFS_Data(cdata%blk_no)%Sfcprop%tref,xlon=GFS_Data(cdata%blk_no)%Grid%xlon, &
                  tsurf_wat=GFS_Interstitial(cdata%thrd_no)%tsurf_ocean,tsfc_wat=GFS_Interstitial(cdata%thrd_no)%tsfc_ocean, &
                  nthreads=GFS_Control%nthreads,dtzm=GFS_Interstitial(cdata%thrd_no)%dtzm, &
                  errmsg=cdata%errmsg,errflg=cdata%errflg)



      if (cdata%errflg/=0) then
        cdata%errmsg = "An error occured in sfc_nst_post_run: " // trim(cdata%errmsg)
        ierr=cdata%errflg
        return
      end if

    
      


      call lsm_noah_run(im=GFS_Control%blksz(cdata%blk_no),km=GFS_Control%lsoil,grav=con_g,cp=con_cp, &
                  hvap=con_hvap,rd=con_rd,eps=con_eps,epsm1=con_epsm1,rvrdm1=con_fvirt,ps=GFS_Data(cdata%blk_no)%Statein%pgr, &
                  t1=GFS_Data(cdata%blk_no)%Statein%tgrs(:,1),q1=GFS_Data(cdata%blk_no)%Statein%qgrs(:,1,GFS_Control%ntqv), &
                  soiltyp=GFS_Interstitial(cdata%thrd_no)%soiltype,vegtype=GFS_Interstitial(cdata%thrd_no)%vegtype, &
                  sigmaf=GFS_Interstitial(cdata%thrd_no)%sigmaf,sfcemis=GFS_Interstitial(cdata%thrd_no)%semis_land, &
                  dlwflx=GFS_Interstitial(cdata%thrd_no)%gabsbdlw_land,dswsfc=GFS_Data(cdata%blk_no)%Intdiag%dswsfci, &
                  snet=GFS_Data(cdata%blk_no)%Intdiag%nswsfci,delt=GFS_Control%dtf,tg3=GFS_Data(cdata%blk_no)%Sfcprop%tg3, &
                  cm=GFS_Interstitial(cdata%thrd_no)%cd_land,ch=GFS_Interstitial(cdata%thrd_no)%cdq_land, &
                  prsl1=GFS_Data(cdata%blk_no)%Statein%prsl(:,1),prslki=GFS_Interstitial(cdata%thrd_no)%work3, &
                  zf=GFS_Data(cdata%blk_no)%Intdiag%zlvl,land=GFS_Interstitial(cdata%thrd_no)%dry, &
                  wind=GFS_Interstitial(cdata%thrd_no)%wind,slopetyp=GFS_Interstitial(cdata%thrd_no)%slopetype, &
                  shdmin=GFS_Data(cdata%blk_no)%Sfcprop%shdmin,shdmax=GFS_Data(cdata%blk_no)%Sfcprop%shdmax, &
                  snoalb=GFS_Data(cdata%blk_no)%Sfcprop%snoalb,sfalb=GFS_Data(cdata%blk_no)%Radtend%sfalb, &
                  flag_iter=GFS_Interstitial(cdata%thrd_no)%flag_iter,flag_guess=GFS_Interstitial(cdata%thrd_no)%flag_guess, &
                  lheatstrg=GFS_Control%lheatstrg,isot=GFS_Control%isot,ivegsrc=GFS_Control%ivegsrc, &
                  bexppert=GFS_Interstitial(cdata%thrd_no)%bexp1d,xlaipert=GFS_Interstitial(cdata%thrd_no)%xlai1d, &
                  vegfpert=GFS_Interstitial(cdata%thrd_no)%vegf1d,pertvegf=GFS_Interstitial(cdata%thrd_no)%lndp_vgf, &
                  weasd=GFS_Interstitial(cdata%thrd_no)%weasd_land,snwdph=GFS_Interstitial(cdata%thrd_no)%snowd_land, &
                  tskin=GFS_Interstitial(cdata%thrd_no)%tsfc_land,tprcp=GFS_Interstitial(cdata%thrd_no)%tprcp_land, &
                  srflag=GFS_Data(cdata%blk_no)%Sfcprop%srflag,smc=GFS_Data(cdata%blk_no)%Sfcprop%smc, &
                  stc=GFS_Data(cdata%blk_no)%Sfcprop%stc,slc=GFS_Data(cdata%blk_no)%Sfcprop%slc, &
                  canopy=GFS_Data(cdata%blk_no)%Sfcprop%canopy,trans=GFS_Interstitial(cdata%thrd_no)%trans, &
                  tsurf=GFS_Interstitial(cdata%thrd_no)%tsurf_land,zorl=GFS_Interstitial(cdata%thrd_no)%zorl_land, &
                  sncovr1=GFS_Data(cdata%blk_no)%Sfcprop%sncovr,qsurf=GFS_Interstitial(cdata%thrd_no)%qss_land, &
                  gflux=GFS_Interstitial(cdata%thrd_no)%gflx_land,drain=GFS_Interstitial(cdata%thrd_no)%drain, &
                  evap=GFS_Interstitial(cdata%thrd_no)%evap_land,hflx=GFS_Interstitial(cdata%thrd_no)%hflx_land, &
                  ep=GFS_Interstitial(cdata%thrd_no)%ep1d_land,runoff=GFS_Interstitial(cdata%thrd_no)%runoff, &
                  cmm=GFS_Interstitial(cdata%thrd_no)%cmm_land,chh=GFS_Interstitial(cdata%thrd_no)%chh_land, &
                  evbs=GFS_Interstitial(cdata%thrd_no)%evbs,evcw=GFS_Interstitial(cdata%thrd_no)%evcw, &
                  sbsno=GFS_Interstitial(cdata%thrd_no)%sbsno,snowc=GFS_Interstitial(cdata%thrd_no)%snowc, &
                  stm=GFS_Data(cdata%blk_no)%Intdiag%soilm,snohf=GFS_Interstitial(cdata%thrd_no)%snohf, &
                  smcwlt2=GFS_Data(cdata%blk_no)%Intdiag%smcwlt2,smcref2=GFS_Data(cdata%blk_no)%Intdiag%smcref2, &
                  wet1=GFS_Data(cdata%blk_no)%Intdiag%wet1,errmsg=cdata%errmsg,errflg=cdata%errflg)



      if (cdata%errflg/=0) then
        cdata%errmsg = "An error occured in lsm_noah_run: " // trim(cdata%errmsg)
        ierr=cdata%errflg
        return
      end if

    
      


      call sfc_sice_run(im=GFS_Control%blksz(cdata%blk_no),kice=GFS_Control%kice,sbc=con_sbc,hvap=con_hvap, &
                  tgice=con_tice,cp=con_cp,eps=con_eps,epsm1=con_epsm1,rvrdm1=con_fvirt,grav=con_g, &
                  t0c=con_t0c,rd=con_rd,ps=GFS_Data(cdata%blk_no)%Statein%pgr,t1=GFS_Data(cdata%blk_no)%Statein%tgrs(:,1), &
                  q1=GFS_Data(cdata%blk_no)%Statein%qgrs(:,1,GFS_Control%ntqv),delt=GFS_Control%dtf, &
                  sfcemis=GFS_Interstitial(cdata%thrd_no)%semis_ice,dlwflx=GFS_Interstitial(cdata%thrd_no)%gabsbdlw_ice, &
                  sfcnsw=GFS_Data(cdata%blk_no)%Intdiag%nswsfci,sfcdsw=GFS_Data(cdata%blk_no)%Intdiag%dswsfci, &
                  srflag=GFS_Data(cdata%blk_no)%Sfcprop%srflag,cm=GFS_Interstitial(cdata%thrd_no)%cd_ice, &
                  ch=GFS_Interstitial(cdata%thrd_no)%cdq_ice,prsl1=GFS_Data(cdata%blk_no)%Statein%prsl(:,1), &
                  prslki=GFS_Interstitial(cdata%thrd_no)%work3,prsik1=GFS_Data(cdata%blk_no)%Statein%prsik(:,1), &
                  prslk1=GFS_Data(cdata%blk_no)%Statein%prslk(:,1),wind=GFS_Interstitial(cdata%thrd_no)%wind, &
                  flag_iter=GFS_Interstitial(cdata%thrd_no)%flag_iter,lprnt=GFS_Control%lprnt, &
                  ipr=GFS_Interstitial(cdata%thrd_no)%ipr,hice=GFS_Data(cdata%blk_no)%Sfcprop%hice, &
                  fice=GFS_Data(cdata%blk_no)%Sfcprop%fice,tice=GFS_Interstitial(cdata%thrd_no)%tice, &
                  weasd=GFS_Interstitial(cdata%thrd_no)%weasd_ice,tskin=GFS_Interstitial(cdata%thrd_no)%tsfc_ice, &
                  tprcp=GFS_Interstitial(cdata%thrd_no)%tprcp_ice,tiice=GFS_Data(cdata%blk_no)%Sfcprop%tiice, &
                  ep=GFS_Interstitial(cdata%thrd_no)%ep1d_ice,snwdph=GFS_Interstitial(cdata%thrd_no)%snowd_ice, &
                  qsurf=GFS_Interstitial(cdata%thrd_no)%qss_ice,snowmt=GFS_Interstitial(cdata%thrd_no)%snowmt, &
                  gflux=GFS_Interstitial(cdata%thrd_no)%gflx_ice,cmm=GFS_Interstitial(cdata%thrd_no)%cmm_ice, &
                  chh=GFS_Interstitial(cdata%thrd_no)%chh_ice,evap=GFS_Interstitial(cdata%thrd_no)%evap_ice, &
                  hflx=GFS_Interstitial(cdata%thrd_no)%hflx_ice,frac_grid=GFS_Control%frac_grid, &
                  icy=GFS_Interstitial(cdata%thrd_no)%icy,islmsk_cice=GFS_Interstitial(cdata%thrd_no)%islmsk_cice, &
                  min_lakeice=GFS_Control%min_lakeice,min_seaice=GFS_Control%min_seaice,oceanfrac=GFS_Data(cdata%blk_no)%Sfcprop%oceanfrac, &
                  errmsg=cdata%errmsg,errflg=cdata%errflg)



      if (cdata%errflg/=0) then
        cdata%errmsg = "An error occured in sfc_sice_run: " // trim(cdata%errmsg)
        ierr=cdata%errflg
        return
      end if

    
      


      call GFS_surface_loop_control_part2_run(im=GFS_Control%blksz(cdata%blk_no),iter=cdata%loop_cnt,wind=GFS_Interstitial(cdata%thrd_no)%wind, &
                  flag_guess=GFS_Interstitial(cdata%thrd_no)%flag_guess,flag_iter=GFS_Interstitial(cdata%thrd_no)%flag_iter, &
                  dry=GFS_Interstitial(cdata%thrd_no)%dry,wet=GFS_Interstitial(cdata%thrd_no)%wet, &
                  icy=GFS_Interstitial(cdata%thrd_no)%icy,nstf_name1=GFS_Control%nstf_name(1), &
                  errmsg=cdata%errmsg,errflg=cdata%errflg)



      if (cdata%errflg/=0) then
        cdata%errmsg = "An error occured in GFS_surface_loop_control_part2_run: " // trim(cdata%errmsg)
        ierr=cdata%errflg
        return
      end if

    
      end do
      end associate

      


      call GFS_surface_composites_post_run(im=GFS_Control%blksz(cdata%blk_no),kice=GFS_Control%kice,km=GFS_Control%lsoil, &
                  cplflx=GFS_Control%cplflx,cplwav2atm=GFS_Control%cplwav2atm,frac_grid=GFS_Control%frac_grid, &
                  flag_cice=GFS_Interstitial(cdata%thrd_no)%flag_cice,islmsk=GFS_Interstitial(cdata%thrd_no)%islmsk, &
                  dry=GFS_Interstitial(cdata%thrd_no)%dry,wet=GFS_Interstitial(cdata%thrd_no)%wet, &
                  icy=GFS_Interstitial(cdata%thrd_no)%icy,landfrac=GFS_Data(cdata%blk_no)%Sfcprop%landfrac, &
                  lakefrac=GFS_Data(cdata%blk_no)%Sfcprop%lakefrac,oceanfrac=GFS_Data(cdata%blk_no)%Sfcprop%oceanfrac, &
                  zorl=GFS_Data(cdata%blk_no)%Sfcprop%zorl,zorlo=GFS_Data(cdata%blk_no)%Sfcprop%zorlo, &
                  zorll=GFS_Data(cdata%blk_no)%Sfcprop%zorll,zorli=GFS_Data(cdata%blk_no)%Sfcprop%zorli, &
                  zorl_wat=GFS_Interstitial(cdata%thrd_no)%zorl_ocean,zorl_lnd=GFS_Interstitial(cdata%thrd_no)%zorl_land, &
                  zorl_ice=GFS_Interstitial(cdata%thrd_no)%zorl_ice,cd=GFS_Interstitial(cdata%thrd_no)%cd, &
                  cd_wat=GFS_Interstitial(cdata%thrd_no)%cd_ocean,cd_lnd=GFS_Interstitial(cdata%thrd_no)%cd_land, &
                  cd_ice=GFS_Interstitial(cdata%thrd_no)%cd_ice,cdq=GFS_Interstitial(cdata%thrd_no)%cdq, &
                  cdq_wat=GFS_Interstitial(cdata%thrd_no)%cdq_ocean,cdq_lnd=GFS_Interstitial(cdata%thrd_no)%cdq_land, &
                  cdq_ice=GFS_Interstitial(cdata%thrd_no)%cdq_ice,rb=GFS_Interstitial(cdata%thrd_no)%rb, &
                  rb_wat=GFS_Interstitial(cdata%thrd_no)%rb_ocean,rb_lnd=GFS_Interstitial(cdata%thrd_no)%rb_land, &
                  rb_ice=GFS_Interstitial(cdata%thrd_no)%rb_ice,stress=GFS_Interstitial(cdata%thrd_no)%stress, &
                  stress_wat=GFS_Interstitial(cdata%thrd_no)%stress_ocean,stress_lnd=GFS_Interstitial(cdata%thrd_no)%stress_land, &
                  stress_ice=GFS_Interstitial(cdata%thrd_no)%stress_ice,ffmm=GFS_Data(cdata%blk_no)%Sfcprop%ffmm, &
                  ffmm_wat=GFS_Interstitial(cdata%thrd_no)%ffmm_ocean,ffmm_lnd=GFS_Interstitial(cdata%thrd_no)%ffmm_land, &
                  ffmm_ice=GFS_Interstitial(cdata%thrd_no)%ffmm_ice,ffhh=GFS_Data(cdata%blk_no)%Sfcprop%ffhh, &
                  ffhh_wat=GFS_Interstitial(cdata%thrd_no)%ffhh_ocean,ffhh_lnd=GFS_Interstitial(cdata%thrd_no)%ffhh_land, &
                  ffhh_ice=GFS_Interstitial(cdata%thrd_no)%ffhh_ice,uustar=GFS_Data(cdata%blk_no)%Sfcprop%uustar, &
                  uustar_wat=GFS_Interstitial(cdata%thrd_no)%uustar_ocean,uustar_lnd=GFS_Interstitial(cdata%thrd_no)%uustar_land, &
                  uustar_ice=GFS_Interstitial(cdata%thrd_no)%uustar_ice,fm10=GFS_Interstitial(cdata%thrd_no)%fm10, &
                  fm10_wat=GFS_Interstitial(cdata%thrd_no)%fm10_ocean,fm10_lnd=GFS_Interstitial(cdata%thrd_no)%fm10_land, &
                  fm10_ice=GFS_Interstitial(cdata%thrd_no)%fm10_ice,fh2=GFS_Interstitial(cdata%thrd_no)%fh2, &
                  fh2_wat=GFS_Interstitial(cdata%thrd_no)%fh2_ocean,fh2_lnd=GFS_Interstitial(cdata%thrd_no)%fh2_land, &
                  fh2_ice=GFS_Interstitial(cdata%thrd_no)%fh2_ice,tsurf=GFS_Interstitial(cdata%thrd_no)%tsurf, &
                  tsurf_wat=GFS_Interstitial(cdata%thrd_no)%tsurf_ocean,tsurf_lnd=GFS_Interstitial(cdata%thrd_no)%tsurf_land, &
                  tsurf_ice=GFS_Interstitial(cdata%thrd_no)%tsurf_ice,cmm=GFS_Data(cdata%blk_no)%Intdiag%cmm, &
                  cmm_wat=GFS_Interstitial(cdata%thrd_no)%cmm_ocean,cmm_lnd=GFS_Interstitial(cdata%thrd_no)%cmm_land, &
                  cmm_ice=GFS_Interstitial(cdata%thrd_no)%cmm_ice,chh=GFS_Data(cdata%blk_no)%Intdiag%chh, &
                  chh_wat=GFS_Interstitial(cdata%thrd_no)%chh_ocean,chh_lnd=GFS_Interstitial(cdata%thrd_no)%chh_land, &
                  chh_ice=GFS_Interstitial(cdata%thrd_no)%chh_ice,gflx=GFS_Interstitial(cdata%thrd_no)%gflx, &
                  gflx_wat=GFS_Interstitial(cdata%thrd_no)%gflx_ocean,gflx_lnd=GFS_Interstitial(cdata%thrd_no)%gflx_land, &
                  gflx_ice=GFS_Interstitial(cdata%thrd_no)%gflx_ice,ep1d=GFS_Interstitial(cdata%thrd_no)%ep1d, &
                  ep1d_wat=GFS_Interstitial(cdata%thrd_no)%ep1d_ocean,ep1d_lnd=GFS_Interstitial(cdata%thrd_no)%ep1d_land, &
                  ep1d_ice=GFS_Interstitial(cdata%thrd_no)%ep1d_ice,weasd=GFS_Data(cdata%blk_no)%Sfcprop%weasd, &
                  weasd_wat=GFS_Interstitial(cdata%thrd_no)%weasd_ocean,weasd_lnd=GFS_Interstitial(cdata%thrd_no)%weasd_land, &
                  weasd_ice=GFS_Interstitial(cdata%thrd_no)%weasd_ice,snowd=GFS_Data(cdata%blk_no)%Sfcprop%snowd, &
                  snowd_wat=GFS_Interstitial(cdata%thrd_no)%snowd_ocean,snowd_lnd=GFS_Interstitial(cdata%thrd_no)%snowd_land, &
                  snowd_ice=GFS_Interstitial(cdata%thrd_no)%snowd_ice,tprcp=GFS_Data(cdata%blk_no)%Sfcprop%tprcp, &
                  tprcp_wat=GFS_Interstitial(cdata%thrd_no)%tprcp_ocean,tprcp_lnd=GFS_Interstitial(cdata%thrd_no)%tprcp_land, &
                  tprcp_ice=GFS_Interstitial(cdata%thrd_no)%tprcp_ice,evap=GFS_Data(cdata%blk_no)%Sfcprop%evap, &
                  evap_wat=GFS_Interstitial(cdata%thrd_no)%evap_ocean,evap_lnd=GFS_Interstitial(cdata%thrd_no)%evap_land, &
                  evap_ice=GFS_Interstitial(cdata%thrd_no)%evap_ice,hflx=GFS_Data(cdata%blk_no)%Sfcprop%hflx, &
                  hflx_wat=GFS_Interstitial(cdata%thrd_no)%hflx_ocean,hflx_lnd=GFS_Interstitial(cdata%thrd_no)%hflx_land, &
                  hflx_ice=GFS_Interstitial(cdata%thrd_no)%hflx_ice,qss=GFS_Data(cdata%blk_no)%Sfcprop%qss, &
                  qss_wat=GFS_Interstitial(cdata%thrd_no)%qss_ocean,qss_lnd=GFS_Interstitial(cdata%thrd_no)%qss_land, &
                  qss_ice=GFS_Interstitial(cdata%thrd_no)%qss_ice,tsfc=GFS_Data(cdata%blk_no)%Sfcprop%tsfc, &
                  tsfco=GFS_Data(cdata%blk_no)%Sfcprop%tsfco,tsfcl=GFS_Data(cdata%blk_no)%Sfcprop%tsfcl, &
                  tsfc_wat=GFS_Interstitial(cdata%thrd_no)%tsfc_ocean,tsfc_lnd=GFS_Interstitial(cdata%thrd_no)%tsfc_land, &
                  tsfc_ice=GFS_Interstitial(cdata%thrd_no)%tsfc_ice,tisfc=GFS_Data(cdata%blk_no)%Sfcprop%tisfc, &
                  tice=GFS_Interstitial(cdata%thrd_no)%tice,hice=GFS_Data(cdata%blk_no)%Sfcprop%hice, &
                  cice=GFS_Data(cdata%blk_no)%Sfcprop%fice,min_seaice=GFS_Control%min_seaice, &
                  tiice=GFS_Data(cdata%blk_no)%Sfcprop%tiice,stc=GFS_Data(cdata%blk_no)%Sfcprop%stc, &
                  errmsg=cdata%errmsg,errflg=cdata%errflg)



      if (cdata%errflg/=0) then
        cdata%errmsg = "An error occured in GFS_surface_composites_post_run: " // trim(cdata%errmsg)
        ierr=cdata%errflg
        return
      end if

    
      


      call sfc_diag_run(im=GFS_Control%blksz(cdata%blk_no),grav=con_g,cp=con_cp,eps=con_eps,epsm1=con_epsm1, &
                  ps=GFS_Data(cdata%blk_no)%Statein%pgr,u1=GFS_Data(cdata%blk_no)%Stateout%gu0(:,1), &
                  v1=GFS_Data(cdata%blk_no)%Stateout%gv0(:,1),t1=GFS_Data(cdata%blk_no)%Stateout%gt0(:,1), &
                  q1=GFS_Data(cdata%blk_no)%Stateout%gq0(:,1,GFS_Control%ntqv),prslki=GFS_Interstitial(cdata%thrd_no)%work3, &
                  evap=GFS_Data(cdata%blk_no)%Sfcprop%evap,fm=GFS_Data(cdata%blk_no)%Sfcprop%ffmm, &
                  fh=GFS_Data(cdata%blk_no)%Sfcprop%ffhh,fm10=GFS_Interstitial(cdata%thrd_no)%fm10, &
                  fh2=GFS_Interstitial(cdata%thrd_no)%fh2,tskin=GFS_Data(cdata%blk_no)%Sfcprop%tsfc, &
                  qsurf=GFS_Data(cdata%blk_no)%Sfcprop%qss,f10m=GFS_Data(cdata%blk_no)%Sfcprop%f10m, &
                  u10m=GFS_Data(cdata%blk_no)%Intdiag%u10m,v10m=GFS_Data(cdata%blk_no)%Intdiag%v10m, &
                  t2m=GFS_Data(cdata%blk_no)%Sfcprop%t2m,q2m=GFS_Data(cdata%blk_no)%Sfcprop%q2m, &
                  errmsg=cdata%errmsg,errflg=cdata%errflg)



      if (cdata%errflg/=0) then
        cdata%errmsg = "An error occured in sfc_diag_run: " // trim(cdata%errmsg)
        ierr=cdata%errflg
        return
      end if

    
      


      call sfc_diag_post_run(im=GFS_Control%blksz(cdata%blk_no),lsm=GFS_Control%lsm,lsm_noahmp=GFS_Control%lsm_noahmp, &
                  dry=GFS_Interstitial(cdata%thrd_no)%dry,lssav=GFS_Control%lssav,dtf=GFS_Control%dtf, &
                  con_eps=con_eps,con_epsm1=con_epsm1,pgr=GFS_Data(cdata%blk_no)%Statein%pgr, &
                  t2mmp=GFS_Interstitial(cdata%thrd_no)%t2mmp,q2mp=GFS_Interstitial(cdata%thrd_no)%q2mp, &
                  t2m=GFS_Data(cdata%blk_no)%Sfcprop%t2m,q2m=GFS_Data(cdata%blk_no)%Sfcprop%q2m, &
                  u10m=GFS_Data(cdata%blk_no)%Intdiag%u10m,v10m=GFS_Data(cdata%blk_no)%Intdiag%v10m, &
                  tmpmin=GFS_Data(cdata%blk_no)%Intdiag%tmpmin,tmpmax=GFS_Data(cdata%blk_no)%Intdiag%tmpmax, &
                  spfhmin=GFS_Data(cdata%blk_no)%Intdiag%spfhmin,spfhmax=GFS_Data(cdata%blk_no)%Intdiag%spfhmax, &
                  wind10mmax=GFS_Data(cdata%blk_no)%Intdiag%wind10mmax,u10mmax=GFS_Data(cdata%blk_no)%Intdiag%u10mmax, &
                  v10mmax=GFS_Data(cdata%blk_no)%Intdiag%v10mmax,dpt2m=GFS_Data(cdata%blk_no)%Intdiag%dpt2m, &
                  errmsg=cdata%errmsg,errflg=cdata%errflg)



      if (cdata%errflg/=0) then
        cdata%errmsg = "An error occured in sfc_diag_post_run: " // trim(cdata%errmsg)
        ierr=cdata%errflg
        return
      end if

    
      


      call GFS_surface_generic_post_run(im=GFS_Control%blksz(cdata%blk_no),cplflx=GFS_Control%cplflx,cplwav=GFS_Control%cplwav, &
                  lssav=GFS_Control%lssav,icy=GFS_Interstitial(cdata%thrd_no)%icy,wet=GFS_Interstitial(cdata%thrd_no)%wet, &
                  dtf=GFS_Control%dtf,ep1d=GFS_Interstitial(cdata%thrd_no)%ep1d,gflx=GFS_Interstitial(cdata%thrd_no)%gflx, &
                  tgrs_1=GFS_Data(cdata%blk_no)%Statein%tgrs(:,1),qgrs_1=GFS_Data(cdata%blk_no)%Statein%qgrs(:,1,GFS_Control%ntqv), &
                  ugrs_1=GFS_Data(cdata%blk_no)%Statein%ugrs(:,1),vgrs_1=GFS_Data(cdata%blk_no)%Statein%vgrs(:,1), &
                  adjsfcdlw=GFS_Data(cdata%blk_no)%Intdiag%dlwsfci,adjsfcdsw=GFS_Data(cdata%blk_no)%Intdiag%dswsfci, &
                  adjnirbmd=GFS_Interstitial(cdata%thrd_no)%adjnirbmd,adjnirdfd=GFS_Interstitial(cdata%thrd_no)%adjnirdfd, &
                  adjvisbmd=GFS_Interstitial(cdata%thrd_no)%adjvisbmd,adjvisdfd=GFS_Interstitial(cdata%thrd_no)%adjvisdfd, &
                  adjsfculw=GFS_Data(cdata%blk_no)%Intdiag%ulwsfci,adjsfculw_wat=GFS_Interstitial(cdata%thrd_no)%adjsfculw_ocean, &
                  adjnirbmu=GFS_Interstitial(cdata%thrd_no)%adjnirbmu,adjnirdfu=GFS_Interstitial(cdata%thrd_no)%adjnirdfu, &
                  adjvisbmu=GFS_Interstitial(cdata%thrd_no)%adjvisbmu,adjvisdfu=GFS_Interstitial(cdata%thrd_no)%adjvisdfu, &
                  t2m=GFS_Data(cdata%blk_no)%Sfcprop%t2m,q2m=GFS_Data(cdata%blk_no)%Sfcprop%q2m, &
                  u10m=GFS_Data(cdata%blk_no)%Intdiag%u10m,v10m=GFS_Data(cdata%blk_no)%Intdiag%v10m, &
                  tsfc=GFS_Data(cdata%blk_no)%Sfcprop%tsfc,tsfc_wat=GFS_Interstitial(cdata%thrd_no)%tsfc_ocean, &
                  pgr=GFS_Data(cdata%blk_no)%Statein%pgr,xcosz=GFS_Interstitial(cdata%thrd_no)%xcosz, &
                  evbs=GFS_Interstitial(cdata%thrd_no)%evbs,evcw=GFS_Interstitial(cdata%thrd_no)%evcw, &
                  trans=GFS_Interstitial(cdata%thrd_no)%trans,sbsno=GFS_Interstitial(cdata%thrd_no)%sbsno, &
                  snowc=GFS_Interstitial(cdata%thrd_no)%snowc,snohf=GFS_Interstitial(cdata%thrd_no)%snohf, &
                  epi=GFS_Data(cdata%blk_no)%Intdiag%epi,gfluxi=GFS_Data(cdata%blk_no)%Intdiag%gfluxi, &
                  t1=GFS_Data(cdata%blk_no)%Intdiag%t1,q1=GFS_Data(cdata%blk_no)%Intdiag%q1, &
                  u1=GFS_Data(cdata%blk_no)%Intdiag%u1,v1=GFS_Data(cdata%blk_no)%Intdiag%v1, &
                  dlwsfci_cpl=GFS_Data(cdata%blk_no)%Coupling%dlwsfci_cpl,dswsfci_cpl=GFS_Data(cdata%blk_no)%Coupling%dswsfci_cpl, &
                  dlwsfc_cpl=GFS_Data(cdata%blk_no)%Coupling%dlwsfc_cpl,dswsfc_cpl=GFS_Data(cdata%blk_no)%Coupling%dswsfc_cpl, &
                  dnirbmi_cpl=GFS_Data(cdata%blk_no)%Coupling%dnirbmi_cpl,dnirdfi_cpl=GFS_Data(cdata%blk_no)%Coupling%dnirdfi_cpl, &
                  dvisbmi_cpl=GFS_Data(cdata%blk_no)%Coupling%dvisbmi_cpl,dvisdfi_cpl=GFS_Data(cdata%blk_no)%Coupling%dvisdfi_cpl, &
                  dnirbm_cpl=GFS_Data(cdata%blk_no)%Coupling%dnirbm_cpl,dnirdf_cpl=GFS_Data(cdata%blk_no)%Coupling%dnirdf_cpl, &
                  dvisbm_cpl=GFS_Data(cdata%blk_no)%Coupling%dvisbm_cpl,dvisdf_cpl=GFS_Data(cdata%blk_no)%Coupling%dvisdf_cpl, &
                  nlwsfci_cpl=GFS_Data(cdata%blk_no)%Coupling%nlwsfci_cpl,nlwsfc_cpl=GFS_Data(cdata%blk_no)%Coupling%nlwsfc_cpl, &
                  t2mi_cpl=GFS_Data(cdata%blk_no)%Coupling%t2mi_cpl,q2mi_cpl=GFS_Data(cdata%blk_no)%Coupling%q2mi_cpl, &
                  u10mi_cpl=GFS_Data(cdata%blk_no)%Coupling%u10mi_cpl,v10mi_cpl=GFS_Data(cdata%blk_no)%Coupling%v10mi_cpl, &
                  tsfci_cpl=GFS_Data(cdata%blk_no)%Coupling%tsfci_cpl,psurfi_cpl=GFS_Data(cdata%blk_no)%Coupling%psurfi_cpl, &
                  nnirbmi_cpl=GFS_Data(cdata%blk_no)%Coupling%nnirbmi_cpl,nnirdfi_cpl=GFS_Data(cdata%blk_no)%Coupling%nnirdfi_cpl, &
                  nvisbmi_cpl=GFS_Data(cdata%blk_no)%Coupling%nvisbmi_cpl,nvisdfi_cpl=GFS_Data(cdata%blk_no)%Coupling%nvisdfi_cpl, &
                  nswsfci_cpl=GFS_Data(cdata%blk_no)%Coupling%nswsfci_cpl,nswsfc_cpl=GFS_Data(cdata%blk_no)%Coupling%nswsfc_cpl, &
                  nnirbm_cpl=GFS_Data(cdata%blk_no)%Coupling%nnirbm_cpl,nnirdf_cpl=GFS_Data(cdata%blk_no)%Coupling%nnirdf_cpl, &
                  nvisbm_cpl=GFS_Data(cdata%blk_no)%Coupling%nvisbm_cpl,nvisdf_cpl=GFS_Data(cdata%blk_no)%Coupling%nvisdf_cpl, &
                  gflux=GFS_Data(cdata%blk_no)%Intdiag%gflux,evbsa=GFS_Data(cdata%blk_no)%Intdiag%evbsa, &
                  evcwa=GFS_Data(cdata%blk_no)%Intdiag%evcwa,transa=GFS_Data(cdata%blk_no)%Intdiag%transa, &
                  sbsnoa=GFS_Data(cdata%blk_no)%Intdiag%sbsnoa,snowca=GFS_Data(cdata%blk_no)%Intdiag%snowca, &
                  snohfa=GFS_Data(cdata%blk_no)%Intdiag%snohfa,ep=GFS_Data(cdata%blk_no)%Intdiag%ep, &
                  runoff=GFS_Data(cdata%blk_no)%Intdiag%runoff,srunoff=GFS_Data(cdata%blk_no)%Intdiag%srunoff, &
                  runof=GFS_Interstitial(cdata%thrd_no)%runoff,drain=GFS_Interstitial(cdata%thrd_no)%drain, &
                  lheatstrg=GFS_Control%lheatstrg,z0fac=GFS_Control%z0fac,e0fac=GFS_Control%e0fac, &
                  zorl=GFS_Data(cdata%blk_no)%Sfcprop%zorl,hflx=GFS_Data(cdata%blk_no)%Sfcprop%hflx, &
                  evap=GFS_Data(cdata%blk_no)%Sfcprop%evap,hflxq=GFS_Interstitial(cdata%thrd_no)%hflxq, &
                  evapq=GFS_Interstitial(cdata%thrd_no)%evapq,hefac=GFS_Interstitial(cdata%thrd_no)%hefac, &
                  hffac=GFS_Interstitial(cdata%thrd_no)%hffac,errmsg=cdata%errmsg,errflg=cdata%errflg)



      if (cdata%errflg/=0) then
        cdata%errmsg = "An error occured in GFS_surface_generic_post_run: " // trim(cdata%errmsg)
        ierr=cdata%errflg
        return
      end if

    
      


      call GFS_PBL_generic_pre_run(im=GFS_Control%blksz(cdata%blk_no),levs=GFS_Control%levs,nvdiff=GFS_Interstitial(cdata%thrd_no)%nvdiff, &
                  ntrac=GFS_Control%ntrac,ntqv=GFS_Control%ntqv,ntcw=GFS_Control%ntcw,ntiw=GFS_Control%ntiw, &
                  ntrw=GFS_Control%ntrw,ntsw=GFS_Control%ntsw,ntlnc=GFS_Control%ntlnc,ntinc=GFS_Control%ntinc, &
                  ntrnc=GFS_Control%ntrnc,ntsnc=GFS_Control%ntsnc,ntgnc=GFS_Control%ntgnc, &
                  ntwa=GFS_Control%ntwa,ntia=GFS_Control%ntia,ntgl=GFS_Control%ntgl,ntoz=GFS_Control%ntoz, &
                  ntke=GFS_Control%ntke,ntkev=GFS_Interstitial(cdata%thrd_no)%ntkev,nqrimef=GFS_Control%nqrimef, &
                  trans_aero=GFS_Interstitial(cdata%thrd_no)%trans_aero,ntchs=GFS_Control%ntchs, &
                  ntchm=GFS_Control%ntchm,imp_physics=GFS_Control%imp_physics,imp_physics_gfdl=GFS_Control%imp_physics_gfdl, &
                  imp_physics_thompson=GFS_Control%imp_physics_thompson,imp_physics_wsm6=GFS_Control%imp_physics_wsm6, &
                  imp_physics_zhao_carr=GFS_Control%imp_physics_zhao_carr,imp_physics_mg=GFS_Control%imp_physics_mg, &
                  imp_physics_fer_hires=GFS_Control%imp_physics_fer_hires,cplchm=GFS_Control%cplchm, &
                  ltaerosol=GFS_Control%ltaerosol,hybedmf=GFS_Control%hybedmf,do_shoc=GFS_Control%do_shoc, &
                  satmedmf=GFS_Control%satmedmf,qgrs=GFS_Data(cdata%blk_no)%Statein%qgrs, &
                  vdftra=GFS_Interstitial(cdata%thrd_no)%vdftra,save_u=GFS_Interstitial(cdata%thrd_no)%save_u, &
                  save_v=GFS_Interstitial(cdata%thrd_no)%save_v,save_t=GFS_Interstitial(cdata%thrd_no)%save_t, &
                  save_q=GFS_Interstitial(cdata%thrd_no)%save_q,ldiag3d=GFS_Control%ldiag3d, &
                  qdiag3d=GFS_Control%qdiag3d,lssav=GFS_Control%lssav,ugrs=GFS_Data(cdata%blk_no)%Statein%ugrs, &
                  vgrs=GFS_Data(cdata%blk_no)%Statein%vgrs,tgrs=GFS_Data(cdata%blk_no)%Statein%tgrs, &
                  errmsg=cdata%errmsg,errflg=cdata%errflg)



      if (cdata%errflg/=0) then
        cdata%errmsg = "An error occured in GFS_PBL_generic_pre_run: " // trim(cdata%errmsg)
        ierr=cdata%errflg
        return
      end if

    
      


      call hedmf_run(im=GFS_Control%blksz(cdata%blk_no),km=GFS_Control%levs,ntrac=GFS_Interstitial(cdata%thrd_no)%nvdiff, &
                  ntcw=GFS_Control%ntcw,dv=GFS_Interstitial(cdata%thrd_no)%dvdt,du=GFS_Interstitial(cdata%thrd_no)%dudt, &
                  tau=GFS_Interstitial(cdata%thrd_no)%dtdt,rtg=GFS_Interstitial(cdata%thrd_no)%dvdftra, &
                  u1=GFS_Data(cdata%blk_no)%Statein%ugrs,v1=GFS_Data(cdata%blk_no)%Statein%vgrs, &
                  t1=GFS_Data(cdata%blk_no)%Statein%tgrs,q1=GFS_Interstitial(cdata%thrd_no)%vdftra, &
                  swh=GFS_Data(cdata%blk_no)%Radtend%htrsw,hlw=GFS_Data(cdata%blk_no)%Radtend%htrlw, &
                  xmu=GFS_Interstitial(cdata%thrd_no)%xmu,psk=GFS_Data(cdata%blk_no)%Statein%prsik(:,1), &
                  rbsoil=GFS_Interstitial(cdata%thrd_no)%rb,zorl=GFS_Data(cdata%blk_no)%Sfcprop%zorl, &
                  u10m=GFS_Data(cdata%blk_no)%Intdiag%u10m,v10m=GFS_Data(cdata%blk_no)%Intdiag%v10m, &
                  fm=GFS_Data(cdata%blk_no)%Sfcprop%ffmm,fh=GFS_Data(cdata%blk_no)%Sfcprop%ffhh, &
                  tsea=GFS_Data(cdata%blk_no)%Sfcprop%tsfc,heat=GFS_Interstitial(cdata%thrd_no)%hflxq, &
                  evap=GFS_Interstitial(cdata%thrd_no)%evapq,stress=GFS_Interstitial(cdata%thrd_no)%stress, &
                  spd1=GFS_Interstitial(cdata%thrd_no)%wind,kpbl=GFS_Interstitial(cdata%thrd_no)%kpbl, &
                  prsi=GFS_Data(cdata%blk_no)%Statein%prsi,del=GFS_Interstitial(cdata%thrd_no)%del, &
                  prsl=GFS_Data(cdata%blk_no)%Statein%prsl,prslk=GFS_Data(cdata%blk_no)%Statein%prslk, &
                  phii=GFS_Data(cdata%blk_no)%Statein%phii,phil=GFS_Data(cdata%blk_no)%Statein%phil, &
                  delt=GFS_Control%dtp,dspheat=GFS_Control%dspheat,dusfc=GFS_Interstitial(cdata%thrd_no)%dusfc1, &
                  dvsfc=GFS_Interstitial(cdata%thrd_no)%dvsfc1,dtsfc=GFS_Interstitial(cdata%thrd_no)%dtsfc1, &
                  dqsfc=GFS_Interstitial(cdata%thrd_no)%dqsfc1,hpbl=GFS_Data(cdata%blk_no)%Tbd%hpbl, &
                  hgamt=GFS_Interstitial(cdata%thrd_no)%gamt,hgamq=GFS_Interstitial(cdata%thrd_no)%gamq, &
                  dkt=GFS_Interstitial(cdata%thrd_no)%dkt,kinver=GFS_Interstitial(cdata%thrd_no)%kinver, &
                  xkzm_m=GFS_Control%xkzm_m,xkzm_h=GFS_Control%xkzm_h,xkzm_s=GFS_Control%xkzm_s, &
                  lprnt=GFS_Control%lprnt,ipr=GFS_Interstitial(cdata%thrd_no)%ipr,xkzminv=GFS_Control%xkzminv, &
                  moninq_fac=GFS_Control%moninq_fac,lssav=GFS_Control%lssav,ldiag3d=GFS_Control%ldiag3d, &
                  qdiag3d=GFS_Control%qdiag3d,ntoz=GFS_Control%ntoz,du3dt_PBL=GFS_Data(cdata%blk_no)%Intdiag%du3dt(:,:,1), &
                  dv3dt_PBL=GFS_Data(cdata%blk_no)%Intdiag%dv3dt(:,:,1),dt3dt_PBL=GFS_Data(cdata%blk_no)%Intdiag%dt3dt(:,:,3), &
                  dq3dt_PBL=GFS_Data(cdata%blk_no)%Intdiag%dq3dt(:,:,1),do3dt_PBL=GFS_Data(cdata%blk_no)%Intdiag%dq3dt(:,:,5), &
                  flag_for_pbl_generic_tend=GFS_Control%flag_for_pbl_generic_tend,errmsg=cdata%errmsg, &
                  errflg=cdata%errflg)



      if (cdata%errflg/=0) then
        cdata%errmsg = "An error occured in hedmf_run: " // trim(cdata%errmsg)
        ierr=cdata%errflg
        return
      end if

    
      


      call GFS_PBL_generic_post_run(im=GFS_Control%blksz(cdata%blk_no),levs=GFS_Control%levs,nvdiff=GFS_Interstitial(cdata%thrd_no)%nvdiff, &
                  ntrac=GFS_Control%ntrac,ntqv=GFS_Control%ntqv,ntcw=GFS_Control%ntcw,ntiw=GFS_Control%ntiw, &
                  ntrw=GFS_Control%ntrw,ntsw=GFS_Control%ntsw,ntlnc=GFS_Control%ntlnc,ntinc=GFS_Control%ntinc, &
                  ntrnc=GFS_Control%ntrnc,ntsnc=GFS_Control%ntsnc,ntgnc=GFS_Control%ntgnc, &
                  ntwa=GFS_Control%ntwa,ntia=GFS_Control%ntia,ntgl=GFS_Control%ntgl,ntoz=GFS_Control%ntoz, &
                  ntke=GFS_Control%ntke,ntkev=GFS_Interstitial(cdata%thrd_no)%ntkev,nqrimef=GFS_Control%nqrimef, &
                  trans_aero=GFS_Interstitial(cdata%thrd_no)%trans_aero,ntchs=GFS_Control%ntchs, &
                  ntchm=GFS_Control%ntchm,imp_physics=GFS_Control%imp_physics,imp_physics_gfdl=GFS_Control%imp_physics_gfdl, &
                  imp_physics_thompson=GFS_Control%imp_physics_thompson,imp_physics_wsm6=GFS_Control%imp_physics_wsm6, &
                  imp_physics_zhao_carr=GFS_Control%imp_physics_zhao_carr,imp_physics_mg=GFS_Control%imp_physics_mg, &
                  imp_physics_fer_hires=GFS_Control%imp_physics_fer_hires,ltaerosol=GFS_Control%ltaerosol, &
                  cplflx=GFS_Control%cplflx,cplchm=GFS_Control%cplchm,lssav=GFS_Control%lssav, &
                  flag_for_pbl_generic_tend=GFS_Control%flag_for_pbl_generic_tend,ldiag3d=GFS_Control%ldiag3d, &
                  qdiag3d=GFS_Control%qdiag3d,lsidea=GFS_Control%lsidea,hybedmf=GFS_Control%hybedmf, &
                  do_shoc=GFS_Control%do_shoc,satmedmf=GFS_Control%satmedmf,shinhong=GFS_Control%shinhong, &
                  do_ysu=GFS_Control%do_ysu,dvdftra=GFS_Interstitial(cdata%thrd_no)%dvdftra, &
                  dusfc1=GFS_Interstitial(cdata%thrd_no)%dusfc1,dvsfc1=GFS_Interstitial(cdata%thrd_no)%dvsfc1, &
                  dtsfc1=GFS_Interstitial(cdata%thrd_no)%dtsfc1,dqsfc1=GFS_Interstitial(cdata%thrd_no)%dqsfc1, &
                  dtf=GFS_Control%dtf,dudt=GFS_Interstitial(cdata%thrd_no)%dudt,dvdt=GFS_Interstitial(cdata%thrd_no)%dvdt, &
                  dtdt=GFS_Interstitial(cdata%thrd_no)%dtdt,htrsw=GFS_Data(cdata%blk_no)%Radtend%htrsw, &
                  htrlw=GFS_Data(cdata%blk_no)%Radtend%htrlw,xmu=GFS_Interstitial(cdata%thrd_no)%xmu, &
                  dqdt=GFS_Interstitial(cdata%thrd_no)%dqdt,dusfc_cpl=GFS_Data(cdata%blk_no)%Coupling%dusfc_cpl, &
                  dvsfc_cpl=GFS_Data(cdata%blk_no)%Coupling%dvsfc_cpl,dtsfc_cpl=GFS_Data(cdata%blk_no)%Coupling%dtsfc_cpl, &
                  dqsfc_cpl=GFS_Data(cdata%blk_no)%Coupling%dqsfc_cpl,dusfci_cpl=GFS_Data(cdata%blk_no)%Coupling%dusfci_cpl, &
                  dvsfci_cpl=GFS_Data(cdata%blk_no)%Coupling%dvsfci_cpl,dtsfci_cpl=GFS_Data(cdata%blk_no)%Coupling%dtsfci_cpl, &
                  dqsfci_cpl=GFS_Data(cdata%blk_no)%Coupling%dqsfci_cpl,dusfc_diag=GFS_Data(cdata%blk_no)%Intdiag%dusfc, &
                  dvsfc_diag=GFS_Data(cdata%blk_no)%Intdiag%dvsfc,dtsfc_diag=GFS_Data(cdata%blk_no)%Intdiag%dtsfc, &
                  dqsfc_diag=GFS_Data(cdata%blk_no)%Intdiag%dqsfc,dusfci_diag=GFS_Data(cdata%blk_no)%Intdiag%dusfci, &
                  dvsfci_diag=GFS_Data(cdata%blk_no)%Intdiag%dvsfci,dtsfci_diag=GFS_Data(cdata%blk_no)%Intdiag%dtsfci, &
                  dqsfci_diag=GFS_Data(cdata%blk_no)%Intdiag%dqsfci,dt3dt=GFS_Data(cdata%blk_no)%Intdiag%dt3dt(:,:,3), &
                  du3dt_PBL=GFS_Data(cdata%blk_no)%Intdiag%du3dt(:,:,1),du3dt_OGWD=GFS_Data(cdata%blk_no)%Intdiag%du3dt(:,:,2), &
                  dv3dt_PBL=GFS_Data(cdata%blk_no)%Intdiag%dv3dt(:,:,1),dv3dt_OGWD=GFS_Data(cdata%blk_no)%Intdiag%dv3dt(:,:,2), &
                  dq3dt=GFS_Data(cdata%blk_no)%Intdiag%dq3dt(:,:,1),dq3dt_ozone=GFS_Data(cdata%blk_no)%Intdiag%dq3dt(:,:,5), &
                  rd=con_rd,cp=con_cp,fvirt=con_fvirt,hvap=con_hvap,t1=GFS_Data(cdata%blk_no)%Intdiag%t1, &
                  q1=GFS_Data(cdata%blk_no)%Intdiag%q1,prsl=GFS_Data(cdata%blk_no)%Statein%prsl, &
                  hflx=GFS_Data(cdata%blk_no)%Sfcprop%hflx,ushfsfci=GFS_Data(cdata%blk_no)%Coupling%ushfsfci, &
                  oceanfrac=GFS_Data(cdata%blk_no)%Sfcprop%oceanfrac,flag_cice=GFS_Interstitial(cdata%thrd_no)%flag_cice, &
                  dusfc_cice=GFS_Data(cdata%blk_no)%Coupling%dusfcin_cpl,dvsfc_cice=GFS_Data(cdata%blk_no)%Coupling%dvsfcin_cpl, &
                  dtsfc_cice=GFS_Data(cdata%blk_no)%Coupling%dtsfcin_cpl,dqsfc_cice=GFS_Data(cdata%blk_no)%Coupling%dqsfcin_cpl, &
                  wet=GFS_Interstitial(cdata%thrd_no)%wet,dry=GFS_Interstitial(cdata%thrd_no)%dry, &
                  icy=GFS_Interstitial(cdata%thrd_no)%icy,wind=GFS_Interstitial(cdata%thrd_no)%wind, &
                  stress_wat=GFS_Interstitial(cdata%thrd_no)%stress_ocean,hflx_wat=GFS_Interstitial(cdata%thrd_no)%hflx_ocean, &
                  evap_wat=GFS_Interstitial(cdata%thrd_no)%evap_ocean,ugrs1=GFS_Data(cdata%blk_no)%Statein%ugrs(:,1), &
                  vgrs1=GFS_Data(cdata%blk_no)%Statein%vgrs(:,1),dkt_cpl=GFS_Data(cdata%blk_no)%Coupling%dkt, &
                  dkt=GFS_Interstitial(cdata%thrd_no)%dkt,hefac=GFS_Interstitial(cdata%thrd_no)%hefac, &
                  hffac=GFS_Interstitial(cdata%thrd_no)%hffac,ugrs=GFS_Data(cdata%blk_no)%Statein%ugrs, &
                  vgrs=GFS_Data(cdata%blk_no)%Statein%vgrs,tgrs=GFS_Data(cdata%blk_no)%Statein%tgrs, &
                  qgrs=GFS_Data(cdata%blk_no)%Statein%qgrs,save_u=GFS_Interstitial(cdata%thrd_no)%save_u, &
                  save_v=GFS_Interstitial(cdata%thrd_no)%save_v,save_t=GFS_Interstitial(cdata%thrd_no)%save_t, &
                  save_q=GFS_Interstitial(cdata%thrd_no)%save_q,errmsg=cdata%errmsg,errflg=cdata%errflg)



      if (cdata%errflg/=0) then
        cdata%errmsg = "An error occured in GFS_PBL_generic_post_run: " // trim(cdata%errmsg)
        ierr=cdata%errflg
        return
      end if

    
      


      call GFS_GWD_generic_pre_run(im=GFS_Control%blksz(cdata%blk_no),levs=GFS_Control%levs,nmtvr=GFS_Control%nmtvr, &
                  mntvar=GFS_Data(cdata%blk_no)%Sfcprop%hprime,oc=GFS_Interstitial(cdata%thrd_no)%oc, &
                  oa4=GFS_Interstitial(cdata%thrd_no)%oa4,clx=GFS_Interstitial(cdata%thrd_no)%clx, &
                  theta=GFS_Interstitial(cdata%thrd_no)%theta,varss=GFS_Interstitial(cdata%thrd_no)%varss, &
                  ocss=GFS_Interstitial(cdata%thrd_no)%ocss,oa4ss=GFS_Interstitial(cdata%thrd_no)%oa4ss, &
                  clxss=GFS_Interstitial(cdata%thrd_no)%clxss,sigma=GFS_Interstitial(cdata%thrd_no)%sigma, &
                  gamma=GFS_Interstitial(cdata%thrd_no)%gamma,elvmax=GFS_Interstitial(cdata%thrd_no)%elvmax, &
                  lssav=GFS_Control%lssav,ldiag3d=GFS_Control%ldiag3d,dudt=GFS_Interstitial(cdata%thrd_no)%dudt, &
                  dvdt=GFS_Interstitial(cdata%thrd_no)%dvdt,dtdt=GFS_Interstitial(cdata%thrd_no)%dtdt, &
                  du3dt=GFS_Data(cdata%blk_no)%Intdiag%du3dt(:,:,2),dv3dt=GFS_Data(cdata%blk_no)%Intdiag%dv3dt(:,:,2), &
                  dt3dt=GFS_Data(cdata%blk_no)%Intdiag%dt3dt(:,:,7),dtf=GFS_Control%dtf,flag_for_gwd_generic_tend=GFS_Control%flag_for_gwd_generic_tend, &
                  errmsg=cdata%errmsg,errflg=cdata%errflg)



      if (cdata%errflg/=0) then
        cdata%errmsg = "An error occured in GFS_GWD_generic_pre_run: " // trim(cdata%errmsg)
        ierr=cdata%errflg
        return
      end if

    
      


      call cires_ugwp_run(do_ugwp=GFS_Control%do_ugwp,me=GFS_Control%me,master=GFS_Control%master, &
                  im=GFS_Control%blksz(cdata%blk_no),levs=GFS_Control%levs,ntrac=GFS_Control%ntrac, &
                  dtp=GFS_Control%dtp,kdt=GFS_Control%kdt,lonr=GFS_Control%lonr,oro=GFS_Data(cdata%blk_no)%Sfcprop%oro, &
                  oro_uf=GFS_Data(cdata%blk_no)%Sfcprop%oro_uf,hprime=GFS_Data(cdata%blk_no)%Sfcprop%hprime(:,1), &
                  nmtvr=GFS_Control%nmtvr,oc=GFS_Interstitial(cdata%thrd_no)%oc,theta=GFS_Interstitial(cdata%thrd_no)%theta, &
                  sigma=GFS_Interstitial(cdata%thrd_no)%sigma,gamma=GFS_Interstitial(cdata%thrd_no)%gamma, &
                  elvmax=GFS_Interstitial(cdata%thrd_no)%elvmax,clx=GFS_Interstitial(cdata%thrd_no)%clx, &
                  oa4=GFS_Interstitial(cdata%thrd_no)%oa4,do_tofd=GFS_Control%do_tofd,ldiag_ugwp=GFS_Control%ldiag_ugwp, &
                  cdmbgwd=GFS_Control%cdmbgwd,xlat=GFS_Data(cdata%blk_no)%Grid%xlat,xlat_d=GFS_Data(cdata%blk_no)%Grid%xlat_d, &
                  sinlat=GFS_Data(cdata%blk_no)%Grid%sinlat,coslat=GFS_Data(cdata%blk_no)%Grid%coslat, &
                  area=GFS_Data(cdata%blk_no)%Grid%area,ugrs=GFS_Data(cdata%blk_no)%Statein%ugrs, &
                  vgrs=GFS_Data(cdata%blk_no)%Statein%vgrs,tgrs=GFS_Data(cdata%blk_no)%Statein%tgrs, &
                  qgrs=GFS_Data(cdata%blk_no)%Statein%qgrs,prsi=GFS_Data(cdata%blk_no)%Statein%prsi, &
                  prsl=GFS_Data(cdata%blk_no)%Statein%prsl,prslk=GFS_Data(cdata%blk_no)%Statein%prslk, &
                  phii=GFS_Data(cdata%blk_no)%Statein%phii,phil=GFS_Data(cdata%blk_no)%Statein%phil, &
                  del=GFS_Interstitial(cdata%thrd_no)%del,kpbl=GFS_Interstitial(cdata%thrd_no)%kpbl, &
                  dusfcg=GFS_Interstitial(cdata%thrd_no)%dusfcg,dvsfcg=GFS_Interstitial(cdata%thrd_no)%dvsfcg, &
                  gw_dudt=GFS_Interstitial(cdata%thrd_no)%gw_dudt,gw_dvdt=GFS_Interstitial(cdata%thrd_no)%gw_dvdt, &
                  gw_dtdt=GFS_Interstitial(cdata%thrd_no)%gw_dtdt,gw_kdis=GFS_Interstitial(cdata%thrd_no)%gw_kdis, &
                  tau_tofd=GFS_Interstitial(cdata%thrd_no)%tau_tofd,tau_mtb=GFS_Interstitial(cdata%thrd_no)%tau_mtb, &
                  tau_ogw=GFS_Interstitial(cdata%thrd_no)%tau_ogw,tau_ngw=GFS_Interstitial(cdata%thrd_no)%tau_ngw, &
                  zmtb=GFS_Interstitial(cdata%thrd_no)%zmtb,zlwb=GFS_Interstitial(cdata%thrd_no)%zlwb, &
                  zogw=GFS_Interstitial(cdata%thrd_no)%zogw,dudt_mtb=GFS_Interstitial(cdata%thrd_no)%dudt_mtb, &
                  dudt_ogw=GFS_Interstitial(cdata%thrd_no)%dudt_ogw,dudt_tms=GFS_Interstitial(cdata%thrd_no)%dudt_tms, &
                  du3dt_mtb=GFS_Data(cdata%blk_no)%Intdiag%du3dt_mtb,du3dt_ogw=GFS_Data(cdata%blk_no)%Intdiag%du3dt_ogw, &
                  du3dt_tms=GFS_Data(cdata%blk_no)%Intdiag%du3dt_tms,dudt=GFS_Interstitial(cdata%thrd_no)%dudt, &
                  dvdt=GFS_Interstitial(cdata%thrd_no)%dvdt,dtdt=GFS_Interstitial(cdata%thrd_no)%dtdt, &
                  rdxzb=GFS_Data(cdata%blk_no)%Intdiag%zmtnblck,con_g=con_g,con_pi=con_pi, &
                  con_cp=con_cp,con_rd=con_rd,con_rv=con_rv,con_fvirt=con_fvirt,rain=GFS_Data(cdata%blk_no)%Intdiag%rain, &
                  ntke=GFS_Control%ntke,q_tke=GFS_Data(cdata%blk_no)%Statein%qgrs(:,:,GFS_Control%ntke), &
                  dqdt_tke=GFS_Interstitial(cdata%thrd_no)%dqdt(:,:,GFS_Control%ntke),lprnt=GFS_Control%lprnt, &
                  ipr=GFS_Interstitial(cdata%thrd_no)%ipr,ldu3dt_ogw=GFS_Data(cdata%blk_no)%Intdiag%du3dt(:,:,2), &
                  ldv3dt_ogw=GFS_Data(cdata%blk_no)%Intdiag%dv3dt(:,:,2),ldt3dt_ogw=GFS_Data(cdata%blk_no)%Intdiag%dt3dt(:,:,7), &
                  ldu3dt_cgw=GFS_Data(cdata%blk_no)%Intdiag%du3dt(:,:,4),ldv3dt_cgw=GFS_Data(cdata%blk_no)%Intdiag%dv3dt(:,:,4), &
                  ldt3dt_cgw=GFS_Data(cdata%blk_no)%Intdiag%dt3dt(:,:,9),ldiag3d=GFS_Control%ldiag3d, &
                  lssav=GFS_Control%lssav,flag_for_gwd_generic_tend=GFS_Control%flag_for_gwd_generic_tend, &
                  errmsg=cdata%errmsg,errflg=cdata%errflg)



      if (cdata%errflg/=0) then
        cdata%errmsg = "An error occured in cires_ugwp_run: " // trim(cdata%errmsg)
        ierr=cdata%errflg
        return
      end if

    
      


      call cires_ugwp_post_run(ldiag_ugwp=GFS_Control%ldiag_ugwp,dtf=GFS_Control%dtf,im=GFS_Control%blksz(cdata%blk_no), &
                  levs=GFS_Control%levs,gw_dtdt=GFS_Interstitial(cdata%thrd_no)%gw_dtdt,gw_dudt=GFS_Interstitial(cdata%thrd_no)%gw_dudt, &
                  gw_dvdt=GFS_Interstitial(cdata%thrd_no)%gw_dvdt,tau_tofd=GFS_Interstitial(cdata%thrd_no)%tau_tofd, &
                  tau_mtb=GFS_Interstitial(cdata%thrd_no)%tau_mtb,tau_ogw=GFS_Interstitial(cdata%thrd_no)%tau_ogw, &
                  tau_ngw=GFS_Interstitial(cdata%thrd_no)%tau_ngw,zmtb=GFS_Interstitial(cdata%thrd_no)%zmtb, &
                  zlwb=GFS_Interstitial(cdata%thrd_no)%zlwb,zogw=GFS_Interstitial(cdata%thrd_no)%zogw, &
                  dudt_mtb=GFS_Interstitial(cdata%thrd_no)%dudt_mtb,dudt_ogw=GFS_Interstitial(cdata%thrd_no)%dudt_ogw, &
                  dudt_tms=GFS_Interstitial(cdata%thrd_no)%dudt_tms,tot_zmtb=GFS_Data(cdata%blk_no)%Intdiag%zmtb, &
                  tot_zlwb=GFS_Data(cdata%blk_no)%Intdiag%zlwb,tot_zogw=GFS_Data(cdata%blk_no)%Intdiag%zogw, &
                  tot_tofd=GFS_Data(cdata%blk_no)%Intdiag%tau_tofd,tot_mtb=GFS_Data(cdata%blk_no)%Intdiag%tau_mtb, &
                  tot_ogw=GFS_Data(cdata%blk_no)%Intdiag%tau_ogw,tot_ngw=GFS_Data(cdata%blk_no)%Intdiag%tau_ngw, &
                  du3dt_mtb=GFS_Data(cdata%blk_no)%Intdiag%du3dt_mtb,du3dt_ogw=GFS_Data(cdata%blk_no)%Intdiag%du3dt_ogw, &
                  du3dt_tms=GFS_Data(cdata%blk_no)%Intdiag%du3dt_tms,du3dt_ngw=GFS_Data(cdata%blk_no)%Intdiag%du3dt_ngw, &
                  dv3dt_ngw=GFS_Data(cdata%blk_no)%Intdiag%dv3dt_ngw,dtdt=GFS_Interstitial(cdata%thrd_no)%dtdt, &
                  dudt=GFS_Interstitial(cdata%thrd_no)%dudt,dvdt=GFS_Interstitial(cdata%thrd_no)%dvdt, &
                  errmsg=cdata%errmsg,errflg=cdata%errflg)



      if (cdata%errflg/=0) then
        cdata%errmsg = "An error occured in cires_ugwp_post_run: " // trim(cdata%errmsg)
        ierr=cdata%errflg
        return
      end if

    
      


      call GFS_GWD_generic_post_run(lssav=GFS_Control%lssav,ldiag3d=GFS_Control%ldiag3d,dtf=GFS_Control%dtf, &
                  dusfcg=GFS_Interstitial(cdata%thrd_no)%dusfcg,dvsfcg=GFS_Interstitial(cdata%thrd_no)%dvsfcg, &
                  dudt=GFS_Interstitial(cdata%thrd_no)%dudt,dvdt=GFS_Interstitial(cdata%thrd_no)%dvdt, &
                  dtdt=GFS_Interstitial(cdata%thrd_no)%dtdt,dugwd=GFS_Data(cdata%blk_no)%Intdiag%dugwd, &
                  dvgwd=GFS_Data(cdata%blk_no)%Intdiag%dvgwd,du3dt=GFS_Data(cdata%blk_no)%Intdiag%du3dt(:,:,2), &
                  dv3dt=GFS_Data(cdata%blk_no)%Intdiag%dv3dt(:,:,2),dt3dt=GFS_Data(cdata%blk_no)%Intdiag%dt3dt(:,:,7), &
                  flag_for_gwd_generic_tend=GFS_Control%flag_for_gwd_generic_tend,errmsg=cdata%errmsg, &
                  errflg=cdata%errflg)



      if (cdata%errflg/=0) then
        cdata%errmsg = "An error occured in GFS_GWD_generic_post_run: " // trim(cdata%errmsg)
        ierr=cdata%errflg
        return
      end if

    
      


      call rayleigh_damp_run(lsidea=GFS_Control%lsidea,im=GFS_Control%blksz(cdata%blk_no),km=GFS_Control%levs, &
                  A=GFS_Interstitial(cdata%thrd_no)%dvdt,B=GFS_Interstitial(cdata%thrd_no)%dudt, &
                  C=GFS_Interstitial(cdata%thrd_no)%dtdt,u1=GFS_Data(cdata%blk_no)%Statein%ugrs, &
                  v1=GFS_Data(cdata%blk_no)%Statein%vgrs,dt=GFS_Control%dtp,cp=con_cp,levr=GFS_Control%levr, &
                  pgr=GFS_Data(cdata%blk_no)%Statein%pgr,prsl=GFS_Data(cdata%blk_no)%Statein%prsl, &
                  prslrd0=GFS_Control%prslrd0,ral_ts=GFS_Control%ral_ts,ldiag3d=GFS_Control%ldiag3d, &
                  du3dt=GFS_Data(cdata%blk_no)%Intdiag%du3dt(:,:,5),dv3dt=GFS_Data(cdata%blk_no)%Intdiag%dv3dt(:,:,5), &
                  dt3dt=GFS_Data(cdata%blk_no)%Intdiag%dt3dt(:,:,8),errmsg=cdata%errmsg,errflg=cdata%errflg)



      if (cdata%errflg/=0) then
        cdata%errmsg = "An error occured in rayleigh_damp_run: " // trim(cdata%errmsg)
        ierr=cdata%errflg
        return
      end if

    
      


      call GFS_suite_stateout_update_run(im=GFS_Control%blksz(cdata%blk_no),levs=GFS_Control%levs,ntrac=GFS_Control%ntrac, &
                  dtp=GFS_Control%dtp,tgrs=GFS_Data(cdata%blk_no)%Statein%tgrs,ugrs=GFS_Data(cdata%blk_no)%Statein%ugrs, &
                  vgrs=GFS_Data(cdata%blk_no)%Statein%vgrs,qgrs=GFS_Data(cdata%blk_no)%Statein%qgrs, &
                  dudt=GFS_Interstitial(cdata%thrd_no)%dudt,dvdt=GFS_Interstitial(cdata%thrd_no)%dvdt, &
                  dtdt=GFS_Interstitial(cdata%thrd_no)%dtdt,dqdt=GFS_Interstitial(cdata%thrd_no)%dqdt, &
                  gt0=GFS_Data(cdata%blk_no)%Stateout%gt0,gu0=GFS_Data(cdata%blk_no)%Stateout%gu0, &
                  gv0=GFS_Data(cdata%blk_no)%Stateout%gv0,gq0=GFS_Data(cdata%blk_no)%Stateout%gq0, &
                  errmsg=cdata%errmsg,errflg=cdata%errflg)



      if (cdata%errflg/=0) then
        cdata%errmsg = "An error occured in GFS_suite_stateout_update_run: " // trim(cdata%errmsg)
        ierr=cdata%errflg
        return
      end if

    
      


      call ozphys_2015_run(im=GFS_Control%blksz(cdata%blk_no),levs=GFS_Control%levs,ko3=GFS_Interstitial(cdata%thrd_no)%levozp, &
                  dt=GFS_Control%dtp,oz=GFS_Data(cdata%blk_no)%Stateout%gq0(:,:,GFS_Control%ntoz), &
                  tin=GFS_Data(cdata%blk_no)%Stateout%gt0,po3=GFS_Interstitial(cdata%thrd_no)%oz_pres, &
                  prsl=GFS_Data(cdata%blk_no)%Statein%prsl,prdout=GFS_Data(cdata%blk_no)%Tbd%ozpl, &
                  pl_coeff=GFS_Interstitial(cdata%thrd_no)%oz_coeff,delp=GFS_Interstitial(cdata%thrd_no)%del, &
                  ldiag3d=GFS_Control%ldiag3d,qdiag3d=GFS_Control%qdiag3d,ozp1=GFS_Data(cdata%blk_no)%Intdiag%dq3dt(:,:,6), &
                  ozp2=GFS_Data(cdata%blk_no)%Intdiag%dq3dt(:,:,7),ozp3=GFS_Data(cdata%blk_no)%Intdiag%dq3dt(:,:,8), &
                  ozp4=GFS_Data(cdata%blk_no)%Intdiag%dq3dt(:,:,9),con_g=con_g,me=GFS_Control%me, &
                  errmsg=cdata%errmsg,errflg=cdata%errflg)



      if (cdata%errflg/=0) then
        cdata%errmsg = "An error occured in ozphys_2015_run: " // trim(cdata%errmsg)
        ierr=cdata%errflg
        return
      end if

    
      


      call h2ophys_run(im=GFS_Control%blksz(cdata%blk_no),levs=GFS_Control%levs,kh2o=GFS_Interstitial(cdata%thrd_no)%levh2o, &
                  dt=GFS_Control%dtp,h2o=GFS_Data(cdata%blk_no)%Stateout%gq0(:,:,GFS_Control%ntqv), &
                  ph2o=GFS_Interstitial(cdata%thrd_no)%h2o_pres,prsl=GFS_Data(cdata%blk_no)%Statein%prsl, &
                  h2opltc=GFS_Data(cdata%blk_no)%Tbd%h2opl,h2o_coeff=GFS_Interstitial(cdata%thrd_no)%h2o_coeff, &
                  ldiag3d=GFS_Control%ldiag3d,me=GFS_Control%me,errmsg=cdata%errmsg,errflg=cdata%errflg)



      if (cdata%errflg/=0) then
        cdata%errmsg = "An error occured in h2ophys_run: " // trim(cdata%errmsg)
        ierr=cdata%errflg
        return
      end if

    
      


      call get_phi_fv3_run(ix=GFS_Control%blksz(cdata%blk_no),levs=GFS_Control%levs,gt0=GFS_Data(cdata%blk_no)%Stateout%gt0, &
                  gq01=GFS_Data(cdata%blk_no)%Stateout%gq0(:,:,GFS_Control%ntqv),del_gz=GFS_Interstitial(cdata%thrd_no)%del_gz, &
                  phii=GFS_Data(cdata%blk_no)%Statein%phii,phil=GFS_Data(cdata%blk_no)%Statein%phil, &
                  errmsg=cdata%errmsg,errflg=cdata%errflg)



      if (cdata%errflg/=0) then
        cdata%errmsg = "An error occured in get_phi_fv3_run: " // trim(cdata%errmsg)
        ierr=cdata%errflg
        return
      end if

    
      


      call GFS_suite_interstitial_3_run(im=GFS_Control%blksz(cdata%blk_no),levs=GFS_Control%levs,nn=GFS_Interstitial(cdata%thrd_no)%nn, &
                  cscnv=GFS_Control%cscnv,satmedmf=GFS_Control%satmedmf,trans_trac=GFS_Control%trans_trac, &
                  do_shoc=GFS_Control%do_shoc,ltaerosol=GFS_Control%ltaerosol,ntrac=GFS_Control%ntrac, &
                  ntcw=GFS_Control%ntcw,ntiw=GFS_Control%ntiw,ntclamt=GFS_Control%ntclamt, &
                  ntrw=GFS_Control%ntrw,ntsw=GFS_Control%ntsw,ntrnc=GFS_Control%ntrnc,ntsnc=GFS_Control%ntsnc, &
                  ntgl=GFS_Control%ntgl,ntgnc=GFS_Control%ntgnc,xlon=GFS_Data(cdata%blk_no)%Grid%xlon, &
                  xlat=GFS_Data(cdata%blk_no)%Grid%xlat,gt0=GFS_Data(cdata%blk_no)%Stateout%gt0, &
                  gq0=GFS_Data(cdata%blk_no)%Stateout%gq0,imp_physics=GFS_Control%imp_physics, &
                  imp_physics_mg=GFS_Control%imp_physics_mg,imp_physics_zhao_carr=GFS_Control%imp_physics_zhao_carr, &
                  imp_physics_zhao_carr_pdf=GFS_Control%imp_physics_zhao_carr_pdf,imp_physics_gfdl=GFS_Control%imp_physics_gfdl, &
                  imp_physics_thompson=GFS_Control%imp_physics_thompson,imp_physics_wsm6=GFS_Control%imp_physics_wsm6, &
                  imp_physics_fer_hires=GFS_Control%imp_physics_fer_hires,prsi=GFS_Data(cdata%blk_no)%Statein%prsi, &
                  prsl=GFS_Data(cdata%blk_no)%Statein%prsl,prslk=GFS_Data(cdata%blk_no)%Statein%prslk, &
                  rhcbot=GFS_Control%crtrh(1),rhcpbl=GFS_Control%crtrh(2),rhctop=GFS_Control%crtrh(3), &
                  rhcmax=GFS_Control%rhcmax,islmsk=GFS_Interstitial(cdata%thrd_no)%islmsk, &
                  work1=GFS_Interstitial(cdata%thrd_no)%work1,work2=GFS_Interstitial(cdata%thrd_no)%work2, &
                  kpbl=GFS_Interstitial(cdata%thrd_no)%kpbl,kinver=GFS_Interstitial(cdata%thrd_no)%kinver, &
                  ras=GFS_Control%ras,me=GFS_Control%me,clw=GFS_Interstitial(cdata%thrd_no)%clw, &
                  rhc=GFS_Interstitial(cdata%thrd_no)%rhc,save_qc=GFS_Interstitial(cdata%thrd_no)%save_q(:,:,GFS_Control%ntcw), &
                  save_qi=GFS_Interstitial(cdata%thrd_no)%save_q(:,:,GFS_Control%ntiw),save_tcp=GFS_Interstitial(cdata%thrd_no)%save_tcp, &
                  errmsg=cdata%errmsg,errflg=cdata%errflg)



      if (cdata%errflg/=0) then
        cdata%errmsg = "An error occured in GFS_suite_interstitial_3_run: " // trim(cdata%errmsg)
        ierr=cdata%errflg
        return
      end if

    
      


      call GFS_DCNV_generic_pre_run(im=GFS_Control%blksz(cdata%blk_no),levs=GFS_Control%levs,ldiag3d=GFS_Control%ldiag3d, &
                  qdiag3d=GFS_Control%qdiag3d,do_cnvgwd=GFS_Control%do_cnvgwd,cplchm=GFS_Control%cplchm, &
                  gu0=GFS_Data(cdata%blk_no)%Stateout%gu0,gv0=GFS_Data(cdata%blk_no)%Stateout%gv0, &
                  gt0=GFS_Data(cdata%blk_no)%Stateout%gt0,gq0_water_vapor=GFS_Data(cdata%blk_no)%Stateout%gq0(:,:,GFS_Control%ntqv), &
                  save_u=GFS_Interstitial(cdata%thrd_no)%save_u,save_v=GFS_Interstitial(cdata%thrd_no)%save_v, &
                  save_t=GFS_Interstitial(cdata%thrd_no)%save_t,save_qv=GFS_Interstitial(cdata%thrd_no)%save_q(:,:,GFS_Control%ntqv), &
                  dqdti=GFS_Data(cdata%blk_no)%Coupling%dqdti,errmsg=cdata%errmsg,errflg=cdata%errflg)



      if (cdata%errflg/=0) then
        cdata%errmsg = "An error occured in GFS_DCNV_generic_pre_run: " // trim(cdata%errmsg)
        ierr=cdata%errflg
        return
      end if

    
      


      call GFS_DCNV_generic_post_run(im=GFS_Control%blksz(cdata%blk_no),levs=GFS_Control%levs,lssav=GFS_Control%lssav, &
                  ldiag3d=GFS_Control%ldiag3d,qdiag3d=GFS_Control%qdiag3d,ras=GFS_Control%ras, &
                  cscnv=GFS_Control%cscnv,frain=GFS_Interstitial(cdata%thrd_no)%frain,rain1=GFS_Interstitial(cdata%thrd_no)%raincd, &
                  dtf=GFS_Control%dtf,cld1d=GFS_Interstitial(cdata%thrd_no)%cld1d,save_u=GFS_Interstitial(cdata%thrd_no)%save_u, &
                  save_v=GFS_Interstitial(cdata%thrd_no)%save_v,save_t=GFS_Interstitial(cdata%thrd_no)%save_t, &
                  save_qv=GFS_Interstitial(cdata%thrd_no)%save_q(:,:,GFS_Control%ntqv),gu0=GFS_Data(cdata%blk_no)%Stateout%gu0, &
                  gv0=GFS_Data(cdata%blk_no)%Stateout%gv0,gt0=GFS_Data(cdata%blk_no)%Stateout%gt0, &
                  gq0_water_vapor=GFS_Data(cdata%blk_no)%Stateout%gq0(:,:,GFS_Control%ntqv), &
                  ud_mf=GFS_Interstitial(cdata%thrd_no)%ud_mf,dd_mf=GFS_Interstitial(cdata%thrd_no)%dd_mf, &
                  dt_mf=GFS_Interstitial(cdata%thrd_no)%dt_mf,con_g=con_g,npdf3d=GFS_Control%npdf3d, &
                  num_p3d=GFS_Control%num_p3d,ncnvcld3d=GFS_Control%ncnvcld3d,rainc=GFS_Data(cdata%blk_no)%Intdiag%rainc, &
                  cldwrk=GFS_Data(cdata%blk_no)%Intdiag%cldwrk,dt3dt=GFS_Data(cdata%blk_no)%Intdiag%dt3dt(:,:,4), &
                  dq3dt=GFS_Data(cdata%blk_no)%Intdiag%dq3dt(:,:,2),du3dt=GFS_Data(cdata%blk_no)%Intdiag%du3dt(:,:,3), &
                  dv3dt=GFS_Data(cdata%blk_no)%Intdiag%dv3dt(:,:,3),upd_mf=GFS_Data(cdata%blk_no)%Intdiag%upd_mf, &
                  dwn_mf=GFS_Data(cdata%blk_no)%Intdiag%dwn_mf,det_mf=GFS_Data(cdata%blk_no)%Intdiag%det_mf, &
                  cnvw=GFS_Interstitial(cdata%thrd_no)%cnvw,cnvc=GFS_Interstitial(cdata%thrd_no)%cnvc, &
                  cnvw_phy_f3d=GFS_Data(cdata%blk_no)%Tbd%phy_f3d(:,:,GFS_Control%ncnvw), &
                  cnvc_phy_f3d=GFS_Data(cdata%blk_no)%Tbd%phy_f3d(:,:,GFS_Control%ncnvc), &
                  flag_for_dcnv_generic_tend=GFS_Control%flag_for_dcnv_generic_tend,errmsg=cdata%errmsg, &
                  errflg=cdata%errflg)



      if (cdata%errflg/=0) then
        cdata%errmsg = "An error occured in GFS_DCNV_generic_post_run: " // trim(cdata%errmsg)
        ierr=cdata%errflg
        return
      end if

    
      


      call GFS_SCNV_generic_pre_run(im=GFS_Control%blksz(cdata%blk_no),levs=GFS_Control%levs,ldiag3d=GFS_Control%ldiag3d, &
                  qdiag3d=GFS_Control%qdiag3d,gu0=GFS_Data(cdata%blk_no)%Stateout%gu0,gv0=GFS_Data(cdata%blk_no)%Stateout%gv0, &
                  gt0=GFS_Data(cdata%blk_no)%Stateout%gt0,gq0_water_vapor=GFS_Data(cdata%blk_no)%Stateout%gq0(:,:,GFS_Control%ntqv), &
                  save_u=GFS_Interstitial(cdata%thrd_no)%save_u,save_v=GFS_Interstitial(cdata%thrd_no)%save_v, &
                  save_t=GFS_Interstitial(cdata%thrd_no)%save_t,save_qv=GFS_Interstitial(cdata%thrd_no)%save_q(:,:,GFS_Control%ntqv), &
                  flag_for_scnv_generic_tend=GFS_Control%flag_for_scnv_generic_tend,errmsg=cdata%errmsg, &
                  errflg=cdata%errflg)



      if (cdata%errflg/=0) then
        cdata%errmsg = "An error occured in GFS_SCNV_generic_pre_run: " // trim(cdata%errmsg)
        ierr=cdata%errflg
        return
      end if

    
      


      call GFS_SCNV_generic_post_run(im=GFS_Control%blksz(cdata%blk_no),levs=GFS_Control%levs,nn=GFS_Interstitial(cdata%thrd_no)%nn, &
                  lssav=GFS_Control%lssav,qdiag3d=GFS_Control%qdiag3d,ldiag3d=GFS_Control%ldiag3d, &
                  cplchm=GFS_Control%cplchm,frain=GFS_Interstitial(cdata%thrd_no)%frain,gu0=GFS_Data(cdata%blk_no)%Stateout%gu0, &
                  gv0=GFS_Data(cdata%blk_no)%Stateout%gv0,gt0=GFS_Data(cdata%blk_no)%Stateout%gt0, &
                  gq0_water_vapor=GFS_Data(cdata%blk_no)%Stateout%gq0(:,:,GFS_Control%ntqv), &
                  save_u=GFS_Interstitial(cdata%thrd_no)%save_u,save_v=GFS_Interstitial(cdata%thrd_no)%save_v, &
                  save_t=GFS_Interstitial(cdata%thrd_no)%save_t,save_qv=GFS_Interstitial(cdata%thrd_no)%save_q(:,:,GFS_Control%ntqv), &
                  dqdti=GFS_Data(cdata%blk_no)%Coupling%dqdti,du3dt=GFS_Data(cdata%blk_no)%Intdiag%du3dt(:,:,6), &
                  dv3dt=GFS_Data(cdata%blk_no)%Intdiag%dv3dt(:,:,6),dt3dt=GFS_Data(cdata%blk_no)%Intdiag%dt3dt(:,:,5), &
                  dq3dt=GFS_Data(cdata%blk_no)%Intdiag%dq3dt(:,:,3),clw=GFS_Interstitial(cdata%thrd_no)%clw, &
                  shcnvcw=GFS_Control%shcnvcw,rain1=GFS_Interstitial(cdata%thrd_no)%raincs, &
                  npdf3d=GFS_Control%npdf3d,num_p3d=GFS_Control%num_p3d,ncnvcld3d=GFS_Control%ncnvcld3d, &
                  cnvc=GFS_Interstitial(cdata%thrd_no)%cnvc,cnvw=GFS_Interstitial(cdata%thrd_no)%cnvw, &
                  rainc=GFS_Data(cdata%blk_no)%Intdiag%rainc,cnvprcp=GFS_Data(cdata%blk_no)%Intdiag%cnvprcp, &
                  cnvprcpb=GFS_Data(cdata%blk_no)%Intdiag%cnvprcpb,cnvw_phy_f3d=GFS_Data(cdata%blk_no)%Tbd%phy_f3d(:,:,GFS_Control%ncnvw), &
                  cnvc_phy_f3d=GFS_Data(cdata%blk_no)%Tbd%phy_f3d(:,:,GFS_Control%ncnvc), &
                  flag_for_scnv_generic_tend=GFS_Control%flag_for_scnv_generic_tend,imfshalcnv=GFS_Control%imfshalcnv, &
                  imfshalcnv_sas=GFS_Control%imfshalcnv_sas,imfshalcnv_samf=GFS_Control%imfshalcnv_samf, &
                  errmsg=cdata%errmsg,errflg=cdata%errflg)



      if (cdata%errflg/=0) then
        cdata%errmsg = "An error occured in GFS_SCNV_generic_post_run: " // trim(cdata%errmsg)
        ierr=cdata%errflg
        return
      end if

    
      


      call GFS_suite_interstitial_4_run(im=GFS_Control%blksz(cdata%blk_no),levs=GFS_Control%levs,ltaerosol=GFS_Control%ltaerosol, &
                  cplchm=GFS_Control%cplchm,tracers_total=GFS_Interstitial(cdata%thrd_no)%tracers_total, &
                  ntrac=GFS_Control%ntrac,ntcw=GFS_Control%ntcw,ntiw=GFS_Control%ntiw,ntclamt=GFS_Control%ntclamt, &
                  ntrw=GFS_Control%ntrw,ntsw=GFS_Control%ntsw,ntrnc=GFS_Control%ntrnc,ntsnc=GFS_Control%ntsnc, &
                  ntgl=GFS_Control%ntgl,ntgnc=GFS_Control%ntgnc,ntlnc=GFS_Control%ntlnc,ntinc=GFS_Control%ntinc, &
                  nn=GFS_Interstitial(cdata%thrd_no)%nn,imp_physics=GFS_Control%imp_physics, &
                  imp_physics_gfdl=GFS_Control%imp_physics_gfdl,imp_physics_thompson=GFS_Control%imp_physics_thompson, &
                  imp_physics_zhao_carr=GFS_Control%imp_physics_zhao_carr,imp_physics_zhao_carr_pdf=GFS_Control%imp_physics_zhao_carr_pdf, &
                  dtf=GFS_Control%dtf,save_qc=GFS_Interstitial(cdata%thrd_no)%save_q(:,:,GFS_Control%ntcw), &
                  save_qi=GFS_Interstitial(cdata%thrd_no)%save_q(:,:,GFS_Control%ntiw),con_pi=con_pi, &
                  gq0=GFS_Data(cdata%blk_no)%Stateout%gq0,clw=GFS_Interstitial(cdata%thrd_no)%clw, &
                  prsl=GFS_Data(cdata%blk_no)%Statein%prsl,save_tcp=GFS_Interstitial(cdata%thrd_no)%save_tcp, &
                  con_rd=con_rd,nwfa=GFS_Data(cdata%blk_no)%Statein%qgrs(:,:,GFS_Control%ntwa), &
                  spechum=GFS_Data(cdata%blk_no)%Statein%qgrs(:,:,GFS_Control%ntqv),dqdti=GFS_Data(cdata%blk_no)%Coupling%dqdti, &
                  errmsg=cdata%errmsg,errflg=cdata%errflg)



      if (cdata%errflg/=0) then
        cdata%errmsg = "An error occured in GFS_suite_interstitial_4_run: " // trim(cdata%errmsg)
        ierr=cdata%errflg
        return
      end if

    
      


      call GFS_MP_generic_pre_run(im=GFS_Control%blksz(cdata%blk_no),levs=GFS_Control%levs,ldiag3d=GFS_Control%ldiag3d, &
                  qdiag3d=GFS_Control%qdiag3d,do_aw=GFS_Control%do_aw,ntcw=GFS_Control%ntcw, &
                  nncl=GFS_Interstitial(cdata%thrd_no)%nncl,ntrac=GFS_Control%ntrac,gt0=GFS_Data(cdata%blk_no)%Stateout%gt0, &
                  gq0=GFS_Data(cdata%blk_no)%Stateout%gq0,save_t=GFS_Interstitial(cdata%thrd_no)%save_t, &
                  save_qv=GFS_Interstitial(cdata%thrd_no)%save_q(:,:,GFS_Control%ntqv),save_q=GFS_Interstitial(cdata%thrd_no)%save_q, &
                  errmsg=cdata%errmsg,errflg=cdata%errflg)



      if (cdata%errflg/=0) then
        cdata%errmsg = "An error occured in GFS_MP_generic_pre_run: " // trim(cdata%errmsg)
        ierr=cdata%errflg
        return
      end if

    
      


      call gfdl_cloud_microphys_run(levs=GFS_Control%levs,im=GFS_Control%blksz(cdata%blk_no),con_g=con_g,con_fvirt=con_fvirt, &
                  con_rd=con_rd,frland=GFS_Interstitial(cdata%thrd_no)%frland,garea=GFS_Data(cdata%blk_no)%Grid%area, &
                  islmsk=GFS_Interstitial(cdata%thrd_no)%islmsk,gq0=GFS_Data(cdata%blk_no)%Stateout%gq0(:,:,GFS_Control%ntqv), &
                  gq0_ntcw=GFS_Data(cdata%blk_no)%Stateout%gq0(:,:,GFS_Control%ntcw),gq0_ntrw=GFS_Data(cdata%blk_no)%Stateout%gq0(:,:,GFS_Control%ntrw), &
                  gq0_ntiw=GFS_Data(cdata%blk_no)%Stateout%gq0(:,:,GFS_Control%ntiw),gq0_ntsw=GFS_Data(cdata%blk_no)%Stateout%gq0(:,:,GFS_Control%ntsw), &
                  gq0_ntgl=GFS_Data(cdata%blk_no)%Stateout%gq0(:,:,GFS_Control%ntgl),gq0_ntclamt=GFS_Data(cdata%blk_no)%Stateout%gq0(:,:,GFS_Control%ntclamt), &
                  gt0=GFS_Data(cdata%blk_no)%Stateout%gt0,gu0=GFS_Data(cdata%blk_no)%Stateout%gu0, &
                  gv0=GFS_Data(cdata%blk_no)%Stateout%gv0,vvl=GFS_Data(cdata%blk_no)%Statein%vvl, &
                  prsl=GFS_Data(cdata%blk_no)%Statein%prsl,phii=GFS_Data(cdata%blk_no)%Statein%phii, &
                  del=GFS_Interstitial(cdata%thrd_no)%del,rain0=GFS_Interstitial(cdata%thrd_no)%rainmp, &
                  ice0=GFS_Interstitial(cdata%thrd_no)%icemp,snow0=GFS_Interstitial(cdata%thrd_no)%snowmp, &
                  graupel0=GFS_Interstitial(cdata%thrd_no)%graupelmp,prcp0=GFS_Interstitial(cdata%thrd_no)%prcpmp, &
                  sr=GFS_Data(cdata%blk_no)%Intdiag%sr,dtp=GFS_Control%dtp,hydrostatic=GFS_Control%hydrostatic, &
                  phys_hydrostatic=GFS_Interstitial(cdata%thrd_no)%phys_hydrostatic,lradar=GFS_Control%lradar, &
                  refl_10cm=GFS_Data(cdata%blk_no)%Intdiag%refl_10cm,reset=GFS_Interstitial(cdata%thrd_no)%reset, &
                  effr_in=GFS_Control%effr_in,rew=GFS_Data(cdata%blk_no)%Tbd%phy_f3d(:,:,GFS_Control%nleffr), &
                  rei=GFS_Data(cdata%blk_no)%Tbd%phy_f3d(:,:,GFS_Control%nieffr),rer=GFS_Data(cdata%blk_no)%Tbd%phy_f3d(:,:,GFS_Control%nreffr), &
                  res=GFS_Data(cdata%blk_no)%Tbd%phy_f3d(:,:,GFS_Control%nseffr),reg=GFS_Data(cdata%blk_no)%Tbd%phy_f3d(:,:,GFS_Control%ngeffr), &
                  errmsg=cdata%errmsg,errflg=cdata%errflg)



      if (cdata%errflg/=0) then
        cdata%errmsg = "An error occured in gfdl_cloud_microphys_run: " // trim(cdata%errmsg)
        ierr=cdata%errflg
        return
      end if

    
      


      call GFS_MP_generic_post_run(im=GFS_Control%blksz(cdata%blk_no),levs=GFS_Control%levs,kdt=GFS_Control%kdt, &
                  nrcm=GFS_Control%nrcm,ncld=GFS_Control%ncld,nncl=GFS_Interstitial(cdata%thrd_no)%nncl, &
                  ntcw=GFS_Control%ntcw,ntrac=GFS_Control%ntrac,imp_physics=GFS_Control%imp_physics, &
                  imp_physics_gfdl=GFS_Control%imp_physics_gfdl,imp_physics_thompson=GFS_Control%imp_physics_thompson, &
                  imp_physics_mg=GFS_Control%imp_physics_mg,imp_physics_fer_hires=GFS_Control%imp_physics_fer_hires, &
                  cal_pre=GFS_Control%cal_pre,lssav=GFS_Control%lssav,ldiag3d=GFS_Control%ldiag3d, &
                  qdiag3d=GFS_Control%qdiag3d,cplflx=GFS_Control%cplflx,cplchm=GFS_Control%cplchm, &
                  con_g=con_g,dtf=GFS_Control%dtf,frain=GFS_Interstitial(cdata%thrd_no)%frain, &
                  rainc=GFS_Data(cdata%blk_no)%Intdiag%rainc,rain1=GFS_Interstitial(cdata%thrd_no)%prcpmp, &
                  rann=GFS_Data(cdata%blk_no)%Tbd%rann,xlat=GFS_Data(cdata%blk_no)%Grid%xlat, &
                  xlon=GFS_Data(cdata%blk_no)%Grid%xlon,gt0=GFS_Data(cdata%blk_no)%Stateout%gt0, &
                  gq0=GFS_Data(cdata%blk_no)%Stateout%gq0,prsl=GFS_Data(cdata%blk_no)%Statein%prsl, &
                  prsi=GFS_Data(cdata%blk_no)%Statein%prsi,phii=GFS_Data(cdata%blk_no)%Statein%phii, &
                  tsfc=GFS_Data(cdata%blk_no)%Sfcprop%tsfc,ice=GFS_Data(cdata%blk_no)%Intdiag%ice, &
                  snow=GFS_Data(cdata%blk_no)%Intdiag%snow,graupel=GFS_Data(cdata%blk_no)%Intdiag%graupel, &
                  save_t=GFS_Interstitial(cdata%thrd_no)%save_t,save_qv=GFS_Interstitial(cdata%thrd_no)%save_q(:,:,GFS_Control%ntqv), &
                  rain0=GFS_Interstitial(cdata%thrd_no)%rainmp,ice0=GFS_Interstitial(cdata%thrd_no)%icemp, &
                  snow0=GFS_Interstitial(cdata%thrd_no)%snowmp,graupel0=GFS_Interstitial(cdata%thrd_no)%graupelmp, &
                  del=GFS_Interstitial(cdata%thrd_no)%del,rain=GFS_Data(cdata%blk_no)%Intdiag%rain, &
                  domr_diag=GFS_Data(cdata%blk_no)%Intdiag%tdomr,domzr_diag=GFS_Data(cdata%blk_no)%Intdiag%tdomzr, &
                  domip_diag=GFS_Data(cdata%blk_no)%Intdiag%tdomip,doms_diag=GFS_Data(cdata%blk_no)%Intdiag%tdoms, &
                  tprcp=GFS_Data(cdata%blk_no)%Sfcprop%tprcp,srflag=GFS_Data(cdata%blk_no)%Sfcprop%srflag, &
                  sr=GFS_Data(cdata%blk_no)%Intdiag%sr,cnvprcp=GFS_Data(cdata%blk_no)%Intdiag%cnvprcp, &
                  totprcp=GFS_Data(cdata%blk_no)%Intdiag%totprcp,totice=GFS_Data(cdata%blk_no)%Intdiag%totice, &
                  totsnw=GFS_Data(cdata%blk_no)%Intdiag%totsnw,totgrp=GFS_Data(cdata%blk_no)%Intdiag%totgrp, &
                  cnvprcpb=GFS_Data(cdata%blk_no)%Intdiag%cnvprcpb,totprcpb=GFS_Data(cdata%blk_no)%Intdiag%totprcpb, &
                  toticeb=GFS_Data(cdata%blk_no)%Intdiag%toticeb,totsnwb=GFS_Data(cdata%blk_no)%Intdiag%totsnwb, &
                  totgrpb=GFS_Data(cdata%blk_no)%Intdiag%totgrpb,dt3dt=GFS_Data(cdata%blk_no)%Intdiag%dt3dt(:,:,6), &
                  dq3dt=GFS_Data(cdata%blk_no)%Intdiag%dq3dt(:,:,4),rain_cpl=GFS_Data(cdata%blk_no)%Coupling%rain_cpl, &
                  rainc_cpl=GFS_Data(cdata%blk_no)%Coupling%rainc_cpl,snow_cpl=GFS_Data(cdata%blk_no)%Coupling%snow_cpl, &
                  pwat=GFS_Data(cdata%blk_no)%Intdiag%pwat,do_sppt=GFS_Control%do_sppt,ca_global=GFS_Control%ca_global, &
                  dtdtr=GFS_Data(cdata%blk_no)%Tbd%dtdtr,dtdtc=GFS_Interstitial(cdata%thrd_no)%dtdtc, &
                  drain_cpl=GFS_Data(cdata%blk_no)%Tbd%drain_cpl,dsnow_cpl=GFS_Data(cdata%blk_no)%Tbd%dsnow_cpl, &
                  lsm=GFS_Control%lsm,lsm_ruc=GFS_Control%lsm_ruc,lsm_noahmp=GFS_Control%lsm_noahmp, &
                  raincprv=GFS_Data(cdata%blk_no)%Sfcprop%raincprv,rainncprv=GFS_Data(cdata%blk_no)%Sfcprop%rainncprv, &
                  iceprv=GFS_Data(cdata%blk_no)%Sfcprop%iceprv,snowprv=GFS_Data(cdata%blk_no)%Sfcprop%snowprv, &
                  graupelprv=GFS_Data(cdata%blk_no)%Sfcprop%graupelprv,draincprv=GFS_Data(cdata%blk_no)%Sfcprop%draincprv, &
                  drainncprv=GFS_Data(cdata%blk_no)%Sfcprop%drainncprv,diceprv=GFS_Data(cdata%blk_no)%Sfcprop%diceprv, &
                  dsnowprv=GFS_Data(cdata%blk_no)%Sfcprop%dsnowprv,dgraupelprv=GFS_Data(cdata%blk_no)%Sfcprop%dgraupelprv, &
                  dtp=GFS_Control%dtp,errmsg=cdata%errmsg,errflg=cdata%errflg)



      if (cdata%errflg/=0) then
        cdata%errmsg = "An error occured in GFS_MP_generic_post_run: " // trim(cdata%errmsg)
        ierr=cdata%errflg
        return
      end if

    
      


      call maximum_hourly_diagnostics_run(im=GFS_Control%blksz(cdata%blk_no),levs=GFS_Control%levs,reset=GFS_Interstitial(cdata%thrd_no)%reset, &
                  lradar=GFS_Control%lradar,imp_physics=GFS_Control%imp_physics,imp_physics_gfdl=GFS_Control%imp_physics_gfdl, &
                  imp_physics_thompson=GFS_Control%imp_physics_thompson,imp_physics_fer_hires=GFS_Control%imp_physics_fer_hires, &
                  con_g=con_g,phil=GFS_Data(cdata%blk_no)%Statein%phil,gt0=GFS_Data(cdata%blk_no)%Stateout%gt0, &
                  refl_10cm=GFS_Data(cdata%blk_no)%Intdiag%refl_10cm,refdmax=GFS_Data(cdata%blk_no)%Intdiag%refdmax, &
                  refdmax263k=GFS_Data(cdata%blk_no)%Intdiag%refdmax263k,u10m=GFS_Data(cdata%blk_no)%Intdiag%u10m, &
                  v10m=GFS_Data(cdata%blk_no)%Intdiag%v10m,u10max=GFS_Data(cdata%blk_no)%Intdiag%u10max, &
                  v10max=GFS_Data(cdata%blk_no)%Intdiag%v10max,spd10max=GFS_Data(cdata%blk_no)%Intdiag%spd10max, &
                  pgr=GFS_Data(cdata%blk_no)%Statein%pgr,t2m=GFS_Data(cdata%blk_no)%Sfcprop%t2m, &
                  q2m=GFS_Data(cdata%blk_no)%Sfcprop%q2m,t02max=GFS_Data(cdata%blk_no)%Intdiag%t02max, &
                  t02min=GFS_Data(cdata%blk_no)%Intdiag%t02min,rh02max=GFS_Data(cdata%blk_no)%Intdiag%rh02max, &
                  rh02min=GFS_Data(cdata%blk_no)%Intdiag%rh02min,errmsg=cdata%errmsg,errflg=cdata%errflg)



      if (cdata%errflg/=0) then
        cdata%errmsg = "An error occured in maximum_hourly_diagnostics_run: " // trim(cdata%errmsg)
        ierr=cdata%errflg
        return
      end if

    



   end function FV3_GFS_2017_gfdlmp_regional_c768_physics_run_cap

   function FV3_GFS_2017_gfdlmp_regional_c768_physics_finalize_cap(cdata) result(ierr)

      use ccpp_types, only: ccpp_t

      implicit none

      ! Error handling
      integer :: ierr

      type(ccpp_t), intent(inout) :: cdata

      ierr = 0


      if (.not.initialized) return



      


      call lsm_noah_finalize(errmsg=cdata%errmsg,errflg=cdata%errflg)



      if (cdata%errflg/=0) then
        cdata%errmsg = "An error occured in lsm_noah_finalize: " // trim(cdata%errmsg)
        ierr=cdata%errflg
        return
      end if

    
      


      call cires_ugwp_finalize(errmsg=cdata%errmsg,errflg=cdata%errflg)



      if (cdata%errflg/=0) then
        cdata%errmsg = "An error occured in cires_ugwp_finalize: " // trim(cdata%errmsg)
        ierr=cdata%errflg
        return
      end if

    
      


      call gfdl_cloud_microphys_finalize(errmsg=cdata%errmsg,errflg=cdata%errflg)



      if (cdata%errflg/=0) then
        cdata%errmsg = "An error occured in gfdl_cloud_microphys_finalize: " // trim(cdata%errmsg)
        ierr=cdata%errflg
        return
      end if

    


      initialized = .false.


   end function FV3_GFS_2017_gfdlmp_regional_c768_physics_finalize_cap

end module ccpp_FV3_GFS_2017_gfdlmp_regional_c768_physics_cap
