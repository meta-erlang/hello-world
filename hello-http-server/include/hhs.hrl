%% Nitrogen elements
-include_lib("nitrogen_core/include/wf.hrl").
-record(hhs_hoverable_dropdown, {?ELEMENT_BASE(hhs_hoverable_dropdown),
        rowId=undefined         :: string()}).

-define(REMEMBER_ME_TTL, 40320).  % four weeks
