##
## 
## Clustering analysis
##
##

library("RODBC")
conn <- RODBC::odbcConnect(dsn = "exams_db")

subjectsTable <- sqlQuery(conn,"select * from exam_type")

## 635 - Matematica A
##
exam_subject <- 635

year <- 2016

exams <- sqlQuery(conn,paste0("SELECT exam.* , s.*,  c.description as concelho_name, ilet.data as ilet_rate, crime.data as crime_rate "
                              ," from exam "
                              ," left join school s on exam.school_id=s.id  "  
                              ," left join concelho c on s.concelho_id=c.id "
                              , " left join pordata_ileteracy ilet on ilet.concelho_id=c.id "
                              , " left join pordata_crime crime on crime.concelho_id= c.id "
                              ," where exam_type_id=",exam_subject, " and year=",year ) )

exams$school_id <- as.factor( exams$school_id )
exams$sex <-tolower(exams$sex)
exams$concelho_id <- as.factor( exams$concelho_id )

##
## Linear regression fitting
##

lm1 <- lm( formula = exam_score ~ sex + age + internal + pub_priv + phase + ilet_rate , data = exams)
print(lm1)
summary(lm1)




