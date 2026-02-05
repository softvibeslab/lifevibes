import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:lifevibes/core/constants/firebase_constants.dart';
import 'package:lifevibes/core/theme/app_theme.dart';
import 'package:lifevibes/features/auth/bloc/auth_bloc.dart';
import 'package:lifevibes/features/onboarding/bloc/onboarding_bloc.dart';
import 'package:lifevibes/features/avatar/bloc/avatar_bloc.dart';
import 'package:lifevibes/features/poppy/bloc/coach_chat_bloc.dart';
import 'package:lifevibes/features/poppy/services/poppy_service.dart';
import 'package:lifevibes/features/match/bloc/match_bloc.dart';
import 'package:lifevibes/features/quest/bloc/quest_bloc.dart';
import 'package:lifevibes/features/funnel/bloc/funnel_bloc.dart';
import 'package:lifevibes/features/product/bloc/product_bloc.dart';
import 'package:lifevibes/features/onboarding/presentation/pages/onboarding_screen.dart';
import 'package:lifevibes/features/avatar/pages/avatar_page.dart';
import 'package:lifevibes/features/poppy/pages/coach_page.dart';
import 'package:lifevibes/features/match/pages/match_page.dart';
import 'package:lifevibes/features/quest/pages/quest_page.dart';
import 'package:lifevibes/features/funnel/pages/funnel_page.dart';
import 'package:lifevibes/features/product/pages/product_page.dart';
import 'package:lifevibes/features/home/presentation/pages/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  await Firebase.initializeApp(
    name: FirebaseConstants.projectId,
    options: const FirebaseOptions(
      apiKey: 'AIzaSyC_3lh9a6tTnAeLACJp2notPRCLDDxCsAY',
      appId: '1:712287218180:android:7dbc4b2c8ed84fe0a72351',
      messagingSenderId: '712287218180',
      projectId: 'lifevibes-e5915',
      storageBucket: 'lifevibes-e5915.firebasestorage.app',
      databaseURL: 'https://lifevibes-e5915-default-rtdb.firebaseio.com',
    ),
  );

  // Initialize Firebase services
  final firestore = FirebaseFirestore.instance;
  final functions = FirebaseFunctions.instance;
  final auth = FirebaseAuth.instance;

  runApp(LifeVibesApp(
    firestore: firestore,
    functions: functions,
    auth: auth,
  ));
}

class LifeVibesApp extends StatelessWidget {
  final FirebaseFirestore firestore;
  final FirebaseFunctions functions;
  final FirebaseAuth auth;

  const LifeVibesApp({
    super.key,
    required this.firestore,
    required this.functions,
    required this.auth,
  });

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => AuthBloc(auth)),
        BlocProvider(create: (_) => OnboardingBloc()),
        BlocProvider(
          create: (_) => AvatarBloc(firestore),
        ),
        BlocProvider(
          create: (_) => CoachChatBloc(PoppyService()),
        ),
        BlocProvider(
          create: (_) => MatchBloc(firestore, auth),
        ),
        BlocProvider(
          create: (_) => QuestBloc(firestore, auth, functions),
        ),
        BlocProvider(
          create: (_) => FunnelBloc(firestore, auth),
        ),
        BlocProvider(
          create: (_) => ProductBloc(firestore, auth),
        ),
      ],
      child: MaterialApp(
        title: 'LifeVibes',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.darkTheme,
        home: const SplashScreen(),
        routes: {
          '/avatar': (context) => const AvatarPage(),
          '/coach': (context) => const CoachPage(),
          '/match': (context) => const MatchPage(),
          '/quest': (context) => const QuestPage(),
          '/funnel': (context) => const FunnelPage(),
          '/product': (context) => const ProductPage(),
          '/home': (context) => const HomeScreen(),
        },
        onGenerateRoute: (settings) {
          switch (settings.name) {
            case '/':
              return MaterialPageRoute(
                builder: (_) => const OnboardingScreen(),
              );
            default:
              return null;
          }
        },
      ),
    );
  }
}

/// Splash screen for loading and initial checks
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    );

    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );

    _controller.forward();

    // Check authentication status after animation
    Future.delayed(const Duration(milliseconds: 2500), () {
      _checkAuthAndNavigate();
    });
  }

  Future<void> _checkAuthAndNavigate() async {
    // TODO: Implement auth check
    // For now, navigate to onboarding
    if (mounted) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (_) => const OnboardingScreen(),
        ),
      );
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
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
        child: Center(
          child: FadeTransition(
            opacity: _animation,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // TODO: Replace with actual LifeVibes logo
                Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    gradient: AppColors.primaryGradient,
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: const Icon(
                    Icons.favorite,
                    size: 60,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  'LifeVibes',
                  style: Theme.of(context).textTheme.displayMedium?.copyWith(
                        color: Colors.white,
                      ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Transforma tu talento en una empresa digital',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppColors.textSecondary,
                      ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
