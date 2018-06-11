##
##
## File containing socio economic regressions by school level 
##
##

library("RODBC")
conn <- RODBC::odbcConnect(dsn = "exams_db")
subjectsTable <- sqlQuery(conn,"select * from exam_type")


for( subjectId in subjectsTable$id ){

  queryBySubjectByStudent = paste0(
    "select  e.exam_score as 'media', ",
    " e.school_id,  ",
    " s.description as 'school_name', ",
    " c.description as 'concelho', ",
    " e.sex, ",
    " e.phase, ",
    " e.for_approval, ",
    " e.internal, ",
    " e.age, ",
    #" cor.course_type_id, ",
    "wed.data as 'births_out', ",
    "child.data as 'child_mort_rate',",
    "crime.data as 'crime_rate',",
    "divorces.data as 'divorce_rate',",
    "ilet.data as 'ilet_rate',",
    "pur.data as 'purchase_power',",
    "univ.data as 'university_rate'",
    " from exam e ",
    " left join COURSE cor on e.course_id=cor.id ",
    " left join school s on e.school_id=s.id ",
    " left join concelho c on s.concelho_id=c.id ",
    " left join pordata_births_wedlock wed on s.concelho_id=wed.concelho_id ",
    " left join pordata_child_mortality child on s.concelho_id=child.concelho_id ",
    " left join pordata_crime crime on s.concelho_id=crime.concelho_id  ",
    " left join pordata_divorces divorces on s.concelho_id=divorces.concelho_id  ",
    " left join pordata_ileteracy ilet on s.concelho_id=ilet.concelho_id  ",
    " left join pordata_purchase pur on s.concelho_id=pur.concelho_id ",
    " left join pordata_university univ on s.concelho_id=univ.concelho_id ",
    " where e.exam_type_id=" , subjectId, 
    " and e.year=", year
  )
  
  
  
  dataBySubjectByStudent <- sqlQuery(conn,queryBySubjectByStudent, stringsAsFactors=TRUE )
  
  ## sex char all to lower ase
  dataBySubjectByStudent$sex <- tolower( dataBySubjectByStudent$sex )
  dataBySubjectByStudent <- na.omit(dataBySubjectByStudent)
  
  ## ignore school id and name from the train data
  train_data <- dataBySubjectByStudent[,-c(2,3,4)]
  
  lmModel <- lm(formula =  media ~ . , data =  train_data )
  
  summary(lmModel)

  predictions <- predict(object = lmModel , new = train_data )
  
  meanError <- mean( abs( predictions - dataBySubjectByStudent$media ) )
  
  
  ##
  ## Calculate SEAR
  ##
  out <- calculateSEAR(predictions, original_data =  dataBySubjectByStudent)
  
    
}
