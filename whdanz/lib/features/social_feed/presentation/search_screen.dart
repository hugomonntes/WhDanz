import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:whdanz/core/constants/app_constants.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final _searchController = TextEditingController();
  String _searchType = 'all';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Buscar'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(AppDimensions.md),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Buscar usuarios, lugares, posts...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () => _searchController.clear(),
                ),
              ),
            ),
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: AppDimensions.md),
            child: Row(
              children: [
                _buildChip('Todo', 'all'),
                _buildChip('Usuarios', 'users'),
                _buildChip('Lugares', 'places'),
                _buildChip('Videos', 'posts'),
              ],
            ),
          ),
          const SizedBox(height: AppDimensions.md),
          Expanded(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.search,
                    size: 64,
                    color: AppColors.textMuted,
                  ),
                  const SizedBox(height: AppDimensions.md),
                  Text(
                    'Busca bailarines, lugares y más',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChip(String label, String value) {
    final isSelected = _searchType == value;
    return Padding(
      padding: const EdgeInsets.only(right: AppDimensions.sm),
      child: FilterChip(
        label: Text(label),
        selected: isSelected,
        onSelected: (s) => setState(() => _searchType = value),
        selectedColor: AppColors.primary,
        checkmarkColor: Colors.white,
        labelStyle: TextStyle(
          color: isSelected ? Colors.white : AppColors.textPrimary,
        ),
      ),
    );
  }
}
