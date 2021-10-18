

#---------------------------------
# New invocation of recon-all jue mar 22 19:34:00 CET 2018 
#--------------------------------------------
#@# MotionCor jue mar 22 19:34:00 CET 2018

 cp /home/neuroimagen0/Documents/FREESURFER/Freesurfer_prediction/Freesurfer/FTD-FPD109/mri/orig/001.mgz /home/neuroimagen0/Documents/FREESURFER/Freesurfer_prediction/Freesurfer/FTD-FPD109/mri/rawavg.mgz 


 mri_convert /home/neuroimagen0/Documents/FREESURFER/Freesurfer_prediction/Freesurfer/FTD-FPD109/mri/rawavg.mgz /home/neuroimagen0/Documents/FREESURFER/Freesurfer_prediction/Freesurfer/FTD-FPD109/mri/orig.mgz --conform 


 mri_add_xform_to_header -c /home/neuroimagen0/Documents/FREESURFER/Freesurfer_prediction/Freesurfer/FTD-FPD109/mri/transforms/talairach.xfm /home/neuroimagen0/Documents/FREESURFER/Freesurfer_prediction/Freesurfer/FTD-FPD109/mri/orig.mgz /home/neuroimagen0/Documents/FREESURFER/Freesurfer_prediction/Freesurfer/FTD-FPD109/mri/orig.mgz 

#--------------------------------------------
#@# Talairach jue mar 22 19:34:06 CET 2018

 mri_nu_correct.mni --no-rescale --i orig.mgz --o orig_nu.mgz --n 1 --proto-iters 1000 --distance 50 


 talairach_avi --i orig_nu.mgz --xfm transforms/talairach.auto.xfm 

talairach_avi log file is transforms/talairach_avi.log...

 cp transforms/talairach.auto.xfm transforms/talairach.xfm 

#--------------------------------------------
#@# Talairach Failure Detection jue mar 22 19:35:33 CET 2018

 talairach_afd -T 0.005 -xfm transforms/talairach.xfm 


 awk -f /usr/local/freesurfer6/bin/extract_talairach_avi_QA.awk /home/neuroimagen0/Documents/FREESURFER/Freesurfer_prediction/Freesurfer/FTD-FPD109/mri/transforms/talairach_avi.log 


 tal_QC_AZS /home/neuroimagen0/Documents/FREESURFER/Freesurfer_prediction/Freesurfer/FTD-FPD109/mri/transforms/talairach_avi.log 

#--------------------------------------------
#@# Nu Intensity Correction jue mar 22 19:35:33 CET 2018

 mri_nu_correct.mni --i orig.mgz --o nu.mgz --uchar transforms/talairach.xfm --n 2 


 mri_add_xform_to_header -c /home/neuroimagen0/Documents/FREESURFER/Freesurfer_prediction/Freesurfer/FTD-FPD109/mri/transforms/talairach.xfm nu.mgz nu.mgz 

#--------------------------------------------
#@# Intensity Normalization jue mar 22 19:37:04 CET 2018

 mri_normalize -g 1 -mprage nu.mgz T1.mgz 

#--------------------------------------------
#@# Skull Stripping jue mar 22 19:38:14 CET 2018

 mri_em_register -rusage /home/neuroimagen0/Documents/FREESURFER/Freesurfer_prediction/Freesurfer/FTD-FPD109/touch/rusage.mri_em_register.skull.dat -skull nu.mgz /usr/local/freesurfer6/average/RB_all_withskull_2016-05-10.vc700.gca transforms/talairach_with_skull.lta 


 mri_watershed -rusage /home/neuroimagen0/Documents/FREESURFER/Freesurfer_prediction/Freesurfer/FTD-FPD109/touch/rusage.mri_watershed.dat -T1 -brain_atlas /usr/local/freesurfer6/average/RB_all_withskull_2016-05-10.vc700.gca transforms/talairach_with_skull.lta T1.mgz brainmask.auto.mgz 


 cp brainmask.auto.mgz brainmask.mgz 

#-------------------------------------
#@# EM Registration jue mar 22 19:48:25 CET 2018

 mri_em_register -rusage /home/neuroimagen0/Documents/FREESURFER/Freesurfer_prediction/Freesurfer/FTD-FPD109/touch/rusage.mri_em_register.dat -uns 3 -mask brainmask.mgz nu.mgz /usr/local/freesurfer6/average/RB_all_2016-05-10.vc700.gca transforms/talairach.lta 

#--------------------------------------
#@# CA Normalize jue mar 22 19:56:48 CET 2018

 mri_ca_normalize -c ctrl_pts.mgz -mask brainmask.mgz nu.mgz /usr/local/freesurfer6/average/RB_all_2016-05-10.vc700.gca transforms/talairach.lta norm.mgz 

#--------------------------------------
#@# CA Reg jue mar 22 19:57:37 CET 2018

 mri_ca_register -rusage /home/neuroimagen0/Documents/FREESURFER/Freesurfer_prediction/Freesurfer/FTD-FPD109/touch/rusage.mri_ca_register.dat -nobigventricles -T transforms/talairach.lta -align-after -mask brainmask.mgz norm.mgz /usr/local/freesurfer6/average/RB_all_2016-05-10.vc700.gca transforms/talairach.m3z 

#--------------------------------------
#@# SubCort Seg jue mar 22 23:30:58 CET 2018

 mri_ca_label -relabel_unlikely 9 .3 -prior 0.5 -align norm.mgz transforms/talairach.m3z /usr/local/freesurfer6/average/RB_all_2016-05-10.vc700.gca aseg.auto_noCCseg.mgz 


 mri_cc -aseg aseg.auto_noCCseg.mgz -o aseg.auto.mgz -lta /home/neuroimagen0/Documents/FREESURFER/Freesurfer_prediction/Freesurfer/FTD-FPD109/mri/transforms/cc_up.lta FTD-FPD109 

#--------------------------------------
#@# Merge ASeg vie mar 23 00:05:48 CET 2018

 cp aseg.auto.mgz aseg.presurf.mgz 

#--------------------------------------------
#@# Intensity Normalization2 vie mar 23 00:05:48 CET 2018

 mri_normalize -mprage -aseg aseg.presurf.mgz -mask brainmask.mgz norm.mgz brain.mgz 

#--------------------------------------------
#@# Mask BFS vie mar 23 00:08:18 CET 2018

 mri_mask -T 5 brain.mgz brainmask.mgz brain.finalsurfs.mgz 

#--------------------------------------------
#@# WM Segmentation vie mar 23 00:08:19 CET 2018

 mri_segment -mprage brain.mgz wm.seg.mgz 


 mri_edit_wm_with_aseg -keep-in wm.seg.mgz brain.mgz aseg.presurf.mgz wm.asegedit.mgz 


 mri_pretess wm.asegedit.mgz wm norm.mgz wm.mgz 

#--------------------------------------------
#@# Fill vie mar 23 00:09:34 CET 2018

 mri_fill -a ../scripts/ponscc.cut.log -xform transforms/talairach.lta -segmentation aseg.auto_noCCseg.mgz wm.mgz filled.mgz 

#--------------------------------------------
#@# Tessellate lh vie mar 23 00:10:00 CET 2018

 mri_pretess ../mri/filled.mgz 255 ../mri/norm.mgz ../mri/filled-pretess255.mgz 


 mri_tessellate ../mri/filled-pretess255.mgz 255 ../surf/lh.orig.nofix 


 rm -f ../mri/filled-pretess255.mgz 


 mris_extract_main_component ../surf/lh.orig.nofix ../surf/lh.orig.nofix 

#--------------------------------------------
#@# Tessellate rh vie mar 23 00:10:03 CET 2018

 mri_pretess ../mri/filled.mgz 127 ../mri/norm.mgz ../mri/filled-pretess127.mgz 


 mri_tessellate ../mri/filled-pretess127.mgz 127 ../surf/rh.orig.nofix 


 rm -f ../mri/filled-pretess127.mgz 


 mris_extract_main_component ../surf/rh.orig.nofix ../surf/rh.orig.nofix 

#--------------------------------------------
#@# Smooth1 lh vie mar 23 00:10:07 CET 2018

 mris_smooth -nw -seed 1234 ../surf/lh.orig.nofix ../surf/lh.smoothwm.nofix 

#--------------------------------------------
#@# Smooth1 rh vie mar 23 00:10:12 CET 2018

 mris_smooth -nw -seed 1234 ../surf/rh.orig.nofix ../surf/rh.smoothwm.nofix 

#--------------------------------------------
#@# Inflation1 lh vie mar 23 00:10:15 CET 2018

 mris_inflate -no-save-sulc ../surf/lh.smoothwm.nofix ../surf/lh.inflated.nofix 

#--------------------------------------------
#@# Inflation1 rh vie mar 23 00:10:51 CET 2018

 mris_inflate -no-save-sulc ../surf/rh.smoothwm.nofix ../surf/rh.inflated.nofix 

#--------------------------------------------
#@# QSphere lh vie mar 23 00:11:32 CET 2018

 mris_sphere -q -seed 1234 ../surf/lh.inflated.nofix ../surf/lh.qsphere.nofix 

#--------------------------------------------
#@# QSphere rh vie mar 23 00:15:24 CET 2018

 mris_sphere -q -seed 1234 ../surf/rh.inflated.nofix ../surf/rh.qsphere.nofix 

#--------------------------------------------
#@# Fix Topology Copy lh vie mar 23 00:19:18 CET 2018

 cp ../surf/lh.orig.nofix ../surf/lh.orig 


 cp ../surf/lh.inflated.nofix ../surf/lh.inflated 

#--------------------------------------------
#@# Fix Topology Copy rh vie mar 23 00:19:18 CET 2018

 cp ../surf/rh.orig.nofix ../surf/rh.orig 


 cp ../surf/rh.inflated.nofix ../surf/rh.inflated 

#@# Fix Topology lh vie mar 23 00:19:18 CET 2018

 mris_fix_topology -rusage /home/neuroimagen0/Documents/FREESURFER/Freesurfer_prediction/Freesurfer/FTD-FPD109/touch/rusage.mris_fix_topology.lh.dat -mgz -sphere qsphere.nofix -ga -seed 1234 FTD-FPD109 lh 

#@# Fix Topology rh vie mar 23 00:30:16 CET 2018

 mris_fix_topology -rusage /home/neuroimagen0/Documents/FREESURFER/Freesurfer_prediction/Freesurfer/FTD-FPD109/touch/rusage.mris_fix_topology.rh.dat -mgz -sphere qsphere.nofix -ga -seed 1234 FTD-FPD109 rh 


 mris_euler_number ../surf/lh.orig 


 mris_euler_number ../surf/rh.orig 


 mris_remove_intersection ../surf/lh.orig ../surf/lh.orig 


 rm ../surf/lh.inflated 


 mris_remove_intersection ../surf/rh.orig ../surf/rh.orig 


 rm ../surf/rh.inflated 

#--------------------------------------------
#@# Make White Surf lh vie mar 23 00:39:07 CET 2018

 mris_make_surfaces -aseg ../mri/aseg.presurf -white white.preaparc -noaparc -whiteonly -mgz -T1 brain.finalsurfs FTD-FPD109 lh 

#--------------------------------------------
#@# Make White Surf rh vie mar 23 00:42:21 CET 2018

 mris_make_surfaces -aseg ../mri/aseg.presurf -white white.preaparc -noaparc -whiteonly -mgz -T1 brain.finalsurfs FTD-FPD109 rh 

#--------------------------------------------
#@# Smooth2 lh vie mar 23 00:45:33 CET 2018

 mris_smooth -n 3 -nw -seed 1234 ../surf/lh.white.preaparc ../surf/lh.smoothwm 

#--------------------------------------------
#@# Smooth2 rh vie mar 23 00:45:38 CET 2018

 mris_smooth -n 3 -nw -seed 1234 ../surf/rh.white.preaparc ../surf/rh.smoothwm 

#--------------------------------------------
#@# Inflation2 lh vie mar 23 00:45:42 CET 2018

 mris_inflate -rusage /home/neuroimagen0/Documents/FREESURFER/Freesurfer_prediction/Freesurfer/FTD-FPD109/touch/rusage.mris_inflate.lh.dat ../surf/lh.smoothwm ../surf/lh.inflated 

#--------------------------------------------
#@# Inflation2 rh vie mar 23 00:46:31 CET 2018

 mris_inflate -rusage /home/neuroimagen0/Documents/FREESURFER/Freesurfer_prediction/Freesurfer/FTD-FPD109/touch/rusage.mris_inflate.rh.dat ../surf/rh.smoothwm ../surf/rh.inflated 

#--------------------------------------------
#@# Curv .H and .K lh vie mar 23 00:47:22 CET 2018

 mris_curvature -w lh.white.preaparc 


 mris_curvature -thresh .999 -n -a 5 -w -distances 10 10 lh.inflated 

#--------------------------------------------
#@# Curv .H and .K rh vie mar 23 00:48:09 CET 2018

 mris_curvature -w rh.white.preaparc 


 mris_curvature -thresh .999 -n -a 5 -w -distances 10 10 rh.inflated 


#-----------------------------------------
#@# Curvature Stats lh vie mar 23 00:48:57 CET 2018

 mris_curvature_stats -m --writeCurvatureFiles -G -o ../stats/lh.curv.stats -F smoothwm FTD-FPD109 lh curv sulc 


#-----------------------------------------
#@# Curvature Stats rh vie mar 23 00:49:00 CET 2018

 mris_curvature_stats -m --writeCurvatureFiles -G -o ../stats/rh.curv.stats -F smoothwm FTD-FPD109 rh curv sulc 

#--------------------------------------------
#@# Sphere lh vie mar 23 00:49:03 CET 2018

 mris_sphere -rusage /home/neuroimagen0/Documents/FREESURFER/Freesurfer_prediction/Freesurfer/FTD-FPD109/touch/rusage.mris_sphere.lh.dat -seed 1234 ../surf/lh.inflated ../surf/lh.sphere 

#--------------------------------------------
#@# Sphere rh vie mar 23 01:31:57 CET 2018

 mris_sphere -rusage /home/neuroimagen0/Documents/FREESURFER/Freesurfer_prediction/Freesurfer/FTD-FPD109/touch/rusage.mris_sphere.rh.dat -seed 1234 ../surf/rh.inflated ../surf/rh.sphere 

#--------------------------------------------
#@# Surf Reg lh vie mar 23 02:22:25 CET 2018

 mris_register -curv -rusage /home/neuroimagen0/Documents/FREESURFER/Freesurfer_prediction/Freesurfer/FTD-FPD109/touch/rusage.mris_register.lh.dat ../surf/lh.sphere /usr/local/freesurfer6/average/lh.folding.atlas.acfb40.noaparc.i12.2016-08-02.tif ../surf/lh.sphere.reg 

#--------------------------------------------
#@# Surf Reg rh vie mar 23 03:24:18 CET 2018

 mris_register -curv -rusage /home/neuroimagen0/Documents/FREESURFER/Freesurfer_prediction/Freesurfer/FTD-FPD109/touch/rusage.mris_register.rh.dat ../surf/rh.sphere /usr/local/freesurfer6/average/rh.folding.atlas.acfb40.noaparc.i12.2016-08-02.tif ../surf/rh.sphere.reg 

#--------------------------------------------
#@# Jacobian white lh vie mar 23 04:41:49 CET 2018

 mris_jacobian ../surf/lh.white.preaparc ../surf/lh.sphere.reg ../surf/lh.jacobian_white 

#--------------------------------------------
#@# Jacobian white rh vie mar 23 04:41:51 CET 2018

 mris_jacobian ../surf/rh.white.preaparc ../surf/rh.sphere.reg ../surf/rh.jacobian_white 

#--------------------------------------------
#@# AvgCurv lh vie mar 23 04:41:53 CET 2018

 mrisp_paint -a 5 /usr/local/freesurfer6/average/lh.folding.atlas.acfb40.noaparc.i12.2016-08-02.tif#6 ../surf/lh.sphere.reg ../surf/lh.avg_curv 

#--------------------------------------------
#@# AvgCurv rh vie mar 23 04:41:54 CET 2018

 mrisp_paint -a 5 /usr/local/freesurfer6/average/rh.folding.atlas.acfb40.noaparc.i12.2016-08-02.tif#6 ../surf/rh.sphere.reg ../surf/rh.avg_curv 

#-----------------------------------------
#@# Cortical Parc lh vie mar 23 04:41:56 CET 2018

 mris_ca_label -l ../label/lh.cortex.label -aseg ../mri/aseg.presurf.mgz -seed 1234 FTD-FPD109 lh ../surf/lh.sphere.reg /usr/local/freesurfer6/average/lh.DKaparc.atlas.acfb40.noaparc.i12.2016-08-02.gcs ../label/lh.aparc.annot 

