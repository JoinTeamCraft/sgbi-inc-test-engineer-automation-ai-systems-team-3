*** Settings ***
Documentation     SG-17: Verify Car Specifications on Car Details Page
Resource          ../../resources/keywords.robot
Resource          ../../resources/locators.robot
Library           ../python_lib/date_utils.py

*** Variables ***
${PICKUP}          Palakkad
${DROPOFF}         Thrissur
${PICKUP_DATE}     Get Future Date   2
${DROPOFF_DATE}    Get Future Date  4

*** Test Cases ***
SG-17 | Verify Car Specifications On Details Page
    [Documentation]    Verify that car specifications are displayed correctly.
    Open Browser To MoRent
    Perform Valid Car Search    ${PICKUP}    ${DROPOFF}    ${PICKUP_DATE}    ${DROPOFF_DATE}
    Select First Car From Results
    Validate Car Specifications Section