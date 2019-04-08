import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';
import 'package:meta/meta.dart';
import 'package:predictions/data/api/matches_api.dart';
import 'package:predictions/data/model/football_match.dart';
import 'package:rxdart/subjects.dart';

class Matches {
  final List<FootballMatch> allMatches;
  final List<FootballMatch> thisSeasonsMatches;
  final Map<String, Map<String, List<FootballMatch>>> groupedMatches;

  final List<FootballMatch> winLoseDrawMatches;
  final List<FootballMatch> under3Matches;
  final List<FootballMatch> over2Matches;
  final List<FootballMatch> bttsNoMatches;
  final List<FootballMatch> bttsYesMatches;

  Matches(
      {@required this.allMatches,
      @required this.thisSeasonsMatches,
      @required this.groupedMatches,
      @required this.winLoseDrawMatches,
      @required this.under3Matches,
      @required this.over2Matches,
      @required this.bttsNoMatches,
      @required this.bttsYesMatches});
}

class MatchesBloc {
  final BehaviorSubject<Matches> matches = BehaviorSubject<Matches>();

  void dispose() {
    matches.close();
  }

  MatchesBloc() {
    _loadMatches();
  }

  Future _loadMatches() async {
    final api = MatchesApi();
    final apiMatches = await api.fetchMatches();

    final matchesData = await compute(_getMatchesData, apiMatches);
    matches.add(matchesData);
  }

  static Matches _getMatchesData(List<FootballMatch> allMatches) {
    final thisSeasonsMatches = allMatches.where(_isThisSeason).toList();
    return Matches(
      allMatches: allMatches,
      thisSeasonsMatches: thisSeasonsMatches,
      groupedMatches: _groupMatches(thisSeasonsMatches),
      winLoseDrawMatches: _getWinLoseDrawMatches(thisSeasonsMatches),
      under3Matches: _getUnder3Matches(thisSeasonsMatches),
      over2Matches: _getOver2Matches(thisSeasonsMatches),
      bttsNoMatches: _getBttsNoMatches(thisSeasonsMatches),
      bttsYesMatches: _getBttsYesMatches(thisSeasonsMatches),
    );
  }

  static bool _isThisSeason(FootballMatch match) {
    final dateSplitString = match.date.split("-");
    return dateSplitString[0] == "2019";
  }

  static Map<String, Map<String, List<FootballMatch>>> _groupMatches(
      List<FootballMatch> matches) {
    final groupedByDay = groupBy(matches, (obj) => obj.date);
    return groupedByDay.map(
        (key, value) => MapEntry(key, groupBy(value, (obj) => obj.league)));
  }

