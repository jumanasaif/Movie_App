import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeIn;
  late Animation<Offset> _slideUp;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    _fadeIn = CurvedAnimation(parent: _controller, curve: Curves.easeIn);
    _slideUp = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final size = MediaQuery.of(context).size;
    final isTablet = size.width > 600;
    final isDesktop = size.width > 1000;

    double titleFontSize = isDesktop
        ? 100
        : isTablet
        ? 80
        : 60;
    double subtitleFontSize = isTablet ? 20 : 16;
    double buttonFontSize = isTablet ? 20 : 16;
    double verticalPadding = isTablet ? 120 : 80;

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset('assets/images/movieBG.png', fit: BoxFit.cover),

          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.black87, Colors.transparent, Colors.black],
                begin: Alignment.center,
                end: Alignment.topCenter,
                stops: [0.0, 0.5, 1.0],
              ),
            ),
          ),

          LayoutBuilder(
            builder: (context, constraints) {
              return Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: isDesktop
                      ? constraints.maxWidth * 0.2
                      : isTablet
                      ? 60
                      : 30,
                  vertical: verticalPadding,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    FadeTransition(
                      opacity: _fadeIn,
                      child: Text(
                        'Movie Zone',
                        textAlign: TextAlign.center,
                        style: theme.textTheme.displayLarge?.copyWith(
                          fontFamily: 'Bilbo',
                          fontSize: titleFontSize,
                          color: colorScheme.secondary,
                          letterSpacing: 1.5,
                        ),
                      ),
                    ),
                    const SizedBox(height: 15),
                    FadeTransition(
                      opacity: _fadeIn,
                      child: Text(
                        'Unlimited Movies, TV Shows, and More',
                        textAlign: TextAlign.center,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: colorScheme.onSurface.withOpacity(0.8),
                          fontSize: subtitleFontSize,
                        ),
                      ),
                    ),
                    SizedBox(height: isTablet ? 80 : 60),

                    SlideTransition(
                      position: _slideUp,
                      child: Wrap(
                        alignment: WrapAlignment.center,
                        spacing: 16,
                        runSpacing: 16,
                        children: [
                          ElevatedButton(
                            onPressed: () => context.go('/signup'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: colorScheme.primary,
                              foregroundColor: colorScheme.onPrimary,
                              padding: EdgeInsets.symmetric(
                                vertical: isTablet ? 18 : 14,
                                horizontal: isTablet ? 80 : 60,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                            ),
                            child: Text(
                              'Get Started',
                              style: TextStyle(fontSize: buttonFontSize),
                            ),
                          ),
                          OutlinedButton(
                            onPressed: () => context.go('/login'),
                            style: OutlinedButton.styleFrom(
                              side: BorderSide(color: colorScheme.onSurface),
                              padding: EdgeInsets.symmetric(
                                vertical: isTablet ? 18 : 14,
                                horizontal: isTablet ? 80 : 60,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                            ),
                            child: Text(
                              'Login',
                              style: TextStyle(
                                color: colorScheme.onSurface,
                                fontSize: buttonFontSize,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
