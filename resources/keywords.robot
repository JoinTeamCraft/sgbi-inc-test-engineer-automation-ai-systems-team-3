*** Settings ***
Documentation     Template for reusable keywords
Library           SeleniumLibrary
Library           Collections
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

Apply Maximum Price Filter
    [Arguments]    ${Price}
    Scroll Element Into View    xpath=//span[normalize-space()='Apply Filter']
    Wait Until Element Is Visible    xpath=//div[contains(@class,'ant-slider-handle')]      10s
    ${slider}=        Get WebElement    xpath=//div[contains(@class,'ant-slider-handle')]
    ${slider_bar}=    Get WebElement    xpath=//div[contains(@class,'ant-slider-rail')]
    # Get min, max, current values  //p[contains(@class,'_product-price_1dqfj')]
    ${min}=        Get Element Attribute    ${slider}    aria-valuemin
    ${max}=        Get Element Attribute    ${slider}    aria-valuemax
    ${current}=    Get Element Attribute    ${slider}    aria-valuenow
    ${min}=        Convert To Integer    ${min}
    ${max}=        Convert To Integer    ${max}
    ${current}=    Convert To Integer    ${current}
    ${target}=     Convert To Integer    ${Price}
    # Get slider width
    ${width}    ${height}=    Get Element Size    ${slider_bar}    
    # Convert target to percentage
    ${target_percent}=    Evaluate    (${target} - ${min}) / (${max} - ${min})
    # Convert to pixel offset
    ${target_pixel}=      Evaluate    int(${width} * ${target_percent})
    # Convert current to pixel
    ${current_percent}=   Evaluate    (${current} - ${min}) / (${max} - ${min})
    ${current_pixel}=     Evaluate    int(${width} * ${current_percent})
    # Calculate movement needed
    ${move_x}=    Evaluate    ${target_pixel} - ${current_pixel}
    Drag And Drop By Offset    ${slider}    ${move_x}    0

    Click Element   xpath=//span[normalize-space()='Apply Filter']
    Wait Until Page Contains Element    xpath=(//div[@class='_product-card_1dqfj_30'])    5s

Validate Prices Are Sorted Ascending
    [Arguments]    ${Price}
    [Documentation]    Capture prices on the page and verify all <= max_price and sorted ascending
    ${price_locator}=    Set Variable    xpath=(//p[contains(@class,'_product-price_1dqfj')])
    Wait Until Page Contains Element    ${price_locator}    20s
    ${price_elements}=    Get WebElements    ${price_locator}
    @{prices}=    Create List
    FOR    ${element}    IN    @{price_elements}
        ${text}=    Get Text    ${element}
         ${clean}=    Evaluate    float('${text}'.split()[0].replace('$',''))
        Run Keyword If    ${clean} > ${Price}    Fail    Price ${clean} exceeds maximum allowed ${Price}
        Append To List    ${prices}    ${clean}
    END

    ${sorted_prices}=    Evaluate    sorted(${prices})
    Should Be Equal    ${prices}    ${sorted_prices}

Validate No Search Results Message
    [Documentation]    Validates that the search results page shows "No cars Found" when no cars match.
    Wait Until Page Contains Element    xpath=//p[contains(@class,'noresult')]    10s
    Element Should Contain    xpath=//p[contains(@class,'noresult')]    No Cars Found
    ${elements}=    Get WebElements    xpath=//div[contains(@class,'_product-card_')]
    Should Be Empty    ${elements}




