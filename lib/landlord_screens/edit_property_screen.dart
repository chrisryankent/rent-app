import 'package:flutter/material.dart';
import '../models/property.dart';
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
            appBar: AppBar(
              title: const Text(
                'Edit Property',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              centerTitle: true,
              elevation: 0,
              backgroundColor: theme.appBarTheme.backgroundColor,
              foregroundColor: theme.appBarTheme.foregroundColor,
              iconTheme: theme.appBarTheme.iconTheme,
              titleTextStyle: theme.appBarTheme.titleTextStyle,
            ),
            body: Container(
              color: theme.scaffoldBackgroundColor,
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
                child: Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: PropertyUploadForm(
                      onSubmit: (updated) {
                        onSave(updated);
                        Navigator.pop(context);
                      },
                      initialProperty: property,
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}