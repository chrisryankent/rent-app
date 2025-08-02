import 'package:flutter/material.dart';
import 'models/property.dart';
import 'property_detail_screen.dart';
import 'edit_property_screen.dart';
import 'property_upload_form.dart';
import '../theme_provider.dart';
import 'package:provider/provider.dart';

class PropertyListScreen extends StatefulWidget {
  final VoidCallback onCreateProperty;
  final int currentTabIndex;
  final void Function(int) onTabTapped;
  
  const PropertyListScreen({
    super.key,
    required this.onCreateProperty,
    required this.currentTabIndex,
    required this.onTabTapped,
  });

  @override
  State<PropertyListScreen> createState() => _PropertyListScreenState();
}

class _PropertyListScreenState extends State<PropertyListScreen> {
  final List<Property> _properties = List<Property>.from(Property.sampleData);
  final String _currentLandlordId = 'landlord123';
  String _searchQuery = '';
  PropertySortOption _sortOption = PropertySortOption.newestFirst;
  PropertyStatus _filterStatus = PropertyStatus.active;

  void _addProperty(Property property) {
    setState(() {
      _properties.insert(0, property);
    });
  }

  void _editProperty(int index, Property updated) {
    setState(() {
      _properties[index] = updated;
    });
  }

  Future<void> _deleteProperty(int index) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirm Delete'),
        content: const Text('Are you sure you want to delete this property?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      setState(() {
        _properties.removeAt(index);
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Property deleted successfully'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  List<Property> get _filteredProperties {
    List<Property> result = _properties.where((property) {
      final matchesLandlord = property.landlordId == _currentLandlordId;
      final matchesSearch = property.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          property.address.toLowerCase().contains(_searchQuery.toLowerCase());
      final matchesStatus = property.status == _filterStatus;
      return matchesLandlord && matchesSearch && matchesStatus;
    }).toList();

    switch (_sortOption) {
      case PropertySortOption.newestFirst:
        result.sort((a, b) => b.createdAt.compareTo(a.createdAt));
        break;
      case PropertySortOption.oldestFirst:
        result.sort((a, b) => a.createdAt.compareTo(b.createdAt));
        break;
      case PropertySortOption.rentHighToLow:
        result.sort((a, b) => b.rentAmount.compareTo(a.rentAmount));
        break;
      case PropertySortOption.rentLowToHigh:
        result.sort((a, b) => a.rentAmount.compareTo(b.rentAmount));
        break;
    }

    return result;
  }

