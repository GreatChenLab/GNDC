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
class_color <- c("cellular_component" = "#a80000", # 红
                 "molecular_function" = "#ff8c00", # 橙
                 "biological_process" = "#107c10") # 绿
ggplot(data = go_count_filter,aes(y = GOterm, x = number_of_genes,fill = NameSpace,label= number_of_genes)) +
  geom_bar(stat = "identity") +
  geom_text(hjust=-0.2 , size= 3) +
  facet_wrap(~NameSpace, scales = "free",ncol=1) +
  theme_bw() + theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(),legend.direction = "vertical",
        legend.justification="left",) +
  scale_fill_manual(values=class_color)+
  labs(x="Number of genes",fill = "Class") +
  #scale_x_continuous(limits = c(0,maxnum)) +
  #scale_y_discrete(labels=function(y) str_wrap(y, width=60)) +
  lims(x=c(0,max(go_count_filter$number_of_genes)*1.1))+
  theme(axis.text.x=element_text(size=9),
        strip.background = element_blank(),
        strip.text = element_text(size=12),
        legend.position = "none",
        text=element_text(face="bold"))
  #scale_y_continuous(expand = c(0,0))
ggsave("go.svg", width = 8, height = 12)
ggsave("go.pdf", width = 8, height = 12)
ggsave("go.png", width = 8, height = 12)

