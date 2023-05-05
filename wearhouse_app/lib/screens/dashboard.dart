import 'package:flutter/material.dart';
import 'package:wearhouse_app/screens/selling.dart';
import 'package:wearhouse_app/screens/stock.dart';
import 'package:wearhouse_app/screens/receive.dart';
import 'package:wearhouse_app/screens/Shipment.dart';
import 'package:wearhouse_app/screens/historique.dart';

class DashboardScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dashboard'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                _buildSquare(
                  context,
                  'Shipment',
                  Icons.local_shipping,
                  Colors.redAccent,
                ),
                SizedBox(width: 20),
                _buildSquare(
                  context,
                  'Receive',
                  Icons.store,
                  Colors.blueAccent,
                ),
              ],
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                _buildSquare(
                  context,
                  'Stock',
                  Icons.inventory,
                  Colors.greenAccent,
                ),
                SizedBox(width: 20),
                _buildSquare(
                  context,
                  'History',
                  Icons.access_time_outlined,
                  Colors.orangeAccent,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSquare(
      BuildContext context, String title, IconData icon, Color color) {
    return GestureDetector(
      onTap: () {
        switch (title) {
          case 'Shipment':
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ShipmentScreen()),
            );
            break;
          case 'Receive':
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ReceiveScreen()),
            );
            break;
          case 'Stock':
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => Stock()),
            );
            break;
          case 'History':
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => History()),
            );
        }
      },
      child: Container(
        width: 150,
        height: 150,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: Colors.white,
              size: 50,
            ),
            SizedBox(height: 10),
            Text(
              title,
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
