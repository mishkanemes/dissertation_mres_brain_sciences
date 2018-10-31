%% full analysis script to analyse data from experiment: confidence leak in the general domain
% Last accessed by Mihaela Nemes on the 6th of August 2018

%% load participant data and save important variables 


% excluded subj: 1, 8, 33
subjects = [2 3 4 5 6 7 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 ...
    25 26 27 28 29 30 31 32 34];
grand_mat = [];

% vectors to load each subject average values
perf_avg_subj = []; 
conf_avg_subj = [];
zconf_avg_subj = [];
rt_avg_subj = [];
zrt_avg_subj = [];

% vectors to load each trial average values
perf_sem_trial = []; 
conf_sem_trial = [];
zconf_sem_trial = [];
rt_sem_trial = [];
zrt_sem_trial = [];

overconf_rgrs_mat = []; underconf_rgrs_mat = [];

for subj = 1:length(subjects) % iterate for each subject
    file_name = ['DataExp1_Subject',num2str(subjects(subj)),'.mat'];
    load(file_name)
    
    % load the each subject's data into the vector data matrix
    % z stands for z-scored values
    
    stage = data.matrix(:,3); zstage = zscore(stage);
    coherence = data.matrix(:,4); zcoherence = zscore(coherence);
    perf = data.matrix(:,9); zperf = zscore(perf);
    conf = data.matrix(:,11); zconf = zscore(conf);
    rt = data.matrix(:,10); zrt = zscore(rt);
    subject = repmat(subj, [240,1]);
    trial_be = 1:240; trial = trial_be'; ztrial = zscore(trial);
    
    subj_mat = [subject stage trial coherence perf conf zconf rt rt ...
        zstage zcoherence zperf ztrial]; % col8 rt will be zrt
   
    % save aggregated subject matrixes in matrix by individual
    indiv_mat = [];
    
    % exclude trials outside 2 SD; calculated for the entire experiment,
    % individually calibrated
    
    rt_centre  = mean(rt);
    rt_stdinterval = std(rt)*2;  
    
    for n = 1:length(rt)     
        if (rt(n) <= (rt_centre + rt_stdinterval)) && rt(n) >= (rt_centre - rt_stdinterval)       
            indiv_mat = [ indiv_mat ; subj_mat(n,:) ];   
            % save data from included trials
            zconf_trial(subj,n) = zconf(n);
            perf_trial(subj,n) = perf(n);
            zrt_trial(subj,n) = zrt(n);            
        else % assign NaN values to excluded trials      
            zconf_trial(subj,n) = NaN;
            perf_trial(subj,n) = NaN;
            zrt_trial(subj,n) = NaN;  
        end
    end
    

  
    indiv_mat(:,9) = zscore(indiv_mat(:,9)); % zscore rt 
   
    % save data from each individual in the grand matrix of all subj
    grand_mat = [ grand_mat; indiv_mat ];
    % create new matrixes for each experimental stage 
    b1_mat_subj = []; b2_mat_subj = []; b3_mat_subj = [];
    
    % divide individual subj matrix in experimental stages
    
    for i = 1:length(indiv_mat(:,1))
        if indiv_mat(i,2) == 1
            b1_mat_subj = [ b1_mat_subj ; indiv_mat(i,:) ];
        elseif indiv_mat(i,2) == 2
            b2_mat_subj = [ b2_mat_subj ; indiv_mat(i,:) ];
        elseif indiv_mat(i,2) == 3
            b3_mat_subj = [ b3_mat_subj ; indiv_mat(i,:) ];
        end
    end
    
    % calculate mean and SEM of parameters by subject
    
    perf_avg_subj (subj,:) = [ mean(b1_mat_subj(:,5)) mean(b2_mat_subj(:,5))...
        mean(b3_mat_subj(:,5)) ];
    conf_avg_subj (subj,:) = [ mean(b1_mat_subj(:,6)) mean(b2_mat_subj(:,6))...
        mean(b3_mat_subj(:,6)) ];
    zconf_avg_subj (subj,:) = [ mean(b1_mat_subj(:,7)) mean(b2_mat_subj(:,7))...
        mean(b3_mat_subj(:,7)) ];
    rt_avg_subj (subj,:) = [ mean(b1_mat_subj(:,8)) mean(b2_mat_subj(:,8))...
        mean(b3_mat_subj(:,8)) ];
    zrt_avg_subj (subj,:) = [ mean(b1_mat_subj(:,9)) mean(b2_mat_subj(:,9))...
        mean(b3_mat_subj(:,9)) ];
    
    perf_sem_subj (subj,:) = [ std(b1_mat_subj (:,5))/sqrt(length(b1_mat_subj (:,5))) ...
        std(b2_mat_subj (:,5))/sqrt(length(b2_mat_subj (:,5))) ...
        std(b3_mat_subj (:,5))/sqrt(length(b3_mat_subj (:,5))) ] ;
    conf_sem_subj (subj,:) = [ std(b1_mat_subj (:,6))/sqrt(length(b1_mat_subj (:,6))) ...
        std(b2_mat_subj (:,6))/sqrt(length(b2_mat_subj (:,6))) ...
        std(b3_mat_subj (:,6))/sqrt(length(b3_mat_subj (:,6))) ] ;
    zconf_sem_subj (subj,:) = [ std(b1_mat_subj (:,7))/sqrt(length(b1_mat_subj (:,7))) ...
        std(b2_mat_subj (:,7))/sqrt(length(b2_mat_subj (:,7))) ...
        std(b3_mat_subj (:,7))/sqrt(length(b3_mat_subj (:,7))) ] ;
    rt_sem_subj (subj,:) = [ std(b1_mat_subj (:,8))/sqrt(length(b1_mat_subj (:,8))) ...
        std(b2_mat_subj (:,8))/sqrt(length(b2_mat_subj (:,8))) ...
        std(b3_mat_subj (:,8))/sqrt(length(b3_mat_subj (:,8))) ] ;
    zrt_sem_subj (subj,:) = [ std(b1_mat_subj (:,9))/sqrt(length(b1_mat_subj (:,9))) ...
        std(b2_mat_subj (:,9))/sqrt(length(b2_mat_subj (:,9))) ...
        std(b3_mat_subj (:,9))/sqrt(length(b3_mat_subj (:,9))) ] ;
   
    % create 2 new matrices for regression (rgrs) analysis by conf group
    
    if mean(b1_mat_subj(:,7)) < mean(b3_mat_subj(:,7))
        overconf_rgrs_mat = [ overconf_rgrs_mat; indiv_mat ];
    elseif mean(b1_mat_subj(:,7)) > mean(b3_mat_subj(:,7))
        underconf_rgrs_mat = [ underconf_rgrs_mat; indiv_mat ];
    end
   
    
end

rgrs_mat = [ grand_mat(:,1) grand_mat(:,10) grand_mat(:,13) grand_mat(:,11) ...
    grand_mat(:,12) grand_mat(:,7) grand_mat(:,9) ];
rgrs_mat_overconf = [ overconf_rgrs_mat(:,1) overconf_rgrs_mat(:,10) ...
    overconf_rgrs_mat(:,13) overconf_rgrs_mat(:,11) ...
    overconf_rgrs_mat(:,12) overconf_rgrs_mat(:,7) overconf_rgrs_mat(:,9) ];
rgrs_mat_underconf = [ underconf_rgrs_mat(:,1) underconf_rgrs_mat(:,10) ...
    underconf_rgrs_mat(:,13) underconf_rgrs_mat(:,11) ...
    underconf_rgrs_mat(:,12) underconf_rgrs_mat(:,7) underconf_rgrs_mat(:,9) ];

clear b1_mat_subj  b2_mat_subj b3_mat_subj  coherence conf  ...
    file_name i n perf  ...
    rt   rt_centre ...
    rt_stdinterval stage subj subj_mat subject  ...
    trial trial_be zconf  ...
    zcoherence zperf zrt   ...
    zstage ztrial indiv_mat;



%% divide grand matrix in experimental stages

b1_mat_trial = []; b2_mat_trial = []; b3_mat_trial = [];

for i = 1:length(grand_mat(:,1))
    if grand_mat(i,2) == 1
        b1_mat_trial = [ b1_mat_trial ; grand_mat(i,:) ];
    elseif grand_mat(i,2) == 2
        b2_mat_trial = [ b2_mat_trial ; grand_mat(i,:) ];
    elseif grand_mat(i,2) == 3
        b3_mat_trial = [ b3_mat_trial ; grand_mat(i,:) ];
    end
