##
##
## This file contains the functions used to read .mdb files
##

##
## stringFormatter
##
properStringFormat <- function(s){
  
  newstring <- gsub(pattern = "'",replacement = "`",x = s ,fixed = T)
  
  return(newstring)
}


## 
## This function deletes the content of all database tables in such order that respects FK constraints
##
deleteAllTablesInOrder <- function(conn){
  
  sqlQuery(channel = conn, query = "delete from exam" )
  
  sqlQuery(channel = conn, query = "delete from school" )
  sqlQuery(channel = conn, query = "delete from concelho")
  sqlQuery( channel = conn, query= "delete from district" )
}

##
## import of table tblCodsConcelho
##
importConcelhos <- function(conn,baseDir,years){

  for( year in years ){
    
    current_filename <- paste0( baseDir, "result_", year, "/tblCodsConcelho_" , year  ,".xlsx")
    
      current_data <- read.xlsx( current_filename ,sheet = 1, colNames = TRUE )
      
      for( i in 1:nrow(current_data) ){
          
        insert_statement <- paste0(
          "insert into concelho (id,description) values ('", paste0( current_data$Distrito[i], current_data$Concelho[i] ) , "' , '", current_data$Description[i] , "') "
        )
        
       ret <-  sqlQuery(conn, insert_statement)
       
       if( length(ret)!=0 ){
         cat( ret , "\n")
       }
      }
  }
}

##
## import of table tblCodsDistrito
## 
importDistricts <- function(conn,baseDir,years){

  for( year in years ){
    
    current_filename <- paste0( baseDir, "result_", year, "/tblCodsDistrito_" , year  ,".xlsx")
    
    current_data <- read.xlsx( current_filename ,sheet = 1, colNames = TRUE )
    
    for( i in 1:nrow(current_data) ){
      
      insert_statement <- paste0(
        "insert into DISTRICT (id,description) values ('",current_data$Distrito[i] , "' , '", current_data$Descr[i] , "') "
      )
      
      ret <-  sqlQuery(conn, insert_statement)
      
      if( length(ret)!=0 ){
        cat( ret , "\n")
      }
    }
  }
  
}




##
## import of table tblCodsDistrito
## 
importSchools <- function(conn,baseDir,years){
  
  for( year in years ){
    
    current_filename <- paste0( baseDir, "result_", year, "/tblEscolas_" , year  ,".xlsx")
    
    current_data <- read.xlsx( current_filename ,sheet = 1, colNames = TRUE )
    
    for( i in 1:nrow(current_data) ){
      
      insert_statement <- paste0(
        "insert into SCHOOL (id,description,pub_priv,district_id,concelho_id) values ('",
            current_data$Escola[i] , "' , ", 
           "'",properStringFormat(current_data$Descr[i]) , "', ",
           "'",current_data$PubPriv[i], "', ",
           "'",current_data$Distrito[i],"', ",
           "'",paste0( current_data$Distrito[i], current_data$Concelho[i] ), "' )"
      )
      
      ret <-  sqlQuery(conn, insert_statement)
      
      if( length(ret)!=0 ){
        cat( ret , "\n")
      }
    }
  }
  
}


##
## import of table tbCursosTipos
## 
importCourseTypes <- function(conn,baseDir,years){
  
  for( year in years ){
    
    current_filename <- paste0( baseDir, "result_", year, "/tblCursosTipos_" , year  ,".xlsx")
    
    current_data <- read.xlsx( current_filename ,sheet = 1, colNames = TRUE )
    
    for( i in 1:nrow(current_data) ){
      
      insert_statement <- paste0(
        "insert into COURSE_TYPE (id,description,begin_year,end_year,orden) values ('",
        current_data$TpCurso[i] , "' , ", 
        "'",properStringFormat(current_data$Descr[i]) , "', ",
        current_data$Ano_Ini[i], " , ",
        current_data$Ano_Term[i]," , ",
        current_data$Ordena, " )"
      )
      
      ret <-  sqlQuery(conn, insert_statement)
      
      if( length(ret)!=0 ){
        cat( ret , "\n")
      }
    }
  }

}


##
## import of table tblCursosSubTipos
## 
importCourseSubTypes <- function(conn,baseDir,years){
  
  for( year in years ){
    
    current_filename <- paste0( baseDir, "result_", year, "/tblCursosSubTipos_" , year  ,".xlsx")
    
    current_data <- read.xlsx( current_filename ,sheet = 1, colNames = TRUE )
    
    for( i in 1:nrow(current_data) ){
      
      insert_statement <- paste0(
        "insert into COURSE_SUBTYPE (id,description,course_type_id) values ('",
        current_data$SubTipo[i] , "' , ", 
        "'",properStringFormat(current_data$Descr[i]) , "', '",
        current_data$TpCurso[i], "' ) "
      )
      
      ret <-  sqlQuery(conn, insert_statement)
      
      if( length(ret)!=0 ){
        cat( ret , "\n")
      }
    }
  }
}

