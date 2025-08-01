import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rental_connect/theme_provider.dart';
import 'upload_form_steps.dart';
import 'models/property.dart';
import 'property_upload_form.dart';
import 'property_list_screen.dart';
import 'landlord_profile_screen.dart';
import 'landlord_bottom_navbar.dart';
import 'landlord_messages_screen.dart';

class LandlordMainApp extends StatefulWidget {
  const LandlordMainApp({super.key});

  @override
  State<LandlordMainApp> createState() => _LandlordMainAppState();
}

class AnalyticsScreen extends StatelessWidget {
  const AnalyticsScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('Analytics'));
  }
}

class _LandlordMainAppState extends State<LandlordMainApp> {
  int _currentTab = 0;

  @override
  Widget build(BuildContext context) {
    final screens = [
      const PropertyListScreen(), // 0: Home
      const LandlordMessagesScreen(), // 1: Messages (landlord)
      const AnalyticsScreen(), // 2: Analytics
      const LandlordProfileScreen(), // 3: Profile
    ];
    return ChangeNotifierProvider(
      create: (_) => ThemeProvider(),
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, _) {
          return MaterialApp(
            title: 'Landlord Portal',
            theme: ThemeProvider.lightTheme,
            darkTheme: ThemeProvider.darkTheme,
            themeMode: themeProvider.themeMode,
            home: Scaffold(
              body: SafeArea(bottom: false, child: screens[_currentTab]),
              bottomNavigationBar: LandlordBottomNavBar(
                currentIndex: _currentTab,
                onTap: (i) => setState(() => _currentTab = i),
                onCreate: () => setState(() => _currentTab = 0),
              ),
              floatingActionButton: LandlordFAB(
                onCreate: () async {
                  // Open the property upload form
                  final property = await Navigator.push<Property>(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PropertyUploadForm(
                        onSubmit: (property) =>
                            Navigator.pop(context, property),
                      ),
                    ),
                  );
                  // Optionally handle the new property (e.g., refresh list)
                },
              ),
              floatingActionButtonLocation:
                  FloatingActionButtonLocation.centerDocked,
            ),
          );
        },
      ),
    );
  }
}
