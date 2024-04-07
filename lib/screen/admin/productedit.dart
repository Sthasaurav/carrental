import 'package:firebase_2/screen/admin/admin_screen.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_2/constant.dart';

class AdminProductEditScreen extends StatefulWidget {
  @override
  _AdminProductEditScreenState createState() => _AdminProductEditScreenState();
}

class _AdminProductEditScreenState extends State<AdminProductEditScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Products'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('product').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('No products found.'));
          }

          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              DocumentSnapshot productSnapshot = snapshot.data!.docs[index];
              return ProductCard(productSnapshot: productSnapshot);
            },
          );
        },
      ),
    );
  }
}

class ProductCard extends StatelessWidget {
  final DocumentSnapshot productSnapshot;

  const ProductCard({required this.productSnapshot});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                ProductEditForm(productSnapshot: productSnapshot),
          ),
        );
      },
      child: Card(
        margin: EdgeInsets.all(8.0),
        color: kcontentColor,
        child: ListTile(
          title: Text(productSnapshot['title']),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Category: ${productSnapshot['category']}'),
              Text('Price: Rs.${productSnapshot['price']}'),
              Text('Vehicle No.: Ba. pa${productSnapshot['vehicleNumber']}'),
            ],
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                onPressed: () {
                  // Edit button action
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          ProductEditForm(productSnapshot: productSnapshot),
                    ),
                  );
                },
                icon: Icon(Icons.edit),
                color: Colors.green,
              ),
              IconButton(
                onPressed: () {
                  // Delete button action
                  _showDeleteConfirmationDialog();
                },
                icon: Icon(Icons.delete),
                color: Colors.red,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _showDeleteConfirmationDialog {}

class ProductEditForm extends StatefulWidget {
  final DocumentSnapshot productSnapshot;

  const ProductEditForm({required this.productSnapshot});

  @override
  _ProductEditFormState createState() => _ProductEditFormState();
}

class _ProductEditFormState extends State<ProductEditForm> {
  late Map<String, TextEditingController> _controllers;
  final excludedFields = [
    'image',
    'distance',
    'latitude',
    'longitude',
    'rate',
    'driverImage',
    'count',
    'colors',
    'vehicletype',
    'category'
  ];

  // Fields that should remain as numbers
  final numberFields = ['price', 'numberOfPeople', 'vehicleNumber'];

  @override
  void initState() {
    super.initState();
    _controllers = {};
    final Map<String, dynamic>? data =
        widget.productSnapshot.data() as Map<String, dynamic>?;
    if (data != null) {
      data.keys.forEach((key) {
        if (!excludedFields.contains(key)) {
          _controllers[key] = TextEditingController(text: data[key].toString());
        }
      });
    }
  }

  @override
  void dispose() {
    _controllers.values.forEach((controller) => controller.dispose());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Product'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    children: _controllers.keys.map((key) {
                      return excludedFields.contains(key)
                          ? SizedBox()
                          : Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: TextFormField(
                                controller: _controllers[key],
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  labelText: key,
                                ),
                                keyboardType: _isNumericField(key)
                                    ? TextInputType.number
                                    : TextInputType.text,
                              ),
                            );
                    }).toList(),
                  ),
                ),
              ),
              Row(
                children: [
                  ElevatedButton(
                    onPressed: () async {
                      // Show confirmation dialog
                      _showConfirmationDialog();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: kprimaryColor,
                    ),
                    child: Text(
                      'Save Changes',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: () async {
                      // Show confirmation dialog
                      _showDeleteConfirmationDialog();
                    },
                    style: ElevatedButton.styleFrom(
                      primary: Colors.red,
                    ),
                    child: Text(
                      'Delete',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  bool _isNumericField(String key) {
    // Check if the field is numeric
    return numberFields.contains(key);
  }

  Future<void> _updateProductData() async {
    try {
      // Create a new map to store updated data
      Map<String, dynamic> updatedData = {};

      // Iterate through controllers to get updated values
      _controllers.forEach((key, controller) {
        // Check if the value is numeric
        if (_isNumericField(key)) {
          // If it's numeric, parse it to int
          updatedData[key] = int.parse(controller.text);
        } else {
          // Otherwise, keep it as a string
          updatedData[key] = controller.text;
        }
      });

      // Update the product data in Firestore
      await widget.productSnapshot.reference.update(updatedData);

      // Show a success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Product updated successfully'),
        ),
      );
    } catch (error) {
      // Show an error message if updating fails
      print('Error updating product: $error');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to update product'),
        ),
      );
    }
  }

  Future<void> _deleteProduct() async {
    try {
      // Delete the product document from Firestore
      await widget.productSnapshot.reference.delete();

      // Show a success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Product deleted successfully'),
        ),
      );
    } catch (error) {
      // Show an error message if deletion fails
      print('Error deleting product: $error');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to delete product'),
        ),
      );
    }
  }

  void _showConfirmationDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirmation'),
          content: Text('Are you sure you want to save changes?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => AdminScreen()),
                );
                _updateProductData();
              },
              child: Text('Confirm'),
            ),
          ],
        );
      },
    );
  }

  void _showDeleteConfirmationDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirmation'),
          content: Text('Are you sure you want to delete this product?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => AdminScreen()),
                );
                _deleteProduct();
              },
              child: Text(
                'Delete',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.red,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
