% % % cd 'C:\MyWork\Stanford\Documents\ad_paper_data_figures\PaperData';
% % % % load 'TrainingTestingDataLabels3sigma.mat';
% % % load TrainingTestingFullData.mat
% % % % 
% cd 'C:\MyWork\Stanford\Documents\ad_paper_data_figures\PaperData';
% % load AllTrainingTestingDataNew.mat
% k=10;
% for i=1:k
%     for j=1:length(AllTrainingData{i})
%         AllTrainingData{i}(j).IsTraining = 1;
%     end
% end
% for i=1:k
%     for j=1:length(AllTestingData{i})
%         AllTestingData{i}(j).IsTraining = 0;
%     end
% end
% for i=1:k
%     AllROIs{i} = [AllTrainingData{i}, AllTestingData{i}];
% end
% % 
% [ data,labels,test_train ] = TenMethodsPrepareDataForClassification( AllROIs);
% max_data = max(abs(data));
% data = data./(ones(size(data,1),1)*max_data);

% % % % 
featureind = [1:26,31,32];%69.12 
%  featureind = [1:21,26,41,42];%70.59 
%  featureind = [1:21,26,31:42];%67.65
% featureind = [1:21,26,32,37,41,42];%70.59
%  featureind = [1:21,26,32,33,37,38,41,42];%70.12
% featureind = [1:21,26,32,37];%67.65
featureind = [1:21,26,31,32,36,37,41,42];%67.65 %best for CNAD
% featureind = [1:30,41,42];%CN MCIc
%  featureind = [1:32];
%  featureind = [1:21,41,42];%67.65 %72.97 for CNMCIc
%  featureind = [1:42];
featureind = [1:30,41,42];%67.65 %72.97 for CNMCIc
% featureind = [1:11,15,20,22:42];
%featureind = [1:11,15,16,20:40];


data = data1;labels = labels1;test_train = test_train1;
TrainingData = data(test_train ==1,featureind);
TestingData = data(test_train ==0,featureind);
TrainingLabels = labels(test_train==1);
TestingLabels = labels(test_train==0);


numSubjects = size(data,1);
numTraining = length(TrainingData);
numTesting = numSubjects - numTraining;
classification_task = 'CNAD';%{'CNAD','CNMCIc','MCIcnc'};
%feat = 32;


    clear model trainData trainLabels testData testLabels predict_label best_C best_S cv_acc;
       switch classification_task
        case 'CNAD'
            trainData = TrainingData(TrainingLabels==0 | TrainingLabels==1,:);
            trainLabels = TrainingLabels(TrainingLabels==0 | TrainingLabels==1,:);
            testData = TestingData(TestingLabels==0 | TestingLabels==1,:);
            testLabels = TestingLabels(TestingLabels==0 | TestingLabels==1,:);
            d_label = 1;n_label = 0;
        case 'CNMCIc'
            trainData = TrainingData(TrainingLabels==0 | TrainingLabels==2,:);
            trainLabels = TrainingLabels(TrainingLabels==0 | TrainingLabels==2,:);
            testData = TestingData(TestingLabels==0 | TestingLabels==2,:);
            testLabels = TestingLabels(TestingLabels==0 | TestingLabels==2,:);
            d_label = 2;n_label = 0;
        case 'MCIcnc'
            trainData = TrainingData(TrainingLabels==3 | TrainingLabels==2,:);
            trainLabels = TrainingLabels(TrainingLabels==3 | TrainingLabels==2,:);
            testData = TestingData(TestingLabels==3 | TestingLabels==2,:);
            testLabels = TestingLabels(TestingLabels==3 | TestingLabels==2,:);
            d_label = 2;n_label = 3;
        case 'CNMCInc'
            trainData = TrainingData(TrainingLabels==3 | TrainingLabels==0,:);
            trainLabels = TrainingLabels(TrainingLabels==3 | TrainingLabels==0,:);
            testData = TestingData(TestingLabels==3 | TestingLabels==0,:);
            testLabels = TestingLabels(TestingLabels==3 | TestingLabels==0,:);
            d_label = 3;n_label = 0;
    end
    
