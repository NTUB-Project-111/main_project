// import 'package:drw/frontend/pages/familypages/family_images.dart';
// import 'package:drw/frontend/utility/front_util.dart';
// import 'package:flutter/material.dart';

// class ReportImagePart extends StatefulWidget {
//   const ReportImagePart({super.key});

//   @override
//   State<ReportImagePart> createState() => _ReportImagePartState();
// }

// class _ReportImagePartState extends State<ReportImagePart> {
//   @override
//   Widget build(BuildContext context) {
    
//     return SingleChildScrollView(
//         child: Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         _buildSectionTitle('本週診斷報告', () {
//           Navigator.push(
//             context,
//             MaterialPageRoute(
//                 builder: (context) => const FamilyImagesPage(
//                       title: '本週診斷報告',
//                     )),
//           );
//         }),
//         _buildImageSection([]),
//         _buildSectionTitle('割傷', () {
//           Navigator.push(
//             context,
//             MaterialPageRoute(
//                 builder: (context) => const FamilyImagesPage(
//                       title: '割傷診斷報告',
//                     )),
//           );
//         }),
//         _buildImageSection([]),
//       ],
//     ));
//   }

//   static Widget _buildSectionTitle(String title, VoidCallback onMorePressed) {
//     return Padding(
//       padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
//       child: Row(
//         children: [
//           const SizedBox(
//             height: 15,
//           ),
//           Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
//           const Spacer(),
//           TextButton(
//               onPressed: onMorePressed,
//               child: Row(
//                 children: [
//                   Text('更多', style: TextStyle(color: FrontUtil.textColor)),
//                   Icon(Icons.arrow_forward_ios, size: 12, color: FrontUtil.textColor),
//                 ],
//               ))
//         ],
//       ),
//     );
//   }

//   static Widget _buildImageSection(List<String> imagePaths) {
//     return Padding(
//       padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
//       child: Row(
//         children: [
//           imagePaths.isEmpty
//               ? Container(
//                   height: 220,
//                   width: 159, //176
//                   margin: const EdgeInsets.only(right: 10),
//                   decoration: BoxDecoration(
//                       color: Colors.grey[200], borderRadius: BorderRadius.circular(10)),
//                 )
//               : ClipRRect(
//                   child: Image.network(
//                     '',
//                     fit: BoxFit.cover,
//                     height: 220,
//                     width: 159,
//                   ),
//                 ),
//           Column(
//             children: [
//               imagePaths.isEmpty
//                   ? Container(
//                       height: 105,
//                       width: 159,
//                       margin: const EdgeInsets.only(bottom: 10),
//                       decoration: BoxDecoration(
//                           color: Colors.grey[200], borderRadius: BorderRadius.circular(10)),
//                     )
//                   : ClipRRect(
//                       child: Image.network(
//                         '',
//                         fit: BoxFit.cover,
//                         height: 105,
//                         width: 159,
//                       ),
//                     ),
//               Row(
//                 children: [
//                   imagePaths.isEmpty
//                       ? Container(
//                           height: 105,
//                           width: 74, //83
//                           margin: const EdgeInsets.only(right: 10),
//                           decoration: BoxDecoration(
//                               color: Colors.grey[200], borderRadius: BorderRadius.circular(10)),
//                         )
//                       : ClipRRect(
//                           child: Image.network(
//                             '',
//                             fit: BoxFit.cover,
//                             height: 105,
//                             width: 74,
//                           ),
//                         ),
//                   imagePaths.isEmpty
//                       ? Container(
//                           height: 105,
//                           width: 74,
//                           decoration: BoxDecoration(
//                               color: Colors.grey[200], borderRadius: BorderRadius.circular(10)),
//                         )
//                       : ClipRRect(
//                           child: Image.network(
//                             '',
//                             fit: BoxFit.cover,
//                             height: 105,
//                             width: 74,
//                           ),
//                         )
//                 ],
//               )
//             ],
//           )
//         ],
//       ),
//     );
//   }
// }
