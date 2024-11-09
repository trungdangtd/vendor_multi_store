import 'package:flutter/material.dart';
import 'package:vendor_multi_store/views/screens/nav_screen/earnings_screen.dart';
import 'package:vendor_multi_store/views/screens/nav_screen/edit_screen.dart';
import 'package:vendor_multi_store/views/screens/nav_screen/order_screen.dart';
import 'package:vendor_multi_store/views/screens/nav_screen/upload_screen.dart';
import 'package:vendor_multi_store/views/screens/nav_screen/vendor_profile_screen.dart';

class MainVendorScreen extends StatefulWidget {
  const MainVendorScreen({super.key});

  @override
  State<MainVendorScreen> createState() => _MainVendorScreenState();
}

class _MainVendorScreenState extends State<MainVendorScreen> {
  int _pageIndex = 0;
    
  List<Widget> _pages = [
    EarningsScreen(),
    UploadScreen(),
    EditScreen(),
    OrderScreen(),
    VendorProfileScreen(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
          currentIndex: _pageIndex,
          onTap: (value) {
            setState(() {
              _pageIndex = value;
            });
          },
          unselectedItemColor: Colors.grey,
          selectedItemColor: Colors.purple,
          type: BottomNavigationBarType.fixed,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.money), label: "Earning"),
            BottomNavigationBarItem(icon: Icon(Icons.upload), label: "Upload"),
            BottomNavigationBarItem(icon: Icon(Icons.edit), label: "Edit"),
            BottomNavigationBarItem(
                icon: Icon(Icons.shopping_cart), label: "Orders"),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
          ]),
          body: _pages[_pageIndex],
    );
  }
}
