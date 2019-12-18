function [feature_set] = Load_Features(Genres)

    %Classes - 1) Blues, 2) Classical, 3) Country, 4) Disco,  5) Hiphop,
    %          6) Jazz,  7) Metal,     8) Pop,     9) Reggae, 10) Rock.
    %Genres = ["blues", "classical", "country", "disco", "hiphop", "jazz", "metal", "pop", "reggae", "rock"];
   %{     
    genre_number = 1;
    for genre = Genres
        
        mfcc = dir(strcat('featDirMFCC/', genre, '.*'));
        cfcc = dir(strcat('featDirCFCC/', genre, '.*'));
        
        n_samples = length(mfcc);
        
        for i = 1:n_samples      
            %Keep Adding Features Here
            %MFCC
            mfcc_feat = load(strcat(mfcc(i).folder, '/', mfcc(i).name));
            %CFCC
            cfcc_feat = load(strcat(cfcc(i).folder, '/', cfcc(i).name));
            
            feature_set{genre_number,i} = [mfcc_feat, cfcc_feat];  
        end
        genre_number = genre_number + 1;
    end
    
end
%}


%
    %Classes - 1) Blues, 2) Classical, 3) Country, 4) Disco,  5) Hiphop,
    %          6) Jazz,  7) Metal,     8) Pop,     9) Reggae, 10) Rock.
    %Genres = ["blues", "classical", "country", "disco", "hiphop", "jazz", "metal", "pop", "reggae", "rock"];
        
    genre_number = 1;
    avg_over = 100;
    n_vec = 3000/avg_over;
    for genre = Genres
        
        mfcc = dir(strcat('featDirMFCC/', genre, '.*'));
        cfcc = dir(strcat('featDirCFCC/', genre, '.*'));
        
        n_samples = length(mfcc);
        
        for i = 1:n_samples      
            %Keep Adding Features Here
            %MFCC
            mfcc_feat = load(strcat(mfcc(i).folder, '/', mfcc(i).name));
            %CFCC
            cfcc_feat = load(strcat(cfcc(i).folder, '/', cfcc(i).name));
            
            %feature_set{genre_number,i} = [mfcc_feat, cfcc_feat]; 
            %feature_set{genre_number,i} = [cfcc_feat]; 

            %----------------------
            new_feat_set = [];
            temp1 = [cfcc_feat];
            temp2 = temp1(1:3000,:);
            for k = 1:n_vec
                subset = temp2(((k-1)*avg_over+1):k*avg_over, :);
                new_feat_set = [new_feat_set; mean(subset)];
            end
            feature_set{genre_number,i} = new_feat_set;
            %----------------------
        end
        genre_number = genre_number + 1;
    end
    
end



