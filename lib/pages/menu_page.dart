import 'dart:convert';
import 'package:flutter/material.dart';
import 'cart_page.dart';

class MenuPage extends StatefulWidget {
  final String restaurantName;

  const MenuPage({Key? key, required this.restaurantName}) : super(key: key);

  @override
  _MenuPageState createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  List<Map<String, dynamic>> cartItems = [];

  Future<List<Map<String, dynamic>>> loadMenuItems(BuildContext context) async {
    try {
      String dataString = await DefaultAssetBundle.of(context).loadString('assets/data1.json');
      List<dynamic> jsonList = jsonDecode(dataString);

      Map<String, dynamic>? restaurantData = jsonList.firstWhere(
        (element) => element['restNAme'] == widget.restaurantName,
        orElse: () => {},
      );

      if (restaurantData!.isEmpty) {
        throw Exception('Restaurant not found: ${widget.restaurantName}');
      }

      return List<Map<String, dynamic>>.from(restaurantData['menuItems']);
    } catch (e) {
      throw Exception('Error loading menu: $e');
    }
  }

  void addToCart(Map<String, dynamic> item) {
    setState(() {
      var existingItem = cartItems.firstWhere(
        (cartItem) => cartItem['Name'] == item['Name'],
        orElse: () => {},
      );

      if (existingItem.isEmpty) {
        cartItems.add({
          'Name': item['Name'],
          'Image': item['Image'],
          'price': item['price'],
          'quantity': 1,
        });
      } else {
        existingItem['quantity']++;
      }
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${item['Name']} added to cart!'),
        backgroundColor: Colors.green.shade700,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.restaurantName),
        backgroundColor: Colors.orange.shade700,
      ),
      body: Stack(
        children: [
          FutureBuilder<List<Map<String, dynamic>>>(
            future: loadMenuItems(context),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return const Center(child: Text('Error loading menu'));
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Center(child: Text('No menu items available'));
              }

              List<Map<String, dynamic>> menuItems = snapshot.data!;

              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                    childAspectRatio: 0.8,
                  ),
                  itemCount: menuItems.length,
                  itemBuilder: (context, index) {
                    return Card(
                      elevation: 8,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Stack(
                        alignment: Alignment.bottomCenter,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(15),
                            child: Image.asset(
                              menuItems[index]['Image'],
                              fit: BoxFit.cover,
                              width: double.infinity,
                              height: double.infinity,
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.all(8),
                            color: Colors.black.withOpacity(0.6),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  menuItems[index]['Name'],
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  '₹${menuItems[index]['price']}',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.white,
                                  ),
                                ),
                                SizedBox(height: 4),
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.orange.shade700,
                                  ),
                                  onPressed: () => addToCart(menuItems[index]),
                                  child: Text('Add to Cart'),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              );
            },
          ),
          Positioned(
            bottom: 20,
            right: 20,
            child: FloatingActionButton(
              backgroundColor: Colors.orange.shade700,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CartPage(cartItems: cartItems),
                  ),
                );
              },
              child: Icon(Icons.shopping_cart),
            ),
          ),
        ],
      ),
    );
  }
}
