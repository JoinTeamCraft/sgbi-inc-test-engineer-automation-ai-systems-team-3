*** Settings ***
Resource    ../../resources/keywords.robot

*** Variables ***
${PICKUP}         Palakkad
${DROPOFF}        Thrissur
${PICKUP_DATE}    24-02-2026
${DROPOFF_DATE}    28-02-2026
${Price}     75

*** Test Cases ***
SG-14 | Verify Sort Cars By Price
    [Documentation]    Verify that cars are sorted by price (Low to High).
    [Tags]    SG-14
    Open Browser To MoRent
    Perform Valid Car Search    ${PICKUP}    ${DROPOFF}    ${PICKUP_DATE}    ${DROPOFF_DATE}
    Apply Price Sort    ${Price}
    Validate Price are sorted Ascending     ${Price}
    Close Browser