  static List<FootballMatch> _getWinLoseDrawMatches(
      List<FootballMatch> allMatches) {
    final teamsWithHighWinLoseDraw = [
      "(H) Arsenal",
      "(H) Braga",
      "(H) Manchester City",
      "(H) Osasuna",
      "(H) Getafe",
      "(H) Rayo Majadahonda",
      "(H) FC Porto",
      "(H) Valenciennes",
      "(H) Guimaraes",
      "(H) Sheffield United",
      "(H) Pachuca",
      "(H) Atletico Madrid",
      "(H) Barcelona",
      "(H) Norwich City",
      "(H) Lecce",
      "(H) Hannover 96",
      "(H) Galatasaray",
      "(H) Standard Liege",
      "(H) PAOK Salonika",
      "(H) AZ",
      "(H) Eupen",
      "(H) FC Groningen",
      "(H) Tigres UANL",
      "(H) Frosinone",
      "(H) Ajax",
      "(H) Fulham",
      "(H) Juventus",
      "(H) Motherwell",
      "(H) St Johnstone",
      "(H) Dundee",
      "(H) St Mirren",
      "(H) Bayern Munich",
      "(H) Lazio",
      "(H) Fenerbahce",
      "(H) Olympiacos",
      "(H) Young Boys",
      "(H) FC Cologne",
      "(H) Zenit St Petersburg",
      "(H) LASK Linz",
      "(H) Guangzhou Evergrande",
      "(H) Ural Sverdlovsk Oblast",
      "(H) Los Angeles Galaxy",
      "(H) Seattle Sounders FC",
      "(H) Los Angeles FC",
      "(A) Newport County",
      "(A) Fulham",
      "(A) Swansea City",
      "(A) AD Alcorcon",
      "(A) Maritzburg Utd",
      "(A) Reus Deportiu",
      "(A) Boavista",
      "(A) C.D. Nacional",
      "(A) Huddersfield Town",
      "(A) Apollon Smyrni",
      "(A) Paris Saint-Germain",
      "(A) Querétaro",
      "(A) Pumas Unam",
      "(A) AFC Bournemouth",
      "(A) Olympiacos",
      "(A) PAOK Salonika",
      "(A) Gimnástic Tarragona",
      "(A) Excelsior",
      "(A) Mainz",
      "(A) KSC Lokeren",
      "(A) NAC",
      "(A) Fortuna Sittard",
      "(A) Manchester City",
      "(A) Anderlecht",
      "(A) Empoli",
      "(A) Asteras Tripolis",
      "(A) Dijon FCO",
      "(A) Hibernian",
      "(A) Carpi",
      "(A) Hannover 96",
      "(A) 1. FC Nürnberg",
      "(A) Motherwell",
      "(A) Hamilton Academical",
      "(A) Emmen",
      "(A) RB Leipzig",
      "(A) FC Ingolstadt 04",
      "(A) Celtic",
      "(A) FK Austria Vienna",
      "(A) Guizhou Renhe",
      "(A) Beijing Guoan",
      "(A) Metallurg Krasnoyarsk",
      "(A) Colorado Rapids",
      "(A) Las Vegas Lights FC",
    ];
    return allMatches
        .where((m) =>
            teamsWithHighWinLoseDraw.contains("(H) ${m.homeTeam}") ||
            teamsWithHighWinLoseDraw.contains("(A) ${m.awayTeam}"))
        .toList();
  }

  static List<FootballMatch> _getUnder3Matches(List<FootballMatch> allMatches) {
    final leaguesWithHighUnder3 = [
      "(H) Boavista",
      "(H) Chippa United",
      "(H) Granada",
      "(H) Vitoria Setubal",
      "(H) Gimnástic Tarragona",
      "(H) Amiens",
      "(H) Cadiz",
      "(H) Reus Deportiu",
      "(H) Real Oviedo",
      "(H) Levadiakos",
      "(H) Giannina",
      "(H) Beziers AS",
      "(H) Niort",
      "(H) Rubin Kazan",
      "(A) Maritimo",
      "(A) Vitoria Setubal",
      "(A) Maritzburg Utd",
      "(A) Sochaux",
      "(A) Deportivo La Coruña",
      "(A) Almeria",
      "(A) FC Xanthi",
      "(A) Málaga",
      "(A) Lens",
      "(A) Levadiakos",
      "(A) Caen",
      "(A) Giannina",
      "(A) Belgrano Cordoba",
      "(A) Terek Grozny",
      "(A) Rostov",
    ];
    return allMatches
        .where((m) =>
            leaguesWithHighUnder3.contains("(H) ${m.homeTeam}") ||
            leaguesWithHighUnder3.contains("(A) ${m.awayTeam}"))
        .toList();
  }

