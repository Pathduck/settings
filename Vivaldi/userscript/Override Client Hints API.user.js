// ==UserScript==
// @name         Override Client Hints API
// @namespace
// @version      1.0
// @description  A script to override the Client Hints JavaScript API
// @author
// @match        https://*/*
// @run-at       document-start
// @grant        none
// @license      MIT
// ==/UserScript==

(function() {
    'use strict';

    // Use full version in UA string (e.g. Chrome/133.0.6943.126) to match real Chrome
    const VIVALDI_VERSION = "7.10";
    const VIVALDI_FULL_VERSION = "7.10";
    const CHROME_VERSION = "146";
    const CHROME_FULL_VERSION = "146.0.7680.171";
    const chromeUA = `Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Safari/537.36`;

    function override(obj, prop, value) {
        Object.defineProperty(obj, prop, {
            get: () => value,
            configurable: true,
            enumerable: true
        });
    }


	// Basic navigator properties
    override(Navigator.prototype, "userAgent", chromeUA);
    override(Navigator.prototype, "appVersion", chromeUA.slice("Mozilla/".length));
    override(Navigator.prototype, "platform", "Win32");
    override(Navigator.prototype, "vendor", "Google Inc.");
    override(Navigator.prototype, "oscpu", undefined); // Chrome doesn't expose this; Firefox does
    override(Navigator.prototype, "productSub", "20030107"); // Chrome: "20030107", Firefox: "20100101"

    // User-Agent Client Hints
    // GREASE brand string and version rotate based on Chrome major version to prevent fingerprinting
    function getGreasedBrand(major) {
        const n = parseInt(major, 10) % 3;
        const brandStrings = ["Not A(Brand", "Not)A;Brand", "Not:A-Brand"];
        const brandVersions = ["8", "99", "24"];
        return { brand: brandStrings[n], version: brandVersions[n] };
    }

    const greaseBrand = getGreasedBrand(CHROME_VERSION);
    const greaseBrandFull = { brand: greaseBrand.brand, version: `${greaseBrand.version}.0.0.0` };

    const brands = [
        greaseBrand,
        { brand: "Vivaldi", version: VIVALDI_VERSION },
        { brand: "Chromium", version: CHROME_VERSION }
    ];
    const fullVersionList = [
        greaseBrandFull,
        { brand: "Vivaldi", version: VIVALDI_FULL_VERSION },
        { brand: "Chromium", version: CHROME_FULL_VERSION }
    ];

    // Built once, reused on every getHighEntropyValues() call
    const highEntropyMap = {
        architecture:    "x86",
        bitness:         "64",
        brands,
        fullVersionList,
        mobile:          false,
        model:           "",
        platform:        "Windows",
        platformVersion:  "15.0.0",
        uaFullVersion:   CHROME_FULL_VERSION
    };

    const uaData = {
        brands,
        mobile: false,
        platform: "Windows",
        getHighEntropyValues: async function(hints) {
            const result = {};
            for (const hint of hints) {
                if (hint in highEntropyMap) result[hint] = highEntropyMap[hint];
            }
            return result;
        },
        toJSON: function() {
            return { brands, mobile: false, platform: "Windows" };
        }
    };
    override(Navigator.prototype, "userAgentData", uaData);
})();
