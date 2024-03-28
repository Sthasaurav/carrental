import 'package:firebase_2/Model/product.dart';
import 'package:firebase_2/constant.dart';
import 'package:firebase_2/customui/customtextformfield.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';

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
                  labelText: 'Model',
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a Model';
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
                  controller: _locationController,
                  labelText: 'Location',
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the Location';
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
                SizedBox(height: 10),
                GestureDetector(
                  onTap: _pickImage, // Call _pickImage() when tapped
                  child: Row(
                    children: [
                      Icon(
                        Icons.add_photo_alternate,
                        size: 36,
                        color: Colors.blue,
                      ),
                      SizedBox(width: 10),
                      Text(
                        'Tap to pick an image',
                        style: TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
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

  Future<void> _pickImage() async {
    final pickedImage =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      setState(() {
        _imageController.text = pickedImage.path;
      });
    }
  }

  void _submitProduct() async {
    // Check if the form is valid
    if (!_formKey.currentState!.validate()) {
      return;
    }

    // Call _pickImage if no image is picked yet
    if (_imageController.text.isEmpty) {
      await _pickImage();
    }

    // Construct a Product object from the form data
    Product product = Product(
      title: _titleController.text,
      description: _descriptionController.text,
      image: _imageController.text, // Use the picked image path
      price: double.parse(_priceController.text),
      category: _selectedCategory ?? '',
      rate: 0.0,
      vehicletype: _selectedVehicleType ?? '',
      numberOfPeople: int.parse(_numberOfPeopleController.text),
      phoneNumber: _phoneNumberController.text,
      driverName: _driverNameController.text,
      driverImage: '',
      id: '',
      vehicleNumber: double.parse(_vehicleNumberController.text),
      distance: 0,
      location: _locationController.text,
    );

    // Send the product data to Firestore
    _addProductToFirestore(product);
  }

  void _addProductToFirestore(Product product) async {
    try {
      // Upload image to Firebase Storage
      String imageUrl = await _uploadImageToStorage();

      // Construct product data to be stored in Firestore
      Map<String, dynamic> productData = {
        'title': product.title,
        'description': product.description,
        'image': imageUrl, // Use the uploaded image URL
        'price': product.price,
        'category': product.category,
        'rate': product.rate,
        'vehicletype': product.vehicletype,
        'numberOfPeople': product.numberOfPeople,
        'phoneNumber': product.phoneNumber,
        'driverName': product.driverName,
        'driverImage': product.driverImage,
        'id': product.id,
        'vehicleNumber': product.vehicleNumber,
        'distance': product.distance,
        'location': product.location,
      };

      // Add product data to Firestore
      await FirebaseFirestore.instance.collection('product').add(productData);

      // Show success message
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Success'),
            content: Text('Product added successfully.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Close the dialog
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    } catch (error) {
      // Show error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to add product: $error')),
      );
    }
  }

  Future<String> _uploadImageToStorage() async {
    // Upload image to Firebase Storage and return its download URL
    // Example implementation using Firebase Storage
    // Replace 'imageFile' with your picked image File
    // StorageReference storageRef = FirebaseStorage.instance.ref().child('images/${_imageController.text}');
    // await storageRef.putFile(imageFile);
    // String downloadUrl = await storageRef.getDownloadURL();
    // return downloadUrl;

    // For now, return a placeholder URL
    return 'assets/v-11.png';
  }
}
