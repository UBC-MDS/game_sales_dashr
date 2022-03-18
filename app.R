library(dash)
library(dashHtmlComponents)
library(ggplot2)
library(plotly)
library(tidyr)
library(lubridate)
library(here)
library(tidyverse)
library(dashBootstrapComponents)

## data wrangling


data <- read_csv(here("data/raw","vgsales.csv"))

# pivoting data

pivoted_data <- data %>%  tidyr::pivot_longer('NA_Sales':'Global_Sales',
                                              names_to='region' , values_to='sales')


pivoted_data <- 
  pivoted_data %>%  dplyr::mutate(region = dplyr::case_when(region=='NA_Sales' ~ 'North America',
                                                            region=='EU_Sales' ~ 'Europe',
                                                            region=='JP_Sales' ~ 'Japan',
                                                            region=='Other_Sales' ~ 'Rest of the World',
                                                            region=='Global_Sales' ~ 'Global'),
                                  Year = lubridate::year(lubridate::as_date(Year, format="%Y" )))


## functions to display options


getGenres <- function(){
  pivoted_data %>% 
    dplyr::select(Genre) %>% 
    unique() %>%
    dplyr::pull() %>% 
    purrr::map(function(col) list(label = col, value = col))
}


getRegion <- function(){
  pivoted_data %>% 
    dplyr::select(region) %>% 
    unique() %>%
    dplyr::pull() %>% 
    purrr::map(function(col) list(label = col, value = col))
}

app <- Dash$new(external_stylesheets = dbcThemes$BOOTSTRAP)

platform_plot <- 
  list(
    dccGraph(id='platform-plot'),
    dccSlider(
      id = 'platform-slider',
      min = 0,
      max = 25,
      marks = list("5" = "5", "10" = "10", "15" = "15",
                   "20" = "20", "25" = "25"),
      value = 15)
  )

publisher_plot <- 
  list(
    dccGraph(id='publisher-plot'),
    dccSlider(
      id = 'publisher-slider',
      min = 0,
      max = 25,
      marks = list("5" = "5", "10" = "10", "15" = "15",
                   "20" = "20", "25" = "25"),
      value = 15)
  )


line_global <-
  list(dccGraph(id='line-global'))


line_genre <-
  list(
    dccGraph(id='line-genre'))





app$layout(
  dbcContainer(
    
    list(
      htmlH1("Video Games Dashboard"),
      div(
        list(
          dbcRow(
            list(
              
              htmlLabel('Select Genre'),  
              dccDropdown(
                id='genre-drop',
                options = getGenres(), 
                value='Sports',
                style = list(
                  height = "50px",
                  width = '250px')
              ),
              
              htmlLabel('Select Region'),
              dccDropdown(
                id='region-drop',
                options = getRegion(), 
                value='Global',
                style = list(
                  height = "50px",
                  width = '250px')
              )
            )))),
      dbcRow(
        list(
          dbcCol(line_global, md = 6), #top left
          dbcCol(line_genre, md = 6) # top right
        )
      ),
      dbcRow(
        list(
          dbcCol(publisher_plot, md = 6), #bottom left
          dbcCol(platform_plot, md = 6) #bottom right
        ))
    ), style=list('max-width' = '100%')
  )
)


app$callback(
  output('platform-plot', 'figure'),
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
      theme(axis.text.x = element_text( angle = 90, vjust = 0.5, hjust=1),
            plot.title = element_text(),
            axis.title=element_text())
    
    ggplotly(plot)
  }
)

app$callback(
  output('publisher-plot', 'figure'),
  list(input('publisher-slider', 'value')),
  function(topN) {
    
    data <- read.csv(file = 'data/raw/vgsales.csv')
    
    df_filtered <- data %>%
      select(Publisher) %>%
      group_by(Publisher) %>%
      summarise(count = n()) %>%
      arrange(desc(count)) %>%
      head(topN)
    
    #  p <- ggplot(df_filtered, aes(x = reorder(Publisher, -count), y = count))+ 
    p <- ggplot(df_filtered, aes(x = reorder(Publisher, -count), y = count))+ 
      geom_bar(stat="identity") +
      ggthemes::scale_color_tableau() +
      labs(x = "Release Count", y = "Publisher",
           title = "Top publishers by release") +
      theme(axis.text.x = element_text(angle = 25))
    
    ggplotly(p)
  }
)


app$callback(
  output('line-global', 'figure'),
  list(input('genre-drop', 'value')),
  function(genre) {
    p <- ggplot2::ggplot(pivoted_data %>% dplyr::filter(Genre==genre)) +
      ggplot2::aes(x = Year,
                   y = sales,
                   color = region) +
      ggplot2::geom_line(stat = 'summary', fun = mean, size=1) + 
      ggplot2::ggtitle('Mean Sales') +
      ggplot2::ggtitle('Mean Sales in Millions USD') +
      ggthemes::scale_color_tableau()
    plotly::ggplotly(p)
  }
)



app$callback(
  output('line-genre', 'figure'),
  list(input('genre-drop', 'value'),
       input('region-drop', 'value')),
  function(genre, Region) {
    p <- ggplot2::ggplot(pivoted_data %>% dplyr::filter(region==Region) %>%
                           dplyr::filter(Genre==genre)) +
      ggplot2::aes(x = Year,
                   y = sales) +
      ggplot2::geom_line(stat = 'summary', fun = mean, size=1) + 
      ggplot2::ggtitle('Mean Sales') +
      ggplot2::ggtitle('Mean Sales in Millions USD') +
      ggthemes::scale_color_tableau()
    plotly::ggplotly(p)
  }
)



app$run_server(host = '0.0.0.0')    #Run on Heroku
# app$run_server(debug = T)    #Run Locally