#-----------------------------------------
#@# Cortical Parc rh vie mar 23 04:42:09 CET 2018

 mris_ca_label -l ../label/rh.cortex.label -aseg ../mri/aseg.presurf.mgz -seed 1234 FTD-FPD109 rh ../surf/rh.sphere.reg /usr/local/freesurfer6/average/rh.DKaparc.atlas.acfb40.noaparc.i12.2016-08-02.gcs ../label/rh.aparc.annot 

#--------------------------------------------
#@# Make Pial Surf lh vie mar 23 04:42:22 CET 2018

 mris_make_surfaces -orig_white white.preaparc -orig_pial white.preaparc -aseg ../mri/aseg.presurf -mgz -T1 brain.finalsurfs FTD-FPD109 lh 

#--------------------------------------------
#@# Make Pial Surf rh vie mar 23 04:52:25 CET 2018

 mris_make_surfaces -orig_white white.preaparc -orig_pial white.preaparc -aseg ../mri/aseg.presurf -mgz -T1 brain.finalsurfs FTD-FPD109 rh 

#--------------------------------------------
#@# Surf Volume lh vie mar 23 05:02:22 CET 2018
#--------------------------------------------
#@# Surf Volume rh vie mar 23 05:02:24 CET 2018
#--------------------------------------------
#@# Cortical ribbon mask vie mar 23 05:02:27 CET 2018

 mris_volmask --aseg_name aseg.presurf --label_left_white 2 --label_left_ribbon 3 --label_right_white 41 --label_right_ribbon 42 --save_ribbon FTD-FPD109 

#-----------------------------------------
#@# Parcellation Stats lh vie mar 23 05:10:42 CET 2018

 mris_anatomical_stats -th3 -mgz -cortex ../label/lh.cortex.label -f ../stats/lh.aparc.stats -b -a ../label/lh.aparc.annot -c ../label/aparc.annot.ctab FTD-FPD109 lh white 


 mris_anatomical_stats -th3 -mgz -cortex ../label/lh.cortex.label -f ../stats/lh.aparc.pial.stats -b -a ../label/lh.aparc.annot -c ../label/aparc.annot.ctab FTD-FPD109 lh pial 

#-----------------------------------------
#@# Parcellation Stats rh vie mar 23 05:11:34 CET 2018

 mris_anatomical_stats -th3 -mgz -cortex ../label/rh.cortex.label -f ../stats/rh.aparc.stats -b -a ../label/rh.aparc.annot -c ../label/aparc.annot.ctab FTD-FPD109 rh white 


 mris_anatomical_stats -th3 -mgz -cortex ../label/rh.cortex.label -f ../stats/rh.aparc.pial.stats -b -a ../label/rh.aparc.annot -c ../label/aparc.annot.ctab FTD-FPD109 rh pial 

#-----------------------------------------
#@# Cortical Parc 2 lh vie mar 23 05:12:23 CET 2018

 mris_ca_label -l ../label/lh.cortex.label -aseg ../mri/aseg.presurf.mgz -seed 1234 FTD-FPD109 lh ../surf/lh.sphere.reg /usr/local/freesurfer6/average/lh.CDaparc.atlas.acfb40.noaparc.i12.2016-08-02.gcs ../label/lh.aparc.a2009s.annot 

#-----------------------------------------
#@# Cortical Parc 2 rh vie mar 23 05:12:35 CET 2018

 mris_ca_label -l ../label/rh.cortex.label -aseg ../mri/aseg.presurf.mgz -seed 1234 FTD-FPD109 rh ../surf/rh.sphere.reg /usr/local/freesurfer6/average/rh.CDaparc.atlas.acfb40.noaparc.i12.2016-08-02.gcs ../label/rh.aparc.a2009s.annot 

#-----------------------------------------
#@# Parcellation Stats 2 lh vie mar 23 05:12:48 CET 2018

 mris_anatomical_stats -th3 -mgz -cortex ../label/lh.cortex.label -f ../stats/lh.aparc.a2009s.stats -b -a ../label/lh.aparc.a2009s.annot -c ../label/aparc.annot.a2009s.ctab FTD-FPD109 lh white 

#-----------------------------------------
#@# Parcellation Stats 2 rh vie mar 23 05:13:14 CET 2018

 mris_anatomical_stats -th3 -mgz -cortex ../label/rh.cortex.label -f ../stats/rh.aparc.a2009s.stats -b -a ../label/rh.aparc.a2009s.annot -c ../label/aparc.annot.a2009s.ctab FTD-FPD109 rh white 

#-----------------------------------------
#@# Cortical Parc 3 lh vie mar 23 05:13:41 CET 2018

 mris_ca_label -l ../label/lh.cortex.label -aseg ../mri/aseg.presurf.mgz -seed 1234 FTD-FPD109 lh ../surf/lh.sphere.reg /usr/local/freesurfer6/average/lh.DKTaparc.atlas.acfb40.noaparc.i12.2016-08-02.gcs ../label/lh.aparc.DKTatlas.annot 

#-----------------------------------------
#@# Cortical Parc 3 rh vie mar 23 05:13:52 CET 2018

 mris_ca_label -l ../label/rh.cortex.label -aseg ../mri/aseg.presurf.mgz -seed 1234 FTD-FPD109 rh ../surf/rh.sphere.reg /usr/local/freesurfer6/average/rh.DKTaparc.atlas.acfb40.noaparc.i12.2016-08-02.gcs ../label/rh.aparc.DKTatlas.annot 

#-----------------------------------------
#@# Parcellation Stats 3 lh vie mar 23 05:14:04 CET 2018

 mris_anatomical_stats -th3 -mgz -cortex ../label/lh.cortex.label -f ../stats/lh.aparc.DKTatlas.stats -b -a ../label/lh.aparc.DKTatlas.annot -c ../label/aparc.annot.DKTatlas.ctab FTD-FPD109 lh white 

#-----------------------------------------
#@# Parcellation Stats 3 rh vie mar 23 05:14:28 CET 2018

 mris_anatomical_stats -th3 -mgz -cortex ../label/rh.cortex.label -f ../stats/rh.aparc.DKTatlas.stats -b -a ../label/rh.aparc.DKTatlas.annot -c ../label/aparc.annot.DKTatlas.ctab FTD-FPD109 rh white 

#-----------------------------------------
#@# WM/GM Contrast lh vie mar 23 05:14:52 CET 2018

 pctsurfcon --s FTD-FPD109 --lh-only 

#-----------------------------------------
#@# WM/GM Contrast rh vie mar 23 05:14:57 CET 2018

 pctsurfcon --s FTD-FPD109 --rh-only 

#-----------------------------------------
#@# Relabel Hypointensities vie mar 23 05:15:01 CET 2018

 mri_relabel_hypointensities aseg.presurf.mgz ../surf aseg.presurf.hypos.mgz 

#-----------------------------------------
#@# AParc-to-ASeg aparc vie mar 23 05:15:15 CET 2018

 mri_aparc2aseg --s FTD-FPD109 --volmask --aseg aseg.presurf.hypos --relabel mri/norm.mgz mri/transforms/talairach.m3z /usr/local/freesurfer6/average/RB_all_2016-05-10.vc700.gca mri/aseg.auto_noCCseg.label_intensities.txt 

#-----------------------------------------
#@# AParc-to-ASeg a2009s vie mar 23 05:18:24 CET 2018

 mri_aparc2aseg --s FTD-FPD109 --volmask --aseg aseg.presurf.hypos --relabel mri/norm.mgz mri/transforms/talairach.m3z /usr/local/freesurfer6/average/RB_all_2016-05-10.vc700.gca mri/aseg.auto_noCCseg.label_intensities.txt --a2009s 

#-----------------------------------------
#@# AParc-to-ASeg DKTatlas vie mar 23 05:21:28 CET 2018

 mri_aparc2aseg --s FTD-FPD109 --volmask --aseg aseg.presurf.hypos --relabel mri/norm.mgz mri/transforms/talairach.m3z /usr/local/freesurfer6/average/RB_all_2016-05-10.vc700.gca mri/aseg.auto_noCCseg.label_intensities.txt --annot aparc.DKTatlas --o mri/aparc.DKTatlas+aseg.mgz 

#-----------------------------------------
#@# APas-to-ASeg vie mar 23 05:24:30 CET 2018

 apas2aseg --i aparc+aseg.mgz --o aseg.mgz 

#--------------------------------------------
#@# ASeg Stats vie mar 23 05:24:36 CET 2018

 mri_segstats --seg mri/aseg.mgz --sum stats/aseg.stats --pv mri/norm.mgz --empty --brainmask mri/brainmask.mgz --brain-vol-from-seg --excludeid 0 --excl-ctxgmwm --supratent --subcortgray --in mri/norm.mgz --in-intensity-name norm --in-intensity-units MR --etiv --surf-wm-vol --surf-ctx-vol --totalgray --euler --ctab /usr/local/freesurfer6/ASegStatsLUT.txt --subject FTD-FPD109 

#-----------------------------------------
#@# WMParc vie mar 23 05:28:11 CET 2018

 mri_aparc2aseg --s FTD-FPD109 --labelwm --hypo-as-wm --rip-unknown --volmask --o mri/wmparc.mgz --ctxseg aparc+aseg.mgz 


 mri_segstats --seg mri/wmparc.mgz --sum stats/wmparc.stats --pv mri/norm.mgz --excludeid 0 --brainmask mri/brainmask.mgz --in mri/norm.mgz --in-intensity-name norm --in-intensity-units MR --subject FTD-FPD109 --surf-wm-vol --ctab /usr/local/freesurfer6/WMParcStatsLUT.txt --etiv 

#--------------------------------------------
#@# BA_exvivo Labels lh vie mar 23 05:38:05 CET 2018

 mri_label2label --srcsubject fsaverage --srclabel /home/neuroimagen0/Documents/FREESURFER/Freesurfer_prediction/Freesurfer/fsaverage/label/lh.BA1_exvivo.label --trgsubject FTD-FPD109 --trglabel ./lh.BA1_exvivo.label --hemi lh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /home/neuroimagen0/Documents/FREESURFER/Freesurfer_prediction/Freesurfer/fsaverage/label/lh.BA2_exvivo.label --trgsubject FTD-FPD109 --trglabel ./lh.BA2_exvivo.label --hemi lh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /home/neuroimagen0/Documents/FREESURFER/Freesurfer_prediction/Freesurfer/fsaverage/label/lh.BA3a_exvivo.label --trgsubject FTD-FPD109 --trglabel ./lh.BA3a_exvivo.label --hemi lh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /home/neuroimagen0/Documents/FREESURFER/Freesurfer_prediction/Freesurfer/fsaverage/label/lh.BA3b_exvivo.label --trgsubject FTD-FPD109 --trglabel ./lh.BA3b_exvivo.label --hemi lh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /home/neuroimagen0/Documents/FREESURFER/Freesurfer_prediction/Freesurfer/fsaverage/label/lh.BA4a_exvivo.label --trgsubject FTD-FPD109 --trglabel ./lh.BA4a_exvivo.label --hemi lh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /home/neuroimagen0/Documents/FREESURFER/Freesurfer_prediction/Freesurfer/fsaverage/label/lh.BA4p_exvivo.label --trgsubject FTD-FPD109 --trglabel ./lh.BA4p_exvivo.label --hemi lh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /home/neuroimagen0/Documents/FREESURFER/Freesurfer_prediction/Freesurfer/fsaverage/label/lh.BA6_exvivo.label --trgsubject FTD-FPD109 --trglabel ./lh.BA6_exvivo.label --hemi lh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /home/neuroimagen0/Documents/FREESURFER/Freesurfer_prediction/Freesurfer/fsaverage/label/lh.BA44_exvivo.label --trgsubject FTD-FPD109 --trglabel ./lh.BA44_exvivo.label --hemi lh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /home/neuroimagen0/Documents/FREESURFER/Freesurfer_prediction/Freesurfer/fsaverage/label/lh.BA45_exvivo.label --trgsubject FTD-FPD109 --trglabel ./lh.BA45_exvivo.label --hemi lh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /home/neuroimagen0/Documents/FREESURFER/Freesurfer_prediction/Freesurfer/fsaverage/label/lh.V1_exvivo.label --trgsubject FTD-FPD109 --trglabel ./lh.V1_exvivo.label --hemi lh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /home/neuroimagen0/Documents/FREESURFER/Freesurfer_prediction/Freesurfer/fsaverage/label/lh.V2_exvivo.label --trgsubject FTD-FPD109 --trglabel ./lh.V2_exvivo.label --hemi lh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /home/neuroimagen0/Documents/FREESURFER/Freesurfer_prediction/Freesurfer/fsaverage/label/lh.MT_exvivo.label --trgsubject FTD-FPD109 --trglabel ./lh.MT_exvivo.label --hemi lh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /home/neuroimagen0/Documents/FREESURFER/Freesurfer_prediction/Freesurfer/fsaverage/label/lh.entorhinal_exvivo.label --trgsubject FTD-FPD109 --trglabel ./lh.entorhinal_exvivo.label --hemi lh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /home/neuroimagen0/Documents/FREESURFER/Freesurfer_prediction/Freesurfer/fsaverage/label/lh.perirhinal_exvivo.label --trgsubject FTD-FPD109 --trglabel ./lh.perirhinal_exvivo.label --hemi lh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /home/neuroimagen0/Documents/FREESURFER/Freesurfer_prediction/Freesurfer/fsaverage/label/lh.BA1_exvivo.thresh.label --trgsubject FTD-FPD109 --trglabel ./lh.BA1_exvivo.thresh.label --hemi lh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /home/neuroimagen0/Documents/FREESURFER/Freesurfer_prediction/Freesurfer/fsaverage/label/lh.BA2_exvivo.thresh.label --trgsubject FTD-FPD109 --trglabel ./lh.BA2_exvivo.thresh.label --hemi lh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /home/neuroimagen0/Documents/FREESURFER/Freesurfer_prediction/Freesurfer/fsaverage/label/lh.BA3a_exvivo.thresh.label --trgsubject FTD-FPD109 --trglabel ./lh.BA3a_exvivo.thresh.label --hemi lh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /home/neuroimagen0/Documents/FREESURFER/Freesurfer_prediction/Freesurfer/fsaverage/label/lh.BA3b_exvivo.thresh.label --trgsubject FTD-FPD109 --trglabel ./lh.BA3b_exvivo.thresh.label --hemi lh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /home/neuroimagen0/Documents/FREESURFER/Freesurfer_prediction/Freesurfer/fsaverage/label/lh.BA4a_exvivo.thresh.label --trgsubject FTD-FPD109 --trglabel ./lh.BA4a_exvivo.thresh.label --hemi lh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /home/neuroimagen0/Documents/FREESURFER/Freesurfer_prediction/Freesurfer/fsaverage/label/lh.BA4p_exvivo.thresh.label --trgsubject FTD-FPD109 --trglabel ./lh.BA4p_exvivo.thresh.label --hemi lh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /home/neuroimagen0/Documents/FREESURFER/Freesurfer_prediction/Freesurfer/fsaverage/label/lh.BA6_exvivo.thresh.label --trgsubject FTD-FPD109 --trglabel ./lh.BA6_exvivo.thresh.label --hemi lh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /home/neuroimagen0/Documents/FREESURFER/Freesurfer_prediction/Freesurfer/fsaverage/label/lh.BA44_exvivo.thresh.label --trgsubject FTD-FPD109 --trglabel ./lh.BA44_exvivo.thresh.label --hemi lh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /home/neuroimagen0/Documents/FREESURFER/Freesurfer_prediction/Freesurfer/fsaverage/label/lh.BA45_exvivo.thresh.label --trgsubject FTD-FPD109 --trglabel ./lh.BA45_exvivo.thresh.label --hemi lh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /home/neuroimagen0/Documents/FREESURFER/Freesurfer_prediction/Freesurfer/fsaverage/label/lh.V1_exvivo.thresh.label --trgsubject FTD-FPD109 --trglabel ./lh.V1_exvivo.thresh.label --hemi lh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /home/neuroimagen0/Documents/FREESURFER/Freesurfer_prediction/Freesurfer/fsaverage/label/lh.V2_exvivo.thresh.label --trgsubject FTD-FPD109 --trglabel ./lh.V2_exvivo.thresh.label --hemi lh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /home/neuroimagen0/Documents/FREESURFER/Freesurfer_prediction/Freesurfer/fsaverage/label/lh.MT_exvivo.thresh.label --trgsubject FTD-FPD109 --trglabel ./lh.MT_exvivo.thresh.label --hemi lh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /home/neuroimagen0/Documents/FREESURFER/Freesurfer_prediction/Freesurfer/fsaverage/label/lh.entorhinal_exvivo.thresh.label --trgsubject FTD-FPD109 --trglabel ./lh.entorhinal_exvivo.thresh.label --hemi lh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /home/neuroimagen0/Documents/FREESURFER/Freesurfer_prediction/Freesurfer/fsaverage/label/lh.perirhinal_exvivo.thresh.label --trgsubject FTD-FPD109 --trglabel ./lh.perirhinal_exvivo.thresh.label --hemi lh --regmethod surface 


 mris_label2annot --s FTD-FPD109 --hemi lh --ctab /usr/local/freesurfer6/average/colortable_BA.txt --l lh.BA1_exvivo.label --l lh.BA2_exvivo.label --l lh.BA3a_exvivo.label --l lh.BA3b_exvivo.label --l lh.BA4a_exvivo.label --l lh.BA4p_exvivo.label --l lh.BA6_exvivo.label --l lh.BA44_exvivo.label --l lh.BA45_exvivo.label --l lh.V1_exvivo.label --l lh.V2_exvivo.label --l lh.MT_exvivo.label --l lh.entorhinal_exvivo.label --l lh.perirhinal_exvivo.label --a BA_exvivo --maxstatwinner --noverbose 


 mris_label2annot --s FTD-FPD109 --hemi lh --ctab /usr/local/freesurfer6/average/colortable_BA.txt --l lh.BA1_exvivo.thresh.label --l lh.BA2_exvivo.thresh.label --l lh.BA3a_exvivo.thresh.label --l lh.BA3b_exvivo.thresh.label --l lh.BA4a_exvivo.thresh.label --l lh.BA4p_exvivo.thresh.label --l lh.BA6_exvivo.thresh.label --l lh.BA44_exvivo.thresh.label --l lh.BA45_exvivo.thresh.label --l lh.V1_exvivo.thresh.label --l lh.V2_exvivo.thresh.label --l lh.MT_exvivo.thresh.label --l lh.entorhinal_exvivo.thresh.label --l lh.perirhinal_exvivo.thresh.label --a BA_exvivo.thresh --maxstatwinner --noverbose 


 mris_anatomical_stats -th3 -mgz -f ../stats/lh.BA_exvivo.stats -b -a ./lh.BA_exvivo.annot -c ./BA_exvivo.ctab FTD-FPD109 lh white 


 mris_anatomical_stats -th3 -mgz -f ../stats/lh.BA_exvivo.thresh.stats -b -a ./lh.BA_exvivo.thresh.annot -c ./BA_exvivo.thresh.ctab FTD-FPD109 lh white 

