$title Reporting

$setglobal ds \

$ifthen.unix %system.filesys% == UNIX
$setglobal ds /
$endif.unix

$setglobal outputsPath 'outputs%ds%'

Sets 
    crop            the resources planted
        / corn, hay, soy, wheat, oats, rice /
    nutrients        the nutrients
        /protein, vita, vitd/;

Parameters
    cost(crop)                      the cost per unit for each crop
    / corn 3, hay 4, soy 5, wheat 2, oats 2.4, rice 3 /
    min_nut(nutrients)              the minimum total nutrient content for each nutrient
    / protein 0.05, vita 0.09, vitd 1200 /
    max_nut(nutrients)              the maximum total nutrient content for each nutrient
    / protein 0.35, vita 0.20, vitd 2200 /;

cost(crop)$(NOT SAMEAS(crop,"wheat")) = 0.7 * cost(crop);
display cost;

min_nut(nutrients)$(SAMEAS(nutrients,"vita")) = 0.11;
display min_nut;

Table 
    contents(nutrients, crop)       the nutrients per unit for each nutrient+crop combo
            corn        hay         soy         wheat       oats        rice
protein     0.01        0.07        0.03        0.02        0.04        0.02
vita        0.02        0.14        0.10        0.015       0.02        0.05
vitd        600         700         1600        1500        1500        2000;

Variables
    total_cost                      the objective to be minimized;

Positive Variables
    usage(crop)                     how many units of each crop will be included (the decision variable);

Equations
    objective                       the total cost of the crops used (to be minimized)
    min_nutrients(nutrients)        control the minimum nutrient content
    max_nutrients(nutrients)        control the maximum nutrient content;                  

objective..
    total_cost =e= sum(crop, cost(crop) * usage(crop));

min_nutrients(nutrients)..
    sum(crop, usage(crop) * contents(nutrients, crop)) =g= min_nut(nutrients);

max_nutrients(nutrients)..
    sum(crop, usage(crop) * contents(nutrients, crop)) =l= max_nut(nutrients);

Model Farm /All/;

OPTION LIMROW = 100;
OPTION LIMCOL = 100;

Solve Farm USING LP MINIMIZING total_cost;

execute_unload "outputs%ds%report.gdx" usage;

