import 'package:flutter/material.dart';
import 'package:luf_turism_app/pages/Menu/category_list.dart';
import 'package:luf_turism_app/pages/Menu/favorites_list.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';

class NavigationBarGoo extends StatefulWidget {
  const NavigationBarGoo({super.key});

  @override
  State<NavigationBarGoo> createState() => _NavigationBarGooState();
}

class _NavigationBarGooState extends State<NavigationBarGoo> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const CategoriesPage(),
    const FavoritesPage(),
    // const SearchPage(),
    // const ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //appBar: AppBar(title: const Text('Turismo')),
      body: Center(
        child: _pages[_selectedIndex],
      ),
      bottomNavigationBar: SalomonBottomBar(
        currentIndex: _selectedIndex,
        selectedItemColor: const Color.fromRGBO(1, 82, 104, 1),
        unselectedItemColor: const Color.fromRGBO(0, 122, 129, 1),
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        items: _navBarItems,
      ),
    );
  }
}

final _navBarItems = [
  SalomonBottomBarItem(
    icon: const Icon(Icons.home),
    title: const Text("Inicio"),
    selectedColor: const Color.fromARGB(255, 6, 91, 128),
  ),
  SalomonBottomBarItem(
    icon: const Icon(Icons.favorite_border),
    title: const Text("Favoritos"),
    selectedColor: Colors.pink,
  ),
  // SalomonBottomBarItem(
  //   icon: const Icon(Icons.search),
  //   title: const Text("Search"),
  //   selectedColor: Colors.orange,
  // ),
  // SalomonBottomBarItem(
  //   icon: const Icon(Icons.person),
  //   title: const Text("Profile"),
  //   selectedColor: Colors.teal,
  // ),
];

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('Home Flutter'),
    );
  }
}

class LikesPage extends StatelessWidget {
  const LikesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('Likes Flutter'),
    );
  }
}

class SearchPage extends StatelessWidget {
  const SearchPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('Search Flutter'),
    );
  }
}

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('Profile Flutter'),
    );
  }
}
