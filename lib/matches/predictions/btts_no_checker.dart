import 'package:meta/meta.dart';
import 'package:predictions/data/leagues.dart';
import 'package:predictions/data/model/football_match.dart';
import 'package:predictions/data/teams.dart';

class BttsNoChecker {
  final FootballMatch match;

  BttsNoChecker({@required this.match});

  bool getPrediction() {
    final bttsPercentage = bttsPercentages[match.leagueId];
    return bttsPercentage < 45 &&
        (match.homeProjectedGoals < 1 || match.awayProjectedGoals < 1);
  }

  bool getPredictionIncludingPerformance() {
    final prediction = getPrediction();
    if (!prediction) {
      return false;
    }

    return (match.homeProjectedGoals < 1 &&
            underPerformingGoalsTeams.contains("(H) ${match.homeTeam}")) ||
        (match.awayProjectedGoals < 1 &&
            underPerformingGoalsTeams.contains("(A) ${match.awayTeam}"));
  }

  bool isPredictionCorrect() {
    if (!match.hasFinalScore() || !getPrediction()) {
      return false;
    }

    return match.homeFinalScore < 1 || match.awayFinalScore < 1;
  }
}
