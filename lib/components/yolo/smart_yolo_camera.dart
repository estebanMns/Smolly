// lib/components/yolo/smart_yolo_camera.dart
// Estrategia: Abre SIEMPRE la cámara nativa primero (garantizado),
// luego intenta cargar YOLO en background para detección.

import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:ultralytics_yolo/ultralytics_yolo.dart';
import 'package:juego_movil/auth/service/yolo_service.dart';
import 'yolo_manual_inference_service.dart';

typedef DetectionCallback = void Function(List<YOLOResult> results);

class SmartYoloCamera extends StatefulWidget {
  final DetectionCallback onResult;
  const SmartYoloCamera({super.key, required this.onResult});

  @override
  State<SmartYoloCamera> createState() => _SmartYoloCameraState();
}

class _SmartYoloCameraState extends State<SmartYoloCamera> {
  CameraController? _cameraController;
  final YoloManualInferenceService _manualInference = YoloManualInferenceService();

  bool _cameraReady = false;
  bool _isUsingFallback = false;
  Timer? _inferenceTimer;
  bool _isProcessingFrame = false;

  @override
  void initState() {
    super.initState();
    _requestPermissionAndInit();
  }

  Future<void> _requestPermissionAndInit() async {
    // ESTO ES CLAVE: Fuerza a iOS a mostrar el popup nativo de permisos
    // gracias a que ya activamos PERMISSION_CAMERA=1 en el Podfile.
    await Permission.camera.request();
    if (!mounted) return;
    
    _checkPlatformAndInit();
  }

  void _checkPlatformAndInit() {
    // Si estamos en un entorno que no es móvil real (web, desktop), usamos fallback
    if (kIsWeb || (!Platform.isAndroid && !Platform.isIOS)) {
      _initFallbackCamera();
    } else {
      // En móvil real, YOLOView es mucho más rápido y estable. (Él pide permisos automáticamente)
      setState(() {
        _isUsingFallback = false;
        _cameraReady = true; 
      });
    }
  }

  Future<void> _initFallbackCamera() async {
    setState(() => _isUsingFallback = true);
    final cameras = await availableCameras();
    if (cameras.isEmpty) return;

    _cameraController = CameraController(cameras[0], ResolutionPreset.medium, enableAudio: false);

    try {
      await _cameraController!.initialize();
      await _manualInference.init();
      if (mounted) {
        setState(() => _cameraReady = true);
        _startInferenceLoop();
      }
    } catch (e) {
      debugPrint('Error en cámara fallback: $e');
    }
  }

  void _startInferenceLoop() {
    _inferenceTimer = Timer.periodic(const Duration(milliseconds: 1500), (timer) async {
      if (_isProcessingFrame || !mounted || _cameraController == null || !_cameraController!.value.isInitialized) return;
      _isProcessingFrame = true;
      try {
        final XFile file = await _cameraController!.takePicture();
        final bytes = await file.readAsBytes();
        final results = await _manualInference.predict(bytes);
        if (mounted) widget.onResult(results);
      } catch (e) {
        debugPrint('Error fallback: $e');
      } finally {
        _isProcessingFrame = false;
      }
    });
  }

  @override
  void dispose() {
    _inferenceTimer?.cancel();
    _cameraController?.dispose();
    _manualInference.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_cameraReady) {
      return const Center(child: CircularProgressIndicator(color: Colors.cyanAccent));
    }

    if (_isUsingFallback) {
      return Stack(
        fit: StackFit.expand,
        children: [
          CameraPreview(_cameraController!),
          const Positioned(
            bottom: 10, right: 10,
            child: Text("MODO EMULADOR", style: TextStyle(color: Colors.white54, fontSize: 8)),
          ),
        ],
      );
    }

    // MODO REAL: YOLOView nativo (Abre la cámara automáticamente)
    return YOLOView(
      modelPath: YoloService.modelPath,
      task: YOLOTask.detect,
      onResult: widget.onResult,
    );
  }
}
