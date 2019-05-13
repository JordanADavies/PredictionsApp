import 'package:flutter/material.dart';
import 'package:predictions/data/matches_provider.dart';
import 'package:predictions/matches/stats/profitloss/stats_profit_loss_bloc.dart';

class StatsProfitLossPage extends StatefulWidget {
  @override
  _StatsProfitLossPageState createState() => _StatsProfitLossPageState();
}

class _StatsProfitLossPageState extends State<StatsProfitLossPage> {
  StatsProfitLossBloc _statsBloc;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final matchesBloc = MatchesProvider.of(context);
    _statsBloc ??= StatsProfitLossBloc(matchesBloc: matchesBloc);
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<ProfitLoss>(
      stream: _statsBloc.profitLoss.stream,
      builder: (BuildContext context, AsyncSnapshot<ProfitLoss> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        return _buildProfitLoss(snapshot.data);
      },
    );
  }

  Widget _buildProfitLoss(ProfitLoss profitLoss) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Won: ${profitLoss.won}",
            style: TextStyle(fontSize: 30.0),
          ),
          Divider(),
          Text(
            "Lost: ${profitLoss.lost}",
            style: TextStyle(fontSize: 30.0),
          ),
          Divider(),
          Text(
            "Total: ${profitLoss.profitLoss.toStringAsFixed(2)}u",
            style: TextStyle(fontSize: 32.0),
          ),
          Divider(),
          Text(
            "ROI: ${profitLoss.roi.toStringAsFixed(2)}%",
            style: TextStyle(fontSize: 32.0),
          ),
        ],
      ),
    );
  }
}
