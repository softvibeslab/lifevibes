import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:lifevibes/features/funnel/bloc/funnel_bloc.dart';
import 'package:lifevibes/features/funnel/bloc/funnel_event.dart';
import 'package:lifevibes/features/funnel/bloc/funnel_state.dart';
import 'package:lifevibes/features/funnel/widgets/funnel_widgets.dart';

/// Página principal del sistema de funnels
class FunnelPage extends StatefulWidget {
  const FunnelPage({super.key});

  @override
  State<FunnelPage> createState() => _FunnelPageState();
}

class _FunnelPageState extends State<FunnelPage> {
  @override
  void initState() {
    super.initState();
    _loadFunnels();
  }

  void _loadFunnels() {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId != null) {
      context.read<FunnelBloc>().add(FunnelsLoadRequested(userId));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Funnels de Conversión'),
        backgroundColor: Colors.purple,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => _loadFunnels(),
          ),
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => _showCreateDialog(context),
          ),
        ],
      ),
      body: BlocBuilder<FunnelBloc, FunnelState>(
        builder: (context, state) {
          if (state.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 48, color: Colors.red),
                  const SizedBox(height: 16),
                  Text(
                    state.errorMessage ?? 'Error',
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => _loadFunnels(),
                    child: const Text('Reintentar'),
                  ),
                ],
              ),
            );
          }

          return const FunnelListWidget();
        },
      ),
    );
  }

  void _showCreateDialog(BuildContext context) {
    // This will be handled by the widget's internal logic
  }
}
