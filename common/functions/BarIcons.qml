pragma Singleton
import QtQuick

QtObject {
    id: root

    // --- ICON MAPPING DICTIONARY ---
    function getAppIcon(className) {
        console.log("[IconService] Hyprland reported window class:", className);
        // Sanitize the string to make matching easier
        const lower = className.toString().toLowerCase().trim();

        // Browsers
        if (lower.includes("firefox") || lower.includes("librewolf")) return "";
        if (lower.includes("chrome") || lower.includes("chromium") || lower.includes("brave")) return "";

        // Chat / Social
        if (lower.includes("discord") || lower.includes("vesktop") || lower.includes("webcord")) return "";
        if (lower.includes("slack")) return "";
        if (lower.includes("telegram")) return "";

        // Media / Gaming
        if (lower.includes("spotify")) return "";
        if (lower.includes("vlc") || lower.includes("mpv")) return "";
        if (lower.includes("minecraft")) return "󰍳";
        if (lower.includes("heroes")) return "";
        if (lower.includes("steam")) return "";
        if (lower.includes("mpv") || lower.includes("vlc") || lower.includes("avidemux")) return "󰿎";

        // System / Files
        if (lower.includes("thunar") || lower.includes("dolphin") || lower.includes("nautilus")) return "";
        if (lower.includes("obsidian")) return "󰠮";

        // Development / Terminal
        if (lower.includes("kitty") || lower.includes("alacritty") || lower.includes("wezterm") || lower.includes("konsole")) return "";
        if (lower.includes("code") || lower.includes("codium")) return "󰨞";

        // If not listed dont show
        return "";
    }
}
