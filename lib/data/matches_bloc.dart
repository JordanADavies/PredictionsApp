import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';
import 'package:meta/meta.dart';
import 'package:predictions/data/api/matches_api.dart';
import 'package:predictions/data/model/football_match.dart';
import 'package:predictions/matches/predictions/high_percent_checker.dart';
import 'package:predictions/matches/predictions/over_2_checker.dart';
import 'package:predictions/matches/predictions/under_3_checker.dart';
import 'package:predictions/matches/predictions/win_lose_draw_checker.dart';
import 'package:rxdart/subjects.dart';

class Matches {
  final List<FootballMatch> allMatches;
  final List<FootballMatch> thisSeasonsMatches;
  final Map<String, Map<String, List<FootballMatch>>> groupedMatches;

  final List<FootballMatch> winLoseDrawMatches;
  final List<FootballMatch> highPercentChanceMatches;
  final List<FootballMatch> under3Matches;
  final List<FootballMatch> over2Matches;

  Matches({
    @required this.allMatches,
    @required this.thisSeasonsMatches,
    @required this.groupedMatches,
    @required this.winLoseDrawMatches,
    @required this.highPercentChanceMatches,
    @required this.under3Matches,
    @required this.over2Matches,
  });
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
      highPercentChanceMatches: _getHighPercentChanceMatches(thisSeasonsMatches),
      under3Matches: _getUnder3Matches(thisSeasonsMatches),
      over2Matches: _getOver2Matches(thisSeasonsMatches),
    );
  }

  static bool _isThisSeason(FootballMatch match) {
    final dateSplitString = match.date.split("-");
    return dateSplitString[0] == "2019" ||
        (dateSplitString[0] == "2018" && double.parse(dateSplitString[1]) >= 8);
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

  static List<FootballMatch> _getHighPercentChanceMatches(
      List<FootballMatch> allMatches) {
    return allMatches.where((m) {
      final checker = HighPercentChecker(match: m);
      return checker.getPredictionIncludingPerformance() !=
          HighPercentResult.Unknown;
    }).toList();
  }

  static List<FootballMatch> _getUnder3Matches(List<FootballMatch> allMatches) {
    return allMatches.where((m) {
      final checker = Under3Checker(match: m);
      return checker.getPredictionIncludingPerformance();
    }).toList();
  }

  static List<FootballMatch> _getOver2Matches(List<FootballMatch> allMatches) {
    return allMatches.where((m) {
      final checker = Over2Checker(match: m);
      return checker.getPredictionIncludingPerformance();
    }).toList();
  }
}
