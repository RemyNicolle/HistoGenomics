samp=read.delim("annotations.tsv",header=T,as.is=T,sep="\t")

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


  getMaxRank=reactive({
    sum(!is.na(  samp[,input$comp]))
  })

  getCurrentRank=reactive({
    i=    input$rank
    # print(i)
    if(is.null(i)|is.na(i)){
      return(NA)
    }else if(i<1){
      updateNumericInput(session,"rank",value=1);
      return(1)
    }else if(i>getMaxRank()){
     updateNumericInput(session,"rank",value=getMaxRank());
     return(getMaxRank())
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
  }else if(getCurrentRank()<getMaxRank()){
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

  output$distrib <- renderPlot({
    i=getCurrentRank()
    selcomp=input$comp
    samp[,selcomp]
    ORD=order(samp[,selcomp],decreasing=T,na.last=NA)

    plot(density(samp[,selcomp],na.rm=T),bty="l",main=paste0("Distribution of ",selcomp),sub=NULL,xlab=paste0(selcomp," value distribubtion of all samples\nRed bar indicates the selected sample")         )
    abline(v=samp[ORD[i],selcomp],col="red",lwd=4)  
  })


  output$lab<-renderText({selectImageAndOrder()$labels})

  selectImageAndOrder=reactive({

   i=getCurrentRank()
   if(is.null(i)|is.na(i))return(list(imgpath="",labels="Wrong rank",size=20));
   selcomp=input$comp

   rang=signif(range(samp[,selcomp],na.rm=T),3)
   rangstr=paste( "range: [",rang[1],",",rang[2],"]")

   imgdir=imgdirs[[input$which]]
   ORD=order(samp[,selcomp],decreasing=T,na.last=NA)
   list(
    size=input$size,
    imgpath=paste0(imgdir,samp[ORD,"histologyID"],imgextension)[i],
    # labels=paste(LABELS[ORD],"percentile on component",selcomp,":",signif(100*((getMaxRank():1)/getMaxRank()),2),"% ( value on component:",signif(samp[ORD,selcomp],3)," ; ", rangstr ,")")[i]
     labels=paste(LABELS[ORD],"component",selcomp,", rank :",1:getMaxRank()," (percentile: ",signif(100*((getMaxRank():1)/getMaxRank()),2),"% ; value on component:",signif(samp[ORD,selcomp],3)," ; ", rangstr ,")")[i]
    )
 })




})

