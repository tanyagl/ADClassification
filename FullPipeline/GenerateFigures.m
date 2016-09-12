%%generate figure that compares the sensitivity % of my method to other
%methods according to the paper
%Cuingnet R, Gerardin E, Tessieras J, Auzias G, Lehéricy S, Habert MO, Chupin M, Benali H, Colliot O; Automatic classi?cation of patients with Alzheimer's disease from structural MRI: A comparison of ten methods using the ADNI database. Neuroimage 2011 May 15;56(2):766-81. doi: 10.1016/j.neuroimage.2010.06.013.
spe_mine = [88.89, 93.83, 100]; %75.68 CNMCIc
spe_cnad = [95,98,89,88,95,95,91,81,90,91,91,86,91,91,93,90,93,93,89,81,86,91,90,90,94,80,77,84];%CN vs AD classification sensitivity
spe_mcic = [96,91,96,94,95,96,88,99,85,93,86,93,85,90,80,91,95,94,81,85,78,78,96,93,94,74,73,88];%CN vs MCIc classification sensitivity
spe_mcicnc = [100,100,100,100,70,100,100,100,78,100,91,79,70,72,100,100,100,100,67,78,82,72,91,85,82,61,69,100];%MCInc vs MCIc classification sensitivity


acc_mine = [80.53,88.13,64.7];
%mine = [79.2453,71.4286,46.4286];
sen_mine = [70.59,75.68,0]; %75.68 CNMCIc 72.97
sen_cnad = [81,68,72,65,71,65,65,59,69,71,75,75,72,71,78,81,75,74,82,69,66,72,74,79,69,63,71,69];%CN vs AD classification sensitivity
sen_mcic = [57,49,32,41,54,41,32,22,73,65,59,49,62,57,65,54,68,59,49,51,49,59,54,57,65,73,70,57];%CN vs MCIc classification sensitivity
sen_mcicnc = [0,0,0,0,43,0,0,0,57,0,22,51,35,41,0,0,0,0,62,54,32,51,32,27,24,70,62,0];%MCInc vs MCIc classification sensitivity


% best_sen = [19,9/26,19/27] = [82,73,62];
% best_spe = [89,85/74,67/69]
% 
% 9,22,26,27
ppv_mine = [84.21 ,84.85 ,0];
dprime_mine = [1.76,2.2363 0];
c_mine = [0.33,0.4223 0];
ppv_cnad = [93,96,84,81,92,92,86,73,85,87,88,82,88,87,90,87,89,89,86,76,80,88,86,87,90,73,72,78];
ppv_mcic = [88,72,80,75,83,83,55,89,69,80,67,75,66,72,60,74,86,81,55,61,50,55,87,78,83,56,54,68];
ppv_mcicnc = [0 0 0 0 44 0 0 0 58 0 57 58 39 44 0 0 0 0 51 57 50 50 67 50 43 50 52 0];
npv_mine = [78.26 ,89.41 ,64.42];
npv_cnad = [86 78 79 75 79 76 76 70 78 79 81 80 80 79 83 85 82 81 86 76 85 80 80 84 78 72 76 76];
npv_mcic = [83 80 76 78 82 78 74 73 87 85 82 80 83 82 83 81 87 84 78 79 77 81 82 82 85 86 84 82];
npv_mcicnc = [64 64 64 64 69 64 64 64 78 64 68 75 66 69 64 64 64 64 76 75 69 73 71 68 66 79 77 64];
method_names = {'Voxel-Direct-D-gm','Voxel-Direct-D-all','Voxel-Direct-S-gm','Voxel-Direct-S-all','Voxel-Direct-VOI-D-gm','Voxel-Direct-VOI-D-all','Voxel-Direct-VOI-S-gm','Voxel-Direct-VOI-S-all',...
    'Voxel-STAND-D-gm','Voxel-STAND-D-all','Voxel-STAND-S-gm','Voxel-STAND-S-all','Voxel-STAND-Sc-gm','Voxel-STAND-Sc-all',...
    'Voxel-Atlas-D-gm','Voxel-Atlas-D-all','Voxel-Atlas-S-gm','Voxel-Atlas-S-all',...
    'Voxel-COMPARE-D-gm','Voxel-COMPARE-D-all','Voxel-COMPARE-S-gm','Voxel-COMPARE-S-all',...
    'Thickness-Direct','Thickness-Atlas','Thickness-ROI',...
    'Hippo-Volume-F','Hippo-Volume-S','Hippo-Shape','Our Method'};


dprime_cnad = norminv(sen_cnad/100)-norminv(1-ppv_cnad/100);
dprime_mcic = norminv(sen_mcic/100)-norminv(1-ppv_mcic/100);
dprime_mcicnc = norminv(sen_mcicnc/100)-norminv(1-ppv_mcicnc/100);

    c_cnad = -(norminv(sen_cnad/100)+norminv(1-ppv_cnad/100))/2 ;  %bias
        c_mcic = -(norminv(sen_mcic/100)+norminv(1-ppv_mcic/100))/2;   %bias
    c_mcicnc = -(norminv(sen_mcicnc/100)+norminv(1-ppv_mcicnc/100))/2 ;  %bias

% figure
% for i=1:length(ppv_cnad)
%     plot([1,2,3],[ppv_cnad(i),ppv_mcic(i), ppv_mcicnc(i)]);hold on;
% end
% plot([1,2,3],[ppv_mine(1),ppv_mine(2),ppv_mine(3)],'r')
% figure
% for i=1:length(npv_mcic)
%     plot([1,2,3],[npv_cnad(i),npv_mcic(i), npv_mcicnc(i)]);hold on;
% end
% plot([1,2,3],[npv_mine(1),npv_mine(2),npv_mine(3)],'r')
% 
% figure
% for i=1:length(sen_cnad)
%     plot([1,2],[sen_cnad(i),spe_cnad(i)]);hold on;
% end
% plot([1,2],[sen_mine(1),spe_mine(1)],'r')
% figure
% for i=1:length(sen_mcic)
%     plot([1,2],[sen_mcic(i),spe_mcic(i)]);hold on;
% end
% plot([1,2],[sen_mine(2),spe_mine(2)],'r')
% figure
% for i=1:length(sen_mcicnc)
%     plot([1,2],[sen_mcicnc(i),spe_mcicnc(i)]);hold on;
% end
% plot([1,2],[sen_mine(3),spe_mine(3)],'r')
% figure
% for i=1:length(sen_cnad)
%     plot([1,2],[sen_cnad(i),spe_cnad(i)]);hold on;
% end
% plot([1,2],[sen_mine(1),spe_mine(1)],'r')
% colors = distinguishable_colors(length(cnad)+1);
% avg_val = mean([spe_cnad;spe_mcic;spe_mcicnc]);
% [avg_sorted,avg_ind] = sort(avg_val);
% colors = (rand(1,length(spe_cnad)+5))'*[1 1 1];
% colors = sort(colors);
% colors = colors(5:33,:);
% new_colors = distinguishable_colors(17);
% new_colors = new_colors(3:end,:);
%newcolors = [colors(1:14,:);[1 0.5 0]; colors(16,:);[1 0 0.5];colors(18,:);[0 0 1];colors(20:25,:);[0 1 0];[0 0.9 0.5];colors(28,:)];
%colors = [colors;[1 0 0]];
figure;
for i = [1:14,16,18,20:25,28]
    combine(i,:) = [spe_cnad(avg_ind(i)),spe_mcic(avg_ind(i)),spe_mcicnc(avg_ind(i))];
   h = prettyplot([1,2,3],combine(i,:),'-o','LineSmoothing','on','color',colors(i,:),'markerfacecolor',colors(i,:),'markeredgecolor',colors(i,:),'markersize',8);hold on;
%     h = plot([1,2,3],combine(i,:),'o','markerfacecolor',colors(i,:),'markeredgecolor',colors(i,:),'markersize',8);
    uistack(h,'bottom');hold on;
end

for i = [15,17,19,26,27]
    combine(i,:) = [spe_cnad((i)),spe_mcic((i)),spe_mcicnc((i))];
  h =  prettyplot([1,2,3],combine(i,:),'-o','LineSmoothing','on','color',newcolors(i,:),'markerfacecolor',newcolors(i,:),'markeredgecolor',newcolors(i,:),'markersize',8);hold on;
  uistack(h,'top')

end
h=prettyplot([1,2,3],spe_mine,'-o','LineSmoothing','on','color','r','LineWidth',2.8,'markerfacecolor','r','markeredgecolor','r','markersize',9);
uistack(h,'top');hold on;
    set(gca, 'XTick', [1,2,3]);
set(gca,'XTickLabel',{'NC vs AD','NC vs MCIc','MCIc vs MCInc'},'FontSize', 12,'fontweight','bold');xlim([0.8,3.2]);
 set(gca,'tickdir','out', 'ticklen',[.01 .01],'FontSize',16,'fontweight','bold', ...
               'PlotBoxAspectRatio',[0.5 0.7 1], 'YTick', [60 80 100]);
          
           %%
           figure;
