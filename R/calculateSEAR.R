calculateSEAR <- function( predictions, original_data ){
  
  all_data <- as.data.frame( cbind( predictions, original_data ) )
  
  
  mean_agg_predictions <- aggregate( formula=predictions ~ school_name + concelho , data=all_data ,FUN = mean   )  
  
  mean_agg_observed <- aggregate( formula= media ~ school_name + concelho , data=all_data ,FUN = mean   ) 
  
  if( sum( !  mean_agg_observed$school_name==mean_agg_observed$school_name ) != 0){
    stop("error: aggregates do not match")
  }
  
  
  meanError <- mean( abs( mean_agg_observed$media - mean_agg_predictions$predictions )  )
  
  
  rankings_df <-  data.frame( mean_agg_observed$school_name,  mean_agg_observed$concelho , mean_agg_observed$media, mean_agg_observed$media/mean_agg_predictions$predictions ) 
  
  colnames(rankings_df) <- c("School","Municipality","AvgGrade","SEAR")
  
  return(
    list(
      meanError = meanError,
      typicalRanking = rankings_df[ order(-rankings_df$AvgGrade) , ],
      searRanking =  rankings_df[ order(-rankings_df$SEAR) ,]
    )
  )
  
}
