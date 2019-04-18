import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';
import 'package:meta/meta.dart';
import 'package:predictions/data/api/matches_api.dart';
import 'package:predictions/data/leagues.dart';
import 'package:predictions/data/model/football_match.dart';
import 'package:predictions/matches/predictions/btts_no_checker.dart';
import 'package:predictions/matches/predictions/btts_yes_checker.dart';
import 'package:predictions/matches/predictions/over_2_checker.dart';
import 'package:predictions/matches/predictions/under_3_checker.dart';
import 'package:predictions/matches/predictions/win_lose_draw_checker.dart';
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
    return allMatches.where((m) {
      final checker = WinLoseDrawChecker(match: m);
      return checker.getPredictionIncludingPerformance() !=
          WinLoseDrawResult.Unknown;
    }).toList();
  }

  static List<FootballMatch> _getUnder3Matches(List<FootballMatch> allMatches) {
    final leagues = [
      AUSTRALIAN_A_LEAGUE,
      PORTUGUESE_LIGA,
      SPANISH_SEGUNDA_DIVISION,
      FRENCH_LIGUE_1,
      ITALY_SERIE_B,
      SWISS_RAIFFEISEN_SUPER_LEAGUE,
      JAPANESE_J_LEAGUE,
      SWEDISH_ALLSVENSKAN,
    ];

    return allMatches.where((m) {
      final checker = Under3Checker(match: m);
      return checker.getPrediction() && leagues.contains(m.leagueId);
    }).toList();
  }

  static List<FootballMatch> _getOver2Matches(List<FootballMatch> allMatches) {
    final leagues = [
      AUSTRALIAN_A_LEAGUE,
      FRENCH_LIGUE_1,
      GREEK_SUPER_LEAGUE,
      BELGIAN_JUPILER_LEAGUE,
      ARGENTINA_PRIMERA_DIVISION,
      UNITED_SOCCER_LEAGUE,
      NORWEGIAN_TIPPELIGAEN,
    ];

    return allMatches.where((m) {
      final checker = Over2Checker(match: m);
      return checker.getPrediction() && leagues.contains(m.leagueId);
    }).toList();
  }

  static List<FootballMatch> _getBttsNoMatches(List<FootballMatch> allMatches) {
    final leagues = [
      MEXICAN_PRIMERA_DIVISION_TORNEO_CLAUSURA,
      SCOTTISH_PREMIERSHIP,
      UEFA_CHAMPIONS_LEAGUE,
      AUSTRIAN_T_MOBILE_BUNDESLIGA,
      NATIONAL_WOMENS_SOCCER_LEAGUE,
    ];
    return allMatches.where((m) {
      final checker = BttsNoChecker(match: m);
      return checker.getPrediction() && leagues.contains(m.leagueId);
    }).toList();
  }

  static List<FootballMatch> _getBttsYesMatches(
      List<FootballMatch> allMatches) {
    final leagues = [
      AUSTRALIAN_A_LEAGUE,
      GERMAN_BUNDESLIGA,
      BELGIAN_JUPILER_LEAGUE,
      DANISH_SAS_LIGAEN,
      UEFA_CHAMPIONS_LEAGUE,
      UNITED_SOCCER_LEAGUE,
    ];
    return allMatches.where((m) {
      final checker = BttsYesChecker(match: m);
      return checker.getPrediction() && leagues.contains(m.leagueId);
    }).toList();
  }
}
