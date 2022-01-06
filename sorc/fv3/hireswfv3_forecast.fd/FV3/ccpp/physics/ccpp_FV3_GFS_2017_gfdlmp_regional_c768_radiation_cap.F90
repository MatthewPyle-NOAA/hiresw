
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
!! @brief Auto-generated cap module for the CCPP radiation group
!!
!
module ccpp_FV3_GFS_2017_gfdlmp_regional_c768_radiation_cap

   use GFS_suite_interstitial_rad_reset, only: GFS_suite_interstitial_rad_reset_run
   use GFS_rrtmg_pre, only: GFS_rrtmg_pre_run
   use rrtmg_sw_pre, only: rrtmg_sw_pre_run
   use rrtmg_sw, only: rrtmg_sw_run
   use rrtmg_sw_post, only: rrtmg_sw_post_run
   use rrtmg_lw_pre, only: rrtmg_lw_pre_run
   use rrtmg_lw, only: rrtmg_lw_run
   use rrtmg_lw_post, only: rrtmg_lw_post_run
   use GFS_rrtmg_post, only: GFS_rrtmg_post_run


   implicit none

   private
   public :: FV3_GFS_2017_gfdlmp_regional_c768_radiation_init_cap, &
             FV3_GFS_2017_gfdlmp_regional_c768_radiation_run_cap, &
             FV3_GFS_2017_gfdlmp_regional_c768_radiation_finalize_cap

   logical, save :: initialized = .false.

   contains

   function FV3_GFS_2017_gfdlmp_regional_c768_radiation_init_cap() result(ierr)

      

      implicit none

      ! Error handling
      integer :: ierr

      

      ierr = 0


      if (initialized) return





      initialized = .true.


   end function FV3_GFS_2017_gfdlmp_regional_c768_radiation_init_cap

   function FV3_GFS_2017_gfdlmp_regional_c768_radiation_run_cap(GFS_Data,GFS_Control,con_epsm1,con_rog,GFS_Interstitial,con_rd,LTP,con_rocp, &
                  con_eps,cdata,con_fvirt) result(ierr)

      use GFS_typedefs, only: GFS_data_type
      use GFS_typedefs, only: GFS_control_type
      use machine, only: kind_phys
      use GFS_typedefs, only: GFS_interstitial_type
      use ccpp_types, only: ccpp_t

      implicit none

      ! Error handling
      integer :: ierr

      type(GFS_data_type), intent(inout) :: GFS_Data(:)
      type(GFS_control_type), intent(in) :: GFS_Control
      real(kind_phys), intent(in) :: con_epsm1
      real(kind_phys), intent(in) :: con_rog
      type(GFS_interstitial_type), intent(inout) :: GFS_Interstitial(:)
      real(kind_phys), intent(in) :: con_rd
      integer, intent(in) :: LTP
      real(kind_phys), intent(in) :: con_rocp
      real(kind_phys), intent(in) :: con_eps
      type(ccpp_t), intent(inout) :: cdata
      real(kind_phys), intent(in) :: con_fvirt

      ierr = 0


      if (.not.initialized) then
        write(cdata%errmsg,'(*(a))') 'radiation_run called before radiation_init'
        cdata%errflg = 1
        return
      end if



      


      call GFS_suite_interstitial_rad_reset_run(Interstitial=GFS_Interstitial(cdata%thrd_no),Model=GFS_Control,errmsg=cdata%errmsg, &
                  errflg=cdata%errflg)



      if (cdata%errflg/=0) then
        cdata%errmsg = "An error occured in GFS_suite_interstitial_rad_reset_run: " // trim(cdata%errmsg)
        ierr=cdata%errflg
        return
      end if

    
      


      call GFS_rrtmg_pre_run(im=GFS_Control%blksz(cdata%blk_no),levs=GFS_Control%levs,lm=GFS_Control%levr, &
                  lmk=GFS_Interstitial(cdata%thrd_no)%lmk,lmp=GFS_Interstitial(cdata%thrd_no)%lmp, &
                  n_var_lndp=GFS_Control%n_var_lndp,imfdeepcnv=GFS_Control%imfdeepcnv,imfdeepcnv_gf=GFS_Control%imfdeepcnv_gf, &
                  me=GFS_Control%me,ncnd=GFS_Control%ncnd,ntrac=GFS_Control%ntrac,num_p3d=GFS_Control%num_p3d, &
                  npdf3d=GFS_Control%npdf3d,ncnvcld3d=GFS_Control%ncnvcld3d,ntqv=GFS_Control%ntqv, &
                  ntcw=GFS_Control%ntcw,ntiw=GFS_Control%ntiw,ntlnc=GFS_Control%ntlnc,ntinc=GFS_Control%ntinc, &
                  ncld=GFS_Control%ncld,ntrw=GFS_Control%ntrw,ntsw=GFS_Control%ntsw,ntgl=GFS_Control%ntgl, &
                  ntwa=GFS_Control%ntwa,ntoz=GFS_Control%ntoz,ntclamt=GFS_Control%ntclamt, &
                  nleffr=GFS_Control%nleffr,nieffr=GFS_Control%nieffr,nseffr=GFS_Control%nseffr, &
                  lndp_type=GFS_Control%lndp_type,kdt=GFS_Control%kdt,imp_physics=GFS_Control%imp_physics, &
                  imp_physics_thompson=GFS_Control%imp_physics_thompson,imp_physics_gfdl=GFS_Control%imp_physics_gfdl, &
                  imp_physics_zhao_carr=GFS_Control%imp_physics_zhao_carr,imp_physics_zhao_carr_pdf=GFS_Control%imp_physics_zhao_carr_pdf, &
                  imp_physics_mg=GFS_Control%imp_physics_mg,imp_physics_wsm6=GFS_Control%imp_physics_wsm6, &
                  imp_physics_fer_hires=GFS_Control%imp_physics_fer_hires,julian=GFS_Control%julian, &
                  yearlen=GFS_Control%yearlen,lndp_var_list=GFS_Control%lndp_var_list,lsswr=GFS_Control%lsswr, &
                  lslwr=GFS_Control%lslwr,ltaerosol=GFS_Control%ltaerosol,lgfdlmprad=GFS_Control%lgfdlmprad, &
                  uni_cld=GFS_Control%uni_cld,effr_in=GFS_Control%effr_in,do_mynnedmf=GFS_Control%do_mynnedmf, &
                  lmfshal=GFS_Control%lmfshal,lmfdeep2=GFS_Control%lmfdeep2,fhswr=GFS_Control%fhswr, &
                  fhlwr=GFS_Control%fhlwr,solhr=GFS_Control%solhr,sup=GFS_Control%sup,eps=con_eps, &
                  epsm1=con_epsm1,fvirt=con_fvirt,rog=con_rog,rocp=con_rocp,con_rd=con_rd, &
                  xlat_d=GFS_Data(cdata%blk_no)%Grid%xlat_d,xlat=GFS_Data(cdata%blk_no)%Grid%xlat, &
                  xlon=GFS_Data(cdata%blk_no)%Grid%xlon,coslat=GFS_Data(cdata%blk_no)%Grid%coslat, &
                  sinlat=GFS_Data(cdata%blk_no)%Grid%sinlat,tsfc=GFS_Data(cdata%blk_no)%Sfcprop%tsfc, &
                  slmsk=GFS_Data(cdata%blk_no)%Sfcprop%slmsk,prsi=GFS_Data(cdata%blk_no)%Statein%prsi, &
                  prsl=GFS_Data(cdata%blk_no)%Statein%prsl,prslk=GFS_Data(cdata%blk_no)%Statein%prslk, &
                  tgrs=GFS_Data(cdata%blk_no)%Statein%tgrs,sfc_wts=GFS_Data(cdata%blk_no)%Coupling%sfc_wts, &
                  mg_cld=GFS_Data(cdata%blk_no)%Tbd%phy_f3d(:,:,GFS_Control%indcld),effrr_in=GFS_Data(cdata%blk_no)%Tbd%phy_f3d(:,:,GFS_Control%nreffr), &
                  cnvw_in=GFS_Data(cdata%blk_no)%Tbd%phy_f3d(:,:,GFS_Control%ncnvw),cnvc_in=GFS_Data(cdata%blk_no)%Tbd%phy_f3d(:,:,GFS_Control%ncnvc), &
                  qgrs=GFS_Data(cdata%blk_no)%Statein%qgrs,aer_nm=GFS_Data(cdata%blk_no)%Tbd%aer_nm, &
                  coszen=GFS_Data(cdata%blk_no)%Radtend%coszen,coszdg=GFS_Data(cdata%blk_no)%Radtend%coszdg, &
                  effrl_inout=GFS_Data(cdata%blk_no)%Tbd%phy_f3d(:,:,GFS_Control%nleffr), &
                  effri_inout=GFS_Data(cdata%blk_no)%Tbd%phy_f3d(:,:,GFS_Control%nieffr), &
                  effrs_inout=GFS_Data(cdata%blk_no)%Tbd%phy_f3d(:,:,GFS_Control%nseffr), &
                  clouds1=GFS_Interstitial(cdata%thrd_no)%clouds(:,:,1),clouds2=GFS_Interstitial(cdata%thrd_no)%clouds(:,:,2), &
                  clouds3=GFS_Interstitial(cdata%thrd_no)%clouds(:,:,3),clouds4=GFS_Interstitial(cdata%thrd_no)%clouds(:,:,4), &
                  clouds5=GFS_Interstitial(cdata%thrd_no)%clouds(:,:,5),kd=GFS_Interstitial(cdata%thrd_no)%kd, &
                  kt=GFS_Interstitial(cdata%thrd_no)%kt,kb=GFS_Interstitial(cdata%thrd_no)%kb, &
                  mtopa=GFS_Interstitial(cdata%thrd_no)%mtopa,mbota=GFS_Interstitial(cdata%thrd_no)%mbota, &
                  raddt=GFS_Interstitial(cdata%thrd_no)%raddt,tsfg=GFS_Interstitial(cdata%thrd_no)%tsfg, &
                  tsfa=GFS_Interstitial(cdata%thrd_no)%tsfa,de_lgth=GFS_Interstitial(cdata%thrd_no)%de_lgth, &
                  alb1d=GFS_Interstitial(cdata%thrd_no)%alb1d,delp=GFS_Interstitial(cdata%thrd_no)%delr, &
                  dz=GFS_Interstitial(cdata%thrd_no)%dzlyr,plvl=GFS_Interstitial(cdata%thrd_no)%plvl, &
                  plyr=GFS_Interstitial(cdata%thrd_no)%plyr,tlvl=GFS_Interstitial(cdata%thrd_no)%tlvl, &
                  tlyr=GFS_Interstitial(cdata%thrd_no)%tlyr,qlyr=GFS_Interstitial(cdata%thrd_no)%qlyr, &
                  olyr=GFS_Interstitial(cdata%thrd_no)%olyr,gasvmr_co2=GFS_Interstitial(cdata%thrd_no)%gasvmr(:,:,1), &
                  gasvmr_n2o=GFS_Interstitial(cdata%thrd_no)%gasvmr(:,:,2),gasvmr_ch4=GFS_Interstitial(cdata%thrd_no)%gasvmr(:,:,3), &
                  gasvmr_o2=GFS_Interstitial(cdata%thrd_no)%gasvmr(:,:,4),gasvmr_co=GFS_Interstitial(cdata%thrd_no)%gasvmr(:,:,5), &
                  gasvmr_cfc11=GFS_Interstitial(cdata%thrd_no)%gasvmr(:,:,6),gasvmr_cfc12=GFS_Interstitial(cdata%thrd_no)%gasvmr(:,:,7), &
                  gasvmr_cfc22=GFS_Interstitial(cdata%thrd_no)%gasvmr(:,:,8),gasvmr_ccl4=GFS_Interstitial(cdata%thrd_no)%gasvmr(:,:,9), &
                  gasvmr_cfc113=GFS_Interstitial(cdata%thrd_no)%gasvmr(:,:,10),aerodp=GFS_Interstitial(cdata%thrd_no)%aerodp, &
                  clouds6=GFS_Interstitial(cdata%thrd_no)%clouds(:,:,6),clouds7=GFS_Interstitial(cdata%thrd_no)%clouds(:,:,7), &
                  clouds8=GFS_Interstitial(cdata%thrd_no)%clouds(:,:,8),clouds9=GFS_Interstitial(cdata%thrd_no)%clouds(:,:,9), &
                  cldsa=GFS_Interstitial(cdata%thrd_no)%cldsa,cldfra=GFS_Data(cdata%blk_no)%Intdiag%cldfra, &
                  faersw1=GFS_Interstitial(cdata%thrd_no)%faersw(:,:,:,1),faersw2=GFS_Interstitial(cdata%thrd_no)%faersw(:,:,:,2), &
                  faersw3=GFS_Interstitial(cdata%thrd_no)%faersw(:,:,:,3),faerlw1=GFS_Interstitial(cdata%thrd_no)%faerlw(:,:,:,1), &
                  faerlw2=GFS_Interstitial(cdata%thrd_no)%faerlw(:,:,:,2),faerlw3=GFS_Interstitial(cdata%thrd_no)%faerlw(:,:,:,3), &
                  alpha=GFS_Interstitial(cdata%thrd_no)%alpha,errmsg=cdata%errmsg,errflg=cdata%errflg)



      if (cdata%errflg/=0) then
        cdata%errmsg = "An error occured in GFS_rrtmg_pre_run: " // trim(cdata%errmsg)
        ierr=cdata%errflg
        return
      end if

    
      


      call rrtmg_sw_pre_run(im=GFS_Control%blksz(cdata%blk_no),lndp_type=GFS_Control%lndp_type,n_var_lndp=GFS_Control%n_var_lndp, &
                  lsswr=GFS_Control%lsswr,lndp_var_list=GFS_Control%lndp_var_list,lndp_prt_list=GFS_Control%lndp_prt_list, &
                  tsfg=GFS_Interstitial(cdata%thrd_no)%tsfg,tsfa=GFS_Interstitial(cdata%thrd_no)%tsfa, &
                  coszen=GFS_Data(cdata%blk_no)%Radtend%coszen,alb1d=GFS_Interstitial(cdata%thrd_no)%alb1d, &
                  slmsk=GFS_Data(cdata%blk_no)%Sfcprop%slmsk,snowd=GFS_Data(cdata%blk_no)%Sfcprop%snowd, &
                  sncovr=GFS_Data(cdata%blk_no)%Sfcprop%sncovr,snoalb=GFS_Data(cdata%blk_no)%Sfcprop%snoalb, &
                  zorl=GFS_Data(cdata%blk_no)%Sfcprop%zorl,hprime=GFS_Data(cdata%blk_no)%Sfcprop%hprime(:,1), &
                  alvsf=GFS_Data(cdata%blk_no)%Sfcprop%alvsf,alnsf=GFS_Data(cdata%blk_no)%Sfcprop%alnsf, &
                  alvwf=GFS_Data(cdata%blk_no)%Sfcprop%alvwf,alnwf=GFS_Data(cdata%blk_no)%Sfcprop%alnwf, &
                  facsf=GFS_Data(cdata%blk_no)%Sfcprop%facsf,facwf=GFS_Data(cdata%blk_no)%Sfcprop%facwf, &
                  fice=GFS_Data(cdata%blk_no)%Sfcprop%fice,tisfc=GFS_Data(cdata%blk_no)%Sfcprop%tisfc, &
                  sfalb=GFS_Data(cdata%blk_no)%Radtend%sfalb,nday=GFS_Interstitial(cdata%thrd_no)%nday, &
                  idxday=GFS_Interstitial(cdata%thrd_no)%idxday,sfcalb1=GFS_Interstitial(cdata%thrd_no)%sfcalb(:,1), &
                  sfcalb2=GFS_Interstitial(cdata%thrd_no)%sfcalb(:,2),sfcalb3=GFS_Interstitial(cdata%thrd_no)%sfcalb(:,3), &
                  sfcalb4=GFS_Interstitial(cdata%thrd_no)%sfcalb(:,4),errmsg=cdata%errmsg, &
                  errflg=cdata%errflg)



      if (cdata%errflg/=0) then
        cdata%errmsg = "An error occured in rrtmg_sw_pre_run: " // trim(cdata%errmsg)
        ierr=cdata%errflg
        return
      end if

    
      


      call rrtmg_sw_run(plyr=GFS_Interstitial(cdata%thrd_no)%plyr,plvl=GFS_Interstitial(cdata%thrd_no)%plvl, &
                  tlyr=GFS_Interstitial(cdata%thrd_no)%tlyr,tlvl=GFS_Interstitial(cdata%thrd_no)%tlvl, &
                  qlyr=GFS_Interstitial(cdata%thrd_no)%qlyr,olyr=GFS_Interstitial(cdata%thrd_no)%olyr, &
                  gasvmr_co2=GFS_Interstitial(cdata%thrd_no)%gasvmr(:,:,1),gasvmr_n2o=GFS_Interstitial(cdata%thrd_no)%gasvmr(:,:,2), &
                  gasvmr_ch4=GFS_Interstitial(cdata%thrd_no)%gasvmr(:,:,3),gasvmr_o2=GFS_Interstitial(cdata%thrd_no)%gasvmr(:,:,4), &
                  gasvmr_co=GFS_Interstitial(cdata%thrd_no)%gasvmr(:,:,5),gasvmr_cfc11=GFS_Interstitial(cdata%thrd_no)%gasvmr(:,:,6), &
                  gasvmr_cfc12=GFS_Interstitial(cdata%thrd_no)%gasvmr(:,:,7),gasvmr_cfc22=GFS_Interstitial(cdata%thrd_no)%gasvmr(:,:,8), &
                  gasvmr_ccl4=GFS_Interstitial(cdata%thrd_no)%gasvmr(:,:,9),icseed=GFS_Data(cdata%blk_no)%Tbd%icsdsw, &
                  aeraod=GFS_Interstitial(cdata%thrd_no)%faersw(:,:,:,1),aerssa=GFS_Interstitial(cdata%thrd_no)%faersw(:,:,:,2), &
                  aerasy=GFS_Interstitial(cdata%thrd_no)%faersw(:,:,:,3),sfcalb_nir_dir=GFS_Interstitial(cdata%thrd_no)%sfcalb(:,1), &
                  sfcalb_nir_dif=GFS_Interstitial(cdata%thrd_no)%sfcalb(:,2),sfcalb_uvis_dir=GFS_Interstitial(cdata%thrd_no)%sfcalb(:,3), &
                  sfcalb_uvis_dif=GFS_Interstitial(cdata%thrd_no)%sfcalb(:,4),dzlyr=GFS_Interstitial(cdata%thrd_no)%dzlyr, &
                  delpin=GFS_Interstitial(cdata%thrd_no)%delr,de_lgth=GFS_Interstitial(cdata%thrd_no)%de_lgth, &
                  alpha=GFS_Interstitial(cdata%thrd_no)%alpha,cosz=GFS_Data(cdata%blk_no)%Radtend%coszen, &
                  solcon=GFS_Control%solcon,nday=GFS_Interstitial(cdata%thrd_no)%nday,idxday=GFS_Interstitial(cdata%thrd_no)%idxday, &
                  npts=GFS_Control%blksz(cdata%blk_no),nlay=GFS_Interstitial(cdata%thrd_no)%lmk, &
                  nlp1=GFS_Interstitial(cdata%thrd_no)%lmp,lprnt=GFS_Control%lprnt,cld_cf=GFS_Interstitial(cdata%thrd_no)%clouds(:,:,1), &
                  lsswr=GFS_Control%lsswr,hswc=GFS_Interstitial(cdata%thrd_no)%htswc,topflx=GFS_Data(cdata%blk_no)%Intdiag%topfsw, &
                  sfcflx=GFS_Data(cdata%blk_no)%Radtend%sfcfsw,cldtau=GFS_Interstitial(cdata%thrd_no)%cldtausw, &
                  hsw0=GFS_Interstitial(cdata%thrd_no)%htsw0,fdncmp=GFS_Interstitial(cdata%thrd_no)%scmpsw, &
                  cld_lwp=GFS_Interstitial(cdata%thrd_no)%clouds(:,:,2),cld_ref_liq=GFS_Interstitial(cdata%thrd_no)%clouds(:,:,3), &
                  cld_iwp=GFS_Interstitial(cdata%thrd_no)%clouds(:,:,4),cld_ref_ice=GFS_Interstitial(cdata%thrd_no)%clouds(:,:,5), &
                  cld_rwp=GFS_Interstitial(cdata%thrd_no)%clouds(:,:,6),cld_ref_rain=GFS_Interstitial(cdata%thrd_no)%clouds(:,:,7), &
                  cld_swp=GFS_Interstitial(cdata%thrd_no)%clouds(:,:,8),cld_ref_snow=GFS_Interstitial(cdata%thrd_no)%clouds(:,:,9), &
                  errmsg=cdata%errmsg,errflg=cdata%errflg)



      if (cdata%errflg/=0) then
        cdata%errmsg = "An error occured in rrtmg_sw_run: " // trim(cdata%errmsg)
        ierr=cdata%errflg
        return
      end if

    
      


      call rrtmg_sw_post_run(im=GFS_Control%blksz(cdata%blk_no),levr=GFS_Interstitial(cdata%thrd_no)%lmk, &
                  levs=GFS_Control%levs,ltp=LTP,nday=GFS_Interstitial(cdata%thrd_no)%nday, &
                  lm=GFS_Control%levr,kd=GFS_Interstitial(cdata%thrd_no)%kd,lsswr=GFS_Control%lsswr, &
                  swhtr=GFS_Control%swhtr,sfcalb1=GFS_Interstitial(cdata%thrd_no)%sfcalb(:,1), &
                  sfcalb2=GFS_Interstitial(cdata%thrd_no)%sfcalb(:,2),sfcalb3=GFS_Interstitial(cdata%thrd_no)%sfcalb(:,3), &
                  sfcalb4=GFS_Interstitial(cdata%thrd_no)%sfcalb(:,4),htswc=GFS_Interstitial(cdata%thrd_no)%htswc, &
                  htsw0=GFS_Interstitial(cdata%thrd_no)%htsw0,nirbmdi=GFS_Data(cdata%blk_no)%Coupling%nirbmdi, &
                  nirdfdi=GFS_Data(cdata%blk_no)%Coupling%nirdfdi,visbmdi=GFS_Data(cdata%blk_no)%Coupling%visbmdi, &
                  visdfdi=GFS_Data(cdata%blk_no)%Coupling%visdfdi,nirbmui=GFS_Data(cdata%blk_no)%Coupling%nirbmui, &
                  nirdfui=GFS_Data(cdata%blk_no)%Coupling%nirdfui,visbmui=GFS_Data(cdata%blk_no)%Coupling%visbmui, &
                  visdfui=GFS_Data(cdata%blk_no)%Coupling%visdfui,sfcdsw=GFS_Data(cdata%blk_no)%Coupling%sfcdsw, &
                  sfcnsw=GFS_Data(cdata%blk_no)%Coupling%sfcnsw,htrsw=GFS_Data(cdata%blk_no)%Radtend%htrsw, &
                  swhc=GFS_Data(cdata%blk_no)%Radtend%swhc,scmpsw=GFS_Interstitial(cdata%thrd_no)%scmpsw, &
                  sfcfsw=GFS_Data(cdata%blk_no)%Radtend%sfcfsw,topfsw=GFS_Data(cdata%blk_no)%Intdiag%topfsw, &
                  errmsg=cdata%errmsg,errflg=cdata%errflg)



      if (cdata%errflg/=0) then
        cdata%errmsg = "An error occured in rrtmg_sw_post_run: " // trim(cdata%errmsg)
        ierr=cdata%errflg
        return
      end if

    
      


      call rrtmg_lw_pre_run(im=GFS_Control%blksz(cdata%blk_no),lslwr=GFS_Control%lslwr,xlat=GFS_Data(cdata%blk_no)%Grid%xlat, &
                  xlon=GFS_Data(cdata%blk_no)%Grid%xlon,slmsk=GFS_Data(cdata%blk_no)%Sfcprop%slmsk, &
                  snowd=GFS_Data(cdata%blk_no)%Sfcprop%snowd,sncovr=GFS_Data(cdata%blk_no)%Sfcprop%sncovr, &
                  zorl=GFS_Data(cdata%blk_no)%Sfcprop%zorl,hprime=GFS_Data(cdata%blk_no)%Sfcprop%hprime(:,1), &
                  tsfg=GFS_Interstitial(cdata%thrd_no)%tsfg,tsfa=GFS_Interstitial(cdata%thrd_no)%tsfa, &
                  semis=GFS_Data(cdata%blk_no)%Radtend%semis,errmsg=cdata%errmsg,errflg=cdata%errflg)



      if (cdata%errflg/=0) then
        cdata%errmsg = "An error occured in rrtmg_lw_pre_run: " // trim(cdata%errmsg)
        ierr=cdata%errflg
        return
      end if

    
      


      call rrtmg_lw_run(plyr=GFS_Interstitial(cdata%thrd_no)%plyr,plvl=GFS_Interstitial(cdata%thrd_no)%plvl, &
                  tlyr=GFS_Interstitial(cdata%thrd_no)%tlyr,tlvl=GFS_Interstitial(cdata%thrd_no)%tlvl, &
                  qlyr=GFS_Interstitial(cdata%thrd_no)%qlyr,olyr=GFS_Interstitial(cdata%thrd_no)%olyr, &
                  gasvmr_co2=GFS_Interstitial(cdata%thrd_no)%gasvmr(:,:,1),gasvmr_n2o=GFS_Interstitial(cdata%thrd_no)%gasvmr(:,:,2), &
                  gasvmr_ch4=GFS_Interstitial(cdata%thrd_no)%gasvmr(:,:,3),gasvmr_o2=GFS_Interstitial(cdata%thrd_no)%gasvmr(:,:,4), &
                  gasvmr_co=GFS_Interstitial(cdata%thrd_no)%gasvmr(:,:,5),gasvmr_cfc11=GFS_Interstitial(cdata%thrd_no)%gasvmr(:,:,6), &
                  gasvmr_cfc12=GFS_Interstitial(cdata%thrd_no)%gasvmr(:,:,7),gasvmr_cfc22=GFS_Interstitial(cdata%thrd_no)%gasvmr(:,:,8), &
                  gasvmr_ccl4=GFS_Interstitial(cdata%thrd_no)%gasvmr(:,:,9),icseed=GFS_Data(cdata%blk_no)%Tbd%icsdlw, &
                  aeraod=GFS_Interstitial(cdata%thrd_no)%faerlw(:,:,:,1),aerssa=GFS_Interstitial(cdata%thrd_no)%faerlw(:,:,:,2), &
                  sfemis=GFS_Data(cdata%blk_no)%Radtend%semis,sfgtmp=GFS_Interstitial(cdata%thrd_no)%tsfg, &
                  dzlyr=GFS_Interstitial(cdata%thrd_no)%dzlyr,delpin=GFS_Interstitial(cdata%thrd_no)%delr, &
                  de_lgth=GFS_Interstitial(cdata%thrd_no)%de_lgth,alpha=GFS_Interstitial(cdata%thrd_no)%alpha, &
                  npts=GFS_Control%blksz(cdata%blk_no),nlay=GFS_Interstitial(cdata%thrd_no)%lmk, &
                  nlp1=GFS_Interstitial(cdata%thrd_no)%lmp,lprnt=GFS_Control%lprnt,cld_cf=GFS_Interstitial(cdata%thrd_no)%clouds(:,:,1), &
                  lslwr=GFS_Control%lslwr,hlwc=GFS_Interstitial(cdata%thrd_no)%htlwc,topflx=GFS_Data(cdata%blk_no)%Intdiag%topflw, &
                  sfcflx=GFS_Data(cdata%blk_no)%Radtend%sfcflw,cldtau=GFS_Interstitial(cdata%thrd_no)%cldtaulw, &
                  hlw0=GFS_Interstitial(cdata%thrd_no)%htlw0,cld_lwp=GFS_Interstitial(cdata%thrd_no)%clouds(:,:,2), &
                  cld_ref_liq=GFS_Interstitial(cdata%thrd_no)%clouds(:,:,3),cld_iwp=GFS_Interstitial(cdata%thrd_no)%clouds(:,:,4), &
                  cld_ref_ice=GFS_Interstitial(cdata%thrd_no)%clouds(:,:,5),cld_rwp=GFS_Interstitial(cdata%thrd_no)%clouds(:,:,6), &
                  cld_ref_rain=GFS_Interstitial(cdata%thrd_no)%clouds(:,:,7),cld_swp=GFS_Interstitial(cdata%thrd_no)%clouds(:,:,8), &
                  cld_ref_snow=GFS_Interstitial(cdata%thrd_no)%clouds(:,:,9),errmsg=cdata%errmsg, &
                  errflg=cdata%errflg)



      if (cdata%errflg/=0) then
        cdata%errmsg = "An error occured in rrtmg_lw_run: " // trim(cdata%errmsg)
        ierr=cdata%errflg
        return
      end if

    
      


      call rrtmg_lw_post_run(im=GFS_Control%blksz(cdata%blk_no),levs=GFS_Control%levs,ltp=LTP,lm=GFS_Control%levr, &
                  kd=GFS_Interstitial(cdata%thrd_no)%kd,lslwr=GFS_Control%lslwr,lwhtr=GFS_Control%lwhtr, &
                  tsfa=GFS_Interstitial(cdata%thrd_no)%tsfa,htlwc=GFS_Interstitial(cdata%thrd_no)%htlwc, &
                  htlw0=GFS_Interstitial(cdata%thrd_no)%htlw0,sfcflw=GFS_Data(cdata%blk_no)%Radtend%sfcflw, &
                  tsflw=GFS_Data(cdata%blk_no)%Radtend%tsflw,sfcdlw=GFS_Data(cdata%blk_no)%Coupling%sfcdlw, &
                  htrlw=GFS_Data(cdata%blk_no)%Radtend%htrlw,lwhc=GFS_Data(cdata%blk_no)%Radtend%lwhc, &
                  errmsg=cdata%errmsg,errflg=cdata%errflg)



      if (cdata%errflg/=0) then
        cdata%errmsg = "An error occured in rrtmg_lw_post_run: " // trim(cdata%errmsg)
        ierr=cdata%errflg
        return
      end if

    
      


      call GFS_rrtmg_post_run(im=GFS_Control%blksz(cdata%blk_no),km=GFS_Control%levs,kmp1=GFS_Control%levsp1, &
                  lm=GFS_Control%levr,ltp=LTP,kt=GFS_Interstitial(cdata%thrd_no)%kt,kb=GFS_Interstitial(cdata%thrd_no)%kb, &
                  kd=GFS_Interstitial(cdata%thrd_no)%kd,nspc1=GFS_Interstitial(cdata%thrd_no)%nspc1, &
                  nfxr=GFS_Control%nfxr,nday=GFS_Interstitial(cdata%thrd_no)%nday,lsswr=GFS_Control%lsswr, &
                  lslwr=GFS_Control%lslwr,lssav=GFS_Control%lssav,fhlwr=GFS_Control%fhlwr, &
                  fhswr=GFS_Control%fhswr,raddt=GFS_Interstitial(cdata%thrd_no)%raddt,coszen=GFS_Data(cdata%blk_no)%Radtend%coszen, &
                  coszdg=GFS_Data(cdata%blk_no)%Radtend%coszdg,prsi=GFS_Data(cdata%blk_no)%Statein%prsi, &
                  tgrs=GFS_Data(cdata%blk_no)%Statein%tgrs,aerodp=GFS_Interstitial(cdata%thrd_no)%aerodp, &
                  cldsa=GFS_Interstitial(cdata%thrd_no)%cldsa,mtopa=GFS_Interstitial(cdata%thrd_no)%mtopa, &
                  mbota=GFS_Interstitial(cdata%thrd_no)%mbota,clouds1=GFS_Interstitial(cdata%thrd_no)%clouds(:,:,1), &
                  cldtaulw=GFS_Interstitial(cdata%thrd_no)%cldtaulw,cldtausw=GFS_Interstitial(cdata%thrd_no)%cldtausw, &
                  sfcflw=GFS_Data(cdata%blk_no)%Radtend%sfcflw,sfcfsw=GFS_Data(cdata%blk_no)%Radtend%sfcfsw, &
                  topflw=GFS_Data(cdata%blk_no)%Intdiag%topflw,topfsw=GFS_Data(cdata%blk_no)%Intdiag%topfsw, &
                  scmpsw=GFS_Interstitial(cdata%thrd_no)%scmpsw,fluxr=GFS_Data(cdata%blk_no)%Intdiag%fluxr, &
                  errmsg=cdata%errmsg,errflg=cdata%errflg)



      if (cdata%errflg/=0) then
        cdata%errmsg = "An error occured in GFS_rrtmg_post_run: " // trim(cdata%errmsg)
        ierr=cdata%errflg
        return
      end if

    



   end function FV3_GFS_2017_gfdlmp_regional_c768_radiation_run_cap

   function FV3_GFS_2017_gfdlmp_regional_c768_radiation_finalize_cap() result(ierr)

      

      implicit none

      ! Error handling
      integer :: ierr

      

      ierr = 0


      if (.not.initialized) return





      initialized = .false.


   end function FV3_GFS_2017_gfdlmp_regional_c768_radiation_finalize_cap

end module ccpp_FV3_GFS_2017_gfdlmp_regional_c768_radiation_cap