end

rgrs_mat_s1 = [ b1_mat_trial(:,1) b1_mat_trial(:,10) b1_mat_trial(:,13) b1_mat_trial(:,11) ...
    b1_mat_trial(:,12) b1_mat_trial(:,7) b1_mat_trial(:,9) ];
rgrs_mat_s2 = [ b2_mat_trial(:,1) b2_mat_trial(:,10) b2_mat_trial(:,13) b2_mat_trial(:,11) ...
    b2_mat_trial(:,12) b2_mat_trial(:,7) b2_mat_trial(:,9) ];
rgrs_mat_s3 = [ b3_mat_trial(:,1) b3_mat_trial(:,10) b3_mat_trial(:,13) b3_mat_trial(:,11) ...
    b3_mat_trial(:,12) b3_mat_trial(:,7) b3_mat_trial(:,9) ];

%% calculate mean and SEM of parameters by trial

perf_avg_trial  = [ mean(b1_mat_trial(:,5)) mean(b2_mat_trial(:,5))...
    mean(b3_mat_trial(:,5)) ];
conf_avg_trial = [ mean(b1_mat_trial(:,6)) mean(b2_mat_trial(:,6))...
    mean(b3_mat_trial(:,6)) ];
zconf_avg_trial = [ mean(b1_mat_trial(:,7)) mean(b2_mat_trial(:,7))...
    mean(b3_mat_trial(:,7)) ];
rt_avg_trial = [ mean(b1_mat_trial(:,8)) mean(b2_mat_trial(:,8))...
    mean(b3_mat_trial(:,8)) ];
zrt_avg_trial = [ mean(b1_mat_trial(:,9)) mean(b2_mat_trial(:,9))...
    mean(b3_mat_trial(:,9)) ];

perf_sem_trial = [ std(b1_mat_trial (:,5))/sqrt(length(b1_mat_trial (:,5))) ...
    std(b2_mat_trial (:,5))/sqrt(length(b2_mat_trial (:,5))) ...
    std(b3_mat_trial (:,5))/sqrt(length(b3_mat_trial (:,5))) ] ;
conf_sem_trial = [ std(b1_mat_trial (:,6))/sqrt(length(b1_mat_trial (:,6))) ...
    std(b2_mat_trial (:,6))/sqrt(length(b2_mat_trial (:,6))) ...
    std(b3_mat_trial (:,6))/sqrt(length(b3_mat_trial (:,6))) ] ;
zconf_sem_trial = [ std(b1_mat_trial (:,7))/sqrt(length(b1_mat_trial (:,7))) ...
    std(b2_mat_trial (:,7))/sqrt(length(b2_mat_trial (:,7))) ...
    std(b3_mat_trial (:,7))/sqrt(length(b3_mat_trial (:,7))) ] ;
rt_sem_trial = [ std(b1_mat_trial (:,8))/sqrt(length(b1_mat_trial (:,8))) ...
    std(b2_mat_trial (:,8))/sqrt(length(b2_mat_trial (:,8))) ...
    std(b3_mat_trial (:,8))/sqrt(length(b3_mat_trial (:,8))) ] ;
zrt_sem_trial = [ std(b1_mat_trial (:,9))/sqrt(length(b1_mat_trial (:,9))) ...
    std(b2_mat_trial (:,9))/sqrt(length(b2_mat_trial (:,9))) ...
    std(b3_mat_trial (:,9))/sqrt(length(b3_mat_trial (:,9))) ] ;
 
%% plot trial data (top panels) AND subj data (bottom panels) 
% raw conf and raw rt

figure('name', 'Grand plots'); hold on
set(gcf,'color','w');
xspan = 1:3;

% by trial

subplot(2,3,1); hold on
plot(xspan, perf_avg_trial, 'marker', '.', 'markersize', 30, 'linestyle', '-', ...
    'lineWidth', 5, 'color', '[0, 0.4470, 0.7410]'); hold on
errorbar(xspan, perf_avg_trial , perf_sem_trial, 'linestyle', 'none', ...
    'lineWidth', 2, 'color', 'k');
xlim ([0.75 3.25]); xticks([1 2 3]); ylim([0.5 0.9]);
xticklabels ({'', '', ''});
ylabel('% correct');
yticks([0.4 0.5 0.6 0.7 0.8 0.9 1]);
yticklabels ({'40', '50', '60', '70', '80', '90', '100'});
set(gca,'fontsize',25);


subplot(2,3,2); hold on
plot(xspan, conf_avg_trial, 'marker', '.', 'markersize', 30, 'linestyle', '-', ...
    'color', [0.95 0.4 0.2], 'lineWidth', 5); hold on
errorbar(xspan, conf_avg_trial , conf_sem_trial, 'linestyle', 'none', ...
    'color', 'k' , 'lineWidth', 2);
xlim ([0.75 3.25]); xticks([1 2 3]); ylim([0.72 0.82]);
xticklabels ({'', '', ''});
ylabel('Confidence');
set(gca,'fontsize',25);
title ('Trial-level')


subplot(2,3,3); hold on
plot(xspan, rt_avg_trial, 'marker', '.', 'markersize', 30, 'linestyle', '-', ...
    'color', [0 0.5000 0], 'lineWidth', 5); hold on
errorbar(xspan, rt_avg_trial , rt_sem_trial, 'linestyle', 'none', ...
    'color', 'k', 'lineWidth', 2);
xlim ([0.75 3.25]); xticks([1 2 3]); ylim([0.95 1.25]);
xticklabels ({'', '', ''});
ylabel('RT (s)'); 
set(gca,'fontsize',25);


% by subj

subplot(2,3,4); hold on
plot(xspan, mean(perf_avg_subj), 'marker', '.', 'markersize', 30, 'linestyle', '-', ...
    'lineWidth', 5, 'color', '[0, 0.4470, 0.7410]'); hold on
errorbar(xspan, mean(perf_avg_subj) , mean(perf_sem_subj), 'linestyle', 'none', ...
    'lineWidth', 2, 'color', 'k');
xlim ([0.75 3.25]); xticks([1 2 3]); ylim([0.5 0.9]);
xticklabels ({'S1', 'S2', 'S3'});
ylabel('% correct');
yticks([0.4 0.5 0.6 0.7 0.8 0.9 1]);
yticklabels ({'40', '50', '60', '70', '80', '90', '100'});
set(gca,'fontsize',25);

subplot(2,3,5); hold on
plot(xspan, mean(conf_avg_subj), 'marker', '.', 'markersize', 30, 'linestyle', '-', ...
    'color', [0.95 0.4 0.2], 'lineWidth', 5); hold on
errorbar(xspan, mean(conf_avg_subj) , mean(conf_sem_subj), 'linestyle', 'none', ...
    'color', 'k' , 'lineWidth', 2);
xlim ([0.75 3.25]); xticks([1 2 3]); ylim([0.72 0.82]);
xticklabels ({'S1', 'S2', 'S3'});
ylabel('Confidence');
set(gca,'fontsize',25);
title('Subject-level')


subplot(2,3,6); hold on
plot(xspan, mean(rt_avg_subj), 'marker', '.', 'markersize', 30, 'linestyle', '-', ...
    'color', [0 0.5000 0], 'lineWidth', 5); hold on
errorbar(xspan, mean(rt_avg_subj) , mean(rt_sem_subj), 'linestyle', 'none', ...
    'color', 'k', 'lineWidth', 2);
xlim ([0.75 3.25]); xticks([1 2 3]); ylim([0.95 1.25]);
xticklabels ({'S1', 'S2', 'S3'});
ylabel('RT (s)'); 
set(gca,'fontsize',25);


fig = gcf;
fig.PaperUnits = 'inches';
fig.PaperPosition = [0 0 12 6];
print(gcf,'fig3','-dpng','-r300')



%% plot trial data (top panels) AND subj data (bottom panels)
% zscored conf and rt

figure('name', 'Grand plots - zdata'); hold on
set(gcf,'color','w');

% by trial

subplot(2,3,1); hold on
plot(xspan, perf_avg_trial, 'marker', '.', 'markersize', 30, 'linestyle', '-', ...
    'lineWidth', 5, 'color', '[0, 0.4470, 0.7410]'); hold on
errorbar(xspan, perf_avg_trial , perf_sem_trial, 'linestyle', 'none', ...
    'lineWidth', 2, 'color', 'k');
