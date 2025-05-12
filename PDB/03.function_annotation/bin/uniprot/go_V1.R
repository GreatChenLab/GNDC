args=commandArgs(TRUE)
if (length(args) != 1) {
  print ("usage:Rscript go.R <go_annotion.txt> ")
  q()
}

inputFile <-args[1]
library("ggplot2")
library("dplyr")
library("ggthemes")
library("gridExtra")
library("svglite")
#detach("package:plyr")

## GO 
go <- read.delim (file=inputFile, head =T , sep ="\t")
go_count <- group_by(go, NameSpace, GOterm) %>% summarise(number_of_genes = n())
molecular_function <- filter(go_count, NameSpace == "molecular_function") %>% arrange( desc(number_of_genes)) %>% slice(1:20)
cellular_component <- filter(go_count, NameSpace == "cellular_component") %>% arrange( desc(number_of_genes)) %>% slice(1:20)
biological_process <- filter(go_count, NameSpace == "biological_process") %>% arrange( desc(number_of_genes)) %>% slice(1:20)
go_count_filter <- rbind(molecular_function, cellular_component, biological_process)
#go_count_filter$GOterm=factor(go_count_filter$GOterm,levels=go_count_filter$GOterm)
maxnum <- max (go_count_filter$number_of_genes) + 5
ggplot(data = go_count_filter) + 
  geom_bar(aes(x = GOterm, y = number_of_genes, fill = NameSpace) , stat = "identity") + 
  #geom_text(aes(x = GOterm, y = number_of_genes,label= number_of_genes, vjust = -0.3)) +
  facet_wrap(~NameSpace, scales = "free") + 
  theme_bw() + theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank()) +
  theme(axis.text.x=element_text(angle=-60, size=8, hjust = 0)) + 
  labs(y="Number of genes",fill = "Class") + 
  scale_y_continuous(limits = c(0,maxnum))
#scale_y_continuous(expand = c(0,0))
ggsave("go.svg", width = 12, height = 8)
ggsave("go.pdf", width = 12, height = 8)
ggsave("go.png", width = 12, height = 8)
