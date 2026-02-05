import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../bloc/funnel_bloc.dart';
import '../bloc/funnel_event.dart';
import '../bloc/funnel_state.dart';
import '../models/funnel_model.dart';

/// Widget para mostrar lista de funnels
class FunnelListWidget extends StatelessWidget {
  const FunnelListWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FunnelBloc, FunnelState>(
      builder: (context, state) {
        if (state.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state.funnels.isEmpty) {
          return _buildEmptyState(context);
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: state.funnels.length,
          itemBuilder: (context, index) {
            final funnel = state.funnels[index];
            return _FunnelCard(funnel: funnel);
          },
        );
      },
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.filter_alt, size: 64, color: Colors.grey),
          const SizedBox(height: 16),
          Text(
            'No hay funnels creados',
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Crea tu primer funnel para empezar',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[500],
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () => _showCreateDialog(context),
            icon: const Icon(Icons.add),
            label: const Text('Crear Funnel'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.purple,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(
                horizontal: 24,
                vertical: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showCreateDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => _CreateFunnelSheet(),
    );
  }
}

/// Card individual de funnel
class _FunnelCard extends StatelessWidget {
  final FunnelModel funnel;

  const _FunnelCard({required this.funnel});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: () => _showFunnelDetails(context),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                children: [
                  // Type badge
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.purple.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      funnel.typeLabel,
                      style: const TextStyle(
                        color: Colors.purple,
                        fontWeight: FontWeight.bold,
                        fontSize: 11,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  // Status badge
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      color: funnel.statusColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      funnel.statusLabel,
                      style: TextStyle(
                        color: funnel.statusColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 11,
                      ),
                    ),
                  ),
                  const Spacer(),
                  // Date
                  Text(
                    _formatDate(funnel.createdAt),
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              // Title
              Text(
                funnel.title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              // Description
              Text(
                funnel.description,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 13,
                ),
              ),
              const SizedBox(height: 12),
              // Metrics row
              Row(
                children: [
                  _buildMetric(
                    icon: Icons.people,
                    label: 'Visitantes',
                    value: '${funnel.metrics.totalVisitors}',
                    color: Colors.blue,
                  ),
                  const SizedBox(width: 16),
                  _buildMetric(
                    icon: Icons.mail,
                    label: 'Leads',
                    value: '${funnel.metrics.leadsCaptured}',
                    color: Colors.orange,
                  ),
                  const SizedBox(width: 16),
                  _buildMetric(
                    icon: Icons.trending_up,
                    label: 'Conversión',
                    value: '${funnel.metrics.conversionRate.toStringAsFixed(1)}%',
                    color: Colors.green,
                  ),
                  const Spacer(),
                  // Steps count
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.layers, size: 12),
                        const SizedBox(width: 4),
                        Text(
                          '${funnel.steps.length} pasos',
                          style: const TextStyle(fontSize: 11),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    ).animate().fadeIn(duration: 300.ms).slideY(begin: 0.1, end: 0);
  }

  Widget _buildMetric({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Row(
      children: [
        Icon(icon, size: 16, color: color),
        const SizedBox(width: 4),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              value,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: color,
                fontSize: 12,
              ),
            ),
            Text(
              label,
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 10,
              ),
            ),
          ],
        ),
      ],
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inHours < 1) {
      return '${difference.inMinutes} min';
    } else if (difference.inDays < 1) {
      return '${difference.inHours} h';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} días';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }

  void _showFunnelDetails(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => _FunnelDetailSheet(funnel: funnel),
    );
  }
}

/// Bottom sheet para crear funnel
class _CreateFunnelSheet extends StatefulWidget {
  @override
  State<_CreateFunnelSheet> createState() => _CreateFunnelSheetState();
}

