# Casos de Teste
*** Settings ***
Library    RequestsLibrary
Resource    ../../resources/common.resource
Variables    ../../resources/variables.py
Suite Setup    Create Token    ${url}

*** Test Cases ***
Create Booking
    ${headers}    Create Dictionary    Content_Type=${Content_Type}
    ${body}    Evaluate    json.loads(open('./fixtures/json/booking1.json').read())

    ${response}    POST    url=${url}/booking    json=${body}    headers=${headers}
    ${response_body}    Set Variable    ${response.json()}
    Log To Console    ${response_body}

    Status Should Be    200
    Should Be Equal    ${response_body}[booking][firstname]    ${firstname}
    Should Be Equal    ${response_body}[booking][bookingdates][checkin]    2024-04-27


Get Booking
    Get Booking Id    ${url}    ${firstname}    ${lastname}

    ${response}    GET    url=${url}/booking/${booking_id}

    ${response_body}    Set Variable    ${response.json()}
    Log To Console    ${response_body}

    Should Be Equal    ${response_body}[firstname]    ${firstname}
    Should Be Equal    ${response_body}[lastname]    ${lastname}
    Should Be Equal    ${response_body}[totalprice]    ${totalprice}
    Should Be Equal    ${response_body}[depositpaid]    ${depositpaid}
    Should Be Equal    ${response_body}[bookingdates][checkin]    ${bookingdates}[checkin]
    Should Be Equal    ${response_body}[bookingdates][checkout]    ${bookingdates}[checkout]
    Should Be Equal    ${response_body}[additionalneeds]    ${additionalneeds}