numLabels = length(unique(trainLabels));
is_liblinear =1;
is_multiclass = 0;
if(~is_multiclass)
    %%first choose C and Gamma parameters
    %%
    C = -1:2:20;
    if(is_liblinear)
        S = 0:6;
    else
        gamma = -6:2:5;
    end
    
    folds = 5;
    %# grid search, and cross-validation
    for i=1:numel(C)
        if(is_liblinear)
            last_param = numel(S);
        else
            last_param = numel(gamma);
        end
        for j=1:last_param
            if(~is_liblinear)
                
                cv_acc(i,j) = svmtrain_libsvm(trainLabels, trainData, sprintf('-t 0 -c %f -g %f -v 5 -q', double(2^C(i)), double(2^gamma(j))));
            else
                cv_acc(i,j) = svmtrain_liblinear(trainLabels, sparse(trainData), sprintf('-c %f -s %f -v %d -q', 2^C(i), S(j), folds));
            end
        end
    end
    
    %# pair (C,gamma) with best accuracy
    [i,j] = find(cv_acc == max(max(cv_acc)),1);
    % if(~is_liblinear)
    %     %# contour plot of paramter selection
    %     contour(C, gamma, reshape(cv_acc,size(C))), colorbar
    %     hold on
    %     plot(C(idx), gamma(idx), 'rx')
    %     text(C(idx), gamma(idx), sprintf('Acc = %.2f %%',cv_acc(idx)), ...
    %         'HorizontalAlign','left', 'VerticalAlign','top')
    %     hold off
    %     xlabel('log_2(C)'), ylabel('log_2(\gamma)'), title('Cross-Validation Accuracy')
    % end
    %# now you can train you model using best_C and best_gamma
    best_C = 2^C(i);
    if(is_liblinear)
        best_S = S(j);
        model = svmtrain_liblinear(trainLabels, sparse(trainData), sprintf('-c %f -s %f -q', best_C, best_S));
    else
        best_gamma = 2^gamma(j);
        model = svmtrain_libsvm(trainLabels, trainData, sprintf('-t 0 -c %f -g %f -q -b 1', best_C, best_gamma));
    end
    
    
    if(~is_liblinear)
        [predict_label, ac, p] = svmpredict_libsvm(testLabels, testData, model, sprintf('-b 1')); % run the SVM model on the test data
    else
        [predict_label,~,p] = svmpredict_liblinear(testLabels, sparse(testData), model,sprintf('-b 1'));
    end
    
    
    tp = length(find(testLabels == d_label & predict_label == d_label));%number of true positives
    fn = length(find(testLabels == d_label & predict_label == n_label));%number of false negatives
    
    sensitivity = tp/(tp+fn)
    
    tn = length(find(testLabels == n_label & predict_label == n_label));%number of true positives
    fp = length(find(testLabels == n_label & predict_label == d_label));%number of false negatives
    specificity = tn/(tn+fp)
    
    err = length(find(testLabels == predict_label))/length(testLabels)
  %  fprintf('accuracy is %f, sensitivity is %f, specificity is %f \n',err,sensitivity,specificity)
    ppv = tp/(tp+fp)
    npv = tn/(tn+fn)
    hits = length(find(testLabels == d_label & predict_label == d_label)); %tp
    misses = length(find(testLabels == d_label & predict_label == n_label)); %fn
    false_alarm = length(find(testLabels == n_label & predict_label == d_label));%fp
    correct_rejection = length(find(testLabels == n_label & predict_label == n_label));%tn
    hr = hits/(hits+misses); %tp/(tp+fn) = sensitivity
    far = false_alarm/(false_alarm+correct_rejection); %fp/(fp+tn)
    if(norminv(far)<0)
        stop = 1;
    end
    d_prime = norminv(hr)-norminv(far)
    c = -(norminv(hr)+norminv(far))/2   %bias
    if (is_liblinear)
    w = model.w(1,:);
    end
    
else %multiclass
    %     model = ovrtrain(TrainingLabels, TrainingData,'.',is_liblinear);
    %
    %     for k = 1:numLabels
    %         % Use the SVM model to classify the data
    %         [predict_label,~,p] = svmpredict_liblinear(double(TestingLabels==k-1), sparse(TestingData), model.models{k}, '-b 1');
    %     end
    %     tp = length(find(TestingLabels == d_label & predict_label == d_label));%number of true positives
    %     fn = length(find(TestingLabels == d_label & predict_label == n_label));%number of false negatives
    %     sensitivity = (tp/(tp+fn));
    %
    %     tn = length(find(TestingLabels == d_label & predict_label == n_label));%number of true positives
    %     fp = length(find(TestingLabels == n_label & predict_label == d_label));%number of false negatives
    %     specificity = (tn/(tn+fp));
    %       err = length(find(TestingLabels == predict_label))/length(TestingLabels);
    %     fprintf('accuracy is %f, sensitivity is %f, specificity is %f \n',err,sensitivity,specificity)
    %
