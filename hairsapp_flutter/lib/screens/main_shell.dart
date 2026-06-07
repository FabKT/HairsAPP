import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import 'home_screen.dart';
import 'routine_screen.dart';
import 'products_screen.dart';
import 'nutrition_screen.dart';
import 'profile_screen.dart';

class MainShell extends StatefulWidget {
  const MainShell({super.key, this.initialIndex = 0});
  final int initialIndex;

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
  }

  static const _screens = [
    HomeScreen(),
    RoutineScreen(),
    ProductsScreen(),
    NutritionScreen(),
    ProfileScreen(),
  ];

  static const _icons = [
    Icons.home_outlined,
    Icons.calendar_today_outlined,
    Icons.shopping_bag_outlined,
    Icons.restaurant_outlined,
    Icons.person_outline,
  ];

  static const _selectedIcons = [
    Icons.home,
    Icons.calendar_today,
    Icons.shopping_bag,
    Icons.restaurant,
    Icons.person,
  ];

  static const _labels = [
    'Home',
    'Routine',
    'Produits',
    'Nutrition',
    'Profil',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: const Color(0xF2101014),
          border: Border(
            top: BorderSide(
              color: AppColors.border.withValues(alpha: 0.4),
              width: 0.5,
            ),
          ),
        ),
        child: SafeArea(
          top: false,
          child: SizedBox(
            height: 64,
            child: Row(
              children: List.generate(5, (i) {
                final selected = i == _currentIndex;
                return Expanded(
                  child: GestureDetector(
                    onTap: () => setState(() => _currentIndex = i),
                    behavior: HitTestBehavior.opaque,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 4, vertical: 6),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        curve: Curves.easeInOut,
                        decoration: BoxDecoration(
                          gradient:
                              selected ? AppColors.primaryGradient : null,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              selected ? _selectedIcons[i] : _icons[i],
                              size: 22,
                              color: selected
                                  ? Colors.white
                                  : AppColors.mutedForeground,
                            ),
                            const SizedBox(height: 3),
                            Text(
                              _labels[i],
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: selected
                                    ? FontWeight.w700
                                    : FontWeight.normal,
                                color: selected
                                    ? Colors.white
                                    : AppColors.mutedForeground,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              }),
            ),
          ),
        ),
      ),
    );
  }
}
