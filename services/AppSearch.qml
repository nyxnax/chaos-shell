pragma Singleton
import Quickshell
import QtQuick

Singleton {
    id: root

    readonly property var substitutions: ({
        "code-url-handler": "visual-studio-code",
        "Code": "visual-studio-code",
        "gnome-tweaks": "org.gnome.tweaks",
        "pavucontrol-qt": "pavucontrol",
        "wps": "wps-office2019-kprometheus",
        "wpsoffice": "wps-office2019-kprometheus",
        "footclient": "foot",
        "Heroes of the Storm": "lutris_heroes-of-the-storm"
    })

    readonly property var regexSubstitutions: [
        { "regex": /^steam_app_(\d+)$/, "replace": "steam_icon_$1" },
        { "regex": /Minecraft.*/, "replace": "minecraft" },
        { "regex": /.*polkit.*/, "replace": "system-lock-screen" },
        { "regex": /gcr.prompter/, "replace": "system-lock-screen" },
    ]

    function iconExists(name) {
        if (!name) return false;
        return Quickshell.iconPath(name, true).length > 0;
    }

    function guessIcon(str) {
        if (!str) return "application-x-executable";

        if (substitutions[str]) return substitutions[str];

        for (let sub of regexSubstitutions) {
            if (sub.regex.test(str)) {
                return str.replace(sub.regex, sub.replace);
            }
        }

        const entry = DesktopEntries.byId(str);
        if (entry && entry.icon) return entry.icon;

        const heuristic = DesktopEntries.heuristicLookup(str);
        if (heuristic && heuristic.icon) return heuristic.icon;

        let normalized = str.toLowerCase();
        if (iconExists(normalized)) return normalized;

        if (str.includes('.')) {
            let parts = str.split('.');
            let last = parts[parts.length - 1].toLowerCase();
            if (iconExists(last)) return last;
        }

        return iconExists("application-x-executable") ? "application-x-executable" : "system-run";
    }
}
