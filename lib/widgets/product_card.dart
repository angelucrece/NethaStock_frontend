// import 'package:flutter/material.dart';
// import 'package:cached_network_image/cached_network_image.dart';
// import '../models/product.dart';
// import '../utils/helpers.dart';
//
// class ProductCard extends StatelessWidget {
//   final Product product;
//   final VoidCallback onTap;
//   final VoidCallback? onEdit;
//   final VoidCallback? onDelete;
//
//   const ProductCard({
//     Key? key,
//     required this.product,
//     required this.onTap,
//     this.onEdit,
//     this.onDelete,
//   }) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       elevation: 2,
//       margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 0),
//       child: InkWell(
//         onTap: onTap,
//         child: Padding(
//           padding: const EdgeInsets.all(12),
//           child: Row(
//             children: [
//               // Image du produit
//               _buildProductImage(),
//               const SizedBox(width: 12),
//
//               // Informations du produit
//               Expanded(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       product.name,
//                       style: const TextStyle(
//                         fontSize: 16,
//                         fontWeight: FontWeight.bold,
//                       ),
//                       maxLines: 1,
//                       overflow: TextOverflow.ellipsis,
//                     ),
//                     const SizedBox(height: 4),
//                     Text(
//                       product.barcode,
//                       style: TextStyle(
//                         fontSize: 14,
//                         color: Colors.grey[600],
//                       ),
//                     ),
//                     const SizedBox(height: 4),
//                     _buildStockInfo(),
//                   ],
//                 ),
//               ),
//
//               // Actions
//               if (onEdit != null || onDelete != null) ...[
//                 PopupMenuButton(
//                   itemBuilder: (context) => [
//                     if (onEdit != null)
//                       const PopupMenuItem(
//                         value: 'edit',
//                         child: ListTile(
//                           leading: Icon(Icons.edit),
//                           title: Text('Modifier'),
//                         ),
//                       ),
//                     if (onDelete != null)
//                       const PopupMenuItem(
//                         value: 'delete',
//                         child: ListTile(
//                           leading: Icon(Icons.delete, color: Colors.red),
//                           title: Text('Supprimer'),
//                         ),
//                       ),
//                   ],
//                   onSelected: (value) {
//                     if (value == 'edit') onEdit?.call();
//                     if (value == 'delete') onDelete?.call();
//                   },
//                 ),
//               ],
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildProductImage() {
//     return Container(
//       width: 60,
//       height: 60,
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(8),
//         color: Colors.grey[200],
//       ),
//       // child: product.imageUrl != null
//       //     ? CachedNetworkImage(
//       //   //imageUrl: product.imageUrl!,
//       //   fit: BoxFit.cover,
//       //   placeholder: (context, url) => const Center(
//       //     child: CircularProgressIndicator(),
//       //   ),
//       //   errorWidget: (context, url, error) => const Icon(Icons.error),
//       // )
//       //     : const Icon(Icons.inventory_2, size: 30, color: Colors.grey),
//     );
//   }
//
//   Widget _buildStockInfo() {
//     final isLowStock = product.isLowStock;
//
//     return Row(
//       children: [
//         Text(
//           'Stock: ${product.quantity}',
//           style: TextStyle(
//             fontSize: 14,
//             color: isLowStock ? Colors.orange : Colors.green,
//             fontWeight: FontWeight.w500,
//           ),
//         ),
//         if (isLowStock) ...[
//           const SizedBox(width: 8),
//           Icon(Icons.warning, size: 16, color: Colors.orange),
//         ],
//       ],
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/product.dart';
import '../providers/product_provider.dart';
import '../screens/product_form_screen.dart';

class ProductCard extends StatelessWidget {
  final Product product;
  ProductCard({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ProductProvider>(context, listen: false);
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 10),
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Row(
          children: [
            SizedBox(
              width: 100,
              height: 100,
              child: product.imageUrl != null && product.imageUrl!.isNotEmpty
                  ? Image.network(product.fullImageUrl, fit: BoxFit.cover, errorBuilder: (_, __, ___) => const Icon(Icons.broken_image))
                  : const Icon(Icons.image_not_supported, size: 50),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(product.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  Text('Catégorie: ${product.categoryName}'),
                  Text('Prix: \$${product.price.toStringAsFixed(2)}'),
                  Text('Quantité: ${product.quantity}'),
                  if (product.lowStock)
                    const Text('Stock bas!', style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
                ],
              ),
            ),
            Column(
              children: [
                IconButton(
                  icon: const Icon(Icons.edit, color: Colors.blue),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => ProductFormScreen(product: product)),
                    );
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () => provider.deleteProduct(product.id),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
