// TODO Implement this library
import 'package:flutter/material.dart';
import 'package:rental_connect/tenant_screens/models/room.dart';

class CompareScreen extends StatelessWidget {
  final List<Room> rooms;
  const CompareScreen({super.key, required this.rooms});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Compare Rooms'),
      ),
      body: ListView.builder(
        itemCount: rooms.length,
        itemBuilder: (context, index) {
          final room = rooms[index];
          return ListTile(
            title: Text(room.name),
            subtitle: Text('${room.price} - ${room.location}'),
          );
        },
      ),
    );
  }
}