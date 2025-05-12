args=commandArgs(TRUE)
if (length(args) != 2) {
  print ("usage:Rscript cog.R <cog.txt> ")
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
cog<- read.delim (file=inputFile, head =T , sep ="\t")
cog<-mutate(cog, CogClassCode_name=paste(CogClassCode, CogClassName, sep="|"))
cog<-arrange(cog, CogClassCode_name)
CogClassCode_name <- as.data.frame(as.character(cog$CogClassCode_name))
#cog$CogClassCode_name <- factor(cog$CogClassCode_name, levels = unique(cog$CogClassCode_name))
#qplot(CogClassCode_name, data=cog, fill=CogClassCode_name, geom = "bar", , width=I(0.65)) +
cog_freq <- as.data.frame(table(CogClassCode_name),stringsAsFactors = F)
new_all <- merge(cog, cog_freq, by = "CogClassCode_name", all.x = T)
new_all$CogClassCode_name <- as.character(new_all$CogClassCode_name)
new_all$CogClassCode_name <- factor(new_all$CogClassCode_name,levels=unique(new_all$CogClassCode_name))

ggplot(new_all, aes(x=CogClassCode_name,y=Freq,fill=CogClassCode_name)) + geom_bar(stat = "identity",position = "dodge") +
  scale_fill_discrete(breaks=new_all$CogClassCode_name, labels=new_all$CogClassCode_name ) +
  geom_text(aes(x=CogClassCode_name,label=Freq,y=Freq,vjust=-0.5),size=2.7) +
  labs(x="Function Class", y="Number of genes", fill="Group") +
  theme(legend.position="right", legend.title=element_blank()) + scale_x_discrete(labels=unique(new_all$CogClassCode))+
  guides(fill=guide_legend(ncol=1))+theme_classic()
  #scale_y_continuous(breaks=seq(0,max(new_all$Freq)+200,by=200), expand = c(0,0),limits=c(0,max(new_all$Freq+200)))

svgFile <- paste(outprefix, "svg", sep = ".")
pdfFile <- paste(outprefix, "pdf", sep = ".")
pngFile <- paste(outprefix, "png", sep = ".")
ggsave(svgFile, width=10, height=8)
ggsave(pdfFile, width=10, height=8)
ggsave(pngFile, width=10, height=8)