// home_screen.dart
import 'package:flutter/material.dart';
import 'room_detail_screen.dart';
import 'compare_screen.dart';
import 'models/room.dart';
import 'widgets/room_card.dart';
import 'search_screen.dart';
import 'deals_screen.dart';
import 'top_picks_screen.dart';

class HomeScreen extends StatefulWidget {
  final ScrollController? scrollController;
  final List<Room> favorites;
  final void Function(Room) onToggleFavorite;
  const HomeScreen({
    super.key,
    this.scrollController,
    required this.favorites,
    required this.onToggleFavorite,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();
  final List<Room> _rooms = Room.sampleData;
  final List<String> _recentSearches = [
    'Downtown',
    'Near University',
    'Pet Friendly',
    'Studio',
  ];
  bool _showMapView = false;
  double _priceRange = 2000;
  String _selectedCategory = 'All';
  bool _showRecent = false;

  void _toggleFavorite(Room room) {
    widget.onToggleFavorite(room);
  }

  void _toggleView() {
    setState(() {
      _showMapView = !_showMapView;
    });
  }

  void _addRecentSearch(String search) {
    setState(() {
      if (search.trim().isEmpty) return;
      _recentSearches.remove(search);
      _recentSearches.insert(0, search);
      if (_recentSearches.length > 10) {
        _recentSearches.removeLast();
      }
    });
  }

  void _onSearchTap() {
    setState(() {
      _showRecent = true;
    });
  }

  void _onSearchSubmit(String value) {
    _addRecentSearch(value);
    setState(() {
      _showRecent = false;
    });
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SearchScreen(initialQuery: value),
      ),
    );
  }

