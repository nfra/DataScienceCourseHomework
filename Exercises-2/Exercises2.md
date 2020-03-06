Exercises 2
================
Nathan Franz, Ian McBride, and Claire Roycroft

# Saratoga house prices

In order to predict the market values of properties in the Saratoga, NY
market, our team developed several different models based on the
available data. We then iteratively scored the performance of our models
and implemented various alterations to try to improve each of the
models’ predictive ability. While we will not delve into many of the
technical details of our analysis in this report, it is important to
give a brief description of the primary measure that we used to evaluate
model performance. This metric, called ‘Root Mean-Squared Error’ (RMSE),
reports an average difference of the value predicted by our model
compared to the actual value of the property. The main goal of our work
was to minimize this value.

To start, our team ran a linear regression on a selection of covariates
that we strongly suspected would have a significant impact on the market
value of a given property. This regression served as the baseline for
further analysis; different variables and interaction terms were
subsequently added or removed, and the predictive accuracy was
re-measured according to the RMSE metric. To rank the relative
importance of terms in our final hand-built model, we then individually
dropped each of the terms from the regression, re-ran it, then compared
the model’s performance without a given covariate to its performance
with the covariate included. This process yielded several mostly
intuitive conclusions; the most important variables to include in our
model were the underlying land value, the living area interacted with
whether a property was newly built, waterfront status, and room
characteristics (with interactions). These results can be seen in the
table below. Additionally, the RMSE of the original model was lower than
each of the models with one excluded term, which verified that all terms
in our regression were positively contributing to our goal of reducing
the overall RMSE.

<table style="text-align:center">

<caption>

<strong>RMSE Impact of Excluding Specified Terms in Linear
Regression</strong>

</caption>

<tr>

<td colspan="2" style="border-bottom: 1px solid black">

</td>

</tr>

<tr>

<td style="text-align:left">

Dropped\_Term

</td>

<td>

RMSE\_Impact

</td>

</tr>

<tr>

<td colspan="2" style="border-bottom: 1px solid black">

</td>

</tr>

<tr>

<td style="text-align:left">

landValue

</td>

<td>

5,867.293

</td>

</tr>

<tr>

<td style="text-align:left">

livingArea \* newConstruction

</td>

<td>

3,935.635

</td>

</tr>

<tr>

<td style="text-align:left">

waterfront

</td>

<td>

838.765

</td>

</tr>

<tr>

<td style="text-align:left">

bedrooms \* bathrooms \* rooms

</td>

<td>

754.773

</td>

</tr>

<tr>

<td style="text-align:left">

age \* lotSize

</td>

<td>

413.516

</td>

</tr>

<tr>

<td style="text-align:left">

centralAir

</td>

<td>

120.284

</td>

</tr>

<tr>

<td style="text-align:left">

heating

</td>

<td>

100.299

</td>

</tr>

<tr>

<td colspan="2" style="border-bottom: 1px solid black">

</td>

</tr>

</table>

After we had improved linear regression model as much as possible
manually, we also then proceeded to implement an automated stepwise
variable selection process, which mechanically considered all pairwise
combinations of covariates in the dataset and included all that would be
beneficial to model performance. While it didn’t reveal any new
significant insights, it did slightly improve performance compared to
the manually built model.

Lastly, our team implemented a k-nearest neighbors model with the
covariates from our best hand-built linear model. While the optimal
k-nearest neighbors model significantly outperformed the baseline linear
regression model, it didn’t outperform the best hand-built linear model
or stepwise linear model. This can be seen in the figure below, which
shows the average RMSE values across all values of k and also compares
them to the RMSE values of the other models we tested. (A technical
note: the average RMSE of the linear models and the average RMSE of the
k-nearest neighbor models were calculated using different sets of random
samples from the overall data. While it is typically not optimal to
compare performance across different sets of random samples, this issue
is alleviated by averaging across a large number of random samples
within each set, which we do in our analysis.)

![](exercises2_files/figure-gfm/e1_results-1.png)<!-- -->

For tax-assessing purposes, the main takeaways from our analysis are
clear. Obtaining accurate information about land value, basic house
characteristics, and geographic location are all key for forming the
best predictive models. Even with this information, however, the RMSE
values of our best models are still relatively high (on the order of
tens of thousands of dollars). It is unclear on if this is an acceptable
level of error for the purposes of tax assessment, though the models
would likely yield more accurate results if more data can be obtained.
At the very least, these models can serve as a general guideline for
aiding in assessment, even if they cannot be completely trusted to come
up with true market values by themselves.

# A hospital audit

# Predicting when articles go viral
