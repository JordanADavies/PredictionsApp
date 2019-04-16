import 'package:meta/meta.dart';
import 'package:predictions/data/model/football_match.dart';
import 'package:predictions/data/teams.dart';
import 'package:predictions/util/utils.dart';

class BttsNoChecker {
  final FootballMatch match;

  BttsNoChecker({@required this.match});

  bool getPrediction() {
    final roundedHomeGoals =
        Utils.roundProjectedGoals(match.homeProjectedGoals);
    final roundedAwayGoals =
        Utils.roundProjectedGoals(match.awayProjectedGoals);
    return roundedHomeGoals < 1 || roundedAwayGoals < 1;
  }

  bool getPredictionIncludingPerformance() {
    final roundedHomeGoals = Utils.roundProjectedGoals(match.homeProjectedGoals);
    final roundedAwayGoals = Utils.roundProjectedGoals(match.awayProjectedGoals);

    return (roundedHomeGoals < 1 &&
            underPerformingTeams.contains("(H) ${match.homeTeam}")) ||
        (roundedAwayGoals < 1 &&
            underPerformingTeams.contains("(A) ${match.awayTeam}"));
  }

  bool isPredictionCorrect() {
    if (!match.hasFinalScore() || !getPrediction()) {
      return false;
    }

    return match.homeFinalScore < 1 || match.awayFinalScore < 1;
  }
}
