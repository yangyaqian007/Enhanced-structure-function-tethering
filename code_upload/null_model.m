
%% randomize the SC (maintain degree)
% run 'par_null_distriubtion_Sc.m' in the server for paralell computing
% results are saved in the ..\server\result
nR_Sh=zeros(N,10000);  
nR_Sl=zeros(N,10000);  
for ipar=1:20
    dich=fullfile(pwd,'server','result',['par',num2str(ipar),'null_distribution_Sc.mat']); 
    temp=load(dich);
    nR_Sh=nR_Sh+temp.nR_Sh;
    nR_Sl=nR_Sl+temp.nR_Sl;
end

%% randomize the geometry
load('matlab.mat'); % rsql,rsqh,rsqt
load('permid.mat'); % the results of spin tests
nR_Ll=zeros(N,10000);
nR_Lh=zeros(N,10000);
for itera = 1:10000
    p = perm_id(:,itera);
    % dummy-code permuted community assignments
    nR_Ll(:,itera) = rsql(p);
    nR_Lh(:,itera) = rsqh(p);
end


%% F3: calculate the null distribution of G-R
nR1=nR_Ll;nR2=nR_Lh; % change for different null model
%%%%%%%%%%%
RL=zeros(10000,1);RH=zeros(10000,1);
for itera=1:10000
yl=nR1(:,itera);
yh=nR2(:,itera);
[rhol, pl] = corr(xx, yl);
[rhoh, ph] = corr(xx, yh); 
RL(itera)=rhol;
RH(itera)=rhoh;
end

rhol=-0.5569;rhoh=0.5134;
figure;
h=histogram(RL,'Normalization','probability','EdgeColor','#0072BD');hold on;
plot([rhol rhol],[0 max(h.Values)],'LineWIdth',2);
xlabel('R-G correlation');ylabel('frequency');title('low frequency');yticklabels(yticks*100);
b=h.BinEdges;
xl=(b(1:end-1)+b(2:end))/2;
pl=h.Values*100;
figure;
h=histogram(RH,'Normalization','probability','EdgeColor','#0072BD');hold on;
plot([rhoh rhoh],[0 max(h.Values)],'LineWIdth',2);
xlabel('R-G correlation');ylabel('frequency');title('high frequency');yticklabels(yticks*100);
b=h.BinEdges;
xh=(b(1:end-1)+b(2:end))/2;
ph=h.Values*100;
