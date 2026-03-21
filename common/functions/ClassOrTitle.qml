pragma Singleton
import QtQuick

QtObject {
    id: root

    // --- exclusions for WindowClass ---
    function excludeClass(Wclass, Wtitle) {

         //Sanitize the string to make matching easier
        if (Wclass == undefined || Wclass == "") return Wtitle;
        const lower = Wclass.toString().toLowerCase().trim();

        if (lower.includes("steam_app_default") || lower.includes("~")) return Wtitle;
        return Wclass;
    }
}
