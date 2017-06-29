function output_kappa = cohen_kappa_calc(number_images,data)
    
    output_kappa = [];
    for k = 1:16
        
        kappa_pairs=nchoosek(1:number_images,2);
        length = size(kappa_pairs);
        temp_kappa = [];
    
        for i = 1:length(1)
            pair_values = kappa_pairs(i,:);
            
            % Transforming Data for Kappa Calculation
            image_one = round(data(:,:,:,k,pair_values(1)));
            image_two = round(data(:,:,:,k,pair_values(2)));
            
            dims = size(image_one);
            %image_one_re = reshape(image_one,[1 dims(1)*dims(2)*dims(3)]);
            %image_two_re = reshape(image_two,[1 dims(1)*dims(2)*dims(3)]);
            
            % Cohen's Kappa Implementation
            a_val = find(image_one == 1 & image_two == 1);
            b_val = find(image_one == 1 & image_two == 0);
            c_val = find(image_one == 0 & image_two == 1);
            d_val = find(image_one == 0 & image_two == 0);
            
            a = size(a_val);
            b = size(b_val);
            c = size(c_val);
            d = size(d_val);
   
            p0 = (a(1)+d(1))/(a(1)+b(1)+c(1)+d(1));
            marginal_a = ((a(1) + b(1))*(a(1)+c(1))) / (a(1)+b(1)+c(1)+d(1));
            marginal_b = ((c(1) + d(1))*(b(1)+d(1))) / (a(1)+b(1)+c(1)+d(1));
            
            pe = (marginal_a + marginal_b) / (a(1)+b(1)+c(1)+d(1));
            
            kapp = (p0 - pe)/(1 - pe);
            
            temp_kappa = [temp_kappa,kapp];
            
        end
        
        output_kappa = [output_kappa;nanmean(temp_kappa)];
        
    end
    display(output_kappa)    
end