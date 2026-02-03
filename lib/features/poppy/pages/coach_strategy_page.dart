import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/coach_chat_bloc.dart';
import '../bloc/coach_chat_event.dart';
import '../bloc/coach_chat_state.dart';

/// Página para generar estrategia de contenido
class CoachStrategyPage extends StatefulWidget {
  const CoachStrategyPage({super.key});

  @override
  State<CoachStrategyPage> createState() => _CoachStrategyPageState();
}

class _CoachStrategyPageState extends State<CoachStrategyPage> {
  final _formKey = GlobalKey<FormState>();
  final _nichoController = TextEditingController();
  final _audienciaController = TextEditingController();
  final List<String> _pilares = [];
  final _pilarController = TextEditingController();

  void _addPilar() {
    final pilar = _pilarController.text.trim();
    if (pilar.isEmpty || _pilares.contains(pilar)) return;

    setState(() {
      _pilares.add(pilar);
      _pilarController.clear();
    });
  }

  void _removePilar(String pilar) {
    setState(() {
      _pilares.remove(pilar);
    });
  }

  void _generateStrategy() {
    if (!_formKey.currentState!.validate()) return;
    if (_pilares.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Agrega al menos 1 pilar'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    context.read<CoachChatBloc>().add(
          CoachContentStrategyGenerated(
            nicho: _nichoController.text,
            audiencia: _audienciaController.text,
            pilares: _pilares,
          ),
    );

    Navigator.pop(context);
  }

  @override
  void dispose() {
    _nichoController.dispose();
    _audienciaController.dispose();
    _pilarController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Genera tu Estrategia de Contenido',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Método Softvibes1: 4 Pilares → 16 Tópicos → 160+ Temas',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 24),
            _buildTextField(
              controller: _nichoController,
              label: 'Tu Nicho',
              hint: 'Ej: Coaching de negocios para freelancers',
              icon: Icons.category,
              required: true,
            ),
            const SizedBox(height: 16),
            _buildTextField(
              controller: _audienciaController,
              label: 'Tu Audiencia',
              hint: 'Ej: Freelancers que quieren escalar a agencia',
              icon: Icons.people,
              required: true,
            ),
            const SizedBox(height: 16),
            const Text(
              'Pilares de Contenido (mínimo 1, ideal 4)',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _pilarController,
                    decoration: InputDecoration(
                      hintText: 'Ej: Branding Personal',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      filled: true,
                      fillColor: Colors.grey[50],
                    ),
                    onFieldSubmitted: (_) => _addPilar(),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  onPressed: _addPilar,
                  icon: const Icon(Icons.add_circle),
                  style: IconButton.styleFrom(
                    backgroundColor: Colors.purple,
                    foregroundColor: Colors.white,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            if (_pilares.isNotEmpty)
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _pilares.map((pilar) {
                  return Chip(
                    label: Text(pilar),
                    onDeleted: () => _removePilar(pilar),
                    deleteIconColor: Colors.red,
                  );
                }).toList(),
              ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _generateStrategy,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.purple,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Generar Estrategia',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    bool required = false,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: Icon(icon),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        filled: true,
        fillColor: Colors.grey[50],
      ),
      validator: (value) {
        if (required && (value == null || value.trim().isEmpty)) {
          return 'Este campo es requerido';
        }
        return null;
      },
    );
  }
}
