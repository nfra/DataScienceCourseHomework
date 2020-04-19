Exercise 2
================

### Question 1

We can’t simply run the regression of “crime” on “police” to estimate
the effect of the number of police on the crime rate because the
selection of policing level is endogenous. That is, governmental
decision-makers can and do decide how much money to spend on policing in
a locality based on its crime rate.

The ability to select the level of policing introduces selection bias
that prevents a consistent estimate of the effect of policing on crime.

### Question 2

In the 2005 article “Using Terror Alert Levels to Estimate the Effect of
Police on Crime”, Jonathan Klick and Alexander Tabarrok were able to
isolate the effect of policing on crime by identifying and examining a
situation in which the number of police in a locality is changed for
reasons unrelated to crime in that area. They identified just such a
situation: Washington, D.C., during a heightened terrorism alert level.
By law, if the Homeland Security Advisory System increases the
color-coded terrorism threat advisory scale to “orange”, extra police
officers are placed on the National Mall and throughout the rest of
Washington.

The researchers then examined what happens to street crime when the
number of police is increased during these periods of orange-alert. They
found that the rate of things like murder, robbery, and assault
decreased. Referring to the first column of the table (reproduced from
the paper) below, we can see the surge of police on crime is estimated
to have reduced the daily number of crimes in Washington by about 7 (not
controlling for variation in METRO ridership).

![Table 2](../../figures/ex3table2.png)

### Question 3

The paper in question used an “instrumental variable” (IV) research
design, where the instrument is whether the day had a high alert. One
assumption that must be true for an IV research design to consistently
estimate a causal effect is the “exclusion restriction” – that is, there
can be no direct effect of the instrument on the dependent variable or
any effect running through omitted variables.

In this case, one can hypothesize that the instrument may have an effect
running through an omitted variable. If the high alert reduces the
number of tourists in Washington, it may suppress crime by diminishing
the pool of possible victims. Klick and Tabarrok use Metro ridership as
a measure of tourism, and control for that in the second column of the
table above. The causal estimate is reduced in that regression to a
decrease of about 6 in the number of crimes per day.

In their paper, Klick and Tabarrok actually argue against the idea that
they have to control for Metro ridership:

> “We are skeptical of the latter explanation on theoretical grounds
> because holding all else equal, daily crime is unlikely to vary
> significantly based on the number of daily visitors. The vast majority
> of visitors to Washington D.C. are never the victim of a crime. Since
> there are far more visitors than crimes it seems unlikely that the
> number of visitors constrains the number of crimes.”

### Question 4

The model being estimated in the first column of the table below allows
for the effect of policing to vary between District 1 (home to the
city’s business and political center) and the rest of Washington, also
controlling for Metro ridership. It uses heteroskedasticity-robust (or
White-Huber) standard errors. The estimate from this model is that the
extra policing reduces the number of daily crimes by about 2.6.

![Table 4](../../figures/ex3table4.png)
