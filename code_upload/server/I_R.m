function I_R(ipar)
loaddata;
R=zeros(N,2000);
K=round((N-433)*ipar*0.05);
for itera=1:10
    p=randperm(N-433,K)+433;
    rsq = zeros(N, 1); % node-wise R vector
    for jj = 1:N    
        y = fc(:, jj);   
        x1 = zscore(BEC_sort(:,[2:14,p]));  
        lm = fitlm(x1, y, 'Exclude', jj);
        rsq(jj) = lm.Rsquared.Ordinary;
    end
    R(:,itera+ipar*100)=sqrt(rsq);
end
dic=fullfile(pwd,['par',num2str(ipar),'I_R.mat']);
save(dic,'R');
end
%end