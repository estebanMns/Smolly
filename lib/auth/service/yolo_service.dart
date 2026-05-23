import 'package:ultralytics_yolo/ultralytics_yolo.dart';

/// Responsabilidad: Configuración de rutas y parámetros del modelo YOLO.
/// Centraliza los parámetros para facilitar el mantenimiento.
class YoloService {
  // Ruta del modelo oficial (descarga automático .tflite o .mlpackage según la plataforma)
  static const String modelPath = 'yolo11n';
  
  // Tarea que realiza el modelo
  final YOLOTask task = YOLOTask.detect;

  // Umbral de confianza por defecto
  final double defaultConfidence = 0.25;

  Future<void> logConfiguration() async {
    print("YoloService: Modelo configurado en $modelPath");
  }
}
