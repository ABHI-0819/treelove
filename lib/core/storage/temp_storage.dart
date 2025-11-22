// File: lib/services/hive_box_manager.dart

import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';

/// A generic manager for any Hive box, providing standard CRUD operations.
/// 
/// T is the type of data stored in the box (e.g., String, int, Map<String, dynamic>).
class HiveBoxManager<T extends Map<dynamic, dynamic>> {
  final String boxName;
  Box<T>? _box;

  HiveBoxManager(this.boxName);

  /// Initializes and opens the Hive box. Must be called once before usage.
  Future<void> init() async {
    // If the box is already open, use the existing instance.
    if (Hive.isBoxOpen(boxName)) {
      _box = Hive.box<T>(boxName);
    } else {
      // Otherwise, open the box.
      _box = await Hive.openBox<T>(boxName);
    }
  }

  // --- CRUD Operations ---

  /// Puts a value into the box with a specific key (creates or updates).
  Future<void> put(String key, T value) async {
    if (_box == null) {
      throw Exception("Hive Box not initialized. Call init() first.");
    }
    await _box!.put(key, value);
  }

  /// Retrieves a value by its key.
  T? get(String key) {
    return _box?.get(key);
  }

  /// Deletes a value by its key.
  Future<void> delete(String key) async {
    await _box?.delete(key);
  }

  /// Deletes all key-value pairs in the box.
  Future<void> clear() async {
    await _box?.clear();
  }

  // --- Utility Accessors ---

  /// Gets all keys in the box.
  Iterable<dynamic> get keys => _box?.keys ?? [];

  /// Gets all values in the box.
  Iterable<T> get values => _box?.values ?? [];

  /// Returns a ValueListenable for real-time UI updates.
  ValueListenable<Box<T>> listenable() {
    if (_box == null) {
      throw Exception("Hive Box not initialized. Call init() first.");
    }
    return _box!.listenable();
  }

  /// Closes the box.
  Future<void> close() async {
    await _box?.close();
  }
}