for i = [1:14,16,18,20:25,28]
    combine(i,:) = [sen_cnad(avg_ind(i)),sen_mcic(avg_ind(i)),sen_mcicnc(avg_ind(i))];
   h = prettyplot([1,2,3],combine(i,:),'-o','LineSmoothing','on','color',colors(i,:),'markerfacecolor',colors(i,:),'markeredgecolor',colors(i,:),'markersize',8);hold on;
%     h = plot([1,2,3],combine(i,:),'o','markerfacecolor',colors(i,:),'markeredgecolor',colors(i,:),'markersize',8);
    uistack(h,'bottom');hold on;
end

for i = [15,17,19,26,27]
    combine(i,:) = [sen_cnad((i)),sen_mcic((i)),sen_mcicnc((i))];
  h =  prettyplot([1,2,3],combine(i,:),'-o','LineSmoothing','on','color',newcolors(i,:),'markerfacecolor',newcolors(i,:),'markeredgecolor',newcolors(i,:),'markersize',8);hold on;
  uistack(h,'top')

end
h=prettyplot([1,2,3],sen_mine,'-o','LineSmoothing','on','color','r','LineWidth',2.8,'markerfacecolor','r','markeredgecolor','r','markersize',9);
uistack(h,'top');hold on;
    set(gca, 'XTick', [1,2,3]);
set(gca,'XTickLabel',{'NC vs AD','NC vs MCIc','MCIc vs MCInc'},'FontSize', 12,'fontweight','bold');xlim([0.8,3.2]);ylim([0 85]);
 set(gca,'tickdir','out', 'ticklen',[.01 .01],'FontSize',16,'fontweight','bold', ...
               'PlotBoxAspectRatio',[0.5 0.7 1], 'YTick', [0 60 80]);
           %%
%            avg_val = mean([sen_cnad;sen_mcic;sen_mcicnc]);
% [avg_sorted,avg_ind] = sort(avg_val);
% colors = (rand(1,length(sen_cnad)+5))'*[1 1 1];
% colors = sort(colors);
% colors = colors(5:33,:);
% % new_colors = distinguishable_colors(17);
% % new_colors = new_colors(3:end,:);
% newcolors = [colors(1:14,:);[1 0.5 0]; colors(16,:);[1 0 0.5];colors(18,:);[0 0 1];colors(20:25,:);[0 1 0];[0 0.9 0.5];colors(28,:)];
% %colors = [colors;[1 0 0]];
figure;
for i = [1:14,16,18,20:25,28]
    combine(i,:) = [dprime_cnad(avg_ind(i)),dprime_mcic(avg_ind(i)),dprime_mcicnc(avg_ind(i))];
   h = prettyplot([1,2,3],combine(i,:),'-o','LineSmoothing','on','color',colors(i,:),'markerfacecolor',colors(i,:),'markeredgecolor',colors(i,:),'markersize',8);hold on;
%     h = plot([1,2,3],combine(i,:),'o','markerfacecolor',colors(i,:),'markeredgecolor',colors(i,:),'markersize',8);
    uistack(h,'bottom');hold on;
end

for i = [15,17,19,26,27]
    combine(i,:) = [dprime_cnad((i)),dprime_mcic((i)),dprime_mcicnc((i))];
   h =  prettyplot([1,2,3],combine(i,:),'-o','LineSmoothing','on','color',newcolors(i,:),'markerfacecolor',newcolors(i,:),'markeredgecolor',newcolors(i,:),'markersize',8);hold on;
  uistack(h,'top')
end
h=prettyplot([1,2,3],dprime_mine,'-o','LineSmoothing','on','color','r','LineWidth',2.8,'markerfacecolor','r','markeredgecolor','r','markersize',9);
uistack(h,'top');hold on;
    set(gca, 'XTick', [1,2,3]);
set(gca,'XTickLabel',{'NC vs AD','NC vs MCIc','MCIc vs MCInc'},'FontSize', 12,'fontweight','bold');xlim([0.8,3.2]);
 set(gca,'tickdir','out', 'ticklen',[.01 .01],'FontSize',16,'fontweight','bold', ...
               'PlotBoxAspectRatio',[0.5 0.7 1], 'YTick',[-1 0 1 2]);

           %%
           figure;
for i = [1:14,16,18,20:25,28]
    combine(i,:) = [c_cnad(avg_ind(i)),c_mcic(avg_ind(i)),c_mcicnc(avg_ind(i))];
   h = prettyplot([1,2,3],combine(i,:),'-o','LineSmoothing','on','color',colors(i,:),'markerfacecolor',colors(i,:),'markeredgecolor',colors(i,:),'markersize',8);hold on;
%     h = plot([1,2,3],combine(i,:),'o','markerfacecolor',colors(i,:),'markeredgecolor',colors(i,:),'markersize',8);
    uistack(h,'bottom');hold on;
end

for i = [15,17,19,26,27]
    combine(i,:) = [c_cnad((i)),c_mcic((i)),c_mcicnc((i))];
   h =  prettyplot([1,2,3],combine(i,:),'-o','LineSmoothing','on','color',newcolors(i,:),'markerfacecolor',newcolors(i,:),'markeredgecolor',newcolors(i,:),'markersize',8);hold on;
  uistack(h,'top')
end
h=prettyplot([1,2,3],c_mine,'-o','LineSmoothing','on','color','r','LineWidth',2.8,'markerfacecolor','r','markeredgecolor','r','markersize',9);
uistack(h,'top');hold on;
    set(gca, 'XTick', [1,2,3]);
set(gca,'XTickLabel',{'NC vs AD','NC vs MCIc','MCIc vs MCInc'},'FontSize', 12,'fontweight','bold');xlim([0.8,3.2]);
 set(gca,'tickdir','out', 'ticklen',[.01 .01],'FontSize',16,'fontweight','bold', ...
               'PlotBoxAspectRatio',[0.5 0.7 1], 'YTick' , [-0.2 0 0.4 0.8]);
%%
%                    %%
%            avg_val = mean([ppv_cnad;ppv_mcic;ppv_mcicnc]);
% [avg_sorted,avg_ind] = sort(avg_val);
% colors = (rand(1,length(ppv_cnad)+5))'*[1 1 1];
% colors = sort(colors);
% colors = colors(5:33,:);
% % new_colors = distinguishable_colors(17);
% % new_colors = new_colors(3:end,:);
% newcolors = [colors(1:14,:);[1 0.5 0]; colors(16,:);[1 0 0.5];colors(18,:);[0 0 1];colors(20:25,:);[0 1 0];[0 0.9 0.5];colors(28,:)];
% %colors = [colors;[1 0 0]];
figure;
for i = [1:14,16,18,20:25,28]
    combine(i,:) = [ppv_cnad(avg_ind(i)),ppv_mcic(avg_ind(i)),ppv_mcicnc(avg_ind(i))];
  h=  prettyplot([1,2,3],combine(i,:),'o-','LineSmoothing','on','color',colors(i,:),...'marker','o','LineSmoothing','on', ...
        'markerfacecolor',colors(i,:),'markeredgecolor',colors(i,:),'markersize',8);uistack(h,'bottom');
hold on;
end

for i = [15,17,19,26,27]
    combine(i,:) = [ppv_cnad((i)),ppv_mcic((i)),ppv_mcicnc((i))];
   h= prettyplot([1,2,3],combine(i,:),'o-','LineSmoothing','on','color',newcolors(i,:),'LineWidth',1.0, ...'marker','o','LineSmoothing','on', ...
        'markerfacecolor',newcolors(i,:),'markeredgecolor',newcolors(i,:),'markersize',8);uistack(h,'top');hold on;

end
h=prettyplot([1,2,3],ppv_mine,'-o','LineSmoothing','on','color','r','LineWidth',2.8,'markerfacecolor','r','markeredgecolor','r','markersize',9);
    set(gca, 'XTick', [1,2,3]);uistack(h,'top');
set(gca,'XTickLabel',{'NC vs AD','NC vs MCIc','MCIc vs MCInc'},'FontSize', 12,'fontweight','bold');xlim([0.8,3.2]);
 set(gca,'tickdir','out', 'ticklen',[.01 .01],'FontSize',16,'fontweight','bold', ...
               'PlotBoxAspectRatio',[0.5 0.7 1],'YTick',[0 50 80 100]);uistack(h,'top');hold on;

           %%
           %%
%                    %%
%            avg_val = mean([ppv_cnad;ppv_mcic;ppv_mcicnc]);
% [avg_sorted,avg_ind] = sort(avg_val);
% colors = (rand(1,length(ppv_cnad)+5))'*[1 1 1];
% colors = sort(colors);
% colors = colors(5:33,:);
% % new_colors = distinguishable_colors(17);
% % new_colors = new_colors(3:end,:);
% newcolors = [colors(1:14,:);[1 0.5 0]; colors(16,:);[1 0 0.5];colors(18,:);[0 0 1];colors(20:25,:);[0 1 0];[0 0.9 0.5];colors(28,:)];
% %colors = [colors;[1 0 0]];
figure;
for i = [1:14,16,18,20:25,28]
    combine(i,:) = [npv_cnad(avg_ind(i)),npv_mcic(avg_ind(i)),npv_mcicnc(avg_ind(i))];
  h=  prettyplot([1,2,3],combine(i,:),'o-','LineSmoothing','on','color',colors(i,:),...'marker','o','LineSmoothing','on', ...
        'markerfacecolor',colors(i,:),'markeredgecolor',colors(i,:),'markersize',8);uistack(h,'bottom');
