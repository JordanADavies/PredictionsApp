import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';
import 'package:meta/meta.dart';
import 'package:predictions/data/api/matches_api.dart';
import 'package:predictions/data/leagues.dart';
import 'package:predictions/data/model/football_match.dart';
import 'package:rxdart/subjects.dart';

class Matches {
  final List<FootballMatch> allMatches;
  final Map<String, Map<String, List<FootballMatch>>> groupedMatches;

  final List<FootballMatch> winLoseDrawMatches;
  final List<FootballMatch> under3Matches;
  final List<FootballMatch> over2Matches;
  final List<FootballMatch> bttsNoMatches;
  final List<FootballMatch> bttsYesMatches;

  Matches(
      {@required this.allMatches,
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
      allMatches: thisSeasonsMatches,
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

  static List<FootballMatch> _getWinLoseDrawMatches(List<FootballMatch> allMatches) {
    final leaguesWithHighWinLoseDraw = [
      CHINESE_SUPER_LEAGUE,
      SCOTTISH_PREMIERSHIP,
      MAJOR_LEAGUE_SOCCER,
      NATIONAL_WOMENS_SOCCER_LEAGUE,
      BARCLAYS_PREMIER_LEAGUE,
      PORTUGUESE_LIGA,
      ITALY_SERIE_A,
      GREEK_SUPER_LEAGUE,
      UEFA_CHAMPIONS_LEAGUE,
      MEXICAN_PRIMERA_DIVISION_TORNEO_CLAUSURA,
    ];
    return allMatches
        .where((m) => leaguesWithHighWinLoseDraw.contains(m.leagueId))
        .toList();
  }

  static List<FootballMatch> _getUnder3Matches(List<FootballMatch> allMatches) {
    final leaguesWithHighUnder3 = [
      JAPANESE_J_LEAGUE,
      UNITED_SOCCER_LEAGUE,
      RUSSIAN_PREMIER_LEAGUE,
      ENGLISH_LEAGUE_CHAMPIONSHIP,
      SOUTH_AFRICA_ABSA_PREMIER_LEAGUE,
      NATIONAL_WOMENS_SOCCER_LEAGUE,
      ITALY_SERIE_B,
      GREEK_SUPER_LEAGUE,
      UEFA_EUROPA_LEAGUE,
    ];

    return allMatches
        .where((m) => leaguesWithHighUnder3.contains(m.leagueId))
        .toList();
  }

  static List<FootballMatch> _getOver2Matches(List<FootballMatch> allMatches) {
    final leaguesWithHighOver2 = [
      CHINESE_SUPER_LEAGUE,
      UNITED_SOCCER_LEAGUE,
      GERMAN_2_BUNDESLIGA,
      MAJOR_LEAGUE_SOCCER,
      NATIONAL_WOMENS_SOCCER_LEAGUE,
      DUTCH_EREDIVISIE,
      FRENCH_LIGUE_1,
      TURKISH_TURKCELL_SUPER_LIG,
      BARCLAYS_PREMIER_LEAGUE,
      PORTUGUESE_LIGA,
      ITALY_SERIE_A,
      UEFA_CHAMPIONS_LEAGUE,
      AUSTRALIAN_A_LEAGUE,
    ];
    return allMatches
        .where((m) => leaguesWithHighOver2.contains(m.leagueId))
        .toList();
  }

  static List<FootballMatch> _getBttsNoMatches(List<FootballMatch> allMatches) {
    final leaguesWithHighBttsNo = [
      UNITED_SOCCER_LEAGUE,
      SOUTH_AFRICA_ABSA_PREMIER_LEAGUE,
      ENGLISH_LEAGUE_TWO,
      SCOTTISH_PREMIERSHIP,
      MAJOR_LEAGUE_SOCCER,
      NATIONAL_WOMENS_SOCCER_LEAGUE,
      FRENCH_LIGUE_1,
      TURKISH_TURKCELL_SUPER_LIG,
      SPANISH_SEGUNDA_DIVISION,
      SPANISH_PRIMERA_DIVISION,
      GREEK_SUPER_LEAGUE,
      UEFA_CHAMPIONS_LEAGUE,
    ];
    return allMatches
        .where((m) => leaguesWithHighBttsNo.contains(m.leagueId))
        .toList();
  }

  static List<FootballMatch> _getBttsYesMatches(List<FootballMatch> allMatches) {
    final leaguesWithHighBttsYes = [
      JAPANESE_J_LEAGUE,
      CHINESE_SUPER_LEAGUE,
      UNITED_SOCCER_LEAGUE,
      AUSTRIAN_T_MOBILE_BUNDESLIGA,
      SWISS_RAIFFEISEN_SUPER_LEAGUE,
      MAJOR_LEAGUE_SOCCER,
      DUTCH_EREDIVISIE,
      FRENCH_LIGUE_1,
      TURKISH_TURKCELL_SUPER_LIG,
      SPANISH_SEGUNDA_DIVISION,
      GERMAN_BUNDESLIGA,
      UEFA_CHAMPIONS_LEAGUE,
      AUSTRALIAN_A_LEAGUE,
    ];
    return allMatches
        .where((m) => leaguesWithHighBttsYes.contains(m.leagueId))
        .toList();
  }
}
