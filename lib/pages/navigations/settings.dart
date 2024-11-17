import 'package:criptop/provider/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      minimum: const EdgeInsets.symmetric(vertical: 56),
      child: ListView(
        children: [
          _buildSettingItem(
            'Update Password',
            Icons.lock,
            onTap: () => Navigator.pushNamed(context, '/update-password'),
          ),
          _buildSettingItem('Notification Settings', Icons.notifications),
          _buildSettingItem('Privacy Policy', Icons.privacy_tip),
          _buildSettingItem('Terms of Service', Icons.description),
          _buildSettingItem('Contact Support', Icons.support_agent),
          _buildSettingItem('About', Icons.info),
          const Divider(),
          _buildSettingItem(
            'Logout',
            Icons.exit_to_app,
            onTap: () {
              context.read<AuthProvider>().logout(context);
              Navigator.pushReplacementNamed(context, '/login');
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSettingItem(String title, IconData icon, {VoidCallback? onTap}) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }
}
