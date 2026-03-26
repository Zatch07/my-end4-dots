// START METADATA
// NAME: Deluxified
// AUTHOR: zatch (based on DELUUXE's deluxify and JulienMaille's spicetify-dynamic-theme)
// DESCRIPTION: Dynamic per-song color extraction for the Deluxified Caelestia theme using Vibrant.js.
// END METADATA

/// <reference path="../globals.d.ts" />

(function Deluxified() {
    // ── Wait for Spicetify & Vibrant to be ready ────────────────
    function waitForDependencies() {
        return new Promise((resolve) => {
            function check() {
                if (Spicetify?.Player?.data && typeof Vibrant !== 'undefined') {
                    resolve();
                } else {
                    setTimeout(check, 100);
                }
            }
            check();
        });
    }

    // ── Apply dynamic colors from a hex value ───────────────────
    function applyDynamicColors(hex) {
        if (!hex || typeof hex !== 'string') return;
        hex = hex.startsWith('#') ? hex : '#' + hex;

        function lightenDarkenColor(h, p) {
            return "#" + [1, 3, 5]
                .map((s) => parseInt(h.substr(s, 2), 16))
                .map((c) => parseInt((c * (100 + p)) / 100))
                .map((c) => Math.min(255, c))
                .map((c) => c.toString(16).padStart(2, "0"))
                .join("");
        }
        
        function hexToRgb(h) {
            var bigint = parseInt(h.replace("#", ""), 16);
            return [(bigint >> 16) & 255, (bigint >> 8) & 255, bigint & 255];
        }

        // Deluxify hue rotation calculation
        function rgbToHsv(r, g, b) {
            r /= 255; g /= 255; b /= 255;
            let v = Math.max(r, g, b), n = v - Math.min(r, g, b);
            let h = n === 0 ? 0 : n && v === r ? (g - b) / n : v === g ? 2 + (b - r) / n : 4 + (r - g) / n;
            return [60 * (h < 0 ? h + 6 : h), v && n / v, v];
        }

        // We use the hex as the normal color
        let normal = hex;
        let light = lightenDarkenColor(hex, 30);
        let dark = lightenDarkenColor(hex, -20);
        let dark_rgb = hexToRgb(dark).join(",");

        const root = document.documentElement.style;
        root.setProperty('--dynamic_color', normal);
        root.setProperty('--dynamic_color-light', light);
        root.setProperty('--dynamic_color-dark', dark);
        root.setProperty('--dynamic_color-dark_RGB', dark_rgb);

        // Waveform hue-shift calculation
        const originalHSV = rgbToHsv(29, 185, 84); // Spotify green #1DB954
        const newHSV = rgbToHsv(...hexToRgb(light));
        const hueRotation = newHSV[0] - originalHSV[0];
        const satDiff = newHSV[1] - originalHSV[1];
        const valDiff = newHSV[2] - originalHSV[2];

        root.setProperty('--waveform-hue-rotation', `${Math.round(hueRotation)}deg`);
        root.setProperty('--waveform-saturation', Math.max(0, Math.min(originalHSV[1] + satDiff + 0.1, 1)));
        root.setProperty('--waveform-brightness', Math.max(0, Math.min(originalHSV[2] + valDiff + 0.2, 1)));
    }

    // ── Extract color from current track via Vibrant ────────────
    let previousURI = '';
    
    function extractVibrantFallback(uri) {
        // Fallback to Spicetify's color extractor if Vibrant canvas load fails
        Spicetify.colorExtractor(uri).then((colors) => {
            if (colors) {
                const hex = colors.VIBRANT || colors.PROMINENT || "#1db954";
                applyDynamicColors(hex);
            }
        }).catch(() => applyDynamicColors("#1db954"));
    }

    function onTrackChange() {
        const item = Spicetify.Player.data?.item;
        if (!item) return;

        const uri = item.uri;
        if (uri === previousURI) return;
        previousURI = uri;

        let imgUrl = item.metadata.image_url;
        if (!imgUrl) {
            applyDynamicColors("#1db954");
            return;
        }

        // If it's a valid spotify image, fetch it in canvas
        if (Spicetify.Platform.PlatformData.client_version_triple >= "1.2.0" && imgUrl.startsWith("spotify:image:")) {
            imgUrl = imgUrl.replace("spotify:image:", "https://i.scdn.co/image/");
            
            let imgCORS = new Image();
            imgCORS.crossOrigin = "anonymous";
            imgCORS.src = imgUrl;

            imgCORS.onload = function () {
                try {
                    // Create dummy canvas
                    let canvas = document.createElement("canvas");
                    let ctx = canvas.getContext("2d");
                    ctx.drawImage(imgCORS, 0, 0);

                    // Extract colors
                    let swatches = new Vibrant(imgCORS, 12).swatches();
                    let bestSwatchType = ["Vibrant", "LightVibrant", "DarkVibrant", "Muted"].find(type => swatches[type]);
                    let hex = bestSwatchType ? swatches[bestSwatchType].getHex() : "#1db954";
                    
                    applyDynamicColors(hex);
                } catch (err) {
                    console.error("[Deluxified] Vibrant error", err);
                    extractVibrantFallback(uri);
                }
            };
            imgCORS.onerror = () => extractVibrantFallback(uri);
        } else {
            extractVibrantFallback(uri);
        }
    }

    // ── Initialize ──────────────────────────────────────────────
    async function init() {
        await waitForDependencies();
        console.log('[Deluxified] Vibrant extension loaded.');
        
        // Listeners
        Spicetify.Player.addEventListener("songchange", onTrackChange);
        onTrackChange();
    }

    init();
})();
