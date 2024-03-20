import 'package:firebase_2/Model/product.dart';
import 'package:firebase_2/constant.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddProductPage extends StatefulWidget {
  @override
  _AddProductPageState createState() => _AddProductPageState();
}

class _AddProductPageState extends State<AddProductPage> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController _titleController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();
  TextEditingController _imageController = TextEditingController();
  TextEditingController _priceController = TextEditingController();
  TextEditingController _categoryController = TextEditingController();
  TextEditingController _rateController = TextEditingController();
  TextEditingController _vehicleTypeController = TextEditingController();
  TextEditingController _numberOfPeopleController = TextEditingController();
  TextEditingController _phoneNumberController = TextEditingController();
  TextEditingController _driverNameController = TextEditingController();
  TextEditingController _driverImageController = TextEditingController();
  TextEditingController _idController = TextEditingController();
  TextEditingController _countController = TextEditingController();
  TextEditingController _vehicleNumberController = TextEditingController();
  TextEditingController _distanceController = TextEditingController();
  TextEditingController _locationController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Product'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  controller: _titleController,
                  decoration: InputDecoration(labelText: 'Title'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a title';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _descriptionController,
                  decoration: InputDecoration(labelText: 'Description'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a description';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _imageController,
                  decoration: InputDecoration(labelText: 'Image'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter an image URL';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _priceController,
                  decoration: InputDecoration(labelText: 'Price'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a price';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _categoryController,
                  decoration: InputDecoration(labelText: 'Category'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a category';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _rateController,
                  decoration: InputDecoration(labelText: 'Rate'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a rate';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _vehicleTypeController,
                  decoration: InputDecoration(labelText: 'Vehicle Type'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a vehicle type';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _numberOfPeopleController,
                  decoration: InputDecoration(labelText: 'Number of People'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the number of people';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _phoneNumberController,
                  decoration: InputDecoration(labelText: 'Phone Number'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a phone number';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _driverNameController,
                  decoration: InputDecoration(labelText: 'Driver Name'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a driver name';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _driverImageController,
                  decoration: InputDecoration(labelText: 'Driver Image'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a driver image URL';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _idController,
                  decoration: InputDecoration(labelText: 'ID'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter an ID';
                    }
                    return null;
                  },
                ),
                // TextFormField(
                //   controller: _countController,
                //   decoration: InputDecoration(labelText: 'Count'),
                //   validator: (value) {
                //     if (value == null || value.isEmpty) {
                //       return 'Please enter a count';
                //     }
                //     return null;
                //   },
                // ),
                TextFormField(
                  controller: _vehicleNumberController,
                  decoration: InputDecoration(labelText: 'Vehicle Number'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a vehicle number';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _locationController,
                  decoration: InputDecoration(labelText: 'location'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a location of vehicle';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _distanceController,
                  decoration: InputDecoration(labelText: 'Distance'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a distance';
                    }
                    return null;
                  },
                ),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _submitProduct();
                    }
                  },
                  child: Text('Submit'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _submitProduct() {
    // Construct a Product object from the form data
    Product product = Product(
      title: _titleController.text,
      description: _descriptionController.text,
      image: _imageController.text,
      price: double.parse(_priceController.text), // Parse price to double
      category: _categoryController.text,
      rate: double.parse(_rateController.text),
      vehicletype: _vehicleTypeController.text,
      numberOfPeople: int.parse(_numberOfPeopleController.text),
      phoneNumber: _phoneNumberController.text,
      driverName: _driverNameController.text,
      driverImage: _driverImageController.text,
      id: _idController.text,
      // count: int.parse(_countController.text),
      vehicleNumber: double.parse(_vehicleNumberController.text),
      distance: double.parse(_distanceController.text),
      location: _locationController.text,
    );

    // Send the product data to Firestore
    _addProductToFirestore(product);
  }

  void _addProductToFirestore(Product product) {
    // Access Firestore and add the product data to the "product" collection
    FirebaseFirestore.instance.collection('product').add({
      'title': product.title,
      'description': product.description,
      'image': "assets/v-2.png",
      'price': product.price,
      'category': product.category,
      'rate': 4.3,
      'vehicletype': product.vehicletype,
      'numberOfPeople': product.numberOfPeople,
      'phoneNumber': product.phoneNumber,
      'driverName': product.driverName,
      'driverImage': "assets/v-2.png",
      'id': 'Default ID',
      // 'count': product.count,
      'vehicleNumber': product.vehicleNumber,
      'distance': 2.6,
      'location': product.location,
    }).then((value) {
      // Product added successfully, show a success message or navigate to another page
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Product added successfully')),
      );
      // You can navigate to another page or clear the form fields here
    }).catchError((error) {
      // Error adding product to Firestore
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to add product: $error')),
      );
    });
  }
}

Widget buildFormField(String label, TextEditingController controller,
    String? Function(String? value)? validator, IconData prefixIcon) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 10),
    child: TextFormField(
      controller: controller,
      style: TextStyle(fontSize: 18),
      decoration: InputDecoration(
        prefixIcon: Icon(prefixIcon, color: kprimaryColor),
        labelText: label,
        labelStyle: TextStyle(fontSize: 16, color: kprimaryColor),
        border: OutlineInputBorder(
          borderSide: BorderSide(color: kprimaryColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: kprimaryColor, width: 2),
        ),
      ),
      validator: validator,
    ),
  );
}
