// generate order table
randTable: {[n] ([] sym: n?`test06`test05; qid: `$string n?0Ng; accountname: n?`testCS02`testUBS01; time:08:00:00+.z.Z; entrustno:0i; 
    stockcode: n?`600036`000001`601818`000333`000725`601888; askprice: n?102.5; askvol:`int$(n?(-100 100i))*(1+n?100); bidprice:0f; bidvol:0i; withdraw:0i; status:0i)}


// cancel unfinalized orders
randCancel: { tab: 2!select sym, qid, entrustno from response where status within (1, 2); nums: (count tab) div 2; rows: nums?exec entrustno from tab; 
              0!update status:3 from requestv2 ij (select from tab where entrustno in rows)}



updv3[`requestv2; randCancel()]

// unit: millisecond
\t 500

i:0
// multi timer
.z.ts:{ if[0=i mod 10; updv3[`requestv2; randCancel()]]; if[0=i mod 30; updv3[`requestv2; randTable[rand 300]]]; i+:1;}
// \t 0 stop timer
