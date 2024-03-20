import 'package:firebase_2/Model/product.dart';
import 'package:firebase_2/constant.dart';
import 'package:firebase_2/customui/customtextformfield.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddProductPage extends StatefulWidget {
  List<String> categories = ['SUV', 'Sedan', 'Hatch-Back', 'Sports'];
  String? _selectedCategory;

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
  String? _selectedCategory; // Define _selectedCategory here
  String? _selectedVehicleType;

  final List<String> categories = [
    'SUV',
    'Sedan',
    'Hatch-Back',
    'Sports',
  ];
  final List<String> vehicletype = [
    'automatic',
    'manual',
  ];
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
                CustomForm(
                  controller: _titleController,
                  labelText: 'Title',
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a title';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),
                CustomForm(
                  controller: _descriptionController,
                  labelText: 'Description',
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a description';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),
                CustomForm(
                  controller: _priceController,
                  labelText: 'Price',
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a price';
                    }
                    return null;
                  },
                ),
                DropdownButtonFormField(
                  decoration: InputDecoration(labelText: 'Vehicle Type'),
                  value: _selectedVehicleType,
                  items: vehicletype.map((type) {
                    return DropdownMenuItem(
                      value: type,
                      child: Text(
                        type,
                        style: const TextStyle(
                          fontWeight: FontWeight.normal,
                          fontSize: 14,
                        ),
                      ),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedVehicleType = value as String?;
                    });
                  },
                  validator: (value) {
                    if (value == null) {
                      return 'Please select a vehicle type';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),
                DropdownButtonFormField(
                  decoration: InputDecoration(labelText: 'Category'),
                  value: _selectedCategory,
                  items: categories.map((category) {
                    return DropdownMenuItem(
                      value: category,
                      child: Text(
                        category,
                        style: const TextStyle(
                          fontWeight: FontWeight.normal,
                          fontSize: 14,
                        ),
                      ),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedCategory = value as String?;
                    });
                  },
                  validator: (value) {
                    if (value == null) {
                      return 'Please select a category';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),
                CustomForm(
                  controller: _numberOfPeopleController,
                  labelText: 'Number of People',
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the number of people';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),
                CustomForm(
                  controller: _phoneNumberController,
                  labelText: 'Phone Number',
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a phone number';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),
                CustomForm(
                  controller: _vehicleNumberController,
                  labelText: 'Vehicle Number',
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the vehicle number';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),
                CustomForm(
                  controller: _driverNameController,
                  labelText: 'Driver Name',
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a driver name';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _submitProduct();
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        kprimaryColor, // Change button color to orange
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(10), // Set slight curve
                    ),
                    minimumSize: Size(double.infinity, 50), // Set button size
                  ),
                  child: Text(
                    'Submit',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                    ),
                  ),
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
      image: '',
      price: double.parse(_priceController.text), // Parse price to double
      category: _selectedCategory ??
          '', // Use selected category from dropdown or default to empty string
      rate: 0.0,
      vehicletype: _selectedVehicleType ?? '',
      numberOfPeople: int.parse(_numberOfPeopleController.text),
      phoneNumber: _phoneNumberController.text,
      driverName: _driverNameController.text,
      driverImage: '', // No need to include driverImage
      id: '', // No need to include id
      vehicleNumber: double.parse(_vehicleNumberController.text),
      distance: 0.0, // No need to include distance
      location: '', // No need to include location
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
