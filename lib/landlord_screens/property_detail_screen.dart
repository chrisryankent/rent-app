import 'package:flutter/material.dart';
import 'models/property.dart';

class PropertyDetailScreen extends StatelessWidget {
  final Property property;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;
  const PropertyDetailScreen({
    super.key,
    required this.property,
    this.onEdit,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          property.title,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(icon: const Icon(Icons.edit), onPressed: onEdit),
          IconButton(icon: const Icon(Icons.delete), onPressed: onDelete),
        ],
        backgroundColor: theme.appBarTheme.backgroundColor,
        foregroundColor: theme.appBarTheme.foregroundColor,
        elevation: theme.appBarTheme.elevation,
        iconTheme: theme.appBarTheme.iconTheme,
        titleTextStyle: theme.appBarTheme.titleTextStyle,
      ),
      body: ListView(
        padding: const EdgeInsets.all(0),
        children: [
          // Image carousel
          if (property.photos.isNotEmpty)
            SizedBox(
              height: 240,
              child: PageView.builder(
                itemCount: property.photos.length,
                itemBuilder: (context, index) => ClipRRect(
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(24),
                    bottomRight: Radius.circular(24),
                  ),
                  child: Image.asset(
                    property.photos[index],
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          // Card with main info
          Container(
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: theme.cardColor,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: theme.shadowColor.withOpacity(0.08),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        property.title,
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.blue.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Text(
                        '\$${property.rentAmount.toStringAsFixed(0)}/mo',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.blue,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.location_on, size: 18, color: Colors.blue),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        property.address,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: Colors.grey[700],
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 12,
                  runSpacing: 8,
                  children: [
                    _infoChip(Icons.king_bed, '${property.bedrooms} beds'),
                    _infoChip(Icons.bathtub, '${property.bathrooms} baths'),
                    _infoChip(
                      Icons.square_foot,
                      '${property.squareFootage} sqft',
                    ),
                    _infoChip(Icons.apartment, property.propertyType.name),
                    _infoChip(Icons.chair, property.furnishingStatus.name),
                  ],
                ),
                const SizedBox(height: 16),
                Divider(color: Colors.grey[300]),
                const SizedBox(height: 8),
                Text(
                  'Description',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  property.neighborhoodDesc,
                  style: theme.textTheme.bodyMedium,
                ),
                const SizedBox(height: 16),
                Divider(color: Colors.grey[300]),
                const SizedBox(height: 8),
                Text(
                  'Details',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                _detailRow('Security Deposit', '\$${property.securityDeposit}'),
                _detailRow(
                  'Available',
                  property.availableDate.toLocal().toString().split(' ')[0],
                ),
                _detailRow('Floor Level', property.floorLevel.toString()),
                _detailRow('Total Floors', property.totalFloors.toString()),
                _detailRow('Heating', property.heatingType.name),
                _detailRow('Cooling', property.coolingType.name),
                _detailRow('Parking', property.parking),
                _detailRow('Pet Policy', property.petPolicy),
                _detailRow('Laundry', property.laundryFacilities),
                _detailRow(
                  'Accessibility',
                  property.accessibilityFeatures.join(', '),
                ),
                _detailRow(
                  'Utilities Included',
                  property.utilitiesIncluded.join(', '),
                ),
                _detailRow(
                  'Avg Utility Cost',
                  property.avgUtilityCost?.toString() ?? '-',
                ),
                _detailRow(
                  'Additional Fees',
                  property.additionalFees.join(', '),
                ),
                _detailRow(
                  'Min Lease Months',
                  property.minLeaseMonths.toString(),
                ),
                _detailRow('Lease Type', property.leaseType.name),
                _detailRow(
                  'Application Requirements',
                  property.applicationRequirements.join(', '),
                ),
                _detailRow('Smoking Policy', property.smokingPolicy),
                _detailRow('Guest Policy', property.guestPolicy),
                _detailRow('Noise Restrictions', property.noiseRestrictions),
                _detailRow('Maintenance', property.maintenanceResponsibilities),
                _detailRow('Subletting', property.sublettingPolicy),
                _detailRow('Contact Method', property.contactMethod),
                _detailRow('Showing Schedule', property.showingSchedule),
                _detailRow('Contact Name', property.contactName),
                _detailRow('Contact Role', property.contactRole),
                _detailRow(
                  'Safety Certifications',
                  property.safetyCertifications.join(', '),
                ),
                _detailRow(
                  'Building Permits',
                  property.buildingPermits.join(', '),
                ),
                _detailRow(
                  'Rental License #',
                  property.rentalLicenseNumber ?? '-',
                ),
                _detailRow('Energy Rating', property.energyRating ?? '-'),
                _detailRow('Parks', property.parks.join(', ')),
                _detailRow('Restaurants', property.restaurants.join(', ')),
                _detailRow('Groceries', property.groceries.join(', ')),
                _detailRow(
                  'Community Features',
                  property.communityFeatures.join(', '),
                ),
                _detailRow('Renovations', property.renovations.join(', ')),
                _detailRow(
                  'Special Features',
                  property.specialFeatures.join(', '),
                ),
                _detailRow('USP', property.usp ?? '-'),
                _detailRow(
                  'Nearby Landmarks',
                  property.nearbyLandmarks.join(', '),
                ),
                _detailRow(
                  'Transport',
                  property.transportationAccess.join(', '),
                ),
                _detailRow(
                  'Distances',
                  property.distancesToKeyLocations.entries
                      .map((e) => "${e.key}: ${e.value}km")
                      .join(', '),
                ),
                _detailRow('Virtual Tour', property.virtualTourUrl ?? '-'),
                _detailRow('Floor Plan', property.floorPlanImage ?? '-'),
                _detailRow(
                  'Video Walkthrough',
                  property.videoWalkthrough ?? '-',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _infoChip(IconData icon, String label) {
    return Chip(
      avatar: Icon(icon, size: 16, color: Colors.blue),
      label: Text(label, style: const TextStyle(fontSize: 13)),
      backgroundColor: Colors.blue[50],
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    );
  }

  Widget _detailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 140,
            child: Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
          Expanded(
            child: Text(value, style: const TextStyle(color: Colors.black87)),
          ),
        ],
      ),
    );
  }
}
