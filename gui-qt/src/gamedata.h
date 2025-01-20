#ifndef GAMEDATA_H
#define GAMEDATA_H

#include <QString>
#include <QMap>

struct GameInfo {
    QString name;
    QString code;
    QString dvpCode;
    QString path;
    QString displayName;
    bool isSupported;

    GameInfo() : isSupported(false) {}
    GameInfo(const QString& n, const QString& c, const QString& d, const QString& dn, bool s = true)
        : name(n), code(c), dvpCode(d), displayName(dn), isSupported(s) {}
};

class GameDatabase {
public:
    static QMap<QString, GameInfo> getDefaultGames() {
        QMap<QString, GameInfo> games;
        
        games["2spicy"] = GameInfo("2spicy", "SBMV", "DVP-0027", "2Spicy");
        games["afterburner"] = GameInfo("afterburner", "SBLR", "DVP-0009", "After Burner Climax");
        games["ghostsquad"] = GameInfo("ghostsquad", "SBNJ", "DVP-0029", "Ghost Squad Evolution");
        games["harleydavidson"] = GameInfo("harleydavidson", "SBRG", "DVP-5007", "Harley Davidson");
        games["hummerextreme"] = GameInfo("hummerextreme", "SBST", "DVP-0079", "Hummer Extreme");
        games["hummer"] = GameInfo("hummer", "SBQN", "DVP-0057", "Hummer");
        games["letsgojungle"] = GameInfo("letsgojungle", "SBLU", "DVP-0011", "Let's Go Jungle");
        games["letsgojunglesp"] = GameInfo("letsgojunglesp", "SBNR", "DVP-0036", "Let's Go Jungle Special");
        games["outrun2sp"] = GameInfo("outrun2sp", "SBMB", "DVP-0015", "Outrun 2 SP SDX");
        games["rtuned"] = GameInfo("rtuned", "SBQW", "DVP-0060", "R-Tuned: Ultimate Street Racing");
        games["racetv"] = GameInfo("racetv", "SBPF", "DVP-0044", "Race TV");
        games["rambo"] = GameInfo("rambo", "SBQL", "DVP-0069", "Rambo");
        games["hotd4"] = GameInfo("hotd4", "SBLC", "DVP-0003", "The House of the Dead 4");
        games["hotd4sp"] = GameInfo("hotd4sp", "SBLS", "DVP-0010", "The House of the Dead 4 Special");
        games["hotdex"] = GameInfo("hotdex", "SBRC", "DVP-0063", "The House of the Dead EX");
        games["vf5"] = GameInfo("vf5", "SBLM", "DVP-0008", "Virtua Fighter 5");
        games["vf5r"] = GameInfo("vf5r", "SBQU", "DVP-5004", "Virtua Fighter 5 R");
        games["vf5fs"] = GameInfo("vf5fs", "SBUV", "DVP-5019", "Virtua Fighter 5 FS");
        games["initiald4"] = GameInfo("initiald4", "SBNK", "DVP-0030", "Initial D 4");
        games["initiald5"] = GameInfo("initiald5", "SBTS", "DVP-0075", "Initial D 5");
        games["virtuatennis3"] = GameInfo("virtuatennis3", "SBKX", "DVP-0005", "Virtua Tennis 3");
        games["primevalhunt"] = GameInfo("primevalhunt", "SBPP", "DVP-0048", "Primeval Hunt");

        return games;
    }
};

#endif // GAMEDATA_H
