import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final List<Map<String, dynamic>> items = [
    {"name": "Sunscreen", "price": 55000},
    {"name": "Moisturizer", "price": 121000},
    {"name": "Serum", "price": 89000},
    {"name": "Lipbalm", "price": 56000},
    {"name": "Facewash", "price": 45000},
  ];

  final Set<String> cart = {};

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.purple,
        scaffoldBackgroundColor: Color(0xFFF6E8FF),
        appBarTheme: AppBarTheme(
          backgroundColor: Color(0xFFEED4FF),
          foregroundColor: Colors.black,
        ),
      ),
      routes: {
        '/': (context) => CatalogPage(
              items: items,
              cart: cart,
              onItemTap: toggleItem,
              onDeleteItem: deleteItem,
            ),
        '/bayar': (context) => BayarPage(
              items: items,
              cart: cart,
              onDeleteItem: deleteItem,
            ),
      },
    );
  }

  void toggleItem(String item) {
    setState(() {
      if (cart.contains(item)) {
        cart.remove(item);
      } else {
        cart.add(item);
      }
    });
  }

  void deleteItem(String item) {
    setState(() {
      cart.remove(item);
    });
  }
}

class CatalogPage extends StatelessWidget {
  final List<Map<String, dynamic>> items;
  final Set<String> cart;
  final Function(String) onItemTap;
  final Function(String) onDeleteItem;

  CatalogPage({
    required this.items,
    required this.cart,
    required this.onItemTap,
    required this.onDeleteItem,
  });

  @override
  Widget build(BuildContext context) {
    final total = cart.length;

    return Scaffold(
      appBar: AppBar(
        title: Text("Catalog"),
        actions: [
          Center(
            child: Text(
              "$total",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          IconButton(
            icon: Icon(Icons.shopping_cart),
            onPressed: () => Navigator.pushNamed(context, '/bayar'),
          ),
        ],
      ),
      body: Stack(
        children: [
          ListView.builder(
            padding: EdgeInsets.only(bottom: 150),
            itemCount: items.length,
            itemBuilder: (context, index) {
              final item = items[index]["name"];
              final price = items[index]["price"];
              final isSelected = cart.contains(item);

              return Card(
                color: Colors.white,
                child: ListTile(
                  title: Text(item),
                  onTap: () => onItemTap(item),
                  subtitle: Text(
                    "Rp $price",
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  trailing: isSelected
                      ? IconButton(
                          icon: Icon(Icons.delete, color: Colors.purple),
                          onPressed: () => onDeleteItem(item),
                        )
                      : Icon(Icons.circle_outlined),
                ),
              );
            },
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 6,
                    offset: Offset(0, -2),
                  )
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Total produk dipilih: $total",
                    style: TextStyle(fontSize: 18),
                  ),
                  SizedBox(height: 10),
                  ElevatedButton.icon(
                    onPressed: total == 0
                        ? null
                        : () => Navigator.pushNamed(context, '/bayar'),
                    icon: Icon(Icons.add_shopping_cart),
                    label: Text("ADD ($total)"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.purpleAccent,
                      foregroundColor: Colors.black,
                      minimumSize: Size(double.infinity, 50),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class BayarPage extends StatelessWidget {
  final List<Map<String, dynamic>> items;
  final Set<String> cart;
  final Function(String) onDeleteItem;

  BayarPage({
    required this.items,
    required this.cart,
    required this.onDeleteItem,
  });

  Map<String, dynamic>? getItemData(String name) {
    return items.firstWhere((e) => e["name"] == name, orElse: () => {});
  }

  @override
  Widget build(BuildContext context) {
    final total = cart.length;

    return Scaffold(
      appBar: AppBar(title: Text("Pembayaran")),
      body: Stack(
        children: [
          ListView(
            padding: EdgeInsets.only(bottom: 150, top: 16),
            children: cart.map((item) {
              final data = getItemData(item);
              final price = data?["price"] ?? 0;

              return Card(
                color: Colors.white,
                child: ListTile(
                  title: Text(item),
                  subtitle: Text(
                    "Rp $price",
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  trailing: IconButton(
                    icon: Icon(Icons.delete, color: Colors.purple),
                    onPressed: () {
                      onDeleteItem(item);
                      if (cart.isEmpty) {
                        Navigator.pop(context);
                      }
                    },
                  ),
                ),
              );
            }).toList(),
          ),

          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 6,
                    offset: Offset(0, -2),
                  )
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Total produk dipilih: $total",
                    style: TextStyle(fontSize: 18),
                  ),
                  SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: total == 0 ? null : () {},
                    child: Text("CHECKOUT ($total)"),
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size(double.infinity, 50),
                      backgroundColor: Colors.purpleAccent,
                      foregroundColor: Colors.black,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
