// ==UserScript==
// @name         Mod: Use Tab cycler to close multiple tabs at once
// @description  Mark multiple tabs with checkboxes as you navigate the Tab Cycler, then close them all at once.
// @version      1.0
// @author       barbudo2005
// @match        *://*/*
// ==/UserScript==

(function() {
    'use strict';

    let cyclerActive = false;
    let markedTabIds = new Set();
    let processedTabs = new Set();
    let focusObserver = null;

    console.log('🚀 Tab Cycler Batch Close v1.0 loaded');

    // M key - toggle checkbox on highlighted tab
    window.addEventListener('keydown', function(e) {
        if (!cyclerActive) return;
        
        if (e.code === 'Space' && e.ctrlKey) {
            e.preventDefault();
            e.stopPropagation();
            
            const activeLi = document.querySelector('.tabswitcher.list li.selected');
            if (!activeLi) return;
            
            const checkbox = activeLi.querySelector('.tab-checkbox');
            if (!checkbox) return;
            
            // Toggle checkbox
            if (checkbox.checked) {
                checkbox.checked = false;
                checkbox.removeAttribute('checked');
            } else {
                checkbox.checked = true;
                checkbox.setAttribute('checked', '');
            }
            
            const tabId = parseInt(checkbox.dataset.tabId);
            
            if (checkbox.checked) {
                markedTabIds.add(tabId);
            } else {
                markedTabIds.delete(tabId);
            }
            
            return false;
        }
    }, true);

    // CTRL or ALT keyup - batch close
    document.addEventListener('keyup', function(e) {
        if (e.key === 'Control' || e.key === 'Alt') {
            if (markedTabIds.size === 0) return;
            executeBatchClose();
        }
    }, true);

    function executeBatchClose() {
        const idsToClose = Array.from(markedTabIds);
        
        chrome.tabs.remove(idsToClose, () => {
            if (chrome.runtime.lastError) {
                console.error('❌ Batch close error:', chrome.runtime.lastError);
            }
            markedTabIds.clear();
        });
    }

    // Polling
    setInterval(function() {
        const cycler = document.querySelector('.tabswitcher.list');
        
        if (cycler) {
            if (!cyclerActive) {
                cyclerActive = true;
                processedTabs.clear();
                markedTabIds.clear();
                applyCustomStyles();
                setupFocusObserver(cycler);
            }
            injectCheckboxes(cycler);
        } else if (cyclerActive) {
            cyclerActive = false;
            processedTabs.clear();
            
            // Batch close when cycler closes (any method)
            if (markedTabIds.size > 0) {
                executeBatchClose();
            }
            
            // Cleanup observer
            if (focusObserver) {
                focusObserver.disconnect();
                focusObserver = null;
            }
        }
    }, 500);

    function setupFocusObserver(cycler) {
        if (focusObserver) return;
        
        focusObserver = new MutationObserver(() => {
            const selectedLi = cycler.querySelector('li.selected');
            if (selectedLi) {
                const checkbox = selectedLi.querySelector('.tab-checkbox');
                if (checkbox && document.activeElement !== checkbox) {
                    checkbox.focus();
                }
            }
        });
        
        focusObserver.observe(cycler, {
            attributes: true,
            attributeFilter: ['class'],
            subtree: true
        });
    }

    function applyCustomStyles() {
        if (document.getElementById('tab-cycler-custom-styles')) return;
        
        const style = document.createElement('style');
        style.id = 'tab-cycler-custom-styles';
        style.textContent = `
            .tabswitcher.list li.active-page {
                filter: brightness(1.4) !important;
            }
            
            .tab-checkbox {
                appearance: none;
                -webkit-appearance: none;
                width: 13px !important;
                height: 13px !important;
                min-width: 13px !important;
                min-height: 13px !important;
                border: 1px solid var(--colorFgFadedMost) !important;
                border-radius: 2px !important;
                background: transparent !important;
                cursor: pointer !important;
                position: absolute !important;
                right: 6px !important;
                top: 50% !important;
                transform: translateY(-50%) !important;
                z-index: 99999 !important;
                transition: all 0.15s ease !important;
                pointer-events: auto !important;
            }
            
            .tab-checkbox:hover {
                border-color: var(--colorFgFaded) !important;
            }
            
            /* Override Vivaldi's checkbox ::before and ::after */
            input[type=checkbox].tab-checkbox::before,
            input[type=checkbox].tab-checkbox::after {
                display: none !important;
                content: none !important;
            }
            
            .tab-checkbox:checked {
                border-color: var(--colorFg) !important;
                background-color: var(--colorHighlightBg) !important;
            }
            
            /* Our custom checkmark - more specific selector */
			
            input[type=checkbox].tab-checkbox:checked::after {
                content: '✓' !important;
                display: block !important;
                color: var(--colorFg) !important;
                font-size: 10px !important;
                font-weight: bold !important;
                position: absolute !important;
                top: -1px !important;
                left: 1px !important;
                transform: none !important;
                background: none !important;
            } 
        `;
        document.head.appendChild(style);
    }

    function injectCheckboxes(cycler) {
        const tabItems = cycler.querySelectorAll('ul.listed-tabs > li.visual-list');
        
        chrome.tabs.query({currentWindow: true}, (allTabs) => {
            tabItems.forEach((li) => {
                if (processedTabs.has(li)) return;
                if (li.querySelector('.tab-checkbox')) {
                    processedTabs.add(li);
                    return;
                }
                
                let matchingTab = null;
                
                // Get URL from favicon
                const favicon = li.querySelector('.visual-tab-list-favicon');
                
                if (favicon && favicon.srcset) {
                    const match = favicon.srcset.match(/chrome:\/\/favicon\/size\/\d+\/(.+?)\s/);
                    if (match) {
                        const tabUrl = match[1];
                        matchingTab = allTabs.find(t => t.url === tabUrl);
                    }
                }
                
                if (!matchingTab) {
                    processedTabs.add(li);
                    return;
                }
                
                li.style.position = 'relative';
                li.style.display = 'flex';
                li.style.alignItems = 'center';
                li.style.gap = '8px';
                li.style.paddingRight = '25px';
                li.style.minWidth = '0';
                
                const textNodes = Array.from(li.childNodes).filter(node => node.nodeType === Node.TEXT_NODE);
                textNodes.forEach(textNode => {
                    if (textNode.textContent.trim()) {
                        const span = document.createElement('span');
                        span.textContent = textNode.textContent;
                        span.style.overflow = 'hidden';
                        span.style.textOverflow = 'ellipsis';
                        span.style.whiteSpace = 'nowrap';
                        span.style.flex = '1';
                        span.style.minWidth = '0';
                        span.style.cursor = 'pointer';
                        
                        span.addEventListener('mousedown', function(e) {
                            chrome.tabs.update(matchingTab.id, {active: true});
                            
                            if (markedTabIds.size > 0) {
                                executeBatchClose();
                            }
                        }, true);
                        
                        li.replaceChild(span, textNode);
                    }
                });
                
                if (favicon) {
                    favicon.style.flexShrink = '0';
                }
                
                const checkbox = document.createElement('input');
                checkbox.type = 'checkbox';
                checkbox.className = 'tab-checkbox';
                checkbox.dataset.tabId = matchingTab.id;
                
                checkbox.addEventListener('change', function() {
                    const tabId = parseInt(checkbox.dataset.tabId);
                    
                    if (checkbox.checked) {
                        markedTabIds.add(tabId);
                    } else {
                        markedTabIds.delete(tabId);
                    }
                });
                
                // Block propagation to prevent tab activation
                checkbox.addEventListener('mousedown', function(e) {
                    e.stopPropagation();
                    e.stopImmediatePropagation();
                }, true);
                
                checkbox.addEventListener('mouseup', function(e) {
                    e.stopPropagation();
                    e.stopImmediatePropagation();
                }, true);
                
                checkbox.addEventListener('click', function(e) {
                    e.stopPropagation();
                    e.stopImmediatePropagation();
                }, true);
                
                li.appendChild(checkbox);
                processedTabs.add(li);
            });
        });
    }

    console.log('✅ Active');
})();


