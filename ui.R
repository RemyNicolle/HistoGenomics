library(shiny)

samp=read.delim("annotations.tsv",header=T,as.is=T,sep="\t")
N=nrow(samp)
#comps=grep("comp",colnames(samp),value=T)
comps=colnames(samp)[c(3:10,14:38)]



navbarPage("Histogenomics",

tabPanel("Slides",fluidPage(
	title = 'Histogenomics',

	p("Visualize the association between the histology and genomics of pancreatic adenocarcinoma"),

#sidebarLayout(
#sidebarPanel(
# create some select inputs

h3("Image feature"),
	sliderInput("size", "Image size (%)", min = 10, max = 150, value = 80),

	radioButtons("which","Show zoom on selected portion of the slide or full slide:", choiceValues=c("selected","full"),
		choiceNames=c("10x zoom on selection","full slide"),
		selected="full"),

h3("Genomic feature selection"),

	selectInput("comp","Select component:",
		choices = comps),


#),

#mainPanel(

h3("Sample selection"),
	fluidRow(
		column(1,	actionButton("previous", "previous")),
	column(1,	numericInput("rank", label = NULL, value = 1,min=1,max=N,step=1,width="100px")),
	column(1,actionButton("nex", "next"))
	),

# UI output
# lapply(1:N, function(i) {
    #    plotOutput(paste0('plot', i),height="100%")
    # fluidRow(
    h3("Sample slide"),
	textOutput(paste0('lab')),
	plotOutput("distrib",height="200px"),
	imageOutput(paste0('plot'),height="auto",width="auto")

	# )
# })
#)
#)
#)
)),
tabPanel("Information",
p("Details for each parameter and output of the app."),
h3("Image feature"),
p(strong("Image size (%): "),"Display size in percentage of original image"),
p(strong("Zoom: "),"Either display entire slide (full slide) or a 10x zoom inside the selected microdissected zone."),
h3("Genomic feature selection"),
p("Select the genomic component by which the slides should be ordered."),
h3("Sample selection"),
p("Select the sample to show as ranked by the selected genomic component."),
h3("Sample slide"),
p("Display genomic information from the selected component on the selected sample."),
p("Display the slide of the selected sample. In full slides, a thick green line delineates the microdissected zone.")
	))