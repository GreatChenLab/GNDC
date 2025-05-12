args=commandArgs(TRUE)
if (length(args) != 4) {
  print ("usage:Rscript cog.data.R <eggnog.txt> <cog.txt> <CogClass.txt> <Outfile>")
  q()
}
inputFile <- args[1]
inref1 <- args[2]   ##"/calculate/database/uniprot/2022-03-09/cog.txt"
inref2 <- args[3]   ##"/calculate/database/uniprot/2022-03-09/CogClass.txt"
outfile <- args[4]
a <- as.data.frame(read.delim(file=inputFile, header = F,check.names = F,encoding = "UTF-8",comment.char = '#'))[,c(1,5)]
ref1 <- as.data.frame(read.delim(file = inref1, header = F, row.names = 1,check.names = F,encoding = "UTF-8"))
ref2 <- as.data.frame(read.delim(file = inref2, header = F, row.names = 1,check.names = F,encoding = "UTF-8"))
# ref1$CogClassName <- ref1$CogName
# ref1$CogClassName[ref1$CogClassCode==rownames(ref2)] <- ref2[rownames(ref2),]

colnames(a) <- c("query","eggNOG_OGs")
colnames(ref1) <- c("CogClassCode","CogName")
colnames(ref2) <- c("CogClassName")
for (i in 1:nrow(a)) {
  a$eggNOG_OGs[i] <- unlist(strsplit(a$eggNOG_OGs[i],"@"))[1]
}
# a$eggNOG_OGs <- unlist(strsplit(a$eggNOG_OGs,"@"))

a <- a[a$eggNOG_OGs %in% rownames(ref1),]


a$CogName<-a$eggNOG_OGs
a$CogClassName<-a$eggNOG_OGs
a$CogClassCode<-a$eggNOG_OGs
colnames(a) <- c("SeqID","CogID","CogName","CogClassName","CogClassCode")


# b<-data.frame(ncol=c("SeqID","CogID","CogName","CogClassName","CogClassCode"))
b<-a

for (i in 1:nrow(b)) {
  a$CogName[i] <-  ref1$CogName[rownames(ref1)==a$CogID[i]]
  a$CogClassCode[i] <-  ref1$CogClassCode[rownames(ref1)==a$CogID[i]]
  type <- strsplit(a$CogClassCode[i],"")[[1]]  
  if(length(type)>1){
    a$CogClassCode[i] <- type[1]
    a$CogClassName[i] <- ref2$CogClassName[rownames(ref2)==type[1]]
    for (y in 2:length(type)) {
      x<- unlist(c(a[i,1:3],ref2$CogClassName[rownames(ref2)==type[y]],type[y]))
      a <- rbind(a,x)
    }
  }else{
    a$CogClassName[i] <- ref2$CogClassName[rownames(ref2)==type[1]]
    
  }
  
}

write.table(a,file = outfile,sep = "\t",quote = F,fileEncoding = "utf-8",row.names = F)
