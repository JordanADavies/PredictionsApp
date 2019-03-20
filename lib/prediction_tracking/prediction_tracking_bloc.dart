import 'dart:async';

import 'package:meta/meta.dart';
import 'package:predictions/data/matches_bloc.dart';
import 'package:predictions/data/model/football_match.dart';

class FilterType {
  static const WinLoseDraw = "1X2";
  static const Under3 = "u2.5";
  static const Under2 = "u1.5";
  static const BttsYes = "BTTS Yes";
  static const BttsNo = "BTTS No";

  static List<String> get values => [WinLoseDraw, Under3, Under2, BttsYes, BttsNo];
}

class PredictionTrackingBloc {
  final MatchesBloc matchesBloc;

  StreamController<String> _trackingType = StreamController();

  StreamController<List<FootballMatch>> _trackedMatches = StreamController();

  StreamController<String> _trackedTotals = StreamController();

  PredictionTrackingBloc({@required this.matchesBloc}) {
    matchesBloc.allMatches.listen((allMatches) =>
        _fetchTrackedMatches(allMatches, FilterType.WinLoseDraw));
    _trackingType.stream.listen(
        (filter) => _fetchTrackedMatches(matchesBloc.allMatches.value, filter));
  }

  Sink<String> get trackingType => _trackingType.sink;

  Stream<List<FootballMatch>> get trackedMatches => _trackedMatches.stream;

  Stream<String> get trackedTotals => _trackedTotals.stream;

  void dispose() {
    _trackingType.close();
    _trackedMatches.close();
    _trackedTotals.close();
  }

  void _fetchTrackedMatches(List<FootballMatch> allMatches, String filter) {
    if (filter == FilterType.WinLoseDraw) {
      final filteredMatches = allMatches.where(_winLoseDrawPredictedCorrectly).toList();
      _trackedMatches.add(filteredMatches);

      final percentage = filteredMatches.length/allMatches.length*100;
      _trackedTotals.add("${percentage.toStringAsFixed(2)}% correct");
    }

    if (filter == FilterType.Under3) {
      final filteredMatches = allMatches.where(_under3PredictedCorrectly).toList();
      _trackedMatches.add(filteredMatches);

      final allUnder3Matches = allMatches.where(_under3Predicted).toList();
      final percentage = filteredMatches.length/allUnder3Matches.length*100;
      _trackedTotals.add("${percentage.toStringAsFixed(2)}% correct");
    }

    if (filter == FilterType.Under2) {
      final filteredMatches = allMatches.where(_under2PredictedCorrectly).toList();
      _trackedMatches.add(filteredMatches);

      final allUnder2Matches = allMatches.where(_under2Predicted).toList();
      final percentage = filteredMatches.length/allUnder2Matches.length*100;
      _trackedTotals.add("${percentage.toStringAsFixed(2)}% correct");
    }
    
    if (filter == FilterType.BttsYes) {
      final filteredMatches = allMatches.where(_bttsYesPredictedCorrectly).toList();
      _trackedMatches.add(filteredMatches);

      final allBttsYesMatches = allMatches.where(_bttsYesPredicted).toList();
      final percentage = filteredMatches.length/allBttsYesMatches.length*100;
      _trackedTotals.add("${percentage.toStringAsFixed(2)}% correct");
    }

    if (filter == FilterType.BttsNo) {
      final filteredMatches = allMatches.where(_bttsNoPredictedCorrectly).toList();
      _trackedMatches.add(filteredMatches);

      final allBttsNoMatches = allMatches.where(_bttsNoPredicted).toList();
      final percentage = filteredMatches.length/allBttsNoMatches.length*100;
      _trackedTotals.add("${percentage.toStringAsFixed(2)}% correct");
    }
  }

  bool _winLoseDrawPredictedCorrectly(FootballMatch match) {
    if (!match.hasBeenPlayed()) {
      return false;
    }

    if (match.homeWinProbability > match.awayWinProbability &&
        match.homeWinProbability > match.drawProbability &&
        match.homeFinalScore > match.awayFinalScore) {
      return true;
    }

    if (match.awayWinProbability > match.homeWinProbability &&
        match.awayWinProbability > match.drawProbability &&
        match.awayFinalScore > match.homeFinalScore) {
      return true;
    }

    if (match.drawProbability > match.homeWinProbability &&
        match.drawProbability > match.awayWinProbability &&
        match.homeFinalScore == match.awayFinalScore) {
      return true;
    }

    return false;
  }

  bool _under3Predicted(FootballMatch match) {
    if (!match.hasBeenPlayed()) {
      return false;
    }

    return (match.homeProjectedGoals + match.awayProjectedGoals) < 3;
  }

  bool _under3PredictedCorrectly(FootballMatch match) {
    return _under3Predicted(match) && ((match.homeFinalScore + match.awayFinalScore) < 3);
  }

  bool _under2Predicted(FootballMatch match) {
    if (!match.hasBeenPlayed()) {
      return false;
    }

    return (match.homeProjectedGoals + match.awayProjectedGoals) < 2;
  }

  bool _under2PredictedCorrectly(FootballMatch match) {
    return _under2Predicted(match) && ((match.homeFinalScore + match.awayFinalScore) < 2);
  }
  
  bool _bttsYesPredicted(FootballMatch match) {
    if (!match.hasBeenPlayed()) {
      return false;
    }
    
    return match.homeProjectedGoals > 1 && match.awayProjectedGoals > 1;
  }

  bool _bttsYesPredictedCorrectly(FootballMatch match) {
    return _bttsYesPredicted(match) && match.homeFinalScore >= 1 && match.awayFinalScore >= 1;
  }

  bool _bttsNoPredicted(FootballMatch match) {
    if (!match.hasBeenPlayed()) {
      return false;
    }

    return match.homeProjectedGoals < 1 || match.awayProjectedGoals < 1;
  }

  bool _bttsNoPredictedCorrectly(FootballMatch match) {
    return _bttsNoPredicted(match) && (match.homeFinalScore < 1 || match.awayFinalScore < 1);
  }
}
