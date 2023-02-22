load doublependulumdata(1).mat
load desiredtrajecotry(3).mat
ds = 1:10:length(q); %%Down sample 
qone = q(ds,1);
qtwo = q(ds,2);
qoneD = qDot(ds,1);
qtwoD = qDot(ds,2);
qoneDD = qDDot(ds,1);
qtwoDD = qDDot(ds,2);
desired1 = tau(ds,1);
desired2 = tau(ds,2);
x = [qone qtwo qoneD qtwoD qoneDD qtwoDD]';
p1 = 20;
p2 = [30 50 100];
for i=1:length(p2)
P2= p2(i);
[predicted_tor,RMS_error1(i),RMS_error2(i)] = LOOCVgpr(x,p1,P2,desired1,desired2);

% disp(RMS_error2(i))
predicted1 = predicted_tor(:,1);
predicted2 = predicted_tor(:,2);
end
display(['LOOCV RMS error for p = 30 is ',num2str(RMS_error2(:,1))]);
display(['LOOCV RMS error for p = 50 is ',num2str(RMS_error2(:,2))]);
display(['LOOCV RMS error for p = 100 is ',num2str(RMS_error2(:,3))]);

subplot(2,2,1)
plot(predicted1,'r')
hold on 
plot(desired1,'b');
legend({'predicted 1','desired 1'},'Location','southeast');
subplot(2,2,2)
plot(predicted2,'r')
tt00 = title('Predicted torque Vs actual torques');
tt00.FontSize = 09;
hold on
plot(desired2,'b');
legend({'predicted 2','desired 2'},'Location','best');
tt1 = title('predicted torque Vs actual torques');
tt1.FontSize = 09;
hold off

function [predicted_tor,RMS_error1,RMS_error2] = LOOCVgpr(x,p1,p2,t1,t2)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%inputs
%input training data x=link, velocity , acc.
% t1 & t2 = given torqs
% p1 & p2 are Hyper Parameters 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% covXstarX is the covariance of training data with query (Xstar)
% covXX is covariance of trainig data with training data(XX)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% outputs 
% predicted_tor is preditected torques using LOOCV Gaussian process regression  
% RMS_error is RMS error of Predicted torque and given data
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
N=length(x);
 a=2*p2^2;
for qq = 1:N
    xstar1 = x(:,qq);
    for f = 1:N-1
        XX = x;
        XX(:,qq) = [];
        s(qq,f) = (xstar1-XX(:,f))'*(xstar1-XX(:,f))/a;
        covXstarX(qq,f) = p1*exp(s(qq,f));
    end
    for hh = 1:N-1
        for ih = 1:N-1
            c(hh,ih) = ((XX(:,hh) - XX(:,ih))'*(XX(:,hh) - XX(:,ih)))/a;
            covXX(hh,ih) = p1*exp(c(hh,ih));
        end
    end
    cZ = pinv(covXX + eye(N-1));
    tt1 = t1;
    tt1(qq,:) = [];
    tau1 = tt1;
    tt2 = t2;
    tt2(qq,:) = [];
    tau2 = tt2;
    predicted_tor(qq,1) = covXstarX(qq,:)*cZ*tau1; % regression happens prd. tau(1)
    predicted_tor(qq,2) = covXstarX(qq,:)*cZ*tau2; % regression happens prd. tau(2)
end 
RMS_error1 = abs(sqrt((predicted_tor(:,1)-t1)'*(predicted_tor(:,1)-t1))/N);
RMS_error2 = abs(sqrt((predicted_tor(:,2)-t2)'*(predicted_tor(:,2)-t2))/N);

end


