*** Settings ***
Documentation     SG-18: Verify Car Image Display on Car Details Page
Resource          ../../resources/keywords.robot
Resource          ../../resources/locators.robot
Library           ../python_lib/date_utils.py
Library           SeleniumLibrary

*** Variables ***
${PICKUP}        Palakkad
${DROPOFF}       Palakkad
${PICKUP_DATE}   Get Future Date   3
${DROPOFF_DATE}  Get Future Date   6

*** Test Cases ***
SG-18 | Verify Car Image Display
    [Documentation]    Validate that the primary car image is visible and loaded correctly on the Car Details page.
    Open Browser To MoRent
    Perform Valid Car Search    ${PICKUP}    ${DROPOFF}    ${PICKUP_DATE}    ${DROPOFF_DATE}
    Select First Car From Results
    Validate Car Image Display