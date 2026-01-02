import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import '../utils/colors.dart';
import '../utils/constants.dart';
import 'dashboard_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});
  
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _logoController;
  late AnimationController _textController;
  late Animation<double> _logoAnimation;
  late Animation<double> _textAnimation;
  
  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _startSplashSequence();
  }
  
  void _initializeAnimations() {
    _logoController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    
    _textController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    
    _logoAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _logoController,
      curve: Curves.elasticOut,
    ));
    
    _textAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _textController,
      curve: Curves.easeInOut,
    ));
  }
  
  Future<void> _startSplashSequence() async {
    await Future.delayed(const Duration(milliseconds: 500));
    _logoController.forward();
    
    await Future.delayed(const Duration(milliseconds: 800));
    _textController.forward();
    
    await Future.delayed(const Duration(milliseconds: 2000));
    
    if (mounted) {
      Navigator.of(context).pushReplacement(
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) =>
              const DashboardScreen(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(opacity: animation, child: child);
          },
          transitionDuration: const Duration(milliseconds: 800),
        ),
      );
    }
  }
  
  @override
  void dispose() {
    _logoController.dispose();
    _textController.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedBuilder(
              animation: _logoAnimation,
              builder: (context, child) {
                return Transform.scale(
                  scale: _logoAnimation.value,
                  child: Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      color: AppColors.background,
                      borderRadius: BorderRadius.circular(30),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.shadow,
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.account_balance_wallet,
                      size: 60,
                      color: AppColors.primary,
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: AppConstants.largePadding),
            AnimatedBuilder(
              animation: _textAnimation,
              builder: (context, child) {
                return Opacity(
                  opacity: _textAnimation.value,
                  child: Column(
                    children: [
                      const Text(
                        AppConstants.appName,
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textWhite,
                          letterSpacing: 1.2,
                        ),
                      ),
                      const SizedBox(height: AppConstants.smallPadding),
                      Text(
                        AppConstants.tagline,
                        style: TextStyle(
                          fontSize: 16,
                          color: AppColors.textWhite.withOpacity(0.9),
                          letterSpacing: 0.5,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
            const SizedBox(height: 60),
            const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(AppColors.textWhite),
              strokeWidth: 2,
            ),
          ],
        ),
      ),
    );
  }
}