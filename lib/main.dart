import 'dart:io';

import 'package:adminharbour/screen/menu/categories.dart';
import 'package:adminharbour/screen/menu/dashboard.dart';
import 'package:adminharbour/screen/menu/order.dart';
import 'package:adminharbour/screen/menu/product.dart';
import 'package:adminharbour/screen/menu/return.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_admin_scaffold/admin_scaffold.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: const FirebaseOptions(
          apiKey: "AIzaSyDO2puqMiCGW5JtMGc1Q0JjlTp4BwhCLng",
          projectId: "harbour-ecommerce",
          authDomain: "harbour-ecommerce.firebaseapp.com",
          storageBucket: "harbour-ecommerce.appspot.com",
          messagingSenderId: "951451534126",
          appId: "1:951451534126:web:abee7c1a6735b7949f70bf",
          measurementId: "G-25CRE6SLP9")
      // options: kIsWeb || Platform.isAndroid ?
      // const FirebaseOptions(
      //     apiKey: "AIzaSyDO2puqMiCGW5JtMGc1Q0JjlTp4BwhCLng",
      //     projectId: "harbour-ecommerce",
      //     storageBucket: "harbour-ecommerce.appspot.com",
      //     messagingSenderId: "951451534126",
      //     appId: "1:951451534126:web:abee7c1a6735b7949f70bf",
      // ) : null
      );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      //home: const Text('Ansu Kumar Huajscsnchhajcshi'),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Widget _selectedItem = const DashboardScreen();

  screenSelector(item) {
    switch (item.route) {
      case DashboardScreen.routeName:
        setState(() {
          _selectedItem = const DashboardScreen();
        });
        break;
      case OrderScreen.routeName:
        setState(() {
          _selectedItem = const OrderScreen();
        });
        break;
      case ProductScreen.routeName:
        setState(() {
          _selectedItem = const ProductScreen();
        });
        break;
      case CategoriesScreen.routeName:
        setState(() {
          _selectedItem = const CategoriesScreen();
        });
        break;
      case ReturnScreen.routeName:
        setState(() {
          _selectedItem = const ReturnScreen();
        });
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return AdminScaffold(
        sideBar: SideBar(
          items: const [
            AdminMenuItem(
              title: 'Dashboard',
              icon: Icons.dashboard,
              route: DashboardScreen.routeName,
            ),
            AdminMenuItem(
              title: 'Orders',
              icon: Icons.add_shopping_cart,
              route: OrderScreen.routeName,
              // children: [
              //   AdminMenuItem(
              //     title:'Reseller',
              //     icon: Icons.car_crash,
              //     route: ResellerScreen.routeName,
              //   ),
              //   AdminMenuItem(
              //     title:'Retailer',
              //     icon: Icons.shop,
              //     route: RetailorScreen.routeName,
              //   ),
              // ]
            ),
            AdminMenuItem(
              title: 'Categories',
              icon: Icons.app_registration_outlined,
              route: CategoriesScreen.routeName,
            ),
            AdminMenuItem(
              title: 'Product',
              icon: Icons.production_quantity_limits_sharp,
              route: ProductScreen.routeName,
            ),
            AdminMenuItem(
              title: 'Refund',
              icon: Icons.production_quantity_limits_sharp,
              route: ReturnScreen.routeName,
            ),
          ],
          selectedRoute: '',
          onSelected: (item) {
            screenSelector(item);
          },
        ),
        body: _selectedItem);
  }
}
