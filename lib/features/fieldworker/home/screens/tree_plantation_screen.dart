import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:treelove/core/utils/logger.dart';

import '../../../../core/config/route/app_route.dart';
import '../../../../core/config/themes/app_color.dart';
import '../../../../core/config/themes/app_fonts.dart';

class PlantTreeScreen extends StatefulWidget {
  static const route ='/PlantTreeScreen';
  const PlantTreeScreen({super.key});

  @override
  State<PlantTreeScreen> createState() => _PlantTreeScreenState();
}

class _PlantTreeScreenState extends State<PlantTreeScreen> {
  String plantationType = 'Fresh';
  bool maintenanceRequired = true;
  final TextEditingController latitudeController = TextEditingController();
  final TextEditingController longitudeController = TextEditingController();
  final TextEditingController areaController = TextEditingController();
  DateTime plantationDate = DateTime(2023, 5, 6);

  final  List<String> _areaList = const [
    'Thane',
     'Kurla'
  ];


  @override
  void initState() {
    plantationDate = DateTime.now();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFF0E5D57),
        title: const Text('Plant a tree', style: TextStyle(color: Colors.white)),
        leading: IconButton(
          icon:  Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => AppRoute.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
             height: 10.h,
            ),
            const Text('Plantation type'),
            const SizedBox(height: 8),
            Row(
              children: [
                _buildToggleButton('Fresh'),
                const SizedBox(width: 12),
                _buildToggleButton('Transplant'),
              ],
            ),
            const SizedBox(height: 20),
            const Text('Location'),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: latitudeController,
                    decoration: const InputDecoration(
                      labelText: 'Latitude',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: TextField(
                    controller: longitudeController,
                    decoration: const InputDecoration(
                      labelText: 'Longitude',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Container(
                  padding: EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(2),
                    border: Border.all(
                      color: Colors.grey, // Change to your desired color
                      width: 1.5,
                    ),
                  ),
                  child:  IconButton(
                    onPressed: () {
                      // TODO: Add location picker logic
                    },
                    icon:  Icon(Icons.my_location,size: 26.r),
                  ),
                )
              ],
            ),
            const SizedBox(height: 20),
            const Text('Area'),
            const SizedBox(height: 8),
            CustomDropdown<String>.search(
              hintText: 'Select Area',
              items: _areaList,
              decoration:CustomDropdownDecoration(
                closedFillColor: Colors.white, // Optional: background color
                closedBorder: Border.all(
                  color: Colors.grey, // Change to your desired color
                  width: 1.5,
                ),
                closedBorderRadius: BorderRadius.circular(8), // Optional: rounded corners
                hintStyle: const TextStyle(
                  color: Colors.black54,
                  fontSize: 14,
                ),
              ) ,
              // initialItem: _areaList[0],
              onChanged: (value) {
                debugLog('changing value to: $value');
              },
            ),
            const SizedBox(height: 20),
            const Text('Plantation date'),
            const SizedBox(height: 8),
            TextField(
              readOnly: true,
              decoration: InputDecoration(
                hintText: DateFormat('dd MMM yyyy').format(plantationDate),
                border: const OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            const Text('Take photo'),
            const SizedBox(height: 8),
            GestureDetector(
              onTap: () {
                // TODO: Add image picker
              },
              child: Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey,  width: 1.5,),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Center(
                  child: Icon(Icons.camera_alt_outlined, size: 28),
                ),
              ),
            ),
            const SizedBox(height: 50),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF004D40),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(28),
                  ),
                ),
                onPressed: () {
                  // AppRoute.goToNextPage(context: context, screen: PasswordLoginScreen.route, arguments: {});
                },
                child:  Text(
                    'Submit',
                    style: AppFonts.regular

                ),
              ),
            ),
            /*
            const Text('Maintenance required'),
            const SizedBox(height: 8),
            Row(
              children: [
                _buildMaintenanceButton(true),
                const SizedBox(width: 12),
                _buildMaintenanceButton(false),
              ],
            ),

             */
          ],
        ),
      ),
    );
  }

  /*
  Widget _buildToggleButton(String type) {
    final bool isSelected = plantationType == type;
    return Expanded(
      child: OutlinedButton(
        style: OutlinedButton.styleFrom(
          backgroundColor: isSelected ? const Color(0xFFE6F0ED) : Colors.white,
          side: BorderSide(color: isSelected ? const Color(0xFF0E5D57) : Colors.grey),
        ),
        onPressed: () {
          setState(() => plantationType = type);
        },
        child: Text(
          type,
          style: TextStyle(
            color: isSelected ? const Color(0xFF0E5D57) : Colors.black,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

   */

  Widget _buildToggleButton(String type) {
    final bool isSelected = plantationType == type;

    return Expanded(
      child: OutlinedButton(
        style: OutlinedButton.styleFrom(
          backgroundColor: isSelected ? const Color(0xFFE6F0ED) : Colors.white,
          side: BorderSide(
            color: isSelected ? const Color(0xFF0E5D57) : Colors.grey,
            width: 1.5
          ),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.zero, // Rectangle shape
          ),
          padding: const EdgeInsets.symmetric(vertical: 16), // Optional: better tap target
        ),
        onPressed: () {
          setState(() => plantationType = type);
        },
        child: Text(
          type,
          style: TextStyle(
            color: isSelected ? const Color(0xFF0E5D57) : Colors.black,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }




  Widget _buildMaintenanceButton(bool value) {
    final bool isSelected = maintenanceRequired == value;
    return Expanded(
      child: OutlinedButton(
        style: OutlinedButton.styleFrom(
          backgroundColor: isSelected ? const Color(0xFFE6F0ED) : Colors.white,
          side: BorderSide(color: isSelected ? const Color(0xFF0E5D57) : Colors.grey),
        ),
        onPressed: () {
          setState(() => maintenanceRequired = value);
        },
        child: Text(
          value ? 'Yes' : 'No',
          style: TextStyle(
            color: isSelected ? const Color(0xFF0E5D57) : Colors.black,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
