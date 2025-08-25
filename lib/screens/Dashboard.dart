


import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

void main() {
  runApp(StockDashboardApp());
}

class StockDashboardApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dashboard de Gestion de Stock',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: StockDashboard(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class StockDashboard extends StatefulWidget {
  @override
  _StockDashboardState createState() => _StockDashboardState();
}

class _StockDashboardState extends State<StockDashboard> {
  int _currentIndex = 0;

  // Filtres
  String _selectedCategoryFilter = "Toutes";
  String _selectedTimeFilter = "Mois";
  DateTimeRange? _selectedDateRange;

  // Données pour les graphiques
  final List<StockItem> _allItems = [
    StockItem("Écouteurs Bluetooth", 2, 10, "Électronique"),
    StockItem("Souris sans fil", 5, 15, "Électronique"),
    StockItem("Claviers mécaniques", 3, 20, "Électronique"),
    StockItem("T-shirts", 45, 50, "Vêtements"),
    StockItem("Pantalons", 30, 40, "Vêtements"),
    StockItem("Pommes", 100, 150, "Alimentation"),
    StockItem("Bananes", 80, 120, "Alimentation"),
  ];

  final List<Transaction> _allTransactions = [
    Transaction("CMD-1234", "Écouteurs Bluetooth", 50, DateTime.now().subtract(Duration(hours: 2)), "Électronique"),
    Transaction("CMD-1235", "Souris gaming", 25, DateTime.now().subtract(Duration(days: 1)), "Électronique"),
    Transaction("CMD-1236", "Claviers mécaniques", 10, DateTime.now().subtract(Duration(days: 2)), "Électronique"),
    Transaction("CMD-1237", "T-shirts", 100, DateTime.now().subtract(Duration(days: 3)), "Vêtements"),
    Transaction("CMD-1238", "Pommes", 200, DateTime.now().subtract(Duration(days: 5)), "Alimentation"),
  ];

  // Données pour le graphique en barres
  final List<BarChartModel> _barData = [
    BarChartModel(mois: "Jan", valeur: 150),
    BarChartModel(mois: "Fév", valeur: 180),
    BarChartModel(mois: "Mar", valeur: 220),
    BarChartModel(mois: "Avr", valeur: 190),
    BarChartModel(mois: "Mai", valeur: 250),
    BarChartModel(mois: "Juin", valeur: 280),
  ];

  // Données pour le graphique circulaire
  final List<PieChartModel> _pieData = [
    PieChartModel(categorie: "Électronique", valeur: 35, couleur: Colors.blue),
    PieChartModel(categorie: "Vêtements", valeur: 25, couleur: Colors.green),
    PieChartModel(categorie: "Alimentation", valeur: 20, couleur: Colors.orange),
    PieChartModel(categorie: "Maison", valeur: 15, couleur: Colors.purple),
    PieChartModel(categorie: "Sport", valeur: 5, couleur: Colors.red),
  ];

  // Liste des catégories pour le filtre
  final List<String> _categories = ["Toutes", "Électronique", "Vêtements", "Alimentation", "Maison", "Sport"];

  // Liste des filtres temporels
  final List<String> _timeFilters = ["Aujourd'hui", "Semaine", "Mois", "Trimestre", "Année", "Personnalisé"];

  // Getter pour les éléments filtrés
  List<StockItem> get _filteredItems {
    if (_selectedCategoryFilter == "Toutes") return _allItems;
    return _allItems.where((item) => item.category == _selectedCategoryFilter).toList();
  }

  // Getter pour les transactions filtrées
  List<Transaction> get _filteredTransactions {
    List<Transaction> filtered = _allTransactions;

    // Filtre par catégorie
    if (_selectedCategoryFilter != "Toutes") {
      filtered = filtered.where((t) => t.category == _selectedCategoryFilter).toList();
    }

    // Filtre par date
    final now = DateTime.now();
    switch (_selectedTimeFilter) {
      case "Aujourd'hui":
        filtered = filtered.where((t) =>
        t.date.year == now.year &&
            t.date.month == now.month &&
            t.date.day == now.day
        ).toList();
        break;
      case "Semaine":
        final weekAgo = now.subtract(Duration(days: 7));
        filtered = filtered.where((t) => t.date.isAfter(weekAgo)).toList();
        break;
      case "Mois":
        final monthAgo = now.subtract(Duration(days: 30));
        filtered = filtered.where((t) => t.date.isAfter(monthAgo)).toList();
        break;
      case "Trimestre":
        final quarterAgo = now.subtract(Duration(days: 90));
        filtered = filtered.where((t) => t.date.isAfter(quarterAgo)).toList();
        break;
      case "Année":
        final yearAgo = now.subtract(Duration(days: 365));
        filtered = filtered.where((t) => t.date.isAfter(yearAgo)).toList();
        break;
      case "Personnalisé":
        if (_selectedDateRange != null) {
          filtered = filtered.where((t) =>
          t.date.isAfter(_selectedDateRange!.start) &&
              t.date.isBefore(_selectedDateRange!.end)
          ).toList();
        }
        break;
    }

    return filtered;
  }

