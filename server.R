samp=read.delim("sampleTable.tsv",header=T,as.is=T,sep="\t")
N=nrow(samp)
comps=grep("comp",colnames(samp),value=T)

imgdir="dataimg/"
imgextension=".jpg"




shinyServer(function(input, output, session) {
    
    
    
   selectImageAndOrder=reactive({
        selcomp=input$comp
        list(
                size=input$size,
        imgpath=paste0(imgdir,samp[order(samp[,selcomp]),"sample"],imgextension)
        )
    })
    
    lapply(1:N, function(i) {
        output[[paste0('plot', i)]] <- renderImage({
            
            list(src = selectImageAndOrder()$imgpath[[i]],
            #width=300,height=200,
            width=paste0(selectImageAndOrder()$size,"%"),
            alt = "Missing img")
        },deleteFile=F)
    })
})
