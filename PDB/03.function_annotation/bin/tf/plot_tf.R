args=commandArgs(TRUE)
if (length(args) != 2) {
          print ("usage:Rscript $0 <infile> <output_prefix>")
  q()
}
library("svglite")
myfile<-args[1]
outprefix<-args[2]

data <- read.table(file=myfile,header=T,sep = "\t")
names(data)[1:2] <- c('ID','Family')
table <- table(data$Family)
plot_data <- as.data.frame(table)
colnames(plot_data) <- c('Family', 'Number')
plot_data <- plot_data[order(-plot_data$Number,decreasing=F),]
write.table(plot_data,file="TF.xls",quote = F,row.names = F,sep = "\t")

plot_data <- plot_data[1:20,]
plot_data$Family<-factor(plot_data$Family,levels=unique(plot_data$Family))
percentage <- scales::percent(plot_data$Number / sum(plot_data$Number))
labs <- paste(plot_data$Family, '(', percentage, ')', sep = '')
#label_value <- rev(paste( round(plot_data$Number/sum(plot_data$Number) * 100,2), '%', sep = ''))

library(ggplot2)
#library(ggrepel)
library(RColorBrewer)
#colourCount = length(unique(data$V2))
#getPalette = colorRampPalette(brewer.pal(9, "Set1"))
col <- c(brewer.pal(12,"Set3"),brewer.pal(11,"Paired"))

f <- paste(outprefix, "png", sep = ".")
png(file=f,  width = 700, height = 600)
ggplot(data = plot_data, mapping = aes(x = "", y = Number,fill = Family)) + 
           geom_bar(alpha=0.8,stat = 'identity', width = 1)+
           coord_polar(theta = 'y')+ labs(x = 1, y = '', title = '') +
           theme(axis.text = element_blank()) + theme(axis.ticks = element_blank()) +
          #geom_text_repel(aes(x=1.2,y = rev(Number/2) +  c(0, cumsum(rev(Number))[-length(Number)]), label = labs))+    
          theme_void()+
          theme(legend.title=element_blank(),legend.position="right") +
          scale_fill_manual(breaks=plot_data$Family,values = col,labels=labs)
f <- paste(outprefix, "pdf", sep = ".")
fs <- paste(outprefix, "svg", sep = ".")
ggsave(f, width = 10, height = 8)
ggsave(fs, width = 10, height = 8)
dev.off()
