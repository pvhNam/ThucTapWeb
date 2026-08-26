(function () {
    'use strict';

    if (window.ymSmoothNavigationReady) return;
    window.ymSmoothNavigationReady = true;

    var progressTimer;
    var navigationSafetyTimer;
    var downloadFeedbackTimer;
    var downloadGuardTimer;
    var downloadSubmissionInFlight = false;
    var adminAjaxController;
    var adminAjaxSequence = 0;
    var adminSearchTimer;
    var siteAjaxController;
    var siteAjaxSequence = 0;
    var currency = new Intl.NumberFormat('vi-VN');
    var languageSwitchInFlight = false;
    var languageAttributes = ['placeholder', 'title', 'aria-label', 'alt', 'data-message', 'onsubmit'];
    var activeLanguageTranslations = [];
    var languageObserver;

    function ensureProgress() {
        var bar = document.getElementById('ym-navigation-progress');
        if (!bar) {
            bar = document.createElement('div');
            bar.id = 'ym-navigation-progress';
            bar.setAttribute('aria-hidden', 'true');
            document.body.appendChild(bar);
        }
        return bar;
    }

    function startProgress(leaving) {
        var bar = ensureProgress();
        window.clearTimeout(progressTimer);
        if (leaving) {
            window.clearTimeout(downloadFeedbackTimer);
            window.clearTimeout(downloadGuardTimer);
            downloadSubmissionInFlight = false;
        }
        window.clearTimeout(navigationSafetyTimer);
        bar.classList.remove('is-done');
        requestAnimationFrame(function () { bar.classList.add('is-active'); });
        if (leaving) {
            document.body.classList.add('ym-page-leaving');
            navigationSafetyTimer = window.setTimeout(finishProgress, 10000);
        }
    }

    function finishProgress() {
        var bar = document.getElementById('ym-navigation-progress');
        window.clearTimeout(navigationSafetyTimer);
        document.body.classList.remove('ym-page-leaving');
        if (!bar) return;
        bar.classList.remove('is-active');
        bar.classList.add('is-done');
        progressTimer = window.setTimeout(function () { bar.classList.remove('is-done'); }, 400);
    }

    function toUrl(value) {
        try { return new URL(value, window.location.href); }
        catch (error) { return null; }
    }

    function isDownloadSubmission(form, submitter, action) {
        var target = (submitter && submitter.getAttribute('formtarget')) || form.getAttribute('target');
        if (target && target.toLowerCase() !== '_self') return true;
        if (form.dataset.download !== undefined || form.dataset.noTransition !== undefined) return true;
        if (submitter && (submitter.dataset.download !== undefined || submitter.dataset.noTransition !== undefined)) return true;
        return Boolean(action && /\/admin-export-(?:report|revenue)\/?$/.test(action.pathname));
    }

    function showDownloadFeedback(form, submitter) {
        var control = submitter || form.querySelector('button[type="submit"], input[type="submit"]');
        downloadSubmissionInFlight = true;
        window.clearTimeout(downloadGuardTimer);
        downloadGuardTimer = window.setTimeout(function () {
            downloadSubmissionInFlight = false;
        }, 30000);
        startProgress(false);
        if (control) {
            control.classList.add('ym-download-started');
            control.setAttribute('aria-busy', 'true');
        }
        window.clearTimeout(downloadFeedbackTimer);
        downloadFeedbackTimer = window.setTimeout(function () {
            if (control) {
                control.classList.remove('ym-download-started');
                control.removeAttribute('aria-busy');
            }
            finishProgress();
        }, 1200);
    }

    function adminFormUrl(form, submitter) {
        var action = toUrl((submitter && submitter.getAttribute('formaction')) || form.action);
        if (!action) return null;
        action.search = formDataWithSubmitter(form, submitter).toString();
        return action;
    }

    function captureAdminFocus(form) {
        var active = document.activeElement;
        if (!active || !form.contains(active) || !active.name || !active.matches('[data-admin-live-search]')) return null;
        return {
            name: active.name,
            start: typeof active.selectionStart === 'number' ? active.selectionStart : null,
            end: typeof active.selectionEnd === 'number' ? active.selectionEnd : null
        };
    }

    function restoreAdminFocus(main, focus) {
        if (!focus) return;
        var controls = main.querySelectorAll('[name]');
        for (var index = 0; index < controls.length; index++) {
            if (controls[index].name !== focus.name || !controls[index].matches('[data-admin-live-search]')) continue;
            controls[index].focus({ preventScroll: true });
            if (focus.start !== null && typeof controls[index].setSelectionRange === 'function') {
                try { controls[index].setSelectionRange(focus.start, focus.end); }
                catch (error) { /* Some input types do not expose a text selection. */ }
            }
            break;
        }
    }

    function announceAdminUpdate(message) {
        var status = document.getElementById('ym-admin-ajax-status');
        if (!status) {
            status = document.createElement('div');
            status.id = 'ym-admin-ajax-status';
            status.className = 'ym-sr-only';
            status.setAttribute('role', 'status');
            status.setAttribute('aria-live', 'polite');
            document.body.appendChild(status);
        }
        status.textContent = '';
        window.setTimeout(function () { status.textContent = message; }, 30);
    }

    async function loadAdminContent(url, options) {
        options = options || {};
        var targetUrl = typeof url === 'string' ? toUrl(url) : url;
        var currentMain = document.querySelector('main.main-content');
        if (!targetUrl || targetUrl.origin !== window.location.origin || !currentMain) {
            if (targetUrl) window.location.assign(targetUrl.href);
            return;
        }

        if (adminAjaxController) adminAjaxController.abort();
        adminAjaxController = new AbortController();
        var requestId = ++adminAjaxSequence;
        currentMain.classList.add('ym-admin-ajax-loading');
        currentMain.setAttribute('aria-busy', 'true');
        startProgress(false);

        try {
            var response = await fetch(targetUrl.href, {
                method: 'GET',
                credentials: 'same-origin',
                headers: {
                    'Accept': 'text/html',
                    'X-Requested-With': 'XMLHttpRequest'
                },
                signal: adminAjaxController.signal
            });
            if (!response.ok) throw new Error('HTTP ' + response.status);

            var html = await response.text();
            var nextDocument = new DOMParser().parseFromString(html, 'text/html');
            var nextMain = nextDocument.querySelector('main.main-content');
            if (!nextMain) {
                window.location.assign(response.url || targetUrl.href);
                return;
            }
            if (requestId !== adminAjaxSequence) return;

            var importedMain = document.importNode(nextMain, true);
            importedMain.classList.add('ym-admin-content-entering');
            currentMain.replaceWith(importedMain);
            if (nextDocument.title) document.title = nextDocument.title;

            if (options.historyMode === 'push') {
                window.history.pushState({ adminAjax: true }, '', targetUrl.href);
            } else if (options.historyMode === 'replace') {
                window.history.replaceState({ adminAjax: true }, '', targetUrl.href);
            }

            restoreAdminFocus(importedMain, options.focus);
            window.requestAnimationFrame(function () {
                window.requestAnimationFrame(function () { importedMain.classList.remove('ym-admin-content-entering'); });
            });
            announceAdminUpdate('Nội dung quản trị đã được cập nhật.');
            document.dispatchEvent(new CustomEvent('admin:content-updated', { detail: { url: targetUrl.href } }));
        } catch (error) {
            if (error.name !== 'AbortError') {
                currentMain.classList.remove('ym-admin-ajax-loading');
                currentMain.removeAttribute('aria-busy');
                showMessage('Không thể cập nhật dữ liệu. Vui lòng thử lại.', 'error');
            }
        } finally {
            if (requestId === adminAjaxSequence) finishProgress();
        }
    }

    function submitAdminFilter(form, submitter, historyMode) {
        var url = adminFormUrl(form, submitter);
        if (!url) return;
        loadAdminContent(url, {
            historyMode: historyMode || 'push',
            focus: captureAdminFocus(form)
        });
    }

    function isPersistentBodyNode(node) {
        if (node.nodeType !== Node.ELEMENT_NODE) return false;
        return /^(ym-navigation-progress|ym-language-status|ym-admin-ajax-status|ym-site-navigation-status)$/.test(node.id || '');
    }

    function ensureSitePageContent() {
        var existing = document.querySelector('.ym-site-page-content');
        if (existing) return existing;
        var header = document.getElementById('ym-site-header');
        if (!header || header.parentNode !== document.body) return null;
        var bodyNodes = Array.from(document.body.childNodes);
        var headerIndex = bodyNodes.indexOf(header);
        if (headerIndex < 0) return null;
        var root = document.createElement('div');
        root.className = 'ym-site-page-content';
        header.insertAdjacentElement('afterend', root);
        bodyNodes.slice(headerIndex + 1).forEach(function (node) {
            if (!isPersistentBodyNode(node)) root.appendChild(node);
        });
        return root;
    }

    function createNextSitePageContent(nextDocument) {
        var nextHeader = nextDocument.getElementById('ym-site-header');
        if (!nextHeader || nextHeader.parentNode !== nextDocument.body) return null;
        var bodyNodes = Array.from(nextDocument.body.childNodes);
        var headerIndex = bodyNodes.indexOf(nextHeader);
        var root = nextDocument.createElement('div');
        root.className = 'ym-site-page-content';
        bodyNodes.slice(headerIndex + 1).forEach(function (node) {
            if (!isPersistentBodyNode(node)) root.appendChild(node);
        });
        return root;
    }

    function isPersistentSiteStyle(href) {
        var url = toUrl(href);
        if (!url || url.origin !== window.location.origin) return true;
        return /\/CSS\/(?:style\.css|user\/(?:modern-shell|user-pages)\.css|shared\/smooth-navigation\.css)$/.test(url.pathname);
    }

    function markInitialSiteStyles() {
        document.head.querySelectorAll('link[rel="stylesheet"]').forEach(function (link) {
            if (!isPersistentSiteStyle(link.href)) link.dataset.ymSitePageStyle = 'true';
        });
        document.head.querySelectorAll('style').forEach(function (style) {
            style.dataset.ymSitePageStyle = 'true';
        });
    }

    function waitForStyle(link) {
        return new Promise(function (resolve) {
            var settled = false;
            function done() {
                if (settled) return;
                settled = true;
                resolve();
            }
            link.addEventListener('load', done, { once: true });
            link.addEventListener('error', done, { once: true });
            window.setTimeout(done, 1800);
        });
    }

    async function syncSiteStyles(nextDocument, baseUrl, requestId) {
        var desired = new Map();
        nextDocument.head.querySelectorAll('link[rel="stylesheet"]').forEach(function (link) {
            var rawHref = link.getAttribute('href');
            if (!rawHref) return;
            var absolute = new URL(rawHref, baseUrl).href;
            if (!isPersistentSiteStyle(absolute)) desired.set(absolute, link);
        });

        var existingLinks = Array.from(document.head.querySelectorAll('link[rel="stylesheet"]'));
        var existingHrefs = new Set(existingLinks.map(function (link) { return link.href; }));
        var additions = [];
        desired.forEach(function (source, href) {
            if (existingHrefs.has(href)) return;
            var link = document.createElement('link');
            Array.from(source.attributes).forEach(function (attribute) {
                if (attribute.name !== 'href') link.setAttribute(attribute.name, attribute.value);
            });
            link.rel = 'stylesheet';
            link.href = href;
            link.dataset.ymSitePageStyle = 'true';
            document.head.appendChild(link);
            additions.push(waitForStyle(link));
        });
        await Promise.all(additions);
        if (requestId !== siteAjaxSequence) return;

        existingLinks.forEach(function (link) {
            if (link.dataset.ymSitePageStyle === 'true' && !desired.has(link.href)) link.remove();
        });
        document.head.querySelectorAll('style[data-ym-site-page-style="true"]').forEach(function (style) {
            style.remove();
        });
        nextDocument.head.querySelectorAll('style').forEach(function (source) {
            var style = document.createElement('style');
            Array.from(source.attributes).forEach(function (attribute) {
                style.setAttribute(attribute.name, attribute.value);
            });
            style.dataset.ymSitePageStyle = 'true';
            style.textContent = source.textContent;
            document.head.appendChild(style);
        });
    }

    function positionHeaderNavPill(nav, target, animate) {
        if (!nav || !target || !target.offsetWidth || !target.offsetHeight) return;
        if (!animate) nav.classList.add('ym-nav-pill-no-transition');
        nav.style.setProperty('--ym-nav-pill-x', target.offsetLeft + 'px');
        nav.style.setProperty('--ym-nav-pill-y', target.offsetTop + 'px');
        nav.style.setProperty('--ym-nav-pill-width', target.offsetWidth + 'px');
        nav.style.setProperty('--ym-nav-pill-height', target.offsetHeight + 'px');
        nav.classList.add('ym-nav-indicator-ready');
        if (!animate) {
            void nav.offsetWidth;
            window.requestAnimationFrame(function () { nav.classList.remove('ym-nav-pill-no-transition'); });
        }
    }

    function previewHeaderNavigation(target, animate, commit) {
        var nav = document.getElementById('ym-main-navigation');
        if (!nav || !target) return;
        nav.querySelectorAll(':scope > a[data-site-navigation]').forEach(function (anchor) {
            var active = anchor.dataset.page === target.dataset.page;
            anchor.classList.toggle('active', active);
            if (active) anchor.setAttribute('aria-current', 'page');
            else anchor.removeAttribute('aria-current');
        });
        positionHeaderNavPill(nav, target, animate);
        if (commit) nav.dataset.currentPage = target.dataset.page || '';
    }

    function headerTargetForUrl(url) {
        var nav = document.getElementById('ym-main-navigation');
        if (!nav || !url) return null;
        var targetPath = url.pathname.replace(/\/$/, '');
        return Array.from(nav.querySelectorAll(':scope > a[data-site-navigation]')).find(function (anchor) {
            var anchorUrl = toUrl(anchor.href);
            return anchorUrl && anchorUrl.pathname.replace(/\/$/, '') === targetPath;
        }) || null;
    }

    function committedHeaderTarget() {
        var nav = document.getElementById('ym-main-navigation');
        if (!nav) return null;
        return nav.dataset.currentPage
                ? nav.querySelector(':scope > a[data-page="' + nav.dataset.currentPage + '"]')
                : null;
    }

    function executeSiteScripts(root, baseUrl) {
        root.querySelectorAll('script').forEach(function (source) {
            var rawSrc = source.getAttribute('src');
            if (rawSrc && /\/JS\/smooth-navigation\.js(?:\?|$)/.test(new URL(rawSrc, baseUrl).href)) return;
            var script = document.createElement('script');
            Array.from(source.attributes).forEach(function (attribute) {
                if (attribute.name !== 'src') script.setAttribute(attribute.name, attribute.value);
            });
            if (rawSrc) {
                script.src = new URL(rawSrc, baseUrl).href;
                script.async = false;
            } else {
                script.textContent = source.textContent;
            }
            source.replaceWith(script);
        });
    }

    function syncHomeMarquee(nextDocument) {
        var current = document.querySelector('body > .marquee-bar');
        var next = nextDocument.querySelector('body > .marquee-bar');
        if (!next) {
            if (current) current.remove();
            return;
        }
        var imported = document.importNode(next, true);
        if (current) current.replaceWith(imported);
        else {
            var header = document.getElementById('ym-site-header');
            if (header) header.parentNode.insertBefore(imported, header);
        }
    }

    function announceSiteNavigation() {
        var status = document.getElementById('ym-site-navigation-status');
        if (!status) {
            status = document.createElement('div');
            status.id = 'ym-site-navigation-status';
            status.className = 'ym-sr-only';
            status.setAttribute('role', 'status');
            status.setAttribute('aria-live', 'polite');
            document.body.appendChild(status);
        }
        status.textContent = '';
        window.setTimeout(function () { status.textContent = 'Trang đã được cập nhật.'; }, 30);
    }

    async function loadSiteContent(url, options) {
        options = options || {};
        var targetUrl = typeof url === 'string' ? toUrl(url) : url;
        var currentRoot = ensureSitePageContent();
        if (!targetUrl || targetUrl.origin !== window.location.origin || !currentRoot) {
            if (targetUrl) window.location.assign(targetUrl.href);
            return;
        }

        if (siteAjaxController) siteAjaxController.abort();
        siteAjaxController = new AbortController();
        var requestId = ++siteAjaxSequence;
        currentRoot.classList.add('ym-site-content-loading');
        currentRoot.setAttribute('aria-busy', 'true');
        startProgress(false);

        try {
            var response = await fetch(targetUrl.href, {
                method: 'GET',
                credentials: 'same-origin',
                headers: { 'Accept': 'text/html', 'X-Requested-With': 'XMLHttpRequest' },
                signal: siteAjaxController.signal
            });
            if (!response.ok) throw new Error('HTTP ' + response.status);
            var nextDocument = new DOMParser().parseFromString(await response.text(), 'text/html');
            var nextHeader = nextDocument.getElementById('ym-site-header');
            var nextRoot = createNextSitePageContent(nextDocument);
            if (!nextHeader || !nextRoot) {
                window.location.assign(response.url || targetUrl.href);
                return;
            }
            if (getCurrentLanguage() === 'en' && activeLanguageTranslations.length) {
                prepareTranslatedDocument(nextDocument, activeLanguageTranslations);
            }
            await syncSiteStyles(nextDocument, response.url || targetUrl.href, requestId);
            if (requestId !== siteAjaxSequence) return;

            var importedRoot = document.importNode(nextRoot, true);
            importedRoot.classList.add('ym-site-content-entering');
            importedRoot.dataset.slideDirection = options.direction || 'forward';
            currentRoot.replaceWith(importedRoot);
            syncHomeMarquee(nextDocument);
            document.body.className = nextDocument.body.className;
            document.documentElement.lang = nextDocument.documentElement.lang || getCurrentLanguage();
            if (nextDocument.title) document.title = nextDocument.title;

            var nextActive = nextHeader.querySelector('#ym-main-navigation > a.active[data-site-navigation]');
            var currentTarget = nextActive ? document.querySelector('#ym-main-navigation > a[data-page="' + nextActive.dataset.page + '"]') : headerTargetForUrl(targetUrl);
            if (currentTarget) previewHeaderNavigation(currentTarget, true, true);

            if (options.historyMode === 'push') {
                if (!window.history.state || !window.history.state.ymSiteAjax) {
                    window.history.replaceState(Object.assign({}, window.history.state, { ymSiteAjax: true }), '', window.location.href);
                }
                window.history.pushState({ ymSiteAjax: true }, '', targetUrl.href);
            }

            executeSiteScripts(importedRoot, response.url || targetUrl.href);
            window.scrollTo({ top: 0, behavior: 'auto' });
            window.requestAnimationFrame(function () {
                window.requestAnimationFrame(function () { importedRoot.classList.remove('ym-site-content-entering'); });
            });
            announceSiteNavigation();
            document.dispatchEvent(new CustomEvent('ym:sitecontentchange', { detail: { url: targetUrl.href } }));
        } catch (error) {
            if (error.name !== 'AbortError') {
                if (currentRoot.isConnected) {
                    currentRoot.classList.remove('ym-site-content-loading');
                    currentRoot.removeAttribute('aria-busy');
                }
                var committed = committedHeaderTarget();
                if (committed) {
                    previewHeaderNavigation(committed, true, false);
                } else {
                    var nav = document.getElementById('ym-main-navigation');
                    if (nav) {
                        nav.classList.remove('ym-nav-indicator-ready');
                        nav.querySelectorAll(':scope > a.active').forEach(function (anchor) {
                            anchor.classList.remove('active');
                            anchor.removeAttribute('aria-current');
                        });
                    }
                }
                showMessage('Không thể mở trang. Vui lòng thử lại.', 'error');
            }
        } finally {
            if (requestId === siteAjaxSequence) finishProgress();
        }
    }

    function siteNavigationDirection(target) {
        var nav = document.getElementById('ym-main-navigation');
        if (!nav || !target) return 'forward';
        var anchors = Array.from(nav.querySelectorAll(':scope > a[data-site-navigation]'));
        var current = committedHeaderTarget();
        return anchors.indexOf(target) < anchors.indexOf(current) ? 'backward' : 'forward';
    }

    function isNormalNavigation(event, anchor) {
        if (!anchor || event.defaultPrevented || event.button !== 0) return false;
        if (event.metaKey || event.ctrlKey || event.shiftKey || event.altKey) return false;
        if (anchor.target && anchor.target !== '_self') return false;
        if (anchor.hasAttribute('download') || anchor.dataset.noTransition !== undefined) return false;
        var url = toUrl(anchor.href);
        if (!url || url.origin !== window.location.origin) return false;
        if (url.protocol !== 'http:' && url.protocol !== 'https:') return false;
        return !(url.pathname === window.location.pathname && url.search === window.location.search && url.hash);
    }

    function prefetch(anchor) {
        if (!anchor || anchor.dataset.prefetched === 'true') return;
        var url = toUrl(anchor.href);
        if (!url || url.origin !== window.location.origin) return;
        anchor.dataset.prefetched = 'true';
        var hint = document.createElement('link');
        hint.rel = 'prefetch';
        hint.href = url.href;
        document.head.appendChild(hint);
    }

    function formDataWithSubmitter(form, submitter) {
        var data;
        try { data = new FormData(form, submitter || undefined); }
        catch (error) {
            data = new FormData(form);
            if (submitter && submitter.name) data.append(submitter.name, submitter.value);
        }
        return new URLSearchParams(data);
    }

    function setBusy(element, busy) {
        if (!element) return;
        element.classList.toggle('ym-async-busy', busy);
        element.disabled = busy;
        element.setAttribute('aria-busy', String(busy));
    }

    function showMessage(message, type) {
        if (typeof window.showToast === 'function') {
            window.showToast(message, type || 'success');
        } else {
            window.alert(message);
        }
    }

    function updateCartCount(count) {
        var badge = document.querySelector('.ym-cart-count');
        if (!badge) return;
        var safeCount = Math.max(0, Number(count) || 0);
        badge.textContent = safeCount > 99 ? '99+' : String(safeCount);
        badge.dataset.count = String(safeCount);
        badge.hidden = safeCount === 0;
        var cart = badge.closest('.ym-cart');
        if (cart) {
            cart.classList.remove('ym-cart-bump');
            void cart.offsetWidth;
            cart.classList.add('ym-cart-bump');
        }
    }

    async function postForm(url, body) {
        var response = await fetch(url, {
            method: 'POST',
            credentials: 'same-origin',
            headers: {
                'Accept': 'application/json',
                'Content-Type': 'application/x-www-form-urlencoded;charset=UTF-8',
                'X-Requested-With': 'XMLHttpRequest'
            },
            body: body.toString()
        });
        var data;
        try { data = await response.json(); }
        catch (error) { throw new Error('Máy chủ trả về dữ liệu không hợp lệ.'); }
        if (!response.ok && !data.loginRequired) throw new Error(data.message || 'Không thể thực hiện thao tác.');
        return data;
    }

    function formatMoney(value) {
        return currency.format(Number(value) || 0) + ' VNĐ';
    }

    function getCurrentLanguage() {
        var header = document.getElementById('ym-site-header');
        return header && header.dataset.currentLang === 'en' ? 'en' : 'vi';
    }

    function replaceTranslations(value, translations) {
        if (!value || !translations.length) return value;
        var output = value;
        translations.forEach(function (translation) {
            if (!translation.from || translation.from === translation.to || !output.includes(translation.from)) return;
            var leadingWhitespace = output.match(/^\s*/)[0];
            var trailingWhitespace = output.match(/\s*$/)[0];
            if (output.trim() === translation.from) {
                output = leadingWhitespace + translation.to + trailingWhitespace;
            } else if (translation.from.length >= 8) {
                output = output.split(translation.from).join(translation.to);
            }
        });
        return output;
    }

    function prepareTranslatedDocument(nextDocument, translations) {
        var ordered = (translations || []).slice().sort(function (left, right) {
            return right.from.length - left.from.length;
        });
        var walker = nextDocument.createTreeWalker(nextDocument.body, NodeFilter.SHOW_TEXT);
        var node;
        while ((node = walker.nextNode())) {
            var parentName = node.parentElement && node.parentElement.tagName;
            if (parentName === 'SCRIPT' || parentName === 'STYLE' || parentName === 'NOSCRIPT' || parentName === 'TEMPLATE') continue;
            node.nodeValue = replaceTranslations(node.nodeValue, ordered);
        }
        nextDocument.body.querySelectorAll('*').forEach(function (element) {
            languageAttributes.forEach(function (attribute) {
                if (element.hasAttribute(attribute)) {
                    element.setAttribute(attribute, replaceTranslations(element.getAttribute(attribute), ordered));
                }
            });
        });
        nextDocument.title = replaceTranslations(nextDocument.title, ordered);
    }

    function translateLiveNode(root, translations) {
        if (!root) return;
        if (root.nodeType === Node.TEXT_NODE) {
            var parentName = root.parentElement && root.parentElement.tagName;
            if (!/^(SCRIPT|STYLE|NOSCRIPT|TEMPLATE)$/.test(parentName || '')) {
                root.nodeValue = replaceTranslations(root.nodeValue, translations);
            }
            return;
        }
        if (root.nodeType !== Node.ELEMENT_NODE) return;
        languageAttributes.forEach(function (attribute) {
            if (root.hasAttribute(attribute)) {
                root.setAttribute(attribute, replaceTranslations(root.getAttribute(attribute), translations));
            }
        });
        var walker = document.createTreeWalker(root, NodeFilter.SHOW_TEXT);
        var node;
        while ((node = walker.nextNode())) translateLiveNode(node, translations);
    }

    function watchDynamicTranslations(translations) {
        activeLanguageTranslations = (translations || []).slice().sort(function (left, right) {
            return right.from.length - left.from.length;
        });
        if (!languageObserver) {
            languageObserver = new MutationObserver(function (records) {
                if (!activeLanguageTranslations.length) return;
                languageObserver.disconnect();
                records.forEach(function (record) {
                    if (record.type === 'characterData') translateLiveNode(record.target, activeLanguageTranslations);
                    record.addedNodes.forEach(function (addedNode) {
                        translateLiveNode(addedNode, activeLanguageTranslations);
                    });
                });
                languageObserver.observe(document.body, { childList: true, subtree: true, characterData: true });
            });
        } else {
            languageObserver.disconnect();
        }
        languageObserver.observe(document.body, { childList: true, subtree: true, characterData: true });
    }

    function positionLanguagePill(switcher, lang, animate) {
        var target = switcher.querySelector('[data-lang="' + lang + '"]');
        if (!target || !target.offsetWidth || !target.offsetHeight) return;
        if (!animate) switcher.classList.add('ym-language-pill-no-transition');
        switcher.style.setProperty('--ym-language-pill-x', target.offsetLeft + 'px');
        switcher.style.setProperty('--ym-language-pill-y', target.offsetTop + 'px');
        switcher.style.setProperty('--ym-language-pill-width', target.offsetWidth + 'px');
        switcher.style.setProperty('--ym-language-pill-height', target.offsetHeight + 'px');
        switcher.classList.add('ym-language-pill-ready');
        if (!animate) {
            void switcher.offsetWidth;
            window.requestAnimationFrame(function () {
                switcher.classList.remove('ym-language-pill-no-transition');
            });
        }
    }

    function previewLanguageControls(lang, animate) {
        document.querySelectorAll('[data-language-switcher]').forEach(function (switcher) {
            switcher.dataset.activeLang = lang;
            switcher.querySelectorAll('[data-lang]').forEach(function (option) {
                var active = option.dataset.lang === lang;
                option.classList.toggle('active', active);
                option.setAttribute('aria-pressed', String(active));
            });
            positionLanguagePill(switcher, lang, animate);
        });
    }

    function updateLanguageControls(lang) {
        previewLanguageControls(lang, true);
        document.querySelectorAll('[data-language-switcher]').forEach(function (switcher) {
            switcher.classList.remove('is-switching');
        });
        var header = document.getElementById('ym-site-header');
        if (header) header.dataset.currentLang = lang;
        document.documentElement.lang = lang;
        window.ymCurrentLanguage = lang;
    }

    function announceLanguage(lang) {
        var status = document.getElementById('ym-language-status');
        if (!status) {
            status = document.createElement('div');
            status.id = 'ym-language-status';
            status.className = 'ym-visually-hidden';
            status.setAttribute('role', 'status');
            status.setAttribute('aria-live', 'polite');
            document.body.appendChild(status);
        }
        status.textContent = lang === 'en' ? 'Switched to English' : 'Đã chuyển sang Tiếng Việt';
    }

    function applyLanguageDocument(lang, translations) {
        if (languageObserver) languageObserver.disconnect();
        activeLanguageTranslations = [];

        var ordered = (translations || []).slice().sort(function (left, right) {
            return right.from.length - left.from.length;
        });
        translateLiveNode(document.body, ordered);
        document.title = replaceTranslations(document.title, ordered);
        updateLanguageControls(lang);
        watchDynamicTranslations(ordered);
        announceLanguage(lang);
        window.dispatchEvent(new CustomEvent('ym:languagechange', { detail: { lang: lang } }));
    }

    async function switchLanguage(anchor) {
        var lang = anchor.dataset.lang === 'en' ? 'en' : 'vi';
        if (languageSwitchInFlight || lang === getCurrentLanguage()) return;
        var previousLang = getCurrentLanguage();
        languageSwitchInFlight = true;
        document.querySelectorAll('[data-language-switcher]').forEach(function (switcher) {
            switcher.classList.add('is-switching');
        });
        previewLanguageControls(lang, true);

        try {
            var languageResponse = await fetch(anchor.href, {
                credentials: 'same-origin',
                cache: 'no-store',
                headers: {
                    'Accept': 'application/json',
                    'X-Requested-With': 'XMLHttpRequest'
                }
            });
            if (!languageResponse.ok) throw new Error('Language request failed');
            var payload = await languageResponse.json();
            if (!payload.success) throw new Error('Language request was rejected');

            applyLanguageDocument(payload.lang || lang, payload.translations || []);
        } catch (error) {
            previewLanguageControls(previousLang, true);
            showMessage('Không thể đổi ngôn ngữ. Vui lòng thử lại.', 'error');
        } finally {
            languageSwitchInFlight = false;
            document.querySelectorAll('[data-language-switcher]').forEach(function (switcher) {
                switcher.classList.remove('is-switching');
            });
        }
    }

    async function hydrateInitialEnglishPage() {
        if (getCurrentLanguage() !== 'en') return;
        var englishOption = document.querySelector('[data-language-switcher] [data-lang="en"]');
        if (!englishOption) return;
        try {
            var response = await fetch(englishOption.href, {
                credentials: 'same-origin',
                cache: 'no-store',
                headers: {
                    'Accept': 'application/json',
                    'X-Requested-With': 'XMLHttpRequest'
                }
            });
            if (!response.ok) return;
            var payload = await response.json();
            if (!payload.success) return;
            prepareTranslatedDocument(document, payload.translations || []);
            watchDynamicTranslations(payload.translations || []);
            updateLanguageControls('en');
        } catch (error) {
            /* The server-rendered fmt:message content remains usable. */
        }
    }

    function renderEmptyCart(section) {
        if (!section || section.querySelector('.empty-cart')) return;
        section.innerHTML = '<div class="empty-cart ym-empty-enter">' +
            '<i class="fa-solid fa-bag-shopping" aria-hidden="true"></i>' +
            '<p>Giỏ hàng của bạn đang trống.</p>' +
            '<a href="home" class="btn-shop-now">Tiếp tục mua sắm</a>' +
            '</div>';
    }

    function applyCartState(data, source) {
        updateCartCount(data.cartCount);

        var subtotal = document.getElementById('cart-subtotal');
        var discount = document.getElementById('cart-discount');
        var discountRow = document.getElementById('cart-discount-row');
        var finalTotal = document.getElementById('cart-final-total');
        if (subtotal) subtotal.textContent = formatMoney(data.subtotal);
        if (discount) discount.textContent = '- ' + formatMoney(data.discountAmount);
        if (discountRow) discountRow.hidden = !(Number(data.discountAmount) > 0);
        if (finalTotal) finalTotal.textContent = formatMoney(data.finalTotal);

        var checkout = document.querySelector('.btn-checkout');
        if (checkout && Number(data.cartCount) === 0) checkout.disabled = true;

        if (!source) return;
        var card = source.closest('.cart-card');
        if (!card) return;

        if (data.removed) {
            card.classList.add('is-removing');
            window.setTimeout(function () {
                card.remove();
                if (Number(data.cartCount) === 0) renderEmptyCart(document.querySelector('.cart-items-section'));
            }, 260);
            return;
        }

        var quantity = card.querySelector('.input-qty');
        var itemTotal = card.querySelector('.item-total');
        var increase = card.querySelector('button[value="increase"]');
        if (quantity) quantity.value = data.itemQuantity;
        if (itemTotal) itemTotal.textContent = formatMoney(data.itemTotal);
        if (increase) increase.disabled = Number(data.itemQuantity) >= Number(data.itemStock);
        card.classList.remove('is-updating');
        void card.offsetWidth;
        card.classList.add('is-updated');
        window.setTimeout(function () { card.classList.remove('is-updated'); }, 420);
    }

    async function addToCart(form, submitter) {
        if (!form.reportValidity()) return;
        var url = toUrl((submitter && submitter.getAttribute('formaction')) || form.action);
        if (!url) return;
        setBusy(submitter, true);
        startProgress(false);
        try {
            var data = await postForm(url.href, formDataWithSubmitter(form, submitter));
            if (data.loginRequired) {
                showMessage(data.message || 'Vui lòng đăng nhập để thêm sản phẩm.', 'error');
                window.setTimeout(function () { window.location.assign(data.redirect || 'login'); }, 650);
                return;
            }
            updateCartCount(data.cartCount);
            showMessage(data.message || 'Đã thêm sản phẩm vào giỏ hàng.', 'success');
            if (typeof window.closeBuyNowModal === 'function') window.closeBuyNowModal();
        } catch (error) {
            showMessage(error.message || 'Không thể thêm sản phẩm.', 'error');
        } finally {
            setBusy(submitter, false);
            finishProgress();
        }
    }

    async function updateCart(form, submitter) {
        setBusy(submitter, true);
        startProgress(false);
        var card = form.closest('.cart-card');
        if (card) card.classList.add('is-updating');
        try {
            var data = await postForm(form.action, formDataWithSubmitter(form, submitter));
            applyCartState(data, submitter || form);
            if (data.message) showMessage(data.message, data.success === false ? 'error' : 'success');
        } catch (error) {
            if (card) card.classList.remove('is-updating');
            showMessage(error.message || 'Không thể cập nhật giỏ hàng.', 'error');
        } finally {
            setBusy(submitter, false);
            finishProgress();
        }
    }

    async function removeCartItem(anchor) {
        var url = toUrl(anchor.href);
        if (!url) return;
        var body = new URLSearchParams(url.search);
        body.set('action', 'remove');
        startProgress(false);
        var card = anchor.closest('.cart-card');
        if (card) card.classList.add('is-updating');
        try {
            var data = await postForm(url.pathname, body);
            applyCartState(data, anchor);
            showMessage(data.message || 'Đã xóa sản phẩm khỏi giỏ hàng.', 'success');
        } catch (error) {
            if (card) card.classList.remove('is-updating');
            showMessage(error.message || 'Không thể xóa sản phẩm.', 'error');
        } finally {
            finishProgress();
        }
    }

    document.addEventListener('pointerover', function (event) {
        var anchor = event.target.closest('a[data-prefetch]');
        if (anchor) prefetch(anchor);
    }, { passive: true });

    document.addEventListener('focusin', function (event) {
        var anchor = event.target.closest('a[data-prefetch]');
        if (anchor) prefetch(anchor);
    });

    document.addEventListener('click', function (event) {
        var languageOption = event.target.closest('[data-language-switcher] [data-lang]');
        if (languageOption) {
            event.preventDefault();
            switchLanguage(languageOption);
            return;
        }
        var remove = event.target.closest('.cart-items-section .btn-remove');
        if (remove) {
            event.preventDefault();
            removeCartItem(remove);
            return;
        }
        var siteLink = event.target.closest('a[data-site-navigation]');
        if (siteLink && isNormalNavigation(event, siteLink)) {
            event.preventDefault();
            var navTarget = document.querySelector('#ym-main-navigation > a[data-page="' + siteLink.dataset.page + '"]');
            var direction = siteNavigationDirection(navTarget);
            if (navTarget) previewHeaderNavigation(navTarget, true, false);
            loadSiteContent(toUrl(siteLink.href), {
                historyMode: 'push',
                direction: direction
            });
            return;
        }
        var adminAjaxLink = event.target.closest('a[data-admin-ajax-link]');
        if (adminAjaxLink && isNormalNavigation(event, adminAjaxLink)) {
            event.preventDefault();
            loadAdminContent(toUrl(adminAjaxLink.href), { historyMode: 'push' });
            return;
        }
        var anchor = event.target.closest('a');
        if (isNormalNavigation(event, anchor)) {
            downloadSubmissionInFlight = false;
            startProgress(true);
        }
    });

    document.addEventListener('submit', function (event) {
        if (event.defaultPrevented) return;
        var form = event.target;
        var submitter = event.submitter;
        var action = toUrl((submitter && submitter.getAttribute('formaction')) || form.action);
        if (form.matches('form[data-admin-ajax]') && form.method.toLowerCase() === 'get') {
            event.preventDefault();
            window.clearTimeout(adminSearchTimer);
            submitAdminFilter(form, submitter, 'push');
            return;
        }
        if (isDownloadSubmission(form, submitter, action)) {
            showDownloadFeedback(form, submitter);
            return;
        }
        if (action && action.origin === window.location.origin && /\/add-to-cart\/?$/.test(action.pathname)) {
            event.preventDefault();
            addToCart(form, submitter);
            return;
        }
        if (form.matches('.quantity-control, .voucher-input-group, [data-cart-ajax]')) {
            event.preventDefault();
            updateCart(form, submitter);
            return;
        }
        downloadSubmissionInFlight = false;
        startProgress(true);
    });

    document.addEventListener('input', function (event) {
        var control = event.target.closest('[data-admin-live-search]');
        if (!control || event.isComposing) return;
        var form = control.closest('form[data-admin-ajax]');
        if (!form) return;
        window.clearTimeout(adminSearchTimer);
        adminSearchTimer = window.setTimeout(function () {
            submitAdminFilter(form, null, 'replace');
        }, 380);
    });

    document.addEventListener('change', function (event) {
        var control = event.target.closest('[data-admin-auto-submit]');
        if (!control) return;
        var form = control.closest('form[data-admin-ajax]');
        if (!form) return;
        window.clearTimeout(adminSearchTimer);
        submitAdminFilter(form, null, 'push');
    });

    window.addEventListener('popstate', function (event) {
        if (document.querySelector('form[data-admin-ajax]')) {
            loadAdminContent(toUrl(window.location.href), { historyMode: 'none' });
        } else if (document.getElementById('ym-site-header') && event.state && event.state.ymSiteAjax) {
            var target = headerTargetForUrl(toUrl(window.location.href));
            var direction = siteNavigationDirection(target);
            if (target) previewHeaderNavigation(target, true, false);
            loadSiteContent(toUrl(window.location.href), { historyMode: 'none', direction: direction });
        }
    });

    window.addEventListener('pageshow', finishProgress);
    window.addEventListener('beforeunload', function () {
        if (!downloadSubmissionInFlight) startProgress(true);
    });
    ensureProgress();
    if (document.getElementById('ym-site-header')) {
        markInitialSiteStyles();
        ensureSitePageContent();
        var initialNav = document.querySelector('#ym-main-navigation > a.active[data-site-navigation]')
                || headerTargetForUrl(toUrl(window.location.href));
        if (initialNav) previewHeaderNavigation(initialNav, false, true);
    }
    previewLanguageControls(getCurrentLanguage(), false);
    window.addEventListener('resize', function () {
        previewLanguageControls(getCurrentLanguage(), false);
        var activeNav = document.querySelector('#ym-main-navigation > a.active[data-site-navigation]');
        if (activeNav) positionHeaderNavPill(document.getElementById('ym-main-navigation'), activeNav, false);
    }, { passive: true });
    hydrateInitialEnglishPage();
})();
