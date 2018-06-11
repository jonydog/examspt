##
## This file contains the import script from xlsx data intto a MySQL database
##
library("RODBC")
library(openxlsx)
baseDir <- "~/examspt/data_xlsx/"
years <- 2010:2017
conn <- RODBC::odbcConnect(dsn = "exams_db")

deleteAllTablesInOrder(conn)

##import concelhos
importConcelhos(conn,baseDir,years)

##import districts
importDistricts(conn,baseDir,years)

##import schools
importSchools(conn,baseDir,years)

##import course types
importCourseTypes(conn,baseDir,years)

##import course subtypes
importCourseSubTypes(conn,baseDir,years)

## import courses
importCourses(conn,baseDir,years)

## import exam type
importExamTypes(conn,baseDir,years)

## import examination
importExams(conn,baseDir,years)


##
## Now we import municipality-level data of several socioeconomic indicators
##

##  percentage of ileterate population 
importMunicipalityGenericData(
  conn=conn,
  filename = "pordata_varios/population/pordata_analfabetismo.xlsx",
  tableName = "pordata_ileteracy",
  dataCol = "percent_analfabeta",
  concelhoCol = "codigo_concelho"
)


##  crime rate by 1000 residents
importMunicipalityGenericData(
  conn=conn,
  filename = "~/Desktop/data_xlsx/pordata_varios/crime/pordata_crime.xlsx",
  tableName = "pordata_crime",
  dataCol = "media_crime",
  concelhoCol = "codigo_concelho"
)
  

##  number divorces for 100 weddings
importMunicipalityGenericData(
  conn=conn,
  filename = "~/Desktop/data_xlsx/pordata_varios/divorces/pordata_divorces.xlsx",
  tableName = "pordata_divorces",
  dataCol = "divorce_rate",
  concelhoCol = "codigo_concelho"
)


##  child mortality rate
importMunicipalityGenericData(
  conn=conn,
  filename = "~/Desktop/data_xlsx/pordata_varios/child_mortality/pordata_child_mortality.xlsx",
  tableName = "pordata_child_mortality",
  dataCol = "mortality_rate",
  concelhoCol = "codigo_concelho"
)

##  child mortality rate
importMunicipalityGenericData(
  conn=conn,
  filename = "~/Desktop/data_xlsx/pordata_varios/births_outof_wedlock/pordata_birthswedlock.xlsx",
  tableName = "pordata_births_wedlock",
  dataCol = "birth_out_wedlock",
  concelhoCol = "codigo_concelho"
)


##  population for 1 doctor
importMunicipalityGenericData(
  conn=conn,
  filename = "~/Desktop/data_xlsx/pordata_varios/doctors/pordata_doctors.xlsx",
  tableName = "pordata_doctors",
  dataCol = "people_per_doctor",
  concelhoCol = "codigo_concelho"
)

## university_degree_rate
importMunicipalityGenericData(
  conn=conn,
  filename = "~/Desktop/data_xlsx/pordata_varios/pop_education/pordata_education.xlsx",
  tableName = "pordata_university",
  dataCol = "percent_university",
  concelhoCol = "codigo_concelho"
)

## purchase power 
importMunicipalityGenericData(
  conn=conn,
  filename = "~/Desktop/data_xlsx/pordata_varios/purchase_power/pordata_purchase_power.xlsx",
  tableName = "pordata_purchase",
  dataCol = "purchase_power",
  concelhoCol = "codigo_concelho"
)