xlim ([0.75 3.25]); xticks([1 2 3]); ylim([0.5 0.9]);
xticklabels ({'', '', ''});
ylabel('% correct');
set(gca,'fontsize',25);
yticks([0.4 0.5 0.6 0.7 0.8 0.9 1]);
yticklabels ({'40', '50', '60', '70', '80', '90', '100'});
% title ('Performance')

subplot(2,3,2); hold on
plot(xspan, zconf_avg_trial, 'marker', '.', 'markersize', 30, 'linestyle', '-', ...
    'color', [0.95 0.4 0.2], 'lineWidth', 5); hold on
errorbar(xspan, zconf_avg_trial , zconf_sem_trial, 'linestyle', 'none', ...
    'color', 'k' , 'lineWidth', 2);
xlim ([0.75 3.25]); xticks([1 2 3]); ylim([-0.3 0.3]);
xticklabels ({'', '', ''});
ylabel('zConfidence');
set(gca,'fontsize',25);
% title ('Confidence')
title('Trial-level')


subplot(2,3,3); hold on
plot(xspan, zrt_avg_trial, 'marker', '.', 'markersize', 30, 'linestyle', '-', ...
    'color', [0 0.5000 0], 'lineWidth', 5); hold on
errorbar(xspan, zrt_avg_trial , zrt_sem_trial, 'linestyle', 'none', ...
    'color', 'k', 'lineWidth', 2);
xlim ([0.75 3.25]); xticks([1 2 3]); ylim([-0.5 0.5]);
xticklabels ({'', '', ''});
ylabel('zRT(s)'); 
set(gca,'fontsize',25);
% title ('Reaction time')

% by subj

subplot(2,3,4); hold on
plot(xspan, mean(perf_avg_subj), 'marker', '.', 'markersize', 30, 'linestyle', '-', ...
    'lineWidth', 5, 'color', '[0, 0.4470, 0.7410]'); hold on
errorbar(xspan, mean(perf_avg_subj) , mean(perf_sem_subj), 'linestyle', 'none', ...
    'lineWidth', 2, 'color', 'k');
xlim ([0.75 3.25]); xticks([1 2 3]); ylim([0.5 0.9]);
xticklabels ({'S1', 'S2', 'S3'});
ylabel('% correct');
yticks([0.4 0.5 0.6 0.7 0.8 0.9 1]);
yticklabels ({'40', '50', '60', '70', '80', '90', '100'});
set(gca,'fontsize',25);

subplot(2,3,5); hold on
plot(xspan, mean(zconf_avg_subj), 'marker', '.', 'markersize', 30, 'linestyle', '-', ...
    'color', [0.95 0.4 0.2], 'lineWidth', 5); hold on
errorbar(xspan, mean(zconf_avg_subj) , mean(zconf_sem_subj), 'linestyle', 'none', ...
    'color', 'k' , 'lineWidth', 2);
xlim ([0.75 3.25]); xticks([1 2 3]); ylim([-0.3 0.3]);
xticklabels ({'S1', 'S2', 'S3'});
ylabel('zConfidence');
set(gca,'fontsize',25);
title('Subject-level')


subplot(2,3,6); hold on
plot(xspan, mean(zrt_avg_subj), 'marker', '.', 'markersize', 30, 'linestyle', '-', ...
    'color', [0 0.5000 0], 'lineWidth', 5); hold on
errorbar(xspan, mean(zrt_avg_subj) , mean(zrt_sem_subj), 'linestyle', 'none', ...
    'color', 'k', 'lineWidth', 2);
xlim ([0.75 3.25]); xticks([1 2 3]); ylim([-0.5 0.5]);
xticklabels ({'S1', 'S2', 'S3'});
ylabel('zRT(s)'); 
set(gca,'fontsize',25);

fig = gcf;
fig.PaperUnits = 'inches';
fig.PaperPosition = [0 0 12 6];
print(gcf,'fig3','-dpng','-r300')

%% test carry over for first 10 trials before and after coherence change at subj level

% divide grand matrix in experimental stages

last_s1_avg = []; first_s2_avg = []; last_s2_avg = []; first_s3_avg = [];
last_s1_sem = []; first_s2_sem = []; last_s2_sem = []; first_s3_sem = [];
last_s1_trial = []; first_s2_trial = []; last_s2_trial = []; first_s3_trial = [];

for k = 1:length(subjects)
        
    l = find (grand_mat(:,2) == 1 & grand_mat(:,1) == k, 10, 'last' );
    m = find (grand_mat(:,2) == 2 & grand_mat(:,1) == k, 10, 'first' );
    n = find (grand_mat(:,2) == 2 & grand_mat(:,1) == k, 10, 'last' );
    o = find (grand_mat(:,2) == 3 & grand_mat(:,1) == k, 10, 'first' );
    
    % save by subj
    last_s1_avg = [ last_s1_avg; mean(grand_mat(l,:)) ];
    first_s2_avg = [ first_s2_avg; mean(grand_mat(m,:)) ];
    last_s2_avg = [ last_s2_avg; mean(grand_mat(n,:)) ];
    first_s3_avg = [ first_s3_avg; mean(grand_mat(o,:)) ];
    
    last_s1_sem = [ last_s1_sem; std(grand_mat(l,:))/sqrt(length(grand_mat(l,:))) ]; 
    first_s2_sem = [ first_s2_sem; std(grand_mat(m,:))/sqrt(length(grand_mat(m,:))) ]; 
    last_s2_sem = [ last_s2_sem; std(grand_mat(n,:))/sqrt(length(grand_mat(n,:))) ]; 
    first_s3_sem = [ first_s3_sem; std(grand_mat(o,:))/sqrt(length(grand_mat(o,:))) ]; 
    
    % save by trial
    last_s1_trial = [ last_s1_trial; grand_mat(l,:) ];
    first_s2_trial = [ first_s2_trial; grand_mat(m,:) ];
    last_s2_trial = [ last_s2_trial; grand_mat(n,:) ];
    first_s3_trial = [ first_s3_trial; grand_mat(o,:) ];
    
end

% calculations by subj
perf_dynamics_avg_subj = [ mean(last_s1_avg(:, 5)) mean(first_s2_avg(:, 5)) ...
    mean(last_s2_avg(:, 5)) mean(first_s3_avg(:, 5)) ];
perf_dynamics_sem_subj = [ mean(last_s1_sem(:, 5)) mean(first_s2_sem(:, 5)) ...
    mean(last_s2_sem(:, 5)) mean(first_s3_sem(:, 5)) ];

zconf_dynamics_avg_subj = [ mean(last_s1_avg(:, 7)) mean(first_s2_avg(:, 7)) ...
    mean(last_s2_avg(:, 7)) mean(first_s3_avg(:, 7)) ];
zconf_dynamics_sem_subj = [ mean(last_s1_sem(:, 7)) mean(first_s2_sem(:, 7)) ...
    mean(last_s2_sem(:, 7)) mean(first_s3_sem(:, 7)) ];


zrt_dynamics_avg_subj = [ mean(last_s1_avg(:, 9)) mean(first_s2_avg(:, 9)) ...
    mean(last_s2_avg(:, 9)) mean(first_s3_avg(:, 9)) ];
zrt_dynamics_sem_subj = [ mean(last_s1_sem(:, 7)) mean(first_s2_sem(:, 9)) ...
    mean(last_s2_sem(:, 9)) mean(first_s3_sem(:, 9)) ];

% calculations by trial
perf_dynamics_avg_trial = [ mean(last_s1_trial(:, 5)) mean(first_s2_trial(:, 5)) ...
    mean(last_s2_trial(:, 5)) mean(first_s3_trial(:, 5)) ];
perf_dynamics_sem_trial = [ std(last_s1_trial(:, 5))/sqrt(length(last_s1_trial(:, 5))) ...
    std(first_s2_trial(:, 5))/sqrt(length(first_s2_trial(:, 5))) ...
    std(last_s2_trial(:, 5))/sqrt(length(last_s2_trial(:, 5))) ...
    std(first_s3_trial(:, 5))/sqrt(length(first_s3_trial(:, 5))) ];

zconf_dynamics_avg_trial = [ mean(last_s1_trial(:, 7)) mean(first_s2_trial(:, 7)) ...
    mean(last_s2_trial(:, 7)) mean(first_s3_trial(:, 7)) ];
