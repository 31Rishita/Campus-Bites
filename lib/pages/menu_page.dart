import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:login_signup/widgets/custom_scaffold.dart';
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
        orElse: () => {}, // If item is not found, return an empty map
      );

      if (existingItem.isEmpty) {
        cartItems.add({
          'Name': item['Name'],
          'Image': item['Image'],
          'price': double.parse(item['price'].toString()), // Ensure price is a double
          'quantity': 1,
        });
      } else {
        existingItem['quantity']++;
      }
    });

    // Show snack bar confirmation
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${item['Name']} added to cart!'),
        backgroundColor: Colors.green.shade700,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      child: Stack(
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
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                    childAspectRatio: 0.8,
                  ),
                  itemCount: menuItems.length,
                  itemBuilder: (context, index) {
                    return Card(
  elevation: 8,  // Elevates the card above its background
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(15),  // Rounded corners for the card
  ),
  child: Stack(  // Stack is used to overlay the content on top of each other
    alignment: Alignment.bottomCenter,  // Align the content at the bottom of the card
    children: [
      // Image container
      ClipRRect(
        borderRadius: BorderRadius.circular(15),  // Rounded corners for the image
        child: Image.asset(
          menuItems[index]['Image'],  // The image file path for the menu item
          fit: BoxFit.cover,  // Ensures the image covers the container without distorting
          width: double.infinity,  // Make the image take up the full width of the card
          height: double.infinity,  // Make the image take up the full height of the card
        ),
      ),
      // Overlay container for name, price, and button
      Positioned(
        bottom: 0,  // Positions the container at the bottom of the card
        left: 0,  // Aligns it to the left side
        right: 0,  // Aligns it to the right side
        child: Container(
          padding: const EdgeInsets.all(8),  // Padding around the content inside the container
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.6),  // Semi-transparent black background to make text readable
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(15),  // Match the card's rounded corners
              bottomRight: Radius.circular(15),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,  // Shrinks the column size to fit the children
            children: [
              // Item name
              Text(
                menuItems[index]['Name'],  // The name of the menu item
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,  // White color text to contrast with the dark background
                ),
                textAlign: TextAlign.center,  // Center the text
              ),
              const SizedBox(height: 4),  // Spacer between text elements
              // Item price
              Text(
                '₹${menuItems[index]['price']}',  // The price of the menu item
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.white,  // White color text for the price
                ),
                textAlign: TextAlign.center,  // Center the text
              ),
              const SizedBox(height: 8),  // Spacer between price and button
              // Add to Cart button
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(150, 36),  // Reduce the button size (width, height)
                  backgroundColor: Colors.orange.shade700,  // Background color for the button
                ),
                onPressed: () => addToCart(menuItems[index]),  // Adds the item to the cart when pressed
                child: const Text('Add to Cart'),  // Button label
              ),
            ],
          ),
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
              child: const Icon(Icons.shopping_cart),
            ),
          ),
        ],
      ),
    );
  }
}
