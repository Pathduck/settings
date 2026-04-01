// ==UserScript==
// @name         Override Client Hints API - Basic
// @namespace
// @version      1.0
// @description  A script to override the Client Hints JavaScript API
// @author
// @match        https://*/*
// @run-at       document-start
// @grant        none
// @license      MIT
// ==/UserScript==

(function () {
    'use strict';

    const ua = "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Safari/537.36";

    function override(obj, prop, value) {
        Object.defineProperty(obj, prop, {
            get: () => value,
            configurable: true
        });
    }

    override(navigator, "userAgent", ua);
    override(navigator, "appVersion", ua.slice("Mozilla/".length));
    override(navigator, "vendor", "Google Inc.");
    override(navigator, "platform", "Win32");
    override(navigator, "hardwareConcurrency", 8);
    override(navigator, "deviceMemory", 8);

    override(navigator, "userAgentData", {
        brands: [
            { brand: "Vivaldi", version: "7.10" },
            { brand: "Chromium", version: "146" },
            { brand: "Not=A?Brand", version: "24" }
        ],
        fullVersionList: [
            { brand: "Vivaldi", version: "7.10" },
            { brand: "Chromium", version: "146.0.0.0" },
            { brand: "Not=A?Brand", version: "24.0.0.0" }
        ],
        uaFullVersion: "146.0.0.0",
        platform: "Windows",
        platformVersion: "15.0.0",
        architecture: "x86",
        bitness: "64",
        mobile: false,
        wow64: false
     });

})();
