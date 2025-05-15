import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../theme/app_theme.dart';
import '../widgets/custom_widgets.dart';
import 'game_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 20),
    )..repeat();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedGradientBackground(
        colors: [
          AppTheme.backgroundColor,
          AppTheme.primaryColor.withOpacity(0.5),
          AppTheme.backgroundColor,
        ],
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // App Title
                Animate(
                  effects: [
                    FadeEffect(duration: 800.ms),
                    SlideEffect(
                      begin: const Offset(0, -0.2),
                      end: const Offset(0, 0),
                      duration: 800.ms,
                    ),
                  ],
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.auto_awesome,
                        color: AppTheme.primaryColor,
                        size: 36,
                      ),
                      const SizedBox(width: 12),
                      AnimatedTextKit(
                        animatedTexts: [
                          TypewriterAnimatedText(
                            'WORD MASTER',
                            textStyle: Theme.of(context).textTheme.displaySmall?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                            speed: const Duration(milliseconds: 150),
                          ),
                        ],
                        totalRepeatCount: 1,
                        displayFullTextOnTap: true,
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 8),

                // Subtitle
                Animate(
                  effects: [
                    FadeEffect(duration: 800.ms, delay: 400.ms),
                  ],
                  child: Center(
                    child: Text(
                      'The Ultimate Word Guessing Game',
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: AppTheme.textSecondary,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),

                const SizedBox(height: 40),

                // Category Selection Title
                Animate(
                  effects: [
                    FadeEffect(duration: 800.ms, delay: 800.ms),
                    SlideEffect(
                      begin: const Offset(0, 0.2),
                      end: const Offset(0, 0),
                      duration: 800.ms,
                      delay: 800.ms,
                    ),
                  ],
                  child: Text(
                    'Choose a Category',
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                ),

                const SizedBox(height: 24),

                // Category Buttons
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        // Countries Button
                        Animate(
                          effects: [
                            FadeEffect(duration: 800.ms, delay: 1000.ms),
                            SlideEffect(
                              begin: const Offset(-0.2, 0),
                              end: const Offset(0, 0),
                              duration: 800.ms,
                              delay: 1000.ms,
                            ),
                          ],
                          child: GradientButton(
                            text: 'Countries',
                            icon: Icons.public,
                            gradient: AppTheme.countriesGradient,
                            onPressed: () => _navigateToGameScreen('Countries'),
                          ),
                        ),

                        const SizedBox(height: 16),

                        // Animals Button
                        Animate(
                          effects: [
                            FadeEffect(duration: 800.ms, delay: 1200.ms),
                            SlideEffect(
                              begin: const Offset(0.2, 0),
                              end: const Offset(0, 0),
                              duration: 800.ms,
                              delay: 1200.ms,
                            ),
                          ],
                          child: GradientButton(
                            text: 'Animals',
                            icon: Icons.pets,
                            gradient: AppTheme.animalsGradient,
                            onPressed: () => _navigateToGameScreen('Animals'),
                          ),
                        ),

                        const SizedBox(height: 16),

                        // Foods Button
                        Animate(
                          effects: [
                            FadeEffect(duration: 800.ms, delay: 1400.ms),
                            SlideEffect(
                              begin: const Offset(-0.2, 0),
                              end: const Offset(0, 0),
                              duration: 800.ms,
                              delay: 1400.ms,
                            ),
                          ],
                          child: GradientButton(
                            text: 'Foods',
                            icon: Icons.restaurant,
                            gradient: AppTheme.foodsGradient,
                            onPressed: () => _navigateToGameScreen('Foods'),
                          ),
                        ),

                        const SizedBox(height: 40),

                        // How to Play Section
                        Animate(
                          effects: [
                            FadeEffect(duration: 800.ms, delay: 1600.ms),
                          ],
                          child: GlassCard(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    const Icon(
                                      Icons.help_outline,
                                      color: AppTheme.secondaryColor,
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      'How to Play',
                                      style: Theme.of(context).textTheme.titleLarge,
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 16),
                                _buildInstructionItem(
                                  context,
                                  '1',
                                  'Choose a category and guess the word',
                                ),
                                const SizedBox(height: 8),
                                _buildInstructionItem(
                                  context,
                                  '2',
                                  'Bulls (🎯) = correct letter in correct position',
                                ),
                                const SizedBox(height: 8),
                                _buildInstructionItem(
                                  context,
                                  '3',
                                  'Cows (🐄) = correct letter in wrong position',
                                ),
                                const SizedBox(height: 8),
                                _buildInstructionItem(
                                  context,
                                  '4',
                                  'You have 8 attempts to guess the word',
                                ),
                              ],
                            ),
                          ),
                        ),

                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInstructionItem(BuildContext context, String number, String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 24,
          height: 24,
          decoration: BoxDecoration(
            color: AppTheme.primaryColor.withOpacity(0.2),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Center(
            child: Text(
              number,
              style: TextStyle(
                color: AppTheme.primaryColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            text,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ),
      ],
    );
  }

  void _navigateToGameScreen(String category) {
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => GameScreen(category: category),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(1.0, 0.0);
          const end = Offset.zero;
          const curve = Curves.easeInOut;

          var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
          var offsetAnimation = animation.drive(tween);

          return SlideTransition(
            position: offsetAnimation,
            child: child,
          );
        },
        transitionDuration: const Duration(milliseconds: 500),
      ),
    );
  }
}
