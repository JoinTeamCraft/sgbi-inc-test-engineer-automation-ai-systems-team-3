*** Settings ***
Documentation     SG-15: Verify No Search Results behavior on MoRent
Resource          ../../resources/keywords.robot
Resource          ../../resources/locators.robot
Library           ../python_lib/date_utils.py

*** Variables ***
${PICKUP}         Kozhikode
${DROPOFF}        Thrissur
${PICKUP_DATE}     Get Future Date   2
${DROPOFF_DATE}      Get Future Date  4

*** Test Cases ***
SG-15 | Verify No Search Results
    [Documentation]    Verify that the system shows a friendly message when no cars are available.
    Open Browser To MoRent
    Perform Valid Car Search    ${PICKUP}    ${DROPOFF}    ${PICKUP_DATE}    ${DROPOFF_DATE}
    Validate No Search Results Message
    Close Browser