import 'dart:async';

import 'package:meta/meta.dart';
import 'package:predictions/matches/matches_bloc.dart';
import 'package:predictions/matches/model/match.dart';

class Last5HomeBloc {
  final MatchesBloc matchesBloc;
  final Match match;

  StreamController<List<Match>> _homeMatches = StreamController();

  Last5HomeBloc({@required this.matchesBloc, @required this.match}) {
    matchesBloc.allMatches.listen(_fetchLast5Matches);
  }

  Stream<List<Match>> get homeMatches => _homeMatches.stream;

  void dispose() {
    _homeMatches.close();
  }

  void _fetchLast5Matches(List<Match> allMatches) {
    final homeMatches = allMatches
        .where((m) => m.homeTeam == match.homeTeam && m.hasBeenPlayed())
        .toList();
    final sortedHomeMatches = homeMatches.length > 5
        ? homeMatches.sublist(homeMatches.length - 5).reversed.toList()
        : homeMatches;
    _homeMatches.add(sortedHomeMatches);
  }
}
