#This code extracts a table from a pdf file using data wrangling techniques in R

#@author: Benjamin O. Tayo

#date: 8/15/2018

#import necessary libraries
library("stringr")
library("pdftools")

#define path of the file
pdf_file<-file.path("C:\\Users\\btayo\\Desktop\\TRADE", "trade_report.pdf")
text <- pdf_text(pdf_file)

#wrangle the data to clean and organize
tab <- str_split(text, "\n")[[1]][6:31]
tab[1]<-tab[1]%>%str_replace("\\.","")%>%str_replace("\r","")
col_names <-str_replace_all(tab[1],"\\s+"," ")%>%str_replace(" ", "")%>%str_split(" ")%>%unlist()
col_names<-col_names[-3]
col_names[2]<-"Trade_id"
col_names<-append(col_names, "Time", 5)
col_names<-append(col_names,"sign",9)
length(col_names)==11
tab<-tab[-1]
dat<-data.frame(x=tab%>%str_replace_all("\\s+"," ")%>%str_replace_all("\\s*USD","")%>%str_replace(" ",""),stringsAsFactors = FALSE)
data<-dat%>%separate(x,col_names,sep=" ")
data<-data%>%mutate(total=paste(data$sign,data$Total,sep=""))%>%select(-c(sign,Total))
names(data)<-names(data)%>%tolower()
data$product<-data$product%>%str_replace("-$","")
data%>%head()
