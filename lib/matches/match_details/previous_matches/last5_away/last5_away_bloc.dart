import 'dart:async';

import 'package:meta/meta.dart';
import 'package:predictions/data/matches_bloc.dart';
import 'package:predictions/data/model/football_match.dart';
import 'package:predictions/matches/match_details/previous_matches/match_finder.dart';

class Last5AwayBloc {
  final MatchesBloc matchesBloc;
  final FootballMatch match;

  StreamController<List<FootballMatch>> _awayMatches = StreamController();

  Last5AwayBloc({@required this.matchesBloc, @required this.match}) {
    matchesBloc.matches.listen(_fetchLast5Matches);
  }

  Stream<List<FootballMatch>> get awayMatches => _awayMatches.stream;

  void dispose() {
    _awayMatches.close();
  }

  void _fetchLast5Matches(Matches matches) {
    final matchFinder = MatchFinder(allMatches: matches.allMatches);
    final awayMatches =
        matchFinder.findLastMatchesForAwayTeam(5, match).reversed.toList();
    _awayMatches.add(awayMatches);
  }
}
