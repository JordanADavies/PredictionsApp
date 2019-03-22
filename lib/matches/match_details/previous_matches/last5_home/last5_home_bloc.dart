import 'dart:async';

import 'package:meta/meta.dart';
import 'package:predictions/data/matches_bloc.dart';
import 'package:predictions/data/model/football_match.dart';
import 'package:predictions/prediction_tracking/match_finder.dart';

class Last5HomeBloc {
  final MatchesBloc matchesBloc;
  final FootballMatch match;

  StreamController<List<FootballMatch>> _homeMatches = StreamController();

  Last5HomeBloc({@required this.matchesBloc, @required this.match}) {
    matchesBloc.allMatches.listen(_fetchLast5Matches);
  }

  Stream<List<FootballMatch>> get homeMatches => _homeMatches.stream;

  void dispose() {
    _homeMatches.close();
  }

  void _fetchLast5Matches(List<FootballMatch> allMatches) {
    final matchFinder = MatchFinder(allMatches: allMatches);
    final homeMatches =
        matchFinder.findLastMatchesForHomeTeam(5, match).reversed.toList();
    _homeMatches.add(homeMatches);
  }
}
