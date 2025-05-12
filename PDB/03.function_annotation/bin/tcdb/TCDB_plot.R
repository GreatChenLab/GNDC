args <- commandArgs(T)

options(bitmapType='cairo')

library(ggplot2)
library(stringr)
library(magrittr)
library(dplyr)
library("svglite")
data <- read.delim(args[1],stringsAsFactors = F)

data1 <- data[,3:4]
data1$TcdbID <- data1$TcdbID %>% str_sub(1,1)
data2 <- as.data.frame(table(data1))
data2 <- filter(data2, Freq > 0)
data2 <- mutate(data2, label = paste(TcdbID,Class,sep = ":"))

ggplot(data2, aes(TcdbID,Freq,fill=label)) + geom_bar(stat = "identity",width = .6) +
  xlab("Class") + ylab("Number of Seqcence") + 
  theme_classic() + theme(legend.title = element_blank()) +
  scale_y_continuous(expand = c(0,0))

ggsave("TCDB.svg",width = 8,height = 8)
ggsave("TCDB.pdf",width = 8,height = 8)
dev.off()
ggsave("TCDB.png",width = 8,height = 8)

