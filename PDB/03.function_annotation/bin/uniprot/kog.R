args=commandArgs(TRUE)
if (length(args) != 2) {
  print ("usage:Rscript kog.R <kog.txt> ")
  q()
}

inputFile <-args[1]
outprefix <-args[2]
library("ggplot2")
library("dplyr")
library("ggthemes")
library("gridExtra")
library("svglite")
## COG
kog<- read.delim (file=inputFile, head =T , sep ="\t")
kog<-mutate(kog, KogClassCode_name=paste(KogClassCode, KogClassName, sep="|"))
kog<-arrange(kog, KogClassCode_name)
KogClassCode_name <- as.data.frame(as.character(kog$KogClassCode_name))
#kog$KogClassCode_name <- factor(kog$KogClassCode_name, levels = unique(kog$KogClassCode_name))
#qplot(KogClassCode_name, data=kog, fill=KogClassCode_name, geom = "bar", , width=I(0.65)) +
kog_freq <- as.data.frame(table(KogClassCode_name),stringsAsFactors = F)
new_all <- merge(kog, kog_freq, by = "KogClassCode_name", all.x = T)
new_all$KogClassCode_name <- as.character(new_all$KogClassCode_name)
new_all$KogClassCode_name <- factor(new_all$KogClassCode_name,levels=unique(new_all$KogClassCode_name))

ggplot(new_all, aes(x=KogClassCode_name,y=Freq,fill=KogClassCode_name)) + geom_bar(stat = "identity",position = "dodge") +
  scale_fill_discrete(breaks=new_all$KogClassCode_name, labels=new_all$KogClassCode_name ) +
  geom_text(aes(x=KogClassCode_name,label=Freq,y=Freq,vjust=-0.5),size=2.7) +
  labs(x="Function Class", y="Number of genes", fill="Group") +
  theme(legend.position="right", legend.title=element_blank()) + scale_x_discrete(labels=unique(new_all$KogClassCode))+
  guides(fill=guide_legend(ncol=1))+theme_classic()
  #scale_y_continuous(breaks=seq(0,max(new_all$Freq)+200,by=200), expand = c(0,0),limits=c(0,max(new_all$Freq+200)))

svgFile <- paste(outprefix, "svg", sep = ".")
pdfFile <- paste(outprefix, "pdf", sep = ".")
pngFile <- paste(outprefix, "png", sep = ".")
ggsave(svgFile, width=10, height=8)
ggsave(pdfFile, width=10, height=8)
ggsave(pngFile, width=10, height=8)
