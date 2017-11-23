
% Yousof Erfani : 19 June 2017

% The  code to compute the HRmax max heart rate:
%Below is my analysis  for my  approach:
%
%1. As the data is noisy, I first estimate a polynomial fit (or any other better fitting method)  to the data, in this case the effect of the noise of recording 
% is reduced (The blue lines).
%
%2. Also, the heart rate signal is not stationary so  the heart rate variability is changing during the time. So,  I estimated the short term variance of hr signals for short intervals (npadd variable  , defualt =  100,  still to  play with).
%
% In this case, if there are a lot of variation on the signal in a short time, I ignore those segments with high short time variance 
%  when computing the hrMax.
%
%3. I  computed the  polynomial fitted values  + 3*  short time standard deviation  for 2* npad time samples around each time sample  
%I have plotted this in magenta color.
%
%4. Max of the plot in  magenta color is the estimated hrMax if the variance  smaller than a threshold (here Th =5 ),
% The place of the estimation for hrMAx is shown by a black circle.
%
%The value of the maxHR estimation is shown in the command window after running the function.
% For each runner the estimate of the maxHR can be the average of all estimations.
%
%If I had more time:
%1 would try to remove outliers using more domain knowledge.
% I will denoise the hrSignals more  using digital filtering
%
%I will search more on the internet for efficient hr variability measuring from the data.  
%I will play more with the parameters I introduced to find  the best estimate of the maxHR


function test()
% Estimating the maximum heart rate
% (MAX_HR) of a runner based on his measured heart rate (HR) during a
% single run. Note that during a run, a runner’s HR will likely not reach
% its maximum value. A runner might be running at 140 during a run but
% his maximum heart rate might be much higher. The idea is to estimate heart rate
% variability (HRV) during the run and based on this measure, estimate MAX_HR.

close all
clc
clear all

% the degree of polynomial fitting 
npolyfit = 50

% Threshold for short time variance, a sample with a variance higher than this threshold is excluded  for Hr Max estimation 
Th_variance = 5

% number of time samples around each sample of the hr signal to find short time  variance
npadd = 100;

hr = csvread('exampleRest.csv');
figure; plot(hr(:, 1), hr(:, 2), 'r+'); 
xlabel('Time, sec'); ylabel('HR'); title('exampleRest');

hr = csvread('exampleRun.csv');
figure; plot(hr(:, 1), hr(:, 2), 'r+'); 
xlabel('Time, sec'); ylabel('HR'); title('exampleRun');

filenames = { 'user1Run1.csv' 'user1Run2.csv' 'user1Run3.csv' ...
              'user2Run1.csv' 'user2Run2.csv' 'user2Run3.csv' };

for i = 1 : numel(filenames)    
    hr = csvread(filenames{i});   
    % To view:
    figure; plot(hr(:, 1), hr(:, 2), 'r+');
    xlabel('Time, sec'); ylabel('HR'); title(filenames{i});

    % Compute your maximum HR here 
    % for example, a very bad solution could be:
    maxHR = prctile(hr(:, 2), 99) + 10;    
    
    % poly nomial fit of the hr 
    p = polyfit(hr(:,1),hr(:,2),npolyfit);
    polyn_fit = polyval(p,hr(:,1));
    hold on;plot(hr(:,1),polyn_fit)

    % zero padd the signal at the neginig and end to find the short time variace for all the hr signal
    padded_hr = [ hr(1,2)*ones(npadd,1); hr(:,2); hr(end,2)*ones(npadd,1) ];  
    
    % find the short time variance for the hr 
    shortime_variance = zeros(1, length(hr(:,2)));
    for  j =1:  length(hr(:,2))
        shortime_variance(j)  = sum((padded_hr(j:1:j+2*npadd) - mean (padded_hr(j:j+2*npadd))).^2 )/(2*npadd);
    end
    
    length( shortime_variance);
    length (hr(:,1));
    length (hr(:,2));
    
   % Estimate the max Hr from the polyfit + 3* std
    estim_mxHr =  polyn_fit'+ 3*sqrt(shortime_variance);  
    hold on ;plot(hr(:,1),estim_mxHr,'m')
    
    % better visuaization using axis
    axis([min(hr(:,1)),max(hr(:,1)), min(hr(:,2)),max(hr(:,2))+10])
    fprintf('Maximum HR for %s is %.1f\n\n', filenames{i}, maxHR);    
    % sort all the values for the maxHr
    [estim_mxHr, Indx] = sort (estim_mxHr,'descend');
    cnt =1;
    % selec the max value with the condition that  we do not have too much short time variance
    while ((shortime_variance(Indx(cnt)))>Th_variance)    
          cnt =cnt+1;          
          end
    % find and  print mys estimation of mxHr      
    mymaxHR = estim_mxHr(cnt);   
    printf('my estimatred  Maximum HR for %s is %.1f\n\n', filenames{i}, mymaxHR );
    printf('Maximum HR  measured at index: %.1f\n\n', Indx(cnt)  );
    printf('-----------------------------------------------------')
    hold on;
    % plot in a green circle the position of max HR
    h = plot(hr(Indx(cnt),1), hr(Indx(cnt),2),'ko');
   
    set(h,{'markers'},{30})  
end