zconf_dynamics_sem_trial = [ std(last_s1_trial(:, 7))/sqrt(length(last_s1_trial(:, 7))) ...
    std(first_s2_trial(:, 7))/sqrt(length(first_s2_trial(:, 7))) ...
    std(last_s2_trial(:, 7))/sqrt(length(last_s2_trial(:, 7))) ...
    std(first_s3_trial(:, 7))/sqrt(length(first_s3_trial(:, 7))) ];

zrt_dynamics_avg_trial = [ mean(last_s1_trial(:, 9)) mean(first_s2_trial(:, 9)) ...
    mean(last_s2_trial(:, 9)) mean(first_s3_trial(:, 9)) ];
zrt_dynamics_sem_trial = [ std(last_s1_trial(:, 9))/sqrt(length(last_s1_trial(:, 9))) ...
    std(first_s2_trial(:, 9))/sqrt(length(first_s2_trial(:, 9))) ...
    std(last_s2_trial(:, 9))/sqrt(length(last_s2_trial(:, 9))) ...
    std(first_s3_trial(:, 9))/sqrt(length(first_s3_trial(:, 9))) ];



%% plot the coherence change for zscores

figure('name', 'Coherence change plots'); hold on
set(gcf,'color','w');
xspan2 = 1:4;

% by trial
subplot(2,3,1); hold on
plot(xspan2, perf_dynamics_avg_trial, 'marker', '.', 'markersize', 30, 'linestyle', '-', ...
    'lineWidth', 5, 'color', '[0, 0.4470, 0.7410]'); hold on
errorbar(xspan2, perf_dynamics_avg_trial , perf_dynamics_sem_trial, 'linestyle', 'none', ...
    'lineWidth', 2, 'color', 'k');
xlim ([0.75 4.25])
xticks([1 2 3 4]); 
xticklabels ({'', '', '', ''});
yticks([0.4 0.5 0.6 0.7 0.8 0.9 1]);
yticklabels ({'40', '50', '60', '70', '80', '90', '100'});
ylabel('% correct');
set(gca,'fontsize',25);


subplot(2,3,2); hold on
plot(xspan2, zconf_dynamics_avg_trial, 'marker', '.', 'markersize', 30, 'linestyle', '-', ...
    'lineWidth', 5, 'color', '[0.95 0.4 0.2]'); hold on
errorbar(xspan2, zconf_dynamics_avg_trial , zconf_dynamics_sem_trial, 'linestyle', 'none', ...
    'lineWidth', 2, 'color', 'k');
xlim ([0.75 4.25])
xticks([1 2 3 4]);
xticklabels ({'', '', '', ''});
ylabel('zConfidence');
set(gca,'fontsize',25);
title ('Trial-level')


subplot(2,3,3); hold on
plot(xspan2, zrt_dynamics_avg_trial, 'marker', '.', 'markersize', 30, 'linestyle', '-', ...
    'lineWidth', 5, 'color', '[0 0.5000 0]'); hold on
errorbar(xspan2, zrt_dynamics_avg_trial , zrt_dynamics_sem_trial, 'linestyle', 'none', ...
    'lineWidth', 2, 'color', 'k');
xlim ([0.75 4.25])
xticks([1 2 3 4]);
xticklabels ({'', '', '', ''});
ylabel('RT (s)');
set(gca,'fontsize',25);



% by subj

subplot(2,3,4); hold on
plot(xspan2, perf_dynamics_avg_subj, 'marker', '.', 'markersize', 30, 'linestyle', '-', ...
    'lineWidth', 5, 'color', '[0, 0.4470, 0.7410]'); hold on
errorbar(xspan2, perf_dynamics_avg_subj , perf_dynamics_sem_subj, 'linestyle', 'none', ...
    'lineWidth', 2, 'color', 'k');
xlim ([0.75 4.25])
xticks([1 2 3 4]);
ylabel('% correct');
set(gca,'fontsize',25);
xticklabels ({'beforeS2', 'afterS2', 'beforeS3', 'afterS3'});
yticks([0.4 0.5 0.6 0.7 0.8 0.9 1]);
yticklabels ({'40', '50', '60', '70', '80', '90', '100'});
% xticklabels ({'', '', '', ''});
xtickangle(45);

subplot(2,3,5); hold on
plot(xspan2, zconf_dynamics_avg_subj, 'marker', '.', 'markersize', 30, 'linestyle', '-', ...
    'lineWidth', 5, 'color', '[0.95 0.4 0.2]'); hold on
errorbar(xspan2, zconf_dynamics_avg_subj , zconf_dynamics_sem_subj, 'linestyle', 'none', ...
    'lineWidth', 2, 'color', 'k');
xlim ([0.75 4.25])
xticks([1 2 3 4]);
ylabel('zConfidence');
set(gca,'fontsize',25);
xticklabels ({'beforeS2', 'afterS2', 'beforeS3', 'afterS3'});
% xticklabels ({'', '', '', ''});
xtickangle(45);
title('Subject-level')

subplot(2,3,6); hold on
plot(xspan2, zrt_dynamics_avg_subj, 'marker', '.', 'markersize', 30, 'linestyle', '-', ...
    'lineWidth', 5, 'color', '[0 0.5000 0]'); hold on
errorbar(xspan2, zrt_dynamics_avg_subj , zrt_dynamics_sem_subj, 'linestyle', 'none', ...
    'lineWidth', 2, 'color', 'k');
xlim ([0.75 4.25])
xticks([1 2 3 4]);
ylabel('zRT (s)');
set(gca,'fontsize',25);
xticklabels ({'beforeS2', 'afterS2', 'beforeS3', 'afterS3'});
% xticklabels ({'', '', '', ''});
xtickangle(45);

fig = gcf;
fig.PaperUnits = 'inches';
fig.PaperPosition = [0 0 12 6];
print(gcf,'fig3','-dpng','-r300')


%% plot conf across the S1 and S3 for the conf groups

%   subj_mat = [subject stage trial coherence perf conf zconf rt rt ...
%        zstage zcoherence zperf ztrial]; % col8 rt will be zrt

overconf_zrt_trial = []; overconf_zconf_trial = []; overconf_perf_trial = [];
underconf_zrt_trial = []; underconf_zconf_trial = []; underconf_perf_trial = [];


for s = 1:31
    if conf_avg_subj (s,1) < conf_avg_subj (s,3) % overconf
       overconf_zrt_trial = [ overconf_zrt_trial; zrt_trial(s,:) ];
       overconf_zconf_trial = [ overconf_zconf_trial; zconf_trial(s,:) ];
       overconf_perf_trial = [ overconf_perf_trial; perf_trial(s,:) ];
    elseif conf_avg_subj (s,1) > conf_avg_subj (s,3) % underconf
       underconf_zrt_trial = [ underconf_zrt_trial; zrt_trial(s,:) ];
       underconf_zconf_trial = [ underconf_zconf_trial; zconf_trial(s,:) ];
       underconf_perf_trial = [ underconf_perf_trial; perf_trial(s,:) ];
    end
end

for t = 1:240
    mean_overconf_perf_trial(:,t) = nanmean(overconf_perf_trial(:,t));
    mean_overconf_zconf_trial(:,t) = nanmean(overconf_zconf_trial(:,t));
    mean_overconf_zrt_trial(:,t) = nanmean(overconf_zrt_trial(:,t));
    
    std_overconf_perf_trial(:,t) = nanstd(overconf_perf_trial(:,t));
    std_overconf_zconf_trial(:,t) = nanstd(overconf_zconf_trial(:,t));
    std_overconf_zrt_trial(:,t) = nanstd(overconf_zrt_trial(:,t));
    
    mean_underconf_perf_trial(:,t) = nanmean(underconf_perf_trial(:,t));
    mean_underconf_zconf_trial(:,t) = nanmean(underconf_zconf_trial(:,t));
    mean_underconf_zrt_trial(:,t) = nanmean(underconf_zrt_trial(:,t));
    
    std_underconf_perf_trial(:,t) = nanstd(underconf_perf_trial(:,t));
    std_underconf_zconf_trial(:,t) = nanstd(underconf_zconf_trial(:,t));
    std_underconf_zrt_trial(:,t) = nanstd(underconf_zrt_trial(:,t));
    
end

for x = 1:240
    mean_zconf_trial(1,x) = nanmean(zconf_trial(:,x));
    std_zconf_trial(1,x) = nanstd(zconf_trial(:,x));
    
end


xtrial = 1:240

