% Calls Matlab scripts to calculate DSC and Kappa and then write them to a
% CSV file.

% Calls Matlab scripts to calculate DSC and Kappa and then write them to a
% CSV file.

function out_mat=report_dsc_kappa(nifti1,nifti2)

    accum_data_A = load_untouch_nii(nifti1);
    accum_data_B = load_untouch_nii(nifti2);
    
    dims = accum_data_A.hdr.dime.dim;
    % If single shell models
    if dims(6) == 30
       s1_start = 1;
       s1_end = 15;
       s2_start = 16;
       s2_end = 30;
       s1_s2 = 60;
    end
    
    % Multi shell models
    if dims(6) == 10
       s1_start = 1;
       s1_end = 5;
       s2_start = 6;
       s2_end = 10;
       s1_s2 = 20;
    end
    
    % Intra Scanner-Session Dice
    display('Intra Session Dice Scanner A')
    A_Intra_S1_dice = dsc_calculation_ver2(s1_end,accum_data_A.img(:,:,:,:,s1_start:s1_end));
    A_Intra_S2_dice = dsc_calculation_ver2(s1_end,accum_data_A.img(:,:,:,:,s2_start:s2_end));
    
    display('Intra Session Dice Scanner B')
    B_Intra_S1_dice = dsc_calculation_ver2(s1_end,accum_data_B.img(:,:,:,:,s1_start:s1_end));
    B_Intra_S2_dice = dsc_calculation_ver2(s1_end,accum_data_B.img(:,:,:,:,s2_start:s2_end));
    
    % Intra Scanner Dice
    display('Intra Scanner Dice')
    A_Intra_dice = dsc_calculation_ver2(s2_end,accum_data_A.img);
    B_Intra_dice = dsc_calculation_ver2(s2_end,accum_data_B.img);
    
    % Inter Scanner Dice
    display('Inter Scanner Dice')
    accum_data = cat(5,accum_data_A.img,accum_data_B.img);
    Inter_Scanner_Dice = dsc_calculation_ver2(s1_s2,accum_data);
    
    
    % Kappa Stats !
    
    % Intra Scanner-Session Kappa
    display('Intra Session ICC Scanner A')
    A_Intra_S1_icc = icc_calculation(s1_end,accum_data_A.img(:,:,:,:,s1_start:s1_end));
    A_Intra_S2_icc = icc_calculation(s1_end,accum_data_A.img(:,:,:,:,s2_start:s2_end));
    
    display('Intra Session ICC Scanner B')
    B_Intra_S1_icc = icc_calculation(s1_end,accum_data_B.img(:,:,:,:,s1_start:s1_end));
    B_Intra_S2_icc = icc_calculation(s1_end,accum_data_B.img(:,:,:,:,s2_start:s2_end));
    
    % Intra Scanner Kappa
    display('Intra Scanner ICC')
    A_Intra_icc = icc_calculation(s2_end,accum_data_A.img);
    B_Intra_icc = icc_calculation(s2_end,accum_data_B.img);
    
    % Inter Scanner Kappa
    display('Inter Scanner ICC')
    accum_data = cat(5,accum_data_A.img,accum_data_B.img);
    Inter_Scanner_icc = icc_calculation(s1_s2,accum_data);
    
    kapp_mean = nanmean(Inter_Scanner_icc);
    dsc_mean = nanmean(Inter_Scanner_Dice);
    
    values_out = [kapp_mean,dsc_mean];
    dlmwrite('values_out.txt',values_out);
    
    
    % Tables for the pdf.
    Tract_name = categorical({'Uncinate_Left';'Uncinate_Right';'Fornix_Left';'Fornix_Right';'Fminor';'Cingulum_Left';'Cingulum_Right';'CST_Left';'CST_Right';'Fmajor';'ILF_Left';'ILF_Right';'SLF_Left';'SLF_Right';'IFO_Left';'IFO_Right'});
    
    T5 = table(Tract_name,Inter_Scanner_Dice,Inter_Scanner_icc,A_Intra_dice,B_Intra_dice,A_Intra_icc,B_Intra_icc,B_Intra_S1_dice,B_Intra_S1_icc,B_Intra_S2_dice,B_Intra_S2_icc,A_Intra_S1_dice,A_Intra_S1_icc,A_Intra_S2_dice,A_Intra_S2_icc);
    
    out_mat = [Inter_Scanner_Dice,Inter_Scanner_icc,A_Intra_dice,B_Intra_dice,A_Intra_icc,B_Intra_icc,B_Intra_S1_dice,B_Intra_S1_icc,B_Intra_S2_dice,B_Intra_S2_icc,A_Intra_S1_dice,A_Intra_S1_icc,A_Intra_S2_dice,A_Intra_S2_icc];
    
    %writetable(T5,output_csv_name,'Delimiter',',')

end