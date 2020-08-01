// load q script
system "l /root/q/src/tick/u.q"

// basic table
request:2!flip `sym`qid`accountname`time`entrustno`stockcode`askprice`askvol`bidprice`bidvol`withdraw`status!"ssszisfifiii"$\:()
// new table for adding params of orders
params: 2!flip `sym`qid`broker`fund`strategy`side`ordertype`stocktype`algorithm`params`resptime!"sssssiiissz"$\:()


// extra table
requestv2: select from request where 0<>0

// response tables
response: select from request where 0<>0
response1: select from request where 0<>0
responsev2: select from request where 0<>0


// func
upd:{[t;x] upsert[t;x];.u.pub[t;x];}

topNfunc:{[t;N] kcols:N#(cols t); ?[t;();0b;kcols!kcols]}
tailNfunc:{[t;m;n] n:neg n; kcols:m#(cols t),n#(cols t); ?[t;();0b;kcols!kcols]}


updv3:{[t;x] if[t=`requestv3;
 .u.pub[`requestv3;x];
 subtab:topNfunc[x;12];
 upsert[`request;subtab];
 upsert[`requestv2;subtab];
 upsert[`params;tailNfunc[x;2;9]];
 .u.pub[`requestv2;subtab]; 
 .u.pub[`request;subtab]];
 upd[t;x];}


// modify wsupdv2 in cim
wsupdv2: {[t;x] if[t=`responsev2; upsert[`responsev2;0!x]; .u.pub[`responsev2;0!x]];  
          upsert[`response;0!x]; .u.wspub[`response;0!x]; // json pub
          upsert[`response1;0!x]; .u.pub[`response1;0!x]; // table pub
          // add update/pub v3
          tab:x lj params; // table with params
          tab:update resptime: .z.Z from tab;
          .u.pub[`responsev3;0!tab];}




// init tables
.u.init[]

