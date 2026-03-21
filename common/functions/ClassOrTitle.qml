pragma Singleton
import QtQuick

QtObject {
    id: root

    // --- exclusions for WindowClass ---
    function excludeClass(Wclass, Wtitle) {
        console.log("[Vented Debug] class is undefined: ", Wclass == undefined );
        console.log("[Vented Debug] title is undefined: ", Wtitle == undefined );
        console.log("[Vented Debug] Class: ",  Wclass, ", Title: ", Wtitle);


         //Sanitize the string to make matching easier
        if (Wclass == undefined || Wclass == "") return Wtitle;
        const lower = Wclass.toString().toLowerCase().trim();

        if (lower.includes("steam_app_default") || lower.includes("~")) return Wtitle;
        return Wclass;
    }
}
