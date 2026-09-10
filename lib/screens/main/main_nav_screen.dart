import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/localization/app_strings.dart';
import '../../core/providers/locale_provider.dart';
import '../event/add_edit_event_screen.dart';
import '../favorite/favorite_screen.dart';
import '../home/home_screen.dart';
import '../profile/profile_screen.dart';

class MainNavScreen extends StatefulWidget {
  const MainNavScreen({super.key});

  @override
  State<MainNavScreen> createState() => _MainNavScreenState();
}

class _MainNavScreenState extends State<MainNavScreen> {
  int _index = 0;

  final _pages = const [
    HomeScreen(),
    FavoriteScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final ar = context.watch<LocaleProvider>().isArabic;

    return Scaffold(
      body: IndexedStack(index: _index, children: _pages),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => const AddEditEventScreen()),
        ),
        shape: const CircleBorder(),
        child: const Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _index,
        onTap: (i) => setState(() => _index = i),
        items: [
          BottomNavigationBarItem(
            icon: const Icon(Icons.home_outlined),
            activeIcon: const Icon(Icons.home),
            label: AppStrings.of(ar, 'home'),
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.favorite_border),
            activeIcon: const Icon(Icons.favorite),
            label: AppStrings.of(ar, 'favorite'),
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.person_outline),
            activeIcon: const Icon(Icons.person),
            label: AppStrings.of(ar, 'profile'),
          ),
        ],
      ),
    );
  }
}
