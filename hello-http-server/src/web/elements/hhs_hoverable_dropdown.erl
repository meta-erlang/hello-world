-module (hhs_hoverable_dropdown).
-include("hhs.hrl").
-compile(export_all).

reflect() -> record_info(fields, hhs_hoverable_dropdown).

render_element(#hhs_hoverable_dropdown{rowId = Id} = Record) -> 

    DropdownButton = #button{class=dropbtn, body=#p{class="ri-more-2-fill ri-sm"}},

    EditUrl = "test/edit/1",
    RunUrl = "test/run/1",

    Edit = #link{text="Edit", url=EditUrl},
    Delete = #link{text="Delete", postback={delete, 1, Id}},
    Run = #link{text="Run", url=RunUrl},

    DropdownContent = #panel{ class='dropdown-content', body=[
        Edit, Delete, Run
    ]},

    #panel{ class=dropdown, body=[DropdownButton, DropdownContent]}.

