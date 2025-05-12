args=commandArgs(TRUE)
if (length(args) != 1) {
  print ("usage:Rscript nr.R <Nr_Species_distribution.txt> ")
  q()
}

inputFile <-args[1]
library(dplyr)
library(ggplot2)
library("svglite")

data <- read.delim(file=inputFile,header=T,sep = "\t")
#data$Species<-factor(data$Species,levels=unique(data$Species))
#label_value <- rev(paste( round(data$Number/sum(data$Number) * 100,2), '%', sep = ''))
data$value <- paste( round(data$Number/sum(data$Number) * 100,2), '%', sep = '')
data$Species <- paste(data$Species,data$value, sep=" : ")
data$Species<-factor(data$Species,levels=unique(data$Species))
png(file="Nr_Species_distribution.png", width = 1000, height = 800)
ggplot(data = data, mapping = aes(x = "", y = Number, fill = Species)) +
  geom_bar(stat = 'identity', width = 1) +
  coord_polar(theta = 'y') + labs(x = 1, y = '', title = '') +
  theme(axis.text = element_blank()) + theme(axis.ticks = element_blank()) +
#  geom_text_repel(aes(x=1.38,y = rev(Number/3) +
#  c(0, cumsum(rev(Number))[-length(Number)]), label = label_value)) +
  theme_void() +
  scale_fill_brewer(palette = "Set3")
ggsave("Nr_Species_distribution.svg", width = 10, height = 8)
ggsave("Nr_Species_distribution.pdf", width = 10, height = 8)
