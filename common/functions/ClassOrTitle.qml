pragma Singleton
import QtQuick

QtObject {
    id: root

    // --- exclusions for WindowClass ---
    function excludeClass(Wclass, Wtitle) {

         //Sanitize the string to make matching easier
        if (Wclass == undefined || Wclass == "") return Wtitle;
        const lower = Wclass.toString().toLowerCase().trim();

        //add rules to handle edge cases for apps here e.g. Kitty
        if (lower.includes("steam_app_default") || lower.includes("~") || lower.includes("org.quickshell")) return Wtitle;
        return Wclass;
    }
}
