// screens/product_form_screen.dart
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../models/product.dart';
import '../providers/product_provider.dart';
import '../services/api_service.dart';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:barcode_widget/barcode_widget.dart';
// import 'api_service.dart';
// import 'product_provider.dart';
// import 'product_model.dart';

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:barcode_widget/barcode_widget.dart';

import '../models/product.dart';
import '../models/category.dart';
import '../providers/product_provider.dart';
import '../providers/category_provider.dart';
import '../services/api_service.dart';

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:barcode_widget/barcode_widget.dart';

import '../models/product.dart';
import '../models/category.dart';
import '../providers/product_provider.dart';
import '../providers/category_provider.dart';
import '../services/api_service.dart';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:barcode_widget/barcode_widget.dart';
import 'package:provider/provider.dart';
import 'dart:typed_data';
import 'dart:io' show File;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:image_picker/image_picker.dart';


// Utilisation de la charte graphique fournie
final Color _primaryColor = Color(0xFF2196F3);
final Color _secondaryColor = Color(0xFFFF9800);
final Color _accentColor = Color(0xFFFF9800);
final Color _successColor = Color(0xFF10B981);
final Color _warningColor = Color(0xFFF59E0B);
final Color _dangerColor = Color(0xFFEF4444);
final Color _infoColor = Color(0xFF8B5CF6);

class ProductFormScreen extends StatefulWidget {
  final Product? product;
  const ProductFormScreen({super.key, this.product});

  @override
  State<ProductFormScreen> createState() => _ProductFormScreenState();
}

class _ProductFormScreenState extends State<ProductFormScreen> {
  final _formKey = GlobalKey<FormState>();

  // Variables pour stocker les valeurs des champs du formulaire
  String name = '';
  String barcode = '';
  String description = '';
  double price = 0;
  double purchasePrice = 0;
  int quantity = 0;
  int threshold = 1;
  int? categoryId;
  String? imageUrl;
  File? imageFile;
  //File? imageFile;       // Mobile/Desktop
  Uint8List? webImage;   // Web


  // Variables de contrôle
  bool _isLoading = false;

  // Contrôleurs pour les champs de texte
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _barcodeController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _purchasePriceController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();
  final TextEditingController _thresholdController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final p = widget.product;
    if (p != null) {
      name = p.name;
      barcode = p.barcode;
      description = p.description;
      price = p.price;
      purchasePrice = p.purchasePrice;
      quantity = p.quantity;
      threshold = p.threshold;
      categoryId = p.categoryId;
      imageUrl = p.imageUrl;

      // Initialisation des contrôleurs avec les valeurs existantes
      _nameController.text = name;
      _barcodeController.text = barcode;
      _descriptionController.text = description;
      _priceController.text = price.toString();
      _purchasePriceController.text = purchasePrice.toString();
      _quantityController.text = quantity.toString();
      _thresholdController.text = threshold.toString();
    } else {
      barcode = 'BC${DateTime.now().millisecondsSinceEpoch}';
      _barcodeController.text = barcode;
    }

