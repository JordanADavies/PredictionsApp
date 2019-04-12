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
      "(H) Lecce",
      "(H) Hannover 96",
      "(H) Galatasaray",
      "(H) Standard Liege",
      "(H) AZ",
      "(H) PAOK Salonika",
      "(H) Eupen",
      "(H) FC Groningen",
      "(H) Tigres UANL",
      "(H) Frosinone",
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
      "(A) Swansea City",
      "(A) Fulham",
      "(A) Newport County",
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
      "(A) Anderlecht",
      "(A) Empoli",
      "(A) Asteras Tripolis",
      "(A) Dijon FCO",
      "(A) Hibernian",
      "(A) Carpi",
      "(A) Hannover 96",
      "(A) 1. FC Nürnberg",
      "(A) Hamilton Academical",
      "(A) Motherwell",
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
      "(H) Grimsby Town",
      "(H) Blackburn",
      "(H) Chippa United",
      "(H) Vitoria Setubal",
      "(H) Grenoble",
      "(H) Reus Deportiu",
      "(H) Nice",
      "(H) Atletico Madrid",
      "(H) Levadiakos",
      "(H) Athletic Bilbao",
      "(H) Dijon FCO",
      "(H) Auxerre",
      "(H) Beziers AS",
      "(H) Cosenza",
      "(H) Cremonese",
      "(H) Salernitana",
      "(H) Panionios",
      "(H) Konyaspor",
      "(H) Colon Santa Fe",
      "(H) Columbus Crew",
      "(A) Maritimo",
      "(A) Belenenses",
      "(A) Tijuana",
      "(A) Desportivo Aves",
      "(A) Las Palmas",
      "(A) Sochaux",
      "(A) Derby County",
      "(A) Troyes",
      "(A) Numancia",
      "(A) Extremadura UD",
      "(A) Málaga",
      "(A) Lens",
      "(A) Nantes",
      "(A) Levadiakos",
      "(A) Dijon FCO",
      "(A) San Lorenzo",
      "(A) Kilmarnock",
      "(A) Gimnasia La Plata",
      "(A) Giannina",
    ];
    return allMatches
        .where((m) =>
            leaguesWithHighUnder3.contains("(H) ${m.homeTeam}") ||
            leaguesWithHighUnder3.contains("(A) ${m.awayTeam}"))
        .toList();
  }

  static List<FootballMatch> _getOver2Matches(List<FootballMatch> allMatches) {
    final leaguesWithHighOver2 = [
      "(H) Nottingham Forest",
      "(H) Highlands Park FC",
      "(H) Brisbane Roar",
      "(H) Leeds United",
      "(H) Walsall",
      "(H) Real Betis",
      "(H) FC Augsburg",
      "(H) Standard Liege",
      "(H) KSC Lokeren",
      "(H) Cercle Brugge",
      "(H) Caykur Rizespor",
      "(H) Feyenoord",
      "(H) Fortuna Düsseldorf",
      "(H) KV Kortrijk",
      "(H) Empoli",
      "(H) Olympiacos",
      "(H) FC Cologne",
      "(H) AC Horsens",
      "(H) Orlando City SC",
      "(H) San Jose Earthquakes",
      "(A) Walsall",
      "(A) Brighton and Hove Albion",
      "(A) Real Madrid",
      "(A) Rayo Vallecano",
      "(A) Swindon Town",
      "(A) Western Sydney FC",
      "(A) Stade Rennes",
      "(A) Eibar",
      "(A) Besiktas",
      "(A) Mainz",
      "(A) Wycombe Wanderers",
      "(A) Reading",
      "(A) Parma",
      "(A) Fortuna Sittard",
      "(A) Sampdoria",
      "(A) Necaxa",
      "(A) Hannover 96",
      "(A) Lecce",
      "(A) Emmen",
      "(A) Vitesse",
      "(A) Club Brugge",
      "(A) VfL Bochum",
      "(A) Thun",
      "(A) Portland Timbers",
      "(A) Minnesota United FC",
    ];
    return allMatches
        .where((m) =>
            leaguesWithHighOver2.contains("(H) ${m.homeTeam}") ||
            leaguesWithHighOver2.contains("(A) ${m.awayTeam}"))
        .toList();
  }

  static List<FootballMatch> _getBttsNoMatches(List<FootballMatch> allMatches) {
    final leaguesWithHighBttsNo = [
      "(H) Grimsby Town",
      "(H) Stoke City",
      "(H) Guadalajara",
      "(H) Osasuna",
      "(H) Leganes",
      "(H) Atletico Madrid",
      "(H) Asteras Tripolis",
      "(H) Auxerre",
      "(H) Galatasaray",
      "(H) Motherwell",
      "(H) Cremonese",
      "(H) Panionios",
      "(A) Maritimo",
      "(A) Atletico Madrid",
      "(A) Reus Deportiu",
      "(A) Lens",
      "(A) Levadiakos",
      "(A) Hamilton Academical",
      "(A) Juventus",
      "(A) Godoy Cruz",
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
      "(H) Macclesfield",
      "(H) Forest Green Rovers",
      "(H) Rotherham United",
      "(H) Morelia",
      "(H) Cordoba",
      "(H) Real Betis",
      "(H) Vitesse",
      "(H) AS Roma",
      "(H) VfB Stuttgart",
      "(H) Waasland-Beveren",
      "(H) SV Zulte Waregem",
      "(H) Banfield",
      "(H) SC Freiburg",
      "(H) Tigre",
      "(H) F.B.C Unione Venezia",
      "(H) Thun",
      "(A) Brisbane Roar",
      "(A) Real Madrid",
      "(A) Western Sydney FC",
      "(A) Besiktas",
      "(A) Genk",
      "(A) PSV",
      "(A) Necaxa",
      "(A) Lecce",
      "(A) Fiorentina",
      "(A) Thun",
      "(A) FC Luzern",
      "(A) Shimizu S-Pulse",
      "(A) Portland Timbers 2",
    ];
    return allMatches
        .where((m) =>
            leaguesWithHighBttsYes.contains("(H) ${m.homeTeam}") ||
            leaguesWithHighBttsYes.contains("(A) ${m.awayTeam}"))
        .toList();
  }
}
