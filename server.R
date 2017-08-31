samp=read.delim("annotations.tsv",header=T,as.is=T,sep="\t")
N=nrow(samp)
comps=grep("comp",colnames(samp),value=T)



haslabel=length(grep("label",colnames(samp)))>0
if(haslabel){
    labelcol=grep("label",colnames(samp),value=T)
    if(length(labelcol)==1){
        LABELS= paste0(samp[,"sample"]," : ",samp[,labelcol])
    }else{
        LABELS= paste0(samp[,"sample"]," : ",apply(samp[,labelcol],1,paste,collapse=" "))
    }
}else{
    LABELS=paste0(samp[,"sampleID"]," (subtype: ",samp[,"whole.tumor.classification"],")")
}


imgdirs=list(selected="dataimg/selected/"
,full="dataimg/full/")
imgextension=".jpg"




shinyServer(function(input, output, session) {
    
    
    
   selectImageAndOrder=reactive({
       
       
        selcomp=input$comp
        
        rang=signif(range(samp[,selcomp],na.rm=T),3)
        rangstr=paste( "range: [",rang[1],",",rang[2],"]")
        
        imgdir=imgdirs[[input$which]]
        ORD=order(samp[,selcomp],decreasing=T)
        list(
                size=input$size,
        imgpath=paste0(imgdir,samp[ORD,"histologyID"],imgextension),
        labels=paste(LABELS[ORD],selcomp,":",signif(samp[ORD,selcomp],3),
        " ( percentile:",signif(100*((N:1)/N),2),"% ;", rangstr ,")")
        )
    })
    
    lapply(1:N, function(i) {
        output[[paste0('plot', i)]] <- renderImage({
            
            list(src = selectImageAndOrder()$imgpath[[i]],
            hover=selectImageAndOrder()$labels[[i]],
            #width=300,height=200,
            width=paste0(selectImageAndOrder()$size,"%"),
            alt = "Missing img")
        },deleteFile=F)
        
        output[[paste0('lab', i)]]<-renderText({
        selectImageAndOrder()$labels[[i]]
        })
    })
})