/*****************************************************************************************************************/

(async () => {
    'use strict';
    
    const config = {
        // タブスタックにベースドメインを使用する (true: 有効, false: 無効)
        // Use the base domain for tab stacks (true: enabled, false: disabled)
        base_domain: true,
        
        // タブスタックの名前を自動的に変更する (0: 無効, 1: ホスト名を使用, 2: ベースドメインから生成)
        // Automatically change the name of the tab stack (0: disabled, 1: use hostname, 2: generate from base domain)
        rename_stack: 0,
        
        // 自動タブスタックを許可するワークスペース (完全一致もしくは <default_workspace>)
        // * 未設定の場合はすべてのワークスペースで自動タブスタックを許可する
        // Workspaces that allow automatic tab stacking (exact match or <default_workspace>)
        // * If not set, automatic tab stacking is allowed in all workspaces
        allow_workspaces: [
         //   "<default_workspace>",
            // "Shopping",
        ],
        
        // 自動タブスタックを許可するドメイン (完全一致もしくは正規表現)
        // * 未設定の場合はすべてのドメインで自動タブスタックを許可する
        // Domains that allow automatic tab stacking (exact match or regular expression)
        // * If not set, automatic tab stacking is allowed for all domains
        allow_domains: [
            // "www.example.com",
            // /^(.+\.)?example\.net$/,
        ],
        
        // 自動タブスタックから除外するドメイン (完全一致もしくは正規表現)
        // Domains to exclude from automatic tab stacking (exact match or regular expression)
        block_domains: [
            // "www.example.com",
            // /^(.+\.)?example\.net$/,
        ],
    };
    
    const mergeArrays = (...arrays) => [...new Set(arrays.flat())];
    
    const getUrlFragments = (url) => vivaldi.utilities.getUrlFragments(url);
    
    const getBaseDomain = (url) => {
        const {hostForSecurityDisplay, tld} = getUrlFragments(url);
        return hostForSecurityDisplay.match(`([^.]+\\.${ tld })$`)?.[1] || hostForSecurityDisplay;
    };
    
    const getHostname = (url) => {
        const {hostForSecurityDisplay} = getUrlFragments(url);
        return config.base_domain ? getBaseDomain(url) : hostForSecurityDisplay;
    };
    
    const matchHostRule = (url, rule) => {
        const {hostForSecurityDisplay} = getUrlFragments(url);
        return rule instanceof RegExp ? rule.test(hostForSecurityDisplay) : hostForSecurityDisplay === rule;
    };
    
    const getTab = async (tabId) => {
        const tab = await chrome.tabs.get(tabId);
        
        if (tab.vivExtData) {
            tab.vivExtData = JSON.parse(tab.vivExtData);
            return tab;
        }
    };
    
    const getTabIndex = async (tabId) => (await getTab(tabId)).index;
    
    const getWorkspaceName = async (workspaceId) => {
        if (!workspaceId) {
            return '<default_workspace>';
        }
        const workspaceList = await vivaldi.prefs.get('vivaldi.workspaces.list');
        return workspaceList.find(item => item.id === workspaceId).name;
    };
    
    const getTabsByWorkspace = async () => {
        const tabs = (await chrome.tabs.query({ currentWindow: true }))
            .filter(tab => tab.id !== -1 && tab.vivExtData)
            .map(tab => Object.assign(tab, { vivExtData: JSON.parse(tab.vivExtData) }))
            .filter(tab => !tab.pinned && !tab.vivExtData.panelId)
            .filter(tab => !config.allow_domains.length || config.allow_domains.find(rule => matchHostRule(tab.url, rule)))
            .filter(tab => !config.block_domains.length || !config.block_domains.find(rule => matchHostRule(tab.url, rule)));
        
        return Object.groupBy(tabs, tab => tab.vivExtData.workspaceId);
    };
    
    const getTabsByStack = (tabs) => Object.groupBy(tabs, tab => tab.vivExtData.group);
    
    const getTabsByHost = (tabs) => Object.groupBy(tabs, tab => getHostname(tab.url));
    
    const getMaxTabsStackId = (tabsByStack, targetHost) => {
        const counts = {};
        
        for (const [stackId, tabs] of Object.entries(tabsByStack)) {
            if (stackId !== 'undefined') {
                const tabsByHost = getTabsByHost(tabs);
                const count = tabsByHost[targetHost]?.length || 0;
                
                delete tabsByHost[targetHost];
                counts[stackId] = Object.values(tabsByHost)
                    .reduce((acc, tabs) => {
                        return acc > tabs.length ? acc : 0;
                    }, count);
            }
        }
        
        return Object.entries(counts)
            .reduce((acc, [stackId, count]) => {
                return acc[1] < count ? [stackId, count] : acc;
            }, [, 0])[0];
    };
    
    const getTabStackName = (url) => {
        let stackName;
        
        switch (config.rename_stack) {
            case 1:
                stackName = getHostname(url);
                break;
            case 2:
                stackName = getBaseDomain(url).split('.')[0];
                stackName = stackName.charAt(0).toUpperCase() + stackName.slice(1);
                break;
        }
        return stackName;
    };
    
    const addTabStack = async (tabId, stackId, stackName) => {
        const {vivExtData} = await getTab(tabId);
        
        if (stackName) {
            vivExtData.fixedGroupTitle = stackName;
        }
        vivExtData.group = stackId;
        chrome.tabs.update(tabId, { vivExtData: JSON.stringify(vivExtData) });
    };
    
    const stackingTabs = async (workspaceId) => {
        const workspaceName = await getWorkspaceName(workspaceId);
        
        if (!config.allow_workspaces.length || config.allow_workspaces.includes(workspaceName)) {
            const tabsByWorkspace = await getTabsByWorkspace();
            const tabsByStack = getTabsByStack(tabsByWorkspace[workspaceId]);
            const tabsByHost = getTabsByHost(tabsByWorkspace[workspaceId]);
            
            for (const [host, tabs] of Object.entries(tabsByHost)) {
                const targetStackId = getMaxTabsStackId(tabsByStack, host) || crypto.randomUUID();
                const targetStackTabs = tabsByStack[targetStackId] ? getTabsByHost(tabsByStack[targetStackId])[host] : [];
                const targetTabs = mergeArrays(targetStackTabs, tabs);
                const targetStackName = getTabStackName(tabs[0].pendingUrl || tabs[0].url);
                
                let tabIndex = await getTabIndex(targetTabs[0].id);
                
                for (const tab of targetTabs) {
                    addTabStack(tab.id, targetStackId, targetStackName);
                    chrome.tabs.move(tab.id, { index: tabIndex });
                    tabIndex++;
                }
            }
        }
    };
    
    chrome.webNavigation.onCommitted.addListener(async details => {
        if (details.tabId !== -1) {
            const tab = await getTab(details.tabId);
            
            if (tab && !tab.pinned && !tab.vivExtData.panelId && details.frameType === 'outermost_frame') {
                const workspaceId = tab.vivExtData.workspaceId;
                stackingTabs(workspaceId);
            }
        }
    });
})();


