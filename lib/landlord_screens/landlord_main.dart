import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rental_connect/theme_provider.dart';
import 'upload_form_steps.dart';
import 'models/property.dart';
import 'property_upload_form.dart';
import 'property_list_screen.dart';
import 'landlord_profile_screen.dart';
import 'landlord_bottom_navbar.dart';

class LandlordMainApp extends StatefulWidget {
  const LandlordMainApp({super.key});

  @override
  State<LandlordMainApp> createState() => _LandlordMainAppState();
}

class _LandlordMainAppState extends State<LandlordMainApp> {
  int _currentTab = 0;

  @override
  Widget build(BuildContext context) {
    final screens = [const PropertyListScreen(), const LandlordProfileScreen()];
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
              body: screens[_currentTab],
              bottomNavigationBar: LandlordBottomNavBar(
                currentIndex: _currentTab,
                onTap: (i) => setState(() => _currentTab = i),
                onCreate: () => setState(() => _currentTab = 0),
              ),
              floatingActionButton: _currentTab == 0
                  ? FloatingActionButton(
                      onPressed: () {
                        // The create button is handled in PropertyListScreen
                      },
                      child: const Icon(Icons.add),
                      shape: const CircleBorder(),
                    )
                  : null,
              floatingActionButtonLocation:
                  FloatingActionButtonLocation.centerDocked,
            ),
          );
        },
      ),
    );
  }
}