#--------------------------------------------
#@# BA_exvivo Labels rh vie mar 23 05:42:14 CET 2018

 mri_label2label --srcsubject fsaverage --srclabel /home/neuroimagen0/Documents/FREESURFER/Freesurfer_prediction/Freesurfer/fsaverage/label/rh.BA1_exvivo.label --trgsubject FTD-FPD109 --trglabel ./rh.BA1_exvivo.label --hemi rh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /home/neuroimagen0/Documents/FREESURFER/Freesurfer_prediction/Freesurfer/fsaverage/label/rh.BA2_exvivo.label --trgsubject FTD-FPD109 --trglabel ./rh.BA2_exvivo.label --hemi rh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /home/neuroimagen0/Documents/FREESURFER/Freesurfer_prediction/Freesurfer/fsaverage/label/rh.BA3a_exvivo.label --trgsubject FTD-FPD109 --trglabel ./rh.BA3a_exvivo.label --hemi rh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /home/neuroimagen0/Documents/FREESURFER/Freesurfer_prediction/Freesurfer/fsaverage/label/rh.BA3b_exvivo.label --trgsubject FTD-FPD109 --trglabel ./rh.BA3b_exvivo.label --hemi rh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /home/neuroimagen0/Documents/FREESURFER/Freesurfer_prediction/Freesurfer/fsaverage/label/rh.BA4a_exvivo.label --trgsubject FTD-FPD109 --trglabel ./rh.BA4a_exvivo.label --hemi rh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /home/neuroimagen0/Documents/FREESURFER/Freesurfer_prediction/Freesurfer/fsaverage/label/rh.BA4p_exvivo.label --trgsubject FTD-FPD109 --trglabel ./rh.BA4p_exvivo.label --hemi rh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /home/neuroimagen0/Documents/FREESURFER/Freesurfer_prediction/Freesurfer/fsaverage/label/rh.BA6_exvivo.label --trgsubject FTD-FPD109 --trglabel ./rh.BA6_exvivo.label --hemi rh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /home/neuroimagen0/Documents/FREESURFER/Freesurfer_prediction/Freesurfer/fsaverage/label/rh.BA44_exvivo.label --trgsubject FTD-FPD109 --trglabel ./rh.BA44_exvivo.label --hemi rh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /home/neuroimagen0/Documents/FREESURFER/Freesurfer_prediction/Freesurfer/fsaverage/label/rh.BA45_exvivo.label --trgsubject FTD-FPD109 --trglabel ./rh.BA45_exvivo.label --hemi rh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /home/neuroimagen0/Documents/FREESURFER/Freesurfer_prediction/Freesurfer/fsaverage/label/rh.V1_exvivo.label --trgsubject FTD-FPD109 --trglabel ./rh.V1_exvivo.label --hemi rh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /home/neuroimagen0/Documents/FREESURFER/Freesurfer_prediction/Freesurfer/fsaverage/label/rh.V2_exvivo.label --trgsubject FTD-FPD109 --trglabel ./rh.V2_exvivo.label --hemi rh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /home/neuroimagen0/Documents/FREESURFER/Freesurfer_prediction/Freesurfer/fsaverage/label/rh.MT_exvivo.label --trgsubject FTD-FPD109 --trglabel ./rh.MT_exvivo.label --hemi rh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /home/neuroimagen0/Documents/FREESURFER/Freesurfer_prediction/Freesurfer/fsaverage/label/rh.entorhinal_exvivo.label --trgsubject FTD-FPD109 --trglabel ./rh.entorhinal_exvivo.label --hemi rh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /home/neuroimagen0/Documents/FREESURFER/Freesurfer_prediction/Freesurfer/fsaverage/label/rh.perirhinal_exvivo.label --trgsubject FTD-FPD109 --trglabel ./rh.perirhinal_exvivo.label --hemi rh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /home/neuroimagen0/Documents/FREESURFER/Freesurfer_prediction/Freesurfer/fsaverage/label/rh.BA1_exvivo.thresh.label --trgsubject FTD-FPD109 --trglabel ./rh.BA1_exvivo.thresh.label --hemi rh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /home/neuroimagen0/Documents/FREESURFER/Freesurfer_prediction/Freesurfer/fsaverage/label/rh.BA2_exvivo.thresh.label --trgsubject FTD-FPD109 --trglabel ./rh.BA2_exvivo.thresh.label --hemi rh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /home/neuroimagen0/Documents/FREESURFER/Freesurfer_prediction/Freesurfer/fsaverage/label/rh.BA3a_exvivo.thresh.label --trgsubject FTD-FPD109 --trglabel ./rh.BA3a_exvivo.thresh.label --hemi rh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /home/neuroimagen0/Documents/FREESURFER/Freesurfer_prediction/Freesurfer/fsaverage/label/rh.BA3b_exvivo.thresh.label --trgsubject FTD-FPD109 --trglabel ./rh.BA3b_exvivo.thresh.label --hemi rh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /home/neuroimagen0/Documents/FREESURFER/Freesurfer_prediction/Freesurfer/fsaverage/label/rh.BA4a_exvivo.thresh.label --trgsubject FTD-FPD109 --trglabel ./rh.BA4a_exvivo.thresh.label --hemi rh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /home/neuroimagen0/Documents/FREESURFER/Freesurfer_prediction/Freesurfer/fsaverage/label/rh.BA4p_exvivo.thresh.label --trgsubject FTD-FPD109 --trglabel ./rh.BA4p_exvivo.thresh.label --hemi rh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /home/neuroimagen0/Documents/FREESURFER/Freesurfer_prediction/Freesurfer/fsaverage/label/rh.BA6_exvivo.thresh.label --trgsubject FTD-FPD109 --trglabel ./rh.BA6_exvivo.thresh.label --hemi rh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /home/neuroimagen0/Documents/FREESURFER/Freesurfer_prediction/Freesurfer/fsaverage/label/rh.BA44_exvivo.thresh.label --trgsubject FTD-FPD109 --trglabel ./rh.BA44_exvivo.thresh.label --hemi rh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /home/neuroimagen0/Documents/FREESURFER/Freesurfer_prediction/Freesurfer/fsaverage/label/rh.BA45_exvivo.thresh.label --trgsubject FTD-FPD109 --trglabel ./rh.BA45_exvivo.thresh.label --hemi rh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /home/neuroimagen0/Documents/FREESURFER/Freesurfer_prediction/Freesurfer/fsaverage/label/rh.V1_exvivo.thresh.label --trgsubject FTD-FPD109 --trglabel ./rh.V1_exvivo.thresh.label --hemi rh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /home/neuroimagen0/Documents/FREESURFER/Freesurfer_prediction/Freesurfer/fsaverage/label/rh.V2_exvivo.thresh.label --trgsubject FTD-FPD109 --trglabel ./rh.V2_exvivo.thresh.label --hemi rh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /home/neuroimagen0/Documents/FREESURFER/Freesurfer_prediction/Freesurfer/fsaverage/label/rh.MT_exvivo.thresh.label --trgsubject FTD-FPD109 --trglabel ./rh.MT_exvivo.thresh.label --hemi rh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /home/neuroimagen0/Documents/FREESURFER/Freesurfer_prediction/Freesurfer/fsaverage/label/rh.entorhinal_exvivo.thresh.label --trgsubject FTD-FPD109 --trglabel ./rh.entorhinal_exvivo.thresh.label --hemi rh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /home/neuroimagen0/Documents/FREESURFER/Freesurfer_prediction/Freesurfer/fsaverage/label/rh.perirhinal_exvivo.thresh.label --trgsubject FTD-FPD109 --trglabel ./rh.perirhinal_exvivo.thresh.label --hemi rh --regmethod surface 


 mris_label2annot --s FTD-FPD109 --hemi rh --ctab /usr/local/freesurfer6/average/colortable_BA.txt --l rh.BA1_exvivo.label --l rh.BA2_exvivo.label --l rh.BA3a_exvivo.label --l rh.BA3b_exvivo.label --l rh.BA4a_exvivo.label --l rh.BA4p_exvivo.label --l rh.BA6_exvivo.label --l rh.BA44_exvivo.label --l rh.BA45_exvivo.label --l rh.V1_exvivo.label --l rh.V2_exvivo.label --l rh.MT_exvivo.label --l rh.entorhinal_exvivo.label --l rh.perirhinal_exvivo.label --a BA_exvivo --maxstatwinner --noverbose 


 mris_label2annot --s FTD-FPD109 --hemi rh --ctab /usr/local/freesurfer6/average/colortable_BA.txt --l rh.BA1_exvivo.thresh.label --l rh.BA2_exvivo.thresh.label --l rh.BA3a_exvivo.thresh.label --l rh.BA3b_exvivo.thresh.label --l rh.BA4a_exvivo.thresh.label --l rh.BA4p_exvivo.thresh.label --l rh.BA6_exvivo.thresh.label --l rh.BA44_exvivo.thresh.label --l rh.BA45_exvivo.thresh.label --l rh.V1_exvivo.thresh.label --l rh.V2_exvivo.thresh.label --l rh.MT_exvivo.thresh.label --l rh.entorhinal_exvivo.thresh.label --l rh.perirhinal_exvivo.thresh.label --a BA_exvivo.thresh --maxstatwinner --noverbose 


 mris_anatomical_stats -th3 -mgz -f ../stats/rh.BA_exvivo.stats -b -a ./rh.BA_exvivo.annot -c ./BA_exvivo.ctab FTD-FPD109 rh white 


 mris_anatomical_stats -th3 -mgz -f ../stats/rh.BA_exvivo.thresh.stats -b -a ./rh.BA_exvivo.thresh.annot -c ./BA_exvivo.thresh.ctab FTD-FPD109 rh white 



#---------------------------------
# New invocation of recon-all mié abr  4 02:01:11 CEST 2018 
#--------------------------------------------
#@# Intensity Normalization2 mié abr  4 02:01:11 CEST 2018

 mri_normalize -mprage -aseg aseg.presurf.mgz -mask brainmask.mgz norm.mgz brain.mgz 

#--------------------------------------------
#@# Mask BFS mié abr  4 02:03:20 CEST 2018

 mri_mask -T 5 brain.mgz brainmask.mgz brain.finalsurfs.mgz 

#--------------------------------------------
#@# WM Segmentation mié abr  4 02:03:21 CEST 2018

 mri_binarize --i wm.mgz --min 255 --max 255 --o wm255.mgz --count wm255.txt 


 mri_binarize --i wm.mgz --min 1 --max 1 --o wm1.mgz --count wm1.txt 


 rm wm1.mgz wm255.mgz 


 cp wm.mgz wm.seg.mgz 


 mri_segment -keep -mprage brain.mgz wm.seg.mgz 


 mri_edit_wm_with_aseg -keep-in wm.seg.mgz brain.mgz aseg.presurf.mgz wm.asegedit.mgz 


 mri_pretess -keep wm.asegedit.mgz wm norm.mgz wm.mgz 

#--------------------------------------------
#@# Fill mié abr  4 02:04:42 CEST 2018

 mri_fill -a ../scripts/ponscc.cut.log -xform transforms/talairach.lta -segmentation aseg.auto_noCCseg.mgz wm.mgz filled.mgz 

#--------------------------------------------
#@# Tessellate lh mié abr  4 02:05:12 CEST 2018

 mri_pretess ../mri/filled.mgz 255 ../mri/norm.mgz ../mri/filled-pretess255.mgz 


 mri_tessellate ../mri/filled-pretess255.mgz 255 ../surf/lh.orig.nofix 


 rm -f ../mri/filled-pretess255.mgz 


 mris_extract_main_component ../surf/lh.orig.nofix ../surf/lh.orig.nofix 

#--------------------------------------------
#@# Tessellate rh mié abr  4 02:05:16 CEST 2018

 mri_pretess ../mri/filled.mgz 127 ../mri/norm.mgz ../mri/filled-pretess127.mgz 


 mri_tessellate ../mri/filled-pretess127.mgz 127 ../surf/rh.orig.nofix 


 rm -f ../mri/filled-pretess127.mgz 


 mris_extract_main_component ../surf/rh.orig.nofix ../surf/rh.orig.nofix 

#--------------------------------------------
#@# Smooth1 lh mié abr  4 02:05:21 CEST 2018

 mris_smooth -nw -seed 1234 ../surf/lh.orig.nofix ../surf/lh.smoothwm.nofix 

#--------------------------------------------
#@# Smooth1 rh mié abr  4 02:05:25 CEST 2018

 mris_smooth -nw -seed 1234 ../surf/rh.orig.nofix ../surf/rh.smoothwm.nofix 

#--------------------------------------------
#@# Inflation1 lh mié abr  4 02:05:28 CEST 2018

 mris_inflate -no-save-sulc ../surf/lh.smoothwm.nofix ../surf/lh.inflated.nofix 

#--------------------------------------------
#@# Inflation1 rh mié abr  4 02:05:59 CEST 2018

 mris_inflate -no-save-sulc ../surf/rh.smoothwm.nofix ../surf/rh.inflated.nofix 

#--------------------------------------------
#@# QSphere lh mié abr  4 02:06:43 CEST 2018

 mris_sphere -q -seed 1234 ../surf/lh.inflated.nofix ../surf/lh.qsphere.nofix 

#--------------------------------------------
#@# QSphere rh mié abr  4 02:10:25 CEST 2018

 mris_sphere -q -seed 1234 ../surf/rh.inflated.nofix ../surf/rh.qsphere.nofix 

#--------------------------------------------
#@# Fix Topology Copy lh mié abr  4 02:14:35 CEST 2018

 cp ../surf/lh.orig.nofix ../surf/lh.orig 


 cp ../surf/lh.inflated.nofix ../surf/lh.inflated 

#--------------------------------------------
#@# Fix Topology Copy rh mié abr  4 02:14:35 CEST 2018

 cp ../surf/rh.orig.nofix ../surf/rh.orig 


 cp ../surf/rh.inflated.nofix ../surf/rh.inflated 

#@# Fix Topology lh mié abr  4 02:14:35 CEST 2018

 mris_fix_topology -rusage /home/neuroimagen0/Documents/FREESURFER/Freesurfer_prediction/Freesurfer/WM/s2/FTD-FPD109/touch/rusage.mris_fix_topology.lh.dat -mgz -sphere qsphere.nofix -ga -seed 1234 FTD-FPD109 lh 

#@# Fix Topology rh mié abr  4 02:20:32 CEST 2018

 mris_fix_topology -rusage /home/neuroimagen0/Documents/FREESURFER/Freesurfer_prediction/Freesurfer/WM/s2/FTD-FPD109/touch/rusage.mris_fix_topology.rh.dat -mgz -sphere qsphere.nofix -ga -seed 1234 FTD-FPD109 rh 


 mris_euler_number ../surf/lh.orig 


 mris_euler_number ../surf/rh.orig 


 mris_remove_intersection ../surf/lh.orig ../surf/lh.orig 


 rm ../surf/lh.inflated 


 mris_remove_intersection ../surf/rh.orig ../surf/rh.orig 


 rm ../surf/rh.inflated 

