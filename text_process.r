setwd("C:/Users/will/Dropbox/code/four_quartets/")
library('tm')
library('RTextTools')
if (Sys.getenv("JAVA_HOME")!="")
  Sys.setenv(JAVA_HOME="")
library(rJava)
library(lsa)

library(ggplot2)
library(plyr)
library(reshape2)

dtm.to.sm <- function(dtm){
  sparseMatrix(i=dtm$i, j=dtm$j, x=dtm$v,
               dims=c(dtm$nrow, dtm$ncol))
}

poem.data <- read.csv("./four_quartets.csv",stringsAsFactors=FALSE)

#allows us to compare the poem between each song
#full.song.poem <- tapply(poem.data$poem,poem.data$song,function(x)paste(x,collapse="\n"))

#order by actual album ordering when you have a chance...
#song.data <- data.frame(song=labels(full.song.poem),poem=full.song.poem)


#poem time
poem.corpus <- Corpus(VectorSource(poem.data$line))

poem.corpus <- tm_map(poem.corpus,stripWhitespace)
poem.corpus <- tm_map(poem.corpus,removePunctuation)
poem.corpus <- tm_map(poem.corpus,tolower)


# because poem are so dense I think both stemming and remove stopwords is a bit risky
# poem.corpus <- tm_map(poem.corpus, removeWords, stopwords("english"))
# poem.corpus <- tm_map(poem.corpus,stemDocument)

print("creating dtm")
poem.dtm <- DocumentTermMatrix(poem.corpus,control = list(weighting =
                                                                function(x)
                                                                  weightTfIdf(x, normalize =
                                                                                FALSE)))

poem.sm <- dtm.to.sm(poem.dtm)

for(quartet in unique(poem.data$quartet)){
  for(stanza in unique(poem.data$stanza[which(poem.data$quartet == quartet)])){
   name.print <- paste(quartet,stanza)
   name.file <- tolower(gsub(" ","_",name.print))
   print(name.print)
   selected <- which(poem.data$quartet == quartet & poem.data$stanza == stanza)
   dis.m <- t(cosine(t(as.matrix(poem.sm[selected,]))))

   image = qplot(x=Var1, y=Var2,data=melt(dis.m),fill=value,geom="tile",
         main=name.print) + theme(legend.position="none", panel.grid.major = element_blank(),
                                                                               panel.grid.minor = element_blank(),
                                                                               panel.border = element_blank(),
                                                                               panel.background = element_blank(),
                                                                               axis.ticks = element_blank(),
                                                                               axis.text = element_blank(),
                                                                               axis.title = element_blank()
         ) + coord_fixed()
   
   ggsave(paste("./images/",name.file,'.png',sep=''),plot=image)
    
  }
}