  // Calcul des KPI basés sur les filtres
  String get _totalProducts {
    return _filteredItems.length.toString();
  }

  String get _stockValue {
    // Simulation de calcul de valeur
    final total = _filteredItems.fold(0, (sum, item) => sum + item.currentQuantity * 50);
    return '€${total.toStringAsFixed(0)}';
  }

  String get _lowStockAlerts {
    final lowStockCount = _filteredItems.where((item) => item.currentQuantity < item.threshold).length;
    return lowStockCount.toString();
  }

  // Fonction pour sélectionner une plage de dates
  Future<void> _selectDateRange(BuildContext context) async {
    final DateTimeRange? picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
      currentDate: DateTime.now(),
      saveText: 'Appliquer',
    );

    if (picked != null) {
      setState(() {
        _selectedDateRange = picked;
        _selectedTimeFilter = "Personnalisé";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: Text('Dashboard de Gestion de Stock'),
        elevation: 0,
        backgroundColor: Colors.blue[700],
        actions: [
          IconButton(
            icon: Icon(Icons.notifications),
            onPressed: () {},
          ),
          IconButton(
            icon: Icon(Icons.filter_alt),
            onPressed: () {
              showModalBottomSheet(
                context: context,
                builder: (context) => _buildFilterSheet(),
              );
            },
          ),
        ],
      ),
      drawer: _buildDrawer(),
      body: _buildBody(),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.inventory),
            label: 'Stock',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart),
            label: 'Rapports',
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: Icon(Icons.add),
        backgroundColor: Colors.blue[700],
      ),
    );
  }

  // Widget pour la feuille de filtres
  Widget _buildFilterSheet() {
    return Container(
      padding: EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Filtres',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 16),
          Text('Catégorie', style: TextStyle(fontWeight: FontWeight.bold)),
          DropdownButton<String>(
            value: _selectedCategoryFilter,
            isExpanded: true,
            items: _categories.map((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
            onChanged: (newValue) {
              setState(() {
                _selectedCategoryFilter = newValue!;
              });
              Navigator.pop(context);
            },
          ),
          SizedBox(height: 16),
          Text('Période', style: TextStyle(fontWeight: FontWeight.bold)),
          DropdownButton<String>(
            value: _selectedTimeFilter,
            isExpanded: true,
            items: _timeFilters.map((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
            onChanged: (newValue) {
              setState(() {
                _selectedTimeFilter = newValue!;
                if (newValue == "Personnalisé") {
                  Navigator.pop(context);
                  _selectDateRange(context);
                } else {
                  Navigator.pop(context);
                }
              });
            },
          ),
          SizedBox(height: 16),
          if (_selectedTimeFilter == "Personnalisé" && _selectedDateRange != null)
            Text(
              'Du ${_formatDate(_selectedDateRange!.start)} au ${_formatDate(_selectedDateRange!.end)}',
              style: TextStyle(color: Colors.blue),
            ),
          SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _selectedCategoryFilter = "Toutes";
                      _selectedTimeFilter = "Mois";
                      _selectedDateRange = null;
                    });
                    Navigator.pop(context);
                  },
                  child: Text('Réinitialiser'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey[300],
                    foregroundColor: Colors.black,
                  ),
                ),
              ),
              SizedBox(width: 16),
              Expanded(
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text('Appliquer'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDrawer() {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.blue[700],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  backgroundColor: Colors.white,
                  radius: 30,
                  child: Icon(
                    Icons.person,
                    size: 30,
                    color: Colors.blue[700],
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  'John Doe',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                  ),
                ),
                Text(
                  'Administrateur',
                  style: TextStyle(
                    color: Colors.white70,
                  ),
                ),
              ],
            ),
          ),
          ListTile(
            leading: Icon(Icons.dashboard),
            title: Text('Tableau de bord'),
            onTap: () {},
          ),
          ListTile(
            leading: Icon(Icons.inventory),
            title: Text('Gestion des stocks'),
            onTap: () {},
          ),
          ListTile(
            leading: Icon(Icons.assessment),
            title: Text('Rapports'),
            onTap: () {},
          ),
          ListTile(
            leading: Icon(Icons.settings),
            title: Text('Paramètres'),
            onTap: () {},
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.exit_to_app),
            title: Text('Déconnexion'),
            onTap: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildBody() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Indicateurs de filtrage actifs
          _buildActiveFilters(),
          SizedBox(height: 16),

          // KPI Cards
          _buildKPISection(),
          SizedBox(height: 24),

          // Charts Row
          _buildChartsSection(),
          SizedBox(height: 24),

          // Low Stock Alert
          _buildLowStockSection(),
          SizedBox(height: 24),

          // Recent Transactions
          _buildRecentTransactionsSection(),
        ],
      ),
    );
  }

  Widget _buildActiveFilters() {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        if (_selectedCategoryFilter != "Toutes")
          Chip(
            label: Text('Catégorie: $_selectedCategoryFilter'),
            deleteIcon: Icon(Icons.close, size: 16),
            onDeleted: () {
              setState(() {
                _selectedCategoryFilter = "Toutes";
              });
            },
          ),
        Chip(
          label: Text('Période: $_selectedTimeFilter'),
          deleteIcon: Icon(Icons.close, size: 16),
          onDeleted: () {
            setState(() {
              _selectedTimeFilter = "Mois";
              _selectedDateRange = null;
            });
          },
        ),
        if (_selectedDateRange != null)
          Chip(
            label: Text('Du ${_formatDate(_selectedDateRange!.start)} au ${_formatDate(_selectedDateRange!.end)}'),
            deleteIcon: Icon(Icons.close, size: 16),
            onDeleted: () {
              setState(() {
                _selectedDateRange = null;
                _selectedTimeFilter = "Mois";
              });
            },
          ),
      ],
    );
  }

  Widget _buildKPISection() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          _buildKPICard(
            'Total des Produits',
            _totalProducts,
            Icons.inventory,
            Colors.blue,
          ),
          SizedBox(width: 16),
          _buildKPICard(
            'Valeur du Stock',
            _stockValue,
            Icons.euro_symbol,
            Colors.green,
          ),
          SizedBox(width: 16),
          _buildKPICard(
            'Alertes Stock Bas',
            _lowStockAlerts,
            Icons.warning,
            Colors.orange,
          ),
        ],
      ),
    );
  }

  Widget _buildKPICard(String title, String value, IconData icon, Color color) {
    return Container(
      width: 180,
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Icon(
                    icon,
                    color: color,
                    size: 30,
                  ),
                  Flexible(
                    child: Text(
                      title,
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 14,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16),
              Text(
                value,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildChartsSection() {
    return Column(
      children: [
        _buildBarChart(),
        SizedBox(height: 16),
        _buildPieChart(),
      ],
    );
  }

  Widget _buildBarChart() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Évolution des Entrées de Stock',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
            Container(
              height: 200,
              child: BarChart(
                BarChartData(
                  barTouchData: BarTouchData(
                    enabled: false,
                    touchTooltipData: BarTouchTooltipData(
                      getTooltipItem: (group, groupIndex, rod, rodIndex) {
                        return BarTooltipItem(
                          rod.toY.round().toString(),
                          TextStyle(
                            color: Colors.blue,
                            fontWeight: FontWeight.bold,
                          ),
                        );
                      },
                    ),
                  ),
                  titlesData: FlTitlesData(
                    show: true,
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          if (value.toInt() < _barData.length) {
                            return Padding(
                              padding: EdgeInsets.only(top: 8.0),
                              child: Text(
                                _barData[value.toInt()].mois,
                                style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 10,
                                ),
                              ),
                            );
                          }
                          return Text('');
                        },
                        reservedSize: 30,
                      ),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          return Text(
                            value.toInt().toString(),
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 10,
                            ),
                          );
                        },
                        reservedSize: 30,
                      ),
                    ),
                  ),
                  gridData: FlGridData(
                    show: true,
                    checkToShowHorizontalLine: (value) => value % 50 == 0,
                    getDrawingHorizontalLine: (value) => FlLine(
                      color: Colors.grey[300],
                      strokeWidth: 1,
                    ),
                  ),
                  borderData: FlBorderData(
                    show: false,
                  ),
                  barGroups: _barData
                      .asMap()
                      .entries
                      .map(
                        (entry) => BarChartGroupData(
                      x: entry.key,
                      barRods: [
                        BarChartRodData(
                          toY: entry.value.valeur,
                          color: Colors.blue,
                          width: 20,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ],
                    ),
                  )
                      .toList(),
                  alignment: BarChartAlignment.spaceAround,
                  maxY: 300,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPieChart() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Répartition par Catégorie',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
            Container(
              height: 200,
              child: PieChart(
                PieChartData(
                  centerSpaceRadius: 40,
                  sections: _pieData.map((data) {
                    return PieChartSectionData(
                      color: data.couleur,
                      value: data.valeur,
                      title: '${data.valeur}%',
                      radius: 25,
                      titleStyle: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
            SizedBox(height: 16),
            Wrap(
              spacing: 8,
              runSpacing: 4,
              children: _pieData.map((data) {
                return Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 12,
                      height: 12,
                      color: data.couleur,
                    ),
                    SizedBox(width: 4),
                    Text(
                      data.categorie,
                      style: TextStyle(fontSize: 12),
                    ),
                  ],
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLowStockSection() {
    final lowStockItems = _filteredItems.where((item) => item.currentQuantity < item.threshold).toList();

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    'Alertes Stock Bas',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Chip(
                  label: Text(
                    lowStockItems.length.toString(),
                    style: TextStyle(color: Colors.white),
                  ),
                  backgroundColor: Colors.orange,
                ),
              ],
            ),
            SizedBox(height: 16),
            lowStockItems.isEmpty
                ? Center(
              child: Text(
                'Aucune alerte de stock bas',
                style: TextStyle(color: Colors.grey),
              ),
            )
                : Column(
              children: lowStockItems.map((item) => _buildLowStockItem(item)).toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLowStockItem(StockItem item) {
    return ListTile(
      contentPadding: EdgeInsets.symmetric(vertical: 4),
      leading: Icon(
        Icons.warning,
        color: Colors.orange,
      ),
      title: Text(item.name),
      subtitle: LinearProgressIndicator(
        value: item.currentQuantity / item.threshold,
        backgroundColor: Colors.grey[300],
        valueColor: AlwaysStoppedAnimation<Color>(
          item.currentQuantity < item.threshold ? Colors.orange : Colors.green,
        ),
      ),
      trailing: Text(
        '${item.currentQuantity}/${item.threshold}',
        style: TextStyle(
          color: item.currentQuantity < item.threshold ? Colors.orange : Colors.green,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildRecentTransactionsSection() {
    final transactions = _filteredTransactions;

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Transactions Récentes',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
            transactions.isEmpty
                ? Center(
              child: Text(
                'Aucune transaction',
                style: TextStyle(color: Colors.grey),
              ),
            )
                : Column(
              children: transactions.map((transaction) => _buildTransactionItem(transaction)).toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTransactionItem(Transaction transaction) {
    return ListTile(
      contentPadding: EdgeInsets.symmetric(vertical: 8),
      leading: Icon(
        Icons.arrow_circle_up,
        color: Colors.green,
      ),
      title: Text(transaction.reference),
      subtitle: Text(transaction.productName),
      trailing: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            '${transaction.quantity} unités',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            _formatDate(transaction.date),
            style: TextStyle(
              color: Colors.grey,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}

// Modèles de données
class StockItem {
  final String name;
  final int currentQuantity;
  final int threshold;
  final String category;

  StockItem(this.name, this.currentQuantity, this.threshold, this.category);
}

class Transaction {
  final String reference;
  final String productName;
  final int quantity;
  final DateTime date;
  final String category;

  Transaction(this.reference, this.productName, this.quantity, this.date, this.category);
}

class BarChartModel {
  final String mois;
  final double valeur;

  BarChartModel({required this.mois, required this.valeur});
}

class PieChartModel {
  final String categorie;
  final double valeur;
  final Color couleur;

  PieChartModel({
    required this.categorie,
    required this.valeur,
    required this.couleur,
  });
}