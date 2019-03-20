import 'dart:async';

import 'package:meta/meta.dart';
import 'package:predictions/data/matches_bloc.dart';
import 'package:predictions/data/model/football_match.dart';

class PredictionTrackingBloc {
  final MatchesBloc matchesBloc;

  StreamController<List<FootballMatch>> _trackedMatches = StreamController();

  PredictionTrackingBloc({@required this.matchesBloc}) {
    matchesBloc.allMatches.listen(_fetchTrackedMatches);
  }

  Stream<List<FootballMatch>> get trackedMatches => _trackedMatches.stream;

  void dispose() {
    _trackedMatches.close();
  }

  void _fetchTrackedMatches(List<FootballMatch> allMatches) {
    final predictionMatchedMatches = _filterList(allMatches);
    _trackedMatches.add(predictionMatchedMatches);
  }

  List<FootballMatch> _filterList(
      List<FootballMatch> allMatches) {
    final filteredList = List<FootballMatch>();
    for (int i = 0; i < allMatches.length; i++) {
      final match = allMatches[i];
      if (!match.hasBeenPlayed() &&
          _under2Predicted(match, allMatches)) {
        filteredList.add(match);
      }
    }

    return filteredList;
  }

  bool _under2Predicted(
      FootballMatch match, List<FootballMatch> allMatches) {
    final homeTeamsLastMatchGoals =
        _findGoalsInLastMatchForHomeTeam(match: match, allMatches: allMatches);
    final awayTeamsLastMatchGoals =
        _findGoalsInLastMatchForAwayTeam(match: match, allMatches: allMatches);

    return match.homeProjectedGoals + match.awayProjectedGoals < 2 &&
        homeTeamsLastMatchGoals < 2 &&
        awayTeamsLastMatchGoals < 2;
  }

  int _findGoalsInLastMatchForHomeTeam(
      {FootballMatch match, List<FootballMatch> allMatches}) {
    final lastMatches = allMatches
        .where((m) =>
            m != match && m.hasBeenPlayed() && m.homeTeam == match.homeTeam)
        .toList();

    if (lastMatches.isEmpty) {
      return 99;
    }

    return lastMatches.last.homeFinalScore + lastMatches.last.awayFinalScore;
  }

  int _findGoalsInLastMatchForAwayTeam(
      {FootballMatch match, List<FootballMatch> allMatches}) {
    final lastMatches = allMatches
        .where((m) =>
            m != match && m.hasBeenPlayed() && m.awayTeam == match.awayTeam)
        .toList();

    if (lastMatches.isEmpty) {
      return 99;
    }

    return lastMatches.last.homeFinalScore + lastMatches.last.awayFinalScore;
  }
}
