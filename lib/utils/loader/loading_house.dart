import 'dart:async';

import 'package:expenso/core/constants/colors.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;

class LoadingHouse extends StatefulWidget {
  const LoadingHouse({super.key});

  @override
  State<LoadingHouse> createState() => _LoadingHouseState();
}

class _LoadingHouseState extends State<LoadingHouse>
    with TickerProviderStateMixin {
  late AnimationController _leftWallController;
  late AnimationController _rightWallController;
  late AnimationController _leftRoofController;
  late AnimationController _rightRoofController;

  late Animation<double> _leftWallRotation;
  late Animation<double> _rightWallRotation;
  late Animation<double> _leftRoofRotation;
  late Animation<double> _rightRoofRotation;
  late Animation<Offset> _leftRoofPosition;
  late Animation<Offset> _rightRoofPosition;

  bool _disposed = false;
  Timer? _animationTimer;

  @override
  void initState() {
    super.initState();

    // Left Wall Animation - matches CSS 10% to 20%
    _leftWallController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );
    _leftWallRotation = Tween<double>(begin: 0, end: -math.pi / 2).animate(
      CurvedAnimation(
        parent: _leftWallController,
        curve: const Interval(0.1, 0.2, curve: Curves.easeOut),
      ),
    );

    // Right Wall Animation - matches CSS 20% to 40%
    _rightWallController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );
    _rightWallRotation = Tween<double>(begin: 0, end: math.pi / 2).animate(
      CurvedAnimation(
        parent: _rightWallController,
        curve: const Interval(0.2, 0.4, curve: Curves.easeOut),
      ),
    );

    // Left Roof Animation - matches CSS 40% to 60%
    _leftRoofController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );
    _leftRoofRotation =
        Tween<double>(
          begin: 0,
          end: -math.pi / 5.14, // -35 degrees
        ).animate(
          CurvedAnimation(
            parent: _leftRoofController,
            curve: const Interval(0.4, 0.6, curve: Curves.easeOut),
          ),
        );
    _leftRoofPosition =
        Tween<Offset>(
          begin: const Offset(0, 0),
          end: const Offset(-7, -23), // Matches CSS left: -7px, bottom: 100%
        ).animate(
          CurvedAnimation(
            parent: _leftRoofController,
            curve: const Interval(0.4, 0.6, curve: Curves.easeOut),
          ),
        );

    // Right Roof Animation - matches CSS 60% to 80%
    _rightRoofController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );
    _rightRoofRotation =
        Tween<double>(
          begin: 0,
          end: math.pi / 5.14, // 35 degrees
        ).animate(
          CurvedAnimation(
            parent: _rightRoofController,
            curve: const Interval(0.6, 0.8, curve: Curves.easeOut),
          ),
        );
    _rightRoofPosition =
        Tween<Offset>(
          begin: const Offset(0, 0),
          end: const Offset(7, -23), // Matches CSS left: 7px, bottom: 100%
        ).animate(
          CurvedAnimation(
            parent: _rightRoofController,
            curve: const Interval(0.6, 0.8, curve: Curves.easeOut),
          ),
        );

    startAnimationCycle();
  }

  void startAnimationCycle() {
    if (_disposed) return;

    _leftWallController.forward();
    _rightWallController.forward();
    _leftRoofController.forward();
    _rightRoofController.forward();

    // Schedule next cycle
    _animationTimer?.cancel();
    _animationTimer = Timer(const Duration(milliseconds: 2000), () {
      if (!_disposed) {
        _leftWallController.reset();
        _rightWallController.reset();
        _leftRoofController.reset();
        _rightRoofController.reset();
        startAnimationCycle();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 110,
      height: 110,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Bottom Line
          Positioned(
            bottom: 20,
            child: Container(
              width: 36,
              height: 3,
              decoration: BoxDecoration(
                color: TColors.white,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),

          // Left Wall
          AnimatedBuilder(
            animation: _leftWallRotation,
            builder: (context, child) {
              return Positioned(
                bottom: 20,
                left: 37,
                child: Transform.rotate(
                  angle: _leftWallRotation.value,
                  alignment: Alignment.topLeft,
                  child: Container(
                    width: 24,
                    height: 3,
                    decoration: BoxDecoration(
                      color: TColors.white,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
              );
            },
          ),

          // Right Wall
          AnimatedBuilder(
            animation: _rightWallRotation,
            builder: (context, child) {
              return Positioned(
                bottom: 20,
                right: 37,
                child: Transform.rotate(
                  angle: _rightWallRotation.value,
                  alignment: Alignment.topRight,
                  child: Container(
                    width: 24,
                    height: 3,
                    decoration: BoxDecoration(
                      color: TColors.white,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
              );
            },
          ),

          // Left Roof
          AnimatedBuilder(
            animation: Listenable.merge([_leftRoofRotation, _leftRoofPosition]),
            builder: (context, child) {
              return Positioned(
                bottom: 20,
                left: 37,
                child: Transform.translate(
                  offset: _leftRoofPosition.value,
                  child: Transform.rotate(
                    angle: _leftRoofRotation.value,
                    alignment: Alignment.bottomLeft,
                    child: Container(
                      width: 33,
                      height: 3,
                      decoration: BoxDecoration(
                        color: TColors.white,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),

          // Right Roof
          AnimatedBuilder(
            animation: Listenable.merge([
              _rightRoofRotation,
              _rightRoofPosition,
            ]),
            builder: (context, child) {
              return Positioned(
                bottom: 20,
                right: 37,
                child: Transform.translate(
                  offset: _rightRoofPosition.value,
                  child: Transform.rotate(
                    angle: _rightRoofRotation.value,
                    alignment: Alignment.bottomRight,
                    child: Container(
                      width: 33,
                      height: 3,
                      decoration: BoxDecoration(
                        color: TColors.white,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _disposed = true;
    _animationTimer?.cancel();
    _leftWallController.dispose();
    _rightWallController.dispose();
    _leftRoofController.dispose();
    _rightRoofController.dispose();
    super.dispose();
  }
}
