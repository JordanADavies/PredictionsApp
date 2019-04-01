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
    return dateSplitString[0] == "2019" ||
        (dateSplitString[0] == "2018" && double.parse(dateSplitString[1]) > 7);
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
      "Shandong Luneng",
      "Shanghai SIPG",
      "Zenit St Petersburg",
      "Brommapojkarna",
      "Celtic",
      "Grêmio",
      "Richmond Kickers",
      "Pachuca",
      "Saint Louis FC",
      "Cruz Azul",
      "Young Boys",
      "Kristiansund BK",
      "Portland Timbers 2",
      "New York Red Bulls",
      "Dalkurd FF",
      "Benfica",
      "Watford",
      "Norwich City",
      "FC Salzburg",
      "Ajax",
      "St Etienne",
      "PSV",
      "FC Porto",
      "Columbus Crew",
      "Liverpool",
      "Östersunds FK",
      "BK Hacken",
      "Boca Juniors",
      "FC Copenhagen",
      "Arsenal",
      "FC Midtjylland",
      "Paris Saint-Germain",
      "Braga",
      "Palmeiras",
      "Toronto FC II",
      "DC United",
      "Seattle Sounders FC",
      "Haugesund",
      "Tottenham Hotspur",
      "Boavista",
      "Sporting CP",
      "Barcelona",
      "Portland Thorns",
      "Guangzhou Evergrande",
      "Manchester City",
      "Internacional",
      "Atlético Paranaense",
      "Galatasaray",
      "Racing Club",
      "Getafe",
      "CA Independiente",
      "Juventus",
      "PAOK Salonika",
      "Atletico Madrid",
      "AEK Athens",
      "Borussia Dortmund",
      "Espanyol",
      "Osasuna",
      "Olympiacos",
      "Hannover 96",
      "Panathinaikos",
      "Lecce",
      "FC Astana",
      "BATE Borisov",
      "Central Coast Mariners",
      "Wuhan Zall",
      "Shenzhen FC",
      "Matsumoto Yamaga FC",
      "Austin Bold FC",
    ];
    return allMatches
        .where((m) => teamsWithHighWinLoseDraw.contains(m.homeTeam))
        .toList();
  }

  static List<FootballMatch> _getUnder3Matches(List<FootballMatch> allMatches) {
    final leaguesWithHighUnder3 = [
      "Pittsburgh Riverhounds",
      "Beziers AS",
      "Metz",
      "Niort",
      "Troyes",
      "Ottawa Fury FC",
      "Sunderland",
      "Mamelodi Sundowns",
      "Zenit St Petersburg",
      "Swindon Town",
      "Mansfield Town",
      "Kalmar FF",
      "Celtic",
      "Kilmarnock",
      "Black Aces",
      "Colorado Springs Switchbacks FC",
      "Sagan Tosu",
      "FC Tokyo",
      "Terek Grozny",
      "Paraná",
      "Seattle Reign FC",
      "Polokwane City FC",
      "Middlesbrough",
      "Free State Stars",
      "Baroka FC",
      "Utah Royals FC",
      "Grenoble",
      "Benfica",
      "Nashville SC",
      "Metallurg Krasnoyarsk",
      "Stoke City",
      "Vitoria Setubal",
      "Spartak Moscow",
      "Derby County",
      "Rostov",
      "Gazovik Orenburg",
      "AaB",
      "Bordeaux",
      "AIK",
      "Konyaspor",
      "Rosario Central",
      "Rubin Kazan",
      "Anzhi Makhachkala",
      "Cadiz",
      "Talleres de Córdoba",
      "Boavista",
      "Amiens",
      "Banfield",
      "Santos",
      "Internacional",
      "Colon Santa Fe",
      "Mallorca",
      "Real Oviedo",
      "Alanyaspor",
      "Las Palmas",
      "Washington Spirit",
      "Getafe",
      "F.B.C Unione Venezia",
      "Reus Deportiu",
      "Apollon Smyrni",
      "FC Xanthi",
      "Panionios",
      "Sporting Gijón",
      "Granada",
      "Ascoli",
      "AEK Larnaca",
      "Ludogorets",
      "Giannina",
    ];
    return allMatches
        .where((m) => leaguesWithHighUnder3.contains(m.homeTeam))
        .toList();
  }

  static List<FootballMatch> _getOver2Matches(List<FootballMatch> allMatches) {
    final leaguesWithHighOver2 = [
      "Changchun Yatai",
      "Jubilo Iwata",
      "Shandong Luneng",
      "Yokohama F. Marinos",
      "Shanghai SIPG",
      "Orange County SC",
      "Tianjin Teda",
      "Auxerre",
      "New York Red Bulls II",
      "VfL Bochum",
      "Guizhou Renhe",
      "Barnsley",
      "Walsall",
      "Exeter City",
      "Vejle",
      "Cercle Brugge",
      "North Carolina FC",
      "Richmond Kickers",
      "Minnesota United FC",
      "New York City FC",
      "San Antonio FC",
      "Colorado Rapids",
      "Nagoya Grampus Eight",
      "AC Horsens",
      "1. FC Union Berlin",
      "1. FC Heidenheim 1846",
      "St Gallen",
      "LASK Linz",
      "Kristiansund BK",
      "Santos Laguna",
      "Houston Dash",
      "GIF Sundsvall",
      "Tampa Bay Rowdies",
      "Charlotte Independence",
      "Gamba Osaka",
      "IFK Goteborg",
      "Ankaragucu",
      "Chicago Red Stars",
      "Newcastle",
      "Clermont Foot",
      "Arminia Bielefeld",
      "Gillingham",
      "Hobro IK",
      "Huddersfield Town",
      "Colchester United",
      "Rotherham United",
      "Watford",
      "Fulham",
      "Sheffield Wednesday",
      "Morecambe",
      "Ajax",
      "Caykur Rizespor",
      "St. Truidense",
      "Lille",
      "Nice",
      "PSV",
      "FC Porto",
      "New England Revolution",
      "Oklahoma City Energy FC",
      "Los Angeles Galaxy",
      "Southampton",
      "Östersunds FK",
      "BK Hacken",
      "Bordeaux",
      "Randers FC",
      "Rosenborg",
      "Konyaspor",
      "FC Midtjylland",
      "Toronto FC",
      "Bethlehem Steel FC",
      "FC Cologne",
      "Shanghai Greenland",
      "Anzhi Makhachkala",
      "Lorient",
      "Real Betis",
      "Cardiff City",
      "Leicester City",
      "Malmo FF",
      "Guingamp",
      "Chievo Verona",
      "Dijon FCO",
      "Caen",
      "Stade Rennes",
      "Amiens",
      "Fortuna Sittard",
      "Yeni Malatyaspor",
      "Philadelphia Union",
      "Vancouver Whitecaps",
      "San Jose Earthquakes",
      "Portland Thorns",
      "Feyenoord",
      "Burnley",
      "Manchester City",
      "SK Sturm Graz",
      "C.D. Nacional",
      "Eibar",
      "Akhisar Belediye",
      "Mallorca",
      "Rayo Vallecano",
      "Parma",
      "Nimes",
      "Kasimpasa",
      "Málaga",
      "Leganes",
      "Fortuna Düsseldorf",
      "Panetolikos",
      "Napoli",
      "Mainz",
      "Granada",
      "Genoa",
      "Foggia",
      "Sevilla FC",
      "Levante",
      "AS Roma",
      "Benevento",
      "AC Milan",
      "Sampdoria",
      "Crotone",
      "Red Star Belgrade",
      "Shakhtar Donetsk",
      "Viktoria Plzen",
      "FK Qarabag",
      "Adelaide United",
      "Brisbane Roar",
      "New Mexico United",
    ];
    return allMatches
        .where((m) => leaguesWithHighOver2.contains(m.homeTeam))
        .toList();
  }

  static List<FootballMatch> _getBttsNoMatches(List<FootballMatch> allMatches) {
    final leaguesWithHighBttsNo = [
      "Orange County SC",
      "Pittsburgh Riverhounds",
      "Kalmar FF",
      "Hamilton Academical",
      "Rapid Vienna",
      "LASK Linz",
      "América Mineiro",
      "New York Red Bulls",
      "Seattle Reign FC",
      "Ceará",
      "Tampa Bay Rowdies",
      "Utah Royals FC",
      "Nashville SC",
      "Dundee",
      "Milton Keynes Dons",
      "Bahía",
      "Charleston Battery",
      "Arizona United",
      "BK Hacken",
      "Rangers",
      "Seattle Sounders FC",
      "Cadiz",
      "Real Betis",
      "Malmo FF",
      "AD Alcorcon",
      "Barcelona",
      "Atletico Madrid",
      "AEK Athens",
      "FC Xanthi",
      "Osasuna",
      "Internazionale",
      "Eintracht Frankfurt",
      "Ludogorets",
    ];
    return allMatches
        .where((m) => leaguesWithHighBttsNo.contains(m.homeTeam))
        .toList();
  }

  static List<FootballMatch> _getBttsYesMatches(
      List<FootballMatch> allMatches) {
    final leaguesWithHighBttsYes = [
      "Vegalta Sendai",
      "Jubilo Iwata",
      "Yokohama F. Marinos",
      "Shanghai SIPG",
      "Orange County SC",
      "LA Galaxy II",
      "Tianjin Teda",
      "New York Red Bulls II",
      "VfL Bochum",
      "Sunderland",
      "West Bromwich Albion",
      "Walsall",
      "Swindon Town",
      "Notts County",
      "Celtic",
      "Eupen",
      "Ranheim",
      "Basel",
      "KAA Gent",
      "North Carolina FC",
      "Minnesota United FC",
      "San Antonio FC",
      "Colorado Rapids",
      "Nagoya Grampus Eight",
      "Sanfrecce Hiroshima",
      "1. FC Magdeburg",
      "Hebei China Fortune FC",
      "AC Horsens",
      "SV Darmstadt 98",
      "1. FC Heidenheim 1846",
      "FC Sion",
      "Hartberg",
      "Wolfsberger AC",
      "Stromsgodset",
      "Charlotte Independence",
      "Tulsa Roughnecks",
      "Gamba Osaka",
      "FC Ingolstadt 04",
      "SC Paderborn",
      "Sandefjord",
      "Dalkurd FF",
      "PEC Zwolle",
      "Marseille",
      "Vissel Kobe",
      "Gillingham",
      "AFC Bournemouth",
      "Plymouth Argyle",
      "Forest Green Rovers",
      "Luton Town",
      "Tranmere Rovers",
      "Rochdale",
      "Standard Liege",
      "Ajax",
      "Willem II",
      "FC Lugano",
      "Neuchatel Xamax",
      "St Etienne",
      "Fenerbahce",
      "Los Angeles Galaxy",
      "Vitesse",
      "FC Copenhagen",
      "Odd BK",
      "Goztepe",
      "Toronto FC",
      "Trelleborgs FF",
      "Shanghai Greenland",
      "IK Sirius",
      "Trabzonspor",
      "Tottenham Hotspur",
      "NAC",
      "Chelsea",
      "AS Monaco",
      "Yeni Malatyaspor",
      "Cordoba",
      "Barcelona",
      "FC Nordsjaelland",
      "FC Utrecht",
      "Manchester City",
      "Heerenveen",
      "Akhisar Belediye",
      "Galatasaray",
      "Atalanta",
      "Kasimpasa",
      "VfL Wolfsburg",
      "Werder Bremen",
      "Atletico Madrid",
      "Thun",
      "Borussia Dortmund",
      "Internazionale",
      "VfB Stuttgart",
      "Viktoria Plzen",
      "Wellington Phoenix",
      "Brisbane Roar",
      "Central Coast Mariners",
      "Western Sydney FC",
    ];
    return allMatches
        .where((m) => leaguesWithHighBttsYes.contains(m.homeTeam))
        .toList();
  }
}
