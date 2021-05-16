%% Nitrogen elements
-include_lib("nitrogen_core/include/wf.hrl").
-record(hhs_hoverable_dropdown, {?ELEMENT_BASE(hhs_hoverable_dropdown),
        rowId=undefined         :: string()}).
-record(i, {?ELEMENT_BASE(element_i),
        body=[]                 :: body(),
        text=""                 :: text(),
        html_encode=true        :: html_encode()
    }).

-define(REMEMBER_ME_TTL, 40320).  % four weeks