figure; hold on; set(gcf,'color','w');

subplot(3,1,1); hold on

shadedErrorBar(xtrial,smooth(mean_overconf_perf_trial),std_overconf_perf_trial,...
    {'b-o','markerfacecolor','b'}); hold on
shadedErrorBar(xtrial,smooth(mean_underconf_perf_trial),std_underconf_perf_trial,...
    {'r-o','markerfacecolor','r'});
xticks([]);
xlabel('Trial');
ylabel('% correct');
set(gca,'fontsize',25);
% xticklabels ({'S1/S2 switch', 'S2/S3 switch'});

subplot(3,1,2); hold on
shadedErrorBar(xtrial,smooth(mean_overconf_zconf_trial),std_overconf_zconf_trial,...
    {'b-o','markerfacecolor','b'}); hold on
shadedErrorBar(xtrial,smooth(mean_underconf_zconf_trial),std_underconf_zconf_trial,...
    {'r-o','markerfacecolor','r'});
xticks([]);
xlabel('Trial');
ylabel('zConfidence');
set(gca,'fontsize',25);
% xticklabels ({'S1/S2 switch', 'S2/S3 switch'});


subplot(3,1,3); hold on
shadedErrorBar(xtrial,smooth(mean_overconf_zrt_trial),std_overconf_zrt_trial,...
    {'b-o','markerfacecolor','b'}); hold on
shadedErrorBar(xtrial,smooth(mean_underconf_zrt_trial),std_underconf_zrt_trial,...
    {'r-o','markerfacecolor','r'});
xticks([81 161]);
xlabel('Trial');
ylabel('zRT (s)');
set(gca,'fontsize',25);
xticklabels ({'S1/S2 switch', 'S2/S3 switch'});



xtrial2 = 1:80;
figure; hold on; set(gcf,'color','w');

subplot(1,2,1); hold on
shadedErrorBar(xtrial2,smooth(mean_overconf_zconf_trial(:,1:80)), ...
    std_overconf_zconf_trial(:,1:80),...
    {'b-o','markerfacecolor','b'}); hold on
shadedErrorBar(xtrial2,smooth(mean_underconf_zconf_trial(:,1:80)), ...
    std_underconf_zconf_trial(:,1:80),...
    {'r-o','markerfacecolor','r'}); hold on
shadedErrorBar(xtrial2,smooth(mean_zconf_trial(:,1:80)), ...
    std_zconf_trial(:,1:80),...
    {'k-o','markerfacecolor','k'})

xticks([20 40 60]); ylim([-2 2]);
xlabel('S1 - by trial');
ylabel('zConfidence');
set(gca,'fontsize',25);

subplot(1,2,2); hold on
shadedErrorBar(xtrial2,smooth(mean_overconf_zconf_trial(:,161:240)), ...
    std_overconf_zconf_trial(:,161:240),...
    {'b-o','markerfacecolor','b'}); hold on
shadedErrorBar(xtrial2,smooth(mean_underconf_zconf_trial(:,161:240)), ...
    std_underconf_zconf_trial(:,161:240),...
    {'r-o','markerfacecolor','r'}); hold on
shadedErrorBar(xtrial2,smooth(mean_zconf_trial(:,161:240)), ...
    std_zconf_trial(:,161:240),...
    {'k-o','markerfacecolor','k'})



xticks([20 40 60]); ylim([-2 2]);
xlabel('S3 - by trial');
set(gca,'fontsize',25);



figure; hold on
plot(xtrial2,smooth(mean_overconf_zconf_trial(:,161:240)),'r'), hold on
plot(xtrial2,smooth(mean_underconf_zconf_trial(:,161:240)),'b'); hold on
plot(xtrial2,smooth(mean_zconf_trial(:,161:240)),'k');


%% plot coh change for the conf groups

figure('name', 'Coherence change plots'); hold on
set(gcf,'color','w');
xspan2 = 1:4;

perf_dynamics_subj = [ last_s1_avg(:,5) first_s2_avg(:,5) last_s2_avg(:,5) first_s3_avg(:,5) ];
zconf_dynamics_subj = [ last_s1_avg(:,7) first_s2_avg(:,7) last_s2_avg(:,7) first_s3_avg(:,7) ];
zrt_dynamics_subj = [ last_s1_avg(:,9) first_s2_avg(:,9) last_s2_avg(:,9) first_s3_avg(:,9) ];


perf_dynamics_overconf_subj = [];
perf_dynamics_underconf_subj = [];
zconf_dynamics_overconf_subj = [];
zconf_dynamics_underconf_subj = [];
zrt_dynamics_overconf_subj = [];
zrt_dynamics_underconf_subj = [];

% for overconf 
subplot(2,3,1); hold on


for c = 1:length(zconf_avg_subj)
    if zconf_avg_subj(c,1) < zconf_avg_subj(c,3)
    plot(xspan2,perf_dynamics_subj(c,:), 'marker','.','markersize', 15, 'linestyle', '--', ...
        'lineWidth', 1.5, 'color', [0.75 0.75 0.75]), hold on
    perf_dynamics_overconf_subj = [ perf_dynamics_overconf_subj; perf_dynamics_subj(c,:) ];
    end
end
% group data
plot(xspan2, mean(perf_dynamics_overconf_subj), 'marker', '.', 'markersize', 30, 'linestyle', '-', ...
    'lineWidth', 5, 'color', '[0, 0.4470, 0.7410]'); hold on
errorbar(xspan2, mean(perf_dynamics_overconf_subj) , std(perf_dynamics_overconf_subj)/sqrt(length(perf_dynamics_overconf_subj)), ...
    'linestyle', 'none', 'lineWidth', 2, 'color', 'k');

xlim ([0.75 4.25])
xticks([1 2 3 4]); 
xticklabels ({'', '', '', ''});
yticks([0.2 0.4 0.6 0.8 1]);
yticklabels ({'20', '40', '60', '80', '100'});
ylabel('% correct');
set(gca,'fontsize',25);


subplot(2,3,2); hold on

for c = 1:length(zconf_avg_subj)
    if zconf_avg_subj(c,1) < zconf_avg_subj(c,3)
    plot(xspan2,zconf_dynamics_subj(c,:), 'marker','.','markersize', 15, 'linestyle', '--', ...
        'lineWidth', 1.5, 'color', [0.75 0.75 0.75]), hold on
    zconf_dynamics_overconf_subj = [ zconf_dynamics_overconf_subj; zconf_dynamics_subj(c,:) ];
    end
end
% group data
plot(xspan2, mean(zconf_dynamics_overconf_subj), 'marker', '.', 'markersize', 30, 'linestyle', '-', ...
    'lineWidth', 5, 'color', '[0.95 0.4 0.2]'); hold on
errorbar(xspan2, mean(zconf_dynamics_overconf_subj) , std(zconf_dynamics_overconf_subj)/sqrt(length(zconf_dynamics_overconf_subj)), ...
    'linestyle', 'none', 'lineWidth', 2, 'color', 'k');


xlim ([0.75 4.25])
xticks([1 2 3 4]);
xticklabels ({'', '', '', ''});
ylabel('zConfidence');
set(gca,'fontsize',25);
title ('Overconfident group')


subplot(2,3,3); hold on

for c = 1:length(zconf_avg_subj)
    if zconf_avg_subj(c,1) < zconf_avg_subj(c,3)
    plot(xspan2,zrt_dynamics_subj(c,:), 'marker','.','markersize', 15, 'linestyle', '--', ...
        'lineWidth', 1.5, 'color', [0.75 0.75 0.75]), hold on
    zrt_dynamics_overconf_subj = [ zrt_dynamics_overconf_subj; zrt_dynamics_subj(c,:) ];
    end
end
% group data
plot(xspan2, mean(zrt_dynamics_overconf_subj), 'marker', '.', 'markersize', 30, 'linestyle', '-', ...
    'lineWidth', 5, 'color', '[[0 0.5000 0]'); hold on
errorbar(xspan2, mean(zrt_dynamics_overconf_subj) , std(zrt_dynamics_overconf_subj)/sqrt(length(zrt_dynamics_overconf_subj)), ...
    'linestyle', 'none', 'lineWidth', 2, 'color', 'k');


xlim ([0.75 4.25])
xticks([1 2 3 4]);
xticklabels ({'', '', '', ''});
ylabel('zRT (s)');
set(gca,'fontsize',25);



% for underconf

subplot(2,3,4); hold on


