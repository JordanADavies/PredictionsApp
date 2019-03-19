import 'dart:async';

import 'package:meta/meta.dart';
import 'package:predictions/matches/matches_bloc.dart';
import 'package:predictions/matches/model/football_match.dart';

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
    final awayMatches = allMatches
        .where((m) => m.awayTeam == match.awayTeam && m.hasBeenPlayed())
        .toList();
    final sortedAwayMatches = awayMatches.length > 5
        ? awayMatches.sublist(awayMatches.length - 5).reversed.toList()
        : awayMatches;
    _awayMatches.add(sortedAwayMatches);
  }
}
