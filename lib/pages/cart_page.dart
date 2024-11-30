import 'package:flutter/material.dart';
import 'package:login_signup/widgets/custom_scaffold.dart';

class CartPage extends StatefulWidget {
  final List<Map<String, dynamic>> cartItems;

  const CartPage({super.key, required this.cartItems});

  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  // Method to increment the quantity in the cart
  void incrementQuantity(int index) {
    setState(() {
      widget.cartItems[index]['quantity']++;
    });
  }

  // Method to decrement the quantity in the cart
  void decrementQuantity(int index) {
    setState(() {
      if (widget.cartItems[index]['quantity'] > 0) {
        widget.cartItems[index]['quantity']--;
        if (widget.cartItems[index]['quantity'] == 0) {
          widget.cartItems.removeAt(index); // Remove item from cart if quantity is 0
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // Calculate the total price of the cart
    double total = 0;
    for (var item in widget.cartItems) {
      // Ensure price is treated as double (in case it's coming as a string)
      double price = item['price'] is String ? double.parse(item['price']) : item['price'];
      total += price * item['quantity']; // 'price' is now a double
    }

    return CustomScaffold(
      child: widget.cartItems.isEmpty
          ? const Center(
              child: Text(
                "Your cart is empty.",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            )
          : Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      itemCount: widget.cartItems.length,
                      itemBuilder: (context, index) {
                        double price = widget.cartItems[index]['price'] is String
                            ? double.parse(widget.cartItems[index]['price'])
                            : widget.cartItems[index]['price'];
                        
                        return Card(
                          elevation: 8,
                          shadowColor: Colors.grey.shade300,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                // Display item image in a square shape
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: Image.asset(
                                    widget.cartItems[index]['Image'],
                                    height: 60,
                                    width: 60, // Square shape
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                const SizedBox(width: 10),
                                // Item name and quantity
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        widget.cartItems[index]['Name'],
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.brown.shade600,
                                        ),
                                      ),
                                      Row(
                                        children: [
                                          Text(
                                            '₹${price} x ${widget.cartItems[index]['quantity']}',
                                            style: const TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.green,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                // Quantity control with + and - buttons in horizontal layout
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    IconButton(
                                      icon: const Icon(Icons.remove, color: Colors.redAccent),
                                      onPressed: () => decrementQuantity(index),
                                    ),
                                    Text(
                                      '${widget.cartItems[index]['quantity']}',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.brown.shade600,
                                      ),
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.add, color: Colors.green),
                                      onPressed: () => incrementQuantity(index),
                                    ),
                                  ],
                                ),
                                // Total price for the item
                                Text(
                                  '₹${(price * widget.cartItems[index]['quantity']).toStringAsFixed(2)}',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.blue.shade800,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  // Display total price
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'Total: ₹${total.toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  // Pay button (can show a confirmation message or navigate to another page)
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange.shade700,
                    ),
                    onPressed: () {
                      // For now, show a simple confirmation message instead of navigating
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Order Placed Successfully!'),
                          backgroundColor: Colors.green,
                        ),
                      );
                    },
                    child: const Text(
                      'Pay Total Amount',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
