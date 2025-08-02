import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:iconsax/iconsax.dart';
import 'models/property.dart';
import 'upload_form_steps.dart' hide PropertyType;
import 'package:provider/provider.dart';
import '../theme_provider.dart';

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
  final Map<String, dynamic> _formData = {};
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final _pageController = PageController();
  bool _isUploading = false;
  double _uploadProgress = 0.0;

  void _nextStep() {
    if (_formKey.currentState?.validate() ?? false) {
      if (_currentStep < UploadFormSteps.steps.length - 1) {
        setState(() => _currentStep++);
        _pageController.nextPage(
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      } else {
        _submitProperty();
      }
    }
  }

  void _prevStep() {
    if (_currentStep > 0) {
      setState(() => _currentStep--);
      _pageController.previousPage(
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    }
  }

  Future<void> _submitProperty() async {
    setState(() {
      _isUploading = true;
      _uploadProgress = 0.0;
    });

    for (int i = 0; i <= 100; i += 10) {
      await Future.delayed(const Duration(milliseconds: 200));
      setState(() => _uploadProgress = i / 100.0);
    }

    final property = _buildPropertyFromData();
    widget.onSubmit(property);
    
    setState(() => _isUploading = false);
  }

  Property _buildPropertyFromData() {
    return Property(
      id: '',
      landlordId: '',
      createdAt: DateTime.now(),
      status: PropertyStatus.pending,
      title: _formData['title'] ?? '',
      propertyTypes: List<PropertyType>.from(_formData['propertyTypes'] ?? []),
      rentAmount: double.tryParse(_formData['rentAmount']?.toString() ?? '0') ?? 0,
      securityDeposit: double.tryParse(_formData['securityDeposit']?.toString() ?? '0') ?? 0,
      availableDate: _formData['availableDate'] ?? DateTime.now(),
      bedrooms: _formData['bedrooms'] != null ? int.tryParse(_formData['bedrooms'].toString()) : null,
      bathrooms: _formData['bathrooms'] != null ? int.tryParse(_formData['bathrooms'].toString()) : null,
      squareFootage: _formData['squareFootage'] != null ? double.tryParse(_formData['squareFootage'].toString()) : null,
      furnishingStatus: _formData['furnishingStatus'],
      floorLevel: _formData['floorLevel'] != null ? int.tryParse(_formData['floorLevel'].toString()) : null,
      totalFloors: _formData['totalFloors'] != null ? int.tryParse(_formData['totalFloors'].toString()) : null,
      heatingType: _formData['heatingType'],
      coolingType: _formData['coolingType'],
      kitchenAppliances: _formData['kitchenAppliances'],
      laundryFacilities: _formData['laundryFacilities'],
      parking: _formData['parking'],
      petPolicy: _formData['petPolicy'],
      accessibilityFeatures: _formData['accessibilityFeatures'],
      address: _formData['address'] ?? '',
      neighborhoodDesc: _formData['neighborhoodDesc'],
      transportationAccess: _formData['transportationAccess'],
      photos: _formData['photos'],
      virtualTourUrl: _formData['virtualTourUrl'],
      videoWalkthrough: _formData['videoWalkthrough'],
      minLeaseMonths: _formData['minLeaseMonths'] != null ? int.tryParse(_formData['minLeaseMonths'].toString()) : null,
      leaseType: _formData['leaseType'],
      applicationRequirements: _formData['applicationRequirements'],
      smokingPolicy: _formData['smokingPolicy'],
      guestPolicy: _formData['guestPolicy'],
      noiseRestrictions: _formData['noiseRestrictions'],
      maintenanceResponsibilities: _formData['maintenanceResponsibilities'],
      sublettingPolicy: _formData['sublettingPolicy'],
      contactMethod: _formData['contactMethod'],
      showingSchedule: _formData['showingSchedule'],
      contactName: _formData['contactName'],
      contactRole: _formData['contactRole'],
      safetyCertifications: _formData['safetyCertifications'],
      buildingPermits: _formData['buildingPermits'],
      rentalLicenseNumber: _formData['rentalLicenseNumber'],
      energyRating: _formData['energyRating'],
      parks: _formData['parks'],
      restaurants: _formData['restaurants'],
      groceries: _formData['groceries'],
      communityFeatures: _formData['communityFeatures'],
      renovations: _formData['renovations'],
      specialFeatures: _formData['specialFeatures'],
      usp: _formData['usp'],
      description: _formData['description'], amenities: [],
    );
  }

  @override
  void initState() {
    super.initState();
    if (widget.initialProperty != null) {
      _formData.addAll({
        'title': widget.initialProperty!.title,
        'propertyTypes': widget.initialProperty!.propertyTypes,
        'rentAmount': widget.initialProperty!.rentAmount,
        'securityDeposit': widget.initialProperty!.securityDeposit,
        'availableDate': widget.initialProperty!.availableDate,
        'bedrooms': widget.initialProperty!.bedrooms,
        'bathrooms': widget.initialProperty!.bathrooms,
        'squareFootage': widget.initialProperty!.squareFootage,
        'furnishingStatus': widget.initialProperty!.furnishingStatus,
        'floorLevel': widget.initialProperty!.floorLevel,
        'totalFloors': widget.initialProperty!.totalFloors,
        'heatingType': widget.initialProperty!.heatingType,
        'coolingType': widget.initialProperty!.coolingType,
        'kitchenAppliances': widget.initialProperty!.kitchenAppliances,
        'laundryFacilities': widget.initialProperty!.laundryFacilities,
        'parking': widget.initialProperty!.parking,
        'petPolicy': widget.initialProperty!.petPolicy,
        'accessibilityFeatures': widget.initialProperty!.accessibilityFeatures,
        'address': widget.initialProperty!.address,
        'neighborhoodDesc': widget.initialProperty!.neighborhoodDesc,
        'transportationAccess': widget.initialProperty!.transportationAccess,
        'photos': widget.initialProperty!.photos,
        'virtualTourUrl': widget.initialProperty!.virtualTourUrl,
        'videoWalkthrough': widget.initialProperty!.videoWalkthrough,
        'minLeaseMonths': widget.initialProperty!.minLeaseMonths,
        'leaseType': widget.initialProperty!.leaseType,
        'applicationRequirements': widget.initialProperty!.applicationRequirements,
        'smokingPolicy': widget.initialProperty!.smokingPolicy,
        'guestPolicy': widget.initialProperty!.guestPolicy,
        'noiseRestrictions': widget.initialProperty!.noiseRestrictions,
        'maintenanceResponsibilities': widget.initialProperty!.maintenanceResponsibilities,
        'sublettingPolicy': widget.initialProperty!.sublettingPolicy,
        'contactMethod': widget.initialProperty!.contactMethod,
        'showingSchedule': widget.initialProperty!.showingSchedule,
        'contactName': widget.initialProperty!.contactName,
        'contactRole': widget.initialProperty!.contactRole,
        'safetyCertifications': widget.initialProperty!.safetyCertifications,
        'buildingPermits': widget.initialProperty!.buildingPermits,
        'rentalLicenseNumber': widget.initialProperty!.rentalLicenseNumber,
        'energyRating': widget.initialProperty!.energyRating,
        'parks': widget.initialProperty!.parks,
        'restaurants': widget.initialProperty!.restaurants,
        'groceries': widget.initialProperty!.groceries,
        'communityFeatures': widget.initialProperty!.communityFeatures,
        'renovations': widget.initialProperty!.renovations,
        'specialFeatures': widget.initialProperty!.specialFeatures,
        'usp': widget.initialProperty!.usp,
      });
    }
  }

  String _capitalize(String s) => s.isNotEmpty ? s[0].toUpperCase() + s.substring(1) : s;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primaryColor = theme.colorScheme.primary;
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text(_currentStep == 0 ? 'Add Property' : 'Edit Property'),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.pop(context),
        ),
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              primaryColor.withOpacity(0.03),
              theme.scaffoldBackgroundColor,
            ],
          ),
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              decoration: BoxDecoration(
                color: theme.cardColor,
                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 8)],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: List.generate(UploadFormSteps.steps.length, (index) {
                      final isActive = index == _currentStep;
                      final isCompleted = index < _currentStep;
                      return Expanded(
                        child: Container(
                          margin: const EdgeInsets.only(right: 4),
                          height: 6,
                          decoration: BoxDecoration(
                            color: isCompleted
                                ? primaryColor
                                : isActive
                                    ? primaryColor
                                    : Colors.grey.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      );
                    }),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: primaryColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          'Step ${_currentStep + 1}/${UploadFormSteps.steps.length}',
                          style: TextStyle(
                            color: primaryColor,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          UploadFormSteps.steps[_currentStep],
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: PageView(
                controller: _pageController,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  _buildBasicInfoStep(theme),
                  _buildPropertyDetailsStep(theme),
                  _buildAmenitiesStep(theme),
                  _buildLocationStep(theme),
                  _buildMediaStep(theme),
                  _buildPricingStep(theme),
                  _buildRulesStep(theme),
                  _buildReviewStep(theme),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              decoration: BoxDecoration(
                color: theme.cardColor,
                border: Border(top: BorderSide(color: theme.dividerColor.withOpacity(0.2)))),
              child: Row(
                children: [
                  if (_currentStep > 0)
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: _prevStep,
                        icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 18),
                        label: const Text('Back'),
                        style: OutlinedButton.styleFrom(
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          side: BorderSide(color: theme.dividerColor),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                      ),
                    ),
                  const SizedBox(width: 16),
                  Expanded(
                    flex: 2,
                    child: _isUploading
                        ? LinearProgressIndicator(
                            value: _uploadProgress,
                            backgroundColor: theme.colorScheme.surfaceContainerHighest,
                            color: primaryColor,
                            minHeight: 48,
                            borderRadius: BorderRadius.circular(12),
                          )
                        : ElevatedButton.icon(
                            onPressed: _nextStep,
                            icon: Icon(
                              _currentStep == UploadFormSteps.steps.length - 1 
                                  ? Icons.check_rounded 
                                  : Icons.arrow_forward_rounded,
                              size: 20,
                            ),
                            label: Text(
                              _currentStep == UploadFormSteps.steps.length - 1 
                                  ? 'Submit Property' 
                                  : 'Continue',
                              style: const TextStyle(fontWeight: FontWeight.w600),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: primaryColor,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              elevation: 0,
                            ),
                          ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBasicInfoStep(ThemeData theme) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _SectionHeader(
              icon: Icons.info_outline_rounded,
              title: 'Basic Details',
              subtitle: 'Essential information about your property',
            ),
            const SizedBox(height: 24),
            TextFormField(
              initialValue: _formData['title'] ?? '',
              decoration: InputDecoration(
                labelText: 'Property Title*',
                prefixIcon: const Icon(Iconsax.house),
                filled: true,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                hintText: 'Modern 2BR Apartment in Downtown',
                suffixIcon: Icon(Iconsax.info_circle, color: theme.colorScheme.primary),
              ),
              onChanged: (v) => _formData['title'] = v,
              validator: (v) => (v == null || v.isEmpty) ? 'Required' : null,
            ),
            const SizedBox(height: 20),
            Text('Property Types*', style: theme.textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w600)),
            const SizedBox(height: 12),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: PropertyType.values.map((type) {
                final selected = (_formData['propertyTypes'] ?? <PropertyType>[]).contains(type);
                return ChoiceChip(
                  label: Text(
                    _capitalize(type.name.replaceAll('_', ' ')),
                    style: TextStyle(
                      color: selected ? Colors.white : theme.colorScheme.onSurface,
                    ),
                  ),
                  selected: selected,
                  selectedColor: theme.colorScheme.primary,
                  backgroundColor: theme.cardColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
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
            const SizedBox(height: 24),
            _SectionHeader(
              icon: Iconsax.dollar_circle,
              title: 'Pricing & Availability',
              subtitle: 'Set your rental price and availability date',
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    initialValue: _formData['rentAmount']?.toString() ?? '',
                    decoration: InputDecoration(
                      labelText: 'Rent Amount*',
                      prefixIcon: const Icon(Iconsax.dollar_circle),
                      filled: true,
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                      hintText: 'e.g. 1200',
                    ),
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    onChanged: (v) => _formData['rentAmount'] = v,
                    validator: (v) => (v == null || v.isEmpty) ? 'Required' : null,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: TextFormField(
                    initialValue: _formData['securityDeposit']?.toString() ?? '',
                    decoration: InputDecoration(
                      labelText: 'Security Deposit',
                      prefixIcon: const Icon(Iconsax.security_safe),
                      filled: true,
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                      hintText: 'Optional',
                    ),
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    onChanged: (v) => _formData['securityDeposit'] = v,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            GestureDetector(
              onTap: () => _selectDate(context),
              child: AbsorbPointer(
                child: TextFormField(
                  controller: TextEditingController(
                    text: _formData['availableDate'] != null
                        ? '${_formData['availableDate']!.toLocal()}'.split(' ')[0]
                        : '',
                  ),
                  decoration: InputDecoration(
                    labelText: 'Available Move-in Date*',
                    prefixIcon: const Icon(Iconsax.calendar),
                    filled: true,
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                  ),
                  validator: (v) => (v == null || v.isEmpty) ? 'Required' : null,
                ),
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildPropertyDetailsStep(ThemeData theme) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _SectionHeader(
            icon: Iconsax.rulerpen,
            title: 'Property Specifications',
            subtitle: 'Add details about rooms, size, and features',
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  initialValue: _formData['bedrooms']?.toString() ?? '',
                  decoration: InputDecoration(
                    labelText: 'Bedrooms*',
                    prefixIcon: const Icon(Iconsax.back_square),
                    filled: true,
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                  ),
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  onChanged: (v) => _formData['bedrooms'] = v,
                  validator: (v) => (v == null || v.isEmpty) ? 'Required' : null,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: TextFormField(
                  initialValue: _formData['bathrooms']?.toString() ?? '',
                  decoration: InputDecoration(
                    labelText: 'Bathrooms*',
                    prefixIcon: const Icon(Iconsax.ranking),
                    filled: true,
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                  ),
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  onChanged: (v) => _formData['bathrooms'] = v,
                  validator: (v) => (v == null || v.isEmpty) ? 'Required' : null,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          TextFormField(
            initialValue: _formData['squareFootage']?.toString() ?? '',
            decoration: InputDecoration(
              labelText: 'Square Footage*',
              prefixIcon: const Icon(Iconsax.ruler),
              filled: true,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
              hintText: 'e.g. 900',
            ),
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            onChanged: (v) => _formData['squareFootage'] = v,
            validator: (v) => (v == null || v.isEmpty) ? 'Required' : null,
          ),
          const SizedBox(height: 20),
          DropdownButtonFormField(
            value: _formData['furnishingStatus'] ?? FurnishingStatus.unfurnished,
            decoration: InputDecoration(
              labelText: 'Furnishing Status',
              prefixIcon: const Icon(Iconsax.car),
              filled: true,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
            ),
            items: FurnishingStatus.values
                .map((e) => DropdownMenuItem(
                      value: e,
                      child: Text(_capitalize(e.name)),
                    ))
                .toList(),
            onChanged: (v) => setState(() => _formData['furnishingStatus'] = v),
          ),
          const SizedBox(height: 24),
          _SectionHeader(
            icon: Iconsax.buildings,
            title: 'Building Information',
            subtitle: 'Provide details about the building',
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  initialValue: _formData['floorLevel']?.toString() ?? '',
                  decoration: InputDecoration(
                    labelText: 'Floor Level',
                    prefixIcon: const Icon(Iconsax.building),
                    filled: true,
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                    hintText: 'e.g. 5',
                  ),
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  onChanged: (v) => _formData['floorLevel'] = v,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: TextFormField(
                  initialValue: _formData['totalFloors']?.toString() ?? '',
                  decoration: InputDecoration(
                    labelText: 'Total Floors',
                    prefixIcon: const Icon(Iconsax.buildings),
                    filled: true,
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                    hintText: 'e.g. 10',
                  ),
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  onChanged: (v) => _formData['totalFloors'] = v,
                ),
              ),
            ],
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _buildAmenitiesStep(ThemeData theme) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _SectionHeader(
            icon: Icons.emoji_food_beverage,
            title: 'Kitchen Appliances',
            subtitle: 'Select appliances included in the kitchen',
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              'Refrigerator', 'Oven', 'Microwave', 'Dishwasher', 'Stove', 'Garbage disposal'
            ].map((appliance) {
              final selected = (_formData['kitchenAppliances'] ?? []).contains(appliance);
              return FilterChip(
                label: Text(appliance),
                selected: selected,
                onSelected: (val) {
                  setState(() {
                    final list = List<String>.from(_formData['kitchenAppliances'] ?? []);
                    if (val) {
                      list.add(appliance);
                    } else {
                      list.remove(appliance);
                    }
                    _formData['kitchenAppliances'] = list;
                  });
                },
                backgroundColor: theme.cardColor,
                selectedColor: theme.colorScheme.primary.withOpacity(0.2),
                checkmarkColor: theme.colorScheme.primary,
              );
            }).toList(),
          ),
          const SizedBox(height: 24),
          _SectionHeader(
            icon: Icons.local_laundry_service,
            title: 'Laundry Facilities',
            subtitle: 'Select laundry options available',
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              'In-unit', 'Shared', 'None'
            ].map((option) {
              final selected = _formData['laundryFacilities'] == option;
              return ChoiceChip(
                label: Text(option),
                selected: selected,
                onSelected: (val) {
                  setState(() {
                    _formData['laundryFacilities'] = val ? option : null;
                  });
                },
                backgroundColor: theme.cardColor,
                selectedColor: theme.colorScheme.primary.withOpacity(0.2),
              );
            }).toList(),
          ),
          const SizedBox(height: 24),
          _SectionHeader(
            icon: Icons.local_parking,
            title: 'Parking',
            subtitle: 'Select parking options available',
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              'Garage', 'Street', 'Assigned Spot', 'None'
            ].map((option) {
              final selected = _formData['parking'] == option;
              return ChoiceChip(
                label: Text(option),
                selected: selected,
                onSelected: (val) {
                  setState(() {
                    _formData['parking'] = val ? option : null;
                  });
                },
                backgroundColor: theme.cardColor,
                selectedColor: theme.colorScheme.primary.withOpacity(0.2),
              );
            }).toList(),
          ),
          const SizedBox(height: 24),
          _SectionHeader(
            icon: Icons.pets,
            title: 'Pet Policy',
            subtitle: 'Specify pet allowances and restrictions',
          ),
          const SizedBox(height: 16),
          TextFormField(
            initialValue: _formData['petPolicy'] ?? '',
            maxLines: 3,
            decoration: InputDecoration(
              hintText: 'e.g. Pets allowed with deposit, no aggressive breeds',
              filled: true,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
            ),
            onChanged: (v) => _formData['petPolicy'] = v,
          ),
          const SizedBox(height: 24),
          _SectionHeader(
            icon: Icons.accessibility,
            title: 'Accessibility Features',
            subtitle: 'Select accessibility features',
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              'Elevator', 'Ramp', 'Wide doorways', 'Grab bars', 'Roll-in shower'
            ].map((feature) {
              final selected = (_formData['accessibilityFeatures'] ?? []).contains(feature);
              return FilterChip(
                label: Text(feature),
                selected: selected,
                onSelected: (val) {
                  setState(() {
                    final list = List<String>.from(_formData['accessibilityFeatures'] ?? []);
                    if (val) {
                      list.add(feature);
                    } else {
                      list.remove(feature);
                    }
                    _formData['accessibilityFeatures'] = list;
                  });
                },
                backgroundColor: theme.cardColor,
                selectedColor: theme.colorScheme.primary.withOpacity(0.2),
                checkmarkColor: theme.colorScheme.primary,
              );
            }).toList(),
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _buildLocationStep(ThemeData theme) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _SectionHeader(
            icon: Iconsax.location,
            title: 'Property Location',
            subtitle: 'Help tenants find your property easily',
          ),
          const SizedBox(height: 24),
          TextFormField(
            initialValue: _formData['address'] ?? '',
            decoration: InputDecoration(
              labelText: 'Full Address*',
              prefixIcon: const Icon(Iconsax.map),
              filled: true,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
            ),
            onChanged: (v) => _formData['address'] = v,
            validator: (v) => (v == null || v.isEmpty) ? 'Required' : null,
          ),
          const SizedBox(height: 20),
          TextFormField(
            initialValue: _formData['neighborhoodDesc'] ?? '',
            maxLines: 3,
            decoration: InputDecoration(
              labelText: 'Neighborhood Description',
              prefixIcon: const Icon(Iconsax.info_circle),
              filled: true,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
              hintText: 'Describe the neighborhood, nearby amenities, and attractions...',
            ),
            onChanged: (v) => _formData['neighborhoodDesc'] = v,
          ),
          const SizedBox(height: 24),
          _SectionHeader(
            icon: Iconsax.route_square,
            title: 'Transportation',
            subtitle: 'How accessible is your property?',
          ),
          const SizedBox(height: 20),
          TextFormField(
            initialValue: (_formData['transportationAccess'] ?? []).join(', '),
            decoration: InputDecoration(
              labelText: 'Transportation Access',
              prefixIcon: const Icon(Iconsax.bus),
              filled: true,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
              hintText: 'e.g. Subway, Bus, Train',
            ),
            onChanged: (v) => _formData['transportationAccess'] = v.split(',').map((e) => e.trim()).toList(),
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _buildMediaStep(ThemeData theme) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _SectionHeader(
            icon: Iconsax.gallery,
            title: 'Visual Content',
            subtitle: 'Add high-quality photos to attract tenants',
          ),
          const SizedBox(height: 24),
          Text(
            'Property Photos*',
            style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
          Text(
            'Upload at least 3 high-quality photos of your property',
            style: theme.textTheme.bodySmall,
          ),
          const SizedBox(height: 16),
          Container(
            height: 200,
            decoration: BoxDecoration(
              color: theme.cardColor,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: theme.dividerColor),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Iconsax.gallery_add, size: 48, color: theme.colorScheme.primary),
                const SizedBox(height: 16),
                Text(
                  'Tap to add photos',
                  style: theme.textTheme.titleMedium,
                ),
                const SizedBox(height: 8),
                Text(
                  'or drag and drop files here',
                  style: theme.textTheme.bodySmall,
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          TextFormField(
            initialValue: (_formData['photos'] ?? []).join(', '),
            decoration: InputDecoration(
              labelText: 'Image URLs (comma separated)*',
              prefixIcon: const Icon(Iconsax.link),
              filled: true,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
              helperText: 'For demo purposes only',
            ),
            onChanged: (v) => _formData['photos'] = v.split(',').map((e) => e.trim()).where((e) => e.isNotEmpty).toList(),
            validator: (v) {
              final list = v?.split(',').map((e) => e.trim()).where((e) => e.isNotEmpty).toList() ?? [];
              return list.isEmpty ? 'At least one photo is required' : null;
            },
          ),
          const SizedBox(height: 24),
          _SectionHeader(
            icon: Iconsax.video,
            title: 'Virtual Content',
            subtitle: 'Optional but highly recommended',
          ),
          const SizedBox(height: 20),
          TextFormField(
            initialValue: _formData['virtualTourUrl'] ?? '',
            decoration: InputDecoration(
              labelText: 'Virtual Tour URL',
              prefixIcon: const Icon(Iconsax.video_play),
              filled: true,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
              hintText: 'https://example.com/tour',
            ),
            onChanged: (v) => _formData['virtualTourUrl'] = v,
          ),
          const SizedBox(height: 20),
          TextFormField(
            initialValue: _formData['videoWalkthrough'] ?? '',
            decoration: InputDecoration(
              labelText: 'Video Walkthrough URL',
              prefixIcon: const Icon(Iconsax.video),
              filled: true,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
              hintText: 'https://example.com/walkthrough',
            ),
            onChanged: (v) => _formData['videoWalkthrough'] = v,
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _buildPricingStep(ThemeData theme) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _SectionHeader(
            icon: Iconsax.money,
            title: 'Utilities & Costs',
            subtitle: 'Specify utility costs and additional fees',
          ),
          const SizedBox(height: 24),
          Text(
            'Utilities Included',
            style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              'Water', 'Gas', 'Electricity', 'Internet', 'Trash'
            ].map((utility) {
              final selected = (_formData['utilitiesIncluded'] ?? []).contains(utility);
              return FilterChip(
                label: Text(utility),
                selected: selected,
                onSelected: (val) {
                  setState(() {
                    final list = List<String>.from(_formData['utilitiesIncluded'] ?? []);
                    if (val) {
                      list.add(utility);
                    } else {
                      list.remove(utility);
                    }
                    _formData['utilitiesIncluded'] = list;
                  });
                },
                backgroundColor: theme.cardColor,
                selectedColor: theme.colorScheme.primary.withOpacity(0.2),
                checkmarkColor: theme.colorScheme.primary,
              );
            }).toList(),
          ),
          const SizedBox(height: 24),
          TextFormField(
            initialValue: _formData['avgUtilityCost']?.toString() ?? '',
            decoration: InputDecoration(
              labelText: 'Average Monthly Utility Cost',
              prefixIcon: const Icon(Iconsax.money),
              filled: true,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
              hintText: 'e.g. 120',
            ),
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            onChanged: (v) => _formData['avgUtilityCost'] = v,
          ),
          const SizedBox(height: 20),
          Text(
            'Additional Fees',
            style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              'Maintenance', 'HOA', 'Parking', 'Pet fee'
            ].map((fee) {
              final selected = (_formData['additionalFees'] ?? []).contains(fee);
              return FilterChip(
                label: Text(fee),
                selected: selected,
                onSelected: (val) {
                  setState(() {
                    final list = List<String>.from(_formData['additionalFees'] ?? []);
                    if (val) {
                      list.add(fee);
                    } else {
                      list.remove(fee);
                    }
                    _formData['additionalFees'] = list;
                  });
                },
                backgroundColor: theme.cardColor,
                selectedColor: theme.colorScheme.primary.withOpacity(0.2),
                checkmarkColor: theme.colorScheme.primary,
              );
            }).toList(),
          ),
          const SizedBox(height: 24),
          _SectionHeader(
            icon: Icons.description,
            title: 'Lease Terms',
            subtitle: 'Specify lease duration and type',
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  initialValue: _formData['minLeaseMonths']?.toString() ?? '',
                  decoration: InputDecoration(
                    labelText: 'Minimum Lease Months',
                    prefixIcon: const Icon(Iconsax.calendar_1),
                    filled: true,
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                    hintText: 'e.g. 12',
                  ),
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  onChanged: (v) => _formData['minLeaseMonths'] = v,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: DropdownButtonFormField(
                  value: _formData['leaseType'] ?? LeaseType.fixedTerm,
                  decoration: InputDecoration(
                    labelText: 'Lease Type',
                    prefixIcon: const Icon(Iconsax.document),
                    filled: true,
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                  ),
                  items: LeaseType.values
                      .map((e) => DropdownMenuItem(
                            value: e,
                            child: Text(_capitalize(e.name)),
                          ))
                      .toList(),
                  onChanged: (v) => setState(() => _formData['leaseType'] = v),
                ),
              ),
            ],
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _buildRulesStep(ThemeData theme) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _SectionHeader(
            icon: Iconsax.document,
            title: 'Rules & Policies',
            subtitle: 'Set rules for tenants',
          ),
          const SizedBox(height: 24),
          TextFormField(
            initialValue: _formData['smokingPolicy'] ?? '',
            decoration: InputDecoration(
              labelText: 'Smoking Policy*',
              prefixIcon: const Icon(Icons.smoke_free),
              filled: true,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
              hintText: 'e.g. No smoking allowed',
            ),
            onChanged: (v) => _formData['smokingPolicy'] = v,
            validator: (v) => (v == null || v.isEmpty) ? 'Required' : null,
          ),
          const SizedBox(height: 20),
          TextFormField(
            initialValue: _formData['guestPolicy'] ?? '',
            decoration: InputDecoration(
              labelText: 'Guest Policy',
              prefixIcon: const Icon(Icons.people),
              filled: true,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
              hintText: 'e.g. Guests allowed up to 7 nights',
            ),
            onChanged: (v) => _formData['guestPolicy'] = v,
          ),
          const SizedBox(height: 20),
          TextFormField(
            initialValue: _formData['noiseRestrictions'] ?? '',
            decoration: InputDecoration(
              labelText: 'Noise Restrictions',
              prefixIcon: const Icon(Icons.volume_off),
              filled: true,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
              hintText: 'e.g. Quiet hours 10pm-7am',
            ),
            onChanged: (v) => _formData['noiseRestrictions'] = v,
          ),
          const SizedBox(height: 20),
          TextFormField(
            initialValue: _formData['maintenanceResponsibilities'] ?? '',
            decoration: InputDecoration(
              labelText: 'Maintenance Responsibilities',
              prefixIcon: const Icon(Icons.handyman),
              filled: true,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
              hintText: 'e.g. Landlord handles all major repairs',
            ),
            onChanged: (v) => _formData['maintenanceResponsibilities'] = v,
          ),
          const SizedBox(height: 20),
          TextFormField(
            initialValue: _formData['sublettingPolicy'] ?? '',
            decoration: InputDecoration(
              labelText: 'Subletting Policy',
              prefixIcon: const Icon(Icons.swap_horiz),
              filled: true,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
              hintText: 'e.g. Not allowed without written consent',
            ),
            onChanged: (v) => _formData['sublettingPolicy'] = v,
          ),
          const SizedBox(height: 24),
          _SectionHeader(
            icon: Icons.contact_page,
            title: 'Contact Information',
            subtitle: 'How tenants can reach you',
          ),
          const SizedBox(height: 20),
          TextFormField(
            initialValue: _formData['contactMethod'] ?? '',
            decoration: InputDecoration(
              labelText: 'Preferred Contact Method',
              prefixIcon: const Icon(Icons.contact_mail),
              filled: true,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
              hintText: 'e.g. Phone, Email, Text',
            ),
            onChanged: (v) => _formData['contactMethod'] = v,
          ),
          const SizedBox(height: 20),
          TextFormField(
            initialValue: _formData['showingSchedule'] ?? '',
            decoration: InputDecoration(
              labelText: 'Showing Availability',
              prefixIcon: const Icon(Icons.schedule),
              filled: true,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
              hintText: 'e.g. Weekdays 5-7pm, Weekends 10am-2pm',
            ),
            onChanged: (v) => _formData['showingSchedule'] = v,
          ),
          const SizedBox(height: 20),
          TextFormField(
            initialValue: _formData['contactName'] ?? '',
            decoration: InputDecoration(
              labelText: 'Contact Name',
              prefixIcon: const Icon(Icons.person),
              filled: true,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
            ),
            onChanged: (v) => _formData['contactName'] = v,
          ),
          const SizedBox(height: 20),
          TextFormField(
            initialValue: _formData['contactRole'] ?? '',
            decoration: InputDecoration(
              labelText: 'Contact Role',
              prefixIcon: const Icon(Icons.badge),
              filled: true,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
              hintText: 'e.g. Owner, Property Manager',
            ),
            onChanged: (v) => _formData['contactRole'] = v,
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _buildReviewStep(ThemeData theme) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        children: [
          Center(
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: theme.colorScheme.primary.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(Iconsax.tick_circle, size: 48, color: theme.colorScheme.primary),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'Ready to submit!',
            textAlign: TextAlign.center,
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Review your property details before publishing',
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyMedium,
          ),
          const SizedBox(height: 32),
          _ReviewCard(
            icon: Iconsax.info_circle,
            title: 'Basic Information',
            items: {
              'Title': _formData['title'] ?? '',
              'Property Types': (_formData['propertyTypes'] ?? []).map((e) => _capitalize(e.name.replaceAll('_', ' '))).join(', '),
              'Rent Amount': '\$${_formData['rentAmount'] ?? '0'}/mo',
              'Available Date': _formData['availableDate'] != null
                  ? '${_formData['availableDate']!.toLocal()}'.split(' ')[0]
                  : 'Not set',
            },
          ),
          const SizedBox(height: 20),
          _ReviewCard(
            icon: Iconsax.rulerpen,
            title: 'Property Details',
            items: {
              'Bedrooms': _formData['bedrooms']?.toString() ?? '',
              'Bathrooms': _formData['bathrooms']?.toString() ?? '',
              'Square Footage': '${_formData['squareFootage'] ?? ''} sqft',
              'Furnishing': _capitalize((_formData['furnishingStatus'] ?? FurnishingStatus.unfurnished).name),
            },
          ),
          const SizedBox(height: 20),
          _ReviewCard(
            icon: Iconsax.location,
            title: 'Location',
            items: {
              'Address': _formData['address'] ?? '',
              'Transportation': (_formData['transportationAccess'] ?? []).join(', '),
            },
          ),
          const SizedBox(height: 20),
          _ReviewCard(
            icon: Iconsax.setting,
            title: 'Pricing & Rules',
            items: {
              'Utilities Included': (_formData['utilitiesIncluded'] ?? []).join(', '),
              'Lease Type': _capitalize((_formData['leaseType'] ?? LeaseType.fixedTerm).name),
              'Smoking Policy': _formData['smokingPolicy'] ?? '',
            },
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _formData['availableDate'] ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: Theme.of(context).colorScheme.primary,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() => _formData['availableDate'] = picked);
    }
  }
}

class _SectionHeader extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  
  const _SectionHeader({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: theme.colorScheme.primary.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, size: 24, color: theme.colorScheme.primary),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600)),
              const SizedBox(height: 4),
              Text(subtitle, style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurface.withOpacity(0.6))),
            ],
          ),
        ),
      ],
    );
  }
}

class _ReviewCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final Map<String, String> items;
  
  const _ReviewCard({
    required this.icon,
    required this.title,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: theme.dividerColor.withOpacity(0.2)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, size: 20, color: theme.colorScheme.primary),
                const SizedBox(width: 8),
                Text(title, style: theme.textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w600)),
              ],
            ),
            const SizedBox(height: 12),
            ...items.entries.map((e) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 2,
                    child: Text(
                      e.key,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurface.withOpacity(0.6),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: Text(
                      e.value,
                      style: theme.textTheme.bodyMedium,
                    ),
                  ),
                ],
              ),
            )),
          ],
        ),
      ),
    );
  }
}