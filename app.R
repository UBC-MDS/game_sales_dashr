# ---
# jupyter:
#   jupytext:
#     text_representation:
#       extension: .R
#       format_name: light
#       format_version: '1.5'
#       jupytext_version: 1.13.6
#   kernelspec:
#     display_name: R
#     language: R
#     name: ir
# ---

# +
library(dash)
library(dashHtmlComponents)
library(ggplot2)
library(plotly)

app <- Dash$new(external_stylesheets = "https://codepen.io/chriddyp/pen/bWLwgP.css")

app$layout(
    htmlDiv(
        list(
            dccGraph(id='plot-area'),
            dccSlider(
                id = 'platform-slider',
                min = 0,
                max = 25,
                marks = list(
                    "5" = "5",
                    "10" = "10",
                    "15" = "15",
                    "20" = "20",
                    "25" = "25"
                ),
                value = 15
            )
        )
    )
)

app$callback(
    output('plot-area', 'figure'),
    list(input('platform-slider', 'value')),
    function(xlim) {
    
    data <- read.csv(file = 'data/raw/vgsales.csv')
        
    plot <- data %>%
        group_by(Platform) %>%
        summarise(global_sales = sum(Global_Sales)) %>%
        arrange(global_sales)  %>%
        slice(0:xlim) %>% #use this to adjust size vertically
        ggplot(aes(x = reorder(Platform, -global_sales), y = global_sales)) +
        geom_bar(stat = 'summary') +
        labs(title = "Global Sales by Console",
           x = "Console",
           y = "GLobal Sales (M)") +
        theme(axis.text.x = element_text(size = 14, angle = 90, vjust = 0.5, hjust=1),
              plot.title = element_text(size=24),
              axis.title=element_text(size=18))

    ggplotly(plot)
    }     
)
 

app$run_server(host = '0.0.0.0')    #Run on Heroku
#app$run_server(debug = T)    #Run Locally
