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
    return StreamBuilder<List<ProfitLoss>>(
      stream: _statsBloc.profitLoss.stream,
      builder:
          (BuildContext context, AsyncSnapshot<List<ProfitLoss>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        return _buildProfitLoss(snapshot.data);
      },
    );
  }

  Widget _buildProfitLoss(List<ProfitLoss> profitLoss) {
    return ListView(
      padding: EdgeInsets.all(12.0),
      children: profitLoss.map((p) => _buildProfitLossItem(p)).toList(),
    );
  }

  Widget _buildProfitLossItem(ProfitLoss profitLoss) {
    return ListTile(
      contentPadding: EdgeInsets.all(12.0),
      title: Text(
        profitLoss.type,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 17.0,
        ),
      ),
      trailing: Text(
        "${profitLoss.roi.toStringAsFixed(2)}%",
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 16.0,
        ),
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Won: ${profitLoss.won}",
            style: TextStyle(fontSize: 16.0),
          ),
          SizedBox(height: 4.0),
          Text(
            "Lost: ${profitLoss.lost}",
            style: TextStyle(fontSize: 16.0),
          ),
          SizedBox(height: 4.0),
          Text(
            "Total: ${profitLoss.profitLoss.toStringAsFixed(2)}u",
            style: TextStyle(fontSize: 16.0),
          ),
        ],
      ),
    );
  }
}