#--------------------------------------------
#@# Make White Surf lh mié abr  4 02:26:57 CEST 2018

 mris_make_surfaces -aseg ../mri/aseg.presurf -white white.preaparc -noaparc -whiteonly -mgz -T1 brain.finalsurfs FTD-FPD109 lh 

#--------------------------------------------
#@# Make White Surf rh mié abr  4 02:30:09 CEST 2018

 mris_make_surfaces -aseg ../mri/aseg.presurf -white white.preaparc -noaparc -whiteonly -mgz -T1 brain.finalsurfs FTD-FPD109 rh 

#--------------------------------------------
#@# Smooth2 lh mié abr  4 02:33:10 CEST 2018

 mris_smooth -n 3 -nw -seed 1234 ../surf/lh.white.preaparc ../surf/lh.smoothwm 

#--------------------------------------------
#@# Smooth2 rh mié abr  4 02:33:14 CEST 2018

 mris_smooth -n 3 -nw -seed 1234 ../surf/rh.white.preaparc ../surf/rh.smoothwm 

#--------------------------------------------
#@# Inflation2 lh mié abr  4 02:33:18 CEST 2018

 mris_inflate -rusage /home/neuroimagen0/Documents/FREESURFER/Freesurfer_prediction/Freesurfer/WM/s2/FTD-FPD109/touch/rusage.mris_inflate.lh.dat ../surf/lh.smoothwm ../surf/lh.inflated 

#--------------------------------------------
#@# Inflation2 rh mié abr  4 02:34:01 CEST 2018

 mris_inflate -rusage /home/neuroimagen0/Documents/FREESURFER/Freesurfer_prediction/Freesurfer/WM/s2/FTD-FPD109/touch/rusage.mris_inflate.rh.dat ../surf/rh.smoothwm ../surf/rh.inflated 

#--------------------------------------------
#@# Curv .H and .K lh mié abr  4 02:34:46 CEST 2018

 mris_curvature -w lh.white.preaparc 


 mris_curvature -thresh .999 -n -a 5 -w -distances 10 10 lh.inflated 

#--------------------------------------------
#@# Curv .H and .K rh mié abr  4 02:35:31 CEST 2018

 mris_curvature -w rh.white.preaparc 


 mris_curvature -thresh .999 -n -a 5 -w -distances 10 10 rh.inflated 


#-----------------------------------------
#@# Curvature Stats lh mié abr  4 02:36:16 CEST 2018

 mris_curvature_stats -m --writeCurvatureFiles -G -o ../stats/lh.curv.stats -F smoothwm FTD-FPD109 lh curv sulc 


#-----------------------------------------
#@# Curvature Stats rh mié abr  4 02:36:19 CEST 2018

 mris_curvature_stats -m --writeCurvatureFiles -G -o ../stats/rh.curv.stats -F smoothwm FTD-FPD109 rh curv sulc 

#--------------------------------------------
#@# Sphere lh mié abr  4 02:36:22 CEST 2018

 mris_sphere -rusage /home/neuroimagen0/Documents/FREESURFER/Freesurfer_prediction/Freesurfer/WM/s2/FTD-FPD109/touch/rusage.mris_sphere.lh.dat -seed 1234 ../surf/lh.inflated ../surf/lh.sphere 

#--------------------------------------------
#@# Sphere rh mié abr  4 03:07:13 CEST 2018

 mris_sphere -rusage /home/neuroimagen0/Documents/FREESURFER/Freesurfer_prediction/Freesurfer/WM/s2/FTD-FPD109/touch/rusage.mris_sphere.rh.dat -seed 1234 ../surf/rh.inflated ../surf/rh.sphere 

#--------------------------------------------
#@# Surf Reg lh mié abr  4 03:55:13 CEST 2018

 mris_register -curv -rusage /home/neuroimagen0/Documents/FREESURFER/Freesurfer_prediction/Freesurfer/WM/s2/FTD-FPD109/touch/rusage.mris_register.lh.dat ../surf/lh.sphere /usr/local/freesurfer6/average/lh.folding.atlas.acfb40.noaparc.i12.2016-08-02.tif ../surf/lh.sphere.reg 

#--------------------------------------------
#@# Surf Reg rh mié abr  4 04:49:42 CEST 2018

 mris_register -curv -rusage /home/neuroimagen0/Documents/FREESURFER/Freesurfer_prediction/Freesurfer/WM/s2/FTD-FPD109/touch/rusage.mris_register.rh.dat ../surf/rh.sphere /usr/local/freesurfer6/average/rh.folding.atlas.acfb40.noaparc.i12.2016-08-02.tif ../surf/rh.sphere.reg 

#--------------------------------------------
#@# Jacobian white lh mié abr  4 06:06:23 CEST 2018

 mris_jacobian ../surf/lh.white.preaparc ../surf/lh.sphere.reg ../surf/lh.jacobian_white 

#--------------------------------------------
#@# Jacobian white rh mié abr  4 06:06:25 CEST 2018

 mris_jacobian ../surf/rh.white.preaparc ../surf/rh.sphere.reg ../surf/rh.jacobian_white 

#--------------------------------------------
#@# AvgCurv lh mié abr  4 06:06:27 CEST 2018

 mrisp_paint -a 5 /usr/local/freesurfer6/average/lh.folding.atlas.acfb40.noaparc.i12.2016-08-02.tif#6 ../surf/lh.sphere.reg ../surf/lh.avg_curv 

#--------------------------------------------
#@# AvgCurv rh mié abr  4 06:06:29 CEST 2018

 mrisp_paint -a 5 /usr/local/freesurfer6/average/rh.folding.atlas.acfb40.noaparc.i12.2016-08-02.tif#6 ../surf/rh.sphere.reg ../surf/rh.avg_curv 

#-----------------------------------------
#@# Cortical Parc lh mié abr  4 06:06:30 CEST 2018

 mris_ca_label -l ../label/lh.cortex.label -aseg ../mri/aseg.presurf.mgz -seed 1234 FTD-FPD109 lh ../surf/lh.sphere.reg /usr/local/freesurfer6/average/lh.DKaparc.atlas.acfb40.noaparc.i12.2016-08-02.gcs ../label/lh.aparc.annot 

#-----------------------------------------
#@# Cortical Parc rh mié abr  4 06:06:43 CEST 2018

 mris_ca_label -l ../label/rh.cortex.label -aseg ../mri/aseg.presurf.mgz -seed 1234 FTD-FPD109 rh ../surf/rh.sphere.reg /usr/local/freesurfer6/average/rh.DKaparc.atlas.acfb40.noaparc.i12.2016-08-02.gcs ../label/rh.aparc.annot 

#--------------------------------------------
#@# Make Pial Surf lh mié abr  4 06:06:55 CEST 2018

 mris_make_surfaces -orig_white white.preaparc -orig_pial white.preaparc -aseg ../mri/aseg.presurf -mgz -T1 brain.finalsurfs FTD-FPD109 lh 

#--------------------------------------------
#@# Make Pial Surf rh mié abr  4 06:16:47 CEST 2018

 mris_make_surfaces -orig_white white.preaparc -orig_pial white.preaparc -aseg ../mri/aseg.presurf -mgz -T1 brain.finalsurfs FTD-FPD109 rh 

#--------------------------------------------
#@# Surf Volume lh mié abr  4 06:26:40 CEST 2018
#--------------------------------------------
#@# Surf Volume rh mié abr  4 06:26:43 CEST 2018
#--------------------------------------------
#@# Cortical ribbon mask mié abr  4 06:26:46 CEST 2018

 mris_volmask --aseg_name aseg.presurf --label_left_white 2 --label_left_ribbon 3 --label_right_white 41 --label_right_ribbon 42 --save_ribbon FTD-FPD109 

#-----------------------------------------
#@# Parcellation Stats lh mié abr  4 06:36:41 CEST 2018

 mris_anatomical_stats -th3 -mgz -cortex ../label/lh.cortex.label -f ../stats/lh.aparc.stats -b -a ../label/lh.aparc.annot -c ../label/aparc.annot.ctab FTD-FPD109 lh white 


 mris_anatomical_stats -th3 -mgz -cortex ../label/lh.cortex.label -f ../stats/lh.aparc.pial.stats -b -a ../label/lh.aparc.annot -c ../label/aparc.annot.ctab FTD-FPD109 lh pial 

#-----------------------------------------
#@# Parcellation Stats rh mié abr  4 06:37:25 CEST 2018

 mris_anatomical_stats -th3 -mgz -cortex ../label/rh.cortex.label -f ../stats/rh.aparc.stats -b -a ../label/rh.aparc.annot -c ../label/aparc.annot.ctab FTD-FPD109 rh white 


 mris_anatomical_stats -th3 -mgz -cortex ../label/rh.cortex.label -f ../stats/rh.aparc.pial.stats -b -a ../label/rh.aparc.annot -c ../label/aparc.annot.ctab FTD-FPD109 rh pial 

#-----------------------------------------
#@# Cortical Parc 2 lh mié abr  4 06:38:29 CEST 2018

 mris_ca_label -l ../label/lh.cortex.label -aseg ../mri/aseg.presurf.mgz -seed 1234 FTD-FPD109 lh ../surf/lh.sphere.reg /usr/local/freesurfer6/average/lh.CDaparc.atlas.acfb40.noaparc.i12.2016-08-02.gcs ../label/lh.aparc.a2009s.annot 

#-----------------------------------------
#@# Cortical Parc 2 rh mié abr  4 06:38:42 CEST 2018

 mris_ca_label -l ../label/rh.cortex.label -aseg ../mri/aseg.presurf.mgz -seed 1234 FTD-FPD109 rh ../surf/rh.sphere.reg /usr/local/freesurfer6/average/rh.CDaparc.atlas.acfb40.noaparc.i12.2016-08-02.gcs ../label/rh.aparc.a2009s.annot 

#-----------------------------------------
#@# Parcellation Stats 2 lh mié abr  4 06:38:55 CEST 2018

 mris_anatomical_stats -th3 -mgz -cortex ../label/lh.cortex.label -f ../stats/lh.aparc.a2009s.stats -b -a ../label/lh.aparc.a2009s.annot -c ../label/aparc.annot.a2009s.ctab FTD-FPD109 lh white 

#-----------------------------------------
#@# Parcellation Stats 2 rh mié abr  4 06:39:18 CEST 2018

 mris_anatomical_stats -th3 -mgz -cortex ../label/rh.cortex.label -f ../stats/rh.aparc.a2009s.stats -b -a ../label/rh.aparc.a2009s.annot -c ../label/aparc.annot.a2009s.ctab FTD-FPD109 rh white 

#-----------------------------------------
#@# Cortical Parc 3 lh mié abr  4 06:39:43 CEST 2018

 mris_ca_label -l ../label/lh.cortex.label -aseg ../mri/aseg.presurf.mgz -seed 1234 FTD-FPD109 lh ../surf/lh.sphere.reg /usr/local/freesurfer6/average/lh.DKTaparc.atlas.acfb40.noaparc.i12.2016-08-02.gcs ../label/lh.aparc.DKTatlas.annot 

#-----------------------------------------
#@# Cortical Parc 3 rh mié abr  4 06:39:53 CEST 2018

 mris_ca_label -l ../label/rh.cortex.label -aseg ../mri/aseg.presurf.mgz -seed 1234 FTD-FPD109 rh ../surf/rh.sphere.reg /usr/local/freesurfer6/average/rh.DKTaparc.atlas.acfb40.noaparc.i12.2016-08-02.gcs ../label/rh.aparc.DKTatlas.annot 

#-----------------------------------------
#@# Parcellation Stats 3 lh mié abr  4 06:40:02 CEST 2018

 mris_anatomical_stats -th3 -mgz -cortex ../label/lh.cortex.label -f ../stats/lh.aparc.DKTatlas.stats -b -a ../label/lh.aparc.DKTatlas.annot -c ../label/aparc.annot.DKTatlas.ctab FTD-FPD109 lh white 

#-----------------------------------------
#@# Parcellation Stats 3 rh mié abr  4 06:40:24 CEST 2018

 mris_anatomical_stats -th3 -mgz -cortex ../label/rh.cortex.label -f ../stats/rh.aparc.DKTatlas.stats -b -a ../label/rh.aparc.DKTatlas.annot -c ../label/aparc.annot.DKTatlas.ctab FTD-FPD109 rh white 

#-----------------------------------------
#@# WM/GM Contrast lh mié abr  4 06:40:49 CEST 2018

 pctsurfcon --s FTD-FPD109 --lh-only 

#-----------------------------------------
#@# WM/GM Contrast rh mié abr  4 06:40:53 CEST 2018

 pctsurfcon --s FTD-FPD109 --rh-only 

#-----------------------------------------
#@# Relabel Hypointensities mié abr  4 06:40:58 CEST 2018

 mri_relabel_hypointensities aseg.presurf.mgz ../surf aseg.presurf.hypos.mgz 

#-----------------------------------------
#@# AParc-to-ASeg aparc mié abr  4 06:41:13 CEST 2018

 mri_aparc2aseg --s FTD-FPD109 --volmask --aseg aseg.presurf.hypos --relabel mri/norm.mgz mri/transforms/talairach.m3z /usr/local/freesurfer6/average/RB_all_2016-05-10.vc700.gca mri/aseg.auto_noCCseg.label_intensities.txt 

#-----------------------------------------
#@# AParc-to-ASeg a2009s mié abr  4 06:44:27 CEST 2018

 mri_aparc2aseg --s FTD-FPD109 --volmask --aseg aseg.presurf.hypos --relabel mri/norm.mgz mri/transforms/talairach.m3z /usr/local/freesurfer6/average/RB_all_2016-05-10.vc700.gca mri/aseg.auto_noCCseg.label_intensities.txt --a2009s 

#-----------------------------------------
#@# AParc-to-ASeg DKTatlas mié abr  4 06:47:32 CEST 2018

 mri_aparc2aseg --s FTD-FPD109 --volmask --aseg aseg.presurf.hypos --relabel mri/norm.mgz mri/transforms/talairach.m3z /usr/local/freesurfer6/average/RB_all_2016-05-10.vc700.gca mri/aseg.auto_noCCseg.label_intensities.txt --annot aparc.DKTatlas --o mri/aparc.DKTatlas+aseg.mgz 

#-----------------------------------------
#@# APas-to-ASeg mié abr  4 06:50:32 CEST 2018

 apas2aseg --i aparc+aseg.mgz --o aseg.mgz 

#--------------------------------------------
#@# ASeg Stats mié abr  4 06:50:36 CEST 2018

 mri_segstats --seg mri/aseg.mgz --sum stats/aseg.stats --pv mri/norm.mgz --empty --brainmask mri/brainmask.mgz --brain-vol-from-seg --excludeid 0 --excl-ctxgmwm --supratent --subcortgray --in mri/norm.mgz --in-intensity-name norm --in-intensity-units MR --etiv --surf-wm-vol --surf-ctx-vol --totalgray --euler --ctab /usr/local/freesurfer6/ASegStatsLUT.txt --subject FTD-FPD109 

#-----------------------------------------
#@# WMParc mié abr  4 06:54:38 CEST 2018

 mri_aparc2aseg --s FTD-FPD109 --labelwm --hypo-as-wm --rip-unknown --volmask --o mri/wmparc.mgz --ctxseg aparc+aseg.mgz 


 mri_segstats --seg mri/wmparc.mgz --sum stats/wmparc.stats --pv mri/norm.mgz --excludeid 0 --brainmask mri/brainmask.mgz --in mri/norm.mgz --in-intensity-name norm --in-intensity-units MR --subject FTD-FPD109 --surf-wm-vol --ctab /usr/local/freesurfer6/WMParcStatsLUT.txt --etiv 