  Future<void> _onVoiceSearch() async {
    // Simulate voice input for now
    final voiceResult = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Voice Search'),
        content: const Text('Pretend you spoke: "Downtown"'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, 'Downtown'),
            child: const Text('OK'),
          ),
        ],
      ),
    );
    if (voiceResult != null && voiceResult.isNotEmpty) {
      _searchController.text = voiceResult;
      _onSearchSubmit(voiceResult);
    }
  }

  void _goToDeals() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const DealsScreen()),
    );
  }

  void _goToTopPicks() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const TopPicksScreen()),
    );
  }

  void _refreshRooms() async {
    setState(() {
      // Optionally show a loading indicator here
    });
    // Simulate a network fetch delay
    await Future.delayed(const Duration(seconds: 1));
    setState(() {
      // In production, fetch from backend or Firebase here
      _rooms.clear();
      _rooms.addAll(Room.sampleData); // Replace with fetched data
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final ScrollController? controller = widget.scrollController;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text(
          'RoomFinder',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: theme.appBarTheme.backgroundColor,
        foregroundColor: theme.appBarTheme.foregroundColor,
        elevation: theme.appBarTheme.elevation,
        iconTheme: theme.appBarTheme.iconTheme,
        titleTextStyle: theme.appBarTheme.titleTextStyle,
        actions: [
          IconButton(
            icon: const Icon(Icons.tune),
            onPressed: () => _showPriceFilter(context),
          ),
          IconButton(
            icon: const Icon(Icons.compare_arrows),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => CompareScreen(rooms: _rooms),
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.map),
            onPressed: _toggleView,
            tooltip: _showMapView ? 'List View' : 'Map View',
          ),
        ],
      ),
      body: Stack(
        children: [
          CustomScrollView(
            controller: controller,
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
                          fillColor: theme.inputDecorationTheme.fillColor,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 0,
                          ),
                          suffixIcon: IconButton(
                            icon: const Icon(Icons.mic),
                            onPressed: _onVoiceSearch,
                          ),
                        ),
                        onTap: _onSearchTap,
                        onSubmitted: _onSearchSubmit,
                      ),
                      if (_showRecent && _recentSearches.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: SizedBox(
                            height: 36,
                            child: ListView(
                              scrollDirection: Axis.horizontal,
                              children: _recentSearches
                                  .map(
                                    (search) => Padding(
                                      padding: const EdgeInsets.only(
                                        right: 8.0,
                                      ),
                                      child: Chip(
                                        label: GestureDetector(
                                          onTap: () => _onSearchSubmit(search),
                                          child: Text(search),
                                        ),
                                        deleteIcon: const Icon(
                                          Icons.close,
                                          size: 18,
                                        ),
                                        onDeleted: () {
                                          setState(
                                            () =>
                                                _recentSearches.remove(search),
                                          );
                                        },
                                      ),
                                    ),
                                  )
                                  .toList(),
                            ),
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
                        _buildCategory(
                          'All',
                          Icons.all_inclusive,
                          isSelected: _selectedCategory == 'All',
                        ),
                        _buildCategory(
                          'Apartments',
                          Icons.apartment,
                          isSelected: _selectedCategory == 'Apartments',
                        ),
                        _buildCategory(
                          'Shared',
                          Icons.people,
                          isSelected: _selectedCategory == 'Shared',
                        ),
                        _buildCategory(
                          'Studio',
                          Icons.home_work,
                          isSelected: _selectedCategory == 'Studio',
                        ),
                        _buildCategory(
                          'Luxury',
                          Icons.star,
                          isSelected: _selectedCategory == 'Luxury',
                        ),
                        _buildCategory(
                          'Near Me',
                          Icons.location_on,
                          isSelected: _selectedCategory == 'Near Me',
                        ),
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
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.red[50],
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Text(
                              '24h left',
                              style: TextStyle(
                                color: Colors.red,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      TextButton(
                        onPressed: _goToDeals,
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
                    itemCount: _rooms.length >= 2 ? 2 : _rooms.length,
                    itemBuilder: (context, index) {
                      if (index >= _rooms.length) return const SizedBox();
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
                              isFavorite: widget.favorites.contains(room),
                              onFavorite: () => _toggleFavorite(room),
                              onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => RoomDetailScreen(
                                    room: room,
                                    onFavorite: () => _toggleFavorite(room),
                                    isFavorite: widget.favorites.contains(room),
                                  ),
                                ),
                              ),
                              isNew: true,
                              isRecommended: true,
                            ),
                            Positioned(
                              top: 10,
                              left: 10,
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
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
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      TextButton(
                        onPressed: _goToTopPicks,
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
                    itemCount: _rooms.length >= 4 ? 3 : (_rooms.length - 1).clamp(0, 3),
                    itemBuilder: (context, index) {
                      final safeIndex = (index + 1) < _rooms.length ? (index + 1) : index;
                      if (safeIndex >= _rooms.length) return const SizedBox();
                      final room = _rooms[safeIndex];
                      return Container(
                        width: 280,
                        margin: EdgeInsets.only(
                          left: index == 0 ? 16 : 8,
                          right: index == 2 ? 16 : 8,
                        ),
                        child: RoomCard(
                          room: room,
                          isRecommended: true,
                          isFavorite: widget.favorites.contains(room),
                          onFavorite: () => _toggleFavorite(room),
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => RoomDetailScreen(
                                room: room,
                                onFavorite: () => _toggleFavorite(room),
                                isFavorite: widget.favorites.contains(room),
                              ),
                            ),
                          ),
                          isNew: true,
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
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
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
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
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
                              const Icon(
                                Icons.map,
                                size: 64,
                                color: Colors.blue,
                              ),
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
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 24,
                                    vertical: 12,
                                  ),
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
                    : SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (context, index) {
                            if (index >= _rooms.length) return const SizedBox();
                            final room = _rooms[index];
                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                              child: RoomCard(
                                room: room,
                                isNew: index % 3 == 0,
                                isFavorite: widget.favorites.contains(room),
                                onFavorite: () => _toggleFavorite(room),
                                onTap: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => RoomDetailScreen(
                                      room: room,
                                      onFavorite: () => _toggleFavorite(room),
                                      isFavorite: widget.favorites.contains(room),
                                    ),
                                  ),
                                ),
                                isRecommended: false,
                              ),
                            );
                          },
                          childCount: _rooms.length,
                        ),
                      ),
              ),
            ],
          ),
        ],
      ),
      floatingActionButton: SizedBox(
        height: 44,
        width: 44,
        child: FloatingActionButton(
          onPressed: _refreshRooms,
          backgroundColor: theme.floatingActionButtonTheme.backgroundColor,
          child: const Icon(Icons.refresh, color: Colors.white, size: 22),
        ),
      ),
    );
  }

  Widget _buildCategory(
    String title,
    IconData icon, {
    bool isSelected = false,
  }) {
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
                  Icon(
                    icon,
                    size: 18,
                    color: isSelected ? Colors.blue : Colors.grey,
                  ),
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
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
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
}
