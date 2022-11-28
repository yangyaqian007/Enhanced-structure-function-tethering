function null_distribution_Sc(ipar)  %itera=20
%% randomize the SC (maintain degree)
loaddata1;
nR_Sl=zeros(N,10000);                 % result: null R distribution of low frequency in randomized Sc
nR_Sh=zeros(N,10000);

for itera=1+(ipar-1)*500:ipar*500
    % R is random graph with preserved degree distribution
    [R,~] = randmio_und_connected(W, 10); 

    A=R;A=-A;
    for i=1:N
    A(i,i)=-sum(A(i,:));
    end
    B=A/max(eig(A));   % structural Laplacian matrix
    [BECR,BER]=eig(B);   % BEC-eigenvectors, BE-eigenvalues
    [a,b]=sort(diag(BER));
    a(a<0)=0;
    BE_sortR=diag(a);
    BEC_sortR=BECR(:,b);

    rsql = zeros(N,1);rsqh=zeros(N,1); % node-wise $R^2$ vector 
    for jj = 1:N    
        y = fc(:, jj);   
        xl = zscore(BEC_sortR(:,2:14));     
        lml = fitlm(xl, y, 'Exclude', jj);
        rsql(jj) = lml.Rsquared.Ordinary; % record adjusted R-square for parcellation ii, node jj
        xh = zscore(BEC_sortR(:,434:N));
        lmh = fitlm(xh, y, 'Exclude', jj);
        rsqh(jj) = lmh.Rsquared.Ordinary;
    end
    nR_Sl(:,itera)=sqrt(rsql);
    nR_Sh(:,itera)=sqrt(rsqh);
end
%save nR_Sl, nR_Sh
dic=fullfile(pwd,['par',num2str(ipar),'null_distribution_Sc.mat']);
save(dic,'nR_Sl','nR_Sh');
end