#--------------------------------------------
#@# BA_exvivo Labels lh mié abr  4 07:05:08 CEST 2018

 mri_label2label --srcsubject fsaverage --srclabel /home/neuroimagen0/Documents/FREESURFER/Freesurfer_prediction/Freesurfer/WM/s2/fsaverage/label/lh.BA1_exvivo.label --trgsubject FTD-FPD109 --trglabel ./lh.BA1_exvivo.label --hemi lh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /home/neuroimagen0/Documents/FREESURFER/Freesurfer_prediction/Freesurfer/WM/s2/fsaverage/label/lh.BA2_exvivo.label --trgsubject FTD-FPD109 --trglabel ./lh.BA2_exvivo.label --hemi lh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /home/neuroimagen0/Documents/FREESURFER/Freesurfer_prediction/Freesurfer/WM/s2/fsaverage/label/lh.BA3a_exvivo.label --trgsubject FTD-FPD109 --trglabel ./lh.BA3a_exvivo.label --hemi lh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /home/neuroimagen0/Documents/FREESURFER/Freesurfer_prediction/Freesurfer/WM/s2/fsaverage/label/lh.BA3b_exvivo.label --trgsubject FTD-FPD109 --trglabel ./lh.BA3b_exvivo.label --hemi lh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /home/neuroimagen0/Documents/FREESURFER/Freesurfer_prediction/Freesurfer/WM/s2/fsaverage/label/lh.BA4a_exvivo.label --trgsubject FTD-FPD109 --trglabel ./lh.BA4a_exvivo.label --hemi lh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /home/neuroimagen0/Documents/FREESURFER/Freesurfer_prediction/Freesurfer/WM/s2/fsaverage/label/lh.BA4p_exvivo.label --trgsubject FTD-FPD109 --trglabel ./lh.BA4p_exvivo.label --hemi lh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /home/neuroimagen0/Documents/FREESURFER/Freesurfer_prediction/Freesurfer/WM/s2/fsaverage/label/lh.BA6_exvivo.label --trgsubject FTD-FPD109 --trglabel ./lh.BA6_exvivo.label --hemi lh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /home/neuroimagen0/Documents/FREESURFER/Freesurfer_prediction/Freesurfer/WM/s2/fsaverage/label/lh.BA44_exvivo.label --trgsubject FTD-FPD109 --trglabel ./lh.BA44_exvivo.label --hemi lh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /home/neuroimagen0/Documents/FREESURFER/Freesurfer_prediction/Freesurfer/WM/s2/fsaverage/label/lh.BA45_exvivo.label --trgsubject FTD-FPD109 --trglabel ./lh.BA45_exvivo.label --hemi lh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /home/neuroimagen0/Documents/FREESURFER/Freesurfer_prediction/Freesurfer/WM/s2/fsaverage/label/lh.V1_exvivo.label --trgsubject FTD-FPD109 --trglabel ./lh.V1_exvivo.label --hemi lh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /home/neuroimagen0/Documents/FREESURFER/Freesurfer_prediction/Freesurfer/WM/s2/fsaverage/label/lh.V2_exvivo.label --trgsubject FTD-FPD109 --trglabel ./lh.V2_exvivo.label --hemi lh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /home/neuroimagen0/Documents/FREESURFER/Freesurfer_prediction/Freesurfer/WM/s2/fsaverage/label/lh.MT_exvivo.label --trgsubject FTD-FPD109 --trglabel ./lh.MT_exvivo.label --hemi lh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /home/neuroimagen0/Documents/FREESURFER/Freesurfer_prediction/Freesurfer/WM/s2/fsaverage/label/lh.entorhinal_exvivo.label --trgsubject FTD-FPD109 --trglabel ./lh.entorhinal_exvivo.label --hemi lh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /home/neuroimagen0/Documents/FREESURFER/Freesurfer_prediction/Freesurfer/WM/s2/fsaverage/label/lh.perirhinal_exvivo.label --trgsubject FTD-FPD109 --trglabel ./lh.perirhinal_exvivo.label --hemi lh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /home/neuroimagen0/Documents/FREESURFER/Freesurfer_prediction/Freesurfer/WM/s2/fsaverage/label/lh.BA1_exvivo.thresh.label --trgsubject FTD-FPD109 --trglabel ./lh.BA1_exvivo.thresh.label --hemi lh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /home/neuroimagen0/Documents/FREESURFER/Freesurfer_prediction/Freesurfer/WM/s2/fsaverage/label/lh.BA2_exvivo.thresh.label --trgsubject FTD-FPD109 --trglabel ./lh.BA2_exvivo.thresh.label --hemi lh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /home/neuroimagen0/Documents/FREESURFER/Freesurfer_prediction/Freesurfer/WM/s2/fsaverage/label/lh.BA3a_exvivo.thresh.label --trgsubject FTD-FPD109 --trglabel ./lh.BA3a_exvivo.thresh.label --hemi lh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /home/neuroimagen0/Documents/FREESURFER/Freesurfer_prediction/Freesurfer/WM/s2/fsaverage/label/lh.BA3b_exvivo.thresh.label --trgsubject FTD-FPD109 --trglabel ./lh.BA3b_exvivo.thresh.label --hemi lh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /home/neuroimagen0/Documents/FREESURFER/Freesurfer_prediction/Freesurfer/WM/s2/fsaverage/label/lh.BA4a_exvivo.thresh.label --trgsubject FTD-FPD109 --trglabel ./lh.BA4a_exvivo.thresh.label --hemi lh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /home/neuroimagen0/Documents/FREESURFER/Freesurfer_prediction/Freesurfer/WM/s2/fsaverage/label/lh.BA4p_exvivo.thresh.label --trgsubject FTD-FPD109 --trglabel ./lh.BA4p_exvivo.thresh.label --hemi lh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /home/neuroimagen0/Documents/FREESURFER/Freesurfer_prediction/Freesurfer/WM/s2/fsaverage/label/lh.BA6_exvivo.thresh.label --trgsubject FTD-FPD109 --trglabel ./lh.BA6_exvivo.thresh.label --hemi lh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /home/neuroimagen0/Documents/FREESURFER/Freesurfer_prediction/Freesurfer/WM/s2/fsaverage/label/lh.BA44_exvivo.thresh.label --trgsubject FTD-FPD109 --trglabel ./lh.BA44_exvivo.thresh.label --hemi lh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /home/neuroimagen0/Documents/FREESURFER/Freesurfer_prediction/Freesurfer/WM/s2/fsaverage/label/lh.BA45_exvivo.thresh.label --trgsubject FTD-FPD109 --trglabel ./lh.BA45_exvivo.thresh.label --hemi lh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /home/neuroimagen0/Documents/FREESURFER/Freesurfer_prediction/Freesurfer/WM/s2/fsaverage/label/lh.V1_exvivo.thresh.label --trgsubject FTD-FPD109 --trglabel ./lh.V1_exvivo.thresh.label --hemi lh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /home/neuroimagen0/Documents/FREESURFER/Freesurfer_prediction/Freesurfer/WM/s2/fsaverage/label/lh.V2_exvivo.thresh.label --trgsubject FTD-FPD109 --trglabel ./lh.V2_exvivo.thresh.label --hemi lh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /home/neuroimagen0/Documents/FREESURFER/Freesurfer_prediction/Freesurfer/WM/s2/fsaverage/label/lh.MT_exvivo.thresh.label --trgsubject FTD-FPD109 --trglabel ./lh.MT_exvivo.thresh.label --hemi lh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /home/neuroimagen0/Documents/FREESURFER/Freesurfer_prediction/Freesurfer/WM/s2/fsaverage/label/lh.entorhinal_exvivo.thresh.label --trgsubject FTD-FPD109 --trglabel ./lh.entorhinal_exvivo.thresh.label --hemi lh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /home/neuroimagen0/Documents/FREESURFER/Freesurfer_prediction/Freesurfer/WM/s2/fsaverage/label/lh.perirhinal_exvivo.thresh.label --trgsubject FTD-FPD109 --trglabel ./lh.perirhinal_exvivo.thresh.label --hemi lh --regmethod surface 


 mris_label2annot --s FTD-FPD109 --hemi lh --ctab /usr/local/freesurfer6/average/colortable_BA.txt --l lh.BA1_exvivo.label --l lh.BA2_exvivo.label --l lh.BA3a_exvivo.label --l lh.BA3b_exvivo.label --l lh.BA4a_exvivo.label --l lh.BA4p_exvivo.label --l lh.BA6_exvivo.label --l lh.BA44_exvivo.label --l lh.BA45_exvivo.label --l lh.V1_exvivo.label --l lh.V2_exvivo.label --l lh.MT_exvivo.label --l lh.entorhinal_exvivo.label --l lh.perirhinal_exvivo.label --a BA_exvivo --maxstatwinner --noverbose 


 mris_label2annot --s FTD-FPD109 --hemi lh --ctab /usr/local/freesurfer6/average/colortable_BA.txt --l lh.BA1_exvivo.thresh.label --l lh.BA2_exvivo.thresh.label --l lh.BA3a_exvivo.thresh.label --l lh.BA3b_exvivo.thresh.label --l lh.BA4a_exvivo.thresh.label --l lh.BA4p_exvivo.thresh.label --l lh.BA6_exvivo.thresh.label --l lh.BA44_exvivo.thresh.label --l lh.BA45_exvivo.thresh.label --l lh.V1_exvivo.thresh.label --l lh.V2_exvivo.thresh.label --l lh.MT_exvivo.thresh.label --l lh.entorhinal_exvivo.thresh.label --l lh.perirhinal_exvivo.thresh.label --a BA_exvivo.thresh --maxstatwinner --noverbose 


 mris_anatomical_stats -th3 -mgz -f ../stats/lh.BA_exvivo.stats -b -a ./lh.BA_exvivo.annot -c ./BA_exvivo.ctab FTD-FPD109 lh white 


 mris_anatomical_stats -th3 -mgz -f ../stats/lh.BA_exvivo.thresh.stats -b -a ./lh.BA_exvivo.thresh.annot -c ./BA_exvivo.thresh.ctab FTD-FPD109 lh white 

#--------------------------------------------
#@# BA_exvivo Labels rh mié abr  4 07:09:29 CEST 2018

 mri_label2label --srcsubject fsaverage --srclabel /home/neuroimagen0/Documents/FREESURFER/Freesurfer_prediction/Freesurfer/WM/s2/fsaverage/label/rh.BA1_exvivo.label --trgsubject FTD-FPD109 --trglabel ./rh.BA1_exvivo.label --hemi rh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /home/neuroimagen0/Documents/FREESURFER/Freesurfer_prediction/Freesurfer/WM/s2/fsaverage/label/rh.BA2_exvivo.label --trgsubject FTD-FPD109 --trglabel ./rh.BA2_exvivo.label --hemi rh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /home/neuroimagen0/Documents/FREESURFER/Freesurfer_prediction/Freesurfer/WM/s2/fsaverage/label/rh.BA3a_exvivo.label --trgsubject FTD-FPD109 --trglabel ./rh.BA3a_exvivo.label --hemi rh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /home/neuroimagen0/Documents/FREESURFER/Freesurfer_prediction/Freesurfer/WM/s2/fsaverage/label/rh.BA3b_exvivo.label --trgsubject FTD-FPD109 --trglabel ./rh.BA3b_exvivo.label --hemi rh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /home/neuroimagen0/Documents/FREESURFER/Freesurfer_prediction/Freesurfer/WM/s2/fsaverage/label/rh.BA4a_exvivo.label --trgsubject FTD-FPD109 --trglabel ./rh.BA4a_exvivo.label --hemi rh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /home/neuroimagen0/Documents/FREESURFER/Freesurfer_prediction/Freesurfer/WM/s2/fsaverage/label/rh.BA4p_exvivo.label --trgsubject FTD-FPD109 --trglabel ./rh.BA4p_exvivo.label --hemi rh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /home/neuroimagen0/Documents/FREESURFER/Freesurfer_prediction/Freesurfer/WM/s2/fsaverage/label/rh.BA6_exvivo.label --trgsubject FTD-FPD109 --trglabel ./rh.BA6_exvivo.label --hemi rh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /home/neuroimagen0/Documents/FREESURFER/Freesurfer_prediction/Freesurfer/WM/s2/fsaverage/label/rh.BA44_exvivo.label --trgsubject FTD-FPD109 --trglabel ./rh.BA44_exvivo.label --hemi rh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /home/neuroimagen0/Documents/FREESURFER/Freesurfer_prediction/Freesurfer/WM/s2/fsaverage/label/rh.BA45_exvivo.label --trgsubject FTD-FPD109 --trglabel ./rh.BA45_exvivo.label --hemi rh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /home/neuroimagen0/Documents/FREESURFER/Freesurfer_prediction/Freesurfer/WM/s2/fsaverage/label/rh.V1_exvivo.label --trgsubject FTD-FPD109 --trglabel ./rh.V1_exvivo.label --hemi rh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /home/neuroimagen0/Documents/FREESURFER/Freesurfer_prediction/Freesurfer/WM/s2/fsaverage/label/rh.V2_exvivo.label --trgsubject FTD-FPD109 --trglabel ./rh.V2_exvivo.label --hemi rh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /home/neuroimagen0/Documents/FREESURFER/Freesurfer_prediction/Freesurfer/WM/s2/fsaverage/label/rh.MT_exvivo.label --trgsubject FTD-FPD109 --trglabel ./rh.MT_exvivo.label --hemi rh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /home/neuroimagen0/Documents/FREESURFER/Freesurfer_prediction/Freesurfer/WM/s2/fsaverage/label/rh.entorhinal_exvivo.label --trgsubject FTD-FPD109 --trglabel ./rh.entorhinal_exvivo.label --hemi rh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /home/neuroimagen0/Documents/FREESURFER/Freesurfer_prediction/Freesurfer/WM/s2/fsaverage/label/rh.perirhinal_exvivo.label --trgsubject FTD-FPD109 --trglabel ./rh.perirhinal_exvivo.label --hemi rh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /home/neuroimagen0/Documents/FREESURFER/Freesurfer_prediction/Freesurfer/WM/s2/fsaverage/label/rh.BA1_exvivo.thresh.label --trgsubject FTD-FPD109 --trglabel ./rh.BA1_exvivo.thresh.label --hemi rh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /home/neuroimagen0/Documents/FREESURFER/Freesurfer_prediction/Freesurfer/WM/s2/fsaverage/label/rh.BA2_exvivo.thresh.label --trgsubject FTD-FPD109 --trglabel ./rh.BA2_exvivo.thresh.label --hemi rh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /home/neuroimagen0/Documents/FREESURFER/Freesurfer_prediction/Freesurfer/WM/s2/fsaverage/label/rh.BA3a_exvivo.thresh.label --trgsubject FTD-FPD109 --trglabel ./rh.BA3a_exvivo.thresh.label --hemi rh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /home/neuroimagen0/Documents/FREESURFER/Freesurfer_prediction/Freesurfer/WM/s2/fsaverage/label/rh.BA3b_exvivo.thresh.label --trgsubject FTD-FPD109 --trglabel ./rh.BA3b_exvivo.thresh.label --hemi rh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /home/neuroimagen0/Documents/FREESURFER/Freesurfer_prediction/Freesurfer/WM/s2/fsaverage/label/rh.BA4a_exvivo.thresh.label --trgsubject FTD-FPD109 --trglabel ./rh.BA4a_exvivo.thresh.label --hemi rh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /home/neuroimagen0/Documents/FREESURFER/Freesurfer_prediction/Freesurfer/WM/s2/fsaverage/label/rh.BA4p_exvivo.thresh.label --trgsubject FTD-FPD109 --trglabel ./rh.BA4p_exvivo.thresh.label --hemi rh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /home/neuroimagen0/Documents/FREESURFER/Freesurfer_prediction/Freesurfer/WM/s2/fsaverage/label/rh.BA6_exvivo.thresh.label --trgsubject FTD-FPD109 --trglabel ./rh.BA6_exvivo.thresh.label --hemi rh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /home/neuroimagen0/Documents/FREESURFER/Freesurfer_prediction/Freesurfer/WM/s2/fsaverage/label/rh.BA44_exvivo.thresh.label --trgsubject FTD-FPD109 --trglabel ./rh.BA44_exvivo.thresh.label --hemi rh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /home/neuroimagen0/Documents/FREESURFER/Freesurfer_prediction/Freesurfer/WM/s2/fsaverage/label/rh.BA45_exvivo.thresh.label --trgsubject FTD-FPD109 --trglabel ./rh.BA45_exvivo.thresh.label --hemi rh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /home/neuroimagen0/Documents/FREESURFER/Freesurfer_prediction/Freesurfer/WM/s2/fsaverage/label/rh.V1_exvivo.thresh.label --trgsubject FTD-FPD109 --trglabel ./rh.V1_exvivo.thresh.label --hemi rh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /home/neuroimagen0/Documents/FREESURFER/Freesurfer_prediction/Freesurfer/WM/s2/fsaverage/label/rh.V2_exvivo.thresh.label --trgsubject FTD-FPD109 --trglabel ./rh.V2_exvivo.thresh.label --hemi rh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /home/neuroimagen0/Documents/FREESURFER/Freesurfer_prediction/Freesurfer/WM/s2/fsaverage/label/rh.MT_exvivo.thresh.label --trgsubject FTD-FPD109 --trglabel ./rh.MT_exvivo.thresh.label --hemi rh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /home/neuroimagen0/Documents/FREESURFER/Freesurfer_prediction/Freesurfer/WM/s2/fsaverage/label/rh.entorhinal_exvivo.thresh.label --trgsubject FTD-FPD109 --trglabel ./rh.entorhinal_exvivo.thresh.label --hemi rh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /home/neuroimagen0/Documents/FREESURFER/Freesurfer_prediction/Freesurfer/WM/s2/fsaverage/label/rh.perirhinal_exvivo.thresh.label --trgsubject FTD-FPD109 --trglabel ./rh.perirhinal_exvivo.thresh.label --hemi rh --regmethod surface 


 mris_label2annot --s FTD-FPD109 --hemi rh --ctab /usr/local/freesurfer6/average/colortable_BA.txt --l rh.BA1_exvivo.label --l rh.BA2_exvivo.label --l rh.BA3a_exvivo.label --l rh.BA3b_exvivo.label --l rh.BA4a_exvivo.label --l rh.BA4p_exvivo.label --l rh.BA6_exvivo.label --l rh.BA44_exvivo.label --l rh.BA45_exvivo.label --l rh.V1_exvivo.label --l rh.V2_exvivo.label --l rh.MT_exvivo.label --l rh.entorhinal_exvivo.label --l rh.perirhinal_exvivo.label --a BA_exvivo --maxstatwinner --noverbose 


 mris_label2annot --s FTD-FPD109 --hemi rh --ctab /usr/local/freesurfer6/average/colortable_BA.txt --l rh.BA1_exvivo.thresh.label --l rh.BA2_exvivo.thresh.label --l rh.BA3a_exvivo.thresh.label --l rh.BA3b_exvivo.thresh.label --l rh.BA4a_exvivo.thresh.label --l rh.BA4p_exvivo.thresh.label --l rh.BA6_exvivo.thresh.label --l rh.BA44_exvivo.thresh.label --l rh.BA45_exvivo.thresh.label --l rh.V1_exvivo.thresh.label --l rh.V2_exvivo.thresh.label --l rh.MT_exvivo.thresh.label --l rh.entorhinal_exvivo.thresh.label --l rh.perirhinal_exvivo.thresh.label --a BA_exvivo.thresh --maxstatwinner --noverbose 


 mris_anatomical_stats -th3 -mgz -f ../stats/rh.BA_exvivo.stats -b -a ./rh.BA_exvivo.annot -c ./BA_exvivo.ctab FTD-FPD109 rh white 


 mris_anatomical_stats -th3 -mgz -f ../stats/rh.BA_exvivo.thresh.stats -b -a ./rh.BA_exvivo.thresh.annot -c ./BA_exvivo.thresh.ctab FTD-FPD109 rh white 

