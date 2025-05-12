args=commandArgs(TRUE)
if (length(args) != 2) {
  print ("usage:Rscript ko.R <pathway.txt> <species>")
  q()
}

inputFile <- args[1]
species <- args[2]
library("ggplot2")
library("ggstance")
library("dplyr")
library("ggthemes")
library("gridExtra")
library("svglite")
## Pathway
if (species == 'human' | species == 'Human' | species == 'Homo sapiens' | species == 'Homo_sapiens'){
    pathway <- read.delim (file=inputFile, head =T , sep ="\t")
} else {
    pathway1 <- read.delim (file=inputFile, head =T , sep ="\t")
    pathway <- filter(pathway1, A != "Human Diseases")
}
pathway <- pathway[1:3] %>% unique() %>% select(c(2,3))
#pathway <- pathway[2:3]
print('###########tt1')
pathway_data<-as.data.frame(table(pathway))
print('###########tt2')
pathway_data<-pathway_data[pathway_data$Freq!=0,]
write.table(pathway_data,file = "pathway_class_num.xls",col.names = T,row.names = F,quote = F,sep = "\t")
print('###########tt3')
pathway_data<-arrange(pathway_data, A)
print('###########tt4')
pathway_data$B<-factor(pathway_data$B, levels=unique(pathway_data$B))
print('###########tt5')
p <- ggplot(data=pathway_data)+geom_barh(aes(y=B, x=Freq, fill=A), stat="identity")+
    geom_text(aes(x=Freq, y=B, label=Freq), size=2.7, hjust=-0.25, vjust=0.25)+
    labs(x="number", y="", fill = "Class")+
    theme_bw()+
    theme(legend.title=element_blank(), panel.grid=element_blank())+
    scale_x_continuous(limits=c(0, max(pathway_data$Freq)*1.1))

ggsave("pathway.svg", p, width = 10, height = 8)
ggsave("pathway.pdf", p, width = 10, height = 8)
ggsave("pathway.png", p, width = 10, height = 8, dpi=800)