##
## import of table tblCursos
## 
importCourses <- function(conn,baseDir,years){
  
  
  for( year in years ){
    
    current_filename <- paste0( baseDir, "result_", year, "/tblCursos_" , year  ,".xlsx")
    
    current_data <- read.xlsx( current_filename ,sheet = 1, colNames = TRUE )
    
    for( i in 1:nrow(current_data) ){
      
      insert_statement <- paste0(
        "insert into COURSE (id,description,course_type_id,course_subtype_id) values ('",
        current_data$Curso[i] , "' , ", 
        "'",properStringFormat(current_data$Descr[i]) , "', '",
        current_data$TpCurso[i], "', ",
        "'",current_data$SubTipo[i], "' )"
      )
      
      ret <-  sqlQuery(conn, insert_statement)
      
      if( length(ret)!=0 ){
        cat( ret , "\n")
      }
    }
  }
  
}


## 
## Import exam types
## 
importExamTypes <- function(conn,baseDir,years){
  
  for( year in years ){
    
    current_filename <- paste0( baseDir, "result_", year, "/tblExames_" , year  ,".xlsx")
    
    current_data <- read.xlsx( current_filename ,sheet = 1, colNames = TRUE )
    
    for( i in 1:nrow(current_data) ){
      
      insert_statement <- paste0(
        "insert into EXAM_TYPE (id,description) values ('",
        current_data$Exame[i] , "' , ", 
        "'", properStringFormat( current_data$Descr[i] ), "' )"
      )
      
      ret <-  sqlQuery(conn, insert_statement)
      
      if( length(ret)!=0 ){
        cat( ret , "\n")
      }
    }
  }
  
}


##
## Import exam data
##
importExams <- function(conn,baseDir,years){
  
  for( year in years ){
    
    current_filename <- paste0( baseDir, "result_", year, "/tblHomologa_" , year  ,".xlsx")
    
    current_data <- read.xlsx( current_filename ,sheet = 1, colNames = TRUE )
    
    for( i in 1:nrow(current_data) ){

      cif <- 'NULL'
      if( is.na(current_data$CIF[i]) ){
        cif <- 'NULL'
      }
      else{
        cif <- current_data$CIF[i]
      }
      
      insert_statement <- paste0(
        "insert into EXAM ", 
        "(id,year,school_id,phase,exam_type_id,for_approval,internal,to_improve,to_ingress,has_internal,sex,age,course_id,cif,exam_score,cfd) values (",
        current_data$ID[i], " , ", 
        year, " ,  ",
        "'",current_data$Escola[i],"' , ",
        current_data$Fase[i], " , ",
        "'",current_data$Exame[i],"', ",
        "'",current_data$ParaAprov[i],"' , ",
        "'",current_data$Interno[i],"' , ",
        "'",current_data$ParaMelhoria[i],"' , ",
        "'",current_data$ParaIngresso[i],"' , ",
        "'",current_data$TemInterno[i],"' , ",
        "'",current_data$Sexo[i],"' , ",
        "'",current_data$Idade[i],"' , ",
        "'",current_data$Curso[i],"' , ",
        cif," , ",
        current_data$Class_Exam[i]," , ",
        current_data$CFD[i]," )"
      )
      
      ret <-  sqlQuery(conn, insert_statement)
      
      if( length(ret)!=0 ){
        cat( ret , "\n")
      }
    }
  }
}


##
## This function imports generic data associated with the municipality
##
importMunicipalityGenericData <- function(conn,filename,tableName,dataCol,concelhoCol){
  
  current_filename <- filename
  
  current_data <- read.xlsx( current_filename ,sheet = 1, colNames = TRUE )
  
  
  ## DDL
  drop_statement <- paste0("drop table ",tableName)
  sqlQuery( conn, drop_statement )
  
  create_table_statement <- paste0( "create table ", tableName ," ( concelho_id char(4), data float, PRIMARY KEY(concelho_id), FOREIGN KEY(concelho_id) REFERENCES CONCELHO(id)  ) " )
  sqlQuery( conn, create_table_statement )
  
  ## end of DDL
  
  for( i in 1:nrow(current_data) ){
    
    insert_statement <- paste0(
      "insert into " , tableName , "  values ('",
      current_data[i,concelhoCol] , "' , ", 
       current_data[i,dataCol] ,")"
    )
    
    ret <-  sqlQuery(conn, insert_statement)
    
    if( length(ret)!=0 ){
      cat( ret , "\n")
    }
  
  }
  
}