for c = 1:length(zconf_avg_subj)
    if zconf_avg_subj(c,1) > zconf_avg_subj(c,3)
    plot(xspan2,perf_dynamics_subj(c,:), 'marker','.','markersize', 15, 'linestyle', '--', ...
        'lineWidth', 1.5, 'color', [0.75 0.75 0.75]), hold on
    perf_dynamics_underconf_subj = [ perf_dynamics_underconf_subj; perf_dynamics_subj(c,:) ];
    end
end
% group data
plot(xspan2, mean(perf_dynamics_underconf_subj), 'marker', '.', 'markersize', 30, 'linestyle', '-', ...
    'lineWidth', 5, 'color', '[0, 0.4470, 0.7410]'); hold on
errorbar(xspan2, mean(perf_dynamics_underconf_subj) , std(perf_dynamics_underconf_subj)/sqrt(length(perf_dynamics_underconf_subj)), ...
    'linestyle', 'none', 'lineWidth', 2, 'color', 'k');


xlim ([0.75 4.25])
xticks([1 2 3 4]);
ylabel('% correct');
set(gca,'fontsize',25);
xticklabels ({'beforeS2', 'afterS2', 'beforeS3', 'afterS3'});
yticks([0.2 0.4 0.6 0.8 1]);
yticklabels ({'20', '40', '60', '80', '100'});
% xticklabels ({'', '', '', ''});
xtickangle(45);

subplot(2,3,5); hold on


for c = 1:length(zconf_avg_subj)
    if zconf_avg_subj(c,1) > zconf_avg_subj(c,3)
    plot(xspan2,zconf_dynamics_subj(c,:), 'marker','.','markersize', 15, 'linestyle', '--', ...
        'lineWidth', 1.5, 'color', [0.75 0.75 0.75]), hold on
    zconf_dynamics_underconf_subj = [ zconf_dynamics_underconf_subj; zconf_dynamics_subj(c,:) ];
    end
end
% group data
plot(xspan2, mean(zconf_dynamics_underconf_subj), 'marker', '.', 'markersize', 30, 'linestyle', '-', ...
    'lineWidth', 5, 'color', '[0.95 0.4 0.2]'); hold on
errorbar(xspan2, mean(zconf_dynamics_underconf_subj) , std(zconf_dynamics_underconf_subj)/sqrt(length(zconf_dynamics_underconf_subj)), ...
    'linestyle', 'none', 'lineWidth', 2, 'color', 'k');

xlim ([0.75 4.25])
xticks([1 2 3 4]);
ylabel('zConfidence');
set(gca,'fontsize',25);
xticklabels ({'beforeS2', 'afterS2', 'beforeS3', 'afterS3'});
% xticklabels ({'', '', '', ''});
xtickangle(45);
title('Underconfident group')

subplot(2,3,6); hold on


for c = 1:length(zconf_avg_subj)
    if zconf_avg_subj(c,1) > zconf_avg_subj(c,3)
    plot(xspan2,zrt_dynamics_subj(c,:), 'marker','.','markersize', 15, 'linestyle', '--', ...
        'lineWidth', 1.5, 'color', [0.75 0.75 0.75]), hold on
    zrt_dynamics_underconf_subj = [ zrt_dynamics_underconf_subj; zrt_dynamics_subj(c,:) ];
    end
end
% group data
plot(xspan2, mean(zrt_dynamics_underconf_subj), 'marker', '.', 'markersize', 30, 'linestyle', '-', ...
    'lineWidth', 5, 'color', '[0 0.5000 0]'); hold on
errorbar(xspan2, mean(zrt_dynamics_underconf_subj) , std(zrt_dynamics_underconf_subj)/sqrt(length(zrt_dynamics_underconf_subj)), ...
    'linestyle', 'none', 'lineWidth', 2, 'color', 'k');


xlim ([0.75 4.25])
xticks([1 2 3 4]);
ylabel('zRT (s)');
set(gca,'fontsize',25);
xticklabels ({'beforeS2', 'afterS2', 'beforeS3', 'afterS3'});
% xticklabels ({'', '', '', ''});
xtickangle(45);

fig = gcf;
fig.PaperUnits = 'inches';
fig.PaperPosition = [0 0 12 6];
print(gcf,'fig3','-dpng','-r300')

%% plot individual data but separate in 2 plots - over- and under-conf

overconf_zconf_subj = []; overconf_perf_subj = []; overconf_zrt_subj = [];
underconf_zconf_subj =[]; underconf_perf_subj = []; underconf_zrt_subj = [];

for j = 1:length(subjects)
    if zconf_avg_subj(j,3) > zconf_avg_subj(j,1)
        overconf_zconf_subj = [ overconf_zconf_subj; conf_avg_subj(j,:) ];
        overconf_perf_subj = [ overconf_perf_subj; perf_avg_subj(j,:) ];
        overconf_zrt_subj = [ overconf_zrt_subj; zrt_avg_subj(j,:) ];
    elseif zconf_avg_subj(j,3) < zconf_avg_subj(j,1)
        underconf_zconf_subj = [ underconf_zconf_subj; conf_avg_subj(j,:) ];
        underconf_perf_subj = [ underconf_perf_subj; perf_avg_subj(j,:) ];
        underconf_zrt_subj = [ underconf_zrt_subj; zrt_avg_subj(j,:) ];
    end
end

figure('name', 'Grand plots - individual data'); hold on
set(gcf,'color','w');

% top panels: overconf; bottom panels: underconf

% OVERCONF
subplot(2,3,1); hold on
% indiv data
for c = 1:length(overconf_zconf_subj)
    plot(xspan,overconf_perf_subj(c,:), 'marker','.','markersize', 15, 'linestyle', '--', ...
        'lineWidth', 1.5, 'color', [0.75 0.75 0.75]), hold on
end
% group data
plot(xspan, mean(overconf_perf_subj), 'marker', '.', 'markersize', 30, 'linestyle', '-', ...
    'lineWidth', 5, 'color', '[0, 0.4470, 0.7410]'); hold on
errorbar(xspan, mean(overconf_perf_subj) , std(overconf_perf_subj)/sqrt(length(overconf_perf_subj)), ...
    'linestyle', 'none', 'lineWidth', 2, 'color', 'k');

xlim ([0.75 3.25]); xticks([1 2 3]);
xticklabels ({'', '', ''});
yticks([0.4 0.5 0.6 0.7 0.8 0.9 1]);
yticklabels ({'40', '50', '60', '70', '80', '90', '100'});
ylabel('% correct'); 
set(gca,'fontsize',25);

subplot(2,3,2); hold on
% indiv data
for c = 1:length(overconf_zconf_subj)
    plot(xspan,overconf_zconf_subj(c,:), 'marker','.','markersize', 15, 'linestyle', '--', ...
        'lineWidth', 1.5, 'color', [0.75 0.75 0.75]), hold on
end
% group data
plot(xspan, mean(overconf_zconf_subj), 'marker', '.', 'markersize', 30, 'linestyle', '-', ...
    'lineWidth', 5, 'color', '[0.95 0.4 0.2]'); hold on
errorbar(xspan, mean(overconf_zconf_subj) , std(overconf_zconf_subj)/sqrt(length(overconf_zconf_subj)), ...
    'linestyle', 'none', 'lineWidth', 2, 'color', 'k');

xlim ([0.75 3.25]); xticks([1 2 3]);
xticklabels ({'', '', ''});
ylabel('zConfidence'); title ('Overconfident group')
set(gca,'fontsize',25);

subplot(2,3,3); hold on
% indiv data
for c = 1:length(overconf_zconf_subj)
    plot(xspan,overconf_zrt_subj(c,:), 'marker','.','markersize', 15, 'linestyle', '--', ...
        'lineWidth', 1.5, 'color', [0.75 0.75 0.75]), hold on
end
% group data
plot(xspan, mean(overconf_zrt_subj), 'marker', '.', 'markersize', 30, 'linestyle', '-', ...
    'lineWidth', 5, 'color', '[0 0.5000 0]'); hold on
errorbar(xspan, mean(overconf_zrt_subj) , std(overconf_zrt_subj)/sqrt(length(overconf_zrt_subj)), ...
    'linestyle', 'none', 'lineWidth', 2, 'color', 'k');

xlim ([0.75 3.25]); xticks([1 2 3]);
xticklabels ({'', '', ''});
ylabel('zRT (s)'); 
set(gca,'fontsize',25);

