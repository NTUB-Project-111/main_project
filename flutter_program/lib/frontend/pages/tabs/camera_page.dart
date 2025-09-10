import 'dart:io';
import 'package:camera/camera.dart';
import 'package:drw/backend/models/report_model.dart';
import 'package:drw/frontend/pages/report_page.dart';
import 'package:drw/frontend/utility/front_util.dart';
import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:file_picker/file_picker.dart';

class CameraPage extends StatefulWidget {
  final bool isExtra;
  final int? id;
  final String? oktime;
  final String? date;
  final String? woundType;
  const CameraPage(
      {super.key, required this.isExtra, this.id, this.oktime, this.date, this.woundType});

  @override
  State<CameraPage> createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {
  int selectedIndex = 0;
  double progress = 0;
  late List<CameraDescription> _cameras;
  CameraController? _controller;
  bool isCameraInitialized = false;
  int _currentCameraIndex = 0;
  // final ImagePicker _picker = ImagePicker();

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
        debugPrint("設定縮放比例失敗：$e");
      }
    }
  }

  Future<void> _pickPicture(BuildContext context) async {
    try {
      final result = await FilePicker.platform.pickFiles(type: FileType.image);
      if (result != null && result.files.single.path != null) {
        final fileImage = File(result.files.single.path!);
        debugPrint("成功選擇圖片：${fileImage.path}");
        Provider.of<Report>(context, listen: false).setImage(fileImage);
        FrontUtil.showImageDialog(
          context,
          fileImage,
          '確認傷口照片',
          '送出診斷',
          '重新拍攝',
          ReportPage(
            isExtra: widget.isExtra,
            id: widget.id,
            oktime: widget.oktime,
            date: widget.date,
            woundType: widget.woundType,
          ),
        );
      } else {
        debugPrint("使用者取消選圖或路徑為空");
      }
    } catch (e) {
      debugPrint("file_picker 選擇圖片失敗：$e");
    }
  }

  Future<void> _initializeCamera() async {
    try {
      _cameras = await availableCameras();
      if (_cameras.isEmpty) {
        debugPrint("沒有可用相機");
        return;
      }
      await _setupCamera(_currentCameraIndex);
    } catch (e) {
      debugPrint("初始化相機失敗：$e");
    }
  }

  Future<void> _setupCamera(int cameraIndex) async {
    if (_controller != null) {
      await _controller!.dispose();
    }

    final controller = CameraController(
      _cameras[cameraIndex],
      ResolutionPreset.high,
    );

    try {
      await controller.initialize();
      if (!mounted) return;
      setState(() {
        _controller = controller;
        isCameraInitialized = true;
      });
    } catch (e) {
      debugPrint("相機控制器初始化失敗：$e");
    }
  }
  
  @override
  void dispose() {
    try {
      _controller?.dispose();
    } catch (e) {
      debugPrint("CameraController dispose 時發生錯誤: $e");
    }
    super.dispose();
  }


  Future<void> _takePhoto() async {
    if (_controller == null || !_controller!.value.isInitialized) return;
    try {
      final image = await _controller!.takePicture();
      final fileImage = File(image.path);
      if (!mounted) return;
      Provider.of<Report>(context, listen: false).setImage(fileImage);
      FrontUtil.showImageDialog(
        context,
        fileImage,
        '確認傷口照片',
        '送出診斷',
        '重新拍攝',
        ReportPage(
          isExtra: widget.isExtra,
          id: widget.id,
          oktime: widget.oktime,
          date: widget.date,
          woundType: widget.woundType,
        ),
      );
    } catch (e) {
      debugPrint("拍照失敗：$e");
    }
  }

  void _switchCamera() {
    if (_cameras.length > 1) {
      setState(() {
        isCameraInitialized = false;
      });
      _currentCameraIndex = (_currentCameraIndex + 1) % _cameras.length;
      _setupCamera(_currentCameraIndex);
    } else {
      debugPrint("無法切換相機");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: Stack(
              children: [
                (_controller != null && _controller!.value.isInitialized)
                    ? Positioned(
                        top: 0,
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width,
                          height: 735,
                          child: CameraPreview(_controller!),
                        ),
                      )
                    : FrontUtil.loading(),
                Positioned(
                  left: 10,
                  top: 30,
                  child: IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(
                      Icons.arrow_back,
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
                        if (_controller != null && _controller!.value.isInitialized) {
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
                            // onPressed: _pickPicture(),
                            onPressed: () => _pickPicture(context),
                            icon: const Icon(Icons.photo),
                            iconSize: 30,
                            color: const Color(0xFF589399),
                          ),
                        ),
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
                            icon: const Icon(Icons.camera_alt),
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
                            icon: const Icon(Icons.compare_arrows),
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
