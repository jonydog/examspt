##
## SQL Tables with creation of snowflake sch
##
CREATE TABLE CONCELHO(
	id CHAR(4),
	
  description varchar(255),
  
  PRIMARY KEY(id)
);


CREATE TABLE DISTRICT(
	id CHAR(2),
	
  description varchar(255),
  
  PRIMARY KEY(id)
);


CREATE TABLE SCHOOL(
  
  id CHAR(4),
  
  description varchar(255),
  
  pub_priv varchar(50),
  
  district_id char(2),
  
  concelho_id char(4),
  
  PRIMARY KEY(id),
  FOREIGN KEY(district_id) REFERENCES DISTRICT(id),
  FOREIGN KEY(concelho_id) REFERENCES CONCELHO(id)
)


CREATE TABLE COURSE_TYPE(
  
  id CHAR(1),
  
  description varchar(255),
  
  begin_year int,
  
  end_year int,
  
  orden int,
  
  PRIMARY KEY(id)
)


CREATE TABLE COURSE_SUBTYPE(
  
  id CHAR(3),
  
  description varchar(255),
  
  course_type_id char(1),
  
  PRIMARY KEY(id),
  FOREIGN KEY(course_type_id) REFERENCES COURSE_TYPE(id)
)


CREATE TABLE COURSE(
  
  id CHAR(3),
  
  description varchar(255),
  
  course_type_id char(1),
  
  course_subtype_id char(3),
  
  PRIMARY KEY(id),
  FOREIGN KEY(course_type_id) REFERENCES COURSE_TYPE(id),
  FOREIGN KEY(course_subtype_id) REFERENCES COURSE_SUBTYPE(id)
)


CREATE TABLE EXAM_TYPE(
  
  id CHAR(3),
  
  description varchar(255),
  
  course_type_id char(1),
  
  course_subtype_id char(3),
  
  PRIMARY KEY(id),
  FOREIGN KEY(course_type_id) REFERENCES COURSE_TYPE(id),
  FOREIGN KEY(course_subtype_id) REFERENCES COURSE_SUBTYPE(id)
)


CREATE TABLE EXAM_TYPE(
  
  id CHAR(3),
  
  description varchar(255),
  
  PRIMARY KEY(id)
)


CREATE TABLE EXAM(
  
  id int,
  
  year int,
  
  school_id char(4),
  
  phase int,
  
  exam_type_id char(3),
  
  for_approval char(1),
  
  internal char(1),
  
  to_improve char(1),
  
  to_ingress char(1),
  
  has_internal varchar(10),
  
  sex char(1),
  
  age int,
  
  course_id char(3),
  
  cif int,
  
  exam_score int,
  
  cfd int,
  
  PRIMARY KEY(id,year),
  
  FOREIGN KEY(exam_type_id) REFERENCES EXAM_TYPE(id),
  
  FOREIGN KEY(school_id) REFERENCES SCHOOL(id),
  
  FOREIGN KEY(course_id) REFERENCES COURSE(id)

)
CREATE INDEX year_index ON EXAM(year) USING BTREE;