% UNDERCONF
subplot(2,3,4); hold on
% indiv data
for c = 1:length(underconf_zconf_subj)
    plot(xspan,underconf_perf_subj(c,:), 'marker','.','markersize', 15, 'linestyle', '--', ...
        'lineWidth', 1.5, 'color', [0.75 0.75 0.75]), hold on
end
% group data
plot(xspan, mean(underconf_perf_subj), 'marker', '.', 'markersize', 30, 'linestyle', '-', ...
    'lineWidth', 5, 'color', '[0, 0.4470, 0.7410]'); hold on
errorbar(xspan, mean(underconf_perf_subj) , std(underconf_perf_subj)/sqrt(length(underconf_perf_subj)), ...
    'linestyle', 'none', 'lineWidth', 2, 'color', 'k');

xlim ([0.75 3.25]); xticks([1 2 3]);
xticklabels ({'S1', 'S2', 'S3'});


yticks([0.4 0.5 0.6 0.7 0.8 0.9 1]);
yticklabels ({'40', '50', '60', '70', '80', '90', '100'});


ylabel('% correct'); 
set(gca,'fontsize',25);

subplot(2,3,5); hold on
% indiv data
for c = 1:length(underconf_zconf_subj)
    plot(xspan,underconf_zconf_subj(c,:), 'marker','.','markersize', 15, 'linestyle', '--', ...
        'lineWidth', 1.5, 'color', [0.75 0.75 0.75]), hold on
end
% group data
plot(xspan, mean(underconf_zconf_subj), 'marker', '.', 'markersize', 30, 'linestyle', '-', ...
    'lineWidth', 5, 'color', '[0.95 0.4 0.2]'); hold on
errorbar(xspan, mean(underconf_zconf_subj) , std(underconf_zconf_subj)/sqrt(length(underconf_zconf_subj)), ...
    'linestyle', 'none', 'lineWidth', 2, 'color', 'k');

xlim ([0.75 3.25]); xticks([1 2 3]);
xticklabels ({'S1', 'S2', 'S3'});
ylabel('zConfidence'); 
set(gca,'fontsize',25);
title ('Underconfident group')

subplot(2,3,6); hold on
% indiv data
for c = 1:length(underconf_zconf_subj)
    plot(xspan,underconf_zrt_subj(c,:), 'marker','.','markersize', 15, 'linestyle', '--', ...
        'lineWidth', 1.5, 'color', [0.75 0.75 0.75]), hold on
end
% group data
plot(xspan, mean(underconf_zrt_subj), 'marker', '.', 'markersize', 30, 'linestyle', '-', ...
    'lineWidth', 5, 'color', '[0 0.5000 0]'); hold on
errorbar(xspan, mean(underconf_zrt_subj) , std(underconf_zrt_subj)/sqrt(length(underconf_zrt_subj)), ...
    'linestyle', 'none', 'lineWidth', 2, 'color', 'k');

xlim ([0.75 3.25]); xticks([1 2 3]);
xticklabels ({'S1', 'S2', 'S3'});
ylabel('zRT (s)');
set(gca,'fontsize',25);


fig = gcf;
fig.PaperUnits = 'inches';
fig.PaperPosition = [0 0 12 6];
print(gcf,'fig3','-dpng','-r300')

%% m-ratio dynamics and corr with conf-leak
% m-ratio is calculated using hierarchical linear estimation (Fleming)
% 4 bins of confidence using analogue algorithm 

% m_ratio_confleak_dynamics.csv contains 
% col1: m-ratio overall (4bins, analogue, hmeta)
% col2: d' overall
% col3: metad' overall
% col4: mratio S1
% col5: d' S1
% col6: metad' S1
% col7: mratio S2
% col8: d' S2
% col9: metad' S2
% col10: mratio S3
% col11: d' S3
% col12: metad' S3
% col13: rgrs coeff: perf
% col14: rgrs coeff: zrt
% col15: rgrs coeff: trial
% col16: rgrs coeff: stage
% col17: rgrs coeff: coh
% col18: zconf S1
% col19: zconf S2
% col20: zconf S3
% col21: zrt S1
% col22: zrt S2
% col23: zrt S3
% col24: conf S1
% col25: conf S2
% col26: conf S3
% col27: rt S1
% col28: rt S2
% col29: rt S3
% col30: m-ratio overall (5bins, analogue, hmeta)
% col31: d' overall
% col32: metad' overall
% col33: type 1 c criterion (4bins, analogue, hmeta)

load('m_ratio_confleak_dynamics.csv');
conf_leak = m_ratio_confleak_dynamics;


%% conf diff s1/s2 vs s2/s3

zconf_diff_s2_s1 = conf_leak (:,25)./conf_leak (:,24);
zconf_diff_s3_s1 = conf_leak (:,26)./conf_leak (:,24);

overconf_diff_s2_s1 = [];
overconf_diff_s3_s1 = [];
underconf_diff_s2_s1 = [];
underconf_diff_s3_s1 = [];

figure
set (gcf, 'color', 'w');

for c = 1:length(conf_leak(:,1))
    if conf_leak(c,18) < conf_leak(c,20)
    scatter (zconf_diff_s2_s1(c,1), zconf_diff_s3_s1 (c,1), 70, 'b'), hold on
    overconf_diff_s2_s1 = [ overconf_diff_s2_s1; zconf_diff_s2_s1(c,1) ];
    overconf_diff_s3_s1 = [ overconf_diff_s3_s1; zconf_diff_s3_s1(c,1) ];
    elseif conf_leak(c,18) > conf_leak(c,20)
    scatter (zconf_diff_s2_s1(c,1), zconf_diff_s3_s1 (c,1), 70, 'r'), hold on
    underconf_diff_s2_s1 = [ underconf_diff_s2_s1; zconf_diff_s2_s1(c,1) ];
    underconf_diff_s3_s1 = [ underconf_diff_s3_s1; zconf_diff_s3_s1(c,1) ];
    end
end

xlabel ('zConfidence (S2-S1)');
ylabel ('zConfidence (S3-S1)');
set(gca,'fontsize',25);


% add fitting lines

coeffsXover = polyfit(overconf_diff_s2_s1, overconf_diff_s3_s1, 1);
% Get fitted values
fittedXover = linspace(min(overconf_diff_s2_s1), max(overconf_diff_s2_s1), 200);
fittedYover = polyval(coeffsXover, fittedXover);
% Plot the fitted line
hold on;
plot(fittedXover, fittedYover, 'b-', 'LineWidth', 3);


coeffsXunder = polyfit(underconf_diff_s2_s1, underconf_diff_s3_s1, 1);
% Get fitted values
fittedXunder = linspace(min(underconf_diff_s2_s1), max(underconf_diff_s2_s1), 200);
fittedYunder = polyval(coeffsXunder, fittedXunder);
% Plot the fitted line
hold on;
plot(fittedXunder, fittedYunder, 'r-', 'LineWidth', 3);

% legend ({'Overconfident', 'Underconfident'}, 'location', 'southeast')




%% conf diff s3/s1 vs mratio overall for overconf and underconf groups

conf_diff_s3_s1 = conf_leak (:,20) - conf_leak (:,18);
mratio_overall = conf_leak(:,1);

overconf_diff_s3_s1 = []; overconf_mratio = [];
underconf_diff_s3_s1 = []; underconf_mratio = [];

figure
set (gcf, 'color', 'w');

for c = 1:length(conf_leak(:,1))
    if conf_leak(c,18) < conf_leak(c,20)
    scatter (conf_diff_s3_s1(c,1), mratio_overall (c,1), 70, 'b'), hold on
    overconf_diff_s3_s1 = [ overconf_diff_s3_s1; conf_diff_s3_s1(c,1) ];
    overconf_mratio = [ overconf_mratio; mratio_overall(c,1) ];
    elseif conf_leak(c,18) > conf_leak(c,20)
    scatter (conf_diff_s3_s1(c,1), mratio_overall (c,1), 70, 'r'), hold on
    underconf_diff_s3_s1 = [ underconf_diff_s3_s1; conf_diff_s3_s1(c,1) ];
    underconf_mratio = [ underconf_mratio; mratio_overall(c,1) ];
    end
end

xlabel ('Confidence (S3-S1)');
ylabel ('m-ratio (overall)');
set(gca,'fontsize',25);


% add fitting lines

