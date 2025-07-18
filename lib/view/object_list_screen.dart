import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import '../provider/object_provider.dart';
import '../model/object_model.dart';
import '../global/global.dart';
import '../global/colors.dart';
import '../global/text_styles.dart';
import 'object_details_screen.dart';

class ObjectListScreen extends StatefulWidget {
  const ObjectListScreen({super.key});

  @override
  State<ObjectListScreen> createState() => _ObjectListScreenState();
}

class _ObjectListScreenState extends State<ObjectListScreen> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();
  Timer? _debounceTimer;

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      context.read<ObjectProvider>().searchObjects(_searchController.text);

      _debounceTimer?.cancel();

      if (_searchController.text.isNotEmpty) {
        _debounceTimer = Timer(Duration(milliseconds: 1000), () {
          if (mounted) {
            context.read<ObjectProvider>().addToRecentSearches(
              _searchController.text,
            );
          }
        });
      }
    });
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Object Data',
            style: AppTextStyles.heading3.copyWith(color: AppColors.splashText),
          ),
          backgroundColor: AppColors.primary,
          surfaceTintColor: Colors.transparent,
          elevation: 0,
        ),
        body: Column(
          children: [
            _buildSearchBar(),
            _buildRecentSearches(),
            Expanded(
              child: Consumer<ObjectProvider>(
                builder: (context, objectProvider, child) {
                  if (objectProvider.isLoading) {
                    return _buildShimmerList();
                  }

                  if (objectProvider.error.isNotEmpty) {
                    return _buildErrorWidget(objectProvider.error);
                  }

                  if (objectProvider.filteredObjects.isEmpty) {
                    return _buildEmptyState();
                  }

                  return _buildObjectList(objectProvider.filteredObjects);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    final screenWidth = MediaQuery.of(context).size.width;
    final isTablet = screenWidth > 600;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isTablet ? 24 : 16,
        vertical: isTablet ? 16 : 12,
      ),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
      ),
      child: Container(
        constraints: BoxConstraints(maxWidth: isTablet ? 600 : double.infinity),
        margin: isTablet ? const EdgeInsets.symmetric(horizontal: 100) : null,
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: AppColors.shadow,
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: TextField(
          controller: _searchController,
          focusNode: _searchFocusNode,
          onSubmitted: (value) {
            if (value.isNotEmpty) {
              context.read<ObjectProvider>().addToRecentSearches(value);
            }
          },
          decoration: InputDecoration(
            hintText: isTablet
                ? 'Search objects by name, color, capacity, or price...'
                : 'Search objects...',
            hintStyle: AppTextStyles.searchHint,
            prefixIcon: const Icon(
              Icons.search,
              color: AppColors.textSecondary,
            ),
            suffixIcon: Consumer<ObjectProvider>(
              builder: (context, objectProvider, child) {
                return objectProvider.searchQuery.isNotEmpty
                    ? IconButton(
                        icon: const Icon(
                          Icons.clear,
                          color: AppColors.textSecondary,
                        ),
                        onPressed: () {
                          _searchController.clear();
                          objectProvider.clearSearch();
                        },
                      )
                    : const SizedBox.shrink();
              },
            ),
            border: InputBorder.none,
            contentPadding: EdgeInsets.symmetric(
              horizontal: isTablet ? 20 : 16,
              vertical: isTablet ? 16 : 12,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRecentSearches() {
    final screenWidth = MediaQuery.of(context).size.width;
    final isTablet = screenWidth > 600;

    return Consumer<ObjectProvider>(
      builder: (context, objectProvider, child) {
        if (objectProvider.recentSearches.isEmpty) {
          return const SizedBox.shrink();
        }

        return Container(
          padding: EdgeInsets.symmetric(
            horizontal: isTablet ? 24 : 16,
            vertical: isTablet ? 12 : 8,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Recent Searches',
                    style: AppTextStyles.heading3.copyWith(
                      fontSize: isTablet ? 18 : 16,
                    ),
                  ),
                  TextButton(
                    onPressed: () => objectProvider.clearRecentSearches(),
                    child: Text(
                      'Clear All',
                      style: AppTextStyles.bodyMedium.copyWith(
                        fontSize: isTablet ? 16 : 14,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: isTablet ? 12 : 8),
              Wrap(
                spacing: isTablet ? 12 : 8,
                runSpacing: isTablet ? 8 : 4,
                children: objectProvider.recentSearches.map((search) {
                  return GestureDetector(
                    onTap: () {
                      _searchController.text = search;
                      objectProvider.selectRecentSearch(search);
                    },
                    child: Chip(
                      label: Text(
                        search,
                        style: AppTextStyles.chip.copyWith(
                          fontSize: isTablet ? 15 : 14,
                        ),
                      ),
                      deleteIcon: Icon(Icons.close, size: isTablet ? 18 : 16),
                      onDeleted: () =>
                          objectProvider.removeRecentSearch(search),
                      backgroundColor: AppColors.chipBackground,
                      side: BorderSide(color: AppColors.primaryLight),
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildShimmerList() {
    final screenWidth = MediaQuery.of(context).size.width;
    final isTablet = screenWidth > 600;

    return ListView.builder(
      padding: EdgeInsets.all(isTablet ? 24 : 16),
      itemCount: 10,
      itemBuilder: (context, index) {
        return Shimmer.fromColors(
          baseColor: AppColors.divider,
          highlightColor: AppColors.background,
          child: Container(
            margin: EdgeInsets.only(bottom: isTablet ? 20 : 16),
            padding: EdgeInsets.all(isTablet ? 60 : 40),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: AppColors.shadow,
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildErrorWidget(String error) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isTablet = screenWidth > 600;

    return Center(
      child: Padding(
        padding: EdgeInsets.all(isTablet ? 24 : 16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: isTablet ? 12 : 8),
            Text(
              error,
              textAlign: TextAlign.center,
              style: AppTextStyles.bodyLarge.copyWith(
                fontSize: isTablet ? 18 : 16,
                color: AppColors.textSecondary,
              ),
            ),
            SizedBox(height: isTablet ? 20 : 16),
            ElevatedButton(
              onPressed: () => context.read<ObjectProvider>().refreshData(),
              child: Text(
                'Retry',
                style: AppTextStyles.button.copyWith(
                  fontSize: isTablet ? 16 : 14,
                  color: AppColors.textPrimary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    final screenWidth = MediaQuery.of(context).size.width;
    final isTablet = screenWidth > 600;

    return Center(
      child: Padding(
        padding: EdgeInsets.all(isTablet ? 24 : 16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.search_off,
              size: isTablet ? 80 : 64,
              color: AppColors.textLight,
            ),
            SizedBox(height: isTablet ? 20 : 16),
            Text(
              'No objects found',
              style: AppTextStyles.heading2.copyWith(
                fontSize: isTablet ? 28 : 24,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildObjectList(List<ObjectItem> objects) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isTablet = screenWidth > 600;

    return RefreshIndicator(
      onRefresh: () => context.read<ObjectProvider>().refreshData(),
      child: ListView.builder(
        padding: EdgeInsets.all(isTablet ? 24 : 16),
        itemCount: objects.length,
        itemBuilder: (context, index) {
          final object = objects[index];
          return _buildObjectCard(object);
        },
      ),
    );
  }

  Widget _buildObjectCard(ObjectItem object) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isTablet = screenWidth > 600;

    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) =>
                ObjectDetailsScreen(object: object),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
                  const begin = Offset(1.0, 0.0);
                  const end = Offset.zero;
                  const curve = Curves.easeInOutCubic;

                  var tween = Tween(
                    begin: begin,
                    end: end,
                  ).chain(CurveTween(curve: curve));

                  var offsetAnimation = animation.drive(tween);

                  return SlideTransition(
                    position: offsetAnimation,
                    child: child,
                  );
                },
            transitionDuration: const Duration(milliseconds: 500),
          ),
        );
      },
      child: Container(
        margin: EdgeInsets.only(bottom: isTablet ? 20 : 16),
        decoration: BoxDecoration(
          color: AppColors.cardBackground,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: AppColors.shadow,
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Padding(
          padding: EdgeInsets.all(isTablet ? 20 : 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: isTablet ? 30 : 25,
                    backgroundColor: AppColors.primaryLight,
                    child: Text(
                      object.name[0].toUpperCase(),
                      style: AppTextStyles.heading3.copyWith(
                        fontSize: isTablet ? 24 : 20,
                        color: AppColors.primaryDark,
                      ),
                    ),
                  ),
                  SizedBox(width: isTablet ? 16 : 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          object.name,
                          style: AppTextStyles.userCardTitle.copyWith(
                            fontSize: isTablet ? 18 : 14,
                          ),
                        ),
                        Text(
                          'ID: ${object.id}',
                          style: AppTextStyles.userCardSubtitle.copyWith(
                            fontSize: isTablet ? 16 : 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    Icons.arrow_forward_ios,
                    color: AppColors.textLight,
                    size: isTablet ? 20 : 16,
                  ),
                ],
              ),
              SizedBox(height: isTablet ? 16 : 12),
              _buildInfoRow(Icons.info, object.formattedData),
              if (object.price != null) ...[
                SizedBox(height: isTablet ? 12 : 8),
                _buildInfoRow(Icons.attach_money, 'Price: \$${object.price}'),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String text) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isTablet = screenWidth > 600;

    return Row(
      children: [
        Icon(icon, size: isTablet ? 20 : 16, color: AppColors.textSecondary),
        SizedBox(width: isTablet ? 12 : 8),
        Expanded(
          child: Text(
            text,
            style: AppTextStyles.bodyMedium.copyWith(
              fontSize: isTablet ? 16 : 14,
              color: AppColors.textPrimary,
            ),
          ),
        ),
      ],
    );
  }
}
