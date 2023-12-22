import 'dart:async';


import 'package:Chat.On/login-signup.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';


class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _logoScaleAnimation;
  late Animation<double> _logoRotationAnimation;
  late Animation<double> _textOpacityAnimation;
  late Animation<Offset> _textPositionAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 2),
    );

    _logoScaleAnimation = Tween<double>(begin: 0.5, end: 1).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Interval(0, 0.5, curve: Curves.easeInOut),
      ),
    );

    _logoRotationAnimation = Tween<double>(begin: 0, end: 2 * 3.141).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Interval(0, 0.5, curve: Curves.easeInOut),
      ),
    );

    _textOpacityAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Interval(0.5, 1, curve: Curves.easeInOut),
      ),
    );

    _textPositionAnimation = Tween<Offset>(
      begin: Offset(0, 1),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Interval(0.5, 1, curve: Curves.easeInOut),
      ),
    );

    _animationController.forward();
    _animationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => loginpage()),
        );
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.white,
        alignment: Alignment.center,
        child: AnimatedBuilder(
          animation: _animationController,
          builder: (context, child) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Transform.scale(
                  scale: _logoScaleAnimation.value,
                  child: Transform.rotate(
                      angle: _logoRotationAnimation.value,
                      child: Image.asset('assets/img/Logo.png',height: 150,width: 150,)
                  ),
                ),
                SizedBox(height: 20),
                SlideTransition(
                  position: _textPositionAnimation,
                  child: Opacity(
                    opacity: _textOpacityAnimation.value,
                    child:  Text(
                      'CHAT.ON',
                      style: GoogleFonts.laila(color: Color(0xFF338C1D),
                          fontWeight: FontWeight.bold,
                          fontSize: 25),
                    )
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}