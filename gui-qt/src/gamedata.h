#ifndef GAMEDATA_H
#define GAMEDATA_H

#include <QString>
#include <QMap>

struct GameInfo {
    QString name;
    QString code;
    QString dvpCode;
    QString path;
    bool isSupported;

    GameInfo() : isSupported(false) {}
    GameInfo(const QString& n, const QString& c, const QString& d, bool s = true)
        : name(n), code(c), dvpCode(d), isSupported(s) {}
};

class GameDatabase {
public:
    static QMap<QString, GameInfo> getDefaultGames() {
        QMap<QString, GameInfo> games;
        games["2spicy"] = GameInfo("2 Spicy", "SBMV", "DVP-0027");
        games["afterburner"] = GameInfo("After Burner Climax", "SBLR", "DVP-0009");
        games["ghostsquad"] = GameInfo("Ghost Squad Evolution", "SBNJ", "DVP-0029");
        games["harleydavidson"] = GameInfo("Harley Davidson", "SBRG", "DVP-5007");
        games["hummerextreme"] = GameInfo("Hummer Extreme", "SBST", "DVP-0079");
        games["hummer"] = GameInfo("Hummer", "SBQN", "DVP-0057");
        games["letsgojungle"] = GameInfo("Let's Go Jungle", "SBLU", "DVP-0011");
        games["letsgojunglesp"] = GameInfo("Let's Go Jungle Special", "SBNR", "DVP-0036");
        games["outrun2sp"] = GameInfo("Outrun 2 SP SDX", "SBMB", "DVP-0015");
        games["rtuned"] = GameInfo("R-Tuned", "SBQW", "DVP-0060");
        games["racetv"] = GameInfo("Race TV", "SBPF", "DVP-0044");
        games["rambo"] = GameInfo("Rambo", "SBQL", "DVP-0069");
        games["hotd4"] = GameInfo("The House of the Dead 4", "SBLC", "DVP-0003");
        games["hotd4sp"] = GameInfo("The House of the Dead 4 Special", "SBLS", "DVP-0010");
        games["hotdex"] = GameInfo("The House of the Dead Ex", "SBRC", "DVP-0063");
        games["vf5"] = GameInfo("Virtua Fighter 5", "SBLM", "DVP-0008");
        games["vf5r"] = GameInfo("Virtua Fighter 5 R", "SBQU", "DVP-5004");
        games["vf5fs"] = GameInfo("Virtua Fighter 5 FS", "SBUV", "DVP-5019");
        games["initiald4"] = GameInfo("Initial D 4", "SBNK", "DVP-0030");
        games["initiald5"] = GameInfo("Initial D 5", "SBTS", "DVP-0075");
        games["virtuatennis3"] = GameInfo("Virtua Tennis 3", "SBKX", "DVP-0005");
        games["primevalhunt"] = GameInfo("Primeval Hunt", "SBPP", "DVP-0048");
        return games;
    }
};

#endif // GAMEDATA_H
