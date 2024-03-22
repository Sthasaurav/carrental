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
              return ProductEditForm(productSnapshot: productSnapshot);
            },
          );
        },
      ),
    );
  }
}

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
    return Padding(
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
                      ? SizedBox() // Skip rendering excluded fields
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
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text('Confirm Save'),
                        content: Text('Are you sure you want to save changes?'),
                        actions: <Widget>[
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: Text('Cancel'),
                          ),
                          TextButton(
                            onPressed: () async {
                              Navigator.of(context).pop();
                              Map<String, dynamic> updatedData = {};
                              _controllers.forEach((key, controller) {
                                updatedData[key] = controller.text;
                              });

                              try {
                                await widget.productSnapshot.reference
                                    .update(updatedData);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content:
                                        Text('Product updated successfully'),
                                  ),
                                );
                              } catch (error) {
                                print('Error updating product: $error');
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Failed to update product'),
                                  ),
                                );
                              }
                            },
                            child: Text('OK'),
                          ),
                        ],
                      );
                    },
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: kprimaryColor,
                ),
                child: Text(
                  'Save',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                  ),
                ),
              ),
              SizedBox(width: 10),
              ElevatedButton(
                onPressed: () async {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text('Delete Product'),
                        content: Text(
                            'Are you sure you want to delete this product?'),
                        actions: <Widget>[
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: Text('Cancel'),
                          ),
                          TextButton(
                            onPressed: () async {
                              try {
                                // Delete the whole document
                                await widget.productSnapshot.reference.delete();
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content:
                                        Text('Product deleted successfully'),
                                  ),
                                );
                              } catch (error) {
                                print('Error deleting product: $error');
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Failed to delete product'),
                                  ),
                                );
                              }
                              Navigator.of(context).pop();
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
    );
  }
}
