import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lifevibes/features/poppy/bloc/coach_chat_bloc.dart';
import 'package:lifevibes/features/poppy/bloc/coach_chat_event.dart';
import 'package:lifevibes/features/poppy/bloc/coach_chat_state.dart';
import 'package:lifevibes/features/poppy/models/poppy_message.dart';
import 'package:lifevibes/features/poppy/widgets/coach_chat_widget.dart';
import 'coach_manifesto_page.dart';
import 'coach_strategy_page.dart';

/// Página principal del coach virtual
/// Muestra opciones de coaching y el chat
class CoachPage extends StatefulWidget {
  const CoachPage({super.key});

  @override
  State<CoachPage> createState() => _CoachPageState();
}

class _CoachPageState extends State<CoachPage> with TickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Coach Virtual'),
        backgroundColor: Colors.purple,
        foregroundColor: Colors.white,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          tabs: const [
            Tab(text: 'Chat', icon: Icon(Icons.chat)),
            Tab(text: 'Manifiesto', icon: Icon(Icons.description)),
            Tab(text: 'Estrategia', icon: Icon(Icons.lightbulb)),
            Tab(text: 'Análisis', icon: Icon(Icons.bar_chart)),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          const CoachChatWidget(),
          const CoachManifestoPage(),
          const CoachStrategyPage(),
          _buildAnalysisTab(),
        ],
      ),
    );
  }

  Widget _buildAnalysisTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Análisis de Situación',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Describe tu situación actual y te ayudaré a diagnosticar dónde estás y qué acciones tomar.',
                    style: TextStyle(color: Colors.grey[700]),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    maxLines: 5,
                    decoration: InputDecoration(
                      hintText: '¿En qué estás trabajando ahora? ¿Qué problemas enfrentas?',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        // TODO: Implement analysis
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.purple,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: const Text('Analizar'),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          _buildQuickActions(),
        ],
      ),
    );
  }

  Widget _buildQuickActions() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Acciones Rápidas',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            _buildQuickAction(
              icon: Icons.psychology,
              title: 'Descubrir Propósito',
              subtitle: 'Encuentra tu "por qué"',
              onTap: () {
                _tabController.animateTo(0);
              },
            ),
            const Divider(),
            _buildQuickAction(
              icon: Icons.edit_note,
              title: 'Generar Manifiesto',
              subtitle: 'Crea tu declaración de marca',
              onTap: () {
                _tabController.animateTo(1);
              },
            ),
            const Divider(),
            _buildQuickAction(
              icon: Icons.calendar_month,
              title: 'Plan de Contenido',
              subtitle: 'Estrategia para publicar',
              onTap: () {
                _tabController.animateTo(2);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickAction({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.purple.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, color: Colors.purple),
      ),
      title: Text(title),
      subtitle: Text(subtitle),
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }
}
