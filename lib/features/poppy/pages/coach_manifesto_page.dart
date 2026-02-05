import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lifevibes/features/poppy/bloc/coach_chat_bloc.dart';
import 'package:lifevibes/features/poppy/bloc/coach_chat_event.dart';
import 'package:lifevibes/features/poppy/bloc/coach_chat_state.dart';

/// Página para generar el manifiesto de marca
class CoachManifestoPage extends StatefulWidget {
  const CoachManifestoPage({super.key});

  @override
  State<CoachManifestoPage> createState() => _CoachManifestoPageState();
}

class _CoachManifestoPageState extends State<CoachManifestoPage> {
  final _formKey = GlobalKey<FormState>();
  final _usuarioController = TextEditingController();
  final _valoresController = TextEditingController();
  final _propositoController = TextEditingController();
  final _superpoderController = TextEditingController();

  @override
  void dispose() {
    _usuarioController.dispose();
    _valoresController.dispose();
    _propositoController.dispose();
    _superpoderController.dispose();
    super.dispose();
  }

  void _generateManifesto() {
    if (!_formKey.currentState!.validate()) return;

    context.read<CoachChatBloc>().add(
          CoachManifestoGenerated(
            usuario: _usuarioController.text,
            valores: _valoresController.text,
            proposito: _propositoController.text,
            superpoder: _superpoderController.text,
          ),
    );

    Navigator.pop(context);
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
              'Genera tu Manifiesto de Marca',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Un manifieto auténtico conecta emocionalmente con tu audiencia.',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 24),
            _buildTextField(
              controller: _usuarioController,
              label: 'Tu Nombre',
              hint: 'Ej: Roger Garcia Vital',
              icon: Icons.person,
              required: true,
            ),
            const SizedBox(height: 16),
            _buildTextField(
              controller: _valoresController,
              label: 'Valores Principales',
              hint: 'Ej: Autenticidad, Creatividad, Impacto, Libertad',
              icon: Icons.favorite,
              maxLines: 3,
              required: true,
            ),
            const SizedBox(height: 16),
            _buildTextField(
              controller: _propositoController,
              label: 'Tu Propósito',
              hint: 'Ej: Ayudar a freelancers a transformar su talento en empresas digitales escalables',
              icon: Icons.flag,
              maxLines: 3,
              required: true,
            ),
            const SizedBox(height: 16),
            _buildTextField(
              controller: _superpoderController,
              label: 'Tu Superpoder Único',
              hint: 'Ej: Simplificar conceptos complejos en estrategias accionables',
              icon: Icons.star,
              required: true,
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _generateManifesto,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.purple,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Generar Manifiesto',
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
    int maxLines = 1,
    bool required = false,
  }) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
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
