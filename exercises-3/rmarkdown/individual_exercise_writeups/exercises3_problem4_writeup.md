Problem 4
================

Our team chose to treat the task of identifying interesting market
segments for NutrientH20 as a clustering problem and attempted several
different approaches within the clustering family. Before starting,
however, we decided to perform a few transformations to try to make the
data more useful. First, we dropped the random alphanumeric code
associated with each user and created a new variable called
‘num\_tweets’ equal to the sum of all other columns in the dataset.
While we know that some tweets were classified as belonging to more than
one category during the data collection process, this variable should
still serve as a close proxy for the social media engagement of a given
user. Next, we scaled down all other variables by the new ‘num\_tweets’
variable, so that each column now represented the fraction of a given
user’s engagement that fell within a certain category.

After cleaning and transforming the data, we then proceeded to calculate
gap-statistics for both K-means and hierarchical clustering methods in
order to try to find an optimal number of groups for our data. In both
cases, the gap-statistic implied the trivial selection of a single
cluster which was not relevant for our use case, but there was also a
flattening or slight dip of the gap-statistic curve at k=13.

![](exercises3_problem4_writeup_files/figure-gfm/fig1-1.png)<!-- -->![](exercises3_problem4_writeup_files/figure-gfm/fig1-2.png)<!-- -->

Without having prior intuition about the expected number of market
segments, we proceeded to fit both K-means++ and hierarchical clustering
models to the data with 13 clusters. While the K-means++ method yielded
relatively balanced clusters out-of-the-box, hierarchical clustering did
not yield balanced clusters using ‘simple’, ‘complete’, ‘average’, or
‘centroid’ linkage methods (‘complete’ was the most balanced of these
methods and still placed \~94% into a single cluster). To alleviate this
issue, we used a linkage method known as Ward clustering that is based
on minimizing the total within-cluster variance. Ward clustering yielded
much more balanced clusters that were in similar in size to the
K-means++ clusters.

![](exercises3_problem4_writeup_files/figure-gfm/fig2-1.png)<!-- -->![](exercises3_problem4_writeup_files/figure-gfm/fig2-2.png)<!-- -->

In order to explore the defining characteristics of market segments, we
calculated each cluster’s average standard deviation from the mean for
each category. The diverging dot plots below shows the results of this
process, with points outside the red-dotted lines (which are 1 standard
deviation from the mean) highlighting the key characteristics of a given
cluster.

