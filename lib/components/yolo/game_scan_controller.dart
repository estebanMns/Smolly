// lib/components/yolo/game_scan_controller.dart
// Responsabilidad: Gestionar el estado de la detección durante el juego
// y coordinar la validación de los resultados de la cámara.

import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:ultralytics_yolo/ultralytics_yolo.dart';
import 'detection_validator.dart';

class GameScanController extends GetxController {
  String targetObject;
  final DetectionValidator _validator = DetectionValidator();

  // Estados observables
  final isTargetFound = false.obs;
  final currentConfidence = 0.0.obs;
  
  // Detección "bloqueada" una vez que se encuentra el objeto
  final isScanningLocked = false.obs;

  GameScanController({required this.targetObject});

  void updateTargetObject(String newTarget) {
    targetObject = newTarget;
    resetScan();
  }

  /// Procesa los resultados obtenidos de YOLOView.
  void onDetectionResults(List<YOLOResult> detections) {
    if (isScanningLocked.value) return;

    final bestResult = _validator.getBestTargetDetection(detections, targetObject);

    if (bestResult != null) {
      currentConfidence.value = bestResult.confidence;
      isTargetFound.value = true;
      
      // Bloqueamos para dar feedback de éxito
      isScanningLocked.value = true;
      
      if (kDebugMode) {
        print("GameScanController: Objeto encontrado: $targetObject (${bestResult.confidence})");
      }
    } else {
      currentConfidence.value = 0.0;
      isTargetFound.value = false;
    }
  }

  /// Reinicia el escaneo (por si el jugador falla o cambia algo)
  void resetScan() {
    isTargetFound.value = false;
    isScanningLocked.value = false;
    currentConfidence.value = 0.0;
  }
}
