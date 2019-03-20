import 'package:predictions/data/model/football_match.dart';

class MatchFinder {
  final List<FootballMatch> allMatches;

  MatchFinder(this.allMatches);

  int findGoalsInLastMatchForHomeTeam({FootballMatch match}) {
    final lastMatches = allMatches
        .where((m) => m != match && m.hasBeenPlayed() && m.homeTeam == match.homeTeam)
        .toList();

    if (lastMatches.isEmpty) {
      return 99;
    }

    return lastMatches.last.homeFinalScore + lastMatches.last.awayFinalScore;
  }

  int findGoalsInLastMatchForAwayTeam({FootballMatch match}) {
    final lastMatches = allMatches
        .where((m) => m != match && m.hasBeenPlayed() && m.awayTeam == match.awayTeam)
        .toList();

    if (lastMatches.isEmpty) {
      return 99;
    }

    return lastMatches.last.homeFinalScore + lastMatches.last.awayFinalScore;
  }
}
