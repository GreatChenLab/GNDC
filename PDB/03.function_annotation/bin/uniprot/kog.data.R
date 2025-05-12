args=commandArgs(TRUE)
if (length(args) != 4) {
  print ("usage:Rscript kog.data.R <eggnog.txt> <kog.txt> <CogClass.txt>")
  q()
}
inputFile <- args[1]
inref1 <- args[2]   ##"/calculate/database/uniprot/2022-03-09/kog.txt"
inref2 <- args[3]   ##"/calculate/database/uniprot/2022-03-09/CogClass.txt"
outfile <- args[4]
a <- as.data.frame(read.delim(file=inputFile, header = F,check.names = F,encoding = "UTF-8",comment.char = '#'))[,c(1,5)]
ref1 <- as.data.frame(read.delim(file = inref1, header = F, row.names = 1,check.names = F,encoding = "UTF-8"))
ref2 <- as.data.frame(read.delim(file = inref2, header = F, row.names = 1,check.names = F,encoding = "UTF-8"))
# ref1$CogClassName <- ref1$CogName
# ref1$CogClassName[ref1$CogClassCode==rownames(ref2)] <- ref2[rownames(ref2),]

colnames(a) <- c("query","eggNOG_OGs")
colnames(ref1) <- c("KogClassCode","KogName")
colnames(ref2) <- c("KogClassName")
for (i in 1:nrow(a)) {
  a$eggNOG_OGs[i] <- unlist(strsplit(a$eggNOG_OGs[i],"@"))[1]
}
# a$eggNOG_OGs <- unlist(strsplit(a$eggNOG_OGs,"@"))

a <- a[a$eggNOG_OGs %in% rownames(ref1),]


a$KogName<-a$eggNOG_OGs
a$KogClassName<-a$eggNOG_OGs
a$KogClassCode<-a$eggNOG_OGs
colnames(a) <- c("SeqID","KogID","KogName","KogClassName","KogClassCode")


# b<-data.frame(ncol=c("SeqID","CogID","CogName","CogClassName","CogClassCode"))
b<-a

for (i in 1:nrow(b)) {
  a$KogName[i] <-  ref1$KogName[rownames(ref1)==a$KogID[i]]
  a$KogClassCode[i] <-  ref1$KogClassCode[rownames(ref1)==a$KogID[i]]
  type <- strsplit(a$KogClassCode[i],"")[[1]]  
  if(length(type)>1){
    a$KogClassCode[i] <- type[1]
    a$KogClassName[i] <- ref2$KogClassName[rownames(ref2)==type[1]]
    for (y in 2:length(type)) {
      x<- unlist(c(a[i,1:3],ref2$KogClassName[rownames(ref2)==type[y]],type[y]))
      a <- rbind(a,x)
    }
    }else{
      a$KogClassName[i] <- ref2$KogClassName[rownames(ref2)==type[1]]

  }

}

write.table(a,file = outfile,sep = "\t",quote = F,fileEncoding = "utf-8",row.names = F)
