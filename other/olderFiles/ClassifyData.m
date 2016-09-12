function [ C, ac ] = ClassifyData( Data, Labels,is_multiclass)
%% ------------------------ CLASSIFICATION -----------------------------
numSubjects = size(Data,1);
numLabels = length(unique(Labels));
%creating training and testing data: first create an indices vector in the
%following way: we have numSubjects instances of every segment, 0.8*numSubjects(say) examples of
%these instances will be used for training and the rest for testing.
% we need to generate an indices vector that will have random entries
% within the set: i*(1:numSubjects)(where i = 1:numLabels), and then take first 0.8*numSubjects for training and the rest for
% testing.

%permute the Data and Labels randomly to remove any patterns
randInd = randperm(numSubjects)';
Data = Data(randInd,:);
Labels = Labels(randInd,:);
Ind0 = (Labels==0);
Ind1 = (Labels==1);
Ind2 = (Labels==2);
Data0 = Data(Ind0,:);
Data1 = Data(Ind1,:);
Data2 = Data(Ind2,:);
numTraining0 = floor(0.8*size(Data0,1));
numTraining1 = floor(0.8*size(Data1,1));
numTraining2 = floor(0.8*size(Data2,1));
numTesting0 = size(Data0,1) - numTraining0;
numTesting1 = size(Data1,1) - numTraining1;
numTesting2 = size(Data2,1) - numTraining2;

TrainSet = [Data0(1:numTraining0,:);Data1(1:numTraining1,:);Data2(1:numTraining2,:)];
TestSet = [Data0(numTraining0+1:end,:);Data1(numTraining1+1:end,:);Data2(numTraining2+1:end,:)];
TrainLabels = [zeros(numTraining0,1);1*ones(numTraining1,1);2*ones(numTraining2,1)];
TestLabels = [zeros(numTesting0,1);2*ones(numTesting1,1);2*ones(numTesting2,1)];
randInd = randperm(size(TrainSet,1))';
TrainSet = TrainSet(randInd,:);
TrainLabels = TrainLabels(randInd);
randInd = randperm(size(TestSet,1))';
TestSet = TestSet(randInd,:);
TestLabels = TestLabels(randInd);


%  [Train, Test] = crossvalind('LeaveMOut', length(Data),ceil(0.2*length(Data)));
% trainLabels = Labels(Train);
% trainData = Data(Train,:);
% testData = Data(Test,:);
% testLabels = Labels(Test);

% % now create the randomly permuted data and Labels for training and testing
% randInd = randperm(numSubjects);
% permData = Data(randInd,:);
% permLabels = Labels(randInd,:);
% numTrain = ceil(0.8*numSubjects);
% numTest = numSubjects - numTrain;
%
%
% trainInd = randInd(1:numTrain);
% testInd = randInd(numTrain+1:end);
% trainData = permData(trainInd,:);
% testData = permData(testInd,:);
% trainLabels = permLabels(trainInd);
% testLabels = permLabels(testInd);
%
%
% %now permute these vectors
% a = randperm(length(trainInd));
% trainData1 = trainData(a,:);
% trainLabels1 = trainLabels(a);
%
% a = randperm(length(testInd));
% testData1 = testData(a,:);
% testLabels1 = testLabels(a);
%
if(is_multiclass)
    err=0;specificity = 0; sensitivity = 0;cnt_sen = 0;cnt_spe = 0;
        num_trials = 5;
        indices = crossvalind('Kfold',numSubjects,5);
    
        for i=1:num_trials
    
            %[Train, Test] = crossvalind('LeaveMOut', length(Data),ceil(0.2*length(Data)));
    
            Test = (indices == i); Train = ~Test;
    
            trainLabels = Labels(Train);
            trainData = Data(Train,:);
            testData = Data(Test,:);
            testLabels = Labels(Test);
    
    %using libsvm
