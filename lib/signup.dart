import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(GoogleSignupApp());
}

class GoogleSignupApp extends StatefulWidget {
  @override
  _GoogleSignupAppState createState() => _GoogleSignupAppState();
}

class _GoogleSignupAppState extends State<GoogleSignupApp>
    with SingleTickerProviderStateMixin {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  late AnimationController _drawerAnimationController;
  late Animation<Offset> _drawerAnimation;
  late Animation<Offset> _homeAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<double> _opacityAnimation;

  bool isDrawerOpen = false;

  @override
  void initState() {
    super.initState();
    _drawerAnimationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
    );
    _drawerAnimation = Tween<Offset>(
      begin: Offset(-1.0, 0),
      end: Offset(0, 0),
    ).animate(
      CurvedAnimation(
        parent: _drawerAnimationController,
        curve: Curves.easeInOut,
      ),
    );
    _homeAnimation = Tween<Offset>(
      begin: Offset(0, 0),
      end: Offset(0.5, 0),
    ).animate(
      CurvedAnimation(
        parent: _drawerAnimationController,
        curve: Curves.easeInOut,
      ),
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.8,
    ).animate(
      CurvedAnimation(
        parent: _drawerAnimationController,
        curve: Curves.easeInOut,
      ),
    );
    _opacityAnimation = Tween<double>(
      begin: 1.0,
      end: 0.5,
    ).animate(
      CurvedAnimation(
        parent: _drawerAnimationController,
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  void dispose() {
    _drawerAnimationController.dispose();
    super.dispose();
  }

  Future<UserCredential?> _handleGoogleSignIn() async {
    final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
    final GoogleSignInAuthentication googleAuth =
    await googleUser!.authentication;
    final AuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    return await _auth.signInWithCredential(credential);
  }

  void _toggleDrawer() {
    setState(() {
      isDrawerOpen = !isDrawerOpen;
      if (isDrawerOpen) {
        _drawerAnimationController.forward();
      } else {
        _drawerAnimationController.reverse();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Google Sign Up'),
        ),
        body: Stack(
          children: [
            SlideTransition(
              position: _homeAnimation,
              child: AnimatedOpacity(
                opacity: isDrawerOpen ? _opacityAnimation.value : 1.0,
                duration: Duration(milliseconds: 300),
                child: ScaleTransition(
                  scale: _scaleAnimation,
                  child: Container(
                    color: Colors.blueGrey[100],
                    child: Center(
                      child: Text(
                        'Google Sign Up000',
                        style: TextStyle(
                            fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            SlideTransition(
              position: _drawerAnimation,
              child: GestureDetector(
                onTap: () {
                  if (isDrawerOpen) {
                    _toggleDrawer();
                  }
                },
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.7,
                  color: Colors.blueGrey[50],
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        padding:
                        EdgeInsets.symmetric(vertical: 50, horizontal: 20),
                        child: Text(
                          'Drawer Header',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      ListTile(
                        title: Text('Google Sign Up'),
                        onTap: () {
                          _handleGoogleSignIn();
                          _toggleDrawer();
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
            AnimatedPositioned(
              duration: Duration(milliseconds: 300),
              left: isDrawerOpen ? MediaQuery.of(context).size.width * 0.7 : 0,
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                color: Colors.black.withOpacity(isDrawerOpen ? 0.5 : 0),
              ),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: _toggleDrawer,
          child: AnimatedIcon(
            icon: AnimatedIcons.menu_close,
            progress: _drawerAnimationController,
          ),
        ),
        backgroundColor: Colors.white,
      ),
    );
  }
}
