args=commandArgs(TRUE)
if (length(args) != 1) {
  print ("usage:Rscript pfam.R <pfam.txt> ")
  q()
}

inputFile <-args[1]
library("ggplot2")
library("dplyr")
library("ggthemes")
library("gridExtra")
library("svglite")
#pfam
pfam <- read.delim (file=inputFile, head =T , sep ="\t")
pfam_count <- group_by(pfam, Accession, HMMProfile) %>% summarise(number_of_genes = n()) %>% arrange( desc(number_of_genes)) 
pfam_count_filter <- head(pfam_count, 20)
cs <- factor(pfam_count_filter$HMMProfile,levels=unique(pfam_count_filter$HMMProfile))
maxnum <- max (pfam_count_filter$number_of_genes) + 5
ggplot(data = pfam_count_filter) +
  geom_bar(aes(x = cs, y = number_of_genes), fill = I("steelblue"), stat = "identity", width=0.4) + theme_classic()+ 
  #geom_text(aes(x = cs, y = number_of_genes,label= number_of_genes, vjust = -0.3)) +
  theme(axis.text.x = element_text(angle = -45, hjust = 0, size = 10)) +
  xlab("Pfam Domain") +
  ylab("Number of genes") +
  scale_y_continuous(limits = c(0,maxnum))
#scale_y_continuous(expand = c(0,0)) 
ggsave("pfam.svg", width = 12, height = 8)
ggsave("pfam.pdf", width = 12, height = 8)
ggsave("pfam.png", width = 12, height = 8)
