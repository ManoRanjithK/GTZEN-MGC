function [feature_set] = LoadFeatureslibrosa(Genres)


    %Classes - 1) Blues, 2) Classical, 3) Country, 4) Disco,  5) Hiphop,
    %          6) Jazz,  7) Metal,     8) Pop,     9) Reggae, 10) Rock.
    %Genres = ["blues", "classical", "country", "disco", "hiphop", "jazz", "metal", "pop", "reggae", "rock"];
        
    genre_number = 1;
    avg_over = 10;
    n_vec = 1290/avg_over;
    for genre = Genres
        
        mfcc = dir(strcat('ExtLibrosaMFCC/', genre, '/*.mat'));
       % cfcc = dir(strcat('newfeatDirCFCC/', genre, '.*'));
        
        n_samples = length(mfcc);
        
        for i = 1:n_samples      
            %Keep Adding Features Here
            %MFCC
            mfcc_feat = load(strcat(mfcc(i).folder, '/', mfcc(i).name));
          
            new_feat_set = [];
            temp1 = (cell2mat(struct2cell([mfcc_feat])))'; 
            temp2 = temp1(1:1290,:);
            for k = 1:n_vec
                subset = temp2(((k-1)*avg_over+1):k*avg_over, :);
                new_feat_set = [new_feat_set; mean(subset)];
            end
            feature_set{genre_number,i} = new_feat_set;
            %feature_set{genre_number,i} = cfcc_feat; 
            %feature_set{genre_number,i} = mfcc_feat; 
            %feature_set{genre_number,i} = mean([mfcc_feat, cfcc_feat]);
        end
        genre_number = genre_number + 1;
    end
    
end

