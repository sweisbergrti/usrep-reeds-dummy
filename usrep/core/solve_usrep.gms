$title Fake USREP

Set
    Source                              Supply locations
    /Seattle, SanDiego/

    Destination                         Demand locations
    /NewYork, Chicago, Topeka/;

Table
    TranCost(Source, Destination)       Unit transportation cost
                NewYork     Chicago     Topeka
    Seattle      250         178         187
    SanDiego     250         187         151;

Parameter
    Supply(Source)      Supply constraints
    /Seattle 350, SanDiego 600/

    Need(Destination)   Demand constraints
    /NewYork 325, Chicago 300, Topeka 275/;

Variable
    TotalCost           Objective function value;

Positive Variables
    Transport(Source, Destination);

Equations
    Obj                     objective function
    SupplyBal(Source)       Supply balance constraints
    DemandBal(Destination)  Demand balance constraints;

Obj..
    TotalCost =e= SUM((Source, Destination), TranCost(Source, Destination) * Transport(Source, Destination));

SupplyBal(Source)..
    SUM(Destination, Transport(Source, Destination)) =l= Supply(Source);

DemandBal(Destination)..
    SUM(Source, Transport(Source, Destination)) =g= Need(Destination);

Model Trans /All/;

OPTION LIMROW = 100;
OPTION LIMCOL = 100;

Solve Trans USING LP MINIMIZING TotalCost;

display Transport.L, TotalCost.L;