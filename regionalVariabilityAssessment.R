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

## 635 - Matematica A
##
exam_subject <- 635

exams <- sqlQuery(conn,paste0("SELECT exam.* , s.*,  c.description as concelho_name "
                              ," from exam "
                              ," left join school s on exam.school_id=s.id  "  
                              ," left join concelho c on s.concelho_id=c.id "
                              ," where exam_type_id=",exam_subject ) )


by_municipality <- aov( exam_score ~ concelho_name, data = exams ) 


###
### average grades along time 
###

years <- 2010:2017
for(year in years){
  
  exams <- sqlQuery(conn,paste0("SELECT exam.* , s.*,  c.description as concelho_name "
                                ," from exam "
                                ," left join school s on exam.school_id=s.id  "  
                                ," left join concelho c on s.concelho_id=c.id "
                                ," where exam_type_id=",exam_subject ) 
                                ," group by "
  
}