hold on;
end

for i = [15,17,19,26,27]
    combine(i,:) = [npv_cnad((i)),npv_mcic((i)),npv_mcicnc((i))];
   h= prettyplot([1,2,3],combine(i,:),'o-','LineSmoothing','on','color',newcolors(i,:),'LineWidth',1.0, ...'marker','o','LineSmoothing','on', ...
        'markerfacecolor',newcolors(i,:),'markeredgecolor',newcolors(i,:),'markersize',8);uistack(h,'top');hold on;

end
h=prettyplot([1,2,3],npv_mine,'-o','LineSmoothing','on','color','r','LineWidth',2.8,'markerfacecolor','r','markeredgecolor','r','markersize',9);
    set(gca, 'XTick', [1,2,3]);uistack(h,'top');
set(gca,'XTickLabel',{'NC vs AD','NC vs MCIc','MCIc vs MCInc'},'FontSize', 12,'fontweight','bold');xlim([0.8,3.2]);
 set(gca,'tickdir','out', 'ticklen',[.01 .01],'FontSize',16,'fontweight','bold', ...
               'PlotBoxAspectRatio',[0.5 0.7 1],'YTick',[60 70 80 90]);uistack(h,'top');hold on;

                   %%
           avg_val = mean([npv_cnad;npv_mcic;npv_mcicnc]);
[avg_sorted,avg_ind] = sort(avg_val);
colors = (rand(1,length(npv_cnad)+5))'*[1 1 1];
colors = sort(colors);
colors = colors(5:33,:);
% new_colors = distinguishable_colors(17);
% new_colors = new_colors(3:end,:);
newcolors = [colors(1:14,:);[1 0.5 0]; colors(16,:);[1 0 0.5];colors(18,:);[0 0 1];colors(20:25,:);[0 1 0];[0 0.9 0.5];colors(28,:)];
%colors = [colors;[1 0 0]];
figure;
for i = [1:14,16,18,20:25,28]
    combine(i,:) = [npv_cnad(avg_ind(i)),npv_mcic(avg_ind(i)),npv_mcicnc(avg_ind(i))];
    plot([1,2,3],combine(i,:),'o-','LineSmoothing','on','color',colors(i,:),...'marker','o','LineSmoothing','on', ...
        'markerfacecolor',colors(i,:),'markeredgecolor','w','markersize',8);hold on;
end

for i = [15,17,19,26,27]
    combine(i,:) = [npv_cnad((i)),npv_mcic((i)),npv_mcicnc((i))];
    plot([1,2,3],combine(i,:),'o-','LineSmoothing','on','color',newcolors(i,:),'LineWidth',1.0, ...'marker','o','LineSmoothing','on', ...
        'markerfacecolor',newcolors(i,:),'markeredgecolor','w','markersize',9);hold on;
end
plot([1,2,3],npv_mine,'LineSmoothing','on','color','r','LineWidth',2.3);
plot([1,2,3],npv_mine,'o','color','r','LineWidth',1.0,...'marker','o','LineSmoothing','on', ...
        'markerfacecolor','r','markeredgecolor','w','markersize',10);
    set(gca, 'XTick', [1,2,3]);
set(gca,'XTickLabel',{'NC vs AD','NC vs MCIc','MCIc vs MCInc'},'FontSize', 12,'fontweight','bold');xlim([0.8,3.2]);
 set(gca,'tickdir','out', 'ticklen',[.01 .01],'FontSize',16,'fontweight','bold', ...
               'PlotBoxAspectRatio',[.5 1 1]);
           %%
% %[legh,objh,outh,outm] = legend('our method');
% h=legend(method_names);
% set(h,'color','w')

%%generate figure that compares the sensitivity % of my method to other
%methods according to the paper
%Cuingnet R, Gerardin E, Tessieras J, Auzias G, Lehéricy S, Habert MO, Chupin M, Benali H, Colliot O; Automatic classi?cation of patients with Alzheimer's disease from structural MRI: A comparison of ten methods using the ADNI database. Neuroimage 2011 May 15;56(2):766-81. doi: 10.1016/j.neuroimage.2010.06.013.
mine = [75.86, 65,72.22]; %75.68 CNMCIc
cnad = [95,98,89,88,95,95,91,81,90,91,91,86,91,91,93,90,93,93,89,81,86,91,90,90,94,80,77,84];%CN vs AD classification sensitivity
mcic = [96,91,96,94,95,96,88,99,85,93,86,93,85,90,80,91,95,94,81,85,78,78,96,93,94,74,73,88];%CN vs MCIc classification sensitivity
mcicnc = [100,100,100,100,70,100,100,100,78,100,91,79,70,72,100,100,100,100,67,78,82,72,91,85,82,61,69,100];%MCInc vs MCIc classification sensitivity

%mine = [79.2453,71.4286,46.4286];
% mine = [70.59,75.68,29.73]; %75.68 CNMCIc
% cnad = [81,68,72,65,71,65,65,59,69,71,75,75,72,71,78,81,75,74,82,69,66,72,74,79,69,63,71,69];%CN vs AD classification sensitivity
% mcic = [57,49,32,41,54,41,32,22,73,65,59,49,62,57,65,54,68,59,49,51,49,59,54,57,65,73,70,57];%CN vs MCIc classification sensitivity
% mcicnc = [0,0,0,0,43,0,0,0,57,0,22,51,35,41,0,0,0,0,62,54,32,51,32,27,24,70,62,0];%MCInc vs MCIc classification sensitivity
method_names = {'Voxel-Direct-D-gm','Voxel-Direct-D-all','Voxel-Direct-S-gm','Voxel-Direct-S-all','Voxel-Direct-VOI-D-gm','Voxel-Direct-VOI-D-all','Voxel-Direct-VOI-S-gm','Voxel-Direct-VOI-S-all',...
    'Voxel-STAND-D-gm','Voxel-STAND-D-all','Voxel-STAND-S-gm','Voxel-STAND-S-all','Voxel-STAND-Sc-gm','Voxel-STAND-Sc-all',...
    'Voxel-Atlas-D-gm','Voxel-Atlas-D-all','Voxel-Atlas-S-gm','Voxel-Atlas-S-all',...
    'Voxel-COMPARE-D-gm','Voxel-COMPARE-D-all','Voxel-COMPARE-S-gm','Voxel-COMPARE-S-all',...
    'Thickness-Direct','Thickness-Atlas','Thickness-ROI',...
    'Hippo-Volume-F','Hippo-Volume-S','Hippo-Shape','Our Method'};
    
%colors = distinguishable_colors(length(cnad)+1);
avg_val = mean([cnad;mcic;mcicnc]);
[avg_sorted,avg_ind] = sort(avg_val);
colors = (rand(1,length(cnad)+5))'*[1 1 1];
colors = sort(colors);
colors = colors(5:33,:);
% new_colors = distinguishable_colors(17);
% new_colors = new_colors(3:end,:);
newcolors = [colors(1:14,:);[1 0.5 0]; colors(16,:);[1 0 0.5];colors(18,:);[0 0 1];colors(20:25,:);[0 1 0];[0 0.9 0.5];colors(28,:)];
%colors = [colors;[1 0 0]];
figure;
for i = [1:14,16,18,20:25,28]
    combine(i,:) = [cnad(avg_ind(i)),mcic(avg_ind(i)),mcicnc(avg_ind(i))];
    plot([1,2,3],combine(i,:),'o-','LineSmoothing','on','color',colors(i,:),...'marker','o','LineSmoothing','on', ...
        'markerfacecolor',colors(i,:),'markeredgecolor','w','markersize',8);hold on;
end

for i = [15,17,19,26,27]
    combine(i,:) = [cnad((i)),mcic((i)),mcicnc((i))];
    plot([1,2,3],combine(i,:),'o-','LineSmoothing','on','color',newcolors(i,:),'LineWidth',1.0, ...'marker','o','LineSmoothing','on', ...
        'markerfacecolor',newcolors(i,:),'markeredgecolor','w','markersize',9);hold on;
end
plot([1,2,3],mine,'LineSmoothing','on','color','r','LineWidth',2.3);
plot([1,2,3],mine,'o','color','r','LineWidth',1.0,...'marker','o','LineSmoothing','on', ...
        'markerfacecolor','r','markeredgecolor','w','markersize',10);
    set(gca, 'XTick', [1,2,3]);
set(gca,'XTickLabel',{'NC vs AD','NC vs MCIc','MCIc vs MCInc'},'FontSize', 12,'fontweight','bold');xlim([0.8,3.2]);
 set(gca,'tickdir','out', 'ticklen',[.01 .01],'FontSize',16,'fontweight','bold', ...
               'PlotBoxAspectRatio',[.5 1 1]);
% %[legh,objh,outh,outm] = legend('our method');
% h=legend(method_names);
% set(h,'color','w')

