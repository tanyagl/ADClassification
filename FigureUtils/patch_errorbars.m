numWeights = 32;
mean_w = w_norm_sorted;
std_w = std(w_norm(1:n,ind(1:n)));
figure;hold on
%  plot([32 32],[0 1.2],'k-','LineWidth',.75,'Color',[.3 .3 .3]);
%  plot([80 80],[0 1.7],'k-','LineWidth',.75,'Color',[.3 .3 .3]);
x_a = [1:numWeights fliplr(1:numWeights)];
y_a = [mean_w+std_w fliplr(mean_w-std_w)];
x_c = x_a;
y_c = [mean_w+0.5*std_w fliplr(mean_w-0.5*std_w)];
errorbarwidth = 0.7;
for i = numWeights:-1:1
    cur_bar_x_a = [x_a(i) x_a(i) x_a(i)+errorbarwidth x_a(i)+errorbarwidth]
    cur_bar_x_c = [x_c(i) x_a(i) x_c(i)+errorbarwidth x_c(i)+errorbarwidth];
    cur_bar_y_a = [mean_w(i)-std_w(i) mean_w(i)+std_w(i) mean_w(i)+std_w(i) mean_w(i)-std_w(i)]
    cur_bar_y_c = [mean_w(i)-0.5*std_w(i) mean_w(i)+0.5*std_w(i) mean_w(i)+0.5*std_w(i) mean_w(i)-0.5*std_w(i)];
    patch(cur_bar_y_a,cur_bar_x_a,'r','EdgeAlpha',0,'FaceAlpha',0.4,'FaceColor',[1 0.5 0])
    patch(cur_bar_y_c,cur_bar_x_c,'b','EdgeAlpha',0,'FaceAlpha',0.4,'FaceColor',[0 1 1])
    hold on;
end
plot(fliplr(mean_w),[numWeights:-1:1],'Color',[1 0.5 0],'LineWidth',2)

set(gca,'tickdir','out', ...
    'ticklen',[.02 .02],...
    'YDir','reverse',...
    'xlim',[-0.05 1.08],...
    'ylim',[0.5 32.5],...
    'XAxisLocation','top',...
    'YAxisLocation','right',...
    'YtickLabel',text1,...
    'FontSize',12);
% saveas(gcf,'this_fig_name_','png')
