import 'dart:convert';
import 'package:flutter/material.dart';

class FastFoodPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Future<List<Map<String, dynamic>>> loadMenuItems() async {
      String dataString = await DefaultAssetBundle.of(context)
          .loadString('assets/data.json');
      List<dynamic> jsonList = jsonDecode(dataString);
      Map<String, dynamic> restaurantData = jsonList.firstWhere((element) => element['restNAme'] == 'fastfood');
      List<dynamic> menuItems = restaurantData['menuItems'];
      return List<Map<String, dynamic>>.from(menuItems);
    }

    return Scaffold(
      appBar: AppBar(title: Text('Fast Food Menu')),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: loadMenuItems(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text('Error loading menu'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No menu items available'));
          }

          List<Map<String, dynamic>> menuItems = snapshot.data!;
          return ListView.builder(
            itemCount: menuItems.length,
            itemBuilder: (context, index) {
              return Card(
                child: ListTile(
                  leading: Image.asset(menuItems[index]['Image']),
                  title: Text(menuItems[index]['Name']),
                  subtitle: Text('Price: ₹${menuItems[index]['price']}'),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