%% generate figure with an ROI as a point cloud (blue for NC and red for AD)
cd C:\MyWork\Stanford\data\ten_methods\output\PaperData
load TrainingTestingFullData.mat

for i=1:8
    AllData{i} = [AllTrainingData{i}, AllTestingData{i}];
end

roi = 5;
all_sbj_rois = AllData{roi};
clear cur_prj prj0 prj1 prj2
roi_name = {'17_Left-Hippocampus',...
    '53_Right-Hippocampus',...
    '5_Left-Inf-Lat-Vent',...
    '44_Right-Inf-Lat-Vent',...
    '43_Right-Lateral-Ventricle',...
    '14_3rd-Ventricle',...
    '2_Left-Cerebral-White-Matter',...
    '41_Right-Cerebral-White-Matter'};

for i=1:length(all_sbj_rois)
    all_sbj_rois(i).surface_coords =  GetSurfaceCoords(all_sbj_rois(i).coords);
    all_sbj_rois(i).normalized_surface_coords = all_sbj_rois(i).surface_coords - repmat(calcCentroid(all_sbj_rois(i).surface_coords),[length(all_sbj_rois(i).surface_coords) 1]);
    [ all_sbj_rois(i).PCAed_surface_coords,~,~ ] = nipals(all_sbj_rois(i).normalized_surface_coords,3);
    
end
%plot just two subjects
figure;plot3(all_sbj_rois(5).PCAed_surface_coords(:,1),all_sbj_rois(5).PCAed_surface_coords(:,2),all_sbj_rois(5).PCAed_surface_coords(:,3),'.b')
hold on;plot3(all_sbj_rois(115).PCAed_surface_coords(:,1),all_sbj_rois(115).PCAed_surface_coords(:,2),all_sbj_rois(115).PCAed_surface_coords(:,3),'.r')
%plot just two subjects
figure;plot3(all_sbj_rois(1).PCAed_coords(:,1),all_sbj_rois(1).PCAed_coords(:,2),all_sbj_rois(1).PCAed_coords(:,3),'.b')
hold on;plot3(all_sbj_rois(120).PCAed_coords(:,1),all_sbj_rois(120).PCAed_coords(:,2),all_sbj_rois(120).PCAed_coords(:,3),'.r')
legend('NC','AD')

colors = distinguishable_colors(4);
figure;title('subject rois clustered according to diagnosis label')
for i=1:length(all_sbj_rois)
    switch all_sbj_rois(i).label
        case 0
            color = 'b';
        case 1
            color = 'r';
        case 2
            color = colors(3,:);
        case 3
            color = colors(4,:);
    end
    if(all_sbj_rois(i).label ~= 2 & all_sbj_rois(i).label ~= 3)
        plot3(all_sbj_rois(i).PCAed_surface_coords(:,1),all_sbj_rois(i).PCAed_surface_coords(:,2),all_sbj_rois(i).PCAed_surface_coords(:,3),'.','color',color);hold on;
    end
end
figure;plot3(all_sbj_rois(5).PCAed_coords(:,1),all_sbj_rois(5).PCAed_coords(:,2),all_sbj_rois(5).PCAed_coords(:,3),'.g')
hold on;plot3(all_sbj_rois(2).PCAed_coords(:,1),all_sbj_rois(2).PCAed_coords(:,2),all_sbj_rois(2).PCAed_coords(:,3),'.r')


