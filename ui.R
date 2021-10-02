library(shiny)
library(tidyverse)
library(ggplot2)
library(plotly)
library(markdown)
shinyUI(fluidPage(
  titlePanel(title='Violin Plot'),
  sidebarLayout(
    sidebarPanel(
      fileInput('file', 'Upload the file', accept = '.csv', 
                placeholder = "The default file is zscoredf.csv."),
      helpText('The maximum file upload size is 5MB.'),
      uiOutput('labelname'),
      actionButton('act','Submit'),
      p('Click on Submit button to update the plot.'),
      textInput('title', 'Give title to plot:', value='Title'),
      textInput('varx', 'Give label name to variable_x:', value='Label_name'),
      textInput('vary', 'Give label name to variable_y:', value='Value'),
      helpText(h5('Plot Options:')),
      checkboxInput('violin','Add violinplot', TRUE),
      checkboxInput('boxplot','Add boxplot', FALSE),
      checkboxInput('jitter','Add jitter', FALSE),
      checkboxInput('coordflip','Switch the x- and y-axis', FALSE),
      checkboxInput('xscale','Add scale/text for x-axis', FALSE),
      checkboxInput('yscale','Add scale/text for y-axis', FALSE),
      checkboxInput('legend','Show the legend', FALSE),
    ),
    mainPanel(
      tabsetPanel(type='tab',
                  tabPanel('Plot', plotlyOutput('myplot', width = '100%')),
                  tabPanel('About this App',
                           includeMarkdown('about.md')
                  )
      )
    ))
)
)
