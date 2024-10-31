> [!WARNING]  
> Don't use this for yourself. If you want to use it change the webhook to a different one

## Installation
1. Install [Tampermonkey](https://www.tampermonkey.net/)
2. Open the Tampermonkey Dashboard
3. Select the 'Utilities' Tab
4. Find the 'Import from URL' section
5. Paste the following URL: [`https://raw.githubusercontent.com/Filipsys/tampermonkey-script-config/refs/heads/main/main.js`](https://raw.githubusercontent.com/Filipsys/tampermonkey-script-config/refs/heads/main/main.js)
6. Select 'Install'
7. Once installed, when opening a website, a page should open asking for access to a cross-origin resource. Select 'Always allow all domains'.
8. Open the script settings in the 'Installed Userscipts' section and change 'Run in' to `All tabs` for the script to work in incognito tabs.

---

If your target browser is Chrome, paste `chrome://extensions` in the URL bar, turn on developer mode, navigate to the Tampermonkey extension settings and change `Allow in incognito mode` to true.
