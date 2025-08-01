import 'package:flutter/material.dart';
import 'models/property.dart';
import 'property_upload_form.dart';
import 'property_detail_screen.dart';
import 'edit_property_screen.dart';
import 'landlord_bottom_navbar.dart';

class PropertyListScreen extends StatefulWidget {
  const PropertyListScreen({super.key});

  @override
  State<PropertyListScreen> createState() => _PropertyListScreenState();
}

class _PropertyListScreenState extends State<PropertyListScreen> {
  final List<Property> _properties = [];

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

  int _currentTab = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My Properties')),
      body: _properties.isEmpty
          ? const Center(child: Text('No properties uploaded yet.'))
          : ListView.builder(
              itemCount: _properties.length,
              itemBuilder: (context, index) {
                final property = _properties[index];
                return ListTile(
                  title: Text(property.title),
                  subtitle: Text(property.address),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () async {
                          final updated = await Navigator.push<Property>(
                            context,
                            MaterialPageRoute(
                              builder: (context) => EditPropertyScreen(
                                property: property,
                                onSave: (p) => Navigator.pop(context, p),
                              ),
                            ),
                          );
                          if (updated != null) _editProperty(index, updated);
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () => _deleteProperty(index),
                      ),
                    ],
                  ),
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
                            if (updated != null) _editProperty(index, updated);
                          },
                          onDelete: () {
                            Navigator.pop(context);
                            _deleteProperty(index);
                          },
                        ),
                      ),
                    );
                  },
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final property = await Navigator.push<Property>(
            context,
            MaterialPageRoute(
              builder: (context) => PropertyUploadForm(
                onSubmit: (property) => Navigator.pop(context, property),
              ),
            ),
          );
          if (property != null) _addProperty(property);
        },
        child: const Icon(Icons.add),
        shape: const CircleBorder(),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: LandlordBottomNavBar(
        currentIndex: _currentTab,
        onTap: (i) {
          setState(() => _currentTab = i);
          // TODO: Switch to profile tab if needed
        },
        onCreate: () async {
          final property = await Navigator.push<Property>(
            context,
            MaterialPageRoute(
              builder: (context) => PropertyUploadForm(
                onSubmit: (property) => Navigator.pop(context, property),
              ),
            ),
          );
          if (property != null) _addProperty(property);
        },
      ),
    );
  }
}