end
% clear sensitivity1;clear specificity1
% threshold = 0:0.01:1;
% predict_label1 = n_label*ones(size(predict_label));
% for i=1:length(threshold)
%     for j=1:length(p)
%         if(p(j,1)<threshold(i))
%             predict_label1(j) = d_label;
%         end
%     end
%     
%     tp = length(find(testLabels == d_label & predict_label1 == d_label));%number of true positives
%     fn = length(find(testLabels == d_label & predict_label1 == n_label));%number of false negatives
%     
%     sensitivity1(i) = tp/(tp+fn)
%     
%     tn = length(find(testLabels == d_label & predict_label1 == n_label));%number of true positives
%     fp = length(find(testLabels == n_label & predict_label1 == d_label));%number of false negatives
%     specificity1(i) = tn/(tn+fp)
%         err = length(find(testLabels == predict_label1))/length(testLabels)
% 
%     
% end
%%
% features = {'L Hippo Volume','L Hippo M11', 'L Hippo M12', 'L Hippo M22', 'L Hippo Entropy',...
%             'R Hippo Volume','R Hippo M11', 'R Hippo M12', 'R Hippo M22', 'R Hippo Entropy',...
%             'LiL Vent Volume','LiL Vent M11', 'LiL Vent M12', 'LiL Vent M22', 'LiL Vent Entropy',...
%             'RiL Vent Volume','RiL Vent M11', 'RiL Vent M12', 'RiL Vent M22', 'RiL Vent Entropy',...
%             'RL Vent Volume','RL Vent M11', 'RL Vent M12', 'RL Vent M22', 'RL Vent Entropy',...
%             '3rd Vent Volume','3rd Vent M11', '3rd Vent M12', '3rd Vent M22', '3rd Vent Entropy','LC WM Volume', 'RC WM Volume';...
%             1,1,1,1,1,2,2,2,2,2,3,3,3,3,3,4,4,4,4,4,5,5,5,5,5,6,6,6,6,6,7,8};
% % 
% 
% for i=1:size(w,1)
%     w_norm(i,:) = w(i,:)/max(abs(w(i,:)));
% end
% 
% w_norm = abs(w_norm);
% 
% [w_norm_sorted,ind] = sort(mean(w_norm),'descend');
% 
% 
% % figure;
% % n=32;
% % errorb(mean(w_norm(1:n,ind(1:n))),1:n, std(w_norm(1:n,ind(1:n))),'multicolor')
% % text = features(1,ind(1:n));
% % organ = cell2mat(features(2,ind(1:n)));
% % set( gca(), 'XTick',[1:n],'XTickLabel', text )
% % rotateXLabels( gca(), 45 )
% % colors = distinguishable_colors(20);
% % colors = colors([12,11,8,7,20,6,16,15],:);
% % colors = linspecer(8,'qualitative');
% %colors = varycolor(8);
% 
% numWeights = 32;
% mean_w = w_norm_sorted;
% std_w = std(w_norm(1:numWeights,ind(1:numWeights)));
% figure;hold on
% %  plot([32 32],[0 1.2],'k-','LineWidth',.75,'Color',[.3 .3 .3]);
% %  plot([80 80],[0 1.7],'k-','LineWidth',.75,'Color',[.3 .3 .3]);
% x_a = [1:numWeights fliplr(1:numWeights)];
% y_a = [mean_w+std_w fliplr(mean_w-std_w)];
% x_c = x_a;
% y_c = [mean_w+0.5*std_w fliplr(mean_w-0.5*std_w)];
% errorbarwidth = 0.7;
% for i = numWeights:-1:1
%     cur_bar_x_a = [x_a(i) x_a(i) x_a(i)+errorbarwidth x_a(i)+errorbarwidth];
%     cur_bar_x_c = [x_c(i) x_a(i) x_c(i)+errorbarwidth x_c(i)+errorbarwidth];
%     cur_bar_y_a = [mean_w(i)-std_w(i) mean_w(i)+std_w(i) mean_w(i)+std_w(i) mean_w(i)-std_w(i)];
%     cur_bar_y_c = [mean_w(i)-0.5*std_w(i) mean_w(i)+0.5*std_w(i) mean_w(i)+0.5*std_w(i) mean_w(i)-0.5*std_w(i)];
%     patch(cur_bar_y_a,cur_bar_x_a,'r','EdgeAlpha',0,'FaceAlpha',0.4,'FaceColor',[1 0.5 0])
%     patch(cur_bar_y_c,cur_bar_x_c,'b','EdgeAlpha',0,'FaceAlpha',0.4,'FaceColor',[0 1 1])
%     hold on;
% end
% plot(fliplr(mean_w),[numWeights:-1:1],'Color',[1 0.5 0],'LineWidth',2)
% text1 = features(1,ind(1:numWeights));
% 
% set(gca,'tickdir','out', ...
%     'ticklen',[.01 .01],...
%     'YDir','reverse',...
%     'xlim',[-0.05 1.06],...
%     'ylim',[0.5 32.5],...
%     'XAxisLocation','top',...
%     'YAxisLocation','right',...
%     'YtickLabel',text1,...
%     'YTick',[1:32],...
%     'FontSize',10);
% % saveas(gcf,'this_fig_name_','png')
% 
% % saveas(gcf,'this_fig_name_','png')
% 
% % figure;
% % n=32;
% % errorb([1:n],mean(w_norm(1:n,ind(1:n))), std(w_norm(1:n,ind(1:n))), colors,organ,'horizontal');
% % hold on;plot(mean(w_norm(1:n,ind(1:n))),'k')
% % text1 = features(1,ind(1:n));
% % set( gca(), 'XTick',[1:n],'YTick', [0:0.2:1],'XTickLabel', text1 ,'FontSize',13)
% % rotateXLabels( gca(), 45 );xlim([0 32.5]);ylim([-0.05 1.12]);
% %Add legend
% text4legend = {'L Hippocampus','R Hippocampus','L iL Ventricle','R iL Ventricle','R L Ventricle', '3rd Ventricle','L C WM', 'R C WM'};
% colors4legend = colors(1:2:end,:);
% for i=1:length(text4legend)
%     text(29,1.15-i*0.08,text4legend{i},'HorizontalAlignment','left','Color',colors(i,:),'Margin',0.5,'FontSize',13);
% end
% %%
% figure;
% errorb_orig(1:n,d_prime_feat,d_prime_feat_std);
% hold on;
% errorb_orig(1:n,bias_feat+1.5*ones(size(bias_feat)),bias_feat_std,'color','blue');
% hold on;
% set( gca(), 'XTick',[1:n],'XTickLabel', text1 ,'FontSize',10)
% rotateXLabels( gca(), 45 );xlim([0 32.5]);ylim([1 3.2]);
% legend('d prime','bias')
% 
% figure;
% errorb_orig(1:n,err_feat,err_feat_std);
% hold on;
% errorb_orig(1:n,sensitivity_feat,sensitivity_feat_std,'color','blue');
% hold on;
% set( gca(), 'XTick',[1:n],'XTickLabel', text1 ,'FontSize',10)
% rotateXLabels( gca(), 45 );xlim([0 32.5]);ylim([0 1]);
% legend('d prime','bias')
% 
% 
% %%
% hold on;plot(1:n,fliplr(d_prime_feat)-ones(1,32),'b.',1:n,fliplr(err_feat),'r.',1:n,fliplr(sensitivity_feat),'g.',1:n,fliplr(bias_feat),'k.')
% grid on
% legend('d prime - 1','accuracy','sensitivity','bias')
% hold on;errorb(1:n,fliplr(d_prime_feat)-ones(1,32),fliplr(d_prime_feat_std))
% 
% figure;subplot(221);hist(d_prime(d_prime~=Inf));title('d prime')
% subplot(222);hist(c(d_prime~=Inf & c~=Inf));title('bias')
% subplot(223);hist(sensitivity);title('sensitivity');
% subplot(224); hist(err);title('accuracy')