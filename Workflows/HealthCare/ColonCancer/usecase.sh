#
# Rosa gets diagnosed with colon cancer, and we make a treatment plan.

#Data about Rosa: patientData/Rosa.n3, rules about colon cancer: treatmentPlan/gps-desc.n3, goal: treatmentPlan/goal.n3

#!/bin/bash

eye  patientData/Rosa.n3 treatmentPlan/gps-desc.n3 treatmentPlan/gps-knowledge.n3 ../../Plugin/gps-plugin.n3 --query treatmentPlan/gps-query.n3 --nope > treatmentPlan/plan-T0.n3


#remark: If needed I can also generate csv here, do we need that for the visualisation?


#from the two possible treatment plans we choose the one including chemotherapy. We have to indicate that and produce an N3 file stating our decision. 

#We have here treatmentPlan/cancerChosenPath.n3

#Next we need to add timestamps to our chosen path:
eye  treatmentPlan/cancerChosenPath.n3 otherData/t0.ttl ../../Plugin/gps-temporal-rule.n3 treatmentPlan/gps-desc.n3 --query ../../Plugin/gps-temporal-query.n3q --nope > treatmentPlan/initialPathT1.n3

#For this chemotherapy, we do a second planning step which provides us with the details

#Generate query (that will be used to generate sub steps).
eye --nope treatmentPlan/initialPathT1.n3 treatmentPlan/gps-desc.n3 --query treatmentPlan/chemotherapy-goal-creation.n3q > treatmentPlan/goal_neoadjuvant_chemoradiotherapy.n3q

#Generate sub-plans for neoadjuvant-chemoradiotherapy.
eye --nope treatmentPlan/contraindications.n3 treatmentPlan/initialPathT1.n3 treatmentPlan/gps-desc.n3 treatmentPlan/gps-desc-details.n3 ../../Plugin/gps-plugin.n3 --query treatmentPlan/goal_neoadjuvant_chemoradiotherapy.n3q >treatmentPlan/path_neoadjuvant_chemoradiotherapy.n3

#choose an option (here we only have one) and state that in a file: selectedpath_neoadjuvant_chemoradiotherapy.n3

#add time stamps to that path
eye  treatmentPlan/selectedpath_neoadjuvant_chemoradiotherapy.n3 otherData/t0.ttl ../../Plugin/gps-temporal-rule.n3 treatmentPlan/gps-desc-details.n3 --query ../../Plugin/gps-temporal-query.n3q --nope > treatmentPlan/sub_initialPathT1.n3

#make the path an "aggregated path" (we simply rename here since we only have one path)
eye --nope ../../Plugin/initialToAggregated.n3 treatmentPlan/sub_initialPathT1.n3 --query ../../Plugin/gps-aggregation-query.n3q > treatmentPlan/aggreagatedPath-t1.n3


#T1: first session chemo is taken, check whether we are still "on track" (not sure whether this should be in the demo)
eye --nope patientData/Rosa.n3 otherData/t1.ttl treatmentPlan/contraindications.n3 treatmentPlan/gps-desc-details.n3  treatmentPlan/sub_initialPathT1.n3 ../../Plugin/gps-plugin-validation.n3 --query treatmentPlan/goal_neoadjuvant_chemoradiotherapy.n3q > result_t1.n3

#T2: patient gets influenza, this is reflected in her profile: Rosa_T2.n3 

#generate plans for influenza
eye --nope patientData/Rosa_T2.n3 treatmentPlan/gps-desc_influenza.n3 ../../Plugin/gps-plugin.n3 --query treatmentPlan/gps-query-influenza.n3 > treatmentPlan/plan-T2.n3

#we again choose a plan and indicate that treatmentPlan/influenzaChosenPath.n3

# we consider two different dates

########## Alternative 1 - no conflict ################
#we again add time stamps assuming that it is November 4th
eye  treatmentPlan/influenzaChosenPath.n3 otherData/t3.ttl ../../Plugin/gps-temporal-rule.n3 treatmentPlan/gps-desc_influenza.n3 --query ../../Plugin/gps-temporal-query.n3q --nope > treatmentPlan/InfluenzaPathT3.n3

#make aggregated path
eye --nope treatmentPlan/InfluenzaPathT3.n3 treatmentPlan/aggreagatedPath-t1.n3 ../../Plugin/gps-aggregataion-rule.n3 --query ../../Plugin/gps-temporal-query.n3q > treatmentPlan/initial-aggreagated-path-t3.n3

eye --nope patientData/Rosa_T2.n3  otherData/t3.ttl treatmentPlan/gps-desc_influenza.n3 treatmentPlan/contraindications.n3 treatmentPlan/gps-desc-details.n3 treatmentPlan/initial-aggreagated-path-t3.n3 ../../Plugin/gps-plugin-aggregated-path-processing.n3 --tactic limited-answer 1 --query ../../Plugin/gps-aggregation-query.n3q > treatmentPlan/aggreagated-path-t3.n3

#validate aggregated path
eye --nope treatmentPlan/gps-desc_influenza.n3 treatmentPlan/contraindications.n3 treatmentPlan/gps-desc-details.n3   patientData/Rosa_T2.n3 otherData/t3.ttl treatmentPlan/initial-aggreagated-path-t3.n3 ../../Plugin/findConflicts.n3  --query ../../Plugin/conflictGoal.n3 >treatmentPlan/check_t3.n3

#eye --nope treatmentPlan/gps-desc_influenza.n3 treatmentPlan/contraindications.n3 treatmentPlan/gps-desc-details.n3   patientData/Rosa_T2.n3 otherData/t3.ttl treatmentPlan/initial-aggreagated-path-t3.n3 ../../Plugin/findConflicts.n3 treatmentPlan/goal_neoadjuvant_chemoradiotherapy.n3q treatmentPlan/gps-query-influenza.n3 ../../Plugin/checkGoals.n3 --query ../../Plugin/conflictGoal.n3 >treatmentPlan/check_t3.n3



########## Alternative 2 - conflict ################
#Alternative assuming that it is November 16th
eye  treatmentPlan/influenzaChosenPath.n3 otherData/t4.ttl ../../Plugin/gps-temporal-rule.n3 treatmentPlan/gps-desc_influenza.n3 --query ../../Plugin/gps-temporal-query.n3q --nope > treatmentPlan/InfluenzaPathT4.n3

#make aggregated path (only times + start/end)
eye --nope treatmentPlan/InfluenzaPathT4.n3 treatmentPlan/aggreagatedPath-t1.n3 ../../Plugin/gps-aggregataion-rule.n3 --query ../../Plugin/gps-temporal-query.n3q > treatmentPlan/initial-aggreagated-path-t4.n3

#validate aggregated path
eye --nope treatmentPlan/gps-desc_influenza.n3 treatmentPlan/contraindications.n3 treatmentPlan/gps-desc-details.n3   patientData/Rosa_T2.n3 otherData/t4.ttl treatmentPlan/initial-aggreagated-path-t4.n3 ../../Plugin/findConflicts.n3 --query ../../Plugin/conflictGoal.n3 > treatmentPlan/check_t4.n3 
