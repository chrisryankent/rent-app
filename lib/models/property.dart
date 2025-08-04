import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// Property model for unified app

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
        return Colors.red;
      case PropertyStatus.maintenance:
        return Colors.blueGrey;
    }
  }
}

class Property {
  final String id;
  final String ownerId;
  final DateTime createdAt;
  final PropertyStatus status;
  final String title;
  final List<PropertyType> propertyTypes;
  final double rentAmount;
  final String address;
  final String description;
  // Optional fields
  final double? securityDeposit;
  final DateTime? availableDate;
  final int? bedrooms;
  final int? bathrooms;
  final double? squareFootage;
  final FurnishingStatus? furnishingStatus;
  final int? floorLevel;
  final int? totalFloors;
  final HeatingType? heatingType;
  final CoolingType? coolingType;
  final List<String>? kitchenAppliances;
  final List<String>? images;
  final List<String>? amenities;
  final List<String>? laundryFacilities;
  final String? parking;
  final String? petPolicy;
  final List<String>? accessibilityFeatures;
  final String? neighborhoodDesc;
  final String? transportationAccess;
  final List<String>? photos;
  final String? virtualTourUrl;
  final String? videoWalkthrough;
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
  final bool? isNew;
  final bool? isRecommended;
  final bool? isFeatured;

  Property({
    required this.id,
    required this.ownerId,
    required this.createdAt,
    required this.status,
    required this.title,
    required this.propertyTypes,
    required this.rentAmount,
    required this.address,
    required this.description,
    // Optional fields
    this.securityDeposit,
    this.availableDate,
    this.bedrooms,
    this.bathrooms,
    this.squareFootage,
    this.furnishingStatus,
    this.floorLevel,
    this.totalFloors,
    this.heatingType,
    this.coolingType,
    this.kitchenAppliances,
    this.images,
    this.amenities,
    this.laundryFacilities,
    this.parking,
    this.petPolicy,
    this.accessibilityFeatures,
    this.neighborhoodDesc,
    this.transportationAccess,
    this.photos,
    this.virtualTourUrl,
    this.videoWalkthrough,
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
    this.isNew,
    this.isRecommended,
    this.isFeatured,
  });

  String get timeAgo {
    final now = DateTime.now();
    final difference = now.difference(createdAt);
    if (difference.inDays > 30) {
      return '${(difference.inDays / 30).floor()} months ago';
    } else if (difference.inDays > 0) {
      return '${difference.inDays} days ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} hours ago';
    } else {
      return 'Just now';
    }
  }

