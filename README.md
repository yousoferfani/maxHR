# maxHR
maximum heart rate estimation from noisy data

Yousof Erfani : 19 June 2017

The  code to compute the (HRmax) max heart rate:
Below is my analysis  for my  approach:

1. As the data is noisy, I first estimate a polynomial fit (or any other better fitting method)  to the data, in this case the effect of the noise of recording is reduced (The blue lines).

2. Also, the heart rate signal is not stationary so  the heart rate variability is changing during the time. So,  I estimated the short term variance of hr signals for short intervals (npadd variable  , defualt =  100,  still to  play with).

In this case, if there are a lot of variation on the signal in a short time, I ignore those segments with high short time variance 
when computing the hrMax.

3. I  computed the  polynomial fitted values  + 3*  short time standard deviation  for 2* npad time samples around each time sample  
I have plotted this in magenta color.

4. Max of the plot in  magenta color is the estimated hrMax if the variance  smaller than a threshold (here Th =5 ),
 The place of the estimation for hrMAx is shown by a black circle.

The value of the maxHR estimation is shown in the command window after running the function.
 For each runner the estimate of the maxHR can be the average of all estimations.

If I had more time:
1 would try to remove outliers using more domain knowledge.
 I will denoise the hrSignals more  using digital filtering

I will search more on the internet for efficient hr variability measuring from the data.  
I will play more with the parameters I introduced to find  the best estimate of the maxHR



--------- A sample results
npolyfit =  50
Th_variance =  5

Maximum HR for user1Run1.csv is 176.7

my estimatred  Maximum HR for user1Run1.csv is 172.5

Maximum HR  measured at index: 3591.0


------------------------------------
my estimatred  Maximum HR for user1Run2.csv is 163.5

Maximum HR  measured at index: 1575.0

------------------------------------
Maximum HR for user1Run3.csv is 173.0

my estimatred  Maximum HR for user1Run3.csv is 168.7

Maximum HR  measured at index: 4099.0

-------------------------------------

Maximum HR for user2Run1.csv is 140.4

my estimatred  Maximum HR for user2Run1.csv is 137.0

Maximum HR  measured at index: 4484.0

------------------------------------

Maximum HR for user2Run2.csv is 154.2

my estimatred  Maximum HR for user2Run2.csv is 150.2

Maximum HR  measured at index: 6364.0

------------------------------------
Maximum HR for user2Run3.csv is 160.0

my estimatred  Maximum HR for user2Run3.csv is 159.3

Maximum HR  measured at index: 8668.0



