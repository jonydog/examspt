##
##
## File containing socio economic regressions by school level 
##
##

library("RODBC")
conn <- RODBC::odbcConnect(dsn = "exams_db")
subjectsTable <- sqlQuery(conn,"select * from exam_type")


for( subjectId in subjectsTable$id ){
  
  
  queryBySubjectBySchool = paste0(
    "select avg(e.exam_score) as 'media', ",
    "wed.data as 'births_out', ",
    "child.data as 'child_mort_rate', ",
    "crime.data as 'crime_rate',",
    "divorces.data as 'divorce_rate',",
    "ilet.data as 'ilet_rate',",
    "pur.data as 'purchase_power',",
    "univ.data as 'university_rate'",
    " from exam e ",
    " left join school s on e.school_id=s.id ",
    " left join concelho c on s.concelho_id=c.id ",
    " left join pordata_births_wedlock wed on s.concelho_id=wed.concelho_id ",
    " left join pordata_child_mortality child on s.concelho_id=child.concelho_id ",
    " left join pordata_crime crime on s.concelho_id=crime.concelho_id  ",
    " left join pordata_divorces divorces on s.concelho_id=divorces.concelho_id  ",
    " left join pordata_ileteracy ilet on s.concelho_id=ilet.concelho_id  ",
    " left join pordata_purchase pur on s.concelho_id=pur.concelho_id ",
    " left join pordata_university univ on s.concelho_id=univ.concelho_id ",
    " where e.exam_type_id = ",subjectId,
    " and year=2011",
    " group by (s.id) "
  )
  
  
  dataBySubjectBySchool <- sqlQuery(conn,queryBySubjectBySchool, stringsAsFactors=TRUE )
  
  
  ##
  ## Cross validation: 70% train, 30% test
  ##
  dataBySubjectBySchool <- na.omit(dataBySubjectBySchool)
  
  train_indexes <- sample( 1:nrow(dataBySubjectBySchool), replace = F , size = floor(0.7*nrow(dataBySubjectBySchool)) )
  train_data  <-  dataBySubjectBySchool[ train_indexes ,]
  test_data   <-  dataBySubjectBySchool[ -train_indexes,  ]
  
  
  lmModel <- lm(formula =  media ~ . , data =  train_data )
  summary(lmModel)

  
  predictions <- predict(object = lmModel , new = test_data )
  meanError <- mean( abs( predictions - test_data$media ) )
  
  
}
