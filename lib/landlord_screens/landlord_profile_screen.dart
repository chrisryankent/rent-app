import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rental_connect/login_screen.dart';
import 'package:rental_connect/theme_provider.dart';

class LandlordProfileScreen extends StatelessWidget {
  const LandlordProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDark = themeProvider.themeMode == ThemeMode.dark;
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'My Profile',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: theme.appBarTheme.backgroundColor,
        foregroundColor: theme.appBarTheme.foregroundColor,
        iconTheme: theme.appBarTheme.iconTheme,
        titleTextStyle: theme.appBarTheme.titleTextStyle,
        actions: [
          IconButton(
            icon: Icon(isDark ? Icons.light_mode : Icons.dark_mode),
            tooltip: isDark ? 'Switch to Light Mode' : 'Switch to Dark Mode',
            onPressed: () {
              themeProvider.toggleTheme(!isDark);
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Profile header
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: theme.cardColor,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: theme.shadowColor.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  const CircleAvatar(
                    radius: 40,
                    backgroundImage: AssetImage('lib/assets/rent.webp'),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Landlord Name', // TODO: Fetch landlord name
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'landlord@email.com', // TODO: Fetch landlord email
                          style: TextStyle(
                            color: theme.textTheme.bodySmall?.color?.withOpacity(0.7),
                          ),
                        ),
                        const SizedBox(height: 8),
                        OutlinedButton(
                          onPressed: () {},
                          style: OutlinedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            side: BorderSide(color: theme.colorScheme.primary),
                          ),
                          child: Text(
                            'Edit Profile',
                            style: TextStyle(color: theme.colorScheme.primary),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            // Stats
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: theme.cardColor,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: theme.shadowColor.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildStat('8', 'Properties', Icons.home_work, theme),
                  _buildStat('3', 'Tenants', Icons.people, theme),
                  _buildStat('5', 'Messages', Icons.message, theme),
                  _buildStat('2', 'Active', Icons.verified, theme),
                ],
              ),
            ),
            // Settings
            const SizedBox(height: 20),
            Container(
              decoration: BoxDecoration(
                color: theme.cardColor,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: theme.shadowColor.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                children: [
                  _buildListTile(Icons.notifications_active, 'Notifications', theme),
                  _buildListTile(Icons.security, 'Privacy & Security', theme),
                  _buildListTile(Icons.settings, 'App Settings', theme),
                  _buildListTile(Icons.help_center, 'Help & Support', theme),
                  _buildListTile(Icons.info, 'About', theme),
                ],
              ),
            ),
            // Logout
            const SizedBox(height: 20),
            Container(
              decoration: BoxDecoration(
                color: theme.cardColor,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: theme.shadowColor.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: ListTile(
                leading: const Icon(Icons.logout, color: Colors.red),
                title: const Text(
                  'Logout',
                  style: TextStyle(color: Colors.red),
                ),
                onTap: () {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => const LoginScreen()),
                    (route) => false,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStat(
    String value,
    String label,
    IconData icon,
    ThemeData theme,
  ) {
    return Column(
      children: [
        Icon(icon, size: 24, color: theme.colorScheme.primary),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: theme.textTheme.bodySmall?.color?.withOpacity(0.7),
          ),
        ),
      ],
    );
  }

  Widget _buildListTile(IconData icon, String title, ThemeData theme) {
    return Column(
      children: [
        ListTile(
          leading: Icon(icon, color: theme.colorScheme.primary),
          title: Text(title),
          trailing: Icon(Icons.chevron_right, color: theme.dividerColor),
          onTap: () {},
        ),
        Divider(
          height: 0,
          indent: 20,
          endIndent: 20,
          color: theme.dividerColor,
        ),
      ],
    );
  }
}