  static List<FootballMatch> _getOver2Matches(List<FootballMatch> allMatches) {
    final leaguesWithHighOver2 = [
      "(H) Doncaster Rovers",
      "(H) Cardiff City",
      "(H) Villarreal",
      "(H) Brisbane Roar",
      "(H) Sevilla FC",
      "(H) Perth Glory",
      "(H) Walsall",
      "(H) AS Roma",
      "(H) FC Augsburg",
      "(H) Eupen",
      "(H) Frosinone",
      "(H) Ajax",
      "(H) Hamilton Academical",
      "(H) Panetolikos",
      "(H) Werder Bremen",
      "(H) Cercle Brugge",
      "(H) Feyenoord",
      "(H) VfL Bochum",
      "(H) Rangers",
      "(H) St Gallen",
      "(H) FC Cologne",
      "(H) FC Nordsjaelland",
      "(H) Esbjerg",
      "(H) FC Salzburg",
      "(H) Gamba Osaka",
      "(H) Brondby",
      "(H) Yokohama F. Marinos",
      "(H) Shimizu S-Pulse",
      "(H) Los Angeles Galaxy",
      "(H) San Jose Earthquakes",
      "(H) Los Angeles FC",
      "(H) San Antonio FC",
      "(H) LA Galaxy II",
      "(H) Oklahoma City Energy FC",
      "(H) Toronto FC",
      "(A) Walsall",
      "(A) Tottenham Hotspur",
      "(A) Burnley",
      "(A) Watford",
      "(A) Real Madrid",
      "(A) Girona FC",
      "(A) C.D. Nacional",
      "(A) SD Huesca",
      "(A) Western Sydney FC",
      "(A) Levante",
      "(A) Eibar",
      "(A) Besiktas",
      "(A) Genk",
      "(A) Hull City",
      "(A) Peterborough United",
      "(A) Chelsea",
      "(A) VVV Venlo",
      "(A) Cercle Brugge",
      "(A) Sivasspor",
      "(A) Fortuna Sittard",
      "(A) Bologna",
      "(A) St Mirren",
      "(A) Standard Liege",
      "(A) Schalke 04",
      "(A) Hannover 96",
      "(A) Eintracht Frankfurt",
      "(A) Napoli",
      "(A) Emmen",
      "(A) Vitesse",
      "(A) Fiorentina",
      "(A) Club Brugge",
      "(A) VfB Stuttgart",
      "(A) Arminia Bielefeld",
      "(A) SpVgg Greuther Fürth",
      "(A) Thun",
      "(A) AaB",
      "(A) Nagoya Grampus Eight",
      "(A) Shanghai SIPG",
      "(A) Portland Timbers",
      "(A) Minnesota United FC",
      "(A) Chicago Fire",
      "(A) Hartberg",
      "(A) Portland Timbers 2",
      "(A) Las Vegas Lights FC",
      "(A) LA Galaxy II",
      "(A) Tulsa Roughnecks",
      "(A) New Mexico United",
    ];
    return allMatches
        .where((m) =>
            leaguesWithHighOver2.contains("(H) ${m.homeTeam}") ||
            leaguesWithHighOver2.contains("(A) ${m.awayTeam}"))
        .toList();
  }

  static List<FootballMatch> _getBttsNoMatches(List<FootballMatch> allMatches) {
    final leaguesWithHighBttsNo = [
      "(H) Osasuna",
      "(H) Mamelodi Sundowns",
      "(H) Galatasaray",
      "(H) Internazionale",
      "(H) FC Xanthi",
      "(H) Rangers",
      "(A) Reus Deportiu",
      "(A) Panionios",
      "(A) Lamia",
      "(A) Levadiakos",
      "(A) NAC",
      "(A) St Mirren",
      "(A) St Johnstone",
      "(A) Loudoun United FC",
    ];
    return allMatches
        .where((m) =>
            leaguesWithHighBttsNo.contains("(H) ${m.homeTeam}") ||
            leaguesWithHighBttsNo.contains("(A) ${m.awayTeam}"))
        .toList();
  }

  static List<FootballMatch> _getBttsYesMatches(
      List<FootballMatch> allMatches) {
    final leaguesWithHighBttsYes = [
      "(H) Western Sydney FC",
      "(H) Brisbane Roar",
      "(H) Wellington Phoenix",
      "(H) Central Coast Mariners",
      "(H) Vitesse",
      "(H) SV Zulte Waregem",
      "(H) Kasimpasa",
      "(H) VfL Bochum",
      "(H) Gamba Osaka",
      "(H) Hartberg",
      "(H) LA Galaxy II",
      "(A) Brisbane Roar",
      "(A) Newcastle Jets",
      "(A) Western Sydney FC",
      "(A) Feyenoord",
      "(A) Emmen",
      "(A) Willem II",
      "(A) Holstein Kiel",
      "(A) Young Boys",
      "(A) Nagoya Grampus Eight",
      "(A) Shimizu S-Pulse",
    ];
    return allMatches
        .where((m) =>
            leaguesWithHighBttsYes.contains("(H) ${m.homeTeam}") ||
            leaguesWithHighBttsYes.contains("(A) ${m.awayTeam}"))
        .toList();
  }
}
