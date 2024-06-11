import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:typed_data';
import 'product_service.dart'; // Import the ProductService
import 'menu_item.dart'; // Import the MenuItem model

class ProductManagementPage extends StatefulWidget {
  @override
  _ProductManagementPageState createState() => _ProductManagementPageState();
}

class _ProductManagementPageState extends State<ProductManagementPage> {
  final ProductService _productService = ProductService();
  List<MenuItem> _menuItems = [];
  List<MenuItem> _filteredMenuItems = [];
  bool _isLoading = true;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchMenuItems();
    _searchController.addListener(_filterMenuItems);
  }

  @override
  void dispose() {
    _searchController.removeListener(_filterMenuItems);
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _fetchMenuItems() async {
    try {
      final menuItems = await _productService.fetchMenuItems();
      setState(() {
        _menuItems = menuItems;
        _filteredMenuItems = menuItems;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      print('Error fetching menu items: $e');
    }
  }

  void _filterMenuItems() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredMenuItems = _menuItems
          .where((item) => item.food_name.toLowerCase().contains(query))
          .toList();
    });
  }

  void _addMenuItem(MenuItem menuItem) async {
    try {
      await _productService.addMenuItem(menuItem);
      _fetchMenuItems(); // Refresh the list after adding
    } catch (e) {
      print('Error adding menu item: $e');
    }
  }

  void _editMenuItem(MenuItem menuItem) async {
    try {
      await _productService.updateMenuItem(menuItem);
      _fetchMenuItems(); // Refresh the list after editing
    } catch (e) {
      print('Error editing menu item: $e');
    }
  }

  void _deleteMenuItem(int foodId) async {
    try {
      await _productService.deleteMenuItem(foodId);
      _fetchMenuItems(); // Refresh the list after deleting
    } catch (e) {
      print('Error deleting menu item: $e');
    }
  }

  Future<Uint8List> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      return await pickedFile.readAsBytes();
    }
    return Uint8List(0);
  }

  void _showMenuItemDialog({MenuItem? menuItem, int? index}) {
    final _nameController = TextEditingController(text: menuItem?.food_name ?? '');
    final _priceController = TextEditingController(text: menuItem?.food_price.toString() ?? '');
    final _categoryController = TextEditingController(text: menuItem?.food_category ?? '');
    Uint8List _image = menuItem?.food_image ?? Uint8List(0);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(menuItem == null ? 'Add Menu Item' : 'Edit Item Menu'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: _nameController,
                  decoration: InputDecoration(labelText: 'Nama Makanan'),
                ),
                TextField(
                  controller: _priceController,
                  decoration: InputDecoration(labelText: 'Harga Makanan'),
                  keyboardType: TextInputType.number,
                ),
                TextField(
                  controller: _categoryController,
                  decoration: InputDecoration(labelText: 'Kategori Makanan'),
                ),
                SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () async {
                    Uint8List image = await _pickImage();
                    setState(() {
                      _image = image;
                    });
                  },
                  child: Text('Pilih Imej'),
                ),
                if (_image.isNotEmpty)
                  Image.memory(
                    _image,
                    height: 100,
                    fit: BoxFit.cover,
                  ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Batal'),
            ),
            ElevatedButton(
              onPressed: () {
                final name = _nameController.text;
                final price = double.tryParse(_priceController.text) ?? 0;
                final category = _categoryController.text;

                if (menuItem == null) {
                  _addMenuItem(MenuItem(
                    food_id: 0, // Temporary ID for new item, should be replaced by backend
                    food_name: name,
                    food_price: price,
                    food_image: _image,
                    food_category: category,
                  ));
                } else if (index != null) {
                  _editMenuItem(MenuItem(
                    food_id: menuItem.food_id, // Keep the same ID for updates
                    food_name: name,
                    food_price: price,
                    food_image: _image.isNotEmpty ? _image : menuItem.food_image, // Use new image if picked
                    food_category: category,
                  ));
                }

                Navigator.of(context).pop();
              },
              child: Text(menuItem == null ? 'Add' : 'Simpan'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pengurusan Produk'),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'Cari',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.search),
              ),
            ),
          ),
          Expanded(
            child: _filteredMenuItems.isEmpty
                ? Center(child: Text('No items found'))
                : ListView.builder(
              itemCount: _filteredMenuItems.length,
              itemBuilder: (context, index) {
                final menuItem = _filteredMenuItems[index];

                return Card(
                  margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                  child: ListTile(
                    title: Text(menuItem.food_name),
                    subtitle: Text(
                        'RM ${menuItem.food_price.toStringAsFixed(2)} - ${menuItem.food_category}'),
                    leading: Image.memory(menuItem.food_image,
                        width: 50, height: 50, fit: BoxFit.cover),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(Icons.edit),
                          onPressed: () {
                            _showMenuItemDialog(menuItem: menuItem, index: index);
                          },
                        ),
                        IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () {
                            _deleteMenuItem(menuItem.food_id);
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showMenuItemDialog();
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
