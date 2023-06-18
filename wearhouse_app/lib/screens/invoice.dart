import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class InvoiceScreen extends StatefulWidget {
  @override
  _InvoiceScreenState createState() => _InvoiceScreenState();
}

class _InvoiceScreenState extends State<InvoiceScreen> {
  late QuerySnapshot products;
  List<Map<String, dynamic>> invoiceItems = [];
  double totalPrice = 0.0;

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

  void addToInvoice(Map<String, dynamic> product, int quantity) {
    setState(() {
      double price = product['price'];
      double itemTotal = price * quantity;
      invoiceItems.add({
        'name': product['name'],
        'quantity': quantity,
        'price': price,
        'total': itemTotal,
      });
      totalPrice += itemTotal;
    });
  }

  void removeFromInvoice(int index) {
    setState(() {
      double itemTotal = invoiceItems[index]['total'];
      invoiceItems.removeAt(index);
      totalPrice -= itemTotal;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Invoice Screen'),
      ),
      body: Row(
        children: [
          Expanded(
            child: products == null
                ? Center(child: CircularProgressIndicator())
                : GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 1.0,
                    ),
                    itemCount: products.size,
                    itemBuilder: (context, index) {
                      final product =
                          products.docs[index].data() as Map<String, dynamic>;
                      return InkWell(
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (context) {
                              int quantity = 1;
                              return StatefulBuilder(
                                builder: (context, setState) {
                                  return AlertDialog(
                                    title: Text('Enter Quantity'),
                                    content: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        TextField(
                                          keyboardType: TextInputType.number,
                                          onChanged: (value) {
                                            setState(() {
                                              quantity =
                                                  int.tryParse(value) ?? 1;
                                            });
                                          },
                                        ),
                                        if (quantity > product['quantity'])
                                          Text(
                                            'Quantity exceeds available stock!',
                                            style: TextStyle(color: Colors.red),
                                          ),
                                      ],
                                    ),
                                    actions: [
                                      TextButton(
                                        child: Text('Cancel'),
                                        onPressed: () =>
                                            Navigator.of(context).pop(),
                                      ),
                                      TextButton(
                                        child: Text('Add to Invoice'),
                                        onPressed: () {
                                          if (quantity <= product['quantity']) {
                                            addToInvoice(product, quantity);
                                            Navigator.of(context).pop();
                                          }
                                        },
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                          );
                        },
                        child: Container(
                          margin: EdgeInsets.all(8),
                          padding: EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                product['name'],
                                style: TextStyle(fontSize: 16),
                              ),
                              SizedBox(height: 8),
                              Text(
                                'Quantity: ${product['quantity']}',
                                style: TextStyle(fontSize: 14),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
          VerticalDivider(),
          Expanded(
            child: Column(
              children: [
                Text(
                  'Invoice Items',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: invoiceItems.length,
                    itemBuilder: (context, index) {
                      final item = invoiceItems[index];
                      return ListTile(
                        title: Text(item['name']),
                        subtitle: Table(
                          defaultColumnWidth: IntrinsicColumnWidth(),
                          children: [
                            TableRow(
                              children: [
                                TableCell(child: Text('Quantity')),
                                TableCell(child: Text('Price per Unit')),
                                TableCell(child: Text('Total Price')),
                              ],
                            ),
                            TableRow(
                              children: [
                                TableCell(
                                    child: Text(item['quantity'].toString())),
                                TableCell(child: Text('\$${item['price']}')),
                                TableCell(child: Text('\$${item['total']}')),
                              ],
                            ),
                          ],
                        ),
                        trailing: IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () {
                            removeFromInvoice(index);
                          },
                        ),
                      );
                    },
                  ),
                ),
                Text(
                  'Total Price: \$${totalPrice.toStringAsFixed(2)}',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.arrow_forward),
        onPressed: () {
          // Navigate to the next screen for entering client information
          // Pass the invoiceItems and totalPrice to the next screen
        },
      ),
    );
  }
}
