*** Settings ***
Documentation     Template for Search tests
Resource          ../../resources/keywords.robot
Resource          ../../resources/locators.robot

*** Variables ***
${PICKUP}         Palakkad
${DROPOFF}        Thrissur
${PICKUP_DATE}    24-02-2026
${DROPOFF_DATE}    28-02-2026
${CAR_TYPE}     SUV

*** Test Cases ***
SG-13 | Verify Car Type Filter Functionality
    [Documentation]    Automate verification that the Car Type filter displays only the selected car type.
    [Tags]    SG-13
    Open Browser To MoRent
    Perform Valid Car Search    ${PICKUP}    ${DROPOFF}    ${PICKUP_DATE}    ${DROPOFF_DATE}
    Apply Car Type Filter       ${CAR_TYPE}
    Validate Filtered Results   ${CAR_TYPE} 
    Close Browser