coeffsXover = polyfit(overconf_diff_s3_s1, overconf_mratio, 1);
% Get fitted values
fittedXover = linspace(min(overconf_diff_s3_s1), max(overconf_diff_s3_s1), 200);
fittedYover = polyval(coeffsXover, fittedXover);
% Plot the fitted line
hold on;
plot(fittedXover, fittedYover, 'b-', 'LineWidth', 3);


coeffsXunder = polyfit(underconf_diff_s3_s1, underconf_mratio, 1);
% Get fitted values
fittedXunder = linspace(min(underconf_diff_s3_s1), max(underconf_diff_s3_s1), 200);
fittedYunder = polyval(coeffsXunder, fittedXunder);
% Plot the fitted line
hold on;
plot(fittedXunder, fittedYunder, 'r-', 'LineWidth', 3);


coeffsXall = polyfit(conf_diff_s3_s1, mratio_overall, 1);
% Get fitted values
fittedXall = linspace(min(conf_diff_s3_s1), max(conf_diff_s3_s1), 200);
fittedYall = polyval(coeffsXall, fittedXall);
% Plot the fitted line
hold on;
plot(fittedXall, fittedYall, 'k-', 'LineWidth', 3);

[x1, y1 ] = corrcoef(overconf_diff_s3_s1, overconf_mratio);
[x2, y2 ] = corrcoef(underconf_diff_s3_s1, underconf_mratio);
[x3, y3 ] = corrcoef(conf_diff_s3_s1, mratio_overall);
%% corr mratio 3bins and conf diff

figure
set (gcf, 'color', 'w');

for c = 1:length(conf_leak(:,1))
     scatter (conf_leak(c,1), zconf_diff_s3_s1 (c,1), 70, 'k'), hold on
end
coeffsXmratio = polyfit(conf_leak(:,1), zconf_diff_s3_s1, 1);
% Get fitted values
fittedXmratio = linspace(min(conf_leak(:,1)), max(conf_leak(:,1)), 200);
fittedYmratio = polyval(coeffsXmratio, fittedXmratio);
% Plot the fitted line
hold on;
plot(fittedXmratio, fittedYmratio, 'k-', 'LineWidth', 3);

xlabel ('m-ratio');
ylabel ('zConfidence (S3-S1)');
set(gca,'fontsize',25);

[Rho,P] = corrcoef(conf_leak(c,1), zconf_diff_s3_s1 (c,1))

%% plot m-ratio by stage for both over and underconf

m_ratio = [ conf_leak(:,1) conf_leak(:,4) conf_leak(:,7) conf_leak(:,10) ];

xaxis_overconf = [1 4 7 10]; xaxis_underconf = [2 5 8 11];
spread_underconf = 0.1*randn(17,1);
spread_overconf = 0.1*randn(14,1);
xaxis_stage_overconf = xaxis_overconf + spread_overconf;
xaxis_stage_underconf = xaxis_underconf + spread_underconf;

overconf_mratio_all = []; underconf_mratio_all = [];

for c = 1:length(conf_leak(:,1))
    if conf_leak(c,18) < conf_leak(c,20)
    overconf_mratio_all = [ overconf_mratio_all; m_ratio(c,:) ];
    elseif conf_leak(c,18) > conf_leak(c,20)
    underconf_mratio_all = [ underconf_mratio_all; m_ratio(c,:) ];
    end
end


figure
set (gcf, 'color', 'w');

for a = 1:length(overconf_mratio_all(:,1))
scatter (xaxis_stage_overconf(a,:), overconf_mratio_all(a,:),  70, 'b'), hold on
end

for b = 1:length(underconf_mratio_all(:,1))
scatter (xaxis_stage_underconf(b,:), underconf_mratio_all(b,:), 70, 'r'), hold on
end


errorbar(mean(xaxis_stage_overconf), mean(overconf_mratio_all), ...
    std(overconf_mratio_all)/sqrt(length(overconf_mratio_all)),'.',...
    'lineStyle', 'none', 'color', 'k', 'lineWidth', 2, 'markerSize', 20); hold on
errorbar(mean(xaxis_stage_underconf), mean(underconf_mratio_all), ...
    std(underconf_mratio_all)/sqrt(length(underconf_mratio_all)),'.',...
    'lineStyle', 'none', 'color', 'k', 'lineWidth', 2, 'markerSize', 20)


set(gca,'fontsize',25);xlim ([0.5 11.5]); 
% ylim ([0 3]);
xticks([1.5 4.5 7.5 10.5]);
xticklabels ({'Overall', 'S1', 'S2', 'S3'});
ylabel('m-ratio');
% legend ({'Overconfident', 'Underconfident'}, 'location', 'northeast')

%% plot d' by stage for both over and underconf

metadprime = [ conf_leak(:,3) conf_leak(:,6) conf_leak(:,9) conf_leak(:,12) ];

xaxis_overconf = [1 4 7 10]; xaxis_underconf = [2 5 8 11];
spread_underconf = 0.1*randn(17,1);
spread_overconf = 0.1*randn(14,1);
xaxis_stage_overconf = xaxis_overconf + spread_overconf;
xaxis_stage_underconf = xaxis_underconf + spread_underconf;

overconf_mratio_all = []; underconf_mratio_all = [];

for c = 1:length(conf_leak(:,1))
    if conf_leak(c,18) < conf_leak(c,20)
    overconf_mratio_all = [ overconf_mratio_all; metadprime(c,:) ];
    elseif conf_leak(c,18) > conf_leak(c,20)
    underconf_mratio_all = [ underconf_mratio_all; metadprime(c,:) ];
    end
end


figure
set (gcf, 'color', 'w');

for a = 1:length(overconf_mratio_all(:,1))
scatter (xaxis_stage_overconf(a,:), overconf_mratio_all(a,:),  70, 'b'), hold on
end

for b = 1:length(underconf_mratio_all(:,1))
scatter (xaxis_stage_underconf(b,:), underconf_mratio_all(b,:), 70, 'r'), hold on
end


errorbar(mean(xaxis_stage_overconf), mean(overconf_mratio_all), ...
    std(overconf_mratio_all)/sqrt(length(overconf_mratio_all)),'.',...
    'lineStyle', 'none', 'color', 'k', 'lineWidth', 2, 'markerSize', 20); hold on
errorbar(mean(xaxis_stage_underconf), mean(underconf_mratio_all), ...
    std(underconf_mratio_all)/sqrt(length(underconf_mratio_all)),'.',...
    'lineStyle', 'none', 'color', 'k', 'lineWidth', 2, 'markerSize', 20)


set(gca,'fontsize',25);xlim ([0.5 11.5]); 
% ylim ([0 3]);
xticks([1.5 4.5 7.5 10.5]);
xticklabels ({'Overall', 'S1', 'S2', 'S3'});
ylabel('metad-prime');
%% m-ratio box plot


xaxis_bar = 1:4;
spread = 0.1*randn(31,1);
xaxis_stage = xaxis_bar+spread;


figure
set (gcf, 'color', 'w');

avg_mratio_barplot_input = mean(m_ratio);
sem_mratio_errorbar_input = [ std(m_ratio(:,1))/sqrt(length(m_ratio(:,1))) ...
    std(m_ratio(:,2))/sqrt(length(m_ratio(:,2))) ...
    std(m_ratio(:,3))/sqrt(length(m_ratio(:,3))) ...
    std(m_ratio(:,4))/sqrt(length(m_ratio(:,4))) ];


% plot barplot
b = bar(xaxis_bar, avg_mratio_barplot_input, 'FaceColor','flat', 'LineWidth', 1), hold on

b.CData(1,:) = [0.95 0.95 0.95];
b.CData(2,:) = [0.5 0.5 0.5];
b.CData(3,:) = [0.75 0.75 0.75];
b.CData(4,:) = [0.5 0.5 0.5];

% add errorbars to barplot
h = errorbar(xaxis_bar, avg_mratio_barplot_input, sem_mratio_errorbar_input,'.',...
    'lineStyle', 'none', 'color', 'k', 'lineWidth', 3, 'markerSize', 15); hold on

% add indiv data
for k = 1:length(m_ratio(:,1))
    scatter(xaxis_stage(k,:), m_ratio(k,:), 105, 'k'); hold on
end

set(gca,'fontsize',25);
xlim ([0.5 4.5]); 
ylim ([-1 3]);
xticks([1 2 3 4]);
xticklabels ({'Overall', 'S1', 'S2', 'S3'});
ylabel('m-ratio');
