import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:ionicons/ionicons.dart';

import '../../services/auth_service.dart';
import '../../theme/app_theme.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();
  bool _showPassword = false;
  bool _showConfirmPassword = false;
  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  bool _validateForm() {
    if (_nameController.text.trim().isEmpty ||
        _emailController.text.trim().isEmpty ||
        _passwordController.text.trim().isEmpty ||
        _confirmController.text.trim().isEmpty) {
      _showMessage('Error', 'Please fill in all fields');
      return false;
    }
    if (!_emailController.text.contains('@')) {
      _showMessage('Error', 'Please enter a valid email address');
      return false;
    }
    if (_passwordController.text.length < 6) {
      _showMessage('Error', 'Password must be at least 6 characters long');
      return false;
    }
    if (_passwordController.text != _confirmController.text) {
      _showMessage('Error', 'Passwords do not match');
      return false;
    }
    return true;
  }

  Future<void> _handleRegister() async {
    if (!_validateForm()) return;
    setState(() => _isLoading = true);
    try {
      final auth = context.read<AuthService>();
      final success = await auth.register(
        _nameController.text.trim(),
        _emailController.text.trim(),
        _passwordController.text.trim(),
      );
      if (success && mounted) {
        _showMessage('Success', 'Account created successfully! Welcome to Elderly Companion.', onOk: () {
          context.go('/home');
        });
      }
    } catch (_) {
      _showMessage('Error', 'An error occurred during registration');
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void _showMessage(String title, String message, {VoidCallback? onOk}) {
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              onOk?.call();
            },
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
              Stack(
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: IconButton(
                      onPressed: () => context.pop(),
                      icon: Icon(Ionicons.arrow_back, color: colors.text),
                    ),
                  ),
                  Column(
                    children: [
                      const SizedBox(height: 8),
                      Icon(Ionicons.person_add, size: 80, color: colors.tint),
                      const SizedBox(height: 24),
                      Text(
                        'Create Account',
                        style: TextStyle(
                          color: colors.text,
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Join Elderly Companion to stay connected',
                        style: TextStyle(color: colors.icon, fontSize: 16, height: 1.5),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 32),
              _InputField(
                label: 'Full Name',
                icon: Ionicons.person_outline,
                controller: _nameController,
                keyboardType: TextInputType.name,
                colors: colors,
              ),
              const SizedBox(height: 20),
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
              Padding(
                padding: const EdgeInsets.only(top: 4, left: 4),
                child: Text('Must be at least 6 characters', style: TextStyle(color: colors.icon, fontSize: 12)),
              ),
              const SizedBox(height: 20),
              _InputField(
                label: 'Confirm Password',
                icon: Ionicons.lock_closed_outline,
                controller: _confirmController,
                obscureText: !_showConfirmPassword,
                colors: colors,
                suffix: IconButton(
                  icon: Icon(
                    _showConfirmPassword ? Ionicons.eye_off_outline : Ionicons.eye_outline,
                    color: colors.icon,
                  ),
                  onPressed: () => setState(() => _showConfirmPassword = !_showConfirmPassword),
                ),
              ),
              const SizedBox(height: 20),
              Wrap(
                alignment: WrapAlignment.center,
                children: [
                  Text('By creating an account, you agree to our ', style: TextStyle(color: colors.icon)),
                  Text('Terms of Service', style: TextStyle(color: colors.tint, fontWeight: FontWeight.w600)),
                  Text(' and ', style: TextStyle(color: colors.icon)),
                  Text('Privacy Policy', style: TextStyle(color: colors.tint, fontWeight: FontWeight.w600)),
                ],
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _isLoading ? null : _handleRegister,
                style: ElevatedButton.styleFrom(
                  backgroundColor: colors.tint,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: Text(
                  _isLoading ? 'Creating Account...' : 'Create Account',
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
                  Text('Already have an account? ', style: TextStyle(color: colors.icon)),
                  TextButton(
                    onPressed: () => context.push('/login'),
                    child: Text('Sign In', style: TextStyle(color: colors.tint, fontWeight: FontWeight.w600)),
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
