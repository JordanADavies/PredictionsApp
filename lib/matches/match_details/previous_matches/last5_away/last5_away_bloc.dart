import 'dart:async';

import 'package:meta/meta.dart';
import 'package:predictions/data/matches_bloc.dart';
import 'package:predictions/data/model/football_match.dart';
import 'package:predictions/prediction_tracking/match_finder.dart';

class Last5AwayBloc {
  final MatchesBloc matchesBloc;
  final FootballMatch match;

  StreamController<List<FootballMatch>> _awayMatches = StreamController();

  Last5AwayBloc({@required this.matchesBloc, @required this.match}) {
    matchesBloc.allMatches.listen(_fetchLast5Matches);
  }

  Stream<List<FootballMatch>> get awayMatches => _awayMatches.stream;

  void dispose() {
    _awayMatches.close();
  }

  void _fetchLast5Matches(List<FootballMatch> allMatches) {
    final matchFinder = MatchFinder(allMatches: allMatches);
    final awayMatches =
        matchFinder.findLastAwayMatchesForAwayTeam(5, match).reversed.toList();
    _awayMatches.add(awayMatches);
  }
}
