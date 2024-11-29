import 'package:flutter/material.dart';

class CartPage extends StatefulWidget {
  final List<Map<String, dynamic>> cartItems;

  CartPage({required this.cartItems});

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

  // Method to navigate to OrderPlacedPage
  void goToOrderPlacedPage() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => OrderPlacedPage()),
    );
  }


  @override
  Widget build(BuildContext context) {
    // Calculate the total price of the cart
    double total = 0;
    for (var item in widget.cartItems) {
      total += item['price'] * item['quantity'];
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("Cart"),
        backgroundColor: const Color.fromARGB(255, 244, 243, 243),
        centerTitle: true,
        elevation: 8,
      ),
      body: widget.cartItems.isEmpty
          ? Center(
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
                                    widget.cartItems[index]['image'],
                                    height: 60,
                                    width: 60, // Square shape
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                SizedBox(width: 10),
                                // Item name and quantity
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        widget.cartItems[index]['name'],
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.brown.shade600,
                                        ),
                                      ),
                                      Row(
                                        children: [
                                          Text(
                                            '₹${widget.cartItems[index]['price']} x ${widget.cartItems[index]['quantity']}',
                                            style: TextStyle(
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
                                      icon: Icon(Icons.remove, color: Colors.redAccent),
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
                                      icon: Icon(Icons.add, color: Colors.green),
                                      onPressed: () => incrementQuantity(index),
                                    ),
                                  ],
                                ),
                                // Total price for the item
                                Text(
                                  '₹${widget.cartItems[index]['price'] * widget.cartItems[index]['quantity']}',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.brown.shade600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  Divider(),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Total: ",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          '₹${total.toStringAsFixed(2)}',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.green,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Pay Total Amount Button
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton(
                      onPressed: goToOrderPlacedPage,
                      child: Text('Pay Total Amount'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green, // Green color
                        padding: EdgeInsets.symmetric(vertical: 15, horizontal: 30),
                        textStyle: TextStyle(fontSize: 18),
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}

class OrderPlacedPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Order Placed"),
        backgroundColor: Colors.green,
      ),
      body: Center(
        child: Text(
          "Your order has been placed successfully!",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}