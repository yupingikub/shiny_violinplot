library(shiny)
library(tidyverse)
library(ggplot2)
library(plotly)
library(markdown)

shinyServer(function(input,output){
  data <- reactive({
    filein <- input$file
    if(is.null(filein)){
      return(read.csv('data/zscoredf.csv', sep=',', header=TRUE))
    }
      read.csv(file=filein$datapath, sep=',', header=TRUE)
  })
  output$labelname <- renderUI({
    selectInput('labelitem','Select item(s)', 
                choices = unique(data()$variable_x), multiple = TRUE)
  })
  output$myplot <- renderPlotly({
    input$act
    if(input$act==0){return()}
    
    isolate(label_list <- data.frame(cbind(variable_x=input$labelitem[1:length(input$labelitem)])))
    
    isolate(plotdata <- right_join(data(),label_list, by='variable_x'))
   
     plotdata <- plotdata%>%
      group_by(variable_x)
    
    p <- ggplot(plotdata, aes(x = variable_x, y = variable_y , 
                              fill = variable_x, alpha=0.8, label=data.annotation))+scale_fill_viridis_d(direction = -1)+
      ggtitle(input$title)+ 
      theme(plot.title = element_text(hjust = 0.5)) +
      xlab(input$varx)+ylab(input$vary)+ 
      scale_alpha(guide = 'none')+
      guides(fill=guide_legend(title=input$varx))
    
    if(input$violin==TRUE){p <- p+
      geom_violin()}
    
    if(input$boxplot==TRUE){p <- p+
      geom_boxplot(fill = NA, width = 0., colour = "black")}
    
    if(input$jitter==TRUE){p <- p+
      geom_jitter()}
 
    if(input$coordflip==TRUE){p <- p+
      coord_flip()}
    
    if(input$xscale==FALSE){p <- p+
      theme(axis.text.x = element_blank(), axis.ticks.x = element_blank())}
    
    if(input$yscale==FALSE){p <- p+
      theme(axis.text.y = element_blank(), axis.ticks.y = element_blank())}
    
    if(input$legend==FALSE){p <- p+
      theme(legend.position='none')}

ggplotly(p, tooltip = c('data.annotation', 'variable_y'), height=700, width=1100)%>%
  highlight("plotly_selected")%>%
  layout(legend = list(orientation = 'h', xanchor = "center", x=0.5, y=-0.2))
  })
})
