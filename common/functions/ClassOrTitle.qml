pragma Singleton
import QtQuick

QtObject {
    id: root

    function excludeClass(Wclass, Wtitle, combiner) {
        if (!Wclass) return Wtitle;

        const lower = Wclass.toString().toLowerCase().trim();
        //add exclusions for title here
        const isExcluded = lower.includes("steam_app_default") ||
                           lower.includes("~") ||
                           lower.includes("org.quickshell") ||
                           lower.includes("steam");

        if (isExcluded) return Wtitle;

        return (arguments.length === 3) ? `${Wclass}: ${Wtitle}` : Wclass;
    }
}
