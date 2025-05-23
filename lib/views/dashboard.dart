// import 'package:flutter/material.dart';

// class DashboardScreen extends StatelessWidget {
//   const DashboardScreen({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     final username = ModalRoute.of(context)!.settings.arguments as String? ?? 'User';

//     return Scaffold(
//       backgroundColor: const Color(0xFF000000), // hitam pekat
//       appBar: AppBar(
//         title: const Text('Dashboard'),
//         backgroundColor: Colors.purpleAccent, // purple accent default Flutter
//         foregroundColor: Colors.white,
//         elevation: 0,
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.logout),
//             onPressed: () {
//               Navigator.pushReplacementNamed(context, '/');
//             },
//           )
//         ],
//       ),
//       body: Center(
//         child: Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 24),
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               const Icon(Icons.headphones_rounded, size: 100, color: Colors.white),
//               const SizedBox(height: 20),
//               Text(
//                 'Selamat Datang, $username!',
//                 style: const TextStyle(
//                   fontSize: 24,
//                   fontWeight: FontWeight.bold,
//                   fontFamily: 'Poppins',
//                   color: Colors.white,
//                 ),
//                 textAlign: TextAlign.center,
//               ),
//               const SizedBox(height: 8),
//               const Text(
//                 'Nikmati musikmu!',
//                 style: TextStyle(
//                   fontSize: 16,
//                   fontWeight: FontWeight.w400,
//                   color: Colors.white70,
//                   fontFamily: 'Poppins',
//                 ),
//                 textAlign: TextAlign.center,
//               ),
//               const SizedBox(height: 40),
//               ElevatedButton.icon(
//                 icon: const Icon(Icons.library_music),
//                 label: const Text(
//                   'Lihat Song Playlist',
//                   style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, fontFamily: 'Poppins'),
//                 ),
//                 onPressed: () {
//                   Navigator.pushNamed(context, '/playlists');
//                 },
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: Colors.purpleAccent,
//                   foregroundColor: Colors.black,
//                   padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
//                   shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
