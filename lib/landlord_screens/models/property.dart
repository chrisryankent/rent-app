import 'package:flutter/material.dart';

enum PropertyType {
  apartment,
  house,
  sharedRoom,
  studio,
  luxuryApartment,
  shop,
  office,
  commercial,
  villa,
  penthouse,
  other,
}

enum FurnishingStatus { furnished, semiFurnished, unfurnished }

enum LeaseType { fixedTerm, monthToMonth }

enum HeatingType { central, electric, gas, none }

enum CoolingType { ac, ceilingFans, none }

enum PropertyStatus { active, pending, rented, maintenance }

extension PropertyStatusExtension on PropertyStatus {
  String get displayName {
    switch (this) {
      case PropertyStatus.active:
        return 'Active';
      case PropertyStatus.pending:
        return 'Pending';
      case PropertyStatus.rented:
        return 'Rented';
      case PropertyStatus.maintenance:
        return 'Maintenance';
    }
  }

  Color get color {
    switch (this) {
      case PropertyStatus.active:
        return Colors.green;
      case PropertyStatus.pending:
        return Colors.orange;
      case PropertyStatus.rented:
        return Colors.blue;
      case PropertyStatus.maintenance:
        return Colors.red;
    }
  }

  IconData get icon {
    switch (this) {
      case PropertyStatus.active:
        return Icons.check_circle;
      case PropertyStatus.pending:
        return Icons.pending;
      case PropertyStatus.rented:
        return Icons.assignment_turned_in;
      case PropertyStatus.maintenance:
        return Icons.handyman;
    }
  }
}

class Property {
  final String id;
  final String landlordId;
  final DateTime createdAt;
  final PropertyStatus status;
  final String title;
  final List<PropertyType> propertyTypes;
  final double rentAmount;
  final double securityDeposit;
  final DateTime availableDate;
  final int? bedrooms;
  final int? bathrooms;
  final double? squareFootage;
  final FurnishingStatus? furnishingStatus;
  final int? floorLevel;
  final int? totalFloors;
  final HeatingType? heatingType;
  final CoolingType? coolingType;
  final List<String>? kitchenAppliances;
  final String? laundryFacilities;
  final String? parking;
  final String? petPolicy;
  final List<String>? accessibilityFeatures;
  final String address;
  final String? neighborhoodDesc;
  final List<String>? nearbyLandmarks;
  final List<String>? transportationAccess;
  final Map<String, double>? distancesToKeyLocations;
  final List<String>? photos;
  final String? virtualTourUrl;
  final String? floorPlanImage;
  final String? videoWalkthrough;
  final List<String>? utilitiesIncluded;
  final double? avgUtilityCost;
  final List<String>? additionalFees;
  final int? minLeaseMonths;
  final LeaseType? leaseType;
  final List<String>? applicationRequirements;
  final String? smokingPolicy;
  final String? guestPolicy;
  final String? noiseRestrictions;
  final String? maintenanceResponsibilities;
  final String? sublettingPolicy;
  final String? contactMethod;
  final String? showingSchedule;
  final String? contactName;
  final String? contactRole;
  final List<String>? safetyCertifications;
  final List<String>? buildingPermits;
  final String? rentalLicenseNumber;
  final String? energyRating;
  final List<String>? parks;
  final List<String>? restaurants;
  final List<String>? groceries;
  final List<String>? communityFeatures;
  final List<String>? renovations;
  final List<String>? specialFeatures;
  final String? usp;
  final String description;

  List<String> get amenities {
    final amenities = <String>[];
    if ((parking ?? '').isNotEmpty) amenities.add('Parking');
    if ((petPolicy ?? '').toLowerCase().contains('allowed')) {
      amenities.add('Pet Friendly');
    }
    if ((laundryFacilities ?? '').toLowerCase().contains('in-unit')) {
      amenities.add('Laundry');
    }
    if (coolingType == CoolingType.ac) amenities.add('Air Conditioning');
    if (heatingType != null && heatingType != HeatingType.none) {
      amenities.add('Heating');
    }
    return amenities;
  }

  Property({
    required this.id,
    required this.landlordId,
    required this.createdAt,
    required this.status,
    required this.title,
    required this.propertyTypes,
    required this.rentAmount,
    required this.securityDeposit,
    required this.availableDate,
    this.bedrooms,
    this.bathrooms,
    this.squareFootage,
    this.furnishingStatus,
    this.floorLevel,
    this.totalFloors,
    this.heatingType,
    this.coolingType,
    this.kitchenAppliances,
    this.laundryFacilities,
    this.parking,
    this.petPolicy,
    this.accessibilityFeatures,
    required this.address,
    this.neighborhoodDesc,
    this.nearbyLandmarks,
    this.transportationAccess,
    this.distancesToKeyLocations,
    this.photos,
    this.virtualTourUrl,
    this.floorPlanImage,
    this.videoWalkthrough,
    this.utilitiesIncluded,
    this.avgUtilityCost,
    this.additionalFees,
    this.minLeaseMonths,
    this.leaseType,
    this.applicationRequirements,
    this.smokingPolicy,
    this.guestPolicy,
    this.noiseRestrictions,
    this.maintenanceResponsibilities,
    this.sublettingPolicy,
    this.contactMethod,
    this.showingSchedule,
    this.contactName,
    this.contactRole,
    this.safetyCertifications,
    this.buildingPermits,
    this.rentalLicenseNumber,
    this.energyRating,
    this.parks,
    this.restaurants,
    this.groceries,
    this.communityFeatures,
    this.renovations,
    this.specialFeatures,
    this.usp,
    required this.description, required List<String> amenities,
  });