#--------------------------------------------
#@# Qdec Cache preproc lh thickness fsaverage mié abr  4 07:13:32 CEST 2018

 mris_preproc --s FTD-FPD109 --hemi lh --meas thickness --target fsaverage --out lh.thickness.fsaverage.mgh 

#--------------------------------------------
#@# Qdec Cache preproc lh area fsaverage mié abr  4 07:13:37 CEST 2018

 mris_preproc --s FTD-FPD109 --hemi lh --meas area --target fsaverage --out lh.area.fsaverage.mgh 

#--------------------------------------------
#@# Qdec Cache preproc lh area.pial fsaverage mié abr  4 07:13:43 CEST 2018

 mris_preproc --s FTD-FPD109 --hemi lh --meas area.pial --target fsaverage --out lh.area.pial.fsaverage.mgh 

#--------------------------------------------
#@# Qdec Cache preproc lh volume fsaverage mié abr  4 07:13:49 CEST 2018

 mris_preproc --s FTD-FPD109 --hemi lh --meas volume --target fsaverage --out lh.volume.fsaverage.mgh 

#--------------------------------------------
#@# Qdec Cache preproc lh curv fsaverage mié abr  4 07:13:55 CEST 2018

 mris_preproc --s FTD-FPD109 --hemi lh --meas curv --target fsaverage --out lh.curv.fsaverage.mgh 

#--------------------------------------------
#@# Qdec Cache preproc lh sulc fsaverage mié abr  4 07:13:59 CEST 2018

 mris_preproc --s FTD-FPD109 --hemi lh --meas sulc --target fsaverage --out lh.sulc.fsaverage.mgh 

#--------------------------------------------
#@# Qdec Cache preproc lh white.K fsaverage mié abr  4 07:14:04 CEST 2018

 mris_preproc --s FTD-FPD109 --hemi lh --meas white.K --target fsaverage --out lh.white.K.fsaverage.mgh 

#--------------------------------------------
#@# Qdec Cache preproc lh white.H fsaverage mié abr  4 07:14:08 CEST 2018

 mris_preproc --s FTD-FPD109 --hemi lh --meas white.H --target fsaverage --out lh.white.H.fsaverage.mgh 

#--------------------------------------------
#@# Qdec Cache preproc lh jacobian_white fsaverage mié abr  4 07:14:13 CEST 2018

 mris_preproc --s FTD-FPD109 --hemi lh --meas jacobian_white --target fsaverage --out lh.jacobian_white.fsaverage.mgh 

#--------------------------------------------
#@# Qdec Cache preproc lh w-g.pct.mgh fsaverage mié abr  4 07:14:18 CEST 2018

 mris_preproc --s FTD-FPD109 --hemi lh --meas w-g.pct.mgh --target fsaverage --out lh.w-g.pct.mgh.fsaverage.mgh 

#--------------------------------------------
#@# Qdec Cache preproc rh thickness fsaverage mié abr  4 07:14:22 CEST 2018

 mris_preproc --s FTD-FPD109 --hemi rh --meas thickness --target fsaverage --out rh.thickness.fsaverage.mgh 

#--------------------------------------------
#@# Qdec Cache preproc rh area fsaverage mié abr  4 07:14:27 CEST 2018

 mris_preproc --s FTD-FPD109 --hemi rh --meas area --target fsaverage --out rh.area.fsaverage.mgh 

#--------------------------------------------
#@# Qdec Cache preproc rh area.pial fsaverage mié abr  4 07:14:34 CEST 2018

 mris_preproc --s FTD-FPD109 --hemi rh --meas area.pial --target fsaverage --out rh.area.pial.fsaverage.mgh 

#--------------------------------------------
#@# Qdec Cache preproc rh volume fsaverage mié abr  4 07:14:40 CEST 2018

 mris_preproc --s FTD-FPD109 --hemi rh --meas volume --target fsaverage --out rh.volume.fsaverage.mgh 

#--------------------------------------------
#@# Qdec Cache preproc rh curv fsaverage mié abr  4 07:14:47 CEST 2018

 mris_preproc --s FTD-FPD109 --hemi rh --meas curv --target fsaverage --out rh.curv.fsaverage.mgh 

#--------------------------------------------
#@# Qdec Cache preproc rh sulc fsaverage mié abr  4 07:14:53 CEST 2018

 mris_preproc --s FTD-FPD109 --hemi rh --meas sulc --target fsaverage --out rh.sulc.fsaverage.mgh 

#--------------------------------------------
#@# Qdec Cache preproc rh white.K fsaverage mié abr  4 07:14:59 CEST 2018

 mris_preproc --s FTD-FPD109 --hemi rh --meas white.K --target fsaverage --out rh.white.K.fsaverage.mgh 

#--------------------------------------------
#@# Qdec Cache preproc rh white.H fsaverage mié abr  4 07:15:04 CEST 2018

 mris_preproc --s FTD-FPD109 --hemi rh --meas white.H --target fsaverage --out rh.white.H.fsaverage.mgh 

#--------------------------------------------
#@# Qdec Cache preproc rh jacobian_white fsaverage mié abr  4 07:15:10 CEST 2018

 mris_preproc --s FTD-FPD109 --hemi rh --meas jacobian_white --target fsaverage --out rh.jacobian_white.fsaverage.mgh 

#--------------------------------------------
#@# Qdec Cache preproc rh w-g.pct.mgh fsaverage mié abr  4 07:15:16 CEST 2018

 mris_preproc --s FTD-FPD109 --hemi rh --meas w-g.pct.mgh --target fsaverage --out rh.w-g.pct.mgh.fsaverage.mgh 

#--------------------------------------------
#@# Qdec Cache surf2surf lh thickness fwhm0 fsaverage mié abr  4 07:15:22 CEST 2018

 mri_surf2surf --prune --s fsaverage --hemi lh --fwhm 0 --sval lh.thickness.fsaverage.mgh --tval lh.thickness.fwhm0.fsaverage.mgh --cortex 

#--------------------------------------------
#@# Qdec Cache surf2surf lh thickness fwhm5 fsaverage mié abr  4 07:15:24 CEST 2018

 mri_surf2surf --prune --s fsaverage --hemi lh --fwhm 5 --sval lh.thickness.fsaverage.mgh --tval lh.thickness.fwhm5.fsaverage.mgh --cortex 

#--------------------------------------------
#@# Qdec Cache surf2surf lh thickness fwhm10 fsaverage mié abr  4 07:15:29 CEST 2018

 mri_surf2surf --prune --s fsaverage --hemi lh --fwhm 10 --sval lh.thickness.fsaverage.mgh --tval lh.thickness.fwhm10.fsaverage.mgh --cortex 

#--------------------------------------------
#@# Qdec Cache surf2surf lh thickness fwhm15 fsaverage mié abr  4 07:15:34 CEST 2018

 mri_surf2surf --prune --s fsaverage --hemi lh --fwhm 15 --sval lh.thickness.fsaverage.mgh --tval lh.thickness.fwhm15.fsaverage.mgh --cortex 

#--------------------------------------------
#@# Qdec Cache surf2surf lh thickness fwhm20 fsaverage mié abr  4 07:15:39 CEST 2018

 mri_surf2surf --prune --s fsaverage --hemi lh --fwhm 20 --sval lh.thickness.fsaverage.mgh --tval lh.thickness.fwhm20.fsaverage.mgh --cortex 

#--------------------------------------------
#@# Qdec Cache surf2surf lh thickness fwhm25 fsaverage mié abr  4 07:15:44 CEST 2018

 mri_surf2surf --prune --s fsaverage --hemi lh --fwhm 25 --sval lh.thickness.fsaverage.mgh --tval lh.thickness.fwhm25.fsaverage.mgh --cortex 

#--------------------------------------------
#@# Qdec Cache surf2surf lh area fwhm0 fsaverage mié abr  4 07:15:50 CEST 2018

 mri_surf2surf --prune --s fsaverage --hemi lh --fwhm 0 --sval lh.area.fsaverage.mgh --tval lh.area.fwhm0.fsaverage.mgh --cortex 

#--------------------------------------------
#@# Qdec Cache surf2surf lh area fwhm5 fsaverage mié abr  4 07:15:52 CEST 2018

 mri_surf2surf --prune --s fsaverage --hemi lh --fwhm 5 --sval lh.area.fsaverage.mgh --tval lh.area.fwhm5.fsaverage.mgh --cortex 

#--------------------------------------------
#@# Qdec Cache surf2surf lh area fwhm10 fsaverage mié abr  4 07:15:57 CEST 2018

 mri_surf2surf --prune --s fsaverage --hemi lh --fwhm 10 --sval lh.area.fsaverage.mgh --tval lh.area.fwhm10.fsaverage.mgh --cortex 

#--------------------------------------------
#@# Qdec Cache surf2surf lh area fwhm15 fsaverage mié abr  4 07:16:02 CEST 2018

 mri_surf2surf --prune --s fsaverage --hemi lh --fwhm 15 --sval lh.area.fsaverage.mgh --tval lh.area.fwhm15.fsaverage.mgh --cortex 

#--------------------------------------------
#@# Qdec Cache surf2surf lh area fwhm20 fsaverage mié abr  4 07:16:07 CEST 2018

 mri_surf2surf --prune --s fsaverage --hemi lh --fwhm 20 --sval lh.area.fsaverage.mgh --tval lh.area.fwhm20.fsaverage.mgh --cortex 

#--------------------------------------------
#@# Qdec Cache surf2surf lh area fwhm25 fsaverage mié abr  4 07:16:14 CEST 2018

 mri_surf2surf --prune --s fsaverage --hemi lh --fwhm 25 --sval lh.area.fsaverage.mgh --tval lh.area.fwhm25.fsaverage.mgh --cortex 

#--------------------------------------------
#@# Qdec Cache surf2surf lh area.pial fwhm0 fsaverage mié abr  4 07:16:20 CEST 2018

 mri_surf2surf --prune --s fsaverage --hemi lh --fwhm 0 --sval lh.area.pial.fsaverage.mgh --tval lh.area.pial.fwhm0.fsaverage.mgh --cortex 

#--------------------------------------------
#@# Qdec Cache surf2surf lh area.pial fwhm5 fsaverage mié abr  4 07:16:23 CEST 2018

 mri_surf2surf --prune --s fsaverage --hemi lh --fwhm 5 --sval lh.area.pial.fsaverage.mgh --tval lh.area.pial.fwhm5.fsaverage.mgh --cortex 

#--------------------------------------------
#@# Qdec Cache surf2surf lh area.pial fwhm10 fsaverage mié abr  4 07:16:28 CEST 2018

 mri_surf2surf --prune --s fsaverage --hemi lh --fwhm 10 --sval lh.area.pial.fsaverage.mgh --tval lh.area.pial.fwhm10.fsaverage.mgh --cortex 

#--------------------------------------------
#@# Qdec Cache surf2surf lh area.pial fwhm15 fsaverage mié abr  4 07:16:33 CEST 2018

 mri_surf2surf --prune --s fsaverage --hemi lh --fwhm 15 --sval lh.area.pial.fsaverage.mgh --tval lh.area.pial.fwhm15.fsaverage.mgh --cortex 

#--------------------------------------------
#@# Qdec Cache surf2surf lh area.pial fwhm20 fsaverage mié abr  4 07:16:37 CEST 2018

 mri_surf2surf --prune --s fsaverage --hemi lh --fwhm 20 --sval lh.area.pial.fsaverage.mgh --tval lh.area.pial.fwhm20.fsaverage.mgh --cortex 

#--------------------------------------------
#@# Qdec Cache surf2surf lh area.pial fwhm25 fsaverage mié abr  4 07:16:43 CEST 2018

 mri_surf2surf --prune --s fsaverage --hemi lh --fwhm 25 --sval lh.area.pial.fsaverage.mgh --tval lh.area.pial.fwhm25.fsaverage.mgh --cortex 

#--------------------------------------------
#@# Qdec Cache surf2surf lh volume fwhm0 fsaverage mié abr  4 07:16:49 CEST 2018

 mri_surf2surf --prune --s fsaverage --hemi lh --fwhm 0 --sval lh.volume.fsaverage.mgh --tval lh.volume.fwhm0.fsaverage.mgh --cortex 

#--------------------------------------------
#@# Qdec Cache surf2surf lh volume fwhm5 fsaverage mié abr  4 07:16:51 CEST 2018

 mri_surf2surf --prune --s fsaverage --hemi lh --fwhm 5 --sval lh.volume.fsaverage.mgh --tval lh.volume.fwhm5.fsaverage.mgh --cortex 

#--------------------------------------------
#@# Qdec Cache surf2surf lh volume fwhm10 fsaverage mié abr  4 07:16:56 CEST 2018

 mri_surf2surf --prune --s fsaverage --hemi lh --fwhm 10 --sval lh.volume.fsaverage.mgh --tval lh.volume.fwhm10.fsaverage.mgh --cortex 

#--------------------------------------------
#@# Qdec Cache surf2surf lh volume fwhm15 fsaverage mié abr  4 07:17:01 CEST 2018

 mri_surf2surf --prune --s fsaverage --hemi lh --fwhm 15 --sval lh.volume.fsaverage.mgh --tval lh.volume.fwhm15.fsaverage.mgh --cortex 

#--------------------------------------------
#@# Qdec Cache surf2surf lh volume fwhm20 fsaverage mié abr  4 07:17:06 CEST 2018

 mri_surf2surf --prune --s fsaverage --hemi lh --fwhm 20 --sval lh.volume.fsaverage.mgh --tval lh.volume.fwhm20.fsaverage.mgh --cortex 

#--------------------------------------------
#@# Qdec Cache surf2surf lh volume fwhm25 fsaverage mié abr  4 07:17:12 CEST 2018

 mri_surf2surf --prune --s fsaverage --hemi lh --fwhm 25 --sval lh.volume.fsaverage.mgh --tval lh.volume.fwhm25.fsaverage.mgh --cortex 

#--------------------------------------------
#@# Qdec Cache surf2surf lh curv fwhm0 fsaverage mié abr  4 07:17:19 CEST 2018

 mri_surf2surf --prune --s fsaverage --hemi lh --fwhm 0 --sval lh.curv.fsaverage.mgh --tval lh.curv.fwhm0.fsaverage.mgh --cortex 

#--------------------------------------------
#@# Qdec Cache surf2surf lh curv fwhm5 fsaverage mié abr  4 07:17:21 CEST 2018

 mri_surf2surf --prune --s fsaverage --hemi lh --fwhm 5 --sval lh.curv.fsaverage.mgh --tval lh.curv.fwhm5.fsaverage.mgh --cortex 

