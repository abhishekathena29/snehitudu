import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ionicons/ionicons.dart';
import 'package:provider/provider.dart';

import '../../models/app_user.dart';
import '../../services/auth_service.dart';
import '../../theme/app_theme.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  AppUser? _localUser;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final user = context.read<AuthService>().user;
    if (user != null && _localUser == null) {
      _localUser = user;
    }
  }

  Future<void> _updateUser(AppUser updated) async {
    setState(() => _localUser = updated);
    await context.read<AuthService>().updateUserProfile(updated);
  }

  void _editField(String field, String currentValue) {
    final controller = TextEditingController(text: currentValue);
    showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Edit ${_titleCase(field)}'),
          content: TextField(
            controller: controller,
            keyboardType: field == 'age' ? TextInputType.number : TextInputType.text,
            decoration: InputDecoration(
              hintText: 'Enter $field',
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            ),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('Cancel')),
            TextButton(
              onPressed: () async {
                final value = controller.text.trim();
                if (value.isEmpty) return;
                Navigator.of(context).pop();
                final user = _localUser;
                if (user == null) return;
                AppUser updated;
                if (field == 'name') {
                  updated = user.copyWith(name: value);
                } else if (field == 'age') {
                  updated = user.copyWith(age: int.tryParse(value) ?? user.age);
                } else if (field == 'emergencyContact') {
                  updated = user.copyWith(emergencyContact: value);
                } else if (field == 'medicalInfo') {
                  updated = user.copyWith(medicalInfo: value);
                } else {
                  updated = user;
                }
                await _updateUser(updated);
                _showMessage('Success', 'Profile updated successfully!');
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  void _showMessage(String title, String message) {
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('OK'))],
      ),
    );
  }

  String _titleCase(String text) {
    if (text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1);
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppThemeColors.of(context);
    final user = _localUser ?? context.watch<AuthService>().user;
    if (user == null) {
      return Scaffold(
        backgroundColor: colors.background,
        body: Center(child: Text('No user data', style: TextStyle(color: colors.text))),
      );
    }

    return Scaffold(
      backgroundColor: colors.background,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Profile', style: TextStyle(color: colors.text, fontSize: 24, fontWeight: FontWeight.bold)),
                  IconButton(
                    onPressed: () => _editField('name', user.name),
                    icon: Icon(Ionicons.create_outline, color: colors.tint),
                  ),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    const SizedBox(height: 12),
                    Column(
                      children: [
                        Container(
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(color: colors.tint.withOpacity(0.2), shape: BoxShape.circle),
                          child: Icon(Ionicons.person, color: colors.tint, size: 48),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Flexible(
                              child: Text(
                                user.name,
                                style: TextStyle(color: colors.text, fontSize: 24, fontWeight: FontWeight.bold),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            IconButton(
                              onPressed: () => _editField('name', user.name),
                              icon: Icon(Ionicons.create_outline, color: colors.tint, size: 18),
                              tooltip: 'Edit username',
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(user.email, style: TextStyle(color: colors.icon, fontSize: 16)),
                        if ((user.age ?? 0) > 0)
                          Text('${user.age} years old', style: TextStyle(color: colors.icon, fontSize: 14)),
                      ],
                    ),
                    const SizedBox(height: 30),
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: colors.background,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: colors.icon.withOpacity(0.4)),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.08),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Personal Information', style: TextStyle(color: colors.text, fontSize: 18, fontWeight: FontWeight.bold)),
                          const SizedBox(height: 16),
                          _InfoRow(
                            icon: Ionicons.person_outline,
                            label: 'Username',
                            value: user.name,
                            colors: colors,
                            onTap: () => _editField('name', user.name),
                          ),
                          _InfoRow(
                            icon: Ionicons.call_outline,
                            label: 'Emergency Contact',
                            value: user.emergencyContact ?? 'Tap to add',
                            colors: colors,
                            onTap: () => _editField('emergencyContact', user.emergencyContact ?? ''),
                          ),
                          _InfoRow(
                            icon: Ionicons.medical_outline,
                            label: 'Medical Information',
                            value: user.medicalInfo ?? 'Tap to add',
                            colors: colors,
                            onTap: () => _editField('medicalInfo', user.medicalInfo ?? ''),
                          ),
                          _InfoRow(
                            icon: Ionicons.calendar_outline,
                            label: 'Age',
                            value: (user.age ?? 0) == 0 ? 'Tap to add' : user.age.toString(),
                            colors: colors,
                            onTap: () => _editField('age', user.age?.toString() ?? ''),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    OutlinedButton.icon(
                      onPressed: () async {
                        final authService = context.read<AuthService>();
                        final router = GoRouter.of(context);
                        final confirmed = await _confirmLogout();
                        if (!confirmed || !mounted) return;
                        await authService.logout();
                        if (!mounted) return;
                        router.go('/login');
                      },
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                        side: const BorderSide(color: Color(0xFFFF3B30)),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      icon: const Icon(Ionicons.log_out_outline, color: Color(0xFFFF3B30), size: 20),
                      label: const Text('Logout', style: TextStyle(color: Color(0xFFFF3B30), fontWeight: FontWeight.w600)),
                    ),
                    const SizedBox(height: 30),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<bool> _confirmLogout() async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(onPressed: () => Navigator.of(context).pop(false), child: const Text('Cancel')),
          TextButton(onPressed: () => Navigator.of(context).pop(true), child: const Text('Logout')),
        ],
      ),
    );
    return result ?? false;
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
    required this.colors,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final String value;
  final AppThemeColors colors;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 16),
        child: Row(
          children: [
            Icon(icon, color: colors.icon, size: 20),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(label, style: TextStyle(color: colors.icon, fontSize: 12)),
                  const SizedBox(height: 4),
                  Text(value, style: TextStyle(color: colors.text, fontSize: 16, fontWeight: FontWeight.w500)),
                ],
              ),
            ),
            Icon(Ionicons.chevron_forward, color: colors.icon, size: 16),
          ],
        ),
      ),
    );
  }
}
