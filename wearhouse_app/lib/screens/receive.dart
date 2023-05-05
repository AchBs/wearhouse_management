import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:wearhouse_app/screens/AddNewProduct.dart';

class ReceiveScreen extends StatefulWidget {
  @override
  _ReceiveScreenState createState() => _ReceiveScreenState();
}

class _ReceiveScreenState extends State<ReceiveScreen> {
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

  void addToHistory(String name, int amount) async {
    await FirebaseFirestore.instance.collection('history').add({
      'name': name,
      'amount': amount,
      'time': DateTime.now(),
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Receive Screen'),
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
                  trailing: IconButton(
                    icon: Icon(Icons.add),
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) {
                          int quantity = product['quantity'];
                          return AlertDialog(
                            title: Text('Add quantity'),
                            content: TextField(
                              keyboardType: TextInputType.number,
                              onChanged: (value) {
                                quantity =
                                    int.tryParse(value) ?? product['quantity'];
                              },
                            ),
                            actions: [
                              TextButton(
                                child: Text('Cancel'),
                                onPressed: () => Navigator.of(context).pop(),
                              ),
                              TextButton(
                                child: Text('Save'),
                                onPressed: () async {
                                  int amountAdded = (quantity).toInt();
                                  int newquantity =
                                      (quantity + product['quantity']).toInt();
                                  await FirebaseFirestore.instance
                                      .collection('Products')
                                      .doc(product.id)
                                      .update({'quantity': newquantity});
                                  addToHistory(product['name'], amountAdded);
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
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddNewProductScreen()),
          ).then((value) => getProducts());
        },
        tooltip: 'Add Product',
        child: Icon(Icons.add),
      ),
    );
  }
}
