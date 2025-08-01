import 'package:flutter/material.dart';
import 'models/property.dart';
import 'property_upload_form.dart';
import 'package:provider/provider.dart';
import 'package:rental_connect/theme_provider.dart';

class EditPropertyScreen extends StatelessWidget {
  final Property property;
  final void Function(Property) onSave;
  const EditPropertyScreen({
    super.key,
    required this.property,
    required this.onSave,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ChangeNotifierProvider.value(
      value: Provider.of<ThemeProvider>(context),
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, _) {
          return Scaffold(
            body: PropertyUploadForm(
              onSubmit: (updated) {
                onSave(updated);
                Navigator.pop(context);
              },
              initialProperty: property,
            ),
          );
        },
      ),
    );
  }
}
