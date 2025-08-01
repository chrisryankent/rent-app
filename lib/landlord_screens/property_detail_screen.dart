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
        automaticallyImplyLeading: true,
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
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 260,
            pinned: true,
            automaticallyImplyLeading: false,
            flexibleSpace: FlexibleSpaceBar(
              background: property.photos.isNotEmpty
                  ? PageView.builder(
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
                    )
                  : Container(color: Colors.grey[200]),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                // Title, price, address
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        property.title,
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Text(
                      '\u0024${property.rentAmount.toStringAsFixed(0)}/mo',
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: theme.colorScheme.primary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(Icons.location_on, size: 18, color: theme.hintColor),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        property.address,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.hintColor,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                // Features card
                const SizedBox(height: 20),
                Card(
                  elevation: 1,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          _featureIcon(theme, Icons.king_bed, '${property.bedrooms} Beds'),
                          const SizedBox(width: 16),
                          _featureIcon(theme, Icons.bathtub, '${property.bathrooms} Baths'),
                          const SizedBox(width: 16),
                          _featureIcon(theme, Icons.square_foot, '${property.squareFootage} sqft'),
                          const SizedBox(width: 16),
                          _featureIcon(theme, Icons.apartment, property.propertyTypes.map((e) => e.name).join(', ')),
                          const SizedBox(width: 16),
                          _featureIcon(theme, Icons.chair, property.furnishingStatus.name),
                        ],
                      ),
                    ),
                  ),
                ),
                // Description
                const SizedBox(height: 24),
                Text(
                  'Description',
                  style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 8),
                Text(
                  property.neighborhoodDesc,
                  style: theme.textTheme.bodyMedium?.copyWith(height: 1.5),
                ),
                // Amenities
                const SizedBox(height: 24),
                Text(
                  'Amenities',
                  style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: [
                    _chip('Heating: ${property.heatingType.name}'),
                    _chip('Cooling: ${property.coolingType.name}'),
                    _chip('Parking: ${property.parking}'),
                    _chip('Laundry: ${property.laundryFacilities}'),
                    _chip('Pets: ${property.petPolicy}'),
                    if (property.utilitiesIncluded.isNotEmpty)
                      _chip('Utilities: ${property.utilitiesIncluded.join(", ")}'),
                    if (property.accessibilityFeatures.isNotEmpty)
                      _chip('Accessibility: ${property.accessibilityFeatures.join(", ")}'),
                  ],
                ),
                // Lease & Terms
                const SizedBox(height: 24),
                Text(
                  'Lease & Terms',
                  style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: [
                    _chip('Deposit: \u0024${property.securityDeposit.toStringAsFixed(0)}'),
                    _chip('Lease: ${property.leaseType.name}'),
                    _chip('Min. Months: ${property.minLeaseMonths}'),
                    _chip('Application: ${property.applicationRequirements.join(", ")}'),
                    _chip('Smoking: ${property.smokingPolicy}'),
                    _chip('Guests: ${property.guestPolicy}'),
                  ],
                ),
                // Community
                const SizedBox(height: 24),
                Text(
                  'Community',
                  style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: [
                    if (property.communityFeatures.isNotEmpty)
                      _chip('Features: ${property.communityFeatures.join(", ")}'),
                    if (property.parks.isNotEmpty)
                      _chip('Parks: ${property.parks.join(", ")}'),
                    if (property.restaurants.isNotEmpty)
                      _chip('Restaurants: ${property.restaurants.join(", ")}'),
                    if (property.groceries.isNotEmpty)
                      _chip('Groceries: ${property.groceries.join(", ")}'),
                  ],
                ),
                // Special Features
                if (property.specialFeatures.isNotEmpty || (property.usp != null && property.usp!.isNotEmpty)) ...[
                  const SizedBox(height: 24),
                  Text(
                    'Special Features',
                    style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: [
                      if (property.specialFeatures.isNotEmpty)
                        _chip(property.specialFeatures.join(", ")),
                      if (property.usp != null && property.usp!.isNotEmpty)
                        _chip(property.usp!),
                    ],
                  ),
                ],
                // Details (optional, compact)
                const SizedBox(height: 24),
                ExpansionTile(
                  title: const Text('More Details'),
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: Column(
                        children: [
                          _detailRow('Available', property.availableDate.toLocal().toString().split(' ')[0],
                            onEdit: () => _showEditDialog(context, 'Available', property.availableDate.toLocal().toString().split(' ')[0], (v) {}),
                            isEmpty: false),
                          _detailRow('Floor Level', property.floorLevel.toString(),
                            onEdit: () => _showEditDialog(context, 'Floor Level', property.floorLevel.toString(), (v) {}),
                            isEmpty: false),
                          _detailRow('Total Floors', property.totalFloors.toString(),
                            onEdit: () => _showEditDialog(context, 'Total Floors', property.totalFloors.toString(), (v) {}),
                            isEmpty: false),
                          _detailRow('Noise Restrictions', property.noiseRestrictions,
                            onEdit: () => _showEditDialog(context, 'Noise Restrictions', property.noiseRestrictions, (v) {}),
                            isEmpty: property.noiseRestrictions.isEmpty,
                            onAdd: () => _showEditDialog(context, 'Noise Restrictions', '', (v) {})),
                          _detailRow('Maintenance', property.maintenanceResponsibilities,
                            onEdit: () => _showEditDialog(context, 'Maintenance', property.maintenanceResponsibilities, (v) {}),
                            isEmpty: property.maintenanceResponsibilities.isEmpty,
                            onAdd: () => _showEditDialog(context, 'Maintenance', '', (v) {})),
                          _detailRow('Subletting', property.sublettingPolicy,
                            onEdit: () => _showEditDialog(context, 'Subletting', property.sublettingPolicy, (v) {}),
                            isEmpty: property.sublettingPolicy.isEmpty,
                            onAdd: () => _showEditDialog(context, 'Subletting', '', (v) {})),
                          _detailRow('Contact', property.contactName,
                            onEdit: () => _showEditDialog(context, 'Contact', property.contactName, (v) {}),
                            isEmpty: property.contactName.isEmpty,
                            onAdd: () => _showEditDialog(context, 'Contact', '', (v) {})),
                          _detailRow('Contact Role', property.contactRole,
                            onEdit: () => _showEditDialog(context, 'Contact Role', property.contactRole, (v) {}),
                            isEmpty: property.contactRole.isEmpty,
                            onAdd: () => _showEditDialog(context, 'Contact Role', '', (v) {})),
                          _detailRow('Showing', property.showingSchedule,
                            onEdit: () => _showEditDialog(context, 'Showing', property.showingSchedule, (v) {}),
                            isEmpty: property.showingSchedule.isEmpty,
                            onAdd: () => _showEditDialog(context, 'Showing', '', (v) {})),
                          _detailRow('Certifications', property.safetyCertifications.join(', '),
                            onEdit: () => _showEditDialog(context, 'Certifications', property.safetyCertifications.join(', '), (v) {}),
                            isEmpty: property.safetyCertifications.isEmpty,
                            onAdd: () => _showEditDialog(context, 'Certifications', '', (v) {})),
                          _detailRow('Permits', property.buildingPermits.join(', '),
                            onEdit: () => _showEditDialog(context, 'Permits', property.buildingPermits.join(', '), (v) {}),
                            isEmpty: property.buildingPermits.isEmpty,
                            onAdd: () => _showEditDialog(context, 'Permits', '', (v) {})),
                          _detailRow('Rental License #', property.rentalLicenseNumber ?? '-',
                            onEdit: () => _showEditDialog(context, 'Rental License #', property.rentalLicenseNumber ?? '', (v) {}),
                            isEmpty: property.rentalLicenseNumber == null || property.rentalLicenseNumber!.isEmpty,
                            onAdd: () => _showEditDialog(context, 'Rental License #', '', (v) {})),
                          _detailRow('Energy Rating', property.energyRating ?? '-',
                            onEdit: () => _showEditDialog(context, 'Energy Rating', property.energyRating ?? '', (v) {}),
                            isEmpty: property.energyRating == null || property.energyRating!.isEmpty,
                            onAdd: () => _showEditDialog(context, 'Energy Rating', '', (v) {})),
                          _detailRow('Landmarks', property.nearbyLandmarks.join(', '),
                            onEdit: () => _showEditDialog(context, 'Landmarks', property.nearbyLandmarks.join(', '), (v) {}),
                            isEmpty: property.nearbyLandmarks.isEmpty,
                            onAdd: () => _showEditDialog(context, 'Landmarks', '', (v) {})),
                          _detailRow('Transport', property.transportationAccess.join(', '),
                            onEdit: () => _showEditDialog(context, 'Transport', property.transportationAccess.join(', '), (v) {}),
                            isEmpty: property.transportationAccess.isEmpty,
                            onAdd: () => _showEditDialog(context, 'Transport', '', (v) {})),
                          _detailRow('Distances', property.distancesToKeyLocations.entries.map((e) => "${e.key}: ${e.value}km").join(', '),
                            onEdit: () => _showEditDialog(context, 'Distances', property.distancesToKeyLocations.entries.map((e) => "${e.key}: ${e.value}km").join(', '), (v) {}),
                            isEmpty: property.distancesToKeyLocations.isEmpty,
                            onAdd: () => _showEditDialog(context, 'Distances', '', (v) {})),
                          _detailRow('Virtual Tour', property.virtualTourUrl ?? '-',
                            onEdit: () => _showEditDialog(context, 'Virtual Tour', property.virtualTourUrl ?? '', (v) {}),
                            isEmpty: property.virtualTourUrl == null || property.virtualTourUrl!.isEmpty,
                            onAdd: () => _showEditDialog(context, 'Virtual Tour', '', (v) {})),
                          _detailRow('Floor Plan', property.floorPlanImage ?? '-',
                            onEdit: () => _showEditDialog(context, 'Floor Plan', property.floorPlanImage ?? '', (v) {}),
                            isEmpty: property.floorPlanImage == null || property.floorPlanImage!.isEmpty,
                            onAdd: () => _showEditDialog(context, 'Floor Plan', '', (v) {})),
                          _detailRow('Video Walkthrough', property.videoWalkthrough ?? '-',
                            onEdit: () => _showEditDialog(context, 'Video Walkthrough', property.videoWalkthrough ?? '', (v) {}),
                            isEmpty: property.videoWalkthrough == null || property.videoWalkthrough!.isEmpty,
                            onAdd: () => _showEditDialog(context, 'Video Walkthrough', '', (v) {})),
                        ],
                      ),
                    ),
                  ],
                ),
              ]),
            ),
          ),
        ],
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Expanded(
              child: ElevatedButton.icon(
                icon: const Icon(Icons.edit),
                label: const Text('Edit Property'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: theme.colorScheme.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: onEdit,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: ElevatedButton.icon(
                icon: const Icon(Icons.delete),
                label: const Text('Delete'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: onDelete,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _featureIcon(ThemeData theme, IconData icon, String label) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: theme.colorScheme.primary.withOpacity(0.08),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: theme.colorScheme.primary, size: 22),
        ),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(fontSize: 11)),
      ],
    );
  }

  Widget _chip(String label) {
    return Chip(
      label: Text(label, style: const TextStyle(fontSize: 12)),
      backgroundColor: Colors.blue[50],
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    );
  }

  Widget _detailRow(String label, String value, {VoidCallback? onEdit, bool isEmpty = false, VoidCallback? onAdd}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
          Expanded(
            child: Text(value, style: const TextStyle(color: Colors.black87)),
          ),
          isEmpty
              ? IconButton(
                  icon: const Icon(Icons.add_circle_outline, size: 18, color: Colors.blue),
                  tooltip: 'Add',
                  onPressed: onAdd,
                )
              : IconButton(
                  icon: const Icon(Icons.edit, size: 18, color: Colors.orange),
                  tooltip: 'Update',
                  onPressed: onEdit,
                ),
        ],
      ),
    );
  }

  void _showEditDialog(BuildContext context, String field, String currentValue, void Function(String) onSave) {
    final controller = TextEditingController(text: currentValue);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Edit $field'),
        content: TextField(
          controller: controller,
          decoration: InputDecoration(labelText: field),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              onSave(controller.text);
              Navigator.pop(context);
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }
}
