function output_icc = icc_calculation(number_images,data)

    output_icc = [];
    for k = 1:16

        dice_pairs=nchoosek(1:number_images,2);
        length = size(dice_pairs);
        temp_icc = [];

        for i = 1:length(1)
            pair_values = dice_pairs(i,:);

            % Implementation of ICC
            image_one = data(:,:,:,k,pair_values(1));
            image_two = data(:,:,:,k,pair_values(2));
            
            dims = size(image_one);
            
            one_re = reshape(image_one,[dims(1)*dims(2)*dims(3) 1]);
            two_re = reshape(image_two,[dims(1)*dims(2)*dims(3) 1]);
            
            M = cat(2,one_re,two_re);
            
            icc = ICC(M,'1-1');
            
            temp_icc = [temp_icc,icc];
            
        end
        output_icc = [output_icc;nanmean(temp_icc)];
    end        
    display(output_icc)
end