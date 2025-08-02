import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
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
    final isDark = theme.brightness == Brightness.dark;
    final primaryColor = theme.colorScheme.primary;
    final backgroundColor = isDark ? Colors.grey[900]! : Colors.grey[50]!;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: Text(
          property.title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: theme.colorScheme.onSurface,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Iconsax.edit, color: theme.colorScheme.onSurface),
            onPressed: onEdit,
          ),
          IconButton(
            icon: Icon(Iconsax.trash, color: Colors.red[400]),
            onPressed: onDelete,
          ),
        ],
        backgroundColor: Colors.transparent,
        elevation: 0,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.black.withOpacity(0.6),
                Colors.transparent,
              ],
            ),
          ),
        ),
      ),
      extendBodyBehindAppBar: true,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverAppBar(
            expandedHeight: 320,
            pinned: true,
            automaticallyImplyLeading: false,
            flexibleSpace: FlexibleSpaceBar(
              collapseMode: CollapseMode.pin,
              background: Stack(
                fit: StackFit.expand,
                children: [
                  PageView.builder(
                    itemCount: property.photos?.isNotEmpty == true ? property.photos!.length : 1,
                    itemBuilder: (context, index) => Image.asset(
                      property.photos?.isNotEmpty == true
                          ? property.photos![index]
                          : 'assets/placeholder.jpg',
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.black.withOpacity(0.4),
                          Colors.transparent,
                          Colors.transparent,
                          backgroundColor.withOpacity(0.8),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    top: 80,
                    right: 16,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: property.status.color.withOpacity(0.9),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        property.status.displayName,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 16,
                    right: 16,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.5),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        property.photos?.isNotEmpty == true
                            ? '1/${property.photos!.length}'
                            : 'No images',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate([
              Container(
                color: backgroundColor,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            property.title,
                            style: theme.textTheme.headlineSmall?.copyWith(
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        Text(
                          '\u0024${property.rentAmount.toStringAsFixed(0)}/mo',
                          style: theme.textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.w700,
                            color: primaryColor,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(Iconsax.location, size: 18, color: theme.colorScheme.onSurface.withOpacity(0.7)),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            property.address,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: theme.colorScheme.onSurface.withOpacity(0.8),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    _buildQuickStats(theme),
                    const SizedBox(height: 32),
                    _buildSectionHeader(theme, Iconsax.document_text, 'Description'),
                    const SizedBox(height: 16),
                    Text(
                      property.neighborhoodDesc ?? '',
                      style: theme.textTheme.bodyLarge?.copyWith(
                        height: 1.6,
                        color: theme.colorScheme.onSurface.withOpacity(0.8),
                      ),
                    ),
                    const SizedBox(height: 32),
                    _buildSectionHeader(theme, Iconsax.star, 'Key Features'),
                    const SizedBox(height: 16),
                    _buildFeaturesGrid(theme),
                    const SizedBox(height: 32),
                    _buildSectionHeader(theme, Iconsax.home_wifi, 'Amenities'),
                    const SizedBox(height: 16),
                    _buildAmenitiesList(theme),
                    const SizedBox(height: 32),
                    _buildSectionHeader(theme, Iconsax.document, 'Lease & Terms'),
                    const SizedBox(height: 16),
                    _buildLeaseTerms(theme),
                    const SizedBox(height: 32),
                    _buildSectionHeader(theme, Iconsax.buildings, 'Community'),
                    const SizedBox(height: 16),
                    _buildCommunityFeatures(theme),
                    if (property.specialFeatures != null && property.specialFeatures!.isNotEmpty || 
                        (property.usp != null && property.usp!.isNotEmpty)) ...[
                      const SizedBox(height: 32),
                      _buildSectionHeader(theme, Iconsax.flash, 'Special Features'),
                      const SizedBox(height: 16),
                      _buildSpecialFeatures(theme),
                    ],
                    const SizedBox(height: 32),
                    _buildSectionHeader(theme, Iconsax.info_circle, 'Detailed Information'),
                    const SizedBox(height: 16),
                    _buildDetailedInfo(theme),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ]),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        decoration: BoxDecoration(
          color: theme.cardColor,
          border: Border(top: BorderSide(color: theme.dividerColor.withOpacity(0.1))),
        ),
        child: Row(
          children: [
            Expanded(
              child: ElevatedButton.icon(
                icon: const Icon(Iconsax.edit),
                label: const Text('Edit Property'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 18),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                ),
                onPressed: onEdit,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: ElevatedButton.icon(
                icon: const Icon(Iconsax.trash),
                label: const Text('Delete'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red.withOpacity(0.1),
                  foregroundColor: Colors.red,
                  padding: const EdgeInsets.symmetric(vertical: 18),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                ),
                onPressed: onDelete,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickStats(ThemeData theme) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: theme.dividerColor.withOpacity(0.1)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _statItem(theme, Iconsax.ruler, '${property.squareFootage?.toStringAsFixed(0)} sqft'),
            _statItem(theme, Iconsax.battery_charging, '${property.bedrooms} Beds'),
            _statItem(theme, Iconsax.back_square, '${property.bathrooms} Baths'),
            _statItem(theme, Iconsax.buildings, property.propertyTypes.map((e) => e.name).join(', ')),
          ],
        ),
      ),
    );
  }

  Widget _statItem(ThemeData theme, IconData icon, String label) {
    return Column(
      children: [
        Icon(icon, size: 22, color: theme.colorScheme.primary),
        const SizedBox(height: 6),
        Text(
          label,
          style: theme.textTheme.bodySmall?.copyWith(
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildSectionHeader(ThemeData theme, IconData icon, String title) {
    return Row(
      children: [
        Icon(icon, size: 24, color: theme.colorScheme.primary),
        const SizedBox(width: 12),
        Text(
          title,
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }

  Widget _buildFeaturesGrid(ThemeData theme) {
    final features = [
      _FeatureItem('Furnishing', property.furnishingStatus?.name ?? 'Not specified'),
      _FeatureItem('Heating', property.heatingType?.name ?? 'Not specified'),
      _FeatureItem('Cooling', property.coolingType?.name ?? 'Not specified'),
      _FeatureItem('Parking', property.parking ?? 'Not specified'),
      _FeatureItem('Laundry', property.laundryFacilities ?? 'Not specified'),
      _FeatureItem('Pets', property.petPolicy ?? 'Not specified'),
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 4,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: features.length,
      itemBuilder: (context, index) {
        final item = features[index];
        return Container(
          decoration: BoxDecoration(
            color: theme.cardColor,
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  item.label,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                    color: theme.colorScheme.onSurface.withOpacity(0.6),
                  ),
                ),
              ),
              Text(
                item.value,
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildAmenitiesList(ThemeData theme) {
    final amenities = [
      if (property.kitchenAppliances != null) 
        ...property.kitchenAppliances!.map((e) => _AmenityItem(e, Icons.kitchen)),
      if (property.accessibilityFeatures != null)
        ...property.accessibilityFeatures!.map((e) => _AmenityItem(e, Icons.accessibility)),
      if (property.utilitiesIncluded != null)
        ...property.utilitiesIncluded!.map((e) => _AmenityItem(e, Icons.electrical_services)),
    ];

    return amenities.isEmpty
        ? Text(
            'No amenities listed',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurface.withOpacity(0.5),
            ),
          )
        : Wrap(
            spacing: 12,
            runSpacing: 12,
            children: amenities
                .map((item) => Chip(
                      label: Text(item.label),
                      avatar: Icon(item.icon, size: 16),
                      backgroundColor: theme.cardColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ))
                .toList(),
          );
  }

  Widget _buildLeaseTerms(ThemeData theme) {
    final terms = [
      _TermItem('Lease Type', property.leaseType?.name ?? 'Not specified'),
      _TermItem('Security Deposit', property.securityDeposit != null ? '\u0024${property.securityDeposit.toStringAsFixed(0)}' : 'Not specified'),
      _TermItem('Minimum Lease', property.minLeaseMonths != null ? '${property.minLeaseMonths} months' : 'Not specified'),
      _TermItem('Application Requirements', property.applicationRequirements?.join(', ') ?? 'Not specified'),
      _TermItem('Smoking Policy', property.smokingPolicy ?? 'Not specified'),
      _TermItem('Guest Policy', property.guestPolicy ?? 'Not specified'),
    ];

    return Column(
      children: terms
          .map((item) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 2,
                      child: Text(
                        item.label,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onSurface.withOpacity(0.6),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 3,
                      child: Text(
                        item.value,
                        style: theme.textTheme.bodyMedium,
                      ),
                    ),
                  ],
                ),
              ))
          .toList(),
    );
  }

  Widget _buildCommunityFeatures(ThemeData theme) {
    final features = [
      if (property.communityFeatures != null && property.communityFeatures!.isNotEmpty)
        _CommunityItem('Community Features', property.communityFeatures!.join(', ')),
      if (property.parks != null && property.parks!.isNotEmpty) _CommunityItem('Parks', property.parks!.join(', ')),
      if (property.restaurants != null && property.restaurants!.isNotEmpty) _CommunityItem('Restaurants', property.restaurants!.join(', ')),
      if (property.groceries != null && property.groceries!.isNotEmpty) _CommunityItem('Groceries', property.groceries!.join(', ')),
    ];

    return features.isEmpty
        ? Text(
            'No community features listed',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurface.withOpacity(0.5),
            ),
          )
        : Column(
            children: features
                .map((item) => Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.label,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            item.value,
                            style: theme.textTheme.bodyMedium,
                          ),
                        ],
                      ),
                    ))
                .toList(),
          );
  }

  Widget _buildSpecialFeatures(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (property.specialFeatures != null && property.specialFeatures!.isNotEmpty)
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: property.specialFeatures!
                .map((feature) => Chip(
                      label: Text(feature),
                      backgroundColor: theme.colorScheme.primary.withOpacity(0.1),
                    ))
                .toList(),
          ),
        if (property.usp != null && property.usp!.isNotEmpty) ...[
          const SizedBox(height: 16),
          Text(
            'Unique Selling Point:',
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            property.usp!,
            style: theme.textTheme.bodyLarge,
          ),
        ],
      ],
    );
  }

  Widget _buildDetailedInfo(ThemeData theme) {
    final details = [
      _DetailCategory(
        title: 'Contact Information',
        items: [
          _DetailItem('Contact Name', property.contactName ?? 'Not specified'),
          _DetailItem('Contact Role', property.contactRole ?? 'Not specified'),
          _DetailItem('Contact Method', property.contactMethod ?? 'Not specified'),
          _DetailItem('Showing Schedule', property.showingSchedule ?? 'Not specified'),
        ],
      ),
      _DetailCategory(
        title: 'Building Information',
        items: [
          _DetailItem('Floor Level', property.floorLevel?.toString() ?? 'Not specified'),
          _DetailItem('Total Floors', property.totalFloors?.toString() ?? 'Not specified'),
          _DetailItem('Available Date', property.availableDate.toLocal().toString().split(' ')[0]),
        ],
      ),
      _DetailCategory(
        title: 'Certifications',
        items: [
          _DetailItem('Safety Certifications', property.safetyCertifications?.join(', ') ?? 'Not specified'),
          _DetailItem('Building Permits', property.buildingPermits?.join(', ') ?? 'Not specified'),
          _DetailItem('Rental License #', property.rentalLicenseNumber ?? 'Not specified'),
          _DetailItem('Energy Rating', property.energyRating ?? 'Not specified'),
        ],
      ),
    ];

    return Column(
      children: details
          .map((category) => _DetailCategoryCard(
                theme: theme,
                category: category,
              ))
          .toList(),
    );
  }
}

class _FeatureItem {
  final String label;
  final String value;

  _FeatureItem(this.label, this.value);
}

class _AmenityItem {
  final String label;
  final IconData icon;

  _AmenityItem(this.label, this.icon);
}

class _TermItem {
  final String label;
  final String value;

  _TermItem(this.label, this.value);
}

class _CommunityItem {
  final String label;
  final String value;

  _CommunityItem(this.label, this.value);
}

class _DetailCategory {
  final String title;
  final List<_DetailItem> items;

  _DetailCategory({required this.title, required this.items});
}

class _DetailItem {
  final String label;
  final String value;

  _DetailItem(this.label, this.value);
}

class _DetailCategoryCard extends StatelessWidget {
  final ThemeData theme;
  final _DetailCategory category;

  const _DetailCategoryCard({
    required this.theme,
    required this.category,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: theme.dividerColor.withOpacity(0.1)),
      ),
      child: ExpansionTile(
        title: Text(
          category.title,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        children: [
          ...category.items.map((item) => ListTile(
                title: Text(
                  item.label,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurface.withOpacity(0.7),
                  ),
                ),
                subtitle: Text(
                  item.value,
                  style: theme.textTheme.bodyMedium,
                ),
              )),
        ],
      ),
    );
  }
}