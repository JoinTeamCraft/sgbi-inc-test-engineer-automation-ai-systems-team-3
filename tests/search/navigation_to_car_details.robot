*** Settings ***
Documentation     SG-16: Verify Navigation to Car Details Page
Resource          ../../resources/keywords.robot
Resource          ../../resources/locators.robot
Library           ../python_lib/date_utils.py

*** Variables ***
${PICKUP}          Palakkad
${DROPOFF}         Thrissur
${PICKUP_DATE}     Get Future Date   2
${DROPOFF_DATE}    Get Future Date  4

*** Test Cases ***
SG-16 | Verify Navigation to Car Details Page
    [Documentation]    Verify that selecting a car navigates to the correct Car Details page.
    Open Browser To MoRent
    Perform Valid Car Search    ${PICKUP}    ${DROPOFF}    ${PICKUP_DATE}    ${DROPOFF_DATE}
    Select First Car From Results
    Validate Car Details Page