import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:web_dashboard/src/app.dart';
import 'package:web_dashboard/src/color.dart';
import 'package:web_dashboard/src/model/standing.dart';
import 'package:web_dashboard/src/model/team.dart';
import 'package:web_dashboard/src/widgets/app_text.dart';
import 'package:web_dashboard/src/widgets/indicator.dart';
import 'package:web_dashboard/src/widgets/team_flag.dart';

import '../utils/screen_helper.dart';
import 'match/match_list_screen.dart';

class StandingPage extends StatefulWidget {
  const StandingPage({
    super.key,
  });

  @override
  State<StandingPage> createState() => _StandingPageState();
}

class _StandingPageState extends State<StandingPage> {
  int _pageIndex = 0;
  late AppState _appState;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _appState = Provider.of<AppState>(context);
    return Scaffold(
      appBar: _appBar(context),
      body: _mainView(),
    );
  }


  AppBar? _appBar(BuildContext context) {
    if (ScreenHelper.isLargeScreen(context)) {
      return null;
    }
    
    return AppBar(
        title: AppText("Standing",
            size: 20, weight: FontWeight.w700, color: SystemColor.WHITE));
  }

  Widget _mainView() {
    return StreamBuilder<List<Standing>>(
      stream: _appState.api!.standingApi.subscribe(),
      builder: (context, snapshot) {
        if (snapshot.data == null) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        return _standingList(snapshot.data ?? []);
      },
    );
  }

  Widget _standingList(List<Standing> standings) {

    return Padding(
      padding: EdgeInsets.all(16),
      child: ListView.builder(
          itemCount: standings.length,
          itemBuilder: (ctx, index) {
            final standing = standings[index];
            return _standingCell(standing);
          }),
    );
  }
  
  Widget _standingCell(Standing standing) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppText("Group ${standing.group ?? ""}", color: SystemColor.RED, weight: FontWeight.bold, size: 20,),
            SizedBox(height: 16),
            _header(),
            _teams(standing.teams)
          ],
        ),
      ),
    );
  }

  Widget _header() {
    return Row(
      children: [
        Expanded(child: AppText("Team", weight: FontWeight.bold)),
        AppText("Pts", weight: FontWeight.bold),
      ],
    );
  }

  Widget _teams(List<Team>? teams) {
    final list = teams ?? [];
    list.sort((a, b) => b.ptsInt.compareTo(a.ptsInt));
    return Column(
      children: list.map((team) {
        return _teamRow(team);
      }).toList(),
    );
  }
  
  Widget _teamRow(Team team) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      onTap: () => _showTeamMatch(team),
      title: Padding(
        padding: EdgeInsets.only(top: 10),
        child: Row(
          children: [
            TeamFag(url: team.flag ?? ""),
            SizedBox(width: 10),
            AppText(team.nameEn ?? ""),
            Expanded(child: Container()),
            AppText("${team.pts ?? "-"}"),
          ],
        ),
      ),
    );
  }
  
  _showTeamMatch(Team team) async {
    Indicator.show(context);
    final matchApi = Provider.of<AppState>(context, listen: false).api!.footballMatchApi;
    final matches = await matchApi.listForTeam(team.teamId ?? "");
    Indicator.hide(context);

    Navigator.of(context)
      .push(MaterialPageRoute(builder: (context) => MatchListScreen(list: matches, enableHeader: true, title: team.nameEn)));
  }
}
