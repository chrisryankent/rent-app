import 'package:flutter/material.dart';
import 'models/property.dart';
import 'upload_form_steps.dart' as steps;

class PropertyUploadForm extends StatefulWidget {
  final void Function(Property) onSubmit;
  final Property? initialProperty;
  const PropertyUploadForm({
    super.key,
    required this.onSubmit,
    this.initialProperty,
  });

  @override
  State<PropertyUploadForm> createState() => _PropertyUploadFormState();
}

class _PropertyUploadFormState extends State<PropertyUploadForm> {
  int _currentStep = 0;
  final int _totalSteps = steps.UploadFormSteps.steps.length;
  final Map<String, dynamic> _formData = {};
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  void _nextStep() {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() {
        if (_currentStep < _totalSteps - 1) {
          _currentStep++;
        } else {
          // Submit
          final property = _buildPropertyFromData();
          widget.onSubmit(property);
        }
      });
    }
  }

  void _prevStep() {
    setState(() {
      if (_currentStep > 0) _currentStep--;
    });
  }

  Property _buildPropertyFromData() {
    // TODO: Map _formData to Property fields
    return Property(
      title: _formData['title'] ?? '',
      propertyType: _formData['propertyType'] ?? steps.PropertyType.apartment,
      rentAmount:
          double.tryParse(_formData['rentAmount']?.toString() ?? '0') ?? 0,
      securityDeposit:
          double.tryParse(_formData['securityDeposit']?.toString() ?? '0') ?? 0,
      availableDate: _formData['availableDate'] ?? DateTime.now(),
      bedrooms: int.tryParse(_formData['bedrooms']?.toString() ?? '1') ?? 1,
      bathrooms: int.tryParse(_formData['bathrooms']?.toString() ?? '1') ?? 1,
      squareFootage:
          double.tryParse(_formData['squareFootage']?.toString() ?? '0') ?? 0,
      furnishingStatus:
          _formData['furnishingStatus'] ?? FurnishingStatus.unfurnished,
      floorLevel: int.tryParse(_formData['floorLevel']?.toString() ?? '1') ?? 1,
      totalFloors:
          int.tryParse(_formData['totalFloors']?.toString() ?? '1') ?? 1,
      heatingType: _formData['heatingType'] ?? HeatingType.none,
      coolingType: _formData['coolingType'] ?? CoolingType.none,
      kitchenAppliances: List<String>.from(
        _formData['kitchenAppliances'] ?? [],
      ),
      laundryFacilities: _formData['laundryFacilities'] ?? '',
      parking: _formData['parking'] ?? '',
      petPolicy: _formData['petPolicy'] ?? '',
      accessibilityFeatures: List<String>.from(
        _formData['accessibilityFeatures'] ?? [],
      ),
      address: _formData['address'] ?? '',
      neighborhoodDesc: _formData['neighborhoodDesc'] ?? '',
      nearbyLandmarks: List<String>.from(_formData['nearbyLandmarks'] ?? []),
      transportationAccess: List<String>.from(
        _formData['transportationAccess'] ?? [],
      ),
      distancesToKeyLocations: Map<String, double>.from(
        _formData['distancesToKeyLocations'] ?? {},
      ),
      photos: List<String>.from(_formData['photos'] ?? []),
      virtualTourUrl: _formData['virtualTourUrl'],
      floorPlanImage: _formData['floorPlanImage'],
      videoWalkthrough: _formData['videoWalkthrough'],
      utilitiesIncluded: List<String>.from(
        _formData['utilitiesIncluded'] ?? [],
      ),
      avgUtilityCost: double.tryParse(
        _formData['avgUtilityCost']?.toString() ?? '0',
      ),
      additionalFees: List<String>.from(_formData['additionalFees'] ?? []),
      minLeaseMonths:
          int.tryParse(_formData['minLeaseMonths']?.toString() ?? '1') ?? 1,
      leaseType: _formData['leaseType'] ?? LeaseType.fixedTerm,
      applicationRequirements: List<String>.from(
        _formData['applicationRequirements'] ?? [],
      ),
      smokingPolicy: _formData['smokingPolicy'] ?? '',
      guestPolicy: _formData['guestPolicy'] ?? '',
      noiseRestrictions: _formData['noiseRestrictions'] ?? '',
      maintenanceResponsibilities:
          _formData['maintenanceResponsibilities'] ?? '',
      sublettingPolicy: _formData['sublettingPolicy'] ?? '',
      contactMethod: _formData['contactMethod'] ?? '',
      showingSchedule: _formData['showingSchedule'] ?? '',
      contactName: _formData['contactName'] ?? '',
      contactRole: _formData['contactRole'] ?? '',
      safetyCertifications: List<String>.from(
        _formData['safetyCertifications'] ?? [],
      ),
      buildingPermits: List<String>.from(_formData['buildingPermits'] ?? []),
      rentalLicenseNumber: _formData['rentalLicenseNumber'],
      energyRating: _formData['energyRating'],
      parks: List<String>.from(_formData['parks'] ?? []),
      restaurants: List<String>.from(_formData['restaurants'] ?? []),
      groceries: List<String>.from(_formData['groceries'] ?? []),
      communityFeatures: List<String>.from(
        _formData['communityFeatures'] ?? [],
      ),
      renovations: List<String>.from(_formData['renovations'] ?? []),
      specialFeatures: List<String>.from(_formData['specialFeatures'] ?? []),
      usp: _formData['usp'],
    );
  }

  @override
  void initState() {
    super.initState();
    if (widget.initialProperty != null) {
      // Pre-fill form data for editing
      final p = widget.initialProperty!;
      _formData.addAll({
        'title': p.title,
        'propertyType': p.propertyType,
        'rentAmount': p.rentAmount,
        'securityDeposit': p.securityDeposit,
        'availableDate': p.availableDate,
        'bedrooms': p.bedrooms,
        'bathrooms': p.bathrooms,
        'squareFootage': p.squareFootage,
        'furnishingStatus': p.furnishingStatus,
        'floorLevel': p.floorLevel,
        'totalFloors': p.totalFloors,
        'heatingType': p.heatingType,
        'coolingType': p.coolingType,
        'kitchenAppliances': p.kitchenAppliances,
        'laundryFacilities': p.laundryFacilities,
        'parking': p.parking,
        'petPolicy': p.petPolicy,
        'accessibilityFeatures': p.accessibilityFeatures,
        'address': p.address,
        'neighborhoodDesc': p.neighborhoodDesc,
        'nearbyLandmarks': p.nearbyLandmarks,
        'transportationAccess': p.transportationAccess,
        'distancesToKeyLocations': p.distancesToKeyLocations,
        'photos': p.photos,
        'virtualTourUrl': p.virtualTourUrl,
        'floorPlanImage': p.floorPlanImage,
        'videoWalkthrough': p.videoWalkthrough,
        'utilitiesIncluded': p.utilitiesIncluded,
        'avgUtilityCost': p.avgUtilityCost,
        'additionalFees': p.additionalFees,
        'minLeaseMonths': p.minLeaseMonths,
        'leaseType': p.leaseType,
        'applicationRequirements': p.applicationRequirements,
        'smokingPolicy': p.smokingPolicy,
        'guestPolicy': p.guestPolicy,
        'noiseRestrictions': p.noiseRestrictions,
        'maintenanceResponsibilities': p.maintenanceResponsibilities,
        'sublettingPolicy': p.sublettingPolicy,
        'contactMethod': p.contactMethod,
        'showingSchedule': p.showingSchedule,
        'contactName': p.contactName,
        'contactRole': p.contactRole,
        'safetyCertifications': p.safetyCertifications,
        'buildingPermits': p.buildingPermits,
        'rentalLicenseNumber': p.rentalLicenseNumber,
        'energyRating': p.energyRating,
        'parks': p.parks,
        'restaurants': p.restaurants,
        'groceries': p.groceries,
        'communityFeatures': p.communityFeatures,
        'renovations': p.renovations,
        'specialFeatures': p.specialFeatures,
        'usp': p.usp,
      });
    }
  }

  String capitalize(String s) =>
      s.isNotEmpty ? s[0].toUpperCase() + s.substring(1) : s;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Upload Property')),
      body: Column(
        children: [
          LinearProgressIndicator(value: (_currentStep + 1) / _totalSteps),
          Expanded(
            child: Form(key: _formKey, child: _buildStep(_currentStep)),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (_currentStep > 0)
                TextButton(onPressed: _prevStep, child: const Text('Back')),
              ElevatedButton(
                onPressed: _nextStep,
                child: Text(
                  _currentStep == _totalSteps - 1 ? 'Submit' : 'Next',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStep(int step) {
    switch (step) {
      case 0:
        // Basic Info
        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                initialValue: _formData['title'] ?? '',
                decoration: const InputDecoration(labelText: 'Property Title'),
                onChanged: (v) => _formData['title'] = v,
                validator: (v) => (v == null || v.isEmpty) ? 'Required' : null,
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField(
                value:
                    _formData['propertyType'] ?? steps.PropertyType.apartment,
                decoration: const InputDecoration(labelText: 'Property Type'),
                items: steps.PropertyType.values
                    .map(
                      (e) => DropdownMenuItem(
                        value: e,
                        child: Text(
                          capitalize(
                            e.name.replaceAll(RegExp(r'([A-Z])'), ' '),
                          ),
                        ),
                      ),
                    )
                    .toList(),
                onChanged: (v) => setState(() => _formData['propertyType'] = v),
              ),
              const SizedBox(height: 16),
              TextFormField(
                initialValue: _formData['rentAmount']?.toString() ?? '',
                decoration: const InputDecoration(labelText: 'Rent Amount'),
                keyboardType: TextInputType.number,
                onChanged: (v) => _formData['rentAmount'] = v,
                validator: (v) => (v == null || v.isEmpty) ? 'Required' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                initialValue: _formData['securityDeposit']?.toString() ?? '',
                decoration: const InputDecoration(
                  labelText: 'Security Deposit',
                ),
                keyboardType: TextInputType.number,
                onChanged: (v) => _formData['securityDeposit'] = v,
              ),
              const SizedBox(height: 16),
              InputDatePickerFormField(
                initialDate: _formData['availableDate'] ?? DateTime.now(),
                firstDate: DateTime(2020),
                lastDate: DateTime(2100),
                fieldLabelText: 'Available Move-in Date',
                onDateSubmitted: (v) => _formData['availableDate'] = v,
              ),
            ],
          ),
        );
      case 1:
        // Property Details
        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                initialValue: _formData['bedrooms']?.toString() ?? '',
                decoration: const InputDecoration(labelText: 'Bedrooms'),
                keyboardType: TextInputType.number,
                onChanged: (v) => _formData['bedrooms'] = v,
              ),
              const SizedBox(height: 16),
              TextFormField(
                initialValue: _formData['bathrooms']?.toString() ?? '',
                decoration: const InputDecoration(labelText: 'Bathrooms'),
                keyboardType: TextInputType.number,
                onChanged: (v) => _formData['bathrooms'] = v,
              ),
              const SizedBox(height: 16),
              TextFormField(
                initialValue: _formData['squareFootage']?.toString() ?? '',
                decoration: const InputDecoration(labelText: 'Square Footage'),
                keyboardType: TextInputType.number,
                onChanged: (v) => _formData['squareFootage'] = v,
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField(
                value:
                    _formData['furnishingStatus'] ??
                    FurnishingStatus.unfurnished,
                decoration: const InputDecoration(
                  labelText: 'Furnishing Status',
                ),
                items: FurnishingStatus.values
                    .map(
                      (e) => DropdownMenuItem(
                        value: e,
                        child: Text(capitalize(e.name)),
                      ),
                    )
                    .toList(),
                onChanged: (v) =>
                    setState(() => _formData['furnishingStatus'] = v),
              ),
              const SizedBox(height: 16),
              TextFormField(
                initialValue: _formData['floorLevel']?.toString() ?? '',
                decoration: const InputDecoration(labelText: 'Floor Level'),
                keyboardType: TextInputType.number,
                onChanged: (v) => _formData['floorLevel'] = v,
              ),
              const SizedBox(height: 16),
              TextFormField(
                initialValue: _formData['totalFloors']?.toString() ?? '',
                decoration: const InputDecoration(labelText: 'Total Floors'),
                keyboardType: TextInputType.number,
                onChanged: (v) => _formData['totalFloors'] = v,
              ),
            ],
          ),
        );
      // ...repeat for all steps, grouping fields as in your spec...
      default:
        return Center(
          child: Text('Step: "${steps.UploadFormSteps.steps[step]}" (UI TBD)'),
        );
    }
  }
}
