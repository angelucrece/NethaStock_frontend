import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gestion de Produits',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        ),
      ),
      home: AddProductForm(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class AddProductForm extends StatefulWidget {
  @override
  _AddProductFormState createState() => _AddProductFormState();
}

class _AddProductFormState extends State<AddProductForm> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _quantityController = TextEditingController();
  final _thresholdController = TextEditingController();

  String? _selectedCategory;
  String? _selectedSection;
  bool _isActive = true;
  bool _isLoading = false;

  // Listes déroulantes fictives
  final List<String> _categories = ['Électronique', 'Vêtements', 'Alimentation', 'Maison', 'Sport'];
  final List<String> _sections = ['Rayon A', 'Rayon B', 'Rayon C', 'Entrepôt', 'Vitrine'];

  // Gestion de la sélection d'image
  String? _imagePath;

  @override
  void initState() {
    super.initState();
    // Initialiser avec des valeurs par défaut valides
    _quantityController.text = '1';
    _thresholdController.text = '1';
  }

  Future<void> _pickImage() async {
    // Simulation de sélection d'image
    setState(() {
      _isLoading = true;
    });

    await Future.delayed(Duration(seconds: 1));

    setState(() {
      _imagePath = 'assets/sample_product_image.jpg';
      _isLoading = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Image sélectionnée avec succès')),
    );
  }

  // Validation des nombres positifs
  String? _validatePositiveNumber(String? value, String fieldName) {
    if (value == null || value.isEmpty) {
      return 'Veuillez entrer $fieldName';
    }

    final number = int.tryParse(value);
    if (number == null) {
      return 'Veuillez entrer un nombre valide';
    }

    if (number <= 0) {
      return '$fieldName doit être supérieur à 0';
    }

    return null;
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      // Simulation de traitement
      await Future.delayed(Duration(seconds: 2));

      setState(() {
        _isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Produit ajouté avec succès!'),
          backgroundColor: Colors.green,
        ),
      );

      // Réinitialisation du formulaire
      _formKey.currentState!.reset();
      setState(() {
        _selectedCategory = null;
        _selectedSection = null;
        _imagePath = null;
        _isActive = true;
        _quantityController.text = '1';
        _thresholdController.text = '1';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ajouter un produit'),
        elevation: 0,
        backgroundColor: Colors.blue.shade700,
        systemOverlayStyle: SystemUiOverlayStyle.light,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Section d'import d'image
              _buildImageSection(),
              SizedBox(height: 24),

              // Champ nom du produit
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'Nom du produit',
                  prefixIcon: Icon(Icons.shopping_bag),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer un nom de produit';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),

              // Champ seuil d'alerte avec input type="number"
              TextFormField(
                controller: _thresholdController,
                decoration: InputDecoration(
                  labelText: 'Seuil d\'alerte',
                  prefixIcon: Icon(Icons.warning),
                  suffixText: 'unités',
                ),
                keyboardType: TextInputType.number, // Équivalent à <input type="number">
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly, // N'autorise que les chiffres
                ],
                validator: (value) => _validatePositiveNumber(value, 'Le seuil'),
              ),
              SizedBox(height: 16),

              // Champ quantité avec input type="number"
              TextFormField(
                controller: _quantityController,
                decoration: InputDecoration(
                  labelText: 'Quantité',
                  prefixIcon: Icon(Icons.inventory),
                  suffixText: 'unités',
                ),
                keyboardType: TextInputType.number, // Équivalent à <input type="number">
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly, // N'autorise que les chiffres
                ],
                validator: (value) => _validatePositiveNumber(value, 'La quantité'),
              ),
              SizedBox(height: 16),

              // Sélection de catégorie
              DropdownButtonFormField<String>(
                value: _selectedCategory,
                decoration: InputDecoration(
                  labelText: 'Catégorie',
                  prefixIcon: Icon(Icons.category),
                ),
                items: _categories.map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (newValue) {
                  setState(() {
                    _selectedCategory = newValue;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez sélectionner une catégorie';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),

              // Sélection de section
              DropdownButtonFormField<String>(
                value: _selectedSection,
                decoration: InputDecoration(
                  labelText: 'Sectionner une catégorie',
                  prefixIcon: Icon(Icons.location_on),
                ),
                items: _sections.map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (newValue) {
                  setState(() {
                    _selectedSection = newValue;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez sélectionner une section';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),

              // Switch Actif
              Row(
                children: [
                  Icon(Icons.toggle_on, color: Colors.blue),
                  SizedBox(width: 12),
                  Text('Actif', style: TextStyle(fontSize: 16)),
                  Spacer(),
                  Switch(
                    value: _isActive,
                    onChanged: (value) {
                      setState(() {
                        _isActive = value;
                      });
                    },
                    activeColor: Colors.blue,
                  ),
                ],
              ),
              SizedBox(height: 32),

              // Bouton d'ajout
              ElevatedButton(
                onPressed: _isLoading ? null : _submitForm,
                child: _isLoading
                    ? SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                )
                    : Text(
                  'Ajouter',
                  style: TextStyle(fontSize: 16),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue.shade700,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImageSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Image du produit',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        ),
        SizedBox(height: 8),
        GestureDetector(
          onTap: _pickImage,
          child: Container(
            height: 150,
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: _imagePath == null
                ? Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.cloud_upload,
                  size: 40,
                  color: Colors.grey.shade400,
                ),
                SizedBox(height: 8),
                Text(
                  'Cliquer pour importer une image',
                  style: TextStyle(color: Colors.grey.shade600),
                ),
              ],
            )
                : ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.asset(
                _imagePath!,
                fit: BoxFit.cover,
                width: double.infinity,
              ),
            ),
          ),
        ),
        if (_isLoading)
          LinearProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
          ),
      ],
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _quantityController.dispose();
    _thresholdController.dispose();
    super.dispose();
  }
}