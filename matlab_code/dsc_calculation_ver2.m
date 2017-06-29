function output_dice = dsc_calculation_ver2(number_images,data)
    
    output_dice = [];
    for k = 1:16

        dice_pairs=nchoosek(1:number_images,2);
        length = size(dice_pairs);
        temp_dice = [];

        for i = 1:length(1)
            pair_values = dice_pairs(i,:);

            % Implementation of DSC

            image_one = round(data(:,:,:,k,pair_values(1)));
            image_two = round(data(:,:,:,k,pair_values(2)));

            intersection = (image_one & image_two);
            a = sum(intersection(:));

            b = sum(image_one(:));
            c = sum(image_two(:));

            Dice = 2*a/(b+c);

            temp_dice = [temp_dice,Dice];

            %display(Dice)
        end

        output_dice = [output_dice;nanmean(temp_dice)];
    
    end
    display(output_dice)
end