import 'package:flutter/material.dart';
import 'models/property.dart';
import 'property_detail_screen.dart';
import 'edit_property_screen.dart';

class PropertyListScreen extends StatefulWidget {
  const PropertyListScreen({super.key});

  @override
  State<PropertyListScreen> createState() => _PropertyListScreenState();
}

class _PropertyListScreenState extends State<PropertyListScreen> {
  final List<Property> _properties = List<Property>.from(Property.sampleData);

  void _addProperty(Property property) {
    setState(() {
      _properties.add(property);
    });
  }

  void _editProperty(int index, Property updated) {
    setState(() {
      _properties[index] = updated;
    });
  }

  void _deleteProperty(int index) {
    setState(() {
      _properties.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
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
            icon: const Icon(Icons.add_box_rounded, color: Colors.blue, size: 28),
            tooltip: 'Add Property',
            onPressed: () async {
              // Example: open property creation (replace with your flow)
              // final newProperty = await ...
            },
          ),
        ],
      ),
      body: _properties.isEmpty
          ? const Center(child: Text('No properties uploaded yet.'))
          : ListView(
              padding: const EdgeInsets.all(16),
              children: [
                // Landlord summary card
                Card(
                  color: theme.colorScheme.primary.withOpacity(0.08),
                  elevation: 0,
                  margin: const EdgeInsets.only(bottom: 18),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 28,
                          backgroundColor: Colors.blue[100],
                          child: const Icon(Icons.person, size: 32, color: Colors.blue),
                        ),
                        const SizedBox(width: 18),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Welcome back, Landlord!', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                              const SizedBox(height: 4),
                              Text('You have ${_properties.length} active properties', style: theme.textTheme.bodyMedium),
                            ],
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.analytics, color: Colors.blue),
                          tooltip: 'View Analytics',
                          onPressed: () {
                            // TODO: Navigate to analytics page
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                // Properties feed
                ..._properties.map((property) => Card(
                  elevation: 2,
                  margin: const EdgeInsets.only(bottom: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(16),
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
                              if (updated != null) _editProperty(_properties.indexOf(property), updated);
                            },
                            onDelete: () {
                              Navigator.pop(context);
                              _deleteProperty(_properties.indexOf(property));
                            },
                          ),
                        ),
                      );
                    },
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ClipRRect(
                          borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                          child: property.photos.isNotEmpty
                              ? Image.asset(
                                  property.photos.first,
                                  height: 180,
                                  width: double.infinity,
                                  fit: BoxFit.cover,
                                )
                              : Container(
                                  height: 180,
                                  width: double.infinity,
                                  color: Colors.grey[300],
                                  child: const Icon(Icons.home, size: 40, color: Colors.grey),
                                ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(14),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Text(
                                      property.title,
                                      style: const TextStyle(
                                        fontSize: 17,
                                        fontWeight: FontWeight.w600,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: Colors.blue.withOpacity(0.08),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Text(
                                      '\u0024${property.rentAmount.toStringAsFixed(0)}/mo',
                                      style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.blue,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  const Icon(Icons.location_on, size: 15, color: Colors.grey),
                                  const SizedBox(width: 4),
                                  Expanded(
                                    child: Text(
                                      property.address,
                                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
                              Row(
                                children: [
                                  const Icon(Icons.king_bed, size: 15, color: Colors.amber),
                                  const SizedBox(width: 2),
                                  Text('${property.bedrooms} bd', style: const TextStyle(fontSize: 12)),
                                  const SizedBox(width: 10),
                                  const Icon(Icons.bathtub, size: 15, color: Colors.blue),
                                  const SizedBox(width: 2),
                                  Text('${property.bathrooms} ba', style: const TextStyle(fontSize: 12)),
                                  const SizedBox(width: 10),
                                  const Icon(Icons.square_foot, size: 15, color: Colors.green),
                                  const SizedBox(width: 2),
                                  Text('${property.squareFootage.toStringAsFixed(0)} sqft', style: const TextStyle(fontSize: 12)),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                )).toList(),
              ],
            ),
    );
  }
}
