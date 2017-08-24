library(shiny)

samp=read.delim("sampleTable.tsv",header=T,as.is=T,sep="\t")
N=nrow(samp)
comps=grep("comp",colnames(samp),value=T)


fluidPage(
title = 'Histogenomics',

#sidebarLayout(
#sidebarPanel(
# create some select inputs

sliderInput("size", "Image size (%)", min = 10, max = 150, value = 100),



selectInput("comp","Select component:",
choices = comps),

#),

#mainPanel(


# UI output
lapply(1:N, function(i) {
    #    plotOutput(paste0('plot', i),height="100%")
    imageOutput(paste0('plot', i),height="auto",width="auto")
})
#)
#)
#)
)
