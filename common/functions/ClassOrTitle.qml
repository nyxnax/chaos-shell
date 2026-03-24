pragma Singleton
import QtQuick

QtObject {
    id: root

    function excludeClass(Wclass, Wtitle, combiner, icon) {
        if (!Wclass) return Wtitle;

        const lower = Wclass.toString().toLowerCase().trim();
        //add exclusions for title here
        const isExcluded = lower.includes("~") ||
                           (lower.includes("org.quickshell") && icon === false) ||
                           lower.includes("steam");

        //ensures steam game still returns icon id
        if (lower.includes("steam_app_") &&
            !lower.includes("default") &&
            icon === true) return Wclass;

        if (isExcluded) return Wtitle;

        return (combiner === true) ? `${Wclass}: ${Wtitle}` : Wclass;
    }
}
