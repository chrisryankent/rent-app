import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'compare_screen.dart';
import '../models/property.dart';
import '../widgets/property_card.dart';
import 'search_screen.dart';
import 'deals_screen.dart';
import 'top_picks_screen.dart';

class HomeScreen extends StatefulWidget {
  final ScrollController? scrollController;
  final List<Property> favorites;
  final void Function(Property) onToggleFavorite;
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
  List<Property> _allProperties = [];
  List<Property> _filteredProperties = [];
  Set<String> _favoriteIds = {};
  List<String> _recentSearches = [];
  bool _showMapView = false;
  double _priceRange = 5000;
  String _selectedCategory = 'All';
  bool _showRecent = false;
  bool _isRefreshing = false;
  bool _isLoading = true;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _loadFavorites();
    _loadRecentSearches();
    _fetchProperties();
  }

  Future<void> _loadFavorites() async {
    // TODO: Replace with persistent storage if needed
    setState(() {
      _favoriteIds = widget.favorites.map((p) => p.id).toSet();
    });
  }

  Future<void> _loadRecentSearches() async {
    // TODO: Replace with persistent storage if needed
    setState(() {
      _recentSearches = [];
    });
  }

  Future<void> _fetchProperties() async {
    setState(() {
      _isLoading = true;
    });
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('properties')
          .get();
      _allProperties = snapshot.docs
          .map((doc) => Property.fromFirestore(doc))
          .toList();
    } catch (e) {
      _allProperties = [];
    }
    _applyFilters();
    setState(() {
      _isLoading = false;
    });
  }

  void _applyFilters() {
    List<Property> props = List.from(_allProperties);
    // Search filter
    if (_searchQuery.isNotEmpty) {
      props = props
          .where(
            (p) =>
                p.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
                p.address.toLowerCase().contains(_searchQuery.toLowerCase()),
          )
          .toList();
    }
    // Category filter
    if (_selectedCategory != 'All') {
      props = props
          .where(
            (p) => p.propertyTypes.any(
              (t) => t.name.toLowerCase().contains(
                _selectedCategory.toLowerCase(),
              ),
            ),
          )
          .toList();
    }
    // Price filter
    props = props.where((p) => p.rentAmount <= _priceRange).toList();
    // Sort newest to oldest
    props.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    setState(() {
      _filteredProperties = props;
    });
  }

  void _toggleFavorite(Property property) {
    setState(() {
      if (_favoriteIds.contains(property.id)) {
        _favoriteIds.remove(property.id);
      } else {
        _favoriteIds.add(property.id);
      }
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
    // TODO: Persist recent searches if needed
  }

  void _onSearchTap() {
    setState(() {
      _showRecent = true;
    });
  }

  void _onSearchSubmit(String value) {
    _addRecentSearch(value);
    setState(() {
      _searchQuery = value;
      _showRecent = false;
    });
    _applyFilters();
  }

  void _onCategorySelected(String category) {
    setState(() {
      _selectedCategory = category;
    });
    _applyFilters();
  }

  void _onPriceChanged(double value) {
    setState(() {
      _priceRange = value;
    });
    _applyFilters();
  }

  void _refreshProperties() async {
    setState(() {
      _isRefreshing = true;
    });
    await _fetchProperties();
    setState(() {
      _isRefreshing = false;
    });
  }

  List<Property> get _dealsOfTheDay => _filteredProperties
      .where(
        (p) =>
            p.createdAt.year == DateTime.now().year &&
            p.createdAt.month == DateTime.now().month &&
            p.createdAt.day == DateTime.now().day,
      )
      .toList();

  List<Property> get _otherProperties => _filteredProperties
      .where(
        (p) =>
            !(p.createdAt.year == DateTime.now().year &&
                p.createdAt.month == DateTime.now().month &&
                p.createdAt.day == DateTime.now().day),
      )
      .toList();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final ScrollController? controller = widget.scrollController;
    if (_isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text(
          'RoomFinder',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
        ),
        backgroundColor: theme.appBarTheme.backgroundColor,
        foregroundColor: theme.appBarTheme.foregroundColor,
        elevation: theme.appBarTheme.elevation,
        iconTheme: theme.appBarTheme.iconTheme,
        titleTextStyle: theme.appBarTheme.titleTextStyle,
        actions: [
          IconButton(
            icon: const Icon(Icons.tune, size: 24),
            onPressed: () => _showPriceFilter(context),
          ),
          IconButton(
            icon: const Icon(Icons.compare_arrows, size: 24),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    CompareScreen(properties: _filteredProperties),
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.map, size: 24),
            onPressed: () {
              setState(() {
                _showMapView = !_showMapView;
              });
            },
            tooltip: _showMapView ? 'List View' : 'Map View',
          ),
        ],
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: Opacity(
              opacity: 0.03,
              child: Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: const AssetImage('lib/assets/rent.webp'),
                    repeat: ImageRepeat.repeat,
                  ),
                ),
              ),
            ),
          ),
          CustomScrollView(
            controller: controller,
            physics: const BouncingScrollPhysics(),
            slivers: [
              SliverAppBar(
                automaticallyImplyLeading: false,
                pinned: true,
                collapsedHeight: 120,
                expandedHeight: 120,
                flexibleSpace: FlexibleSpaceBar(
                  background: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          theme.appBarTheme.backgroundColor!,
                          theme.scaffoldBackgroundColor,
                        ],
                      ),
                    ),
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.05),
                                blurRadius: 12,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: TextField(
                            controller: _searchController,
                            decoration: InputDecoration(
                              hintText: 'Search for rooms, locations...',
                              prefixIcon: const Icon(Icons.search_rounded),
                              filled: true,
                              fillColor: theme.inputDecorationTheme.fillColor,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16),
                                borderSide: BorderSide.none,
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                vertical: 0,
                              ),
                            ),
                            onTap: _onSearchTap,
                            onSubmitted: _onSearchSubmit,
                          ),
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
                                            onTap: () =>
                                                _onSearchSubmit(search),
                                            child: Text(search),
                                          ),
                                          deleteIcon: const Icon(
                                            Icons.close,
                                            size: 18,
                                          ),
                                          onDeleted: () {
                                            setState(
                                              () => _recentSearches.remove(
                                                search,
                                              ),
                                            );
                                          },
                                          backgroundColor:
                                              theme.chipTheme.backgroundColor,
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
              ),
              SliverPadding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
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
                              fontWeight: FontWeight.w700,
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
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const DealsScreen(),
                            ),
                          );
                        },
                        child: const Text(
                          'View All',
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: SizedBox(
                  height: 260,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: _dealsOfTheDay.length >= 2
                        ? 2
                        : _dealsOfTheDay.length,
                    itemBuilder: (context, index) {
                      if (index >= _dealsOfTheDay.length) {
                        return const SizedBox();
                      }
                      final property = _dealsOfTheDay[index];
                      return Container(
                        width: 280,
                        margin: EdgeInsets.only(
                          left: index == 0 ? 16 : 8,
                          right: index == 1 ? 16 : 8,
                        ),
                        child: Stack(
                          children: [
                            PropertyCard(
                              property: property,
                              isFeatured: true,
                              isFavorite: _favoriteIds.contains(property.id),
                              onFavorite: () => _toggleFavorite(property),
                              onTap: () {
                                // TODO: Navigate to property detail screen
                              },
                              isNew: true,
                              isRecommended: true,
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ),
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
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const TopPicksScreen(),
                            ),
                          );
                        },
                        child: const Text(
                          'See More',
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: SizedBox(
                  height: 220,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: _otherProperties.length >= 4
                        ? 3
                        : (_otherProperties.length - 1).clamp(0, 3),
                    itemBuilder: (context, index) {
                      final safeIndex = (index + 1) < _otherProperties.length
                          ? (index + 1)
                          : index;
                      if (safeIndex >= _otherProperties.length) {
                        return const SizedBox();
                      }
                      final property = _otherProperties[safeIndex];
                      return Container(
                        width: 280,
                        margin: EdgeInsets.only(
                          left: index == 0 ? 16 : 8,
                          right: index == 2 ? 16 : 8,
                        ),
                        child: PropertyCard(
                          property: property,
                          isRecommended: true,
                          isFavorite: _favoriteIds.contains(property.id),
                          onFavorite: () => _toggleFavorite(property),
                          onTap: () {
                            // TODO: Navigate to property detail screen
                          },
                          isNew: true,
                        ),
                      );
                    },
                  ),
                ),
              ),
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
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Row(
                        children: [
                          const Icon(Icons.filter_list, size: 18),
                          const SizedBox(width: 4),
                          Text(
                            'Max: \$${_priceRange.toInt()}',
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                sliver: _showMapView
                    ? SliverToBoxAdapter(child: _buildMapPlaceholder(context))
                    : SliverList(
                        delegate: SliverChildBuilderDelegate((context, index) {
                          if (index >= _otherProperties.length) {
                            return const SizedBox();
                          }
                          final property = _otherProperties[index];
                          return Padding(
                            padding: const EdgeInsets.symmetric(
                              vertical: 8,
                              horizontal: 8,
                            ),
                            child: PropertyCard(
                              property: property,
                              isNew: index % 3 == 0,
                              isFavorite: _favoriteIds.contains(property.id),
                              onFavorite: () => _toggleFavorite(property),
                              onTap: () {
                                // TODO: Navigate to property detail screen
                              },
                              isRecommended: false,
                            ),
                          );
                        }, childCount: _otherProperties.length),
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
          onPressed: _refreshProperties,
          backgroundColor: theme.floatingActionButtonTheme.backgroundColor,
          child: _isRefreshing
              ? const CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2,
                )
              : const Icon(Icons.refresh, color: Colors.white, size: 22),
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
          elevation: 2,
          shadowColor: Colors.black.withOpacity(0.1),
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
                    color: isSelected ? Colors.blue : Colors.grey[600],
                  ),
                  const SizedBox(width: 8),
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: isSelected ? Colors.blue : Colors.grey[700],
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

  Widget _buildMapPlaceholder(BuildContext context) {
    return Container(
      height: 400,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Colors.blue[50]!, Colors.blue[100]!],
        ),
      ),
      child: Stack(
        children: [
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.map_rounded, size: 64, color: Colors.blue[700]),
                const SizedBox(height: 16),
                Text(
                  'Map View Showing ${_otherProperties.length} Properties',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.blue[700],
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 20,
            left: 0,
            right: 0,
            child: Center(
              child: ElevatedButton.icon(
                onPressed: () {
                  setState(() {
                    _showMapView = !_showMapView;
                  });
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue[700],
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                ),
                icon: const Icon(Icons.list),
                label: const Text('Switch to List View'),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showPriceFilter(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
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
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Slider(
                    value: _priceRange,
                    min: 500,
                    max: 5000,
                    divisions: 9,
                    activeColor: Colors.blue[700],
                    inactiveColor: Colors.grey[300],
                    thumbColor: Colors.blue[700],
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
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text(
                            'Cancel',
                            style: TextStyle(fontWeight: FontWeight.w600),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            setState(() {});
                            Navigator.pop(context);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue[700],
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text(
                            'Apply',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
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
