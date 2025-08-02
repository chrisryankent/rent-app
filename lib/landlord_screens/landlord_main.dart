import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rental_connect/theme_provider.dart';
import '../models/property.dart';
import 'property_upload_form.dart' as upload_form;
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
  final List<Property> _properties = List<Property>.from(Property.sampleData);
  final String _currentLandlordId = 'landlord123';

  void _addProperty(Property property) {
    setState(() {
      // Assign current landlord ID to new property
      _properties.insert(
        0,
        Property(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          ownerId: _currentLandlordId,
          createdAt: DateTime.now(),
          status: PropertyStatus.active,
          title: property.title,
          propertyTypes: property.propertyTypes,
          rentAmount: property.rentAmount,
          address: property.address,
          description: property.description,
          securityDeposit: property.securityDeposit,
          availableDate: property.availableDate,
          bedrooms: property.bedrooms,
          bathrooms: property.bathrooms,
          squareFootage: property.squareFootage,
          furnishingStatus: property.furnishingStatus,
          floorLevel: property.floorLevel,
          totalFloors: property.totalFloors,
          heatingType: property.heatingType,
          coolingType: property.coolingType,
          kitchenAppliances: property.kitchenAppliances,
          images: property.images,
          amenities: property.amenities,
          laundryFacilities: property.laundryFacilities,
          parking: property.parking,
          petPolicy: property.petPolicy,
          accessibilityFeatures: property.accessibilityFeatures,
          neighborhoodDesc: property.neighborhoodDesc,
          transportationAccess: property.transportationAccess,
          photos: property.photos,
          virtualTourUrl: property.virtualTourUrl,
          videoWalkthrough: property.videoWalkthrough,
          minLeaseMonths: property.minLeaseMonths,
          leaseType: property.leaseType,
          applicationRequirements: property.applicationRequirements,
          smokingPolicy: property.smokingPolicy,
          guestPolicy: property.guestPolicy,
          noiseRestrictions: property.noiseRestrictions,
          maintenanceResponsibilities: property.maintenanceResponsibilities,
          sublettingPolicy: property.sublettingPolicy,
          contactMethod: property.contactMethod,
          showingSchedule: property.showingSchedule,
          contactName: property.contactName,
          contactRole: property.contactRole,
          safetyCertifications: property.safetyCertifications,
          buildingPermits: property.buildingPermits,
          rentalLicenseNumber: property.rentalLicenseNumber,
          energyRating: property.energyRating,
          parks: property.parks,
          restaurants: property.restaurants,
          groceries: property.groceries,
          communityFeatures: property.communityFeatures,
          renovations: property.renovations,
          specialFeatures: property.specialFeatures,
          usp: property.usp,
        ),
      );
    });
  }

  void _editProperty(int index, Property updated) {
    setState(() {
      _properties[index] = updated;
    });
  }

  void _deleteProperty(int index) {
    setState(() {
      _properties.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    final screens = [
      PropertyListScreen(
        onCreateProperty: () {
          // Open the property upload form
          Navigator.push<Property>(
            context,
            MaterialPageRoute(
              builder: (context) => upload_form.PropertyUploadForm(
                onSubmit: (property) {
                  _addProperty(property);
                },
              ),
            ),
          );
        },
        currentTabIndex: 0,
        onTabTapped: (int index) {
          setState(() {
            _currentTab = index;
          });
        },
      ), // 0: Home
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
                      builder: (context) => upload_form.PropertyUploadForm(
                        onSubmit: (property) =>
                            Navigator.pop(context, property),
                      ),
                    ),
                  );
                  if (property != null) {
                    _addProperty(property);
                  }
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
