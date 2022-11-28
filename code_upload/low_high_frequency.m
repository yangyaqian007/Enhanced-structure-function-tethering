% compare low-high frequency
loaddata;load('matlab.mat');   % rsql,rsqh,rsqt

uni=find(xx<0);                % uni node id
trans=find(xx>0);

uni_O=mean(rsql(uni));         % original R
uni_T=mean(rsqt(uni));         % total R
uni_I=uni_T-uni_O;             % increased R
uni_IP=uni_I/uni_O;            % increased percence of R

trans_O=mean(rsql(trans));
trans_T=mean(rsqt(trans));
trans_I=trans_T-trans_O;
trans_IP=trans_I/trans_O;

% after adding high-frequecny, the prediction accuracy is significantly increased
[H,P,~]=ttest2(rsql(uni),rsqt(uni));
[H,P,~]=ttest2(rsql(trans),rsqt(trans));


%% fig-1
c=[0,121,187;223 59 44]/255;

figure;
violinplot([rsql(uni),rsqt(uni)],{'low','total'},'QuartileStyle','boxplot', ...
    'Width',0.2,'BoxColor',[0.3 0.3 0.3]);
hold on
violinplot([rsql(trans),rsqt(trans)],{'low','total'},'QuartileStyle','boxplot', ...
    'Width',0.2,'BoxColor',[0.3 0.3 0.3]);
ylabel('R');
%xlim([0.5 2.5]);ylim([-0.25 0.75])

%% fig-2
% run 'par_I_R.m' in the server for paralell computing
% results are saved in the ..\server\result
R=zeros(N,2000);  
for ipar=1:19
    dich=fullfile(pwd,'server','result',['par',num2str(ipar),'I_R.mat']);
    temp=load(dich);
    R=R+temp.R;
end
R1=zeros(N,2001);
R1(:,100)=rsql;
for i=1:19
R1(:,1+i*100:100+i*100)=R(:,100*i+1:100*i+100);
end
R1(:,2001)=rsqt;

R2=R1(:,100:end);                        % R2(:,1) is original, R2(:,end) is total
R_uni=mean(R2(xx<0,:));                 % seperate R2 into uni and trans and compute mean
R_trans=mean(R2(xx>0,:));
RIP_uni=(R_uni-R_uni(:,1))/R_uni(:,1)*100;
RIP_trans=(R_trans-R_trans(:,1))/R_trans(:,1)*100;
RIP_uni1=reshape(RIP_uni(2:end-1),100,19);
RIP_trans1=reshape(RIP_trans(2:end-1),100,19);
mR_uni=[RIP_uni(1),mean(RIP_uni1),RIP_uni(end)];
mR_trans=[RIP_trans(1),mean(RIP_trans1),RIP_trans(end)];
sR_uni=[0,std(RIP_uni1),0];
sR_trans=[0,std(RIP_trans1),0];

figure;
X=repmat((0:5:100)',1,2);
Y=[mR_uni',mR_trans'-mR_uni'];
a=area(X,Y);
a(1).FaceColor=[222 235 247]/255;
a(2).FaceColor=[251 229 214]/255;
hold on;plot(0:5:100,mR_uni,'-','LineWidth',2,'Color',[0,121,187]/255);
hold on;plot(0:5:100,mR_trans,'-','LineWidth',2,'Color',[223 59 44]/255);
hold on;plot(0:5:100,mR_uni-sR_uni,'--','LineWidth',2,'Color',[0,121,187]/255);
hold on;plot(0:5:100,mR_uni+sR_uni,'--','LineWidth',2,'Color',[0,121,187]/255);
hold on;plot(0:5:100,mR_trans-sR_trans,'--','LineWidth',2,'Color',[223 59 44]/255);
hold on;plot(0:5:100,mR_trans+sR_trans,'--','LineWidth',2,'Color',[223 59 44]/255);

%% fig-3
load('rsn_mapping.mat');
R_name=rsn_names;                         % summerized region name 
R_n=length(R_name);                       % total region number
Rn_Ind=rsn_mapping{ii};                   % R_name index for each node
Rn_name=cell(N,1);                        % R_name for each node
for i=1:R_n
    Rn_name(Rn_Ind==i)=R_name(i);
end

R_IP=(rsqt-rsql)./rsql;                    % increased percent
[a,b]=sort(R_IP,'descend');
a=a(1:100);b=b(1:100);                     % extract the top 100

Regions=categorical(Rn_name(b));
dumdum = dummyvar(Regions);
categories(Regions);sum(dumdum);

% colormap
mycolorpoint=[[232 36 37];[235 233 81]]/255; % red to yellow
mycolorposition=[1 length(b)];
mycolormap_r=interp1(mycolorposition,mycolorpoint(:,1),1:length(b),'linear','extrap');
mycolormap_g=interp1(mycolorposition,mycolorpoint(:,2),1:length(b),'linear','extrap');
mycolormap_b=interp1(mycolorposition,mycolorpoint(:,3),1:length(b),'linear','extrap');
C=[mycolormap_r',mycolormap_g',mycolormap_b'];%color

figure
x=coor(:,1);y=coor(:,2);z=coor(:,3);
S=ones(N,1)*100;                    % size
C1=ones(N,3)*175/255;               % all nodes are grey
x2=x(b);y2=y(b);z2=z(b);
S2=S(b)*2;
scatter3(x,y,z,S,C1,'filled','MarkerFaceAlpha',0.4);hold on;
scatter3(x2,y2,z2,S2,C,'filled');set(gca,'YDir','reverse')
colormap(C);
%axis off 

tmp=LauConsensus.Matrices{5,5}(:,4);
tmp1=zeros(N,1);
for i=1:N
    if tmp{i}=='rh'
        tmp1(i)=1;
    elseif tmp{i}=='lh'
        tmp1(i)=-1;
    end
end
r=find(tmp1==1);
x=coor(r,1);y=coor(r,2);z=coor(r,3);
S=ones(length(r),1)*100;                    % size
C1=ones(length(r),3)*175/255;               % all nodes are grey
figure;
scatter3(x,y,z,S,C1,'filled','MarkerFaceAlpha',0.4);hold on;
cr=find(b<=501);
scatter3(x2(cr),y2(cr),z2(cr),S2(cr),C(cr),'filled');set(gca,'YDir','reverse')
colormap(C);
title('rh');

l=find(tmp1==-1);
x=coor(l,1);y=coor(l,2);z=coor(l,3);
S=ones(length(l),1)*100;                    % size
C1=ones(length(l),3)*175/255;               % all nodes are grey
figure;
scatter3(x,y,z,S,C1,'filled','MarkerFaceAlpha',0.4);hold on;
cl=find(b>501);
scatter3(x2(cl),y2(cl),z2(cl),S2(cl),C(cl),'filled');set(gca,'YDir','reverse')
colormap(C);
title('lh');