#--------------------------------------------
#@# Qdec Cache surf2surf lh curv fwhm10 fsaverage mié abr  4 07:17:27 CEST 2018

 mri_surf2surf --prune --s fsaverage --hemi lh --fwhm 10 --sval lh.curv.fsaverage.mgh --tval lh.curv.fwhm10.fsaverage.mgh --cortex 

#--------------------------------------------
#@# Qdec Cache surf2surf lh curv fwhm15 fsaverage mié abr  4 07:17:33 CEST 2018

 mri_surf2surf --prune --s fsaverage --hemi lh --fwhm 15 --sval lh.curv.fsaverage.mgh --tval lh.curv.fwhm15.fsaverage.mgh --cortex 

#--------------------------------------------
#@# Qdec Cache surf2surf lh curv fwhm20 fsaverage mié abr  4 07:17:39 CEST 2018

 mri_surf2surf --prune --s fsaverage --hemi lh --fwhm 20 --sval lh.curv.fsaverage.mgh --tval lh.curv.fwhm20.fsaverage.mgh --cortex 

#--------------------------------------------
#@# Qdec Cache surf2surf lh curv fwhm25 fsaverage mié abr  4 07:17:44 CEST 2018

 mri_surf2surf --prune --s fsaverage --hemi lh --fwhm 25 --sval lh.curv.fsaverage.mgh --tval lh.curv.fwhm25.fsaverage.mgh --cortex 

#--------------------------------------------
#@# Qdec Cache surf2surf lh sulc fwhm0 fsaverage mié abr  4 07:17:51 CEST 2018

 mri_surf2surf --prune --s fsaverage --hemi lh --fwhm 0 --sval lh.sulc.fsaverage.mgh --tval lh.sulc.fwhm0.fsaverage.mgh --cortex 

#--------------------------------------------
#@# Qdec Cache surf2surf lh sulc fwhm5 fsaverage mié abr  4 07:17:54 CEST 2018

 mri_surf2surf --prune --s fsaverage --hemi lh --fwhm 5 --sval lh.sulc.fsaverage.mgh --tval lh.sulc.fwhm5.fsaverage.mgh --cortex 

#--------------------------------------------
#@# Qdec Cache surf2surf lh sulc fwhm10 fsaverage mié abr  4 07:17:59 CEST 2018

 mri_surf2surf --prune --s fsaverage --hemi lh --fwhm 10 --sval lh.sulc.fsaverage.mgh --tval lh.sulc.fwhm10.fsaverage.mgh --cortex 

#--------------------------------------------
#@# Qdec Cache surf2surf lh sulc fwhm15 fsaverage mié abr  4 07:18:05 CEST 2018

 mri_surf2surf --prune --s fsaverage --hemi lh --fwhm 15 --sval lh.sulc.fsaverage.mgh --tval lh.sulc.fwhm15.fsaverage.mgh --cortex 

#--------------------------------------------
#@# Qdec Cache surf2surf lh sulc fwhm20 fsaverage mié abr  4 07:18:11 CEST 2018

 mri_surf2surf --prune --s fsaverage --hemi lh --fwhm 20 --sval lh.sulc.fsaverage.mgh --tval lh.sulc.fwhm20.fsaverage.mgh --cortex 

#--------------------------------------------
#@# Qdec Cache surf2surf lh sulc fwhm25 fsaverage mié abr  4 07:18:17 CEST 2018

 mri_surf2surf --prune --s fsaverage --hemi lh --fwhm 25 --sval lh.sulc.fsaverage.mgh --tval lh.sulc.fwhm25.fsaverage.mgh --cortex 

#--------------------------------------------
#@# Qdec Cache surf2surf lh white.K fwhm0 fsaverage mié abr  4 07:18:24 CEST 2018

 mri_surf2surf --prune --s fsaverage --hemi lh --fwhm 0 --sval lh.white.K.fsaverage.mgh --tval lh.white.K.fwhm0.fsaverage.mgh --cortex 

#--------------------------------------------
#@# Qdec Cache surf2surf lh white.K fwhm5 fsaverage mié abr  4 07:18:27 CEST 2018

 mri_surf2surf --prune --s fsaverage --hemi lh --fwhm 5 --sval lh.white.K.fsaverage.mgh --tval lh.white.K.fwhm5.fsaverage.mgh --cortex 

#--------------------------------------------
#@# Qdec Cache surf2surf lh white.K fwhm10 fsaverage mié abr  4 07:18:33 CEST 2018

 mri_surf2surf --prune --s fsaverage --hemi lh --fwhm 10 --sval lh.white.K.fsaverage.mgh --tval lh.white.K.fwhm10.fsaverage.mgh --cortex 

#--------------------------------------------
#@# Qdec Cache surf2surf lh white.K fwhm15 fsaverage mié abr  4 07:18:39 CEST 2018

 mri_surf2surf --prune --s fsaverage --hemi lh --fwhm 15 --sval lh.white.K.fsaverage.mgh --tval lh.white.K.fwhm15.fsaverage.mgh --cortex 

#--------------------------------------------
#@# Qdec Cache surf2surf lh white.K fwhm20 fsaverage mié abr  4 07:18:45 CEST 2018

 mri_surf2surf --prune --s fsaverage --hemi lh --fwhm 20 --sval lh.white.K.fsaverage.mgh --tval lh.white.K.fwhm20.fsaverage.mgh --cortex 

#--------------------------------------------
#@# Qdec Cache surf2surf lh white.K fwhm25 fsaverage mié abr  4 07:18:52 CEST 2018

 mri_surf2surf --prune --s fsaverage --hemi lh --fwhm 25 --sval lh.white.K.fsaverage.mgh --tval lh.white.K.fwhm25.fsaverage.mgh --cortex 

#--------------------------------------------
#@# Qdec Cache surf2surf lh white.H fwhm0 fsaverage mié abr  4 07:18:58 CEST 2018

 mri_surf2surf --prune --s fsaverage --hemi lh --fwhm 0 --sval lh.white.H.fsaverage.mgh --tval lh.white.H.fwhm0.fsaverage.mgh --cortex 

#--------------------------------------------
#@# Qdec Cache surf2surf lh white.H fwhm5 fsaverage mié abr  4 07:19:00 CEST 2018

 mri_surf2surf --prune --s fsaverage --hemi lh --fwhm 5 --sval lh.white.H.fsaverage.mgh --tval lh.white.H.fwhm5.fsaverage.mgh --cortex 

#--------------------------------------------
#@# Qdec Cache surf2surf lh white.H fwhm10 fsaverage mié abr  4 07:19:05 CEST 2018

 mri_surf2surf --prune --s fsaverage --hemi lh --fwhm 10 --sval lh.white.H.fsaverage.mgh --tval lh.white.H.fwhm10.fsaverage.mgh --cortex 

#--------------------------------------------
#@# Qdec Cache surf2surf lh white.H fwhm15 fsaverage mié abr  4 07:19:10 CEST 2018

 mri_surf2surf --prune --s fsaverage --hemi lh --fwhm 15 --sval lh.white.H.fsaverage.mgh --tval lh.white.H.fwhm15.fsaverage.mgh --cortex 

#--------------------------------------------
#@# Qdec Cache surf2surf lh white.H fwhm20 fsaverage mié abr  4 07:19:15 CEST 2018

 mri_surf2surf --prune --s fsaverage --hemi lh --fwhm 20 --sval lh.white.H.fsaverage.mgh --tval lh.white.H.fwhm20.fsaverage.mgh --cortex 

#--------------------------------------------
#@# Qdec Cache surf2surf lh white.H fwhm25 fsaverage mié abr  4 07:19:21 CEST 2018

 mri_surf2surf --prune --s fsaverage --hemi lh --fwhm 25 --sval lh.white.H.fsaverage.mgh --tval lh.white.H.fwhm25.fsaverage.mgh --cortex 

#--------------------------------------------
#@# Qdec Cache surf2surf lh jacobian_white fwhm0 fsaverage mié abr  4 07:19:26 CEST 2018

 mri_surf2surf --prune --s fsaverage --hemi lh --fwhm 0 --sval lh.jacobian_white.fsaverage.mgh --tval lh.jacobian_white.fwhm0.fsaverage.mgh --cortex 

#--------------------------------------------
#@# Qdec Cache surf2surf lh jacobian_white fwhm5 fsaverage mié abr  4 07:19:27 CEST 2018

 mri_surf2surf --prune --s fsaverage --hemi lh --fwhm 5 --sval lh.jacobian_white.fsaverage.mgh --tval lh.jacobian_white.fwhm5.fsaverage.mgh --cortex 

#--------------------------------------------
#@# Qdec Cache surf2surf lh jacobian_white fwhm10 fsaverage mié abr  4 07:19:31 CEST 2018

 mri_surf2surf --prune --s fsaverage --hemi lh --fwhm 10 --sval lh.jacobian_white.fsaverage.mgh --tval lh.jacobian_white.fwhm10.fsaverage.mgh --cortex 

#--------------------------------------------
#@# Qdec Cache surf2surf lh jacobian_white fwhm15 fsaverage mié abr  4 07:19:35 CEST 2018

 mri_surf2surf --prune --s fsaverage --hemi lh --fwhm 15 --sval lh.jacobian_white.fsaverage.mgh --tval lh.jacobian_white.fwhm15.fsaverage.mgh --cortex 

#--------------------------------------------
#@# Qdec Cache surf2surf lh jacobian_white fwhm20 fsaverage mié abr  4 07:19:39 CEST 2018

 mri_surf2surf --prune --s fsaverage --hemi lh --fwhm 20 --sval lh.jacobian_white.fsaverage.mgh --tval lh.jacobian_white.fwhm20.fsaverage.mgh --cortex 

#--------------------------------------------
#@# Qdec Cache surf2surf lh jacobian_white fwhm25 fsaverage mié abr  4 07:19:43 CEST 2018

 mri_surf2surf --prune --s fsaverage --hemi lh --fwhm 25 --sval lh.jacobian_white.fsaverage.mgh --tval lh.jacobian_white.fwhm25.fsaverage.mgh --cortex 

#--------------------------------------------
#@# Qdec Cache surf2surf lh w-g.pct.mgh fwhm0 fsaverage mié abr  4 07:19:49 CEST 2018

 mri_surf2surf --prune --s fsaverage --hemi lh --fwhm 0 --sval lh.w-g.pct.mgh.fsaverage.mgh --tval lh.w-g.pct.mgh.fwhm0.fsaverage.mgh --cortex 

#--------------------------------------------
#@# Qdec Cache surf2surf lh w-g.pct.mgh fwhm5 fsaverage mié abr  4 07:19:51 CEST 2018

 mri_surf2surf --prune --s fsaverage --hemi lh --fwhm 5 --sval lh.w-g.pct.mgh.fsaverage.mgh --tval lh.w-g.pct.mgh.fwhm5.fsaverage.mgh --cortex 

#--------------------------------------------
#@# Qdec Cache surf2surf lh w-g.pct.mgh fwhm10 fsaverage mié abr  4 07:19:56 CEST 2018

 mri_surf2surf --prune --s fsaverage --hemi lh --fwhm 10 --sval lh.w-g.pct.mgh.fsaverage.mgh --tval lh.w-g.pct.mgh.fwhm10.fsaverage.mgh --cortex 

#--------------------------------------------
#@# Qdec Cache surf2surf lh w-g.pct.mgh fwhm15 fsaverage mié abr  4 07:20:01 CEST 2018

 mri_surf2surf --prune --s fsaverage --hemi lh --fwhm 15 --sval lh.w-g.pct.mgh.fsaverage.mgh --tval lh.w-g.pct.mgh.fwhm15.fsaverage.mgh --cortex 

#--------------------------------------------
#@# Qdec Cache surf2surf lh w-g.pct.mgh fwhm20 fsaverage mié abr  4 07:20:06 CEST 2018

 mri_surf2surf --prune --s fsaverage --hemi lh --fwhm 20 --sval lh.w-g.pct.mgh.fsaverage.mgh --tval lh.w-g.pct.mgh.fwhm20.fsaverage.mgh --cortex 

#--------------------------------------------
#@# Qdec Cache surf2surf lh w-g.pct.mgh fwhm25 fsaverage mié abr  4 07:20:12 CEST 2018

 mri_surf2surf --prune --s fsaverage --hemi lh --fwhm 25 --sval lh.w-g.pct.mgh.fsaverage.mgh --tval lh.w-g.pct.mgh.fwhm25.fsaverage.mgh --cortex 

#--------------------------------------------
#@# Qdec Cache surf2surf rh thickness fwhm0 fsaverage mié abr  4 07:20:17 CEST 2018

 mri_surf2surf --prune --s fsaverage --hemi rh --fwhm 0 --sval rh.thickness.fsaverage.mgh --tval rh.thickness.fwhm0.fsaverage.mgh --cortex 

#--------------------------------------------
#@# Qdec Cache surf2surf rh thickness fwhm5 fsaverage mié abr  4 07:20:20 CEST 2018

 mri_surf2surf --prune --s fsaverage --hemi rh --fwhm 5 --sval rh.thickness.fsaverage.mgh --tval rh.thickness.fwhm5.fsaverage.mgh --cortex 

#--------------------------------------------
#@# Qdec Cache surf2surf rh thickness fwhm10 fsaverage mié abr  4 07:20:24 CEST 2018

 mri_surf2surf --prune --s fsaverage --hemi rh --fwhm 10 --sval rh.thickness.fsaverage.mgh --tval rh.thickness.fwhm10.fsaverage.mgh --cortex 

#--------------------------------------------
#@# Qdec Cache surf2surf rh thickness fwhm15 fsaverage mié abr  4 07:20:29 CEST 2018

 mri_surf2surf --prune --s fsaverage --hemi rh --fwhm 15 --sval rh.thickness.fsaverage.mgh --tval rh.thickness.fwhm15.fsaverage.mgh --cortex 

#--------------------------------------------
#@# Qdec Cache surf2surf rh thickness fwhm20 fsaverage mié abr  4 07:20:34 CEST 2018

 mri_surf2surf --prune --s fsaverage --hemi rh --fwhm 20 --sval rh.thickness.fsaverage.mgh --tval rh.thickness.fwhm20.fsaverage.mgh --cortex 

#--------------------------------------------
#@# Qdec Cache surf2surf rh thickness fwhm25 fsaverage mié abr  4 07:20:39 CEST 2018

 mri_surf2surf --prune --s fsaverage --hemi rh --fwhm 25 --sval rh.thickness.fsaverage.mgh --tval rh.thickness.fwhm25.fsaverage.mgh --cortex 

#--------------------------------------------
#@# Qdec Cache surf2surf rh area fwhm0 fsaverage mié abr  4 07:20:44 CEST 2018

 mri_surf2surf --prune --s fsaverage --hemi rh --fwhm 0 --sval rh.area.fsaverage.mgh --tval rh.area.fwhm0.fsaverage.mgh --cortex 

#--------------------------------------------
#@# Qdec Cache surf2surf rh area fwhm5 fsaverage mié abr  4 07:20:46 CEST 2018

 mri_surf2surf --prune --s fsaverage --hemi rh --fwhm 5 --sval rh.area.fsaverage.mgh --tval rh.area.fwhm5.fsaverage.mgh --cortex 

#--------------------------------------------
#@# Qdec Cache surf2surf rh area fwhm10 fsaverage mié abr  4 07:20:51 CEST 2018

 mri_surf2surf --prune --s fsaverage --hemi rh --fwhm 10 --sval rh.area.fsaverage.mgh --tval rh.area.fwhm10.fsaverage.mgh --cortex 

#--------------------------------------------
#@# Qdec Cache surf2surf rh area fwhm15 fsaverage mié abr  4 07:20:55 CEST 2018

 mri_surf2surf --prune --s fsaverage --hemi rh --fwhm 15 --sval rh.area.fsaverage.mgh --tval rh.area.fwhm15.fsaverage.mgh --cortex 

#--------------------------------------------
#@# Qdec Cache surf2surf rh area fwhm20 fsaverage mié abr  4 07:21:01 CEST 2018

 mri_surf2surf --prune --s fsaverage --hemi rh --fwhm 20 --sval rh.area.fsaverage.mgh --tval rh.area.fwhm20.fsaverage.mgh --cortex 

#--------------------------------------------
#@# Qdec Cache surf2surf rh area fwhm25 fsaverage mié abr  4 07:21:06 CEST 2018

 mri_surf2surf --prune --s fsaverage --hemi rh --fwhm 25 --sval rh.area.fsaverage.mgh --tval rh.area.fwhm25.fsaverage.mgh --cortex 

#--------------------------------------------
#@# Qdec Cache surf2surf rh area.pial fwhm0 fsaverage mié abr  4 07:21:12 CEST 2018

 mri_surf2surf --prune --s fsaverage --hemi rh --fwhm 0 --sval rh.area.pial.fsaverage.mgh --tval rh.area.pial.fwhm0.fsaverage.mgh --cortex 

