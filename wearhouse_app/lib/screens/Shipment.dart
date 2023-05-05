import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ShipmentScreen extends StatefulWidget {
  @override
  _ShipmentScreenState createState() => _ShipmentScreenState();
}

class _ShipmentScreenState extends State<ShipmentScreen> {
  late QuerySnapshot products;

  @override
  void initState() {
    super.initState();
    getProducts();
  }

  void getProducts() async {
    final querySnapshot =
        await FirebaseFirestore.instance.collection('Products').get();
    setState(() {
      products = querySnapshot;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Shipment Screen'),
      ),
      body: products == null
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: products.size,
              itemBuilder: (context, index) {
                final product = products.docs[index];
                return ListTile(
                  title: Text(product['name']),
                  subtitle: Text('Quantity: ${product['quantity']}'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.remove),
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (context) {
                              int quantity = product['quantity'];
                              return AlertDialog(
                                title: Text('Remove quantity'),
                                content: TextField(
                                  keyboardType: TextInputType.number,
                                  onChanged: (value) {
                                    quantity = int.tryParse(value) ??
                                        product['quantity'];
                                  },
                                ),
                                actions: [
                                  TextButton(
                                    child: Text('Cancel'),
                                    onPressed: () =>
                                        Navigator.of(context).pop(),
                                  ),
                                  TextButton(
                                    child: Text('Facture'),
                                    onPressed: () async {
                                      int amountRemoved =
                                          product['quantity'] - quantity;
                                      await FirebaseFirestore.instance
                                          .collection('Products')
                                          .doc(product.id)
                                          .update({'quantity': amountRemoved});

                                      // Add data to history collection
                                      await FirebaseFirestore.instance
                                          .collection('history')
                                          .add({
                                        'name': product['name'],
                                        'amount': -quantity,
                                        'time': DateTime.now(),
                                      });

                                      Navigator.of(context).pop();
                                      getProducts();
                                    },
                                  ),
                                ],
                              );
                            },
                          );
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
