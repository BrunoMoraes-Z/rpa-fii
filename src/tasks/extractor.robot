*** Settings ***
Resource            ../main.robot

Task Teardown       Close All Browsers


*** Variables ***
@{tickers}
...    BARI11
...    BCFF11
...    CVBI11
...    HCTR11
...    HGLG11
...    IRDM11
...    KNIP11
...    LVBI11
...    MXRF11
...    RBRF11
...    RECR11
...    XPML11


*** Tasks ***
Collect Information About Fii
    Open Browser    about:blank    chrome
    Maximize Browser Window

    FOR    ${fii}    IN    @{tickers}
        Go To    https://fiis.com.br/${fii}

        &{info}    Create Dictionary
        ${date}    Get Current Date    result_format=%m/%Y
        ${info}[date]    Set Variable    ${date}
        ${date}    ${dividend}    Get Dividend

        ${info}[date]    Set Variable    ${date}
        ${info}[dividend]    Set Variable    ${dividend}
        ${info}[dividend_yield]    Get Number value    //div[@class='indicators']//p[text()='Dividend Yield']/..//b

        ${info}[pvp]    Get Number value    //div[@class='indicators']//p[text()='P/VP']/..//b

        ${info}[price]    Get Number value    //div[@class='item quotation']//span[@class='value']

        ${info}[qtd_cotistas]    Get Number value
        ...    //div[@class='wrapper indicators']//p[text()='N° de Cotistas']/..//b

        ${info}[tp_fundo]    Get Text    //div[@class='moreInfo wrapper']//span[text()='Tipo de Fundo']/../b
        ${info}[qt_cotas]    Get Number value    //div[@class='moreInfo wrapper']//span[text()='Número de Cotas']/../b

        ${vl_patrimonio}    Get Number value    //div[@class='moreInfo wrapper']//span[text()='Patrimônio']/../b
        ${info}[vl_patrimonio]    Evaluate    $vl_patrimonio.split(' ')[1]

        ${info}[cnpj]    Get Text    //div[@class='moreInfo wrapper']//span[text()='CNPJ']/../b

        ${info}[admin]    Evaluate    {}
        ${info}[admin][nome]    Get Text    //div[@class='informations__adm']//p
        ${info}[admin][cnpj]    Get Text    //div[@class='informations__adm']//span[2]
        ${info}[admin][email]    Get Text    //div[@class='informations__contact']/div[2]//p

        IF    ${dividend} != ${-1}
            Connect To Deta    project_key=<TOKEN>
            Select Base    dividends
            ${data}    Create Dictionary
            ...    ticker=${fii}
            ...    dados=${info}
            ...    date=${date}

            ${query}    Create Dictionary
            ...    ticker?contains=${fii}
            ...    date=${date}

            ${result}    Fetch From Base    ${query}
            ${status}    Evaluate    $result.count == 0
            IF    ${status}    Insert In A Base    data=${data}
        END
    END


*** Keywords ***
Get Number value
    [Arguments]    ${locator}

    ${raw}    Get Text    ${locator}
    ${parsed}    Evaluate    $raw.replace('.', '').replace(',', '.')

    RETURN    ${parsed}

Get Dividend
    ${date}    Get Current Date    result_format=%m/%Y
    ${locator}    Set Variable    //div[@data-category='rendimento']/p[contains(text(), '${date}')]
    ${status}    Run Keyword And Return Status    Element Should Be Visible    ${locator}
    IF    ${status}
        ${raw}    Get Text    ${locator}
        ${dividendo}    Evaluate    $raw.split('\\n')[1].split('R$ ')[1].split(' ')[0]
        ${dividendo}    Evaluate    $dividendo.replace('.', '').replace(',', '.')
        RETURN    ${date}    ${dividendo}
    ELSE
        ${date}    Get Current Date    increment=-30d    result_format=%m/%Y
        ${locator}    Set Variable    //div[@data-category='rendimento']/p[contains(text(), '${date}')]
        ${status}    Run Keyword And Return Status    Element Should Be Visible    ${locator}
        IF    ${status}
            ${raw}    Get Text    ${locator}
            ${dividendo}    Evaluate    $raw.split('\\n')[1].split('R$ ')[1].split(' ')[0]
            ${dividendo}    Evaluate    $dividendo.replace('.', '').replace(',', '.')
            RETURN    ${date}    ${dividendo}
        ELSE
            RETURN    ${date}    ${-1}
        END
    END
