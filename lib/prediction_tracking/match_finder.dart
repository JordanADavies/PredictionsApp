import 'package:meta/meta.dart';
import 'package:predictions/data/model/football_match.dart';

class MatchFinder {
  final List<FootballMatch> allMatches;

  MatchFinder({@required this.allMatches});

  List<FootballMatch> findLastHomeMatchesForHomeTeam(
      int n, FootballMatch match) {
    final currentMatchIndex = allMatches.indexOf(match);
    final sublistEnd =
        currentMatchIndex > 0 ? currentMatchIndex - 1 : currentMatchIndex;
    final previousMatches = allMatches.sublist(0, sublistEnd);

    final foundMatches = previousMatches
        .where((m) =>
            m.homeTeam == match.homeTeam &&
            m.hasFinalScore() &&
            m.isBeforeToday())
        .toList();
    return foundMatches.length > n
        ? foundMatches.sublist(foundMatches.length - n)
        : foundMatches;
  }

  List<FootballMatch> findLastAwayMatchesForAwayTeam(
      int n, FootballMatch match) {
    final currentMatchIndex = allMatches.indexOf(match);
    final sublistEnd =
        currentMatchIndex > 0 ? currentMatchIndex - 1 : currentMatchIndex;
    final previousMatches = allMatches.sublist(0, sublistEnd);

    final foundMatches = previousMatches
        .where((m) =>
            m.awayTeam == match.awayTeam &&
            m.hasFinalScore() &&
            m.isBeforeToday())
        .toList();
    return foundMatches.length > n
        ? foundMatches.sublist(foundMatches.length - n)
        : foundMatches;
  }

  List<FootballMatch> findLastMatchesForHomeTeam(int n, FootballMatch match) {
    final currentMatchIndex = allMatches.indexOf(match);
    final sublistEnd =
        currentMatchIndex > 0 ? currentMatchIndex - 1 : currentMatchIndex;
    final previousMatches = allMatches.sublist(0, sublistEnd);

    final foundMatches = previousMatches
        .where((m) =>
            (m.homeTeam == match.homeTeam || m.awayTeam == match.homeTeam) &&
            m.hasFinalScore() &&
            m.isBeforeToday())
        .toList();
    return foundMatches.length > n
        ? foundMatches.sublist(foundMatches.length - n)
        : foundMatches;
  }

  List<FootballMatch> findLastMatchesForAwayTeam(int n, FootballMatch match) {
    final currentMatchIndex = allMatches.indexOf(match);
    final sublistEnd =
        currentMatchIndex > 0 ? currentMatchIndex - 1 : currentMatchIndex;
    final previousMatches = allMatches.sublist(0, sublistEnd);

    final foundMatches = previousMatches
        .where((m) =>
            (m.homeTeam == match.awayTeam || m.awayTeam == match.awayTeam) &&
            m.hasFinalScore() &&
            m.isBeforeToday())
        .toList();
    return foundMatches.length > n
        ? foundMatches.sublist(foundMatches.length - n)
        : foundMatches;
  }

  List<FootballMatch> findLastHead2HeadMatches(FootballMatch match) {
    final currentMatchIndex = allMatches.indexOf(match);
    final sublistEnd =
        currentMatchIndex > 0 ? currentMatchIndex - 1 : currentMatchIndex;
    final previousMatches = allMatches.sublist(0, sublistEnd);

    final foundMatches = previousMatches
        .where((m) =>
            m.homeTeam == match.homeTeam &&
            m.awayTeam == match.awayTeam &&
            m.hasFinalScore() &&
            m.isBeforeToday())
        .toList();
    return foundMatches;
  }
}
