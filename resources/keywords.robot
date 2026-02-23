*** Settings ***
Documentation     Template for reusable keywords
Library           SeleniumLibrary
Resource          locators.robot

*** Variables ***
${URL}      https://morent-car.archisacademy.com/
${BROWSER}  chrome
# Search Inputs
${SEARCH_LOCATOR}  //span[normalize-space()='Search']
${PICKUP_LOCATOR}   //div[text()='Pick-Up']/following-sibling::div//div[@aria-label='Select your City']
${DROPOFF_LOCATOR}  //div[text()='Drop-Off']/following-sibling::div//div[@aria-label='Select your City']
${PICKUP_DATE_LOCATOR}  //div[text()='Pick-Up']/following-sibling::div//div[span[text()='Date']]//input[@placeholder='Select date']
${DROPOFF_DATE_LOCATOR}  //div[text()='Drop-Off']/following-sibling::div//div[span[text()='Date']]//input[@placeholder='Select date']
${PICKUP_TIME_LOCATOR}  //div[text()='Pick-Up']/following-sibling::div//div[span[text()='Time']]//input[@placeholder='Select time']
${DROPOFF_TIME_LOCATOR}  //div[text()='Drop-Off']/following-sibling::div//div[span[text()='Time']]//input[@placeholder='Select time'] 


*** Keywords ***
Open Browser To MoRent
    [Documentation]    Open MoRent website with auto-installed ChromeDriver
    Evaluate    __import__('chromedriver_autoinstaller').install()
    Open Browser    ${URL}    ${BROWSER}
    Maximize Browser Window
    Wait Until Page Contains Element    ${SEARCH_LOCATOR}   10s
Perform Valid Car Search
    [Arguments]     ${pickup}=Palakkad    ${dropoff}=Palakkad    ${pickup_date}=22-02-2026    ${dropoff_date}=25-02-2026
    Scroll Element Into View    ${SEARCH_LOCATOR}
    Wait Until Element Is Visible    ${PICKUP_LOCATOR}   10s
    Click Element    ${PICKUP_LOCATOR}
    ${option_locator}=    Set Variable      (//div[@class='ant-select-item-option-content'][normalize-space()='${pickup}'])[1]
    Wait Until Element Is Visible    ${option_locator}    10s
    Click Element   ${option_locator}
    Wait Until Page Contains Element    ${DROPOFF_LOCATOR}   10s
    Click Element    ${PICKUP_DATE_LOCATOR}
    Wait Until Element Is Visible    ${PICKUP_DATE_LOCATOR}    5s
    Input Text       ${PICKUP_DATE_LOCATOR}    ${pickup_date}
    Press Keys        ${PICKUP_DATE_LOCATOR}    ENTER
    Wait Until Element Is Visible  ${DROPOFF_LOCATOR}      10s
    Click Element    ${DROPOFF_LOCATOR}
    Wait Until Element Is Visible    ${DROPOFF_LOCATOR}    5s
    ${locator}=    Set Variable    xpath=(//div[@title='${dropoff}'])[last()]
    Wait Until Element Is Visible    ${locator}    10s
    Click Element    ${locator}
    Click Element    ${DROPOFF_DATE_LOCATOR}
    Wait Until Element Is Visible    ${DROPOFF_DATE_LOCATOR}    5s
    Input Text      ${DROPOFF_DATE_LOCATOR}    ${dropoff_date}
    Press Keys        ${DROPOFF_DATE_LOCATOR}    ENTER
    Click Element    ${SEARCH_LOCATOR}
    Wait Until Page Contains Element    xpath=//fieldset[1]    10s
Apply Car Type Filter
    [Arguments]    ${car_type}
    Wait Until Page Contains Element    xpath=//span[@class='ant-checkbox-label'][contains(.,'${car_type}')]
    Click Element   xpath=//span[@class='ant-checkbox-label'][contains(.,'${car_type}')]
    Scroll Element Into View    xpath=//span[normalize-space()='Apply Filter']
    Click Element   xpath=//span[normalize-space()='Apply Filter']
    Wait Until Page Contains Element    xpath=(//div[@class='_product-card_1dqfj_30'])    5s
Validate Filtered Results
    [Arguments]    ${car_type}
    ${locator}=    Set Variable    xpath=(//h4[@class='_product-card-header-subtitle_1dqfj_56'])[position()<=20]
    Wait Until Page Contains Element    ${locator}    20s
    ${elements}=    Get WebElements    ${locator}
    FOR    ${element}    IN    @{elements}
        ${text}=    Get Text    ${element}
        ${text}=    Strip String    ${text}
        Should Be Equal As Strings    ${text}    ${car_type}
    END