%% Visualize projections of the different structures for NC/MCI/AD (summed
% up and normalized

cd C:\MyWork\Stanford\data\ten_methods\output\PaperData
load TrainingTestingFullData.mat

for i=1:8
    AllData{i} = [AllTrainingData{i}, AllTestingData{i}];
end

roi = 7;
all_sbj_rois = AllROIs{roi};%Data{roi};
clear cur_prj prj0 prj1 prj2
roi_name = {'17_Left-Hippocampus',...
    '53_Right-Hippocampus',...
    '5_Left-Inf-Lat-Vent',...
    '44_Right-Inf-Lat-Vent',...
    '43_Right-Lateral-Ventricle',...
    '14_3rd-Ventricle',...
    '18_left-Amygdala',...
    '54_right-Amygdala',...
    '2_Left-Cerebral-White-Matter',...
    '41_Right-Cerebral-White-Matter'};
figure;suptitle(sprintf('Canonical view of %s\n',roi_name{roi}));set(gcf,'color','w');
max_sizeX = -1;
max_sizeY = -1;
for i=1:length(all_sbj_rois)
    max_sizeX = max(size(all_sbj_rois(i).prj.p12{1},1),max_sizeX);
    max_sizeY = max(size(all_sbj_rois(i).prj.p12{1},2),max_sizeY);
end
if ~mod(max_sizeX,2)
    max_sizeX = max_sizeX + 1; %round to nearest odd number
end
if ~mod(max_sizeY,2)
    max_sizeY = max_sizeY + 1;
end
cnt0=0;cnt1=0;cnt2=0;cnt3=0;s0=0;s1=0;s2=0;s3=0;
sum0=zeros(max_sizeX,max_sizeY);sum1=zeros(max_sizeX,max_sizeY);sum2=zeros(max_sizeX,max_sizeY);sum3=zeros(max_sizeX,max_sizeY);
for i=1:length(all_sbj_rois)
    switch all_sbj_rois(i).label
        case 0 %CN
            cnt0=cnt0+1;
            cur_prj = all_sbj_rois(1,i).prj.p12{1};
            [prj0(cnt0,:),sum0] = PadProjection(cur_prj, max_sizeX, max_sizeY,sum0);
        case 1 %AD
            cnt1=cnt1+1;
            cur_prj = all_sbj_rois(1,i).prj.p12{1};
            [prj1(cnt1,:),sum1] = PadProjection(cur_prj, max_sizeX, max_sizeY,sum1);
        case 2 %MCIc
            cnt2=cnt2+1;
            cur_prj = all_sbj_rois(1,i).prj.p12{1};
            [prj2(cnt2,:),sum2] = PadProjection(cur_prj, max_sizeX, max_sizeY,sum2);
        case 3 %MCInc
            cnt3=cnt3+1;
            cur_prj = all_sbj_rois(1,i).prj.p12{1};
            [prj3(cnt3,:),sum3] = PadProjection(cur_prj, max_sizeX, max_sizeY,sum3);
    end
end
sum0 = sum0./cnt0;
sum1 = sum1./cnt1;
sum2 = sum2./cnt2;
sum3 = sum3./cnt3;

max_val = max([max(max(sum0)),max(max(sum1)),max(max(sum2)),max(max(sum3))]);
subplot(1,4,1);imagesc(sum0,[0 max_val]);colormap gray;axis equal;
title('NC');xlim([0 max_sizeY]);ylim([0 max_sizeX]);set(gca,'xcolor','w','ycolor','w','xtick',[],'ytick',[])
subplot(1,4,2);imagesc(sum1,[0 max_val]);colormap gray;axis equal;
title('AD');xlim([0 max_sizeY]);ylim([0 max_sizeX]);set(gca,'xcolor','w','ycolor','w','xtick',[],'ytick',[])
subplot(1,4,3);imagesc(sum2,[0 max_val]);colormap gray;axis equal;
title('MCIc');xlim([0 max_sizeY]);ylim([0 max_sizeX]);set(gca,'xcolor','w','ycolor','w','xtick',[],'ytick',[])
subplot(1,4,4);imagesc(sum3,[0 max_val]);colormap gray;axis equal;
title('MCInc');xlim([0 max_sizeY]);ylim([0 max_sizeX]);set(gca,'xcolor','w','ycolor','w','xtick',[],'ytick',[])


%% Visualize features

% cd C:\MyWork\Stanford\Documents\ad_paper_data_figures\PaperData
% load TrainingTestingDataAndLabels.mat
% data = [TrainingData; TestingData];
% labels = [TrainingLabels; TestingLabels];
[num_subjects,num_features] = size(data);

l = 5;
k = ceil(num_features/l);

x0 = ones(size(data(labels == 0,:),1),1);
x1 = ones(size(data(labels == 1,:),1),1);
x2 = ones(size(data(labels == 2,:),1),1);
x3 = ones(size(data(labels == 3,:),1),1);

figure;
for i=1:num_features
    subplot(k,l,i);plot(0*x0,data(labels==0,i),'*g');hold on; set(gca, 'XTick', [],'YTick', []);
    plot(0.2*x1,data(labels ==1,i),'*r');
    plot(0.13*x2,data(labels ==2,i),'*b');
    plot(0.06*x3,data(labels ==3,i),'*c');
    xlim([-0.01,0.21]);ylim([min(data(:,i)) max(data(:,i))]);%title(num2str(w(i)));hold off;
    
end
%% VISUALIZE 4 FEATURES ONLY WITH NICE ERRORBARS

cd C:\MyWork\Stanford\Documents\ad_paper_data_figures\PaperData
load TrainingTestingDataAndLabels.mat
load C:\MyWork\Stanford\Documents\ad_paper_data_figures\PaperData\ADNC\ADNC_ind
data = [TrainingData; TestingData];
labels = [TrainingLabels; TestingLabels];
[num_subjects,num_features] = size(data);

x0 = ones(size(data(labels == 0,:),1),1);
x1 = ones(size(data(labels == 1,:),1),1);
x2 = ones(size(data(labels == 2,:),1),1);
x3 = ones(size(data(labels == 3,:),1),1);

figure;
for i=1:num_features
    subplot(k,l,i);plot(0*x0,data(labels==0,i),'*g');hold on; set(gca, 'XTick', [],'YTick', []);
    plot(0.2*x1,data(labels ==1,i),'*r');
    plot(0.13*x2,data(labels ==2,i),'*b');
    plot(0.06*x3,data(labels ==3,i),'*c');
    xlim([-0.01,0.21]);ylim([min(data(:,i)) max(data(:,i))]);%title(num2str(w(i)));hold off;
    
end
%%
reduced_data = data(:,ind([1,2,3,28]));
numClasses = 4;
new_color = [34,139,34]/255;	
line_color = [152,251,152]/255;
x_a = [1:numClasses fliplr(1:numClasses)];
x_c = x_a;
errorbarwidth = 0.7;
colors(1,:)= [26,160,65]/255;
colors(2,:) = [44,123,182]/255;
colors(3,:) = [255,159,0]/255;
colors(4,:) = [215,48,39]/255;

figure;
  text4legend = {'NC','MCInc','MCIc','AD'};
colors4legend = colors;
for i=1:length(text4legend)
    text(29,1.0-i*0.055,text4legend{i},'HorizontalAlignment','left','Color',colors(i,:),'Margin',0.5,'FontSize',13);
end


for i=1:4 %feature number
    subplottight(2,2,i)
    feat_mean = abs([mean(reduced_data(labels == 0,i)),mean(reduced_data(labels == 3,i)),mean(reduced_data(labels == 2,i)),mean(reduced_data(labels == 1,i))]);
    feat_std = [std(reduced_data(labels == 0,i)),std(reduced_data(labels == 3,i)),std(reduced_data(labels == 2,i)),std(reduced_data(labels == 1,i))];
    for j=1:numClasses
    y_a = [feat_mean+feat_std fliplr(feat_mean-feat_std)];
    y_c = [feat_mean+0.5*feat_std fliplr(feat_mean-0.5*feat_std)];
    cur_bar_x_a = [x_a(j) x_a(j) x_a(j)+errorbarwidth x_a(j)+errorbarwidth];
    cur_bar_x_c = [x_c(j) x_a(j) x_c(j)+errorbarwidth x_c(j)+errorbarwidth];
    cur_bar_y_a = [feat_mean(j)-feat_std(j) feat_mean(j)+feat_std(j) feat_mean(j)+feat_std(j) feat_mean(j)-feat_std(j)];
    cur_bar_y_c = [feat_mean(j)-0.5*feat_std(j) feat_mean(j)+0.5*feat_std(j) feat_mean(j)+0.5*feat_std(j) feat_mean(j)-0.5*feat_std(j)];
    patch(cur_bar_x_a,cur_bar_y_a,'r','EdgeAlpha',0,'FaceAlpha',0.4,'FaceColor',colors(j,:))
    patch(cur_bar_x_c,cur_bar_y_c,'b','EdgeAlpha',0,'FaceAlpha',0.4,'FaceColor',colors(j,:))
        hold on;
    end
     plot(1.3:1:4.3,feat_mean,'Color',line_color,'LineWidth',2)
    set(gca,'tickdir','out', ...
        'ticklen',[.01 .01],...
        'YTicklabel',[ ],...
        'xlim',[1,4.7],...
     'XTicklabel',[ ]);
    hold on;grid on
   

end


%% %% Visualize Weights and Statistics
is_horizontal = 0;

load 'C:\MyWork\Stanford\Documents\ad_paper_data_figures\PaperData\ADNC\Weights.mat';
load 'C:\MyWork\Stanford\Documents\ad_paper_data_figures\PaperData\ADNC\StatisticsAddingWeights30runs1.mat';

features = {'L Hippo Volume','L Hippo M11', 'L Hippo M12', 'L Hippo M22', 'L Hippo Entropy',...
    'R Hippo Volume','R Hippo M11', 'R Hippo M12', 'R Hippo M22', 'R Hippo Entropy',...
    'LiL Vent Volume','LiL Vent M11', 'LiL Vent M12', 'LiL Vent M22', 'LiL Vent Entropy',...
    'RiL Vent Volume','RiL Vent M11', 'RiL Vent M12', 'RiL Vent M22', 'RiL Vent Entropy',...
    'RL Vent Volume','RL Vent M11', 'RL Vent M12', 'RL Vent M22', 'RL Vent Entropy',...
    '3rd Vent Volume','3rd Vent M11', '3rd Vent M12', '3rd Vent M22', '3rd Vent Entropy','LC WM Volume', 'RC WM Volume';...
    1,1,1,1,1,2,2,2,2,2,3,3,3,3,3,4,4,4,4,4,5,5,5,5,5,6,6,6,6,6,7,8};
%
for i=1:size(w,1)
    w_norm(i,:) = w(i,:)/max(abs(w(i,:)));
end

w_norm = abs(w_norm);

[w_norm_sorted,ind] = sort(mean(w_norm),'descend');


% figure;
% n=32;
% errorb(mean(w_norm(1:n,ind(1:n))),1:n, std(w_norm(1:n,ind(1:n))),'multicolor')
% text = features(1,ind(1:n));
% organ = cell2mat(features(2,ind(1:n)));
% set( gca(), 'XTick',[1:n],'XTickLabel', text )
% rotateXLabels( gca(), 45 )
% colors = distinguishable_colors(20);
% colors = colors([12,11,8,7,20,6,16,15],:);
% colors = linspecer(8,'qualitative');
%colors = varycolor(8);

numWeights = 32;
mean_w = w_norm_sorted;
std_w = std(w_norm(1:numWeights,ind(1:numWeights)));
figure;
if(is_horizontal)
    subplot(3,1, 1);
else
    subplot(1,3,1);
end
hold on
x_a = [1:numWeights fliplr(1:numWeights)];
y_a = [mean_w+std_w fliplr(mean_w-std_w)];
x_c = x_a;
y_c = [mean_w+0.5*std_w fliplr(mean_w-0.5*std_w)];
errorbarwidth = 0.7;
for i = numWeights:-1:1
    cur_bar_x_a = [x_a(i) x_a(i) x_a(i)+errorbarwidth x_a(i)+errorbarwidth];
    cur_bar_x_c = [x_c(i) x_a(i) x_c(i)+errorbarwidth x_c(i)+errorbarwidth];
    cur_bar_y_a = [mean_w(i)-std_w(i) mean_w(i)+std_w(i) mean_w(i)+std_w(i) mean_w(i)-std_w(i)];
    cur_bar_y_c = [mean_w(i)-0.5*std_w(i) mean_w(i)+0.5*std_w(i) mean_w(i)+0.5*std_w(i) mean_w(i)-0.5*std_w(i)];
    if(is_horizontal)
        patch(cur_bar_x_a,cur_bar_y_a,'r','EdgeAlpha',0,'FaceAlpha',0.4,'FaceColor',[1 0.5 0])
        patch(cur_bar_x_c,cur_bar_y_c,'b','EdgeAlpha',0,'FaceAlpha',0.4,'FaceColor',[0 1 1])
    else
        patch(cur_bar_y_a,cur_bar_x_a,'r','EdgeAlpha',0,'FaceAlpha',0.4,'FaceColor',[1 0.5 0])
        patch(cur_bar_y_c,cur_bar_x_c,'b','EdgeAlpha',0,'FaceAlpha',0.4,'FaceColor',[0 1 1])
    end
    hold on;
end
if(is_horizontal)
    plot([numWeights:-1:1],fliplr(mean_w),'Color',[1 0.5 0],'LineWidth',2);
else
    plot(fliplr(mean_w),[numWeights:-1:1],'Color',[1 0.5 0],'LineWidth',2);
end
text1 = features(1,ind(1:numWeights));
if(is_horizontal)
    set(gca,'tickdir','out', ...
        'ticklen',[.01 .01],...
        'ylim',[-0.05 1.06],...
        'xlim',[0.5 32.5],...
        'XAxisLocation','top',...
        'YAxisLocation','right',...
        'XtickLabel',text1,...
        'XTick',[1:32],...
        'FontSize',10);
    rotateXLabels( gca(), 45 );
    
    subplot(3,1, 2);
else
    set(gca,'tickdir','out', ...
        'ticklen',[.01 .01],...
        'xlim',[-0.05 1.06],...
        'ylim',[0.5 32.5],...
        'YDir','reverse',...
        'XAxisLocation','top',...
        'YAxisLocation','right',...
        'YtickLabel',text1,...
        'YTick',[1:32],...
        'FontSize',10);
    subplot(1,3, 2);
    
end
x_a = [1:numWeights fliplr(1:numWeights)];
y_a = [d_prime_mean30+d_prime_std30 fliplr(d_prime_mean30-d_prime_std30)];
x_c = x_a;
y_c = [d_prime_mean30+0.5*d_prime_std30 fliplr(d_prime_mean30-0.5*d_prime_std30)];

x1_a = [1:numWeights fliplr(1:numWeights)];
y1_a = [bias_mean30+bias_std30 fliplr(bias_mean30-bias_std30)];
x1_c = x_a;
y1_c = [bias_mean30+0.5*bias_std30 fliplr(bias_mean30-0.5*bias_std30)];

errorbarwidth = 0.7;
for i = numWeights:-1:1
    cur_bar_x_a = [x_a(i) x_a(i) x_a(i)+errorbarwidth x_a(i)+errorbarwidth];
    cur_bar_x_c = [x_c(i) x_a(i) x_c(i)+errorbarwidth x_c(i)+errorbarwidth];
    cur_bar_y_a = [d_prime_mean30(i)-d_prime_std30(i) d_prime_mean30(i)+d_prime_std30(i) d_prime_mean30(i)+d_prime_std30(i) d_prime_mean30(i)-d_prime_std30(i)];
    cur_bar_y_c = [d_prime_mean30(i)-0.5*d_prime_std30(i) d_prime_mean30(i)+0.5*d_prime_std30(i) d_prime_mean30(i)+0.5*d_prime_std30(i) d_prime_mean30(i)-0.5*d_prime_std30(i)];
    if(is_horizontal)
        patch(cur_bar_x_a,cur_bar_y_a,'r','EdgeAlpha',0,'FaceAlpha',0.4,'FaceColor',[1 0.5 0])
        patch(cur_bar_x_c,cur_bar_y_c,'b','EdgeAlpha',0,'FaceAlpha',0.4,'FaceColor',[0 1 1])
    else
        patch(cur_bar_y_a,cur_bar_x_a,'r','EdgeAlpha',0,'FaceAlpha',0.4,'FaceColor',[1 0.5 0])
        patch(cur_bar_y_c,cur_bar_x_c,'b','EdgeAlpha',0,'FaceAlpha',0.4,'FaceColor',[0 1 1])
    end
    cur_bar_x1_a = [x_a(i) x_a(i) x_a(i)+errorbarwidth x_a(i)+errorbarwidth];
    cur_bar_x1_c = [x_c(i) x_a(i) x_c(i)+errorbarwidth x_c(i)+errorbarwidth];
    cur_bar_y1_a = [bias_mean30(i)-bias_std30(i) bias_mean30(i)+bias_std30(i) bias_mean30(i)+bias_std30(i) bias_mean30(i)-bias_std30(i)];
    cur_bar_y1_a = 1.5*ones(size(cur_bar_y1_a))+cur_bar_y1_a;
    cur_bar_y1_c = [bias_mean30(i)-0.5*bias_std30(i) bias_mean30(i)+0.5*bias_std30(i) bias_mean30(i)+0.5*bias_std30(i) bias_mean30(i)-0.5*bias_std30(i)];
    cur_bar_y1_c = 1.5*ones(size(cur_bar_y1_c))+cur_bar_y1_c;
    if(is_horizontal)
        patch(cur_bar_x1_a,cur_bar_y1_a,'r','EdgeAlpha',0,'FaceAlpha',0.4,'FaceColor',[1 0.5 0])
        patch(cur_bar_x1_c,cur_bar_y1_c,'b','EdgeAlpha',0,'FaceAlpha',0.4,'FaceColor',[0 1 1])
    else
        patch(cur_bar_y1_a,cur_bar_x1_a,'r','EdgeAlpha',0,'FaceAlpha',0.4,'FaceColor',[1 0.5 0])
        patch(cur_bar_y1_c,cur_bar_x1_c,'b','EdgeAlpha',0,'FaceAlpha',0.4,'FaceColor',[0 1 1])
    end
    
    hold on;
end
if(is_horizontal)
    plot([numWeights:-1:1],fliplr(d_prime_mean30),'Color',[1 0.5 0],'LineWidth',2)
    plot([numWeights:-1:1],fliplr(1.5*ones(size(bias_mean30))+bias_mean30),'Color',[1 0.5 0],'LineWidth',2)
    set(gca,'tickdir','out', ...
        'ticklen',[.01 .01],...
        'ylim',[1.0 3.3],...
        'xlim',[0.5 32.5],...
        'YAxisLocation','right',...
        'XTick',[]);
    
    
    subplot(3,1, 3);
    
else
    plot(fliplr(d_prime_mean30),[numWeights:-1:1],'Color',[1 0.5 0],'LineWidth',2)
    plot(fliplr(1.5*ones(size(bias_mean30))+bias_mean30),[numWeights:-1:1],'Color',[1 0.5 0],'LineWidth',2)
    set(gca,'tickdir','out', ...
        'ticklen',[.01 .01],...
        'xlim',[1.0 3.3],...
        'ylim',[0.5 32.5],...
        'YDir','reverse',...
        'YAxisLocation','right',...
        'YTick',[]);
    
    
    subplot(1,3,3);
    
end
x_a = [1:numWeights fliplr(1:numWeights)];
y_a = [err_mean30+err_std30 fliplr(err_mean30-err_std30)];
x_c = x_a;
y_c = [err_mean30+0.5*err_std30 fliplr(err_mean30-0.5*err_std30)];


x1_a = [1:numWeights fliplr(1:numWeights)];
y1_a = [sensitivity_mean30+sensitivity_std30 fliplr(sensitivity_mean30-sensitivity_std30)];
x1_c = x_a;
y1_c = [sensitivity_mean30+0.5*sensitivity_std30 fliplr(sensitivity_mean30-0.5*sensitivity_std30)];



errorbarwidth = 0.7;
for i = numWeights:-1:1
    cur_bar_x_a = [x_a(i) x_a(i) x_a(i)+errorbarwidth x_a(i)+errorbarwidth];
    cur_bar_x_c = [x_c(i) x_a(i) x_c(i)+errorbarwidth x_c(i)+errorbarwidth];
    cur_bar_y_a = [err_mean30(i)-err_std30(i) err_mean30(i)+err_std30(i) err_mean30(i)+err_std30(i) err_mean30(i)-err_std30(i)];
    cur_bar_y_c = [err_mean30(i)-0.5*err_std30(i) err_mean30(i)+0.5*err_std30(i) err_mean30(i)+0.5*err_std30(i) err_mean30(i)-0.5*err_std30(i)];
    if(is_horizontal)
        patch(cur_bar_x_a,cur_bar_y_a,'r','EdgeAlpha',0,'FaceAlpha',0.4,'FaceColor',[1 0.5 0])
        patch(cur_bar_x_c,cur_bar_y_c,'b','EdgeAlpha',0,'FaceAlpha',0.4,'FaceColor',[0 1 1])
    else
        patch(cur_bar_y_a,cur_bar_x_a,'r','EdgeAlpha',0,'FaceAlpha',0.4,'FaceColor',[1 0.5 0])
        patch(cur_bar_y_c,cur_bar_x_c,'b','EdgeAlpha',0,'FaceAlpha',0.4,'FaceColor',[0 1 1])
        
    end
    cur_bar_x1_a = [x1_a(i) x1_a(i) x1_a(i)+errorbarwidth x1_a(i)+errorbarwidth];
    cur_bar_x1_c = [x1_c(i) x1_a(i) x1_c(i)+errorbarwidth x1_c(i)+errorbarwidth];
    cur_bar_y1_a = [sensitivity_mean30(i)-sensitivity_std30(i) sensitivity_mean30(i)+sensitivity_std30(i) sensitivity_mean30(i)+sensitivity_std30(i) sensitivity_mean30(i)-sensitivity_std30(i)];
    cur_bar_y1_c = [sensitivity_mean30(i)-0.5*sensitivity_std30(i) sensitivity_mean30(i)+0.5*sensitivity_std30(i) sensitivity_mean30(i)+0.5*sensitivity_std30(i) sensitivity_mean30(i)-0.5*sensitivity_std30(i)];
    if(is_horizontal)
        
        patch(cur_bar_x1_a,cur_bar_y1_a,'g','EdgeAlpha',0,'FaceAlpha',0.4,'FaceColor',[1 0.5 0])
        patch(cur_bar_x1_c,cur_bar_y1_c,'c','EdgeAlpha',0,'FaceAlpha',0.4,'FaceColor',[0 1 1])
    else
        patch(cur_bar_y1_a,cur_bar_x1_a,'g','EdgeAlpha',0,'FaceAlpha',0.4,'FaceColor',[1 0.5 0])
        patch(cur_bar_y1_c,cur_bar_x1_c,'c','EdgeAlpha',0,'FaceAlpha',0.4,'FaceColor',[0 1 1])
        
    end
    hold on;
end
if(is_horizontal)
    plot([numWeights:-1:1],fliplr(err_mean30),'Color',[1 0.5 0],'LineWidth',2)
    plot([numWeights:-1:1],fliplr(sensitivity_mean30),'Color',[0.5 1 0],'LineWidth',2)
    
    set(gca,'tickdir','out', ...
        'ticklen',[.01 .01],...
        'ylim',[0.5 0.95],...
        'xlim',[0.5 32.5],...
        'YAxisLocation','right',...
        'XTick',[]);
    
else
    plot(fliplr(err_mean30),[numWeights:-1:1],'Color',[1 0.5 0],'LineWidth',2)
    plot(fliplr(sensitivity_mean30),[numWeights:-1:1],'Color',[0.5 1 0],'LineWidth',2)
    
    set(gca,'tickdir','out', ...
        'ticklen',[.01 .01],...
        'xlim',[0.5 0.95],...
        'ylim',[0.5 32.5],...
        'YDir','reverse',...
        'YAxisLocation','right',...
        'YTick',[]);
    
    
end

%%
%% %% Visualize Weights and Statistics -Separate plots for weights and
%% statistics
is_horizontal = 0;

load 'C:\MyWork\Stanford\Documents\ad_paper_data_figures\PaperData\ADNC\Weights.mat';
load 'C:\MyWork\Stanford\Documents\ad_paper_data_figures\PaperData\ADNC\ADNC_ind.mat';
load 'C:\MyWork\Stanford\Documents\ad_paper_data_figures\PaperData\ADNC\StatisticsAddingWeights30runs1.mat';

features = {'L Hippo Volume','L Hippo M11', 'L Hippo M12', 'L Hippo M22', 'L Hippo Entropy',...
    'R Hippo Volume','R Hippo M11', 'R Hippo M12', 'R Hippo M22', 'R Hippo Entropy',...
    'LiL Vent Volume','LiL Vent M11', 'LiL Vent M12', 'LiL Vent M22', 'LiL Vent Entropy',...
    'RiL Vent Volume','RiL Vent M11', 'RiL Vent M12', 'RiL Vent M22', 'RiL Vent Entropy',...
    'RL Vent Volume','RL Vent M11', 'RL Vent M12', 'RL Vent M22', 'RL Vent Entropy',...
    '3rd Vent Volume','3rd Vent M11', '3rd Vent M12', '3rd Vent M22', '3rd Vent Entropy','LC WM Volume', 'RC WM Volume';...
    1,1,1,1,1,2,2,2,2,2,3,3,3,3,3,4,4,4,4,4,5,5,5,5,5,6,6,6,6,6,7,8};
%
organ = cell2mat(features(2,ind(1:32)));
colors = distinguishable_colors(8);
%colors = colors([12,11,1,8,7,5,15,9],:);
for i=1:size(w,1)
    w_norm(i,:) = w(i,:)/max(abs(w(i,:)));
end

w_norm = abs(w_norm);
[w_norm_sorted,ind] = sort(mean(w_norm),'descend');

numWeights = 32;
mean_w = w_norm_sorted;
std_w = std(w_norm(1:numWeights,ind(1:numWeights)));
figure;
hold on
x_a = [1:numWeights fliplr(1:numWeights)];
y_a = [mean_w+std_w fliplr(mean_w-std_w)];
x_c = x_a;
y_c = [mean_w+0.5*std_w fliplr(mean_w-0.5*std_w)];
errorbarwidth = 0.7;
for i = numWeights:-1:1
    cur_bar_x_a = [x_a(i) x_a(i) x_a(i)+errorbarwidth x_a(i)+errorbarwidth];
    cur_bar_x_c = [x_c(i) x_a(i) x_c(i)+errorbarwidth x_c(i)+errorbarwidth];
    cur_bar_y_a = [mean_w(i)-std_w(i) mean_w(i)+std_w(i) mean_w(i)+std_w(i) mean_w(i)-std_w(i)];
    cur_bar_y_c = [mean_w(i)-0.5*std_w(i) mean_w(i)+0.5*std_w(i) mean_w(i)+0.5*std_w(i) mean_w(i)-0.5*std_w(i)];
    if(is_horizontal)
%         patch(cur_bar_x_a,cur_bar_y_a,'r','EdgeAlpha',0,'FaceAlpha',0.4,'FaceColor',[1 0.5 0])
%         patch(cur_bar_x_c,cur_bar_y_c,'b','EdgeAlpha',0,'FaceAlpha',0.4,'FaceColor',[0 1 1])
            patch(cur_bar_x_a,cur_bar_y_a,'b','EdgeAlpha',0,'FaceAlpha',0.3,'FaceColor',colors(organ(i),:))
        patch(cur_bar_x_c,cur_bar_y_c,'r','EdgeAlpha',0,'FaceAlpha',0.6,'FaceColor',colors(organ(i),:))
    else
        patch(cur_bar_y_a,cur_bar_x_a,'r','EdgeAlpha',0,'FaceAlpha',0.4,'FaceColor',colors(organ(i),:))
        patch(cur_bar_y_c,cur_bar_x_c,'b','EdgeAlpha',0,'FaceAlpha',0.4,'FaceColor',colors(organ(i),:))
    end
    hold on;
end
if(is_horizontal)
    plot([numWeights:-1:1],fliplr(mean_w),'Color',[49/255,79/255,79/255],'LineWidth',2);
else
    plot(fliplr(mean_w),[numWeights:-1:1],'Color',[1 1 0],'LineWidth',2);
end
text1 = features(1,ind(1:numWeights));
if(is_horizontal)
    set(gca,'tickdir','out', ...
        'ticklen',[.006 .006],...
        'ylim',[-0.05 1.06],...
        'xlim',[0.5 32.5],...
        'XtickLabel',text1,...
        'XTick',[1.3:1:32.3],...
        'YTick',[0,0.5,1],...
        'FontSize',15);
    rotateXLabels( gca(), 45 );

    text4legend = {'L Hippocampus','R Hippocampus','L iL Ventricle','R iL Ventricle','R L Ventricle', '3rd Ventricle','L C WM', 'R C WM'};
colors4legend = colors(1:2:end,:);
for i=1:length(text4legend)
    text(29,1.0-i*0.055,text4legend{i},'HorizontalAlignment','left','Color',colors(i,:),'Margin',0.5,'FontSize',13);
end
else
    set(gca,'tickdir','out', ...
        'ticklen',[.01 .01],...
        'xlim',[-0.05 1.06],...
        'ylim',[0.5 32.5],...
        'YDir','reverse',...
        'XAxisLocation','bottom',...
        'YAxisLocation','right',...
        'YtickLabel',text1,...
        'YTick',[1:32],...
        'XTick',[0,0.5,1],...
        'FontSize',12,...
        'fontweight','bold');
    text4legend = {'L Hippocampus','R Hippocampus','L iL Ventricle','R iL Ventricle','R L Ventricle', '3rd Ventricle','L C WM', 'R C WM'};
colors4legend = colors(1:2:end,:);
for i=1:length(text4legend)
    text(0.6,20+i*1.2,text4legend{i},'HorizontalAlignment','left','Color','k','Margin',0.5,'FontSize',12,'fontweight','bold');
end
end

%% Plot statistics separately
new_color = [60,179,113]/255;
new_color = [34,139,34]/255;	
line_color = [152,251,152]/255;
numWeights = 32;
figure;subplot(221)
x_a = [1:numWeights fliplr(1:numWeights)];
y_a = [d_prime_mean30+d_prime_std30 fliplr(d_prime_mean30-d_prime_std30)];
x_c = x_a;
y_c = [d_prime_mean30+0.5*d_prime_std30 fliplr(d_prime_mean30-0.5*d_prime_std30)];

errorbarwidth = 0.7;
for i = numWeights:-1:1
    cur_bar_x_a = [x_a(i) x_a(i) x_a(i)+errorbarwidth x_a(i)+errorbarwidth];
    cur_bar_x_c = [x_c(i) x_a(i) x_c(i)+errorbarwidth x_c(i)+errorbarwidth];
    cur_bar_y_a = [d_prime_mean30(i)-d_prime_std30(i) d_prime_mean30(i)+d_prime_std30(i) d_prime_mean30(i)+d_prime_std30(i) d_prime_mean30(i)-d_prime_std30(i)];
    cur_bar_y_c = [d_prime_mean30(i)-0.5*d_prime_std30(i) d_prime_mean30(i)+0.5*d_prime_std30(i) d_prime_mean30(i)+0.5*d_prime_std30(i) d_prime_mean30(i)-0.5*d_prime_std30(i)];
    patch(cur_bar_x_a,cur_bar_y_a,'r','EdgeAlpha',0,'FaceAlpha',0.4,'FaceColor',[1 0.5 0])
    patch(cur_bar_x_c,cur_bar_y_c,'b','EdgeAlpha',0,'FaceAlpha',0.4,'FaceColor',[0 1 1])
    hold on;
end
plot([numWeights+errorbarwidth/2:-1:1+errorbarwidth/2],fliplr(d_prime_mean30),'Color',[1 0.5 0],'LineWidth',2)
set(gca,'tickdir','out', ...
    'ticklen',[.01 .01],...
    'ylim',[1.9 3.2],...
    'xlim',[1 32.8],...
    'YAxisLocation','right',...
    'XTick',[],...
    'YTick',[2 2.5 3],...
    'FontSize',12);
hold on;



subplot(222);
x1_a = [1:numWeights fliplr(1:numWeights)];
y1_a = [bias_mean30+bias_std30 fliplr(bias_mean30-bias_std30)];
x1_c = x_a;
y1_c = [bias_mean30+0.5*bias_std30 fliplr(bias_mean30-0.5*bias_std30)];


for i = numWeights:-1:1
    cur_bar_x1_a = [x_a(i) x_a(i) x_a(i)+errorbarwidth x_a(i)+errorbarwidth];
    cur_bar_x1_c = [x_c(i) x_a(i) x_c(i)+errorbarwidth x_c(i)+errorbarwidth];
    cur_bar_y1_a = [bias_mean30(i)-bias_std30(i) bias_mean30(i)+bias_std30(i) bias_mean30(i)+bias_std30(i) bias_mean30(i)-bias_std30(i)];
    cur_bar_y1_a = cur_bar_y1_a;
    cur_bar_y1_c = [bias_mean30(i)-0.5*bias_std30(i) bias_mean30(i)+0.5*bias_std30(i) bias_mean30(i)+0.5*bias_std30(i) bias_mean30(i)-0.5*bias_std30(i)];
    cur_bar_y1_c = cur_bar_y1_c;
    patch(cur_bar_x1_a,cur_bar_y1_a,'r','EdgeAlpha',0,'FaceAlpha',0.4,'FaceColor',[1 0.5 0])
    patch(cur_bar_x1_c,cur_bar_y1_c,'b','EdgeAlpha',0,'FaceAlpha',0.4,'FaceColor',[0 1 1])
    hold on;
end
plot([numWeights+errorbarwidth/2:-1:1+errorbarwidth/2],fliplr(bias_mean30),'Color',[1 0.5 0],'LineWidth',2)
set(gca,'tickdir','out', ...
    'ticklen',[.01 .01],...
    'ylim',[-0.35 0.35],...
    'xlim',[1 32.8],...
    'YAxisLocation','right',...
    'XTick',[],...
    'FontSize',12,...
    'YTick',[-0.3 0 0.3]);
hold on;

subplot(223)
x_a = [1:numWeights fliplr(1:numWeights)];
y_a = [err_mean30+err_std30 fliplr(err_mean30-err_std30)];
x_c = x_a;
y_c = [err_mean30+0.5*err_std30 fliplr(err_mean30-0.5*err_std30)];

errorbarwidth = 0.7;
for i = numWeights:-1:1
    cur_bar_x_a = [x_a(i) x_a(i) x_a(i)+errorbarwidth x_a(i)+errorbarwidth];
    cur_bar_x_c = [x_c(i) x_a(i) x_c(i)+errorbarwidth x_c(i)+errorbarwidth];
    cur_bar_y_a = [err_mean30(i)-err_std30(i) err_mean30(i)+err_std30(i) err_mean30(i)+err_std30(i) err_mean30(i)-err_std30(i)];
    cur_bar_y_c = [err_mean30(i)-0.5*err_std30(i) err_mean30(i)+0.5*err_std30(i) err_mean30(i)+0.5*err_std30(i) err_mean30(i)-0.5*err_std30(i)];
    patch(cur_bar_x_a,cur_bar_y_a,'r','EdgeAlpha',0,'FaceAlpha',0.4,'FaceColor',[1 0.5 0])
    patch(cur_bar_x_c,cur_bar_y_c,'b','EdgeAlpha',0,'FaceAlpha',0.4,'FaceColor',[0 1 1])
    hold on;
end
plot([numWeights+errorbarwidth/2:-1:1+errorbarwidth/2],fliplr(err_mean30),'Color',[1 0.5 0],'LineWidth',2)

set(gca,'tickdir','out', ...
    'ticklen',[.01 .01],...
    'ylim',[0.5 0.95],...
    'xlim',[1 32.8],...
    'YAxisLocation','right',...
    'XTick',[],...
    'YTick',[0.5 0.7 0.9],...
    'FontSize',12);
hold on;
subplot(224)
x1_a = [1:numWeights fliplr(1:numWeights)];
y1_a = [sensitivity_mean30+sensitivity_std30 fliplr(sensitivity_mean30-sensitivity_std30)];
x1_c = x_a;
y1_c = [sensitivity_mean30+0.5*sensitivity_std30 fliplr(sensitivity_mean30-0.5*sensitivity_std30)];
for i = numWeights:-1:1
    
    cur_bar_x1_a = [x1_a(i) x1_a(i) x1_a(i)+errorbarwidth x1_a(i)+errorbarwidth];
    cur_bar_x1_c = [x1_c(i) x1_a(i) x1_c(i)+errorbarwidth x1_c(i)+errorbarwidth];
    cur_bar_y1_a = [sensitivity_mean30(i)-sensitivity_std30(i) sensitivity_mean30(i)+sensitivity_std30(i) sensitivity_mean30(i)+sensitivity_std30(i) sensitivity_mean30(i)-sensitivity_std30(i)];
    cur_bar_y1_c = [sensitivity_mean30(i)-0.5*sensitivity_std30(i) sensitivity_mean30(i)+0.5*sensitivity_std30(i) sensitivity_mean30(i)+0.5*sensitivity_std30(i) sensitivity_mean30(i)-0.5*sensitivity_std30(i)];
    
    patch(cur_bar_x1_a,cur_bar_y1_a,'g','EdgeAlpha',0,'FaceAlpha',0.4,'FaceColor',[1 0.5 0])
    patch(cur_bar_x1_c,cur_bar_y1_c,'c','EdgeAlpha',0,'FaceAlpha',0.4,'FaceColor',[0 1 1])
    hold on;
end
plot([numWeights+errorbarwidth/2:-1:1+errorbarwidth/2],fliplr(sensitivity_mean30),'Color',[1 0.5 0],'LineWidth',2)
set(gca,'tickdir','out', ...
    'ticklen',[.01 .01],...
    'ylim',[0.5 0.95],...
    'xlim',[1 32.8],...
    'YAxisLocation','right',...
    'XTick',[],...
    'YTick',[0.5 0.7 0.9],...
    'FontSize',12);

figure; plot([numWeights:-1:1],fliplr(err_mean30),'Color',[1 0.5 0],'LineWidth',2);title('accuracy')
set(gca,'tickdir','out', ...
    'ticklen',[.01 .01],...
    'ylim',[0.8 0.95],...
    'xlim',[1 32.8],...
    'YAxisLocation','right',...
    'XTick',[],...
    'YTick',[0.8 0.85 0.9 0.95],...
    'FontSize',12);
figure; plot([numWeights:-1:1],fliplr(sensitivity_mean30),'Color',[1 0.5 0],'LineWidth',2);title('sensitivity')
set(gca,'tickdir','out', ...
    'ticklen',[.01 .01],...
    'ylim',[0.5 0.95],...
    'xlim',[1 32.8],...
    'YAxisLocation','right',...
    'XTick',[],...
    'YTick',[0.8 0.85 0.9 0.95],...
    'FontSize',12);

%% ROC CURVE PLOTTING
cd C:\MyWork\Stanford\Documents\ad_paper_data_figures\PaperData

load AllROC.mat
figure;
p=1.6;
plot((ones(size(specificity1ADNC)) - specificity1ADNC), sensitivity1ADNC,'b','LineWidth',p,'LineSmoothing','on');
hold on;
plot((ones(size(specificity1CNMCIc)) - specificity1CNMCIc), sensitivity1CNMCIc,'g','LineWidth',p,'LineSmoothing','on');
hold on;
plot((ones(size(specificity1MCIcnc)) - specificity1MCIcnc), sensitivity1MCIcnc,'r','LineWidth',p,'LineSmoothing','on');
legend('CN vs AD', 'CN vs MCIc','MCInc vs MCIc','Location','SouthEast')
legend('boxoff','LineWidth',p);
set(gca,'tickdir','out', ...
    'ticklen',[.01 .01],...
    'XTick',[0:0.2:1],...
    'YTick',[0:0.2:1]);

%%
load 'C:\MyWork\Stanford\code\FMapsNEw\RegionGrowingMaps1_20.mat'
F{2}(F{2}<1e-6) = 0;
F{3}(F{3}<1e-6) = 0;
F{4}(F{4}<1e-6) = 0;
[perm,new_map] = findMapPermutation(F{1});figure;imagesc(new_map);colormap(redbluecmap(255,255));set(gca,'tickdir','out', ...
    'ticklen',[.01 .01],'FontSize',12,'fontweight','bold','XTick', [0 15 30],'YTick', [0 15 30]);axis('square');h=colorbar;set(h,'fontsize',12,'fontweight','bold','ticklen',[0 0])

[perm,new_map] = findMapPermutation(F{2});figure;imagesc(new_map);colormap(redbluecmap(255,255));set(gca,'tickdir','out', ...
    'ticklen',[.01 .01],'FontSize',12,'fontweight','bold');
[perm,new_map] = findMapPermutation(F{3});figure;imagesc(new_map);colormap(redbluecmap(255,255));set(gca,'tickdir','out', ...
    'ticklen',[.01 .01],'FontSize',12,'fontweight','bold');
[perm,new_map] = findMapPermutation(F{4});figure;imagesc(new_map);colormap(redbluecmap(255,255));set(gca,'tickdir','out', ...
    'ticklen',[.01 .01],'FontSize',12,'fontweight','bold');
