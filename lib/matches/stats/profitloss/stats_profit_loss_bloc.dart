import 'dart:async';

import 'package:meta/meta.dart';
import 'package:predictions/data/matches_bloc.dart';
import 'package:predictions/matches/predictions/value_checker.dart';
import 'package:predictions/matches/predictions/win_lose_draw_checker.dart';

class ProfitLoss {
  final double profitLoss;
  final int won;
  final int lost;
  final double roi;

  ProfitLoss(
    this.profitLoss,
    this.won,
    this.lost,
    this.roi,
  );
}

class StatsProfitLossBloc {
  final StreamController<ProfitLoss> profitLoss =
      StreamController<ProfitLoss>();

  void dispose() {
    profitLoss.close();
  }

  StatsProfitLossBloc({@required MatchesBloc matchesBloc}) {
    matchesBloc.matches.listen(_calculateProfitLoss);
  }

  void _calculateProfitLoss(Matches matches) async {
    final predictedMatches = matches.winLoseDrawMatches
        .where((m) => m.hasFinalScore() && m.isBeforeToday())
        .toList();

    double total = 0;
    int won = 0;
    int lost = 0;
    predictedMatches.forEach((m) {
      final resultChecker = WinLoseDrawChecker(match: m);
      if (resultChecker.isPredictionCorrect()) {
        final value = double.parse(ValueChecker(match: m).getValue());
        total += value;
        won += 1;
      } else {
        total -= 1;
        lost += 1;
      }
    });

    final result = ProfitLoss(
      total,
      won,
      lost,
      (total - won) / won,
    );
    profitLoss.add(result);
  }
}
