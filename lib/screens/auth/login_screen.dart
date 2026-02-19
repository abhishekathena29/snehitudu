import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:ionicons/ionicons.dart';

import '../../services/auth_service.dart';
import '../../theme/app_theme.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _showPassword = false;
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      _showMessage('Error', 'Please fill in all fields');
      return;
    }

    if (!email.contains('@')) {
      _showMessage('Error', 'Please enter a valid email address');
      return;
    }

    setState(() => _isLoading = true);

    try {
      final auth = context.read<AuthService>();
      final success = await auth.login(email, password);
      if (success && mounted) {
        context.go('/home');
      }
    } catch (_) {
      _showMessage('Error', 'An error occurred during login');
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void _showMessage(String title, String message) {
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppThemeColors.of(context);

    return Scaffold(
      backgroundColor: colors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 24),
              Column(
                children: [
                  Icon(Ionicons.heart, size: 80, color: colors.tint),
                  const SizedBox(height: 24),
                  Text(
                    'Welcome Back',
                    style: TextStyle(
                      color: colors.text,
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Sign in to your Elderly Companion account',
                    style: TextStyle(color: colors.icon, fontSize: 16, height: 1.5),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
              const SizedBox(height: 40),
              _InputField(
                label: 'Email Address',
                icon: Ionicons.mail_outline,
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                colors: colors,
              ),
              const SizedBox(height: 20),
              _InputField(
                label: 'Password',
                icon: Ionicons.lock_closed_outline,
                controller: _passwordController,
                obscureText: !_showPassword,
                colors: colors,
                suffix: IconButton(
                  icon: Icon(
                    _showPassword ? Ionicons.eye_off_outline : Ionicons.eye_outline,
                    color: colors.icon,
                  ),
                  onPressed: () => setState(() => _showPassword = !_showPassword),
                ),
              ),
              const SizedBox(height: 12),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {},
                  child: Text('Forgot Password?', style: TextStyle(color: colors.tint)),
                ),
              ),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: _isLoading ? null : _handleLogin,
                style: ElevatedButton.styleFrom(
                  backgroundColor: colors.tint,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: Text(
                  _isLoading ? 'Signing In...' : 'Sign In',
                  style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600),
                ),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(child: Divider(color: colors.icon.withOpacity(0.5))),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text('or', style: TextStyle(color: colors.icon)),
                  ),
                  Expanded(child: Divider(color: colors.icon.withOpacity(0.5))),
                ],
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Don\'t have an account? ', style: TextStyle(color: colors.icon)),
                  TextButton(
                    onPressed: () => context.push('/register'),
                    child: Text('Sign Up', style: TextStyle(color: colors.tint, fontWeight: FontWeight.w600)),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _InputField extends StatelessWidget {
  const _InputField({
    required this.label,
    required this.icon,
    required this.controller,
    required this.colors,
    this.keyboardType,
    this.obscureText = false,
    this.suffix,
  });

  final String label;
  final IconData icon;
  final TextEditingController controller;
  final AppThemeColors colors;
  final TextInputType? keyboardType;
  final bool obscureText;
  final Widget? suffix;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(color: colors.text, fontSize: 16, fontWeight: FontWeight.w600)),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: colors.icon),
            borderRadius: BorderRadius.circular(12),
            color: Colors.black.withOpacity(0.02),
          ),
          child: TextField(
            controller: controller,
            keyboardType: keyboardType,
            obscureText: obscureText,
            decoration: InputDecoration(
              prefixIcon: Icon(icon, color: colors.icon, size: 20),
              suffixIcon: suffix,
              hintText: 'Enter your ${label.toLowerCase()}',
              hintStyle: TextStyle(color: colors.icon),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            ),
            style: TextStyle(color: colors.text, fontSize: 16),
          ),
        ),
      ],
    );
  }
}