  factory Property.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Property(
      id: doc.id,
      ownerId: data['ownerId'] ?? '',
      createdAt: (data['createdAt'] is Timestamp)
          ? (data['createdAt'] as Timestamp).toDate()
          : DateTime.tryParse(data['createdAt'] ?? '') ?? DateTime.now(),
      status: PropertyStatus.values.firstWhere(
        (e) => e.name == (data['status'] ?? 'active'),
        orElse: () => PropertyStatus.active,
      ),
      title: data['title'] ?? '',
      propertyTypes:
          (data['propertyTypes'] as List?)?.map((e) {
            return PropertyType.values.firstWhere(
              (t) => t.name == e,
              orElse: () => PropertyType.other,
            );
          }).toList() ??
          [PropertyType.other],
      rentAmount: (data['rentAmount'] is int)
          ? (data['rentAmount'] as int).toDouble()
          : (data['rentAmount'] ?? 0.0),
      address: data['address'] ?? '',
      description: data['description'] ?? '',
      securityDeposit: (data['securityDeposit'] as num?)?.toDouble(),
      availableDate: (data['availableDate'] is Timestamp)
          ? (data['availableDate'] as Timestamp).toDate()
          : null,
      bedrooms: data['bedrooms'],
      bathrooms: data['bathrooms'],
      squareFootage: (data['squareFootage'] as num?)?.toDouble(),
      furnishingStatus: data['furnishingStatus'] != null
          ? FurnishingStatus.values.firstWhere(
              (e) => e.name == data['furnishingStatus'],
              orElse: () => FurnishingStatus.unfurnished,
            )
          : null,
      floorLevel: data['floorLevel'],
      totalFloors: data['totalFloors'],
      heatingType: data['heatingType'] != null
          ? HeatingType.values.firstWhere(
              (e) => e.name == data['heatingType'],
              orElse: () => HeatingType.none,
            )
          : null,
      coolingType: data['coolingType'] != null
          ? CoolingType.values.firstWhere(
              (e) => e.name == data['coolingType'],
              orElse: () => CoolingType.none,
            )
          : null,
      kitchenAppliances: (data['kitchenAppliances'] as List?)?.cast<String>(),
      images: (data['images'] as List?)?.cast<String>(),
      amenities: (data['amenities'] as List?)?.cast<String>(),
      laundryFacilities: (data['laundryFacilities'] as List?)?.cast<String>(),
      parking: data['parking'],
      petPolicy: data['petPolicy'],
      accessibilityFeatures: (data['accessibilityFeatures'] as List?)
          ?.cast<String>(),
      neighborhoodDesc: data['neighborhoodDesc'],
      transportationAccess: data['transportationAccess'],
      photos: (data['photos'] as List?)?.cast<String>(),
      virtualTourUrl: data['virtualTourUrl'],
      videoWalkthrough: data['videoWalkthrough'],
      minLeaseMonths: data['minLeaseMonths'],
      leaseType: data['leaseType'] != null
          ? LeaseType.values.firstWhere(
              (e) => e.name == data['leaseType'],
              orElse: () => LeaseType.monthToMonth,
            )
          : null,
      applicationRequirements: (data['applicationRequirements'] as List?)
          ?.cast<String>(),
      smokingPolicy: data['smokingPolicy'],
      guestPolicy: data['guestPolicy'],
      noiseRestrictions: data['noiseRestrictions'],
      maintenanceResponsibilities: data['maintenanceResponsibilities'],
      sublettingPolicy: data['sublettingPolicy'],
      contactMethod: data['contactMethod'],
      showingSchedule: data['showingSchedule'],
      contactName: data['contactName'],
      contactRole: data['contactRole'],
      safetyCertifications: (data['safetyCertifications'] as List?)
          ?.cast<String>(),
      buildingPermits: (data['buildingPermits'] as List?)?.cast<String>(),
      rentalLicenseNumber: data['rentalLicenseNumber'],
      energyRating: data['energyRating'],
      parks: (data['parks'] as List?)?.cast<String>(),
      restaurants: (data['restaurants'] as List?)?.cast<String>(),
      groceries: (data['groceries'] as List?)?.cast<String>(),
      communityFeatures: (data['communityFeatures'] as List?)?.cast<String>(),
      renovations: (data['renovations'] as List?)?.cast<String>(),
      specialFeatures: (data['specialFeatures'] as List?)?.cast<String>(),
      usp: data['usp'],
      isNew: data['isNew'] ?? false,
      isRecommended: data['isRecommended'] ?? false,
      isFeatured: data['isFeatured'] ?? false,
    );
  }

  static List<Property> get sampleData => [
    Property(
      id: 'p1',
      ownerId: 'u1',
      createdAt: DateTime.now().subtract(const Duration(days: 1)),
      status: PropertyStatus.active,
      title: 'Modern Studio Apartment',
      propertyTypes: [PropertyType.apartment],
      rentAmount: 1200,
      address: '123 Main St, Downtown',
      description:
          'Beautiful studio apartment with city views and modern amenities.',
      // Optional fields
      securityDeposit: 1200,
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
      images: ['lib/assets/property1.jpg'],
    ),
    Property(
      id: 'p2',
      ownerId: 'u2',
      createdAt: DateTime.now().subtract(const Duration(days: 3)),
      status: PropertyStatus.pending,
      title: 'Spacious Family Home',
      propertyTypes: [PropertyType.house],
      rentAmount: 2200,
      address: '456 Oak Ave, Suburbia',
      description: 'Spacious home in a quiet neighborhood with large backyard.',
      // Optional fields
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
      images: ['lib/assets/property2.jpg'],
    ),
    Property(
      id: 'p3',
      ownerId: 'u3',
      createdAt: DateTime.now().subtract(const Duration(hours: 5)),
      status: PropertyStatus.active,
      title: 'Waterfront Luxury Condo',
      propertyTypes: [PropertyType.luxuryApartment],
      rentAmount: 3200,
      address: '789 Ocean Dr, Miami',
      description:
          'Stunning waterfront condo with panoramic views and premium amenities.',
      // Optional fields
      securityDeposit: 3200,
      availableDate: DateTime.now().add(const Duration(days: 30)),
      bedrooms: 2,
      bathrooms: 2,
      squareFootage: 1400,
      furnishingStatus: FurnishingStatus.furnished,
      floorLevel: 12,
      totalFloors: 20,
      heatingType: HeatingType.central,
      coolingType: CoolingType.ac,
      kitchenAppliances: ['Refrigerator', 'Oven', 'Dishwasher'],
      images: ['lib/assets/property3.jpg'],
    ),
  ];
}
