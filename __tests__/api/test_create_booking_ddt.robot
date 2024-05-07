*** Settings ***
Library    RequestsLibrary
Library    DataDriver    ../../fixtures/csv/bookings.csv    dialect=excel    
Resource    ../../resources/common.resource
Variables    ../../resources/variables.py
Test Setup    Create Token    ${url}
Test Template    Create Booking DDT

*** Test Cases ***
TC001    ${firstname}    ${lastname}    ${totalprice}    ${depositpaid}    ${checkin}    ${checkout}    ${additionalneeds}
TC002    Joao    Gouveia    ${totalprice}    ${depositpaid}    ${checkin}    ${checkout}    ${additionalneeds}
TC003
*** Keywords ***
Create Booking DDT
    [Arguments]    ${firstname}    ${lastname}    ${totalprice}    ${depositpaid}    ${checkin}    ${checkout}    ${additionalneeds}
    ${headers}    Create Dictionary    Content-Type=${content_type}
    ${totalprice}    Convert To Integer    ${totalprice}
    ${depositpaid}    Convert To Boolean    ${depositpaid}
    &{bookingdates}    Create Dictionary    checkin=${checkin}    checkout=${checkout}
    ${body}    Create Dictionary    firstname=${firstname}    lastname=${lastname}
    ...    totalprice=${totalprice}    depositpaid=${depositpaid}
    ...    bookingdates=${bookingdates}    additionalneeds=${additionalneeds}
        
    ${response}    POST    url=${url}/booking    headers=${headers}    
    ...    json=${body}

    ${response_body}    Set Variable    ${response.json()}
    Log To Console    ${response_body}

    Status Should Be    200
    Should Be Equal    ${response_body}[booking][firstname]    ${firstname}
    Should Be Equal    ${response_body}[booking][lastname]    ${lastname}
    Should Be Equal    ${response_body}[booking][totalprice]    ${totalprice}
    Should Be Equal    ${response_body}[booking][depositpaid]    ${depositpaid}
    Should Be Equal    ${response_body}[booking][bookingdates][checkin]     ${checkin}
    Should Be Equal    ${response_body}[booking][bookingdates][checkout]    ${checkout}
    Should Be Equal    ${response_body}[booking][additionalneeds]           ${additionalneeds}