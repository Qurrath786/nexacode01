import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:async';
import 'package:flutter/services.dart';

class TerminalLoginScreen extends StatefulWidget {
  const TerminalLoginScreen({super.key});

  @override
  State<TerminalLoginScreen> createState() => _TerminalLoginScreenState();
}

class _TerminalLoginScreenState extends State<TerminalLoginScreen>
    with SingleTickerProviderStateMixin {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final FocusNode _emailFocus = FocusNode();

  String _statusMessage = '';
  bool _isLoading = false;
  String _asciiWelcome = '';
  int _asciiIndex = 0;
  Timer? _asciiTimer;
  Timer? _cursorTimer;
  bool _showCursor = true;

  late AnimationController _shakeController;
  late Animation<double> _shakeAnimation;

  final List<String> _asciiArt = [
    ' _   _                 _            ',
    '| \\ | | _____      __| | ___ _ __  ',
    '|  \\| |/ _ \\ \\ /\\ / /| |/ _ \\ \'__| ',
    '| |\\  |  __/\\ V  V / | |  __/ |    ',
    '|_| \\_|\\___| \\_/\\_/  |_|\\___|_|    ',
    '        Welcome to NexaCode        ',
  ];

  @override
  void initState() {
    super.initState();
    _startAsciiAnimation();

    _shakeController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    _shakeAnimation = Tween<double>(
      begin: 0,
      end: 24,
    ).chain(CurveTween(curve: Curves.elasticIn)).animate(_shakeController);

    _cursorTimer = Timer.periodic(const Duration(milliseconds: 500), (timer) {
      setState(() {
        _showCursor = !_showCursor;
      });
    });
  }

  void _startAsciiAnimation() {
    _asciiTimer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
      if (_asciiIndex < _asciiArt.length) {
        setState(() {
          _asciiWelcome += '${_asciiArt[_asciiIndex]}\n';
          _asciiIndex++;
        });
      } else {
        _asciiTimer?.cancel();
        FocusScope.of(context).requestFocus(_emailFocus);
      }
    });
  }

  void _triggerShake() {
    _shakeController.forward(from: 0);
  }

  Future<void> _login() async {
    setState(() {
      _isLoading = true;
      _statusMessage = '>> Authenticating... █';
    });

    try {
      final userCredential =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      setState(() {
        _statusMessage = '>> Access granted. Welcome, coder. █';
      });

      Navigator.of(context)
          .pushReplacementNamed('/home', arguments: userCredential.user);
    } on FirebaseAuthException catch (e) {
      _triggerShake();
      setState(() {
        _statusMessage = '>> FirebaseAuth error: ${e.message} █';
      });
    } catch (e) {
      _triggerShake();
      setState(() {
        _statusMessage = '>> General error: ${e.toString()} █';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _register() async {
    setState(() {
      _isLoading = true;
      _statusMessage = '>> Creating account... █';
    });

    try {
      final userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      setState(() {
        _statusMessage = '>> Registration successful. Welcome, coder. █';
      });

      Navigator.of(context)
          .pushReplacementNamed('/home', arguments: userCredential.user);
    } on FirebaseAuthException catch (e) {
      _triggerShake();
      setState(() {
        _statusMessage = '>> FirebaseAuth error: ${e.message} █';
      });
    } catch (e) {
      _triggerShake();
      setState(() {
        _statusMessage = '>> General error: ${e.toString()} █';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _anonymousLogin() async {
    setState(() {
      _isLoading = true;
      _statusMessage = '>> Connecting anonymously... █';
    });

    try {
      final userCredential = await FirebaseAuth.instance.signInAnonymously();

      setState(() {
        _statusMessage = '>> Anonymous access granted. █';
      });

      Navigator.of(context)
          .pushReplacementNamed('/home', arguments: userCredential.user);
    } catch (e) {
      _triggerShake();
      setState(() {
        _statusMessage = '>> Anonymous login failed: ${e.toString()} █';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _asciiTimer?.cancel();
    _cursorTimer?.cancel();
    _shakeController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final fadedGreen = Colors.greenAccent.withAlpha(_showCursor ? 255 : 153);

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          Positioned.fill(
            child: Opacity(
              opacity: 0.05,
              child: Image.asset(
                'assets/images/nexa_logo.png',
                fit: BoxFit.cover,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: Center(
              child: SingleChildScrollView(
                child: AnimatedBuilder(
                  animation: _shakeAnimation,
                  builder: (context, child) {
                    return Transform.translate(
                      offset: Offset(_shakeAnimation.value, 0),
                      child: child!,
                    );
                  },
                  child: KeyboardListener(
                    focusNode: FocusNode(),
                    onKeyEvent: (event) {
                      if (event is KeyDownEvent &&
                          HardwareKeyboard.instance
                              .isLogicalKeyPressed(LogicalKeyboardKey.enter) &&
                          !_isLoading) {
                        _login();
                      }
                    },
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _asciiWelcome.isEmpty
                              ? '>> Loading ASCII...'
                              : _asciiWelcome,
                          style: TextStyle(
                            fontFamily: 'FiraCode',
                            color: fadedGreen,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 32),
                        _buildTerminalInput('Email', _emailController,
                            focusNode: _emailFocus),
                        const SizedBox(height: 16),
                        _buildTerminalInput('Password', _passwordController,
                            obscure: true),
                        const SizedBox(height: 24),
                        Wrap(
                          spacing: 16,
                          runSpacing: 12,
                          children: [
                            _buildGlowingButton(
                              key: const Key('loginButton'),
                              label: '>> Login',
                              onPressed: _isLoading ? null : _login,
                              isLoading: _isLoading,
                            ),
                            _buildGlowingButton(
                              label: '>> Register',
                              onPressed: _isLoading ? null : _register,
                              isLoading: _isLoading,
                            ),
                            _buildGlowingButton(
                              label: '>> Anonymous',
                              onPressed: _isLoading ? null : _anonymousLogin,
                              isLoading: _isLoading,
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),
                        Text(
                          _statusMessage,
                          style: const TextStyle(
                            fontFamily: 'FiraCode',
                            color: Colors.greenAccent,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTerminalInput(
    String label,
    TextEditingController controller, {
    bool obscure = false,
    FocusNode? focusNode,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontFamily: 'FiraCode',
            color: Colors.greenAccent,
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          obscureText: obscure,
          focusNode: focusNode,
          style: const TextStyle(
            fontFamily: 'FiraCode',
            color: Colors.greenAccent,
            fontSize: 14,
          ),
          cursorColor: Colors.greenAccent,
          decoration: const InputDecoration(
            filled: true,
            fillColor: Colors.black,
            border: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.greenAccent),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.greenAccent),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.greenAccent),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildGlowingButton({
    required String label,
    required VoidCallback? onPressed,
    bool isLoading = false,
    Key? key,
  }) {
    return ElevatedButton(
      key: key,
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.greenAccent,
        foregroundColor: Colors.black,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        elevation: 8,
        shadowColor: Colors.greenAccent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      child: Text(
        isLoading ? '>> Running...' : label,
        style: const TextStyle(
          fontFamily: 'FiraCode',
          fontSize: 14,
        ),
      ),
    );
  }
}