%              % Train the SVM
%             model = svmtrain_libsvm(trainLabels, trainData, '-t 0 -c 100 -g 0.005 -b 1');
%             % Use the SVM model to classify the data
%             [predict_label, ac, prob_values] = svmpredict_libsvm(testLabels, testData, model, '-b 1'); % run the SVM model on the test data
    %using liblinear
             % Train the SVM
            is_liblinear = 1;
            model = ovrtrain(trainLabels, trainData,'.',is_liblinear);

            for k = 1:numLabels
                % Use the SVM model to classify the data
                [predict_label,~,p] = svmpredict_liblinear(double(testLabels==k-1), sparse(testData), model.models{k}, '-b 1');
            end
            n_label = 0; d_label = 1;
            err = err + (length(find(testLabels~=predict_label))/length(testLabels));
            tp = length(find(testLabels == d_label & predict_label == d_label));%number of true positives
            fn = length(find(testLabels == d_label & predict_label == n_label));%number of false negatives
            if(tp+fn == 0)
                stop = 1;
            else
                sensitivity = sensitivity + (tp/(tp+fn));
                cnt_sen = cnt_sen+1;
            end
            tn = length(find(testLabels == d_label & predict_label == n_label));%number of true positives
            fp = length(find(testLabels == n_label & predict_label == d_label));%number of false negatives
             if(tn+fp == 0)
                stop = 1;
             else
                 specificity = specificity + (tn/(tn+fp));
                 cnt_spe = cnt_spe+1;
            end
    
        end
        err = err./num_trials;
        sensitivity = sensitivity./cnt_sen;
        specificity = specificity./cnt_spe;
    fprintf('error is %f, sensitivity is %f, specificity is %f \n',err,sensitivity,specificity)
    C=0;
%%%
%     model = ovrtrain(TrainLabels, TrainSet,'-t 0 -c 10 -g 0.25 -b 1');
%     
%     prob = zeros(nnz(TestSet),numLabels);
%     for k=1:numLabels
%         [~,~,p] = svmpredict_libsvm(double(TestLabels==k-1), TestSet, model.models{k}, '-b 1');
%         prob(:,k) = p(:,model.models{k}.Label==1);    %# probability of class==k
%     end
%     
%     %# predict the class with the highest probability
%     [~,pred] = max(prob,[],2);
%     ac = sum(pred == TestLabels) ./ numel(TestLabels)    %# accuracy
%     %C = confusionmat(testLabels, pred)    ;
else
% % % % % %     %%first choose C and Gamma parameters
% % % % % %     %[C,gamma] = meshgrid(-5:2:15, -15:2:3);
% % % % % %         [C,S] = meshgrid(-5:2:15, 0:6);
% % % % % % 
% % % % % %     folds = 3;
% % % % % %     %# grid search, and cross-validation
% % % % % %     cv_acc = zeros(numel(C),1);
% % % % % %     for i=1:numel(C)
% % % % % %         %cv_acc(i) = svmtrain_libsvm(TrainLabels, TrainSet, sprintf('-t 2 -c %f -g %f -v %d', 2^C(i), 2^gamma(i), folds));
% % % % % %         cv_acc(i) = svmtrain_liblinear(TrainLabels, sparse(TrainSet), sprintf('-c %f -v %d -s %d', 2^C(i), folds, S(i)));
% % % % % %     end
% % % % % %     
% % % % % %     %# pair (C,gamma) with best accuracy
% % % % % %     [~,idx] = max(cv_acc);
% % % % % %     
% % % % % % %     %# contour plot of paramter selection
% % % % % % %     contour(C, gamma, reshape(cv_acc,size(C))), colorbar
% % % % % % %     hold on
% % % % % % %     plot(C(idx), gamma(idx), 'rx')
% % % % % % %     text(C(idx), gamma(idx), sprintf('Acc = %.2f %%',cv_acc(idx)), ...
% % % % % % %         'HorizontalAlign','left', 'VerticalAlign','top')
% % % % % % %     hold off
% % % % % % %     xlabel('log_2(C)'), ylabel('log_2(\gamma)'), title('Cross-Validation Accuracy')
% % % % % %     
% % % % % %     %# now you can train you model using best_C and best_gamma
% % % % % %     best_C = 2^C(idx);
% % % % % %     best_S = S(idx);
% % % % % %  %   best_gamma = 2^gamma(idx);
% % % % % %     %# ...
% % % % % %    % model = svmtrain_libsvm(TrainLabels, TrainSet, sprintf('-t 2 -c %f -g %f ', best_C, best_gamma));
% % % % % %     model = svmtrain_liblinear(TrainLabels, sparse(TrainSet), sprintf('-c %f -s %f ', best_C, 5));
% % % % % %     
% % % % % % 
%     model = svmtrain_libsvm(TrainLabels, TrainSet, '-t 2 -c 10 -g 0.01 ');
% 
%    % model = svmtrain_liblinear(TrainLabels, sparse(TrainSet), '-c 100 -s 5 ');
%     err=0;specificity = 0; sensitivity = 0;cnt_sen = 0;cnt_spe = 0;
%     %   using libsvm
%     % Train the SVM
%    % model = svmtrain_libsvm(TrainLabels, TrainSet, '-t 2 -c 10 -g 0.05 -b 1');
%     % Use the SVM model to classify the data
%     [predict_label, ac, prob_values] = svmpredict_libsvm(TestLabels, TestSet, model); % run the SVM model on the test data
%       %  [predict_label, ac,prob] = svmpredict_liblinear(TestLabels, sparse(TestSet), model, '-b 1'); % run the SVM model on the test data
% 
%     %  using liblinear
%     %     model = svmtrain_liblinear(TrainLabels, sparse(TrainSet),'-c 10 -s 2 -v 5');
%     %   %  model = svmtrain_liblinear(Labels, sparse(Data),'-v 5');
%     %
%     %     % Use the SVM model to classify the data
%     %     [predict_label, ac, prob_values] = svmpredict_liblinear(TestLabels, sparse(TestSet), model, '-b 1'); % run the SVM model on the test data
%     err = (length(find(TestLabels~=predict_label))/length(TestLabels));
%     tp = length(find(TestLabels == 2 & predict_label == 2));%number of true positives
%     fn = length(find(TestLabels == 2 & predict_label == 0));%number of false negatives
%     if(tp+fn == 0)
%         stop = 1;
%     else
%         sensitivity = (tp/(tp+fn));
%         
%     end
%     tn = length(find(TestLabels == 0 & predict_label == 0));%number of true positives
%     fp = length(find(TestLabels == 0 & predict_label == 2));%number of false negatives
%     if(tn+fp == 0)
%         stop = 1;
%     else
%         specificity = (tn/(tn+fp));
%         
%     end
%     fprintf('error is %f, sensitivity is %f, specificity is %f \n',err,sensitivity,specificity)
%     
  err=0;specificity = 0; sensitivity = 0;cnt_sen = 0;cnt_spe = 0;
        num_trials = 5;
        indices = crossvalind('Kfold',numSubjects,5);
    
        for i=1:num_trials
    
            %[Train, Test] = crossvalind('LeaveMOut', length(Data),ceil(0.2*length(Data)));
    
            Test = (indices == i); Train = ~Test;
    
            trainLabels = Labels(Train);
            trainData = Data(Train,:);
            testData = Data(Test,:);
            testLabels = Labels(Test);
    
    %using libsvm
