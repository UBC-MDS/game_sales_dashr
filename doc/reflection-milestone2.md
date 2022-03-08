# Implemented So Far

For milestone 2 our team has been able to implement every major feature proposed in milestone 1. A few minor improvements were made to improve the overall aesthetic and intuitiveness of the dashboard but overall we have succeeded in creating what was proposed. Below is a more specific breakdown of features implemented:

1. `Grouped line plot`: This plot displays the mean game sales over time for a specific genre within multiple regions. It can be filtered with the `Genre` dropdown in the sidebar allowing users to conduct side-by-side analysis of a genres performance across multiple regions.
2. `Individual line plot`: This plot displays the mean game sales over time for a single genre and region. It can be filtered with the `Genre` and `Region` dropdowns in the sidebar allowing it to effectively focus on specific regions/demographics.
3. `Sales by Publisher`: This plot displays counts of game sales broken down by publisher. It can be filtered with its accompanying `topn-slider` which allows the user to adjust the number of variables displayed on the Y axis.
4. `Sales by Platform`: This plot displays counts of game sales broken down by platform. It can be filtered with its accompanying `platforms-slider` which allows the user to adjust the number of variables displayed on the X axis.

# Not Implemented

The idea had been floated to include a heat map visualization of game genres by publisher but because this data set contains hundreds of unique publishers the resulting plot ended up being wider than the entire screen. We ultimately decided that this plots contribution to the overall dashboard was negligible, if not harmful, and we decided not to include it.

# Performs Well

As intended, our dashboard is very intuitive to use and understand. This dashboard was intended to provide a very high level overview of gaming industry sales with a few common-sense filters and we believe that it succeeds in doing so. 

# Future Additions and Improvements 

While the core functionality of our dashboard is in place we have identified a number of quality-of-life improvements that could be made in future iterations. Firstly, we would like to make the sidebar collapsible. While the sidebar is good to have it eats up quite a sit of screen space which could otherwise be dedicated to the charts. Secondly, we would like to improve the overall aesthetic 'cleanness' of the dashboard by finding ways to eliminate the vertical and horizontal scroll bars that accompany some of the plots (particularly on smaller screens). While not technically impacting functionality, we believe this would definitely improve the user experience and give the dashboard a more professional aesthetic. 
