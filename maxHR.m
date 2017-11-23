
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
% As part of this test, your goal is to estimate the maximum heart rate
% (MAX_HR) of a runner based on his measured heart rate (HR) during a
% single run. Note that during a run, a runner’s HR will likely not reach
% its maximum value. A runner might be running at 140 during a run but
% his maximum heart rate might be much higher. The idea is to estimate heart rate
% variability (HRV) during the run and based on this measure, estimate MAX_HR.

% HRV is the variation of HR between heartbeats. HRV is expected to be high
% before the run, when the runner is at rest, and is expected to go down
% when the runner starts running. The hypothesis is that the HR is maximum
% when HRV is near 0. HRV is best measured when the HR is stable and
% when there is no variation in activity.

% For example, in the following file, we clearly see HRV of a runner at
% rest. We can see that his HR varies approximately between 66 to 82 heart
% beats per minute:
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
% figure
% hist(hr(:,2))
% But in the following file, the user is starting to run:

hr = csvread('exampleRun.csv');
figure; plot(hr(:, 1), hr(:, 2), 'r+'); 
xlabel('Time, sec'); ylabel('HR'); title('exampleRun');

% figure
% hist(hr(:,2))
% During the first 80 seconds, his HR climbs to around 120. This climb
% should not be confused with HRV (even if there is HRV present inside the
% climb). After the climb, you can observe HRV, the HR varies approximately
% between 119 and 127 beats per minute.

% We have provided HR data for two runners (3 runs each). The HR provided
% was cleaned and as a result there might be gaps between some HR. The HR
% might still be noisy but you should not spend time trying to further
% filter the HR signal to remove noise.

% Please detail your initial plan and all steps taken to reach the final solution,
% all intermediate solutions and what needed to be improved.

% For every version of your solution:
% - What is the goal of this version?
% - Give the maximum HR for every file, if available.
% - Keep a copy of this test.m file.
% - You can also save plots if they help to describe your solution.
% - Why did you get this result, what does it mean?

% You should use a single file (from a single run) to estimate a maximum
% HR. But you can use the knowledge of all files to improve your solution.
% For example, if your algo calculates a maximum HR of 150 with one file,
% but other files seem to indicate that the max is higher, you can revise
% your algo to improve it.

% Spend no more than 2 hours on the problem. There are no perfect
% solutions. We are interested in your thought process as much as your
% solution. Start the timer once you have understood the examples, seen all
% the runs by running this program and made a first plan of work. Please
% also include your plan of work. Your plan can change as you compute
% results. 

% If you had more time, what else would you try?

% You can also implement your algo in C if you prefer.

% At the end of the test, please send back all the different Matlab files,
% answers to the questions and results (graph + max HR) if any.

filenames = { 'user1Run1.csv' 'user1Run2.csv' 'user1Run3.csv' ...
              'user2Run1.csv' 'user2Run2.csv' 'user2Run3.csv' };

for i = 1 : numel(filenames)
    
    hr = csvread(filenames{i});
    % hr(:, 1) will contain the number of seconds since the start of the run
    % hr(:, 2) will contain the HR at that time
    
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

% figure
% hist(hr(:,2))
% figure
% plot(hr(:,1),y1-hr(:,2))
    % rint the index associated to maxHR
    printf('Maximum HR  measured at index: %.1f\n\n', Indx(cnt)  );
    printf('-----------------------------------------------------')
    hold on;
    % plot in a green circle the position of max HR
    h = plot(hr(Indx(cnt),1), hr(Indx(cnt),2),'ko');
   
    set(h,{'markers'},{30})  
end
