import 'package:drw/frontend/utility/front_util.dart';
import 'package:flutter/material.dart';

class FamilyImagesPage extends StatefulWidget {
  final String title;
  final List<String> images;
  const FamilyImagesPage({super.key, required this.title, required this.images});

  @override
  State<FamilyImagesPage> createState() => _FamilyImagesPageState();
}

class _FamilyImagesPageState extends State<FamilyImagesPage> {
  String? getImage(int index) {
    if (index < widget.images.length) {
      return widget.images[index];
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: FrontUtil.textColor),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          '家庭群組',
          style: TextStyle(color: FrontUtil.textColor, fontWeight: FontWeight.bold, fontSize: 20),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(2.0),
          child: Container(
            height: 2.0,
            color: FrontUtil.textColor,
          ),
        ),
      ),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 12),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFFD3F1F1), Colors.white],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
              borderRadius: BorderRadius.vertical(
                bottom: Radius.circular(20),
              ),
            ),
            child: Text(
              widget.title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Color(0xFF4E9A99),
                fontSize: 16,
                fontWeight: FontWeight.w600,
                height: 2,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: _buildImageGrid(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBox(String? url, double w, double h) {
    if (url == null) {
      return Container(
        width: w,
        height: h,
        // margin: const EdgeInsets.only(right: 10, bottom: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
      );
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: Image.network(
        url,
        width: w,
        height: h,
        fit: BoxFit.cover,
      ),
    );
  }

  Widget _buildImageGrid() {
    return Column(
      children: [
        Row(
          // crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 左側大區塊
            Column(
              children: [
                _buildBox(getImage(0), 170, 180),
                const SizedBox(height: 10),
                _buildBox(getImage(3), 170, 100),
                const SizedBox(height: 10),
                Row(
                  children: [
                    _buildBox(getImage(5), 80, 85),
                    const SizedBox(width: 10),
                    _buildBox(getImage(6), 80, 85),
                  ],
                ),
                const SizedBox(height: 10),
              ],
            ),

            const SizedBox(width: 10),

            // 右側區塊
            Column(
              children: [
                Row(
                  children: [
                    _buildBox(getImage(1), 80, 85),
                    const SizedBox(width: 10),
                    _buildBox(getImage(2), 80, 85),
                  ],
                ),
                const SizedBox(height: 10),
                _buildBox(getImage(4), 170, 180),
                const SizedBox(height: 10),
                _buildBox(getImage(7), 170, 100),
                const SizedBox(height: 10),
              ],
            ),
          ],
        ),
        Row(
          children: [
            _buildBox(getImage(8), 250, 100),
            const SizedBox(width: 10),
            _buildBox(getImage(9), 90, 100),
          ],
        ),
       
      ],
    );
  }
}