#--------------------------------------------
#@# Qdec Cache surf2surf rh area.pial fwhm5 fsaverage mié abr  4 07:21:14 CEST 2018

 mri_surf2surf --prune --s fsaverage --hemi rh --fwhm 5 --sval rh.area.pial.fsaverage.mgh --tval rh.area.pial.fwhm5.fsaverage.mgh --cortex 

#--------------------------------------------
#@# Qdec Cache surf2surf rh area.pial fwhm10 fsaverage mié abr  4 07:21:19 CEST 2018

 mri_surf2surf --prune --s fsaverage --hemi rh --fwhm 10 --sval rh.area.pial.fsaverage.mgh --tval rh.area.pial.fwhm10.fsaverage.mgh --cortex 

#--------------------------------------------
#@# Qdec Cache surf2surf rh area.pial fwhm15 fsaverage mié abr  4 07:21:24 CEST 2018

 mri_surf2surf --prune --s fsaverage --hemi rh --fwhm 15 --sval rh.area.pial.fsaverage.mgh --tval rh.area.pial.fwhm15.fsaverage.mgh --cortex 

#--------------------------------------------
#@# Qdec Cache surf2surf rh area.pial fwhm20 fsaverage mié abr  4 07:21:29 CEST 2018

 mri_surf2surf --prune --s fsaverage --hemi rh --fwhm 20 --sval rh.area.pial.fsaverage.mgh --tval rh.area.pial.fwhm20.fsaverage.mgh --cortex 

#--------------------------------------------
#@# Qdec Cache surf2surf rh area.pial fwhm25 fsaverage mié abr  4 07:21:34 CEST 2018

 mri_surf2surf --prune --s fsaverage --hemi rh --fwhm 25 --sval rh.area.pial.fsaverage.mgh --tval rh.area.pial.fwhm25.fsaverage.mgh --cortex 

#--------------------------------------------
#@# Qdec Cache surf2surf rh volume fwhm0 fsaverage mié abr  4 07:21:40 CEST 2018

 mri_surf2surf --prune --s fsaverage --hemi rh --fwhm 0 --sval rh.volume.fsaverage.mgh --tval rh.volume.fwhm0.fsaverage.mgh --cortex 

#--------------------------------------------
#@# Qdec Cache surf2surf rh volume fwhm5 fsaverage mié abr  4 07:21:42 CEST 2018

 mri_surf2surf --prune --s fsaverage --hemi rh --fwhm 5 --sval rh.volume.fsaverage.mgh --tval rh.volume.fwhm5.fsaverage.mgh --cortex 

#--------------------------------------------
#@# Qdec Cache surf2surf rh volume fwhm10 fsaverage mié abr  4 07:21:46 CEST 2018

 mri_surf2surf --prune --s fsaverage --hemi rh --fwhm 10 --sval rh.volume.fsaverage.mgh --tval rh.volume.fwhm10.fsaverage.mgh --cortex 

#--------------------------------------------
#@# Qdec Cache surf2surf rh volume fwhm15 fsaverage mié abr  4 07:21:50 CEST 2018

 mri_surf2surf --prune --s fsaverage --hemi rh --fwhm 15 --sval rh.volume.fsaverage.mgh --tval rh.volume.fwhm15.fsaverage.mgh --cortex 

#--------------------------------------------
#@# Qdec Cache surf2surf rh volume fwhm20 fsaverage mié abr  4 07:21:55 CEST 2018

 mri_surf2surf --prune --s fsaverage --hemi rh --fwhm 20 --sval rh.volume.fsaverage.mgh --tval rh.volume.fwhm20.fsaverage.mgh --cortex 

#--------------------------------------------
#@# Qdec Cache surf2surf rh volume fwhm25 fsaverage mié abr  4 07:22:00 CEST 2018

 mri_surf2surf --prune --s fsaverage --hemi rh --fwhm 25 --sval rh.volume.fsaverage.mgh --tval rh.volume.fwhm25.fsaverage.mgh --cortex 

#--------------------------------------------
#@# Qdec Cache surf2surf rh curv fwhm0 fsaverage mié abr  4 07:22:05 CEST 2018

 mri_surf2surf --prune --s fsaverage --hemi rh --fwhm 0 --sval rh.curv.fsaverage.mgh --tval rh.curv.fwhm0.fsaverage.mgh --cortex 

#--------------------------------------------
#@# Qdec Cache surf2surf rh curv fwhm5 fsaverage mié abr  4 07:22:07 CEST 2018

 mri_surf2surf --prune --s fsaverage --hemi rh --fwhm 5 --sval rh.curv.fsaverage.mgh --tval rh.curv.fwhm5.fsaverage.mgh --cortex 

#--------------------------------------------
#@# Qdec Cache surf2surf rh curv fwhm10 fsaverage mié abr  4 07:22:12 CEST 2018

 mri_surf2surf --prune --s fsaverage --hemi rh --fwhm 10 --sval rh.curv.fsaverage.mgh --tval rh.curv.fwhm10.fsaverage.mgh --cortex 

#--------------------------------------------
#@# Qdec Cache surf2surf rh curv fwhm15 fsaverage mié abr  4 07:22:16 CEST 2018

 mri_surf2surf --prune --s fsaverage --hemi rh --fwhm 15 --sval rh.curv.fsaverage.mgh --tval rh.curv.fwhm15.fsaverage.mgh --cortex 

#--------------------------------------------
#@# Qdec Cache surf2surf rh curv fwhm20 fsaverage mié abr  4 07:22:20 CEST 2018

 mri_surf2surf --prune --s fsaverage --hemi rh --fwhm 20 --sval rh.curv.fsaverage.mgh --tval rh.curv.fwhm20.fsaverage.mgh --cortex 

#--------------------------------------------
#@# Qdec Cache surf2surf rh curv fwhm25 fsaverage mié abr  4 07:22:24 CEST 2018

 mri_surf2surf --prune --s fsaverage --hemi rh --fwhm 25 --sval rh.curv.fsaverage.mgh --tval rh.curv.fwhm25.fsaverage.mgh --cortex 

#--------------------------------------------
#@# Qdec Cache surf2surf rh sulc fwhm0 fsaverage mié abr  4 07:22:28 CEST 2018

 mri_surf2surf --prune --s fsaverage --hemi rh --fwhm 0 --sval rh.sulc.fsaverage.mgh --tval rh.sulc.fwhm0.fsaverage.mgh --cortex 

#--------------------------------------------
#@# Qdec Cache surf2surf rh sulc fwhm5 fsaverage mié abr  4 07:22:30 CEST 2018

 mri_surf2surf --prune --s fsaverage --hemi rh --fwhm 5 --sval rh.sulc.fsaverage.mgh --tval rh.sulc.fwhm5.fsaverage.mgh --cortex 

#--------------------------------------------
#@# Qdec Cache surf2surf rh sulc fwhm10 fsaverage mié abr  4 07:22:34 CEST 2018

 mri_surf2surf --prune --s fsaverage --hemi rh --fwhm 10 --sval rh.sulc.fsaverage.mgh --tval rh.sulc.fwhm10.fsaverage.mgh --cortex 

#--------------------------------------------
#@# Qdec Cache surf2surf rh sulc fwhm15 fsaverage mié abr  4 07:22:39 CEST 2018

 mri_surf2surf --prune --s fsaverage --hemi rh --fwhm 15 --sval rh.sulc.fsaverage.mgh --tval rh.sulc.fwhm15.fsaverage.mgh --cortex 

#--------------------------------------------
#@# Qdec Cache surf2surf rh sulc fwhm20 fsaverage mié abr  4 07:22:44 CEST 2018

 mri_surf2surf --prune --s fsaverage --hemi rh --fwhm 20 --sval rh.sulc.fsaverage.mgh --tval rh.sulc.fwhm20.fsaverage.mgh --cortex 

#--------------------------------------------
#@# Qdec Cache surf2surf rh sulc fwhm25 fsaverage mié abr  4 07:22:49 CEST 2018

 mri_surf2surf --prune --s fsaverage --hemi rh --fwhm 25 --sval rh.sulc.fsaverage.mgh --tval rh.sulc.fwhm25.fsaverage.mgh --cortex 

#--------------------------------------------
#@# Qdec Cache surf2surf rh white.K fwhm0 fsaverage mié abr  4 07:22:54 CEST 2018

 mri_surf2surf --prune --s fsaverage --hemi rh --fwhm 0 --sval rh.white.K.fsaverage.mgh --tval rh.white.K.fwhm0.fsaverage.mgh --cortex 

#--------------------------------------------
#@# Qdec Cache surf2surf rh white.K fwhm5 fsaverage mié abr  4 07:22:56 CEST 2018

 mri_surf2surf --prune --s fsaverage --hemi rh --fwhm 5 --sval rh.white.K.fsaverage.mgh --tval rh.white.K.fwhm5.fsaverage.mgh --cortex 

#--------------------------------------------
#@# Qdec Cache surf2surf rh white.K fwhm10 fsaverage mié abr  4 07:23:01 CEST 2018

 mri_surf2surf --prune --s fsaverage --hemi rh --fwhm 10 --sval rh.white.K.fsaverage.mgh --tval rh.white.K.fwhm10.fsaverage.mgh --cortex 

#--------------------------------------------
#@# Qdec Cache surf2surf rh white.K fwhm15 fsaverage mié abr  4 07:23:05 CEST 2018

 mri_surf2surf --prune --s fsaverage --hemi rh --fwhm 15 --sval rh.white.K.fsaverage.mgh --tval rh.white.K.fwhm15.fsaverage.mgh --cortex 

#--------------------------------------------
#@# Qdec Cache surf2surf rh white.K fwhm20 fsaverage mié abr  4 07:23:10 CEST 2018

 mri_surf2surf --prune --s fsaverage --hemi rh --fwhm 20 --sval rh.white.K.fsaverage.mgh --tval rh.white.K.fwhm20.fsaverage.mgh --cortex 

#--------------------------------------------
#@# Qdec Cache surf2surf rh white.K fwhm25 fsaverage mié abr  4 07:23:16 CEST 2018

 mri_surf2surf --prune --s fsaverage --hemi rh --fwhm 25 --sval rh.white.K.fsaverage.mgh --tval rh.white.K.fwhm25.fsaverage.mgh --cortex 

#--------------------------------------------
#@# Qdec Cache surf2surf rh white.H fwhm0 fsaverage mié abr  4 07:23:22 CEST 2018

 mri_surf2surf --prune --s fsaverage --hemi rh --fwhm 0 --sval rh.white.H.fsaverage.mgh --tval rh.white.H.fwhm0.fsaverage.mgh --cortex 

#--------------------------------------------
#@# Qdec Cache surf2surf rh white.H fwhm5 fsaverage mié abr  4 07:23:25 CEST 2018

 mri_surf2surf --prune --s fsaverage --hemi rh --fwhm 5 --sval rh.white.H.fsaverage.mgh --tval rh.white.H.fwhm5.fsaverage.mgh --cortex 

#--------------------------------------------
#@# Qdec Cache surf2surf rh white.H fwhm10 fsaverage mié abr  4 07:23:30 CEST 2018

 mri_surf2surf --prune --s fsaverage --hemi rh --fwhm 10 --sval rh.white.H.fsaverage.mgh --tval rh.white.H.fwhm10.fsaverage.mgh --cortex 

#--------------------------------------------
#@# Qdec Cache surf2surf rh white.H fwhm15 fsaverage mié abr  4 07:23:35 CEST 2018

 mri_surf2surf --prune --s fsaverage --hemi rh --fwhm 15 --sval rh.white.H.fsaverage.mgh --tval rh.white.H.fwhm15.fsaverage.mgh --cortex 

#--------------------------------------------
#@# Qdec Cache surf2surf rh white.H fwhm20 fsaverage mié abr  4 07:23:40 CEST 2018

 mri_surf2surf --prune --s fsaverage --hemi rh --fwhm 20 --sval rh.white.H.fsaverage.mgh --tval rh.white.H.fwhm20.fsaverage.mgh --cortex 

#--------------------------------------------
#@# Qdec Cache surf2surf rh white.H fwhm25 fsaverage mié abr  4 07:23:46 CEST 2018

 mri_surf2surf --prune --s fsaverage --hemi rh --fwhm 25 --sval rh.white.H.fsaverage.mgh --tval rh.white.H.fwhm25.fsaverage.mgh --cortex 

#--------------------------------------------
#@# Qdec Cache surf2surf rh jacobian_white fwhm0 fsaverage mié abr  4 07:23:52 CEST 2018

 mri_surf2surf --prune --s fsaverage --hemi rh --fwhm 0 --sval rh.jacobian_white.fsaverage.mgh --tval rh.jacobian_white.fwhm0.fsaverage.mgh --cortex 

#--------------------------------------------
#@# Qdec Cache surf2surf rh jacobian_white fwhm5 fsaverage mié abr  4 07:23:55 CEST 2018

 mri_surf2surf --prune --s fsaverage --hemi rh --fwhm 5 --sval rh.jacobian_white.fsaverage.mgh --tval rh.jacobian_white.fwhm5.fsaverage.mgh --cortex 

#--------------------------------------------
#@# Qdec Cache surf2surf rh jacobian_white fwhm10 fsaverage mié abr  4 07:23:59 CEST 2018

 mri_surf2surf --prune --s fsaverage --hemi rh --fwhm 10 --sval rh.jacobian_white.fsaverage.mgh --tval rh.jacobian_white.fwhm10.fsaverage.mgh --cortex 

#--------------------------------------------
#@# Qdec Cache surf2surf rh jacobian_white fwhm15 fsaverage mié abr  4 07:24:04 CEST 2018

 mri_surf2surf --prune --s fsaverage --hemi rh --fwhm 15 --sval rh.jacobian_white.fsaverage.mgh --tval rh.jacobian_white.fwhm15.fsaverage.mgh --cortex 

#--------------------------------------------
#@# Qdec Cache surf2surf rh jacobian_white fwhm20 fsaverage mié abr  4 07:24:08 CEST 2018

 mri_surf2surf --prune --s fsaverage --hemi rh --fwhm 20 --sval rh.jacobian_white.fsaverage.mgh --tval rh.jacobian_white.fwhm20.fsaverage.mgh --cortex 

#--------------------------------------------
#@# Qdec Cache surf2surf rh jacobian_white fwhm25 fsaverage mié abr  4 07:24:13 CEST 2018

 mri_surf2surf --prune --s fsaverage --hemi rh --fwhm 25 --sval rh.jacobian_white.fsaverage.mgh --tval rh.jacobian_white.fwhm25.fsaverage.mgh --cortex 

#--------------------------------------------
#@# Qdec Cache surf2surf rh w-g.pct.mgh fwhm0 fsaverage mié abr  4 07:24:18 CEST 2018

 mri_surf2surf --prune --s fsaverage --hemi rh --fwhm 0 --sval rh.w-g.pct.mgh.fsaverage.mgh --tval rh.w-g.pct.mgh.fwhm0.fsaverage.mgh --cortex 

#--------------------------------------------
#@# Qdec Cache surf2surf rh w-g.pct.mgh fwhm5 fsaverage mié abr  4 07:24:20 CEST 2018

 mri_surf2surf --prune --s fsaverage --hemi rh --fwhm 5 --sval rh.w-g.pct.mgh.fsaverage.mgh --tval rh.w-g.pct.mgh.fwhm5.fsaverage.mgh --cortex 

#--------------------------------------------
#@# Qdec Cache surf2surf rh w-g.pct.mgh fwhm10 fsaverage mié abr  4 07:24:24 CEST 2018

 mri_surf2surf --prune --s fsaverage --hemi rh --fwhm 10 --sval rh.w-g.pct.mgh.fsaverage.mgh --tval rh.w-g.pct.mgh.fwhm10.fsaverage.mgh --cortex 

#--------------------------------------------
#@# Qdec Cache surf2surf rh w-g.pct.mgh fwhm15 fsaverage mié abr  4 07:24:28 CEST 2018

 mri_surf2surf --prune --s fsaverage --hemi rh --fwhm 15 --sval rh.w-g.pct.mgh.fsaverage.mgh --tval rh.w-g.pct.mgh.fwhm15.fsaverage.mgh --cortex 

#--------------------------------------------
#@# Qdec Cache surf2surf rh w-g.pct.mgh fwhm20 fsaverage mié abr  4 07:24:33 CEST 2018

 mri_surf2surf --prune --s fsaverage --hemi rh --fwhm 20 --sval rh.w-g.pct.mgh.fsaverage.mgh --tval rh.w-g.pct.mgh.fwhm20.fsaverage.mgh --cortex 

#--------------------------------------------
#@# Qdec Cache surf2surf rh w-g.pct.mgh fwhm25 fsaverage mié abr  4 07:24:39 CEST 2018

 mri_surf2surf --prune --s fsaverage --hemi rh --fwhm 25 --sval rh.w-g.pct.mgh.fsaverage.mgh --tval rh.w-g.pct.mgh.fwhm25.fsaverage.mgh --cortex 

