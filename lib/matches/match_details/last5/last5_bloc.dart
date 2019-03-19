import 'dart:async';

import 'package:meta/meta.dart';
import 'package:predictions/matches/matches_bloc.dart';
import 'package:predictions/matches/model/match.dart';

class Last5Bloc {
  final MatchesBloc matchesBloc;
  final Match match;

  StreamController<List<Match>> _homeMatches = StreamController();
  StreamController<List<Match>> _awayMatches = StreamController();

  Last5Bloc({@required this.matchesBloc, @required this.match}) {
    matchesBloc.allMatches.listen(_fetchLast5Matches);
  }

  Stream<List<Match>> get homeMatches => _homeMatches.stream;

  Stream<List<Match>> get awayMatches => _awayMatches.stream;

  void dispose() {
    _homeMatches.close();
    _awayMatches.close();
  }

  void _fetchLast5Matches(List<Match> allMatches) {
    final homeMatches = allMatches
        .where((m) => m.homeTeam == match.homeTeam && m.hasBeenPlayed())
        .toList();
    final sortedHomeMatches = homeMatches.length > 5
        ? homeMatches.sublist(homeMatches.length - 5).reversed.toList()
        : homeMatches;
    _homeMatches.add(sortedHomeMatches);

    final awayMatches = allMatches
        .where((m) => m.awayTeam == match.awayTeam && m.hasBeenPlayed())
        .toList();
    final sortedAwayMatches = awayMatches.length > 5
        ? awayMatches.sublist(awayMatches.length - 5).reversed.toList()
        : awayMatches;
    _awayMatches.add(sortedAwayMatches);
  }
}
