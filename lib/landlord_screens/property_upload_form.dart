import 'package:flutter/material.dart';
import 'models/property.dart';

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
  final int _totalSteps = 5;
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
    final propertyTypes = List<PropertyType>.from(_formData['propertyTypes'] ?? []);
    final isMultiFloor = propertyTypes.contains(PropertyType.apartment) || propertyTypes.contains(PropertyType.other); // Add more types if needed
    return Property(
      title: _formData['title'] ?? '',
      propertyTypes: propertyTypes,
      rentAmount: double.tryParse(_formData['rentAmount']?.toString() ?? '0') ?? 0,
      securityDeposit: double.tryParse(_formData['securityDeposit']?.toString() ?? '0') ?? 0,
      availableDate: _formData['availableDate'] ?? DateTime.now(),
      bedrooms: int.tryParse(_formData['bedrooms']?.toString() ?? '1') ?? 1,
      bathrooms: int.tryParse(_formData['bathrooms']?.toString() ?? '1') ?? 1,
      squareFootage: double.tryParse(_formData['squareFootage']?.toString() ?? '0') ?? 0,
      furnishingStatus: _formData['furnishingStatus'] ?? FurnishingStatus.unfurnished,
      floorLevel: isMultiFloor ? int.tryParse(_formData['floorLevel']?.toString() ?? '1') : null,
      totalFloors: isMultiFloor ? int.tryParse(_formData['totalFloors']?.toString() ?? '1') : null,
      heatingType: _formData['heatingType'] ?? HeatingType.none,
      coolingType: _formData['coolingType'] ?? CoolingType.none,
      kitchenAppliances: List<String>.from(_formData['kitchenAppliances'] ?? []),
      laundryFacilities: _formData['laundryFacilities'] ?? '',
      parking: _formData['parking'] ?? '',
      petPolicy: _formData['petPolicy'] ?? '',
      accessibilityFeatures: List<String>.from(_formData['accessibilityFeatures'] ?? []),
      address: _formData['address'] ?? '',
      neighborhoodDesc: _formData['neighborhoodDesc'] ?? '',
      nearbyLandmarks: List<String>.from(_formData['nearbyLandmarks'] ?? []),
      transportationAccess: List<String>.from(_formData['transportationAccess'] ?? []),
      distancesToKeyLocations: Map<String, double>.from(_formData['distancesToKeyLocations'] ?? {}),
      photos: List<String>.from(_formData['photos'] ?? []),
      virtualTourUrl: _formData['virtualTourUrl'],
      floorPlanImage: _formData['floorPlanImage'],
      videoWalkthrough: _formData['videoWalkthrough'],
      utilitiesIncluded: List<String>.from(_formData['utilitiesIncluded'] ?? []),
      avgUtilityCost: double.tryParse(_formData['avgUtilityCost']?.toString() ?? '0'),
      additionalFees: List<String>.from(_formData['additionalFees'] ?? []),
      minLeaseMonths: int.tryParse(_formData['minLeaseMonths']?.toString() ?? '1') ?? 1,
      leaseType: _formData['leaseType'] ?? LeaseType.fixedTerm,
      applicationRequirements: List<String>.from(_formData['applicationRequirements'] ?? []),
      smokingPolicy: _formData['smokingPolicy'] ?? '',
      guestPolicy: _formData['guestPolicy'] ?? '',
      noiseRestrictions: _formData['noiseRestrictions'] ?? '',
      maintenanceResponsibilities: _formData['maintenanceResponsibilities'] ?? '',
      sublettingPolicy: _formData['sublettingPolicy'] ?? '',
      contactMethod: _formData['contactMethod'] ?? '',
      showingSchedule: _formData['showingSchedule'] ?? '',
      contactName: _formData['contactName'] ?? '',
      contactRole: _formData['contactRole'] ?? '',
      safetyCertifications: List<String>.from(_formData['safetyCertifications'] ?? []),
      buildingPermits: List<String>.from(_formData['buildingPermits'] ?? []),
      rentalLicenseNumber: _formData['rentalLicenseNumber'],
      energyRating: _formData['energyRating'],
      parks: List<String>.from(_formData['parks'] ?? []),
      restaurants: List<String>.from(_formData['restaurants'] ?? []),
      groceries: List<String>.from(_formData['groceries'] ?? []),
      communityFeatures: List<String>.from(_formData['communityFeatures'] ?? []),
      renovations: List<String>.from(_formData['renovations'] ?? []),
      specialFeatures: List<String>.from(_formData['specialFeatures'] ?? []),
      usp: _formData['usp'],
    );
  }

  @override
  void initState() {
    super.initState();
    if (widget.initialProperty != null) {
      final p = widget.initialProperty!;
      _formData.addAll({
        'title': p.title,
        'propertyTypes': p.propertyTypes,
        'rentAmount': p.rentAmount,
        'securityDeposit': p.securityDeposit,
        'availableDate': p.availableDate,
        'bedrooms': p.bedrooms,
        'bathrooms': p.bathrooms,
        'squareFootage': p.squareFootage,
        'furnishingStatus': p.furnishingStatus,
        'address': p.address,
        'neighborhoodDesc': p.neighborhoodDesc,
        'photos': p.photos,
      });
    }
  }

  String capitalize(String s) =>
      s.isNotEmpty ? s[0].toUpperCase() + s.substring(1) : s;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Modern stepper
              Row(
                children: List.generate(_totalSteps, (i) {
                  final isActive = i == _currentStep;
                  final isCompleted = i < _currentStep;
                  return Expanded(
                    child: Container(
                      height: 6,
                      margin: EdgeInsets.only(right: i == _totalSteps - 1 ? 0 : 4),
                      decoration: BoxDecoration(
                        color: isCompleted
                            ? theme.colorScheme.primary
                            : isActive
                                ? theme.colorScheme.primary.withOpacity(0.7)
                                : theme.dividerColor.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  );
                }),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Text(
                    'Step ${_currentStep + 1} of $_totalSteps',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    _stepTitle(_currentStep),
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        Expanded(
          child: Card(
            margin: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24),
            ),
            color: theme.cardColor,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
              child: Form(key: _formKey, child: _buildStep(_currentStep)),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (_currentStep > 0)
                OutlinedButton.icon(
                  onPressed: _prevStep,
                  icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 18),
                  label: const Text('Back'),
                  style: OutlinedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    side: BorderSide(color: theme.colorScheme.primary),
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                  ),
                ),
              ElevatedButton.icon(
                onPressed: _nextStep,
                icon: Icon(_currentStep == _totalSteps - 1 ? Icons.check : Icons.arrow_forward_rounded, size: 20),
                label: Text(
                  _currentStep == _totalSteps - 1 ? 'Submit' : 'Next',
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: theme.colorScheme.primary,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
                  elevation: 1,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  String _stepTitle(int step) {
    switch (step) {
      case 0:
        return 'Basic Info';
      case 1:
        return 'Property Details';
      case 2:
        return 'Location';
      case 3:
        return 'Photos';
      case 4:
        return 'Review & Submit';
      default:
        return '';
    }
  }

  Widget _buildStep(int step) {
    switch (step) {
      case 0:
        // Basic Info
        return SingleChildScrollView(
          padding: const EdgeInsets.all(0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Basic Information', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
              TextFormField(
                initialValue: _formData['title'] ?? '',
                decoration: const InputDecoration(
                  labelText: 'Property Title',
                  prefixIcon: Icon(Icons.title_rounded),
                  helperText: 'E.g. Modern 2BR Apartment in Downtown',
                ),
                onChanged: (v) => _formData['title'] = v,
                validator: (v) => (v == null || v.isEmpty) ? 'Required' : null,
              ),
              const SizedBox(height: 20),
              Text('Property Types', style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w600)),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                children: PropertyType.values.map((type) {
                  final selected = (_formData['propertyTypes'] ?? <PropertyType>[]).contains(type);
                  return FilterChip(
                    label: Text(capitalize(type.name.replaceAll(RegExp(r'([A-Z])'), ' '))),
                    selected: selected,
                    onSelected: (val) {
                      setState(() {
                        final list = List<PropertyType>.from(_formData['propertyTypes'] ?? []);
                        if (val) {
                          list.add(type);
                        } else {
                          list.remove(type);
                        }
                        _formData['propertyTypes'] = list;
                      });
                    },
                  );
                }).toList(),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      initialValue: _formData['rentAmount']?.toString() ?? '',
                      decoration: const InputDecoration(
                        labelText: 'Rent Amount',
                        prefixIcon: Icon(Icons.attach_money_rounded),
                        helperText: 'Monthly rent (e.g. 1200)',
                      ),
                      keyboardType: TextInputType.number,
                      onChanged: (v) => _formData['rentAmount'] = v,
                      validator: (v) => (v == null || v.isEmpty) ? 'Required' : null,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: TextFormField(
                      initialValue: _formData['securityDeposit']?.toString() ?? '',
                      decoration: const InputDecoration(
                        labelText: 'Security Deposit',
                        prefixIcon: Icon(Icons.savings_rounded),
                        helperText: 'Optional',
                      ),
                      keyboardType: TextInputType.number,
                      onChanged: (v) => _formData['securityDeposit'] = v,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
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
        final propertyTypes = List<PropertyType>.from(_formData['propertyTypes'] ?? []);
        final isMultiFloor = propertyTypes.contains(PropertyType.apartment) || propertyTypes.contains(PropertyType.other); // Add more types if needed
        return SingleChildScrollView(
          padding: const EdgeInsets.all(0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Property Details', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      initialValue: _formData['bedrooms']?.toString() ?? '',
                      decoration: const InputDecoration(
                        labelText: 'Bedrooms',
                        prefixIcon: Icon(Icons.bed_rounded),
                      ),
                      keyboardType: TextInputType.number,
                      onChanged: (v) => _formData['bedrooms'] = v,
                      validator: (v) => (v == null || v.isEmpty) ? 'Required' : null,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: TextFormField(
                      initialValue: _formData['bathrooms']?.toString() ?? '',
                      decoration: const InputDecoration(
                        labelText: 'Bathrooms',
                        prefixIcon: Icon(Icons.bathtub_rounded),
                      ),
                      keyboardType: TextInputType.number,
                      onChanged: (v) => _formData['bathrooms'] = v,
                      validator: (v) => (v == null || v.isEmpty) ? 'Required' : null,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              TextFormField(
                initialValue: _formData['squareFootage']?.toString() ?? '',
                decoration: const InputDecoration(
                  labelText: 'Square Footage',
                  prefixIcon: Icon(Icons.square_foot_rounded),
                  helperText: 'e.g. 900',
                ),
                keyboardType: TextInputType.number,
                onChanged: (v) => _formData['squareFootage'] = v,
                validator: (v) => (v == null || v.isEmpty) ? 'Required' : null,
              ),
              const SizedBox(height: 20),
              DropdownButtonFormField(
                value: _formData['furnishingStatus'] ?? FurnishingStatus.unfurnished,
                decoration: const InputDecoration(
                  labelText: 'Furnishing Status',
                  prefixIcon: Icon(Icons.chair_alt_rounded),
                ),
                items: FurnishingStatus.values
                    .map((e) => DropdownMenuItem(
                          value: e,
                          child: Text(capitalize(e.name)),
                        ))
                    .toList(),
                onChanged: (v) => setState(() => _formData['furnishingStatus'] = v),
              ),
              if (isMultiFloor) ...[
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        initialValue: _formData['floorLevel']?.toString() ?? '',
                        decoration: const InputDecoration(
                          labelText: 'Floor Level',
                          prefixIcon: Icon(Icons.stairs_rounded),
                          helperText: 'Which floor is the unit on?',
                        ),
                        keyboardType: TextInputType.number,
                        onChanged: (v) => _formData['floorLevel'] = v,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: TextFormField(
                        initialValue: _formData['totalFloors']?.toString() ?? '',
                        decoration: const InputDecoration(
                          labelText: 'Total Floors',
                          prefixIcon: Icon(Icons.apartment_rounded),
                          helperText: 'How many floors in the building?',
                        ),
                        keyboardType: TextInputType.number,
                        onChanged: (v) => _formData['totalFloors'] = v,
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        );
      case 2:
        // Location
        return SingleChildScrollView(
          padding: const EdgeInsets.all(0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Location', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
              TextFormField(
                initialValue: _formData['address'] ?? '',
                decoration: const InputDecoration(
                  labelText: 'Address',
                  prefixIcon: Icon(Icons.location_on_rounded),
                ),
                onChanged: (v) => _formData['address'] = v,
                validator: (v) => (v == null || v.isEmpty) ? 'Required' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                initialValue: _formData['neighborhoodDesc'] ?? '',
                decoration: const InputDecoration(
                  labelText: 'Neighborhood Description',
                  prefixIcon: Icon(Icons.map_rounded),
                ),
                onChanged: (v) => _formData['neighborhoodDesc'] = v,
              ),
            ],
          ),
        );
      case 3:
        // Photos
        return SingleChildScrollView(
          padding: const EdgeInsets.all(0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Photos', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
              TextFormField(
                initialValue: (_formData['photos'] ?? []).join(', '),
                decoration: const InputDecoration(
                  labelText: 'Photo URLs (comma separated)',
                  prefixIcon: Icon(Icons.photo_library_rounded),
                  helperText: 'Paste at least one image URL or file name',
                ),
                onChanged: (v) => _formData['photos'] = v.split(',').map((e) => e.trim()).where((e) => e.isNotEmpty).toList(),
                validator: (v) {
                  final list = v?.split(',').map((e) => e.trim()).where((e) => e.isNotEmpty).toList() ?? [];
                  return list.isEmpty ? 'At least one photo is required' : null;
                },
              ),
            ],
          ),
        );
      case 4:
        // Review & Submit
        return SingleChildScrollView(
          padding: const EdgeInsets.all(0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Review & Submit', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
              ..._formData.entries.map((e) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('${capitalize(e.key)}: ', style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600)),
                    Expanded(
                      child: Text(
                        e.value is List
                            ? (e.value as List).join(', ')
                            : e.value?.toString() ?? '',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ),
                  ],
                ),
              )),
              const SizedBox(height: 24),
              Text('Please review all details before submitting.', style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.orange)),
            ],
          ),
        );
      default:
        return const SizedBox();
    }
  }
}
