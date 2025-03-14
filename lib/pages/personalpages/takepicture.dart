import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
// import '../wound.dart'; // 引入分析頁面的檔案
import 'dart:io';
import '../../my_flutter_app_icons.dart';
import 'package:image_picker/image_picker.dart';

import '../resultpage.dart';
import 'personalcontain.dart';

class TakePicuturePage extends StatefulWidget {
  const TakePicuturePage({super.key});

  @override
  _TakePicuturePageState createState() => _TakePicuturePageState();
}

class _TakePicuturePageState extends State<TakePicuturePage> {
  int selectedIndex = 0;
  double progress = 0;
  late List<CameraDescription> _cameras;
  CameraController? _controller;
  bool _isCameraInitialized = false;
  int _currentCameraIndex = 0;
  File? _image;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  void _setZoomLevel(double zoom) async {
    if (_controller != null && _controller!.value.isInitialized) {
      try {
        await _controller!.setZoomLevel(zoom);
      } catch (e) {
        print("設定縮放比例失敗：$e");
      }
    }
  }

  Future<void> _initializeCamera() async {
    try {
      _cameras = await availableCameras();
      await _setupCamera(_currentCameraIndex);
    } catch (e) {
      print("初始化相機失敗：$e");
    }
  }

  Future<void> _setupCamera(int cameraIndex) async {
    if (_controller != null) {
      await _controller!.dispose();
    }
    _controller = CameraController(
      _cameras[cameraIndex],
      ResolutionPreset.high,
    );
    try {
      await _controller!.initialize();
      setState(() {
        _isCameraInitialized = true;
      });
    } catch (e) {
      print("相機控制器初始化失敗：$e");
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  Future<void> _takePhoto() async {
    if (_controller == null || !_controller!.value.isInitialized) return;

    try {
      final image = await _controller!.takePicture();
      print("圖片儲存於：${image.path}");
      setState(() {
        _image = File(image.path);
      });
      _showConfirmationDialog(); // 顯示確認對話框
    } catch (e) {
      print("拍照失敗：$e");
    }
  }

  void _switchCamera() {
    if (_cameras.length > 1) {
      setState(() {
        _isCameraInitialized = false;
      });
      _currentCameraIndex = (_currentCameraIndex + 1) % _cameras.length;
      _setupCamera(_currentCameraIndex);
    } else {
      print("無法切換相機");
    }
  }

  void _navigateToPersonalPage(File image) {
    Navigator.push(
      context,
      MaterialPageRoute(
        // builder: (context) => WoundAnalysisPage(image: image), // 傳遞圖片
        builder: (context) => PersonalContainPage(image: image), // 傳遞圖片
      ),
    );
    
  }

  // 顯示確認對話框
  void _showConfirmationDialog() {
    showDialog(
      barrierDismissible: false, // 禁止點擊外部區域關閉對話框
      context: context,
      builder: (BuildContext context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: const BorderSide(
            color: Color(0xFF589399),
            width: 2,
          ),
        ),
        backgroundColor: Colors.white,
        title: const Text(
          '確認照片',
          style: TextStyle(
            fontSize: 20,
            color: Color(0xFF589399),
            fontWeight: FontWeight.w700,
          ),
          textAlign: TextAlign.center,
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: Image.file(
                _image!,
                width: 200,
                height: 160,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 20),
            OutlinedButton(
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 70),
                backgroundColor: const Color(0xFF589399),
                side: BorderSide.none,
              ),
              onPressed: () {
                Navigator.pop(context); // 關閉對話框
                _navigateToPersonalPage(_image!); // 跳轉到分析頁面
              },
              child: const Text(
                '確認',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            const SizedBox(height: 10),
            OutlinedButton(
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 70),
                side: const BorderSide(
                  width: 2,
                  color: Color(0xFF589399),
                ),
              ),
              onPressed: () {
                Navigator.pop(context); // 關閉對話框
              },
              child: const Text(
                '取消',
                style: TextStyle(
                  color: Color(0xFF589399),
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: Stack(
              children: [
                _isCameraInitialized
                    ? Positioned(
                        top: 0,
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width,
                          height: 735,
                          child: CameraPreview(_controller!),
                        ),
                      )
                    : const Center(
                        child: CircularProgressIndicator(),
                      ),
                Positioned(
                  left: 10,
                  top: 30,
                  child: IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(
                      MyFlutterApp.icon_park_solid__back,
                      color: Color(0xFF589399),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 135,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 50),
                    width: MediaQuery.of(context).size.width,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: List.generate(3, (index) {
                        List<String> labels = ["x1", "x1.5", "x2"];
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 5),
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.zero,
                              backgroundColor: selectedIndex == index
                                  ? const Color(0xFF7BA3A8)
                                  : const Color(0xFFADC4C6),
                              minimumSize: const Size(40, 30),
                            ),
                            onPressed: () {
                              setState(() {
                                selectedIndex = index;
                              });
                              double zoomLevels = [1.0, 1.5, 2.0][index];
                              _setZoomLevel(zoomLevels);
                            },
                            child: Text(labels[index], style: const TextStyle(color: Colors.white)),
                          ),
                        );
                      }),
                    ),
                  ),
                ),
                Positioned(
                  right: 0,
                  top: 240,
                  bottom: 330,
                  child: RotatedBox(
                    quarterTurns: -1,
                    child: Slider(
                      activeColor: const Color(0xFF589399),
                      value: progress,
                      min: -2.0,
                      max: 2.0,
                      onChanged: (value) async {
                        setState(() {
                          progress = value;
                        });
                        if (_controller != null) {
                          await _controller!.setExposureOffset(value);
                        }
                      },
                    ),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                    ),
                    padding: const EdgeInsets.fromLTRB(64, 27, 64, 35),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(),
                        Container(
                          width: 70,
                          height: 70,
                          decoration: const BoxDecoration(
                            color: Color(0xFF589399),
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Color.fromRGBO(0, 0, 0, 0.8),
                                blurRadius: 2,
                              ),
                            ],
                          ),
                          child: IconButton(
                            onPressed: _takePhoto,
                            icon: const Icon(MyFlutterApp.camera),
                            iconSize: 42,
                            color: Colors.white,
                          ),
                        ),
                        Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            boxShadow: const [
                              BoxShadow(
                                color: Color.fromRGBO(0, 0, 0, 0.3),
                                blurRadius: 1,
                              ),
                            ],
                            border: Border.all(color: const Color(0xFF589399), width: 2),
                          ),
                          child: IconButton(
                            onPressed: _switchCamera,
                            icon: const Icon(MyFlutterApp.arrows_ccw),
                            iconSize: 30,
                            color: const Color(0xFF589399),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
