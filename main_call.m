function main_call(directory_path)

%% Welcome Message
disp('Welcome to the ISMRM 2017 TraCED Analysis Pipeline');
disp('This code takes approximately 2 hours to run on an Intel I5 processor in a macbook pro');
disp('');
disp('Your Matlab version is: ')
disp(ver)
disp('This code has been tested on Matlab:');
disp('9.0.0.341360 (R2016a)');
disp('');

%% Find the location of this file and all the subdirectories to the matlab path
disp('Updating the Matlab Path');
[P,F,E]=fileparts(which('main_call'));
addpath(genpath(P))

disp('Defining Expected Data:')

vals = {'syn8533598','syn8649322','syn8649654','syn8662708','syn8662714','syn8666133','syn8666587', ...
    'syn8667022','syn8555229','syn8649611','syn8649656','syn8662709','syn8662715','syn8666134','syn8666598','syn8698866', ...
    'syn8643780','syn8649618','syn8649658','syn8662710','syn8662716','syn8666135','syn8666602','syn8698867', ...
    'syn8643793','syn8649622','syn8656474','syn8662711','syn8662717','syn8666136','syn8666936','syn8698868', ...
    'syn8648608','syn8649650','syn8656475','syn8662712','syn8662718','syn8666137','syn8667007','syn8649314', ...
    'syn8649652','syn8662707','syn8662713','syn8664905','syn8666138','syn8667021'};

Tract_name = {'UNC_L','UNC_R','FX_L','FX_R','Fminor','CNG_L','CNG_R','CST_L','CST_R','Fmajor','ILF_L','ILF_R','SLF_L','SLF_R','IFO_L','IFO_R'};

% These are the stats produced by the hosting engine: 
icc_mat = zeros(16,7,46);
dsc_mat = zeros(16,7,46);
icc_vals = [2 5 6 8 10 12 14];
dsc_vals = [1 3 4 7 9 11 13];

top_five = {'syn8664905','syn8666936','syn8667007','syn8666137','syn8666587'};
top_five_indexes = [];

for iVal=1:length(top_five)
    t = find(strcmp(vals,top_five{iVal}));
    top_five_indexes = [top_five_indexes,t];
end


%% Compute DSC and Kappa Statistics 
disp('Computing DSC and Kappa statistics:')

for jVal=1:length(vals)
    disp([num2str(jVal) ' of ' num2str(length(vals))])
    curDir = [directory_path filesep vals{jVal} filesep vals{jVal} filesep];
    scanner_A_file = sprintf('%sscanner_A.nii.gz',curDir);
    scanner_B_file = sprintf('%sscanner_B.nii.gz',curDir);
    
    M = report_dsc_kappa(scanner_A_file,scanner_B_file);
    
    icc_mat(:,:,jVal) = M(:,icc_vals);
    dsc_mat(:,:,jVal) = M(:,dsc_vals);
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% Forming interscanner ICC and Dice matrix

inter_scanner_icc = reshape(icc_mat(:,1,:),[16 46]);
inter_scanner_dsc = reshape(dsc_mat(:,1,:),[16 46]);

%% Violin Plots Dice & ICC Interscanner
disp('Plotting inter-scanner DSC and ICC :')

figure(1)
subplot(2,1,1)
title('Dice - Inter Scanner')
distributionPlot(inter_scanner_dsc','colormap',gray)
plotSpread(inter_scanner_dsc(:,top_five_indexes)','distributionMarkers','x','distributionColors','m')
set(gca,'XtickLabel',Tract_name(1,:))
grid on
legend('+ Mean','sq Median','x Top-5')

subplot(2,1,2)
title('ICC - Inter Scanner')
distributionPlot(inter_scanner_icc','colormap',gray)
plotSpread(inter_scanner_icc(:,top_five_indexes)','distributionMarkers','x','distributionColors','m')
set(gca,'XtickLabel',Tract_name(1,:))
grid on
print('inter_scanner_violin', '-depsc2','-r0')

%% Violin Plots Dice and ICC Intra Scanner
disp('Plotting intra-scanner DSC and ICC :')

intra_scanner_icc = reshape(nanmean(icc_mat(:,2:3,:),2),[16 46]);
intra_scanner_dsc = reshape(nanmean(dsc_mat(:,2:3,:),2),[16 46]);

figure(2)
subplot(2,1,1)
title('Dice - Intra Scanner')
distributionPlot(intra_scanner_dsc','colormap',gray)
plotSpread(intra_scanner_dsc(:,top_five_indexes)','distributionMarkers','x','distributionColors','m')
set(gca,'XtickLabel',Tract_name(1,:))
grid on
legend('+ Mean','sq Median','x Top-5')

subplot(2,1,2)
title('ICC - Intra Scanner')
distributionPlot(intra_scanner_icc','colormap',gray)
plotSpread(intra_scanner_icc(:,top_five_indexes)','distributionMarkers','x','distributionColors','m')
set(gca,'XtickLabel',Tract_name(1,:))
grid on
print('intra_scanner_violin', '-depsc2','-r0')

%% Violin Plots Dice and ICC Intra Session
disp('Plotting intra-session DSC and ICC :')

intra_session_icc = reshape(nanmean(icc_mat(:,4:7,:),2),[16 46]);
intra_session_dsc = reshape(nanmean(dsc_mat(:,4:7,:),2),[16 46]);

figure(3)
subplot(2,1,1)
title('Dice - Intra Session')
distributionPlot(intra_session_dsc','colormap',gray)
plotSpread(intra_session_dsc(:,top_five_indexes)','distributionMarkers','x','distributionColors','m')
set(gca,'XtickLabel',Tract_name(1,:))
grid on
legend('+ Mean','sq Median','x Top-5')

subplot(2,1,2)
title('ICC - Intra Session')
distributionPlot(intra_scanner_icc','colormap',gray)
plotSpread(intra_session_icc(:,top_five_indexes)','distributionMarkers','x','distributionColors','m')
set(gca,'XtickLabel',Tract_name(1,:))
grid on
print('intra_session_violin', '-depsc2','-r0')

% End of Violin Plots Analysis

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Generating Visual Tracts, Median Tract of the Top five Submissions
disp('Generating Visual Tracts, Median Tract of the Top five Submissions :')
median_matrix = zeros(78,93,75,16,20,5);

for jVal=1:length(top_five)
    curDir = [directory_path filesep top_five{jVal} filesep top_five{jVal} filesep];
    scanner_A_file = sprintf('%sscanner_A.nii.gz',curDir);
    scanner_B_file = sprintf('%sscanner_B.nii.gz',curDir);
    A = load_untouch_nii(scanner_A_file);
    B = load_untouch_nii(scanner_B_file);
    median_matrix(:,:,:,:,1:10,jVal) = A.img;
    median_matrix(:,:,:,:,11:20,jVal) = B.img;
end

output_median = median(median_matrix,6);

two_track_vis(output_median);

