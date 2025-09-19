// class MovementReport {
//   final String type;
//   final String typeLabel;
//   final String productName;
//   final String barcode;
//   final int quantity;
//   final String firstName;
//   final String lastName;
//   final String statusLabel;
//   final String motif;
//   final String date;
//
//   MovementReport({
//     required this.type,
//     required this.typeLabel,
//     required this.productName,
//     required this.barcode,
//     required this.quantity,
//     required this.firstName,
//     required this.lastName,
//     required this.statusLabel,
//     required this.motif,
//     required this.date,
//   });
//
//   factory MovementReport.fromJson(Map<String, dynamic> json) {
//     return MovementReport(
//       type: json['type'],
//       typeLabel: json['type_label'],
//       productName: json['product_name'],
//       barcode: json['barcode'],
//       quantity: json['quantity'],
//       firstName: json['first_name'],
//       lastName: json['last_name'],
//       statusLabel: json['status_label'],
//       motif: json['motif'] ?? "",
//       date: json['date'],
//     );
//   }
// }