    final categoryProvider = context.read<CategoryProvider>();
    if (categoryProvider.categories.isEmpty) {
      categoryProvider.fetchCategories();
    }
  }

  @override
  void dispose() {
    // Nettoyage des contrôleurs
    _nameController.dispose();
    _barcodeController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    _purchasePriceController.dispose();
    _quantityController.dispose();
    _thresholdController.dispose();
    super.dispose();
  }

  Future<void> pickImage() async {
    final picked = await ImagePicker().pickImage(source: ImageSource.gallery);

    if (picked != null) {
      if (kIsWeb) {
        // Sur Web → on lit les bytes
        final bytes = await picked.readAsBytes();
        setState(() {
          webImage = bytes;
          imageFile = null;
        });
      } else {
        // Sur Mobile/Desktop → on utilise File
        setState(() {
          imageFile = File(picked.path);
          webImage = null;
        });
      }
    }
  }


  Future<void> saveProduct() async {
    if (!_formKey.currentState!.validate()) return;
    _formKey.currentState!.save();

    if (categoryId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Veuillez choisir une catégorie'),
          backgroundColor: _warningColor,
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final provider = Provider.of<ProductProvider>(context, listen: false);

      String? uploadedUrl = imageUrl;

      // 📌 Upload image selon la plateforme
      if (imageFile != null) {
        uploadedUrl = await ApiService().uploadImage(imageFile!);
      } else if (kIsWeb && webImage != null) {
        uploadedUrl = await ApiService().uploadWebImage(webImage!);
      }

      final product = Product(
        id: widget.product?.id ?? 0,
        name: name,
        barcode: barcode,
        description: description,
        categoryId: categoryId!,
        purchasePrice: purchasePrice,
        price: price,
        quantity: quantity,
        threshold: threshold,
        categoryName: '',
        imageUrl: uploadedUrl, // ✅ On garde l’URL complète
        lowStock: quantity <= threshold,
      );

      await provider.createOrUpdateProduct(product, isUpdate: widget.product != null);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(widget.product != null
              ? 'Produit modifié avec succès'
              : 'Produit créé avec succès'),
          backgroundColor: _successColor,
        ),
      );

      if (mounted) Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erreur: ${e.toString()}'),
          backgroundColor: _dangerColor,
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }


  @override
  Widget build(BuildContext context) {
    final categories = context.watch<CategoryProvider>().categories;
    final size = MediaQuery.of(context).size;
    final isSmallScreen = size.width < 600;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          widget.product != null ? 'Modifier le produit' : 'Ajouter un produit',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        backgroundColor: _primaryColor,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(isSmallScreen ? 16.0 : 24.0),
        child: Center(
          child: Container(
            constraints: BoxConstraints(
              maxWidth: isSmallScreen ? double.infinity : 600,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: _primaryColor.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.inventory_2,
                      size: 40,
                      color: _primaryColor,
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                Center(
                  child: Text(
                    widget.product != null ? 'Modifier le produit' : 'Nouveau Produit',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF2D3753),
                    ),
                  ),
                ),
                const SizedBox(height: 8),

                Center(
                  child: Text(
                    "Remplissez les informations ci-dessous",
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ),
                ),
                const SizedBox(height: 32),

                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      // Section image
                      Center(
                        child: Column(
                          children: [
                            Container(
                              width: 120,
                              height: 120,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black12,
                                    blurRadius: 6,
                                    offset: Offset(0, 2),
                                  ),
                                ],
                                border: Border.all(
                                  color: _primaryColor.withOpacity(0.2),
                                  width: 1,
                                ),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: kIsWeb && webImage != null
                                    ? Image.memory(webImage!, fit: BoxFit.cover)
                                    : !kIsWeb && imageFile != null
                                    ? Image.file(imageFile!, fit: BoxFit.cover)
                                    : (imageUrl != null && imageUrl!.isNotEmpty)
                                    ? Image.network(
                                  imageUrl!,
                                  fit: BoxFit.cover,
                                  errorBuilder: (_, __, ___) =>
                                      Icon(Icons.broken_image, color: Colors.grey),
                                )
                                    : Icon(
                                  Icons.image,
                                  color: _primaryColor.withOpacity(0.4),
                                  size: 40,
                                ),
                              ),


                            ),
                            SizedBox(height: 10),
                            ElevatedButton.icon(
                              onPressed: pickImage,
                              icon: Icon(Icons.camera_alt, size: 18),
                              label: Text(
                                imageUrl != null || imageFile != null
                                    ? 'Changer l\'image'
                                    : 'Ajouter une image',
                                style: TextStyle(fontSize: 13),
                              ),

                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white,
                                foregroundColor: _primaryColor,
                                elevation: 1,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                  side: BorderSide(color: _primaryColor.withOpacity(0.3)),
                                ),
                                padding: EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                              ),
                            ),
                          ],
                        ),
                      ),

                      SizedBox(height: 25),

                      // Champ Nom du produit
                      TextFormField(
                        controller: _nameController,
                        decoration: InputDecoration(
                          labelText: "Nom du produit",
                          labelStyle: TextStyle(color: Colors.grey),
                          prefixIcon: Icon(Icons.shopping_bag, color: Colors.grey),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: _primaryColor, width: 2),
                          ),
                        ),
                        style: TextStyle(fontSize: 16),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Veuillez entrer un nom';
                          }
                          return null;
                        },
                        onChanged: (val) {
                          if (val != null) {
                            name = val;
                          }
                        },
                      ),
                      SizedBox(height: 20),

                      // Champ Code-barres
                      TextFormField(
                        controller: _barcodeController,
                        decoration: InputDecoration(
                          labelText: "Code-barres",
                          labelStyle: TextStyle(color: Colors.grey),
                          prefixIcon: Icon(Icons.qr_code, color: Colors.grey),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: _primaryColor, width: 2),
                          ),
                        ),
                        style: TextStyle(fontSize: 16),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Veuillez entrer un code-barres';
                          }
                          return null;
                        },
                        onChanged: (val) {
                          if (val != null) {
                            barcode = val;
                          }
                        },
                      ),
                      SizedBox(height: 15),

                      // Visualisation du code-barres
                      Center(
                        child: Container(
                          padding: EdgeInsets.all(15),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black12,
                                blurRadius: 4,
                                offset: Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Column(
                            children: [
                              Text(
                                'Aperçu du code-barres',
                                style: TextStyle(
                                  color: Colors.grey[700],
                                  fontSize: 13,
                                ),
                              ),
                              SizedBox(height: 8),
                              BarcodeWidget(
                                barcode: Barcode.code128(),
                                data: barcode,
                                width: 200,
                                height: 70,
                                drawText: true,
                                color: Colors.black,
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 20),

                      // Champ Description
                      TextFormField(
                        controller: _descriptionController,
                        maxLines: 3,
                        decoration: InputDecoration(
                          labelText: "Description",
                          labelStyle: TextStyle(color: Colors.grey),
                          prefixIcon: Icon(Icons.description, color: Colors.grey),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: _primaryColor, width: 2),
                          ),
                          alignLabelWithHint: true,
                        ),
                        style: TextStyle(fontSize: 16),
                        onChanged: (val) {
                          if (val != null) {
                            description = val;
                          }
                        },
                      ),
                      SizedBox(height: 20),

                      // Sélecteur de catégorie
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 12),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey.shade300),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: DropdownButtonFormField<int>(
                          value: categoryId,
                          icon: Icon(Icons.arrow_drop_down, color: _primaryColor),
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            prefixIcon: Icon(Icons.category, color: Colors.grey),
                            labelText: "Catégorie",
                            labelStyle: TextStyle(color: Colors.grey),
                          ),
                          items: categories.map((cat) {
                            return DropdownMenuItem<int>(
                              value: cat.id,
                              child: Text(cat.name, style: TextStyle(fontSize: 16)),
                            );
                          }).toList(),
                          onChanged: (val) {
                            if (val != null) {
                              setState(() => categoryId = val);
                            }
                          },
                          validator: (value) => value == null ? 'Veuillez sélectionner une catégorie' : null,
                        ),
                      ),
                      SizedBox(height: 20),

                      // Prix d'achat et prix de vente
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: _purchasePriceController,
                              decoration: InputDecoration(
                                labelText: "Prix d'achat",
                                labelStyle: TextStyle(color: Colors.grey),
                                prefixIcon: Icon(Icons.attach_money, color: Colors.grey),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide(color: _primaryColor, width: 2),
                                ),
                              ),
                              style: TextStyle(fontSize: 16),
                              keyboardType: TextInputType.numberWithOptions(decimal: true),
                              validator: (value) {
                                final val = double.tryParse(value ?? '');
                                if (val == null || val <= 0) {
                                  return 'Prix invalide';
                                }
                                return null;
                              },
                              onChanged: (val) {
                                if (val != null) {
                                  purchasePrice = double.tryParse(val) ?? 0;
                                }
                              },
                            ),
                          ),

                          SizedBox(width: 15),

                          Expanded(
                            child: TextFormField(
                              controller: _priceController,
                              decoration: InputDecoration(
                                labelText: "Prix de vente",
                                labelStyle: TextStyle(color: Colors.grey),
                                prefixIcon: Icon(Icons.point_of_sale, color: Colors.grey),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide(color: _primaryColor, width: 2),
                                ),
                              ),
                              style: TextStyle(fontSize: 16),
                              keyboardType: TextInputType.numberWithOptions(decimal: true),
                              validator: (value) {
                                final val = double.tryParse(value ?? '');
                                if (val == null || val <= 0) {
                                  return 'Prix invalide';
                                }
                                return null;
                              },
                              onChanged: (val) {
                                if (val != null) {
                                  price = double.tryParse(val) ?? 0;
                                }
                              },
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 20),

                      // Quantité et seuil
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: _quantityController,
                              decoration: InputDecoration(
                                labelText: "Quantité en stock",
                                labelStyle: TextStyle(color: Colors.grey),
                                prefixIcon: Icon(Icons.inventory_2, color: Colors.grey),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide(color: _primaryColor, width: 2),
                                ),
                              ),
                              style: TextStyle(fontSize: 16),
                              keyboardType: TextInputType.number,
                              validator: (value) {
                                final val = int.tryParse(value ?? '');
                                if (val == null || val < 0) {
                                  return 'Quantité invalide';
                                }
                                return null;
                              },
                              onChanged: (val) {
                                if (val != null) {
                                  quantity = int.tryParse(val) ?? 0;
                                }
                              },
                            ),
                          ),

                          SizedBox(width: 15),

                          Expanded(
                            child: TextFormField(
                              controller: _thresholdController,
                              decoration: InputDecoration(
                                labelText: "Seuil d'alerte",
                                labelStyle: TextStyle(color: Colors.grey),
                                prefixIcon: Icon(Icons.warning, color: Colors.grey),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide(color: _primaryColor, width: 2),
                                ),
                              ),
                              style: TextStyle(fontSize: 16),
                              keyboardType: TextInputType.number,
                              validator: (value) {
                                final val = int.tryParse(value ?? '');
                                if (val == null || val < 2) {
                                  return 'Seuil ≥ 2';
                                }
                                return null;
                              },
                              onChanged: (val) {
                                if (val != null) {
                                  threshold = int.tryParse(val) ?? 1;
                                }
                              },
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 32),

                      // Bouton de soumission
                      SizedBox(
                        width: double.infinity,
                        height: 56,
                        child: _isLoading
                            ? Center(child: CircularProgressIndicator())
                            : ElevatedButton(
                          onPressed: saveProduct,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: _primaryColor,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 3,
                            padding: EdgeInsets.symmetric(vertical: 16),
                          ),
                          child: Text(
                            widget.product != null ? 'Mettre à jour le produit' : 'Ajouter le produit',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),

                      SizedBox(height: 15),

                      // Bouton annuler
                      if (widget.product != null)
                        SizedBox(
                          width: double.infinity,
                          height: 56,
                          child: OutlinedButton(
                            onPressed: () => Navigator.pop(context),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: Colors.grey[700],
                              side: BorderSide(color: Colors.grey[400]!),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: Text('Annuler'),
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}