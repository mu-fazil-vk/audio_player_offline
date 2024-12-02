// Custom Page Route Animations

// 1. Slide Up Animation
import 'dart:ui';

import 'package:flutter/material.dart';

class SlideUpPageRoute extends PageRouteBuilder {
  final Widget child;

  SlideUpPageRoute({required this.child})
      : super(
          pageBuilder: (context, animation, secondaryAnimation) => child,
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            const begin = Offset(0.0, 1.0);
            const end = Offset.zero;
            const curve = Curves.easeInOut;

            var tween =
                Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
            var offsetAnimation = animation.drive(tween);

            return SlideTransition(
              position: offsetAnimation,
              child: child,
            );
          },
          transitionDuration: const Duration(milliseconds: 300),
        );
}

// 2. Fade and Scale Animation
class FadeScalePageRoute extends PageRouteBuilder {
  final Widget child;

  FadeScalePageRoute({required this.child})
      : super(
          pageBuilder: (context, animation, secondaryAnimation) => child,
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            const curve = Curves.easeInOut;

            var fadeAnimation = CurvedAnimation(
              parent: animation,
              curve: curve,
            );

            return FadeTransition(
              opacity: fadeAnimation,
              child: ScaleTransition(
                scale: Tween<double>(
                  begin: 0.95,
                  end: 1.0,
                ).animate(fadeAnimation),
                child: child,
              ),
            );
          },
          transitionDuration: const Duration(milliseconds: 300),
        );
}

// 3. Expand From Mini Player Animation
class ExpandFromMiniPlayerRoute extends PageRouteBuilder {
  final Widget child;
  final Rect miniPlayerRect;

  ExpandFromMiniPlayerRoute({
    required this.child,
    required this.miniPlayerRect,
  }) : super(
          pageBuilder: (context, animation, secondaryAnimation) => child,
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return Stack(
              children: [
                // Background fade animation
                FadeTransition(
                  opacity: animation,
                  child: Container(color: Colors.black54),
                ),
                // Content animation
                AnimatedBuilder(
                  animation: animation,
                  builder: (context, child) {
                    final double progress =
                        Curves.easeInOut.transform(animation.value);

                    // Calculate the animated position and size
                    final double left = lerpDouble(
                      miniPlayerRect.left,
                      0,
                      progress,
                    )!;
                    final double top = lerpDouble(
                      miniPlayerRect.top,
                      0,
                      progress,
                    )!;
                    final double width = lerpDouble(
                      miniPlayerRect.width,
                      MediaQuery.of(context).size.width,
                      progress,
                    )!;
                    final double height = lerpDouble(
                      miniPlayerRect.height,
                      MediaQuery.of(context).size.height,
                      progress,
                    )!;

                    return Positioned(
                      left: left,
                      top: top,
                      width: width,
                      height: height,
                      child: child!,
                    );
                  },
                  child: child,
                ),
              ],
            );
          },
          transitionDuration: const Duration(milliseconds: 500),
          opaque: false,
        );
}