%              % Train the SVM
%             model = svmtrain_libsvm(trainLabels, trainData, '-t 0 -c 100 -g 0.005 -b 1');
%             % Use the SVM model to classify the data
%             [predict_label, ac, prob_values] = svmpredict_libsvm(testLabels, testData, model, '-b 1'); % run the SVM model on the test data
    %using liblinear
             % Train the SVM
            model = svmtrain_liblinear(trainLabels, sparse(trainData));
            % Use the SVM model to classify the data
            [predict_label, ac, prob_values] = svmpredict_liblinear(testLabels, sparse(testData), model, '-b 1'); % run the SVM model on the test data
    
            err = err + (length(find(testLabels~=predict_label))/length(testLabels));
            tp = length(find(testLabels == 2 & predict_label == 2));%number of true positives
            fn = length(find(testLabels == 2 & predict_label == 0));%number of false negatives
            if(tp+fn == 0)
                stop = 1;
            else
                sensitivity = sensitivity + (tp/(tp+fn));
                cnt_sen = cnt_sen+1;
            end
            tn = length(find(testLabels == 0 & predict_label == 0));%number of true positives
            fp = length(find(testLabels == 0 & predict_label == 2));%number of false negatives
             if(tn+fp == 0)
                stop = 1;
             else
                 specificity = specificity + (tn/(tn+fp));
                 cnt_spe = cnt_spe+1;
            end
    
        end
        err = err./num_trials;
        sensitivity = sensitivity./cnt_sen;
        specificity = specificity./cnt_spe;
    fprintf('error is %f, sensitivity is %f, specificity is %f \n',err,sensitivity,specificity)
    C=0;
end

%looking at the weights of the features:
%w = (model.sv_coef' * full(model.SVs))



