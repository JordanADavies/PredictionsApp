import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:predictions/data/matches_bloc.dart';
import 'package:predictions/data/model/football_match.dart';

abstract class PredictionTrackingBloc {
  StreamController<List<FootballMatch>> _upcomingMatches = StreamController();

  void dispose() {
    _upcomingMatches.close();
  }

  Stream<List<FootballMatch>> get upcomingMatches => _upcomingMatches.stream;
}

class Under3PredictionTrackingBloc extends PredictionTrackingBloc {
  Under3PredictionTrackingBloc({MatchesBloc matchesBloc}) {
    matchesBloc.allMatches.listen(_fetchTrackedMatches);
  }

  Future _fetchTrackedMatches(List<FootballMatch> allMatches) async {
    final predictionMatchedMatches = await compute(_filterList, allMatches);
    _upcomingMatches.add(predictionMatchedMatches);
  }

  static List<FootballMatch> _filterList(List<FootballMatch> allMatches) {
    final finishedMatches = allMatches.where((m) => m.hasBeenPlayed()).toList();
    return allMatches
        .where((m) => !m.hasBeenPlayed() && _under2Predicted(m, finishedMatches))
        .toList();
  }

  static bool _under2Predicted(
      FootballMatch match, List<FootballMatch> finishedMatches) {
    final homeTeamsLastMatchGoals = _findGoalsInLastMatchForHomeTeam(
        match: match, finishedMatches: finishedMatches);
    final awayTeamsLastMatchGoals = _findGoalsInLastMatchForAwayTeam(
        match: match, finishedMatches: finishedMatches);

    return match.homeProjectedGoals + match.awayProjectedGoals < 2 &&
        homeTeamsLastMatchGoals < 2 &&
        awayTeamsLastMatchGoals < 2;
  }

  static int _findGoalsInLastMatchForHomeTeam(
      {FootballMatch match, List<FootballMatch> finishedMatches}) {
    final lastMatch = finishedMatches.lastWhere(
        (m) => m.homeTeam == match.homeTeam && m != match,
        orElse: () => null);

    return lastMatch == null
        ? 99
        : lastMatch.homeFinalScore + lastMatch.awayFinalScore;
  }

  static int _findGoalsInLastMatchForAwayTeam(
      {FootballMatch match, List<FootballMatch> finishedMatches}) {
    final lastMatch = finishedMatches.lastWhere(
        (m) => m.awayTeam == match.awayTeam && m != match,
        orElse: () => null);

    return lastMatch == null
        ? 99
        : lastMatch.homeFinalScore + lastMatch.awayFinalScore;
  }
}