  List<Property> get _landlordProperties => 
      _properties.where((p) => p.landlordId == _currentLandlordId).toList();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final filteredProperties = _filteredProperties;
    final landlordProperties = _landlordProperties;
    final activeProperties = landlordProperties.where((p) => p.status == PropertyStatus.active).length;
    final pendingProperties = landlordProperties.where((p) => p.status == PropertyStatus.pending).length;
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Properties', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: theme.appBarTheme.backgroundColor,
        foregroundColor: theme.appBarTheme.foregroundColor,
        elevation: theme.appBarTheme.elevation,
        iconTheme: theme.appBarTheme.iconTheme,
        titleTextStyle: theme.appBarTheme.titleTextStyle,
        actions: [
          IconButton(
            icon: Icon(Icons.filter_list_rounded, color: theme.colorScheme.primary),
            tooltip: 'Filter Properties',
            onPressed: () => _showFilterOptions(context),
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search your properties...',
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: theme.cardColor,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16),
              ),
              onChanged: (value) => setState(() => _searchQuery = value),
            ),
          ),
        ),
      ),
      body: SafeArea(
        bottom: false,
        child: filteredProperties.isEmpty
            ? _buildEmptyState(theme)
            : CustomScrollView(
                slivers: [
                  SliverToBoxAdapter(child: _buildLandlordSummary(theme, landlordProperties)),
                  SliverToBoxAdapter(child: _buildStatusTabs(theme, activeProperties, pendingProperties)),
                  SliverToBoxAdapter(child: _buildSortControls(theme)),
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) => _buildPropertyCard(context, theme, filteredProperties[index]),
                      childCount: filteredProperties.length,
                    ),
                  ),
                  const SliverToBoxAdapter(child: SizedBox(height: 80)),
                ],
              ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: widget.onCreateProperty,
        backgroundColor: theme.colorScheme.primary,
        child: const Icon(Icons.add, size: 28),
      ),
    );
  }

  void _showFilterOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Filter Properties', style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 16),
              ...PropertyStatus.values.map((status) => ListTile(
                leading: Icon(status.icon, color: status.color),
                title: Text(status.displayName),
                trailing: _filterStatus == status ? Icon(Icons.check, color: Theme.of(context).colorScheme.primary) : null,
                onTap: () {
                  setState(() => _filterStatus = status);
                  Navigator.pop(context);
                },
              )),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Apply Filters'),
                ),
              ),
              const SizedBox(height: 8),
            ],
          ),
        );
      },
    );
  }

  Widget _buildLandlordSummary(ThemeData theme, List<Property> properties) {
    final totalValue = properties.fold<double>(0, (sum, p) => sum + p.rentAmount);
    final activeProperties = properties.where((p) => p.status == PropertyStatus.active).length;
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            theme.colorScheme.primary.withOpacity(0.05),
            theme.colorScheme.primary.withOpacity(0.15),
          ],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 30,
                backgroundColor: theme.colorScheme.primary.withOpacity(0.1),
                child: Icon(Icons.person, size: 34, color: theme.colorScheme.primary),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Welcome back, Landlord!', 
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: theme.colorScheme.onSurface
                        )),
                    const SizedBox(height: 4),
                    Text('${properties.length} properties • $activeProperties active', 
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onSurface.withOpacity(0.7)
                        )),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildSummaryItem(
                theme,
                icon: Icons.monetization_on,
                label: 'Total Value',
                value: '\$${totalValue.toStringAsFixed(0)}/mo',
              ),
              _buildSummaryItem(
                theme,
                icon: Icons.star,
                label: 'Avg. Rating',
                value: '4.8/5',
              ),
              _buildSummaryItem(
                theme,
                icon: Icons.calendar_today,
                label: 'Occupancy',
                value: '92%',
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatusTabs(ThemeData theme, int activeCount, int pendingCount) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          Expanded(
            child: ChoiceChip(
              label: Text('Active ($activeCount)'),
              selected: _filterStatus == PropertyStatus.active,
              selectedColor: theme.colorScheme.primary.withOpacity(0.15),
              labelStyle: TextStyle(
                color: _filterStatus == PropertyStatus.active 
                    ? theme.colorScheme.primary 
                    : theme.colorScheme.onSurface,
                fontWeight: FontWeight.bold
              ),
              onSelected: (_) => setState(() => _filterStatus = PropertyStatus.active),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: ChoiceChip(
              label: Text('Pending ($pendingCount)'),
              selected: _filterStatus == PropertyStatus.pending,
              selectedColor: theme.colorScheme.primary.withOpacity(0.15),
              labelStyle: TextStyle(
                color: _filterStatus == PropertyStatus.pending 
                    ? theme.colorScheme.primary 
                    : theme.colorScheme.onSurface,
                fontWeight: FontWeight.bold
              ),
              onSelected: (_) => setState(() => _filterStatus = PropertyStatus.pending),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryItem(ThemeData theme, {required IconData icon, required String label, required String value}) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: theme.colorScheme.primary.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: theme.colorScheme.primary, size: 20),
        ),
        const SizedBox(height: 8),
        Text(value, style: theme.textTheme.bodyLarge?.copyWith(
          fontWeight: FontWeight.bold,
          color: theme.colorScheme.onSurface
        )),
        Text(label, style: theme.textTheme.bodySmall?.copyWith(
          color: theme.colorScheme.onSurface.withOpacity(0.6)
        )),
      ],
    );
  }

  Widget _buildSortControls(ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          Text('Sort by:', style: theme.textTheme.bodyMedium),
          const SizedBox(width: 8),
          DropdownButton<PropertySortOption>(
            value: _sortOption,
            underline: Container(),
            items: PropertySortOption.values.map((option) {
              return DropdownMenuItem<PropertySortOption>(
                value: option,
                child: Text(option.label, style: theme.textTheme.bodyMedium),
              );
            }).toList(),
            onChanged: (value) {
              if (value != null) {
                setState(() => _sortOption = value);
              }
            },
          ),
          const Spacer(),
          IconButton(
            icon: Icon(Icons.swap_vert, color: theme.colorScheme.primary),
            onPressed: () {
              setState(() {
                if (_sortOption == PropertySortOption.rentLowToHigh) {
                  _sortOption = PropertySortOption.rentHighToLow;
                } else {
                  _sortOption = PropertySortOption.rentLowToHigh;
                }
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _buildPropertyCard(BuildContext context, ThemeData theme, Property property) {
    return Card(
      elevation: 1,
      margin: const EdgeInsets.fromLTRB(16, 8, 16, 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PropertyDetailScreen(
                property: property,
                onEdit: () async {
                  Navigator.pop(context);
                  final updated = await Navigator.push<Property>(
                    context,
                    MaterialPageRoute(
                      builder: (context) => EditPropertyScreen(
                        property: property,
                        onSave: (p) => Navigator.pop(context, p),
                      ),
                    ),
                  );
                  if (updated != null) {
                    final index = _properties.indexOf(property);
                    if (index >= 0) _editProperty(index, updated);
                  }
                },
                onDelete: () => _deleteProperty(_properties.indexOf(property)),
              ),
            ),
          );
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
              child: Stack(
                children: [
                  property.photos != null
                      ? Image.asset(
                          property.photos!.first,
                          height: 180,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        )
                      : Container(
                          height: 180,
                          width: double.infinity,
                          color: theme.colorScheme.surfaceContainerHighest,
                          child: Icon(Icons.home, size: 50, color: theme.colorScheme.onSurfaceVariant),
                        ),
                  Positioned(
                    top: 12,
                    right: 12,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.primary.withOpacity(0.9),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        '\$${property.rentAmount.toStringAsFixed(0)}/mo',
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 12,
                    left: 12,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: property.status.color.withOpacity(0.9),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        property.status.displayName,
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          property.title,
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold
                          ),
                        ),
                      ),
                      Icon(Icons.arrow_forward_ios, 
                          size: 16, 
                          color: theme.colorScheme.onSurface.withOpacity(0.5)),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(Icons.location_on, size: 16, color: theme.colorScheme.primary),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          property.address,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.onSurface.withOpacity(0.7)
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 12,
                    runSpacing: 8,
                    children: [
                      _buildFeatureChip(theme, '${property.bedrooms} bd', Icons.king_bed),
                      _buildFeatureChip(theme, '${property.bathrooms} ba', Icons.bathtub),
                      _buildFeatureChip(theme, '${property.squareFootage?.toStringAsFixed(0)} sqft', Icons.square_foot),
                      if (property.amenities.contains('Parking'))
                        _buildFeatureChip(theme, 'Parking', Icons.local_parking),
                      if (property.amenities.contains('Pet Friendly'))
                        _buildFeatureChip(theme, 'Pets', Icons.pets),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    property.description.length > 100 
                        ? '${property.description.substring(0, 100)}...' 
                        : property.description,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurface.withOpacity(0.8)
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Last updated: ${_formatDate(property.createdAt)}',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurface.withOpacity(0.5)
                        ),
                      ),
                      Row(
                        children: [
                          Icon(Icons.star, size: 16, color: Colors.amber),
                          const SizedBox(width: 4),
                          Text('4.8', style: theme.textTheme.bodySmall),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureChip(ThemeData theme, String text, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest.withOpacity(0.4),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: theme.colorScheme.primary),
          const SizedBox(width: 4),
          Text(text, style: theme.textTheme.bodySmall),
        ],
      ),
    );
  }

  Widget _buildEmptyState(ThemeData theme) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.home_work, size: 80, color: theme.colorScheme.onSurface.withOpacity(0.3)),
            const SizedBox(height: 20),
            Text('No Properties Found', style: theme.textTheme.titleLarge),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: Text(
                _searchQuery.isEmpty
                    ? 'You haven\'t added any properties yet. Start by adding your first property!'
                    : 'No properties match your search. Try different keywords.',
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurface.withOpacity(0.6)
                ),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: widget.onCreateProperty,
              icon: const Icon(Icons.add),
              label: const Text('Add First Property'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);
    
    if (difference.inDays > 7) {
      return '${date.day}/${date.month}/${date.year}';
    } else if (difference.inDays > 0) {
      return '${difference.inDays} days ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} hours ago';
    }
    return 'Just now';
  }
}

enum PropertySortOption {
  newestFirst,
  oldestFirst,
  rentHighToLow,
  rentLowToHigh,
}

extension PropertySortOptionExtension on PropertySortOption {
  String get label {
    switch (this) {
      case PropertySortOption.newestFirst:
        return 'Newest First';
      case PropertySortOption.oldestFirst:
        return 'Oldest First';
      case PropertySortOption.rentHighToLow:
        return 'Rent: High to Low';
      case PropertySortOption.rentLowToHigh:
        return 'Rent: Low to High';
    }
  }
}