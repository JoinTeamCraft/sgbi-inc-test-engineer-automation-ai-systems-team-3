*** Settings ***
Resource    ../../resources/keywords.robot
Library    ../../python_lib/date_utils.py

*** Variables ***
${PICKUP}         Palakkad
${DROPOFF}        Thrissur
${PICKUP_DATE}    Get Future Date   2
${DROPOFF_DATE}    Get Future Date  3
${Price}     75

*** Test Cases ***
SG-14 | Verify Sort Cars By Price
    [Documentation]    Verify that cars are sorted by price (Low to High).
    [Tags]    SG-14
    Open Browser To MoRent
    Perform Valid Car Search    ${PICKUP}    ${DROPOFF}    ${PICKUP_DATE}    ${DROPOFF_DATE}
    Apply Maximum Price Filter    ${Price}
    Validate Prices are sorted Ascending     ${Price}
    Close Browser