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

“How were the researchers from UPenn able to isolate this effect?
Briefly describe their approach and discuss their result in the “Table
2” below, from the researchers’ paper."

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
decreased. Referring to the table (reproduced from the paper) below, we
can see the surge of police on crime is estimated to have reduced the
daily number of crimes in Washington by about 7 in column (1) (not
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
a measure of tourism, and control for that in column (2) of the table
above. The causal estimate is reduced in that regression to a decrease
of about 6 in the number of crimes per day.

In their paper, Klick and Tabarrok actually argue against the idea that
they have to control for Metro ridership:

> “We are skeptical of the latter explanation on theoretical grounds
> because holding all else equal, daily crime is unlikely to vary
> significantly based on the number of daily visitors. The vast majority
> of visitors to Washington D.C. are never the victim of a crime. Since
> there are far more visitors than crimes it seems unlikely that the
> number of visitors constrains the number of crimes.”

### Question 4

“Below I am showing you”Table 4" from the researchers’ paper. Just focus
on the first column of the table. Can you describe the model being
estimated here? What is the conclusion?"

![Table 4](ex3table4.png)
