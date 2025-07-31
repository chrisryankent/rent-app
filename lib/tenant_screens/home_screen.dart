// home_screen.dart
import 'package:flutter/material.dart';
import 'room_detail_screen.dart';
import 'favorites_screen.dart';
import 'messages_screen.dart';
import 'profile_screen.dart';
import 'compare_screen.dart';
import 'models/room.dart';
import 'widgets/room_card.dart';
import 'widgets/filter_chip.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();
  final List<Room> _rooms = Room.sampleData;
  final List<Room> _favorites = [];
  final List<String> _recentSearches = ['Downtown', 'Near University', 'Pet Friendly', 'Studio'];
  bool _showMapView = false;
  double _priceRange = 2000;
  String _selectedCategory = 'All';

  void _toggleFavorite(Room room) {
    setState(() {
      if (_favorites.contains(room)) {
        _favorites.remove(room);
      } else {
        _favorites.add(room);
      }
    });
  }

  void _toggleView() {
    setState(() {
      _showMapView = !_showMapView;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'RoomFinder',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.tune),
            onPressed: () => _showPriceFilter(context),
          ),
          IconButton(
            icon: const Icon(Icons.compare_arrows),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => CompareScreen(rooms: _rooms)),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.map),
            onPressed: _toggleView,
            tooltip: _showMapView ? 'List View' : 'Map View',
          ),
        ],
      ),
      body: CustomScrollView(
        slivers: [
          // Search and quick filters
          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: 'Search for rooms, locations...',
                      prefixIcon: const Icon(Icons.search),
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(vertical: 0),
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.mic),
                        onPressed: () {},
                      ),
                    ),
                    onTap: () => _showRecentSearches(context),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    height: 40,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: [
                        FilterChip(
                          label: const Text('Furnished'),
                          selected: false,
                          onSelected: (val) {},
                        ),
                        const SizedBox(width: 8),
                        FilterChip(
                          label: const Text('Pet Friendly'),
                          selected: false,
                          onSelected: (val) {},
                        ),
                        const SizedBox(width: 8),
                        FilterChip(
                          label: const Text('Parking'),
                          selected: false,
                          onSelected: (val) {},
                        ),
                        const SizedBox(width: 8),
                        FilterChip(
                          label: const Text('Utilities Included'),
                          selected: false,
                          onSelected: (val) {},
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          // Categories
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            sliver: SliverToBoxAdapter(
              child: SizedBox(
                height: 50,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    _buildCategory('All', Icons.all_inclusive, isSelected: _selectedCategory == 'All'),
                    _buildCategory('Apartments', Icons.apartment, isSelected: _selectedCategory == 'Apartments'),
                    _buildCategory('Shared', Icons.people, isSelected: _selectedCategory == 'Shared'),
                    _buildCategory('Studio', Icons.home_work, isSelected: _selectedCategory == 'Studio'),
                    _buildCategory('Luxury', Icons.star, isSelected: _selectedCategory == 'Luxury'),
                    _buildCategory('Near Me', Icons.location_on, isSelected: _selectedCategory == 'Near Me'),
                  ],
                ),
              ),
            ),
          ),
          
          // Deals of the day
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(16, 20, 16, 8),
            sliver: SliverToBoxAdapter(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Text(
                        'Deals of the Day',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.red[50],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Text(
                          '24h left',
                          style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                  TextButton(
                    onPressed: () {},
                    child: const Text('View All'),
                  ),
                ],
              ),
            ),
          ),
          
          // Special deals carousel
          SliverToBoxAdapter(
            child: SizedBox(
              height: 260,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: 2,
                itemBuilder: (context, index) {
                  final room = _rooms[index];
                  return Container(
                    width: 280,
                    margin: EdgeInsets.only(
                      left: index == 0 ? 16 : 8,
                      right: index == 1 ? 16 : 8,
                    ),
                    child: Stack(
                      children: [
                        RoomCard(
                          room: room,
                          isFeatured: true,
                          isFavorite: _favorites.contains(room),
                          onFavorite: () => _toggleFavorite(room),
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => RoomDetailScreen(
                                room: room,
                                onFavorite: () => _toggleFavorite(room),
                                isFavorite: _favorites.contains(room),
                              ),
                            ),
                          ), isNew: true, isRecommended: true,
                        ),
                        Positioned(
                          top: 10,
                          left: 10,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.blue,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: const Text(
                              '10% OFF',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
          
          // Top picks for you
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(16, 20, 16, 8),
            sliver: SliverToBoxAdapter(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Top Picks for You',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                  TextButton(
                    onPressed: () {},
                    child: const Text('See More'),
                  ),
                ],
              ),
            ),
          ),
          
          // Recommended properties
          SliverToBoxAdapter(
            child: SizedBox(
              height: 220,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: 3,
                itemBuilder: (context, index) {
                  final room = _rooms[index + 1];
                  return Container(
                    width: 280,
                    margin: EdgeInsets.only(
                      left: index == 0 ? 16 : 8,
                      right: index == 2 ? 16 : 8,
                    ),
                    child: RoomCard(
                      room: room,
                      isRecommended: true,
                      isFavorite: _favorites.contains(room),
                      onFavorite: () => _toggleFavorite(room),
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => RoomDetailScreen(
                            room: room,
                            onFavorite: () => _toggleFavorite(room),
                            isFavorite: _favorites.contains(room),
                          ),
                        ),
                      ), isNew: true, 
                    ),
                  );
                },
              ),
            ),
          ),
          
          // All listings header
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(16, 20, 16, 8),
            sliver: SliverToBoxAdapter(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'All Listings',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                  Row(
                    children: [
                      const Icon(Icons.filter_list, size: 18),
                      const SizedBox(width: 4),
                      Text(
                        'Max: \$${_priceRange.toInt()}',
                        style: const TextStyle(fontSize: 14),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          
          // All listings grid
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            sliver: _showMapView 
                ? SliverToBoxAdapter(
                    child: Container(
                      height: 400,
                      decoration: BoxDecoration(
                        color: Colors.blue[50],
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.map, size: 64, color: Colors.blue),
                          const SizedBox(height: 16),
                          Text(
                            'Map View Showing ${_rooms.length} Properties',
                            style: const TextStyle(fontSize: 18),
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: _toggleView,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                            ),
                            child: const Text(
                              'Switch to List View',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                : SliverGrid(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      childAspectRatio: 0.75,
                    ),
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final room = _rooms[index];
                        return RoomCard(
                          room: room,
                          isNew: index % 3 == 0,
                          isFavorite: _favorites.contains(room),
                          onFavorite: () => _toggleFavorite(room),
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => RoomDetailScreen(
                                room: room,
                                onFavorite: () => _toggleFavorite(room),
                                isFavorite: _favorites.contains(room),
                              ),
                            ),
                          ), isRecommended: true,
                        );
                      },
                      childCount: _rooms.length,
                    ),
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showSaveSearchDialog(context),
        backgroundColor: Colors.blue,
        child: const Icon(Icons.save, color: Colors.white),
      ),
    );
  }

  Widget _buildCategory(String title, IconData icon, {bool isSelected = false}) {
    return GestureDetector(
      onTap: () => setState(() => _selectedCategory = title),
      child: Container(
        margin: const EdgeInsets.only(right: 8),
        child: Material(
          color: isSelected ? Colors.blue[50] : Colors.white,
          borderRadius: BorderRadius.circular(12),
          elevation: 1,
          child: InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: () => setState(() => _selectedCategory = title),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: Row(
                children: [
                  Icon(icon, size: 18, color: isSelected ? Colors.blue : Colors.grey),
                  const SizedBox(width: 8),
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 14,
                      color: isSelected ? Colors.blue : Colors.black,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _showRecentSearches(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Recent Searches',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              ..._recentSearches.map((search) => ListTile(
                leading: const Icon(Icons.history),
                title: Text(search),
                trailing: IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () {
                    setState(() => _recentSearches.remove(search));
                    Navigator.pop(context);
                  },
                ),
                onTap: () {
                  _searchController.text = search;
                  Navigator.pop(context);
                },
              )).toList(),
              const SizedBox(height: 16),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () => setState(() {
                    _recentSearches.clear();
                    Navigator.pop(context);
                  }),
                  child: const Text('Clear All'),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showPriceFilter(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Container(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Set Price Range',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Max Price: \$${_priceRange.toInt()}',
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 10),
                  Slider(
                    value: _priceRange,
                    min: 500,
                    max: 5000,
                    divisions: 9,
                    label: _priceRange.toInt().toString(),
                    onChanged: (value) {
                      setState(() => _priceRange = value);
                    },
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('Cancel'),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            setState(() {});
                            Navigator.pop(context);
                          },
                          child: const Text('Apply'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _showSaveSearchDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Save This Search'),
          content: const Text('Would you like to save your current search filters?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                // Save search logic
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Search saved successfully!')),
                );
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }
}