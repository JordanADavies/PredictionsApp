import 'package:collection/collection.dart';
import 'package:predictions/matches/api/matches_api.dart';
import 'package:predictions/matches/model/match.dart';
import 'package:rxdart/subjects.dart';

class MatchesBloc {
  final BehaviorSubject<List<Match>> _matches = BehaviorSubject<List<Match>>();
  final BehaviorSubject<Map<String, Map<String, List<Match>>>> _groupedMatches =
      BehaviorSubject<Map<String, Map<String, List<Match>>>>();

  MatchesBloc() {
    _loadMatches();
  }

  Future _loadMatches() async {
    final api = MatchesApi();
    final matches = await api.fetchMatches();
    _matches.add(matches);

    final groupedMatches = _groupMatches(matches);
    _groupedMatches.add(groupedMatches);
  }

  Map<String, Map<String, List<Match>>> _groupMatches(List<Match> matches) {
    final groupedByDay = groupBy(matches, (obj) => obj.date);
    return groupedByDay.map(
        (key, value) => MapEntry(key, groupBy(value, (obj) => obj.league)));
  }

  Stream<List<Match>> get allMatches => _matches.stream;

  Stream<Map<String, Map<String, List<Match>>>> get groupedMatches =>
      _groupedMatches.stream;

  void dispose() {
    _groupedMatches.close();
    _matches.close();
  }
}
