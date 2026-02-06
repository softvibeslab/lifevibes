import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_animate/flutter_animate.dart';

import 'package:lifevibes/core/theme/app_theme.dart';
import 'package:lifevibes/features/auth/bloc/auth_bloc.dart';
import 'package:lifevibes/features/onboarding/bloc/onboarding_bloc.dart';
import 'package:lifevibes/features/onboarding/bloc/onboarding_event.dart';
import 'package:lifevibes/features/onboarding/bloc/onboarding_state.dart';

/// Onboarding screen (Ritual de Origen)
class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  int _currentStep = 0;
  final PageController _pageController = PageController();

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _nextStep() {
    if (_currentStep < 2) {
      setState(() {
        _currentStep++;
      });
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      context.read<OnboardingBloc>().add(const OnboardingComplete());
      context.read<AuthBloc>().add(AuthLoginRequested(
            email: 'demo@lifevibes.com',
            password: 'demo123',
          ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF1A1A2E), Color(0xFF16213E)],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Progress indicator
              Padding(
                padding: const EdgeInsets.all(24),
                child: Row(
                  children: List.generate(
                    3,
                    (index) => Expanded(
                      child: Container(
                        margin: EdgeInsets.only(
                          right: index < 2 ? 8 : 0,
                        ),
                        height: 4,
                        decoration: BoxDecoration(
                          color: index <= _currentStep
                              ? AppColors.primary
                              : AppColors.card,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              // PageView
              Expanded(
                child: PageView.builder(
                  controller: _pageController,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: 3,
                  itemBuilder: (context, index) {
                    return _buildStep(index);
                  },
                ),
              ),
              // Next button
              Padding(
                padding: const EdgeInsets.all(24),
                child: SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: _nextStep,
                    child: Text(
                      _currentStep < 2 ? 'Continuar' : 'Comenzar',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStep(int step) {
    switch (step) {
      case 0:
        return _buildValuesStep();
      case 1:
        return _buildPassionsStep();
      case 2:
        return _buildPurposeStep();
      default:
        return const SizedBox.shrink();
    }
  }

  /// Step 1: Values (El Espejo del Alma)
  Widget _buildValuesStep() {
    return BlocBuilder<OnboardingBloc, OnboardingState>(
      builder: (context, state) {
        final availableValues = OnboardingBloc.availableValues;
        final selectedValues = state is OnboardingValuesStep
            ? state.selectedValues
            : <String>[];

        return Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Ritual de Origen',
                style: Theme.of(context).textTheme.headlineLarge,
              ).animate().fadeIn(duration: 300.ms),
              const SizedBox(height: 12),
              Text(
                'Selecciona tus valores fundamentales',
                style: Theme.of(context).textTheme.bodyLarge,
              ).animate().fadeIn(delay: 100.ms, duration: 300.ms),
              const SizedBox(height: 32),
              Expanded(
                child: Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: availableValues.map((value) {
                    final isSelected = selectedValues.contains(value);
                    return FilterChip(
                      label: Text(value),
                      selected: isSelected,
                      onSelected: (selected) {
                        if (selected) {
                          context
                              .read<OnboardingBloc>()
                              .add(OnboardingSaveValues([...selectedValues, value]));
                        }
                      },
                      backgroundColor: AppColors.card,
                      selectedColor: AppColors.primary,
                      labelStyle: TextStyle(
                        color: isSelected ? Colors.white : AppColors.textPrimary,
                      ),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  /// Step 2: Passions (La Forja del Superpoder)
  Widget _buildPassionsStep() {
    return BlocBuilder<OnboardingBloc, OnboardingState>(
      builder: (context, state) {
        final availablePassions = OnboardingBloc.availablePassions;
        final selectedPassions = state is OnboardingPassionsStep
            ? state.selectedPassions
            : <String>[];

        return Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'La Forja del Superpoder',
                style: Theme.of(context).textTheme.headlineLarge,
              ).animate().fadeIn(duration: 300.ms),
              const SizedBox(height: 12),
              Text(
                'Selecciona tus pasiones principales',
                style: Theme.of(context).textTheme.bodyLarge,
              ).animate().fadeIn(delay: 100.ms, duration: 300.ms),
              const SizedBox(height: 32),
              Expanded(
                child: Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: availablePassions.map((passion) {
                    final isSelected = selectedPassions.contains(passion);
                    return FilterChip(
                      label: Text(passion),
                      selected: isSelected,
                      onSelected: (selected) {
                        if (selected) {
                          context.read<OnboardingBloc>().add(
                              OnboardingSavePassions([...selectedPassions, passion]));
                        }
                      },
                      backgroundColor: AppColors.card,
                      selectedColor: AppColors.secondary,
                      labelStyle: TextStyle(
                        color: isSelected ? Colors.white : AppColors.textPrimary,
                      ),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  /// Step 3: Purpose statement
  Widget _buildPurposeStep() {
    final TextEditingController purposeController = TextEditingController();

    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Tu Propósito',
            style: Theme.of(context).textTheme.headlineLarge,
          ).animate().fadeIn(duration: 300.ms),
          const SizedBox(height: 12),
          Text(
            '¿Cuál es tu propósito mayor en la vida?',
            style: Theme.of(context).textTheme.bodyLarge,
          ).animate().fadeIn(delay: 100.ms, duration: 300.ms),
          const SizedBox(height: 32),
          TextField(
            controller: purposeController,
            maxLines: 5,
            style: const TextStyle(
              color: AppColors.textPrimary,
              fontSize: 16,
            ),
            decoration: InputDecoration(
              filled: true,
              fillColor: AppColors.card,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              hintText: 'Escribe tu propósito...',
              hintStyle: TextStyle(
                color: AppColors.textSecondary,
              ),
            ),
          ).animate().fadeIn(delay: 200.ms, duration: 300.ms),
        ],
      ),
    );
  }
}
