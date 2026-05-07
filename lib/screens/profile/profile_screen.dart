import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:provider/provider.dart';

import '../../models/app_user.dart';
import '../../services/profile_service.dart';
import '../../theme/app_theme.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  void _editField(BuildContext context, String field, String currentValue) {
    final controller = TextEditingController(text: currentValue);
    final service = context.read<ProfileService>();
    showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: Text('Edit ${_titleCase(field)}'),
          content: TextField(
            controller: controller,
            keyboardType: field == 'age'
                ? TextInputType.number
                : TextInputType.text,
            style: const TextStyle(fontSize: 18),
            decoration: InputDecoration(
              hintText: 'Enter $field',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                final value = controller.text.trim();
                if (value.isEmpty) return;
                Navigator.of(dialogContext).pop();
                final user = service.profile;
                AppUser updated;
                if (field == 'name') {
                  updated = user.copyWith(name: value);
                } else if (field == 'age') {
                  updated = user.copyWith(age: int.tryParse(value) ?? user.age);
                } else if (field == 'emergencyContact') {
                  updated = user.copyWith(emergencyContact: value);
                } else {
                  updated = user;
                }
                await service.update(updated);
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  String _titleCase(String text) {
    if (text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1);
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppThemeColors.of(context);
    final user = context.watch<ProfileService>().profile;

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
                  Text(
                    'Profile',
                    style: TextStyle(
                      color: colors.text,
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    onPressed: () => _editField(context, 'name', user.name),
                    icon: Icon(Ionicons.create_outline, color: colors.tint),
                    iconSize: 28,
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
                          width: 110,
                          height: 110,
                          decoration: BoxDecoration(
                            color: colors.tint.withOpacity(0.2),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Ionicons.person,
                            color: colors.tint,
                            size: 56,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Flexible(
                              child: Text(
                                user.name,
                                style: TextStyle(
                                  color: colors.text,
                                  fontSize: 26,
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            IconButton(
                              onPressed: () =>
                                  _editField(context, 'name', user.name),
                              icon: Icon(
                                Ionicons.create_outline,
                                color: colors.tint,
                                size: 22,
                              ),
                              tooltip: 'Edit name',
                            ),
                          ],
                        ),
                        if ((user.age ?? 0) > 0)
                          Padding(
                            padding: const EdgeInsets.only(top: 4),
                            child: Text(
                              '${user.age} years old',
                              style:
                                  TextStyle(color: colors.icon, fontSize: 16),
                            ),
                          ),
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
                          Text(
                            'Personal Information',
                            style: TextStyle(
                              color: colors.text,
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 16),
                          _InfoRow(
                            icon: Ionicons.person_outline,
                            label: 'Name',
                            value: user.name,
                            colors: colors,
                            onTap: () =>
                                _editField(context, 'name', user.name),
                          ),
                          _InfoRow(
                            icon: Ionicons.call_outline,
                            label: 'Emergency Contact',
                            value: user.emergencyContact?.isNotEmpty == true
                                ? user.emergencyContact!
                                : 'Tap to add',
                            colors: colors,
                            onTap: () => _editField(
                              context,
                              'emergencyContact',
                              user.emergencyContact ?? '',
                            ),
                          ),
                          _InfoRow(
                            icon: Ionicons.calendar_outline,
                            label: 'Age',
                            value: (user.age ?? 0) == 0
                                ? 'Tap to add'
                                : user.age.toString(),
                            colors: colors,
                            onTap: () => _editField(
                                context, 'age', user.age?.toString() ?? ''),
                          ),
                        ],
                      ),
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
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Row(
          children: [
            Icon(icon, color: colors.icon, size: 24),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: TextStyle(color: colors.icon, fontSize: 14),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    value,
                    style: TextStyle(
                      color: colors.text,
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            Icon(Ionicons.chevron_forward, color: colors.icon, size: 20),
          ],
        ),
      ),
    );
  }
}
