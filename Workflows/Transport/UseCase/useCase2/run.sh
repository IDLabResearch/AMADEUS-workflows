#!/bin/bash

#I have this file to generate descriptions, might not be needed in the demo:
eye locations.n3 --query transitionGeneration.n3 --nope >descriptions.n3

#with these descriptions we can make plans
eye rik.n3 currentLocations.n3 locations.n3 descriptions.n3 gps-plugin_interims.n3 --query gps-query.n3 --nope >out.n3

#we can rule our all plans with irrelevant steps
eye out.n3 --query cleaner.n3 > cleaned_out.n3 --nope


#here we look for the fastest connection, we have a query for that (you don't need to use it, it was for me to control)
eye --nope  cleaned_out.n3 --query find_fastest.n3 > out_fastest.n3 


#now we have the information that there is no bus conncetion between gent sint pieters and gent vogelheide. We add the information that this is blocked. We furthermore can start our journey from gent sint pieters since that is where rik will be.
eye rik.n3 currentLocations_t1.n3 locations.n3 descriptions.n3 blocked_connection.n3 gps-plugin_interims.n3 --query gps-query_t1.n3 --nope >out_t1.n3

#clean up again
eye out_t1.n3 --query cleaner.n3 > cleaned_out_t1.n3 --nope

#find fastest again
eye --nope  cleaned_out_t1.n3 --query find_fastest.n3 > out_fastest_t1.n3 

