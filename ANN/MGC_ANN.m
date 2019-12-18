clc
clear
%Avalibale Classes
Genres = ["blues", "classical", "country", "disco", "hiphop", "jazz", "metal", "pop", "reggae", "rock"];
%Genres = ["pop"];
n_classes = length(Genres);

%Loading Features
feature_set = LoadFeaturesLibrosaann(Genres,1);

%Bifurcating data into training and testing set (need to do K-fold Cross Validation)
training_set = feature_set(:, 1:80);

testing_set = feature_set(:,81:100);


new_train_set=training_set;
new_test_set=testing_set;

feature_set_train = new_train_set;
feature_set_test=new_test_set;

supertrain = [];
labelstrain =[];
supertest = [];
labelstest =[];
min_d=10000;
for i=1:n_classes
    [n_fec_train,n_samples_train] = size(feature_set_train(i,:));
    [n_fec_test,n_samples_test]= size(feature_set_test(i,:));
    for j=1:n_samples_train
        if(length(feature_set_train{i,j})<min_d)
            min_d=length(feature_set_train{i,j});
        end
    end
    
    for j=1:n_samples_test
        if(length(feature_set_test{i,j})<min_d)
            min_d=length(feature_set_test{i,j});
        end
    end
end

for i=1:n_classes
    [n_fec_train,n_samples_train] = size(feature_set_train(i,:));
    [n_fec_test,n_samples_test]= size(feature_set_test(i,:));
    for j=1:n_samples_train
    supertrain = [supertrain feature_set_train{i,j}(:,1:min_d)];
    labelstrain = [labelstrain (ones(1,min_d)*i)];
    end
    
    for j=1:n_samples_test
    supertest = [supertest feature_set_test{i,j}(:,1:min_d)];
    labelstest = [labelstest (ones(1,min_d)*i)];
    end
   
end
targettrain = full(ind2vec(labelstrain));
targettest = full(ind2vec(labelstest));
super_set=supertrain;
super_label=targettrain;
net = patternnet(10);
view(net)
net.divideParam.trainRatio = 80/100;
net.divideParam.valRatio = 20/100;
net.divideParam.testRatio = 0/100;
[net,tr] = train(net,super_set,super_label);
y=net(supertest)
nntraintool
for i=1:n_classes
    count=1;
    for j=1:129:length(labelstest)
        averagedscores(i,count)= mean(mean(y(i,j:j+128)));
        count=count+1;
    end
end
count=1;
for k=1:129:length(labelstest)
     tlabels(count) = mode(mode(labelstest(:,k:k+128)));
     yind=vec2ind(y);
     plabels(count) = (mode(yind(:,k:k+128)));
     count=count+1;
end
acc=sum(tlabels==plabels);