![](exercises3_problem4_writeup_files/figure-gfm/fig3-1.png)<!-- -->![](exercises3_problem4_writeup_files/figure-gfm/fig3-2.png)<!-- -->

    ##                         1         2        3        4        5        6
    ## chatter                NA        NA       NA       NA       NA       NA
    ## current_events         NA        NA       NA       NA       NA       NA
    ## travel                 NA        NA       NA       NA       NA       NA
    ## photo_sharing          NA        NA       NA       NA       NA       NA
    ## uncategorized          NA        NA       NA       NA       NA       NA
    ## tv_film                NA        NA       NA       NA 1.659329 2.029805
    ## sports_fandom          NA        NA 1.455466       NA       NA       NA
    ## politics               NA        NA       NA       NA       NA       NA
    ## food                   NA        NA 1.295079       NA       NA       NA
    ## family                 NA        NA       NA       NA       NA       NA
    ## home_and_garden        NA        NA       NA       NA       NA       NA
    ## music                  NA        NA       NA       NA 2.191240       NA
    ## news                   NA        NA       NA       NA       NA       NA
    ## online_gaming          NA        NA       NA       NA       NA       NA
    ## shopping               NA        NA       NA       NA       NA       NA
    ## health_nutrition       NA        NA       NA 1.874538       NA       NA
    ## college_uni            NA        NA       NA       NA       NA       NA
    ## sports_playing         NA        NA       NA       NA       NA       NA
    ## cooking                NA        NA       NA       NA       NA       NA
    ## eco                    NA        NA       NA       NA       NA       NA
    ## computers              NA        NA       NA       NA       NA       NA
    ## business               NA        NA       NA       NA       NA       NA
    ## outdoors               NA        NA       NA 1.116925       NA       NA
    ## crafts                 NA        NA       NA       NA       NA       NA
    ## automotive             NA        NA       NA       NA       NA       NA
    ## art                    NA        NA       NA       NA       NA 3.515729
    ## religion               NA        NA 1.787059       NA       NA       NA
    ## beauty                 NA        NA       NA       NA       NA       NA
    ## parenting              NA        NA 1.603170       NA       NA       NA
    ## dating                 NA        NA       NA       NA       NA       NA
    ## school                 NA        NA 1.061752       NA       NA       NA
    ## personal_fitness       NA        NA       NA 1.734781       NA       NA
    ## fashion                NA        NA       NA       NA       NA       NA
    ## small_business         NA        NA       NA       NA       NA       NA
    ## spam                   NA 12.587447       NA       NA       NA       NA
    ## adult            4.901486  3.615763       NA       NA       NA       NA
    ## num_tweets             NA        NA       NA       NA       NA       NA
    ##                          7        8       9       10       11       12
    ## chatter                 NA       NA      NA 1.240530       NA       NA
    ## current_events    1.557930       NA      NA       NA       NA       NA
    ## travel                  NA       NA      NA       NA 2.237411       NA
    ## photo_sharing           NA       NA      NA 1.190122       NA       NA
    ## uncategorized     1.117754       NA      NA       NA       NA       NA
    ## tv_film                 NA       NA      NA       NA       NA       NA
    ## sports_fandom           NA       NA      NA       NA       NA       NA
    ## politics                NA       NA      NA       NA 2.290026 1.186056
    ## food                    NA       NA      NA       NA       NA       NA
    ## family                  NA       NA      NA       NA       NA       NA
    ## home_and_garden         NA       NA      NA       NA       NA       NA
    ## music                   NA       NA      NA       NA       NA       NA
    ## news                    NA       NA      NA       NA       NA 2.452152
    ## online_gaming           NA       NA      NA       NA       NA       NA
    ## shopping                NA       NA      NA 1.347879       NA       NA
    ## health_nutrition        NA       NA      NA       NA       NA       NA
    ## college_uni             NA       NA      NA       NA       NA       NA
    ## sports_playing          NA       NA      NA       NA       NA       NA
    ## cooking                 NA 2.320768      NA       NA       NA       NA
    ## eco                     NA       NA      NA       NA       NA       NA
    ## computers               NA       NA      NA       NA 2.002219       NA
    ## business                NA       NA      NA       NA       NA       NA
    ## outdoors                NA       NA      NA       NA       NA       NA
    ## crafts                  NA       NA      NA       NA       NA       NA
    ## automotive              NA       NA      NA       NA       NA 2.158788
    ## art                     NA       NA      NA       NA       NA       NA
    ## religion                NA       NA      NA       NA       NA       NA
    ## beauty                  NA 1.822244      NA       NA       NA       NA
    ## parenting               NA       NA      NA       NA       NA       NA
    ## dating                  NA       NA 4.04127       NA       NA       NA
    ## school                  NA       NA      NA       NA       NA       NA
    ## personal_fitness        NA       NA      NA       NA       NA       NA
    ## fashion                 NA 2.052526      NA       NA       NA       NA
    ## small_business          NA       NA      NA       NA       NA       NA
    ## spam                    NA       NA      NA       NA       NA       NA
    ## adult                   NA       NA      NA       NA       NA       NA
    ## num_tweets       -1.014449       NA      NA       NA       NA       NA
    ##                        13
    ## chatter                NA
    ## current_events         NA
    ## travel                 NA
    ## photo_sharing          NA
    ## uncategorized          NA
    ## tv_film                NA
    ## sports_fandom          NA
    ## politics               NA
    ## food                   NA
    ## family                 NA
    ## home_and_garden        NA
    ## music                  NA
    ## news                   NA
    ## online_gaming    2.912434
    ## shopping               NA
    ## health_nutrition       NA
    ## college_uni      2.612139
    ## sports_playing   1.278281
    ## cooking                NA
    ## eco                    NA
    ## computers              NA
    ## business               NA
    ## outdoors               NA
    ## crafts                 NA
    ## automotive             NA
    ## art                    NA
    ## religion               NA
    ## beauty                 NA
    ## parenting              NA
    ## dating                 NA
    ## school                 NA
    ## personal_fitness       NA
    ## fashion                NA
    ## small_business         NA
    ## spam                   NA
    ## adult                  NA
    ## num_tweets             NA

    ##                         1        2        3        4        5        6
    ## chatter                NA       NA       NA       NA 1.195898       NA
    ## current_events         NA       NA       NA       NA       NA       NA
    ## travel                 NA       NA       NA       NA       NA 2.164227
    ## photo_sharing          NA       NA       NA       NA 1.052022       NA
    ## uncategorized          NA       NA       NA       NA       NA       NA
    ## tv_film                NA       NA 1.946699       NA       NA       NA
    ## sports_fandom          NA 1.351621       NA       NA       NA       NA
    ## politics               NA       NA       NA       NA       NA 2.428848
    ## food                   NA 1.170117       NA       NA       NA       NA
    ## family                 NA       NA       NA       NA       NA       NA
    ## home_and_garden        NA       NA       NA       NA       NA       NA
    ## music                  NA       NA       NA       NA       NA       NA
    ## news                   NA       NA       NA       NA       NA       NA
    ## online_gaming          NA       NA       NA 2.817173       NA       NA
    ## shopping               NA       NA       NA       NA 1.526148       NA
    ## health_nutrition 1.922887       NA       NA       NA       NA       NA
    ## college_uni            NA       NA       NA 2.538054       NA       NA
    ## sports_playing         NA       NA       NA 1.133153       NA       NA
    ## cooking                NA       NA       NA       NA       NA       NA
    ## eco                    NA       NA       NA       NA       NA       NA
    ## computers              NA       NA       NA       NA       NA 1.665409
    ## business               NA       NA       NA       NA       NA       NA
    ## outdoors         1.117400       NA       NA       NA       NA       NA
    ## crafts                 NA       NA       NA       NA       NA       NA
    ## automotive             NA       NA       NA       NA       NA       NA
    ## art                    NA       NA 3.604709       NA       NA       NA
    ## religion               NA 1.652221       NA       NA       NA       NA
    ## beauty                 NA       NA       NA       NA       NA       NA
    ## parenting              NA 1.438893       NA       NA       NA       NA
    ## dating                 NA       NA       NA       NA       NA       NA
    ## school                 NA       NA       NA       NA       NA       NA
    ## personal_fitness 1.743005       NA       NA       NA       NA       NA
    ## fashion                NA       NA       NA       NA       NA       NA
    ## small_business         NA       NA       NA       NA       NA       NA
    ## spam                   NA       NA       NA       NA       NA       NA
    ## adult                  NA       NA       NA       NA       NA       NA
    ## num_tweets             NA       NA       NA       NA       NA       NA
    ##                         7  8        9       10       11       12        13
    ## chatter                NA NA       NA       NA       NA       NA        NA
    ## current_events         NA NA       NA       NA       NA       NA        NA
    ## travel                 NA NA       NA       NA       NA       NA        NA
    ## photo_sharing          NA NA       NA       NA       NA       NA        NA
    ## uncategorized          NA NA       NA       NA       NA       NA        NA
    ## tv_film                NA NA 1.942551       NA       NA       NA        NA
    ## sports_fandom          NA NA       NA       NA       NA       NA        NA
    ## politics               NA NA       NA 1.144501       NA       NA        NA
    ## food                   NA NA       NA       NA       NA       NA        NA
    ## family                 NA NA       NA       NA       NA       NA        NA
    ## home_and_garden        NA NA       NA       NA       NA       NA        NA
    ## music                  NA NA 1.966284       NA       NA       NA        NA
    ## news                   NA NA       NA 2.206660       NA       NA        NA
    ## online_gaming          NA NA       NA       NA       NA       NA        NA
    ## shopping               NA NA       NA       NA       NA       NA        NA
    ## health_nutrition       NA NA       NA       NA       NA       NA        NA
    ## college_uni            NA NA 1.206160       NA       NA       NA        NA
    ## sports_playing         NA NA       NA       NA       NA       NA        NA
    ## cooking          2.171478 NA       NA       NA       NA       NA        NA
    ## eco                    NA NA       NA       NA       NA       NA        NA
    ## computers              NA NA       NA       NA       NA       NA        NA
    ## business               NA NA       NA       NA       NA       NA        NA
    ## outdoors               NA NA       NA       NA       NA       NA        NA
    ## crafts                 NA NA       NA       NA       NA       NA        NA
    ## automotive             NA NA       NA 1.985040       NA       NA        NA
    ## art                    NA NA       NA       NA       NA       NA        NA
    ## religion               NA NA       NA       NA       NA       NA        NA
    ## beauty           1.778883 NA       NA       NA       NA       NA        NA
    ## parenting              NA NA       NA       NA       NA       NA        NA
    ## dating                 NA NA       NA       NA 3.907957       NA        NA
    ## school                 NA NA       NA       NA       NA       NA        NA
    ## personal_fitness       NA NA       NA       NA       NA       NA        NA
    ## fashion          1.992392 NA       NA       NA       NA       NA        NA
    ## small_business         NA NA       NA       NA       NA       NA        NA
    ## spam                   NA NA       NA       NA       NA       NA 10.827822
    ## adult                  NA NA       NA       NA       NA 4.379187  3.225323
    ## num_tweets             NA NA       NA       NA       NA       NA        NA

Commentary on market segments here…
