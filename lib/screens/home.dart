import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:login_signup/pages/menu_page.dart';  // Import the MenuPage
import 'package:login_signup/widgets/custom_scaffold.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  Future<List<Map<String, dynamic>>> loadItems(BuildContext context) async {
    String dataString = await DefaultAssetBundle.of(context)
        .loadString('assets/data.json');
    List<dynamic> jsonList = jsonDecode(dataString);
    return List<Map<String, dynamic>>.from(jsonList);
  }

  Widget buildItem(Map<String, dynamic> item, BuildContext context) {
    // Null safety check for fields before accessing
    String placeImage = item['placeImage'] ?? 'assets/images/BG.png';  // Fallback image
    String placeName = item['placeName'] ?? 'Unknown Place';  // Fallback name

    return GestureDetector(
      onTap: () {
        // Extracting the restaurant name from the 'restNAme' and passing it to the MenuPage
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MenuPage(restaurantName: item['restNAme'] ?? 'Unknown'),  // Pass the restNAme to MenuPage
          ),
        );
      },
      child: Card(
        margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.horizontal(
                left: Radius.circular(10),
              ),
              child: Image.asset(
                placeImage,
                width: 100,
                height: 100,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: 16),
            Text(
              placeName,
              style: const TextStyle(
                  fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      child: FutureBuilder<List<Map<String, dynamic>>>(  // Loading the restaurant data
        future: loadItems(context),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text('Error loading data'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No items available'));
          }

          List<Map<String, dynamic>> items = snapshot.data!;
          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 20),
                  child: Text(
                    "CampusBite",
                    style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
                  ),
                ),
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    return buildItem(items[index], context);
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
