import 'dart:async';

import 'package:meta/meta.dart';
import 'package:predictions/data/matches_bloc.dart';
import 'package:predictions/data/model/football_match.dart';

class PredictionTrackingBloc {
  final MatchesBloc matchesBloc;

  StreamController<List<FootballMatch>> _trackedMatches = StreamController();

  StreamController<String> _trackedTotals = StreamController();

  PredictionTrackingBloc({@required this.matchesBloc}) {
    matchesBloc.allMatches.listen(_fetchTrackedMatches);
  }

  Stream<List<FootballMatch>> get trackedMatches => _trackedMatches.stream;

  Stream<String> get trackedTotals => _trackedTotals.stream;

  void dispose() {
    _trackedMatches.close();
    _trackedTotals.close();
  }

  void _fetchTrackedMatches(List<FootballMatch> allMatches) {
    _trackedMatches.add(allMatches);
    _trackedTotals.add("${allMatches.length} matches");
  }
}