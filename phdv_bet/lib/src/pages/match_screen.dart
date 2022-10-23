import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:web_dashboard/src/model/match.dart';
import 'package:web_dashboard/src/pages/match_list_screen.dart';
import '../app.dart';

class MatchScreen extends StatelessWidget {
  const MatchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return _matches(context);
  }
  
  Widget _matches(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    return StreamBuilder<List<FootballMatch>>(
      stream: appState.api!.footballMatchApi.subscribe(),
      builder: (context, snapshot) {
        if (snapshot.data == null) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        return MatchListScreen(list: snapshot.data ?? []);
      },
    );
  }
  
  Widget _searchBar(BuildContext context) {
    return TextFormField();
  }
}