  factory Property.empty() => Property(
    id: '',
    landlordId: '',
    createdAt: DateTime.now(),
    status: PropertyStatus.pending,
    title: '',
    propertyTypes: [],
    rentAmount: 0,
    securityDeposit: 0,
    availableDate: DateTime.now(),
    address: '',
    description: '', amenities: [],
  );

  static List<Property> get sampleData => [
    Property(
      id: '1',
      landlordId: 'landlord123',
      createdAt: DateTime.now().subtract(const Duration(days: 10)),
      status: PropertyStatus.active,
      title: 'Modern Downtown Studio',
      propertyTypes: [PropertyType.apartment, PropertyType.luxuryApartment],
      rentAmount: 1250,
      securityDeposit: 1250,
      availableDate: DateTime.now().add(const Duration(days: 7)),
      bedrooms: 1,
      bathrooms: 1,
      squareFootage: 650,
      furnishingStatus: FurnishingStatus.furnished,
      floorLevel: 5,
      totalFloors: 10,
      heatingType: HeatingType.central,
      coolingType: CoolingType.ac,
      kitchenAppliances: ['Refrigerator', 'Oven', 'Microwave'],
      laundryFacilities: 'In-unit',
      parking: 'Underground',
      petPolicy: 'Pets allowed with deposit',
      accessibilityFeatures: ['Elevator', 'Wheelchair accessible'],
      address: '123 Main St, Downtown, New York',
      neighborhoodDesc: 'Vibrant downtown area close to shopping and transit.',
      nearbyLandmarks: ['Central Park', 'City Mall'],
      transportationAccess: ['Subway', 'Bus'],
      distancesToKeyLocations: {'Central Park': 0.5, 'City Mall': 0.3},
      photos: ['lib/assets/property1.jpg'],
      utilitiesIncluded: ['Water', 'Trash'],
      avgUtilityCost: 120,
      additionalFees: ['Application fee'],
      minLeaseMonths: 12,
      leaseType: LeaseType.fixedTerm,
      applicationRequirements: ['Credit check', 'Proof of income'],
      smokingPolicy: 'No smoking',
      guestPolicy: 'Guests allowed, max 7 days',
      noiseRestrictions: 'Quiet hours 10pm-7am',
      maintenanceResponsibilities: 'Landlord',
      sublettingPolicy: 'Not allowed',
      contactMethod: 'Phone',
      showingSchedule: 'Weekdays 5-7pm',
      contactName: 'Alex Morgan',
      contactRole: 'Landlord',
      safetyCertifications: ['Fire safety'],
      buildingPermits: ['Occupancy permit'],
      rentalLicenseNumber: 'NYC-12345',
      energyRating: 'A',
      parks: ['Central Park'],
      restaurants: ['Joe’s Diner'],
      groceries: ['Whole Foods'],
      communityFeatures: ['Gym', 'Pool'],
      renovations: ['New kitchen'],
      specialFeatures: ['City view', 'Balcony'],
      usp: 'Best downtown value!',
      description: 'Beautiful modern studio in the heart of downtown with stunning city views and premium amenities.', amenities: [],
    ),
    Property(
      id: '2',
      landlordId: 'landlord123',
      createdAt: DateTime.now().subtract(const Duration(days: 5)),
      status: PropertyStatus.pending,
      title: 'Spacious Family Home',
      propertyTypes: [PropertyType.house],
      rentAmount: 2200,
      securityDeposit: 2200,
      availableDate: DateTime.now().add(const Duration(days: 14)),
      bedrooms: 3,
      bathrooms: 2,
      squareFootage: 1800,
      furnishingStatus: FurnishingStatus.semiFurnished,
      floorLevel: 1,
      totalFloors: 2,
      heatingType: HeatingType.gas,
      coolingType: CoolingType.ceilingFans,
      kitchenAppliances: ['Refrigerator', 'Dishwasher'],
      laundryFacilities: 'Shared',
      parking: 'Garage',
      petPolicy: 'No pets',
      accessibilityFeatures: [],
      address: '456 Oak Ave, Suburbia',
      neighborhoodDesc: 'Quiet family neighborhood with parks.',
      nearbyLandmarks: ['Oak Park'],
      transportationAccess: ['Bus'],
      distancesToKeyLocations: {'Oak Park': 0.2},
      photos: ['lib/assets/property2.jpg'],
      utilitiesIncluded: ['Water'],
      avgUtilityCost: 180,
      additionalFees: [],
      minLeaseMonths: 6,
      leaseType: LeaseType.monthToMonth,
      applicationRequirements: ['Background check'],
      smokingPolicy: 'No smoking',
      guestPolicy: 'Guests allowed',
      noiseRestrictions: 'None',
      maintenanceResponsibilities: 'Tenant',
      sublettingPolicy: 'Allowed with approval',
      contactMethod: 'Email',
      showingSchedule: 'Weekends 10am-2pm',
      contactName: 'Sarah Johnson',
      contactRole: 'Owner',
      safetyCertifications: ['Carbon monoxide detector'],
      buildingPermits: ['Renovation permit'],
      rentalLicenseNumber: 'SUB-67890',
      energyRating: 'B',
      parks: ['Oak Park'],
      restaurants: ['Family Pizza'],
      groceries: ['Local Market'],
      communityFeatures: ['Playground'],
      renovations: ['New roof'],
      specialFeatures: ['Large backyard'],
      usp: 'Perfect for families!',
      description: 'Spacious family home in a quiet suburban neighborhood with large backyard and playground nearby.', amenities: [],
    ),
  ];
}