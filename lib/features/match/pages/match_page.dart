import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:lifevibes/features/avatar/bloc/match_bloc.dart';
import 'package:lifevibes/features/avatar/bloc/match_event.dart';
import 'package:lifevibes/features/avatar/bloc/match_state.dart';
import 'package:lifevibes/features/avatar/widgets/match_widgets.dart';

/// Página principal del sistema de matches
class MatchPage extends StatefulWidget {
  const MatchPage({super.key});

  @override
  State<MatchPage> createState() => _MatchPageState();
}

class _MatchPageState extends State<MatchPage> {
  @override
  void initState() {
    super.initState();
    // Load matches on page load
    _loadMatches();
  }

  void _loadMatches() {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId != null) {
      context.read<MatchBloc>().add(MatchLoadRequested(userId));
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Matches Softvibes'),
          backgroundColor: Colors.purple,
          foregroundColor: Colors.white,
          bottom: const TabBar(
            tabs: [Tab(text: 'Buscar'), Tab(text: 'Mis Matches')],
            labelColor: Colors.white,
            indicatorColor: Colors.white,
          ),
        ),
        body: const TabBarView(
          children: [
            MatchSwipeWidget(),
            MatchListWidget(),
          ],
        ),
      ),
    );
  }
}
