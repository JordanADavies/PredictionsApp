import 'dart:async';

import 'package:meta/meta.dart';
import 'package:predictions/data/matches_bloc.dart';
import 'package:predictions/data/model/football_match.dart';
import 'package:predictions/prediction_tracking/unders_prediction.dart';

class PredictionTracking {
  final List<FootballMatch> matches;
  final double percentageCorrect;
  final List<FootballMatch> correctlyPredictedMatches;

  PredictionTracking(
      this.matches, this.percentageCorrect, this.correctlyPredictedMatches);
}

class PredictionTrackingBloc {
  final MatchesBloc matchesBloc;

  StreamController<PredictionTracking> _trackedMatches = StreamController();

  PredictionTrackingBloc({@required this.matchesBloc}) {
    matchesBloc.allMatches
        .listen((allMatches) => _fetchTrackedMatches(allMatches));
  }

  Stream<PredictionTracking> get trackedMatches => _trackedMatches.stream;

  void dispose() {
    _trackedMatches.close();
  }

  void _fetchTrackedMatches(List<FootballMatch> allMatches) {
    final prediction = UndersPrediction(allMatches);
    final percentage = prediction.predictedCorrectlyMatches.length /
        prediction.predictedAndFinishedMatches.length *
        100;

    final tracking = PredictionTracking(prediction.predictedMatches, percentage,
        prediction.predictedCorrectlyMatches);
    _trackedMatches.add(tracking);
  }
}
