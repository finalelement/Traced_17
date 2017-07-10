function vis_unc_fornix(output_median,sub_num)

    nii = load_untouch_nii('MNI152_T1_25mm.nii.gz');
    raw = nii.img;

    % files are called scanner_A.nii and scanner_B.nii
    % each is 78 93 75 16 10.

    % The last dimension is the scan repeats
    % the first five are session 1 and latter five are session 2
    % 4th dimension is the tracts (16 tracks).  

    names = {'UNCINATE_L';'UNCINATE_R';'FORNIX_L';'FORNIX_R'}
    
    %% setup
    opts = struct; opts.labelsmooth = 0; opts.ilim = [0.0473; 0.2141];
    opts.labelcolors = [1 0 0]; 
    opts.xslices = 'mid'; opts.yslices = 'mid'; opts.zslices = 'mid'; 
    opts.material = 'metal'; 
    opts.resdims = [1 1 1];
    opts.slicealpha = .8;
    opts.labelsmooth = 0;
    opts.isosmooth = {};
    opts.bg_label = 'none';
    opts.bg_color = [0 0 0];
    opts.bg_alpha = 0.05;
    opts.fignum = 1;
    opts.lighting = 'phong';
    opts.camlight = {'headlight'};

    raw = double(raw);
    
    %% Quality check ranking
    % choose the highest, middle, and lowest ranked teams 
    % show the variability across the 10 repeats of a single scanner (5 repeats of the two sessions)

    names_index = [1 2 3 4 5 10 6 7 8 9 11 12 13 14 15 16];
    index_counter = 1;

    for track = 1:(length(names)/2)
        
        % Track_1 is Left and Track_2 is Right, incase of Fminor - 1 and
        % Fmajor - 2
        
        track_1 = names_index(1,index_counter);
        track_2 = names_index(1,index_counter+1);

        % Increment index counter for next loop
        index_counter = index_counter + 2;

        repeats_1 = squeeze(output_median(:,:,:,track_1,:));
        repeats_2 = squeeze(output_median(:,:,:,track_2,:));

        dims = size(repeats_1);

        if track_1 == 1; v = [90,47]; xsl = round(dims(1)/2); ysl= round(dims(2)/2); zsl = 23; end
        if track_1 == 3; v = [90,85]; xsl = round(dims(1)/2); ysl= round(dims(2)/2); zsl = 23; end
        
        track_name = names{track_1};

        figure(opts.fignum); clf;
        colormap(gray);

        ss = slice(1:dims(2), 1:dims(1), 1:dims(3), raw, ysl, xsl, zsl);
        for z = 1:length(ss)
            set(ss(z), 'FaceAlpha', opts.slicealpha);
        end

        % set the viewing angle
        view(v(1), v(2));

        % set the lighting options
        lighting(opts.lighting);
        cams = cell(size(opts.camlight));
        for i = 1:length(opts.camlight)
            cams{i} = camlight(opts.camlight{i});
        end

        % set the final visualization options
        shading interp;
        daspect(1 ./ opts.resdims);
        xlim([1 dims(2)]);
        ylim([1 dims(1)]);
        zlim([1 dims(3)]);
        axis vis3d;
        axis off;

        for z = 1:length(ss)
            set(ss(z), 'FaceLighting', 'none');
        end
        
        
        %%
        % for each repetition, rendering Track_1 or Left Track or Fminor
        for i=1:dims(4)
            seg = squeeze(repeats_1(:,:,:,i));

            if isempty(seg(seg>0 & seg<1))
                iso = isosurface(seg, 0.5);
                disp('binary')
            else
                iso = isosurface(seg, 0.05);
                disp('probabilistic')
            end
            
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            % Color Conditions

            if (track_1 == 1)
                v_color = 'red';
            end

            if (track_1 == 3)
                v_color = 'blue';
            end

            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

            num = size(iso.vertices, 1);
            patch('Vertices', iso.vertices, ...
                'Faces', iso.faces, ...
                'FaceVertexCData', repmat([1 0 0], [num 1]), ...
                'FaceColor', v_color, ...
                'FaceAlpha', 1/2, ...
                'EdgeColor', 'none');
        end
        
        % for each repetition, rendering Track_2 or Right Track or Fmajor
        for i=1:dims(4)
            seg = squeeze(repeats_2(:,:,:,i));

            if isempty(seg(seg>0 & seg<1))
                iso = isosurface(seg, 0.5);
                disp('binary')
            else
                iso = isosurface(seg, 0.05);
                disp('probabilistic')
            end
            
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            % Color Conditions
            if (track_2 == 2)
                v_color = 'red';
            end

            if (track_2 == 4)
                v_color = 'blue';
            end

            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

            num = size(iso.vertices, 1);
            patch('Vertices', iso.vertices, ...
                'Faces', iso.faces, ...
                'FaceVertexCData', repmat([1 0 0], [num 1]), ...
                'FaceColor', v_color, ...
                'FaceAlpha', 1/2, ...
                'EdgeColor', 'none');

        end

        % Saving the Track image in the current directory.
        pause(1);
        rez=300; f=gcf; figpos=getpixelposition(f);
        resolution=get(0,'ScreenPixelsPerInch');
        set(f,'paperunits','inches','papersize',figpos(3:4)/resolution,'paperposition',[0 0 figpos(3:4)/resolution]);
        print(f,[num2str(sub_num) '_median_' track_name] ,'-dpng',['-r',num2str(rez)],'-opengl')
        print(f,[num2str(sub_num) '_median_' track_name] ,'-depsc2',['-r',num2str(rez)],'-opengl')
        pause(1);
        close all;

    end

end
