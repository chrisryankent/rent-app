enum PropertyType { apartment, house, sharedRoom, studio, other }

class UploadFormSteps {
  static const List<String> steps = [
    "Basic Info",
    "Property Details",
    "Amenities",
    "Location",
    "Photos & Media",
    "Pricing",
    "Rules & Terms",
    "Review",
  ];
}

class RequiredFields {
  static const List<String> mandatory = [
    'title',
    'propertyType',
    'bedrooms',
    'bathrooms',
    'rentAmount',
    'address',
    'photos',
  ];
}