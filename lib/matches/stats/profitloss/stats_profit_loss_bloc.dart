import 'dart:async';

import 'package:meta/meta.dart';
import 'package:predictions/data/matches_bloc.dart';
import 'package:predictions/matches/predictions/high_percent_checker.dart';
import 'package:predictions/matches/predictions/value_checker.dart';
import 'package:predictions/matches/predictions/win_lose_draw_checker.dart';

class ProfitLoss {
  final String type;
  final double profitLoss;
  final int won;
  final int lost;
  final double roi;

  ProfitLoss(
    this.type,
    this.profitLoss,
    this.won,
    this.lost,
    this.roi,
  );
}

class StatsProfitLossBloc {
  final StreamController<List<ProfitLoss>> profitLoss =
      StreamController<List<ProfitLoss>>();

  void dispose() {
    profitLoss.close();
  }

  StatsProfitLossBloc({@required MatchesBloc matchesBloc}) {
    matchesBloc.matches.listen(_calculateProfitLoss);
  }

  void _calculateProfitLoss(Matches matches) {
    final winLoseDrawProfitLoss = _calculateWinLoseDrawProfitLoss(matches);
    final highChanceProfitLoss = _calculateHighChanceProfitLoss(matches);
    profitLoss.add([winLoseDrawProfitLoss, highChanceProfitLoss]);
  }

  ProfitLoss _calculateWinLoseDrawProfitLoss(Matches matches) {
    final predictedMatches = matches.winLoseDrawMatches
        .where((m) => m.hasFinalScore() && m.isBeforeToday())
        .toList();

    double total = 0;
    int won = 0;
    int lost = 0;
    predictedMatches.forEach((m) {
      final resultChecker = WinLoseDrawChecker(match: m);
      if (resultChecker.isPredictionCorrect()) {
        final value =
            double.parse(ValueChecker(match: m).getWinLoseDrawValue());
        total += value;
        won += 1;
      } else {
        total -= 1;
        lost += 1;
      }
    });

    return ProfitLoss(
      "1X2",
      total,
      won,
      lost,
      (total - won) / won,
    );
  }

  ProfitLoss _calculateHighChanceProfitLoss(Matches matches) {
    final predictedMatches = matches.highPercentChanceMatches
        .where((m) => m.hasFinalScore() && m.isBeforeToday())
        .toList();

    double total = 0;
    int won = 0;
    int lost = 0;
    predictedMatches.forEach((m) {
      final resultChecker = HighPercentChecker(match: m);
      if (resultChecker.isPredictionCorrect()) {
        final value = double.parse(ValueChecker(match: m).getHighChanceValue());
        total += value;
        won += 1;
      } else {
        total -= 1;
        lost += 1;
      }
    });

    return ProfitLoss(
      "High",
      total,
      won,
      lost,
      (total - won) / won,
    );
  }
}
