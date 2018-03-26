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

   getCurrentRank=reactive({
    i=    input$rank
    # print(i)
    if(is.null(i)|is.na(i)){
        return(NA)
    }else if(i<1){
        updateNumericInput(session,"rank",value=1);
        return(1)
    }else if(i>N){
       updateNumericInput(session,"rank",value=N);
       return(N)
   }
   input$rank
})

   observeEvent(input$comp, {
      updateNumericInput(session,"rank",value=1);

  })


   observeEvent(input$previous, {
      # print(getCurrentRank())
      if(is.na(getCurrentRank())|is.null(getCurrentRank())){
          updateNumericInput(session,"rank",value=1);
      }else if(getCurrentRank()>1){
          updateNumericInput(session,"rank",value=getCurrentRank()-1);
      }
  })
   observeEvent(input$nex, {
       # print(getCurrentRank())
       if(is.na(getCurrentRank())|is.null(getCurrentRank())){
          updateNumericInput(session,"rank",value=1);
       }else if(getCurrentRank()<N){
          updateNumericInput(session,"rank",value=getCurrentRank()+1);
       }
  })

   output$plot <- renderImage({
    list(src = selectImageAndOrder()$imgpath,
        hover=selectImageAndOrder()$labels,
        width=paste0(selectImageAndOrder()$size,"%"),
        contentType="image/jpeg",
        alt = "Missing img")
},deleteFile=F)


   output$lab<-renderText({selectImageAndOrder()$labels})

   selectImageAndOrder=reactive({

     i=getCurrentRank()
     if(is.null(i)|is.na(i))return(list(imgpath="",labels="Wrong rank",size=20));
     selcomp=input$comp

     rang=signif(range(samp[,selcomp],na.rm=T),3)
     rangstr=paste( "range: [",rang[1],",",rang[2],"]")

     imgdir=imgdirs[[input$which]]
     ORD=order(samp[,selcomp],decreasing=T)
     list(
        size=input$size,
        imgpath=paste0(imgdir,samp[ORD,"histologyID"],imgextension)[i],
        labels=paste(LABELS[ORD],"percentile on component",selcomp,":",signif(100*((N:1)/N),2),"% ( value on component:",signif(samp[ORD,selcomp],3)," ; ", rangstr ,")")[i]
        )
 })




})

