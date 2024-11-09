import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vendor_multi_store/provider/vendor_provider.dart';
import 'package:vendor_multi_store/views/screens/authentication/register_screen.dart';
import 'package:vendor_multi_store/views/screens/main_vendor_screen.dart';

void main() {
  runApp(
    const ProviderScope(
      child: MainApp(),
    ),
  );
}

class MainApp extends ConsumerWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Future<void> checkTokenAndSetUser(WidgetRef ref) async {
      SharedPreferences preferences = await SharedPreferences.getInstance();

      String? token = preferences.getString('auth_token');
      String? vendorJson = preferences.getString('vendor');

      if (token != null && vendorJson != null) {
        ref.read(vendorProvider.notifier).setVendor(vendorJson);
      } else {
        ref.read(vendorProvider.notifier).signOut();
      }
    }

    return MaterialApp(
      home: FutureBuilder(
        future: checkTokenAndSetUser(ref),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }
          final vendor = ref.watch(vendorProvider);
          return vendor != null
              ? const MainVendorScreen()
              : const RegisterScreen();
        },
      ),
    );
  }
}
