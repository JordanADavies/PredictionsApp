import 'dart:async';

import 'package:meta/meta.dart';
import 'package:predictions/data/matches_bloc.dart';
import 'package:predictions/data/model/football_match.dart';
import 'package:predictions/matches/match_details/previous_matches/match_finder.dart';

class Last5HomeBloc {
  final MatchesBloc matchesBloc;
  final FootballMatch match;

  StreamController<List<FootballMatch>> _homeMatches = StreamController();

  Last5HomeBloc({@required this.matchesBloc, @required this.match}) {
    matchesBloc.matches.listen(_fetchLast5Matches);
  }

  Stream<List<FootballMatch>> get homeMatches => _homeMatches.stream;

  void dispose() {
    _homeMatches.close();
  }

  void _fetchLast5Matches(Matches matches) {
    final matchFinder = MatchFinder(allMatches: matches.allMatches);
    final homeMatches =
        matchFinder.findLastMatchesForHomeTeam(5, match).reversed.toList();
    _homeMatches.add(homeMatches);
  }
}