class _CreateFunnelSheetState extends State<_CreateFunnelSheet> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  FunnelType _selectedType = FunnelType.webinar;

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.7,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      expand: false,
      builder: (context, scrollController) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            children: [
              // Handle
              Container(
                margin: const EdgeInsets.symmetric(vertical: 12),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              // Header
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: [
                    const Text(
                      'Crear Nuevo Funnel',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Spacer(),
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.close),
                    ),
                  ],
                ),
              ),
              const Divider(),
              // Form
              Expanded(
                child: ListView(
                  controller: scrollController,
                  padding: const EdgeInsets.all(20),
                  children: [
                    Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Title
                          TextFormField(
                            controller: _titleController,
                            decoration: const InputDecoration(
                              labelText: 'Título',
                              hintText: 'Ej: Webinar de Lanzamiento',
                              border: OutlineInputBorder(),
                            ),
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'El título es requerido';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),
                          // Type selector
                          const Text(
                            'Tipo de Funnel',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Wrap(
                            spacing: 8,
                            children: FunnelType.values.map((type) {
                              return FilterChip(
                                label: Text(_getTypeLabel(type)),
                                selected: _selectedType == type,
                                onSelected: (selected) {
                                  setState(() {
                                    _selectedType = type;
                                  });
                                },
                                selectedColor: Colors.purple,
                                labelStyle: const TextStyle(
                                  color: Colors.white,
                                ),
                              );
                            }).toList(),
                          ),
                          const SizedBox(height: 16),
                          // Description
                          TextFormField(
                            controller: _descriptionController,
                            maxLines: 3,
                            decoration: const InputDecoration(
                              labelText: 'Descripción',
                              hintText: 'Describe qué hace este funnel...',
                              border: OutlineInputBorder(),
                            ),
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'La descripción es requerida';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 24),
                          // Submit button
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () => _createFunnel(context),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.purple,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(vertical: 16),
                              ),
                              child: const Text(
                                'Crear Funnel',
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
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  String _getTypeLabel(FunnelType type) {
    switch (type) {
      case FunnelType.webinar:
        return 'Webinar';
      case FunnelType.leadMagnet:
        return 'Lead Magnet';
      case FunnelType.product:
        return 'Product Launch';
      case FunnelType.webinarSequence:
        return 'Webinar Sequence';
    }
  }

  void _createFunnel(BuildContext context) {
    if (!_formKey.currentState!.validate()) return;

    final funnel = FunnelModel(
      funnelId: '',
      userId: '', // Will be set in Bloc
      title: _titleController.text,
      description: _descriptionController.text,
      type: _selectedType,
      status: FunnelStatus.draft,
      steps: [],
      metrics: FunnelMetrics(funnelId: ''),
      createdAt: DateTime.now(),
    );

    context.read<FunnelBloc>().add(FunnelCreateRequested(funnel));
    Navigator.pop(context);
  }
}

/// Bottom sheet con detalles del funnel
class _FunnelDetailSheet extends StatelessWidget {
  final FunnelModel funnel;

  const _FunnelDetailSheet({required this.funnel});

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.8,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      expand: false,
      builder: (context, scrollController) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            children: [
              // Handle
              Container(
                margin: const EdgeInsets.symmetric(vertical: 12),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              // Header
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            funnel.title,
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            funnel.typeLabel,
                            style: TextStyle(
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.close),
                    ),
                  ],
                ),
              ),
              const Divider(),
              // Content
              Expanded(
                child: ListView(
                  controller: scrollController,
                  padding: const EdgeInsets.all(20),
                  children: [
                    // Description
                    _buildSection('Descripción', funnel.description),
                    // Metrics
                    _buildMetricsSection(),
                    // Steps
                    _buildStepsSection(),
                    const SizedBox(height: 20),
                    // Action buttons
                    Row(
                      children: [
                        Expanded(
                          child: _buildActionButton(
                            icon: Icons.edit,
                            label: 'Editar',
                            color: Colors.blue,
                            onTap: () => _editFunnel(context),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildActionButton(
                            icon: Icons.play_arrow,
                            label: 'Activar',
                            color: Colors.green,
                            onTap: () => _activateFunnel(context),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSection(String title, String content) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            content,
            style: TextStyle(
              color: Colors.grey[700],
              fontSize: 14,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMetricsSection() {
    return Card(
      color: Colors.purple.shade50,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Métricas',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            _buildMetricRow(
              'Visitantes',
              '${funnel.metrics.totalVisitors}',
              Icons.people,
              Colors.blue,
            ),
            const SizedBox(height: 8),
            _buildMetricRow(
              'Leads Capturados',
              '${funnel.metrics.leadsCaptured}',
              Icons.mail,
              Colors.orange,
            ),
            const SizedBox(height: 8),
            _buildMetricRow(
              'Webinar Registrados',
              '${funnel.metrics.webinarsRegistered}',
              Icons.event,
              Colors.purple,
            ),
            const SizedBox(height: 8),
            _buildMetricRow(
              'Asistentes',
              '${funnel.metrics.webinarsAttended}',
              Icons.videocam,
              Colors.green,
            ),
            const SizedBox(height: 8),
            _buildMetricRow(
              'Ventas',
              '${funnel.metrics.sales}',
              Icons.shopping_cart,
              Colors.red,
            ),
            const SizedBox(height: 8),
            _buildMetricRow(
              'Tasa de Conversión',
              '${funnel.metrics.conversionRate.toStringAsFixed(1)}%',
              Icons.trending_up,
              Colors.indigo,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMetricRow(String label, String value, IconData icon, Color color) {
    return Row(
      children: [
        Icon(icon, size: 20, color: color),
        const SizedBox(width: 12),
        Expanded(child: Text(label, style: TextStyle(fontSize: 14))),
        Text(
          value,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: color,
            fontSize: 14,
          ),
        ),
      ],
    );
  }

  Widget _buildStepsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Pasos del Funnel',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        ...List.generate(funnel.steps.length, (index) {
          final step = funnel.steps[index];
          return _buildStepCard(step, index);
        }),
      ],
    );
  }

  Widget _buildStepCard(FunnelStep step, int index) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: Colors.purple,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(
                child: Text(
                  '${index + 1}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    step.title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                  Text(
                    step.description,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              step.isCompleted ? Icons.check_circle : Icons.radio_button_unchecked,
              color: step.isCompleted ? Colors.green : Colors.grey,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return ElevatedButton.icon(
      onPressed: onTap,
      icon: Icon(icon),
      label: Text(label),
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 12),
      ),
    );
  }

  void _editFunnel(BuildContext context) {
    // TODO: Implement edit functionality
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Función de edición próximamente')),
    );
  }

  void _activateFunnel(BuildContext context) {
    // TODO: Implement activate functionality
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Función de activación próximamente')),
    );
  }
}
