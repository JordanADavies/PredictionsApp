import 'dart:async';

import 'package:meta/meta.dart';
import 'package:predictions/matches/matches_bloc.dart';
import 'package:predictions/matches/model/football_match.dart';

class Head2HeadBloc {
  final MatchesBloc matchesBloc;
  final FootballMatch match;

  StreamController<List<FootballMatch>> _head2HeadMatches = StreamController();

  Head2HeadBloc({@required this.matchesBloc, @required this.match}) {
    matchesBloc.allMatches.listen(_fetchHead2HeadMatches);
  }

  Stream<List<FootballMatch>> get head2HeadMatches => _head2HeadMatches.stream;

  void dispose() {
    _head2HeadMatches.close();
  }

  void _fetchHead2HeadMatches(List<FootballMatch> allMatches) {
    final head2HeadMatches = allMatches.where((m) => m.hasBeenPlayed() &&
        ((m.homeTeam == match.homeTeam && m.awayTeam == match.awayTeam) ||
        (m.homeTeam == match.awayTeam && m.awayTeam == match.homeTeam)));
    _head2HeadMatches.add(head2HeadMatches.toList().reversed.toList());
  }
}
