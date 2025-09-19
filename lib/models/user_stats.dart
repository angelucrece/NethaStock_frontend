//
//
// class UserStats {
//   final int totalUsers;
//   final int adminCount;
//   final int magasinierCount;
//   final int activeUsers;
//   final int inactiveUsers;
//   final int activeThisWeek;
//   final int activeThisMonth;
//
//   UserStats({
//     required this.totalUsers,
//     required this.adminCount,
//     required this.magasinierCount,
//     required this.activeUsers,
//     required this.inactiveUsers,
//     required this.activeThisWeek,
//     required this.activeThisMonth,
//   });
//
//   factory UserStats.fromJson(Map<String, dynamic> json) {
//     return UserStats(
//       totalUsers: json['totalUsers'] ?? 0,
//       adminCount: json['adminCount'] ?? 0,
//       magasinierCount: json['magasinierCount'] ?? 0,
//       activeUsers: json['activeUsers'] ?? 0,
//       inactiveUsers: json['inactiveUsers'] ?? 0,
//       activeThisWeek: json['activeThisWeek'] ?? 0,
//       activeThisMonth: json['activeThisMonth'] ?? 0,
//     );
//   }
// }
