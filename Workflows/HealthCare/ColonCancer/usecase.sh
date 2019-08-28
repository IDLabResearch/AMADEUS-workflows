#
# Rosa gets diagnosed with colon cancer, and we make a treatment plan.

#Data about Rosa: patientData/Rosa.n3, rules about colon cancer: treatmentPlan/gps-desc.n3, goal: treatmentPlan/goal.n3

#!/bin/bash

eye  patientData/Rosa.n3 treatmentPlan/gps-desc.n3 treatmentPlan/gps-knowledge.n3 ../../Plugin/gps-plugin.n3 --query treatmentPlan/gps-query.n3 --nope > treatmentPlan/plan-T0.n3


#remark: If needed I can also generate csv here, do we need that for the visualisation?


#from the two possible treatment plans we choose the one including chemotherapy. We have to indicate that and produce an N3 file stating our decision. 

#We have her treatmentPlan/cancerChosenPath.n3

#Next we need to add timestamps to our chosen path:
eye  treatmentPlan/cancerChosenPath.n3 otherData/t0.ttl ../../Plugin/gps-temporal-rule.n3 treatmentPlan/gps-desc.n3 --query ../../Plugin/gps-temporal-query.n3q --nope > treatmentPlan/initialPathT1.n3

#For this chemotherapy, we do a second planning step which provides us with the details

#Generate query (that will be used to generate sub steps).
eye --nope treatmentPlan/initialPathT1.n3 treatmentPlan/gps-desc.n3 --query treatmentPlan/chemotherapy-goal-creation.n3q > treatmentPlan/goal_neoadjuvant_chemoradiotherapy.n3q

#Generate sub-plans for neoadjuvant-chemoradiotherapy.
eye --nope treatmentPlan/initialPathT1.n3 treatmentPlan/gps-desc.n3 treatmentPlan/gps-desc-details.n3 ../../Plugin/gps-plugin.n3 --query treatmentPlan/goal_neoadjuvant_chemoradiotherapy.n3q >treatmentPlan/path_neoadjuvant_chemoradiotherapy.n3
