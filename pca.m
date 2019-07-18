clear all
close all
clc
%%

load threes -ascii

n_tr=499; %number of training images
Xtrain=threes(1:n_tr,:);    %nTrain*R , (R=w*h)
Xtest=threes(n_tr+1:end,:);

%display training image
% colormap('gray'),imagesc(reshape(Xtrain(2,:),16,16),[0,1])

M = mean(Xtrain);           %1*R
colormap('gray'),imagesc(reshape(M,16,16),[0,1]), title('Mean image'), axis off
c=cov(Xtrain);              %R*R
% K=256;                        %num of top vec/val
k=[1:256];
% k=[1,5,10,20,50,100,256]
figure
for i=1:length(k)
    K=k(i)
    [vec,val]=eigs(c,K);        %vec=R*K
    %projection
    omega=vec'*Xtest';          %omega=K*nTest
%     projected=bsxfun(@plus,(vec*omega)',M);    %R*nTest
    projected=(vec*omega)';    %nTest*R
    %see results
%     subplot(1,length(k),i)
%     colormap('gray'),imagesc(reshape(projected(1,:),16,16),[0,1])
%     title(['K:',num2str(K)])
%     axis off
%     MAE=zeros(1,size(Xtest,1));
%     for j=1:size(Xtest,1)
%         err=Xtest(j,:)-projected(j,:);
%         MAE(j)=mae(err);
%     end
%     avg_error = mean(MAE)    
%     err=Xtest(1,:)-projected(0,:);
%     MAE=mae(err);
    err(i) = immse(Xtest(1,:), projected(1,:));
%     title(['e:',num2str(MAE)])
end
%%
plot(k,err,'r-')
hold on
plot(diag(val))
hold off
xlim([0,256])
xlabel('number of components')
ylabel('MSE')
title('Reconstruction Error')
% figure
% MAE=zeros(1,size(Xtest,1));
% for i=1:size(Xtest,1)
%     err=Xtest(i,:)-projected(i,:);
%     MAE(i)=mae(err);
% end
% %%
% avg_error = mean(MAE)
