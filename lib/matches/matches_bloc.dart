import 'package:collection/collection.dart';
import 'package:predictions/matches/api/matches_api.dart';
import 'package:predictions/matches/model/football_match.dart';
import 'package:rxdart/subjects.dart';

class MatchesBloc {
  final BehaviorSubject<List<FootballMatch>> _matches = BehaviorSubject<List<FootballMatch>>();
  final BehaviorSubject<Map<String, Map<String, List<FootballMatch>>>> _groupedMatches =
      BehaviorSubject<Map<String, Map<String, List<FootballMatch>>>>();

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

  Map<String, Map<String, List<FootballMatch>>> _groupMatches(List<FootballMatch> matches) {
    final groupedByDay = groupBy(matches, (obj) => obj.date);
    return groupedByDay.map(
        (key, value) => MapEntry(key, groupBy(value, (obj) => obj.league)));
  }

  Stream<List<FootballMatch>> get allMatches => _matches.stream;

  Stream<Map<String, Map<String, List<FootballMatch>>>> get groupedMatches =>
      _groupedMatches.stream;

  void dispose() {
    _groupedMatches.close();
    _matches.close();
  }
}
