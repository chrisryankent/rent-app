// Property model for landlord upload
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

class Property {
  // 1. Basics
  final String title;
  final PropertyType propertyType;
  final double rentAmount;
  final double securityDeposit;
  final DateTime availableDate;

  // 2. Details
  final int bedrooms;
  final int bathrooms;
  final double squareFootage;
  final FurnishingStatus furnishingStatus;
  final int floorLevel;
  final int totalFloors;

  // 3. Amenities
  final HeatingType heatingType;
  final CoolingType coolingType;
  final List<String> kitchenAppliances;
  final String laundryFacilities;
  final String parking;
  final String petPolicy;
  final List<String> accessibilityFeatures;

  // 4. Location
  final String address;
  final String neighborhoodDesc;
  final List<String> nearbyLandmarks;
  final List<String> transportationAccess;
  final Map<String, double> distancesToKeyLocations;

  // 5. Visuals
  final List<String> photos;
  final String? virtualTourUrl;
  final String? floorPlanImage;
  final String? videoWalkthrough;

  // 6. Utilities
  final List<String> utilitiesIncluded;
  final double? avgUtilityCost;
  final List<String> additionalFees;

  // 7. Lease Terms
  final int minLeaseMonths;
  final LeaseType leaseType;
  final List<String> applicationRequirements;
  final String smokingPolicy;

  // 8. Rules
  final String guestPolicy;
  final String noiseRestrictions;
  final String maintenanceResponsibilities;
  final String sublettingPolicy;

  // 9. Contact
  final String contactMethod;
  final String showingSchedule;
  final String contactName;
  final String contactRole;

  // 10. Certifications
  final List<String> safetyCertifications;
  final List<String> buildingPermits;
  final String? rentalLicenseNumber;
  final String? energyRating;

  // 11. Neighborhood
  final List<String> parks;
  final List<String> restaurants;
  final List<String> groceries;
  final List<String> communityFeatures;

  // 12. Unique Selling Points
  final List<String> renovations;
  final List<String> specialFeatures;
  final String? usp;

  Property({
    required this.title,
    required this.propertyType,
    required this.rentAmount,
    required this.securityDeposit,
    required this.availableDate,
    required this.bedrooms,
    required this.bathrooms,
    required this.squareFootage,
    required this.furnishingStatus,
    required this.floorLevel,
    required this.totalFloors,
    required this.heatingType,
    required this.coolingType,
    required this.kitchenAppliances,
    required this.laundryFacilities,
    required this.parking,
    required this.petPolicy,
    required this.accessibilityFeatures,
    required this.address,
    required this.neighborhoodDesc,
    required this.nearbyLandmarks,
    required this.transportationAccess,
    required this.distancesToKeyLocations,
    required this.photos,
    this.virtualTourUrl,
    this.floorPlanImage,
    this.videoWalkthrough,
    required this.utilitiesIncluded,
    this.avgUtilityCost,
    required this.additionalFees,
    required this.minLeaseMonths,
    required this.leaseType,
    required this.applicationRequirements,
    required this.smokingPolicy,
    required this.guestPolicy,
    required this.noiseRestrictions,
    required this.maintenanceResponsibilities,
    required this.sublettingPolicy,
    required this.contactMethod,
    required this.showingSchedule,
    required this.contactName,
    required this.contactRole,
    required this.safetyCertifications,
    required this.buildingPermits,
    this.rentalLicenseNumber,
    this.energyRating,
    required this.parks,
    required this.restaurants,
    required this.groceries,
    required this.communityFeatures,
    required this.renovations,
    required this.specialFeatures,
    this.usp,
  });
}
