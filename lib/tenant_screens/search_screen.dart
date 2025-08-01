import 'package:flutter/material.dart';
import 'models/room.dart';
import 'widgets/room_card.dart';

class SearchScreen extends StatefulWidget {
  final String initialQuery;
  const SearchScreen({super.key, this.initialQuery = ''});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  late TextEditingController _searchController;
  List<Room> _results = [];
  final List<Room> _allRooms = Room.sampleData;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController(text: widget.initialQuery);
    _searchRooms(widget.initialQuery);
  }

  void _searchRooms(String query) {
    setState(() {
      if (query.trim().isEmpty) {
        _results = [];
      } else {
        _results = _allRooms
            .where(
              (room) =>
                  room.title.toLowerCase().contains(query.toLowerCase()) ||
                  room.location.toLowerCase().contains(query.toLowerCase()),
            )
            .toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _searchController,
          decoration: InputDecoration(
            hintText: 'Search rooms...',
            border: InputBorder.none,
            prefixIcon: const Icon(Icons.search),
          ),
          onChanged: _searchRooms,
        ),
        backgroundColor: theme.appBarTheme.backgroundColor,
        foregroundColor: theme.appBarTheme.foregroundColor,
        elevation: theme.appBarTheme.elevation,
        iconTheme: theme.appBarTheme.iconTheme,
        titleTextStyle: theme.appBarTheme.titleTextStyle,
      ),
      body: _results.isEmpty
          ? Center(
              child: Text('No results found', style: theme.textTheme.bodyLarge),
            )
          : Padding(
              padding: const EdgeInsets.all(16),
              child: ListView.separated(
                itemCount: _results.length,
                separatorBuilder: (context, index) =>
                    const SizedBox(height: 16),
                itemBuilder: (context, index) {
                  final room = _results[index];
                  return RoomCard(
                    room: room,
                    isNew: index % 3 == 0,
                    isFavorite: false,
                    onFavorite: () {},
                    onTap: () {},
                    isRecommended: true,
                  );
                },
              ),
            ),
    );
  }
}
