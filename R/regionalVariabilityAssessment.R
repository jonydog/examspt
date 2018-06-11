##
##
## analyze the significance of municipalities on exam_score
## 
##
library("RODBC")
conn <- RODBC::odbcConnect(dsn = "exams_db")

subjectsTable <- sqlQuery(conn,"select * from exam_type")



##
##
## By stundent level
##
##

years <- c(2014)

pvalues <- c()

for( exam_subject in subjectsTable$id ){
  
  for( year in years ){
  
    exams <- sqlQuery(conn,paste0("SELECT exam.* , s.*,  c.description as concelho_name "
                                  ," from exam "
                                  ," left join school s on exam.school_id=s.id  "  
                                  ," left join concelho c on s.concelho_id=c.id "
                                  ," where exam_type_id=",exam_subject,
                                   " and year=", year ) )
    
    
    by_municipality <- aov( exam_score ~ concelho_name, data = exams ) 
    
    s <- summary(by_municipality)
    
    pvalues <- c(pvalues,s[[1]]$`Pr(>F)`)
  
  }

}






