// Property model for landlord upload

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
  final List<PropertyType> propertyTypes;
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
    required this.propertyTypes,
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

  static List<Property> get sampleData => [
    Property(
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
      virtualTourUrl: null,
      floorPlanImage: null,
      videoWalkthrough: null,
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
    ),
    Property(
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
      virtualTourUrl: null,
      floorPlanImage: null,
      videoWalkthrough: null,
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
    ),
  ];
}
