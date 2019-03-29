import 'package:flutter/material.dart';
import 'package:predictions/main.dart';
import 'package:predictions/matches/stats/all_leagues/stats_all_leagues_page.dart';
import 'package:predictions/matches/stats/selected_leagues/stats_selected_leagues_page.dart';

class StatsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Theme(
      data: darkTheme,
      child: Scaffold(
        appBar: AppBar(
          title: Text("Stats"),
          elevation: 0.0,
        ),
        body: DefaultTabController(
          length: 2,
          child: Column(
            children: <Widget>[
              TabBar(
                indicatorColor: Theme.of(context).canvasColor,
                tabs: [
                  Tab(text: "Highlighted Leagues"),
                  Tab(text: "All Leagues"),
                ],
              ),
              Expanded(
                child: TabBarView(
                  children: [
                    StatsSelectedLeaguesPage(),
                    StatsAllLeaguesPage(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
