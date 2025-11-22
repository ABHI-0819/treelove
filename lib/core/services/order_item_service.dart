// File: lib/managers/order_item_manager.dart

/*

// Define the type alias for clarity
import 'package:treelove/core/utils/logger.dart';

import '../storage/temp_storage.dart';

typedef OrderItemMap = Map<String, dynamic>;

/// Manages the temporary storage of order items using a Map<String, dynamic>
/// to avoid custom Hive adapters.
class OrderItemMapManager extends HiveBoxManager<OrderItemMap> {

  // The unique name for this specific box.
  static const String _boxName = 'current_order_items_map_box';

  // Singleton instance for easy global access
  static final OrderItemMapManager _instance = OrderItemMapManager._internal();

  factory OrderItemMapManager() {
    return _instance;
  }

  OrderItemMapManager._internal() : super(_boxName);

  // --- Public Business Logic Methods ---

  // /// Retrieves all order items as a list of maps.
  // List<OrderItemMap> getAllOrderItems() {
  //   return values.toList();
  // }

  // Inside the OrderItemMapManager class...

  /// Retrieves all order items as a list of maps, ensuring type safety.
  List<OrderItemMap> getAllOrderItems() {
    // Use map() and Map.from() to safely cast each item
    return values
        .map((item) => Map<String, dynamic>.from(item))
        .toList();
  }

  /// Adds a new item or updates the count if the treeId already exists.
  ///
  /// The treeId is used as the key in the Hive box.
  Future<void> addItem({
    required String treeId,
    required double latitude,
    required double longitude,
    required int count,
  }) async {
    final existingMap = get(treeId);

    if (existingMap != null) {
      // Item exists: Update the count
      existingMap['count'] = (existingMap['count'] as int) + count;
      await put(treeId, existingMap);
    } else {
      // Item does not exist: Add the new map
      final newMap = {
        'treeId': treeId,
        'latitude': latitude,
        'longitude': longitude,
        'count': count,
      };
      await put(treeId, newMap);
    }
  }



  // Inside the OrderItemMapManager class...

  /// Finds the count of the last item stored in the box.
  ///
  /// NOTE: Since Hive does not guarantee insertion order by default,
  /// this returns the count of the last item in the list of values.
  int getLastItemCount() {
    final allItems = getAllOrderItems(); // Use the new safe getter

    if (allItems.isEmpty) {
      return 1;
    }

    // Now 'lastItemMap' is guaranteed to be Map<String, dynamic>
    final lastItemMap = allItems.last;

    return lastItemMap['count'];
  }

  /// Removes an item completely based on its treeId (the box key).
  Future<void> removeItem(String treeId) async {
    await delete(treeId);
  }
}

 */
// File: lib/managers/order_item_manager.dart



// 1. Define the type alias for clarity (optional, but good)
import 'package:treelove/core/utils/logger.dart';

import '../storage/temp_storage.dart';

typedef OrderItemMap = Map<String, dynamic>;
typedef HiveRawMap = Map<dynamic, dynamic>; // Define the raw type

// 2. Instantiate base class with the raw type
class OrderItemMapManager extends HiveBoxManager<HiveRawMap> { // <--- CHANGE HERE

  static const String _boxName = 'current_order_items_map_box';
  static final OrderItemMapManager _instance = OrderItemMapManager._internal();

  factory OrderItemMapManager() { return _instance; }
  OrderItemMapManager._internal() : super(_boxName);

  // --- OVERRIDE GETTER FOR SAFETY ---

  /// Safely retrieves a single item and converts it to Map<String, dynamic>.
  OrderItemMap? getSafe(String key) {
    final rawMap = super.get(key); // Get the raw Map<dynamic, dynamic>
    if (rawMap == null) return null;
    return Map<String, dynamic>.from(rawMap); // SAFE CONVERSION
  }

  // --- OVERRIDE VALUES GETTER FOR SAFETY ---

  /// Retrieves all values and converts them to a safe Iterable<Map<String, dynamic>>.
  Iterable<OrderItemMap> get safeValues {
    // Iterate over the raw maps and safely convert each one
    return super.values.map((rawMap) => Map<String, dynamic>.from(rawMap));
  }

  // --- Update Business Logic Methods ---

  // Update getAllOrderItems to use the safe getter
  List<OrderItemMap> getAllOrderItems() {
    return safeValues.toList(); // Use the safe iterable
  }

  // Update addItem to use the safe getter
  Future<void> addItem({
    required String treeId,
    required double latitude,
    required double longitude,
    required int count,
  }) async {
    final existingMap = getSafe(treeId);

    // Define a variable to hold the final map to be stored
    Map<String, dynamic> mapToSave;

    if (existingMap != null) {
      // 1. Logic for updating an existing item (using safe retrieval)
      final currentCount = existingMap['count'] as int? ?? 0;
      existingMap['count'] = currentCount + count;

      // Assign the updated map to mapToSave
      mapToSave = existingMap;
    } else {
      // 2. Logic for adding a new item
      mapToSave = {
        'treeId': treeId,
        'latitude': latitude,
        'longitude': longitude,
        'count': count,
      };
    }

    // 3. CRITICAL STEP: Convert the clean Map<String, dynamic>
    //    to the raw Map<dynamic, dynamic> type required by the base Hive box.
    final mapForHiveStorage = Map<dynamic, dynamic>.from(mapToSave);

    // 4. Call the base put method with the correctly typed map
    await put(treeId, mapForHiveStorage);
  }

  // Update getLastItemCount to use the safe list
  int getLastItemCount() {
    final allItems = getAllOrderItems(); // Use the safe list
    debugLog(allItems.toString(),name:"Local data count");
    if (allItems.isEmpty) { return 1; }

    final lastItemMap = allItems.last;

    return lastItemMap['count']??1;
  }
}