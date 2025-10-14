import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:treelove/common/bloc/api_event.dart';
import 'package:treelove/common/bloc/satellite_bloc.dart';
import 'package:treelove/common/models/response.mode.dart';
import 'package:treelove/common/repositories/monitor_repository.dart';
import 'package:treelove/core/network/api_connection.dart';

import '../../core/config/route/app_route.dart';
import '../../core/config/themes/app_color.dart';

import '../../core/widgets/image_viewe.dart';
/*
class SatelliteMonitoringResultScreen extends StatefulWidget {
  static const route ='/satellite';
  final int? index;

  const SatelliteMonitoringResultScreen({super.key, this.index});

  // Dummy tree data — you can move this to a separate file later
  static final List<Map<String, dynamic>> _dummyTrees = [
    {
      "thumbnail":
      "https://iili.io/KYXeYyN.md.jpg",
      "tree_species": {
        "id": "T123",
        "local_name": "Neem Tree",
        "image":
        "https://iili.io/KYXeYyN.md.jpg",
        "scientific_name": "Azadirachta indica"
      },
      "monitoring_status": "Healthy",
      "monitoring_status_color": "0xFF4CAF50",
      "monitoring_status_days": 15,
      "canopy_size": 25,
      "canopy_size_unit": "m²",
      "tree_health": "Good",
      "tree_growth": "Stable",
      "confidence": 85,
      "ndvi": 0.78,
      "vari": -0.5,
      "gli": 0.72,
      "exg": 0.81,
      "tgi": 0.59,
      "model_type": "Center Mask"
    },
    {
      "thumbnail":
      "https://iili.io/KYXeYyN.md.jpg",
      "tree_species": {
        "id": "T456",
        "local_name": "Neem Tree",
        "image":
        "https://iili.io/KYXeYyN.md.jpg",
        "scientific_name": "Azadirachta indica"
      },
      "monitoring_status": "Warning",
      "monitoring_status_color": "0xFFFF9800",
      "monitoring_status_days": 3,
      "canopy_size": 18,
      "canopy_size_unit": "m²",
      "tree_health": "Fair",
      "tree_growth": "Declining",
      "confidence": 85,
      "ndvi": 0.42,
      "vari": 0.1,
      "gli": 0.55,
      "exg": 0.48,
      "tgi": 0.32,
      "model_type": "Center Mask"
    },
    {
      "thumbnail":
      "https://www.imghippo.com/i/Ve7759jY.jpg",
      "tree_species": {
        "id": "T789",
        "local_name": "Peepal Tree",
        "image":
        "https://www.imghippo.com/i/Ve7759jY.jpg",
        "scientific_name": "Ficus religiosa"
      },
      "monitoring_status": "Critical",
      "monitoring_status_color": "0xFFF44336",
      "monitoring_status_days": 1,
      "canopy_size": 12,
      "canopy_size_unit": "m²",
      "tree_health": "Poor",
      "tree_growth": "Rapid Decline",
      "confidence": 76,
      "ndvi": 0.25,
      "vari": -0.8,
      "gli": 0.3,
      "exg": 0.2,
      "tgi": 0.1,
      "model_type": "Emergency Model"
    },
  ];

  @override
  State<SatelliteMonitoringResultScreen> createState() => _SatelliteMonitoringResultScreenState();
}

class _SatelliteMonitoringResultScreenState extends State<SatelliteMonitoringResultScreen> {

  late SatelliteBloc satelliteBloc;

  @override
  void initState() {
    satelliteBloc =SatelliteBloc(
      MonitorRepository(api: ApiConnection())
    );
    satelliteBloc.add(ApiFetch(id: '666e830a-40fa-4609-bce2-c13e1ac37d09'));
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    satelliteBloc.close();
    // TODO: implement dispose
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    // Validate index
    if (widget.index != null && (widget.index! < 0 || widget.index! >= SatelliteMonitoringResultScreen._dummyTrees.length)) {
      return Scaffold(
        body: Center(
          child: Text(
            "Invalid tree index: ${widget.index}",
            style: const TextStyle(fontSize: 18, color: Colors.red),
          ),
        ),
      );
    }

    final int actualIndex = widget.index != null ? widget.index! : 0;
    final selectedTreeJson = SatelliteMonitoringResultScreen._dummyTrees[actualIndex];
    final tree = TreeDetails.fromJson(selectedTreeJson);

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text("Satellite Monitoring"),
        backgroundColor: AppColor.background,
        centerTitle: true,
        elevation: 0.5,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppColor.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: CustomScrollView(
        slivers: [
          // Content
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            tree.species.localName,
                            style: const TextStyle(
                              color: AppColor.black,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            tree.species.scientificName,
                            style: TextStyle(
                              color: AppColor.secondary,
                              fontSize: 14,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.green
                              .withOpacity(0.9), // Replace AppColor.primary if not defined
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.verified,
                                size: 14, color: Colors.white),
                            const SizedBox(width: 4),
                            Text(
                              "Confidence: ${tree.confidence}%",
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  _buildQuickStats(tree, context),
                  const SizedBox(height: 24),
                  CompactPlantAnalysisWidget(context:context),
                  const SizedBox(height: 24),
                  _buildTreeVitals(tree, context),
                  const SizedBox(height: 24),
                  _buildAdditionalInfo(tree, context),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// --------------------
  /// Widget builders
  /// --------------------
  Widget _buildStatCard(
      String title, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: color, size: 16),
              const SizedBox(width: 4),
              Flexible(
                child: Text(
                  value,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[700],
              fontWeight: FontWeight.w500,
            ),
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildQuickStats(TreeDetails tree, BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _buildStatCard(
            "Canopy Coverage",
            "${tree.canopySize} ${tree.canopySizeUnit}",
            Icons.filter_center_focus,
            Colors.blue,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _buildStatCard(
            "Overall Health",
            tree.treeHealth,
            Icons.favorite,
            Colors.red,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _buildStatCard(
            "Growth Rate",
            tree.treeGrowth,
            Icons.trending_up,
            Colors.green,
          ),
        ),
      ],
    );
  }

  Widget _buildTreeVitals(TreeDetails tree, BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.analytics, color: Colors.green[600], size: 24),
            const SizedBox(width: 8),
            const Text(
              "Tree Vitals",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          "Scientific measurements of tree health and growth",
          style: TextStyle(color: Colors.grey[600], fontSize: 12),
        ),
        const SizedBox(height: 16),
        _buildVitalCard("Vegetation Health (NDVI)", tree.ndvi,
            "Measures overall plant health and density", Icons.local_florist, Colors.green, "NDVI"),
        const SizedBox(height: 12),
        _buildVitalCard("Green Coverage (GLI)", tree.gli,
            "Shows how green and lush the tree appears", Icons.nature, Colors.lightGreen, "GLI"),
        const SizedBox(height: 12),
        _buildVitalCard("Growth Activity (ExG)", tree.exg,
            "Indicates active growing areas", Icons.trending_up, Colors.teal, "ExG"),
        const SizedBox(height: 12),
        _buildVitalCard("Leaf Condition (VARI)", tree.vari,
            "Evaluates leaf color and condition", Icons.eco, Colors.amber, "VARI"),
        const SizedBox(height: 12),
        _buildVitalCard("Chlorophyll Level (TGI)", tree.tgi,
            "Measures chlorophyll content in leaves", Icons.opacity, Colors.indigo, "TGI"),
      ],
    );
  }

  Widget _buildVitalCard(
      String title,
      double value,
      String description,
      IconData icon,
      Color color,
      String indexType,
      ) {
    final interpretation = _getIndexInterpretation(indexType, value);

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200, width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Section
          Row(
            children: [
              // Icon Container
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: color, size: 22),
              ),
              const SizedBox(width: 16),

              // Title and Description
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      description,
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 13,
                        height: 1.2,
                      ),
                    ),
                  ],
                ),
              ),

              // Value and Status
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    value.toStringAsFixed(2),
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Container(
                    padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: interpretation['color'].withOpacity(0.12),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      interpretation['status'],
                      style: TextStyle(
                        color: interpretation['color'],
                        fontWeight: FontWeight.w600,
                        fontSize: 11,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 20),

          // Range Information
          Text(
            "Range: ${_getIndexRange(indexType)}",
            style: TextStyle(
              color: Colors.grey[500],
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),

          const SizedBox(height: 12),

          // Progress Bar
          LayoutBuilder(
            builder: (context, constraints) {
              final barWidth = constraints.maxWidth;
              final normalized = ((value + 1) / 2).clamp(0.0, 1.0);

              return Column(
                children: [
                  Stack(
                    alignment: Alignment.centerLeft,
                    children: [
                      // Background gradient bar
                      Container(
                        width: barWidth,
                        height: 8,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4),
                          gradient: LinearGradient(
                            colors: [
                              Colors.red.shade400,
                              Colors.orange.shade400,
                              Colors.green.shade400,
                            ],
                          ),
                        ),
                      ),

                      // Zero line indicator
                      Positioned(
                        left: barWidth / 2 - 1,
                        child: Container(
                          width: 2,
                          height: 12,
                          decoration: BoxDecoration(
                            color: Colors.black54,
                            borderRadius: BorderRadius.circular(1),
                          ),
                        ),
                      ),

                      // Value marker
                      Positioned(
                        left: (normalized * barWidth - 6).clamp(0.0, barWidth - 12),
                        child: Container(
                          width: 12,
                          height: 12,
                          decoration: BoxDecoration(
                            color: interpretation['color'],
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 2),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.2),
                                blurRadius: 3,
                                offset: const Offset(0, 1),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 8),

                  // Scale labels
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "-1.0",
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.grey[500],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        "0.0",
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.grey[600],
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        "+1.0",
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.grey[500],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildAdditionalInfo(TreeDetails tree, BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Additional Information",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          _buildInfoRow("Tree ID", tree.species.id, Icons.tag),
          _buildInfoRow("Analysis Model", tree.modelType, Icons.psychology),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Colors.grey[600]),
          const SizedBox(width: 12),
          Text(label, style: TextStyle(color: Colors.grey[600], fontSize: 14)),
          const Spacer(),
          Text(value,
              style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 14)),
        ],
      ),
    );
  }

  /// --------------------
  /// Helper Methods
  /// --------------------
  Map<String, dynamic> _getIndexInterpretation(String indexType, double value) {
    switch (indexType) {
      case 'NDVI':
        if (value > 0.7) return {'status': 'Excellent', 'color': Colors.green};
        if (value > 0.5) return {'status': 'Good', 'color': Colors.lightGreen};
        if (value > 0.3) return {'status': 'Moderate', 'color': Colors.orange};
        return {'status': 'Poor', 'color': Colors.red};

      case 'VARI':
      case 'GLI':
        if (value > 0.6) return {'status': 'Excellent', 'color': Colors.green};
        if (value > 0.4) return {'status': 'Good', 'color': Colors.lightGreen};
        if (value > 0.2) return {'status': 'Moderate', 'color': Colors.orange};
        return {'status': 'Poor', 'color': Colors.red};

      case 'ExG':
        if (value > 0.7) return {'status': 'Excellent', 'color': Colors.green};
        if (value > 0.5) return {'status': 'Good', 'color': Colors.lightGreen};
        if (value > 0.3) return {'status': 'Moderate', 'color': Colors.orange};
        return {'status': 'Poor', 'color': Colors.red};

      case 'TGI':
        if (value > 0.5) return {'status': 'Excellent', 'color': Colors.green};
        if (value > 0.3) return {'status': 'Good', 'color': Colors.lightGreen};
        if (value > 0.1) return {'status': 'Moderate', 'color': Colors.orange};
        return {'status': 'Poor', 'color': Colors.red};

      default:
        return {'status': 'Unknown', 'color': Colors.grey};
    }
  }

  String _getIndexRange(String indexType) {
    return '-1.0 to +1.0';
  }
}

class TreeSpecies {
  final String id;
  final String localName;
  final String scientificName;
  final String image;

  TreeSpecies({
    required this.id,
    required this.localName,
    required this.scientificName,
    required this.image,
  });

  factory TreeSpecies.fromJson(Map<String, dynamic> json) {
    return TreeSpecies(
      id: json['id'] ?? "",
      localName: json['local_name'] ?? "",
      scientificName: json['scientific_name'] ?? "",
      image: (json['image'] as String?)?.trim() ?? "",
    );
  }
}

class TreeDetails {
  final String thumbnail;
  final TreeSpecies species;

  final String monitoringStatus;
  final int monitoringStatusColor;
  final int monitoringStatusDays;

  final double canopySize;
  final String canopySizeUnit;

  final String treeHealth;
  final String treeGrowth;
  final int confidence;

  final double ndvi;
  final double vari;
  final double gli;
  final double exg;
  final double tgi;

  final String modelType;

  TreeDetails({
    required this.thumbnail,
    required this.species,
    required this.monitoringStatus,
    required this.monitoringStatusColor,
    required this.monitoringStatusDays,
    required this.canopySize,
    required this.canopySizeUnit,
    required this.treeHealth,
    required this.treeGrowth,
    required this.confidence,
    required this.ndvi,
    required this.vari,
    required this.gli,
    required this.exg,
    required this.tgi,
    required this.modelType,
  });

  factory TreeDetails.fromJson(Map<String, dynamic> json) {
    return TreeDetails(
      thumbnail: (json['thumbnail'] ) ?? "",
      species: TreeSpecies.fromJson(json['tree_species'] ?? {}),
      monitoringStatus: json['monitoring_status'] ?? "",
      monitoringStatusColor: int.tryParse(json['monitoring_status_color']?.toString().trim() ?? "0xFF9E9E9E") ?? 0xFF9E9E9E,
      monitoringStatusDays: json['monitoring_status_days'] ?? 0,
      canopySize: (json['canopy_size'] ?? 0).toDouble(),
      canopySizeUnit: json['canopy_size_unit'] ?? "",
      treeHealth: json['tree_health'] ?? "",
      treeGrowth: json['tree_growth'] ?? "",
      confidence: json['confidence'] ?? 0,
      ndvi: (json['ndvi'] ?? 0).toDouble(),
      vari: (json['vari'] ?? 0).toDouble(),
      gli: (json['gli'] ?? 0).toDouble(),
      exg: (json['exg'] ?? 0).toDouble(),
      tgi: (json['tgi'] ?? 0).toDouble(),
      modelType: json['model_type'] ?? "",
    );
  }
}

class AnalysisStep {
  final int id;
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final Color bgColor;

  AnalysisStep({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.bgColor,
  });
}

class CompactPlantAnalysisWidget extends StatelessWidget {
  BuildContext context;
   CompactPlantAnalysisWidget({Key? key,required this.context}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<AnalysisStep> steps = [
      AnalysisStep(
        id: 1,
        title: "Identification",
        subtitle: "Original Image",
        icon: Icons.camera_alt_outlined,
        color: AppColor.primary,
        bgColor: AppColor.grey,
      ),
      AnalysisStep(
        id: 2,
        title: "Cropped Image",
        subtitle: "Processed Region",
        icon: Icons.crop,
        color: AppColor.secondary,
        bgColor: AppColor.grey,
      ),
      AnalysisStep(
        id: 3,
        title: "Detection",
        subtitle: "Analysis Results",
        icon: Icons.search,
        color: AppColor.accent,
        bgColor: AppColor.grey,
      ),
      AnalysisStep(
        id: 4,
        title: "NDVI",
        subtitle: "Vegetation Index",
        icon: Icons.analytics_outlined,
        color: AppColor.success,
        bgColor: AppColor.grey,
      ),
    ];

    return Column(
      children: [
        Row(
          children: [
            Icon(Icons.settings, color: Colors.green[600], size: 24),
            const SizedBox(width: 8),
            const Text(
              "Processing Steps",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          "From capture to analysis,track each stage of processing.",
          style: TextStyle(color: Colors.grey[600], fontSize: 12),
        ),
        const SizedBox(height: 20),
        GridView.builder(
          padding: EdgeInsets.zero, // 🔑
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 0.9,
          ),
          itemCount: steps.length,
          itemBuilder: (context, index) {
            return _buildCompactStepCard(context,steps[index]);
          },
        )
      ],
    );
  }

  Widget _buildCompactStepCard(context,AnalysisStep step) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: step.bgColor,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColor.divider),
      ),
      child: Column(
        spacing: 5.h,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header Row
          Row(
            children: [
              Container(
                width: 30,
                height: 30,
                decoration: BoxDecoration(
                  color: step.color,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Center(
                  child: Text(
                    '${step.id}',
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: AppColor.white,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 6),
              Column(
               mainAxisAlignment: MainAxisAlignment.start,
               crossAxisAlignment: CrossAxisAlignment.start,
               spacing: 1,
               children: [
                 Text(
                   step.title,
                   style: TextStyle(
                     fontSize: 13,
                     fontWeight: FontWeight.w600,
                     color: AppColor.textPrimary,
                   ),
                   maxLines: 1,
                   overflow: TextOverflow.ellipsis,
                 ),
                 //Subtitle
                 Text(
                   step.subtitle,
                   style: TextStyle(
                     fontSize: 11,
                     color: AppColor.textSecondary,
                   ),
                   maxLines: 1,
                   overflow: TextOverflow.ellipsis,
                 ),
               ],
             )
            ],
          ),
          // Compact Image Preview
          Expanded(
            child: Expanded(
              child: InkWell(
                onTap: (){
                  AppRoute.goToNextPage(context: context, screen: FullScreenImageViewer.route, arguments: {
                    'imagePath':'https://iili.io/KYXeYyN.md.jpg',
                    'heroTag':step.id.toString()
                  });
                },
              child:   Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: AppColor.white,
                borderRadius: BorderRadius.circular(4),
                border: Border.all(
                  color: AppColor.border,
                  style: BorderStyle.solid,
                ),
              ),
              child: Center(
                child: Image.network(
                  "https://iili.io/KYXeYyN.md.jpg", // your image path
                  // width: 24,
                  // height: 24,
                  fit: BoxFit.contain,
                ),
              ),
            ),
                )
            ),

          ),
        ],
      ),
    );
  }
}

 */
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/api_state.dart';
import '../models/satellite_monitor_response.dart';

/*
class SatelliteMonitoringResultScreen extends StatefulWidget {
  static const route = '/satellite';
  final String monitorId;

  const SatelliteMonitoringResultScreen({
    super.key,
    required this.monitorId,
  });

  @override
  State<SatelliteMonitoringResultScreen> createState() =>
      _SatelliteMonitoringResultScreenState();
}

class _SatelliteMonitoringResultScreenState
    extends State<SatelliteMonitoringResultScreen> {
  late SatelliteBloc satelliteBloc;

  @override
  void initState() {
    satelliteBloc = SatelliteBloc(MonitorRepository(api: ApiConnection()));
    satelliteBloc.add(ApiFetch(id: widget.monitorId));
    super.initState();
  }

  @override
  void dispose() {
    satelliteBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text("Satellite Monitoring"),
        backgroundColor: AppColor.background,
        centerTitle: true,
        elevation: 0.5,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppColor.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: BlocBuilder<SatelliteBloc, ApiState<SatelliteMonitorResponse, ResponseModel>>(
        bloc: satelliteBloc,
        builder: (context, state) {
          if (state is ApiLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is ApiSuccess<SatelliteMonitorResponse, ResponseModel>) {
            final dataList = state.data.data; // List<SatelliteMonitorData>

            if (dataList.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(Icons.info, color: Colors.grey, size: 48),
                    SizedBox(height: 16),
                    Text("No satellite monitoring data available."),
                  ],
                ),
              );
            }

            final satelliteData = dataList.first;

            // Map to TreeDetails
            final tree = _mapToTreeDetails(satelliteData);

            return CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  tree.species.localName,
                                  style: const TextStyle(
                                    color: AppColor.black,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  tree.species.scientificName,
                                  style: TextStyle(
                                    color: AppColor.secondary,
                                    fontSize: 14,
                                    fontStyle: FontStyle.italic,
                                  ),
                                ),
                              ],
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: Colors.green.withOpacity(0.9),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(Icons.verified, size: 14, color: Colors.white),
                                  const SizedBox(width: 4),
                                  Text(
                                    "Confidence: ${tree.confidence}%",
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),
                        _buildQuickStats(tree, context),
                        const SizedBox(height: 24),
                        // ✅ Use thumbnail as single image preview (no media list)
                        _buildThumbnailPreview(satelliteData.thumbnail),
                        const SizedBox(height: 24),
                        _buildTreeVitals(tree, context),
                        const SizedBox(height: 24),
                        _buildAdditionalInfo(tree, context),
                      ],
                    ),
                  ),
                ),
              ],
            );
          } else if (state is ApiFailure<SatelliteMonitorResponse,ResponseModel> || state is TokenExpired<SatelliteMonitorResponse,ResponseModel>) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error, color: Colors.red, size: 48),
                  const SizedBox(height: 16),
                  Text(
                    "Failed to load tree data.",
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.red, fontSize: 16),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () {
                      satelliteBloc.add(ApiFetch(id: widget.monitorId));
                    },
                    child: const Text("Retry"),
                  )
                ],
              ),
            );
          } else {
            return const Center(child: Text("Unknown state"));
          }
        },
      ),
    );
  }

  TreeDetails _mapToTreeDetails(SatelliteMonitorData data) {
    int parseColor(String colorStr) {
      final clean = colorStr.trim();
      if (clean.startsWith('0x')) {
        return int.tryParse(clean) ?? 0xFF9E9E9E;
      } else {
        return int.tryParse('0x$clean') ?? 0xFF9E9E9E;
      }
    }

    // Handle thumbnail: could be String or null
    String thumbnail = "";
    if (data.thumbnail is String) {
      thumbnail = (data.thumbnail as String).trim();
    }

    return TreeDetails(
      thumbnail: thumbnail,
      species: TreeSpecies(
        id: data.treeSpecies.id,
        localName: data.treeSpecies.localName,
        scientificName: data.treeSpecies.scientificName,
        image: data.treeSpecies.image.trim(),
      ),
      monitoringStatus: data.monitoringStatus,
      monitoringStatusColor: parseColor(data.monitoringStatusColor),
      monitoringStatusDays: data.monitoringStatusDays,
      canopySize: data.canopySize,
      canopySizeUnit: data.canopySizeUnit,
      treeHealth: data.treeHealth,
      treeGrowth: data.treeGrowth,
      confidence: (data.confidence * 100).toInt(), // Convert 0.85 → 85%
      ndvi: data.ndvi,
      vari: data.vari,
      gli: data.gli,
      exg: data.exg,
      tgi: data.tgi,
      modelType: data.modelType,
    );
  }

  // ✅ NEW: Simple thumbnail preview (replaces CompactPlantAnalysisWidget)
  Widget _buildThumbnailPreview(dynamic thumbnail) {
    if (thumbnail == null || thumbnail.toString().trim().isEmpty) {
      return Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Column(
          children: [
            Icon(Icons.image, color: Colors.grey, size: 48),
            const SizedBox(height: 8),
            const Text("No image available", style: TextStyle(color: Colors.grey)),
          ],
        ),
      );
    }

    final imageUrl = thumbnail.toString().trim();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.image, color: Colors.green[600], size: 24),
            const SizedBox(width: 8),
            const Text(
              "Satellite Image",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          "Latest captured satellite imagery",
          style: TextStyle(color: Colors.grey[600], fontSize: 12),
        ),
        const SizedBox(height: 16),
        ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: AspectRatio(
            aspectRatio: 1.5,
            child: Image.network(
              imageUrl,
              fit: BoxFit.cover,
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return Container(
                  color: Colors.grey.shade200,
                  child: const Center(child: CircularProgressIndicator()),
                );
              },
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  color: Colors.grey.shade200,
                  child: const Center(
                    child: Icon(Icons.image_not_supported, size: 48, color: Colors.grey),
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }


  /// --------------------
  /// Widget builders (same as before)
  /// --------------------
  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: color, size: 16),
              const SizedBox(width: 4),
              Flexible(
                child: Text(
                  value,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[700],
              fontWeight: FontWeight.w500,
            ),
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildQuickStats(TreeDetails tree, BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _buildStatCard(
            "Canopy Coverage",
            "${tree.canopySize} ${tree.canopySizeUnit}",
            Icons.filter_center_focus,
            Colors.blue,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _buildStatCard(
            "Overall Health",
            tree.treeHealth,
            Icons.favorite,
            Colors.red,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _buildStatCard(
            "Growth Rate",
            tree.treeGrowth,
            Icons.trending_up,
            Colors.green,
          ),
        ),
      ],
    );
  }

  Widget _buildTreeVitals(TreeDetails tree, BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.analytics, color: Colors.green[600], size: 24),
            const SizedBox(width: 8),
            const Text(
              "Tree Vitals",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          "Scientific measurements of tree health and growth",
          style: TextStyle(color: Colors.grey[600], fontSize: 12),
        ),
        const SizedBox(height: 16),
        _buildVitalCard("Vegetation Health (NDVI)", tree.ndvi,
            "Measures overall plant health and density", Icons.local_florist, Colors.green, "NDVI"),
        const SizedBox(height: 12),
        _buildVitalCard("Green Coverage (GLI)", tree.gli,
            "Shows how green and lush the tree appears", Icons.nature, Colors.lightGreen, "GLI"),
        const SizedBox(height: 12),
        _buildVitalCard("Growth Activity (ExG)", tree.exg,
            "Indicates active growing areas", Icons.trending_up, Colors.teal, "ExG"),
        const SizedBox(height: 12),
        _buildVitalCard("Leaf Condition (VARI)", tree.vari,
            "Evaluates leaf color and condition", Icons.eco, Colors.amber, "VARI"),
        const SizedBox(height: 12),
        _buildVitalCard("Chlorophyll Level (TGI)", tree.tgi,
            "Measures chlorophyll content in leaves", Icons.opacity, Colors.indigo, "TGI"),
      ],
    );
  }

  Widget _buildVitalCard(
      String title,
      double value,
      String description,
      IconData icon,
      Color color,
      String indexType,
      ) {
    final interpretation = _getIndexInterpretation(indexType, value);

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200, width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: color, size: 22),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      description,
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 13,
                        height: 1.2,
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    value.toStringAsFixed(2),
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: interpretation['color'].withOpacity(0.12),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      interpretation['status'],
                      style: TextStyle(
                        color: interpretation['color'],
                        fontWeight: FontWeight.w600,
                        fontSize: 11,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 20),
          Text(
            "Range: ${_getIndexRange(indexType)}",
            style: TextStyle(
              color: Colors.grey[500],
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 12),
          LayoutBuilder(
            builder: (context, constraints) {
              final barWidth = constraints.maxWidth;
              final normalized = ((value + 1) / 2).clamp(0.0, 1.0);

              return Column(
                children: [
                  Stack(
                    alignment: Alignment.centerLeft,
                    children: [
                      Container(
                        width: barWidth,
                        height: 8,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4),
                          gradient: LinearGradient(
                            colors: [
                              Colors.red.shade400,
                              Colors.orange.shade400,
                              Colors.green.shade400,
                            ],
                          ),
                        ),
                      ),
                      Positioned(
                        left: barWidth / 2 - 1,
                        child: Container(
                          width: 2,
                          height: 12,
                          decoration: BoxDecoration(
                            color: Colors.black54,
                            borderRadius: BorderRadius.circular(1),
                          ),
                        ),
                      ),
                      Positioned(
                        left: (normalized * barWidth - 6).clamp(0.0, barWidth - 12),
                        child: Container(
                          width: 12,
                          height: 12,
                          decoration: BoxDecoration(
                            color: interpretation['color'],
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 2),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.2),
                                blurRadius: 3,
                                offset: const Offset(0, 1),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "-1.0",
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.grey[500],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        "0.0",
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.grey[600],
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        "+1.0",
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.grey[500],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildAdditionalInfo(TreeDetails tree, BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Additional Information",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          _buildInfoRow("Tree ID", tree.species.id, Icons.tag),
          _buildInfoRow("Analysis Model", tree.modelType, Icons.psychology),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Colors.grey[600]),
          const SizedBox(width: 12),
          Text(label, style: TextStyle(color: Colors.grey[600], fontSize: 14)),
          const Spacer(),
          Text(value,
              style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 14)),
        ],
      ),
    );
  }

  Map<String, dynamic> _getIndexInterpretation(String indexType, double value) {
    switch (indexType) {
      case 'NDVI':
        if (value > 0.7) return {'status': 'Excellent', 'color': Colors.green};
        if (value > 0.5) return {'status': 'Good', 'color': Colors.lightGreen};
        if (value > 0.3) return {'status': 'Moderate', 'color': Colors.orange};
        return {'status': 'Poor', 'color': Colors.red};
      case 'VARI':
      case 'GLI':
        if (value > 0.6) return {'status': 'Excellent', 'color': Colors.green};
        if (value > 0.4) return {'status': 'Good', 'color': Colors.lightGreen};
        if (value > 0.2) return {'status': 'Moderate', 'color': Colors.orange};
        return {'status': 'Poor', 'color': Colors.red};
      case 'ExG':
        if (value > 0.7) return {'status': 'Excellent', 'color': Colors.green};
        if (value > 0.5) return {'status': 'Good', 'color': Colors.lightGreen};
        if (value > 0.3) return {'status': 'Moderate', 'color': Colors.orange};
        return {'status': 'Poor', 'color': Colors.red};
      case 'TGI':
        if (value > 0.5) return {'status': 'Excellent', 'color': Colors.green};
        if (value > 0.3) return {'status': 'Good', 'color': Colors.lightGreen};
        if (value > 0.1) return {'status': 'Moderate', 'color': Colors.orange};
        return {'status': 'Poor', 'color': Colors.red};
      default:
        return {'status': 'Unknown', 'color': Colors.grey};
    }
  }

  String _getIndexRange(String indexType) {
    return '-1.0 to +1.0';
  }
}

// ================
// CompactPlantAnalysisWidget
// ================

class AnalysisStep {
  final int id;
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final Color bgColor;

  AnalysisStep({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.bgColor,
  });
}

class CompactPlantAnalysisWidget extends StatelessWidget {
  final BuildContext context;
  final List<MediaItem> mediaList;

  const CompactPlantAnalysisWidget({
    Key? key,
    required this.context,
    required this.mediaList,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<AnalysisStep> steps = [
      AnalysisStep(
        id: 1,
        title: "Identification",
        subtitle: "Original Image",
        icon: Icons.camera_alt_outlined,
        color: AppColor.primary,
        bgColor: AppColor.grey,
      ),
      AnalysisStep(
        id: 2,
        title: "Cropped Image",
        subtitle: "Processed Region",
        icon: Icons.crop,
        color: AppColor.secondary,
        bgColor: AppColor.grey,
      ),
      AnalysisStep(
        id: 3,
        title: "Detection",
        subtitle: "Analysis Results",
        icon: Icons.search,
        color: AppColor.accent,
        bgColor: AppColor.grey,
      ),
      AnalysisStep(
        id: 4,
        title: "NDVI",
        subtitle: "Vegetation Index",
        icon: Icons.analytics_outlined,
        color: AppColor.success,
        bgColor: AppColor.grey,
      ),
    ];

    return Column(
      children: [
        Row(
          children: [
            Icon(Icons.settings, color: Colors.green[600], size: 24),
            const SizedBox(width: 8),
            const Text(
              "Processing Steps",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          "From capture to analysis, track each stage of processing.",
          style: TextStyle(color: Colors.grey[600], fontSize: 12),
        ),
        const SizedBox(height: 20),
        GridView.builder(
          padding: EdgeInsets.zero,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 0.9,
          ),
          itemCount: steps.length,
          itemBuilder: (context, index) {
            return _buildCompactStepCard(context, steps[index]);
          },
        )
      ],
    );
  }

  Widget _buildCompactStepCard(BuildContext context, AnalysisStep step) {
    String imageUrl = "https://via.placeholder.com/150";
    if (mediaList.isNotEmpty) {
      // Map step ID to media index (adjust based on your backend logic)
      final mediaIndex = step.id - 1;
      if (mediaIndex >= 0 && mediaIndex < mediaList.length) {
        imageUrl = mediaList[mediaIndex].media.trim();
      } else {
        imageUrl = mediaList[0].media.trim(); // fallback
      }
    }

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColor.grey, // assuming AppColor.grey exists
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColor.divider),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Container(
                width: 30,
                height: 30,
                decoration: BoxDecoration(
                  color: step.color,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Center(
                  child: Text(
                    '${step.id}',
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 6),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    step.title,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: AppColor.textPrimary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    step.subtitle,
                    style: TextStyle(
                      fontSize: 11,
                      color: AppColor.textSecondary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              )
            ],
          ),
          const SizedBox(height: 8),
          Expanded(
            child: InkWell(
              onTap: () {
                AppRoute.goToNextPage(
                  context: context,
                  screen: FullScreenImageViewer.route,
                  arguments: {
                    'imagePath': imageUrl,
                    'heroTag': step.id.toString(),
                  },
                );
              },
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(
                    color: AppColor.border,
                    style: BorderStyle.solid,
                  ),
                ),
                child: Center(
                  child: Image.network(
                    imageUrl,
                    fit: BoxFit.contain,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return const CircularProgressIndicator();
                    },
                    errorBuilder: (context, error, stackTrace) {
                      return const Icon(Icons.image_not_supported, color: Colors.grey);
                    },
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class TreeSpecies {
  final String id;
  final String localName;
  final String scientificName;
  final String image;

  TreeSpecies({
    required this.id,
    required this.localName,
    required this.scientificName,
    required this.image,
  });

  factory TreeSpecies.fromJson(Map<String, dynamic> json) {
    return TreeSpecies(
      id: json['id'] ?? "",
      localName: json['local_name'] ?? "",
      scientificName: json['scientific_name'] ?? "",
      image: (json['image'] as String?)?.trim() ?? "",
    );
  }
}

class TreeDetails {
  final String thumbnail;
  final TreeSpecies species;

  final String monitoringStatus;
  final int monitoringStatusColor;
  final int monitoringStatusDays;

  final double canopySize;
  final String canopySizeUnit;

  final String treeHealth;
  final String treeGrowth;
  final int confidence;

  final double ndvi;
  final double vari;
  final double gli;
  final double exg;
  final double tgi;

  final String modelType;

  TreeDetails({
    required this.thumbnail,
    required this.species,
    required this.monitoringStatus,
    required this.monitoringStatusColor,
    required this.monitoringStatusDays,
    required this.canopySize,
    required this.canopySizeUnit,
    required this.treeHealth,
    required this.treeGrowth,
    required this.confidence,
    required this.ndvi,
    required this.vari,
    required this.gli,
    required this.exg,
    required this.tgi,
    required this.modelType,
  });

  factory TreeDetails.fromJson(Map<String, dynamic> json) {
    return TreeDetails(
      thumbnail: (json['thumbnail'] ) ?? "",
      species: TreeSpecies.fromJson(json['tree_species'] ?? {}),
      monitoringStatus: json['monitoring_status'] ?? "",
      monitoringStatusColor: int.tryParse(json['monitoring_status_color']?.toString().trim() ?? "0xFF9E9E9E") ?? 0xFF9E9E9E,
      monitoringStatusDays: json['monitoring_status_days'] ?? 0,
      canopySize: (json['canopy_size'] ?? 0).toDouble(),
      canopySizeUnit: json['canopy_size_unit'] ?? "",
      treeHealth: json['tree_health'] ?? "",
      treeGrowth: json['tree_growth'] ?? "",
      confidence: json['confidence'] ?? 0,
      ndvi: (json['ndvi'] ?? 0).toDouble(),
      vari: (json['vari'] ?? 0).toDouble(),
      gli: (json['gli'] ?? 0).toDouble(),
      exg: (json['exg'] ?? 0).toDouble(),
      tgi: (json['tgi'] ?? 0).toDouble(),
      modelType: json['model_type'] ?? "",
    );
  }
}

 */

/*
// Alternative
class HorizontalPlantAnalysisWidget extends StatelessWidget {
  const HorizontalPlantAnalysisWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<AnalysisStep> steps = [
      AnalysisStep(
        id: 1,
        title: "Original",
        subtitle: "Image",
        icon: Icons.camera_alt_outlined,
        color: AppColor.primary,
        bgColor: AppColor.background,
      ),
      AnalysisStep(
        id: 2,
        title: "Cropped",
        subtitle: "Region",
        icon: Icons.crop,
        color: AppColor.secondary,
        bgColor: AppColor.grey,
      ),
      AnalysisStep(
        id: 3,
        title: "Detection",
        subtitle: "Results",
        icon: Icons.search,
        color: AppColor.accent,
        bgColor: AppColor.background,
      ),
      AnalysisStep(
        id: 4,
        title: "NDVI",
        subtitle: "Index",
        icon: Icons.analytics_outlined,
        color: AppColor.success,
        bgColor: AppColor.grey,
      ),
    ];

    return Container(
      height: 100,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColor.cardBackground,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColor.border),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: steps.map((step) => Expanded(
          child: _buildHorizontalStepCard(step, steps.indexOf(step) < steps.length - 1),
        )).toList(),
      ),
    );
  }

  Widget _buildHorizontalStepCard(AnalysisStep step, bool showDivider) {
    return Row(
      children: [
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Step Circle with Icon
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: step.color.withOpacity(0.1),
                  shape: BoxShape.circle,
                  border: Border.all(color: step.color, width: 1.5),
                ),
                child: Stack(
                  children: [
                    Center(
                      child: Icon(
                        step.icon,
                        size: 14,
                        color: step.color,
                      ),
                    ),
                    Positioned(
                      top: -2,
                      right: -2,
                      child: Container(
                        width: 16,
                        height: 16,
                        decoration: BoxDecoration(
                          color: step.color,
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Text(
                            '${step.id}',
                            style: const TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                              color: AppColor.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 6),

              // Title
              Text(
                step.title,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: AppColor.textPrimary,
                ),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),

              // Subtitle
              Text(
                step.subtitle,
                style: TextStyle(
                  fontSize: 9,
                  color: AppColor.textSecondary,
                ),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),

        // Divider Arrow
        if (showDivider) ...[
          Icon(
            Icons.arrow_forward_ios,
            size: 12,
            color: AppColor.textMuted,
          ),
        ],
      ],
    );
  }
}

 */

class SatelliteMonitoringResultScreen extends StatefulWidget {
  static const route = '/satellite';
  final String monitorId;

  const SatelliteMonitoringResultScreen({
    super.key,
    required this.monitorId,
  });

  @override
  State<SatelliteMonitoringResultScreen> createState() =>
      _SatelliteMonitoringResultScreenState();
}

class _SatelliteMonitoringResultScreenState
    extends State<SatelliteMonitoringResultScreen> {
  late SatelliteBloc satelliteBloc;

  @override
  void initState() {
    satelliteBloc = SatelliteBloc(MonitorRepository(api: ApiConnection()));
    satelliteBloc.add(ApiFetch(id: widget.monitorId));
    // widget.monitorId));
    super.initState();
  }

  @override
  void dispose() {
    satelliteBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text("Satellite Monitoring"),
        backgroundColor: AppColor.background,
        centerTitle: true,
        elevation: 0.5,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppColor.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: BlocBuilder<SatelliteBloc,
          ApiState<SatelliteMonitorResponse, ResponseModel>>(
        bloc: satelliteBloc,
        builder: (context, state) {
          if (state is ApiLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state
              is ApiSuccess<SatelliteMonitorResponse, ResponseModel>) {
            final dataList = state.data.data;
            //
            // if (dataList) {
            //   return Center(
            //     child: Column(
            //       mainAxisAlignment: MainAxisAlignment.center,
            //       children: const [
            //         Icon(Icons.info, color: Colors.grey, size: 48),
            //         SizedBox(height: 16),
            //         Text("No satellite monitoring data available."),
            //       ],
            //     ),
            //   );
            // }

            final satelliteData = dataList;
            final tree = _mapToTreeDetails(satelliteData);

            return CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  tree.species.localName,
                                  style: const TextStyle(
                                    color: AppColor.black,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  tree.species.scientificName,
                                  style: TextStyle(
                                    color: AppColor.secondary,
                                    fontSize: 14,
                                    fontStyle: FontStyle.italic,
                                  ),
                                ),
                              ],
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: Colors.green.withOpacity(0.9),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(Icons.verified,
                                      size: 14, color: Colors.white),
                                  const SizedBox(width: 4),
                                  Text(
                                    "Confidence: ${tree.confidence}%",
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),
                        _buildQuickStats(tree, context),
                        const SizedBox(height: 24),
                        // _buildThumbnailPreview(tree.thumbnail),
                        _buildMediaPreview(tree.media),
                        const SizedBox(height: 24),
                        _buildTreeVitals(tree, context),
                        const SizedBox(height: 24),
                        _buildAdditionalInfo(tree, context),
                      ],
                    ),
                  ),
                ),
              ],
            );
          } else if (state
                  is ApiFailure<SatelliteMonitorResponse, ResponseModel> ||
              state is TokenExpired<SatelliteMonitorResponse, ResponseModel>) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error, color: Colors.red, size: 48),
                  const SizedBox(height: 16),
                  Text(
                    "Failed to load tree data.",
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.red, fontSize: 16),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () {
                      satelliteBloc.add(ApiFetch(id: widget.monitorId));
                    },
                    child: const Text("Retry"),
                  )
                ],
              ),
            );
          } else {
            return const Center(child: Text("Unknown state"));
          }
        },
      ),
    );
  }

  TreeDetails _mapToTreeDetails(SatelliteMonitorData data) {
    int parseColor(String colorStr) {
      final clean = colorStr.trim();
      if (clean.startsWith('0x')) {
        return int.tryParse(clean) ?? 0xFF9E9E9E;
      } else {
        return int.tryParse('0x$clean') ?? 0xFF9E9E9E;
      }
    }

    // 🔍 Extract thumbnail from media list
    String thumbnail = "";
    if (data.media.isNotEmpty) {
      // Prefer explicit 'thumbnail' type, fallback to first image
      final thumbnailMedia = data.media.firstWhere(
        (item) => item.type.toLowerCase() == 'thumbnail',
        orElse: () => data.media[0],
      );
      thumbnail = thumbnailMedia.media.trim();
    }

    // Handle nullable treeSpecies
    final species = data.treeSpecies ??
        TreeSpecies(
          id: 'unknown',
          localName: 'Unknown Tree',
          scientificName: 'Species unknown',
          image: '',
        );

    return TreeDetails(
      thumbnail: thumbnail,
      species: species,
      media: data.media,
      monitoringStatus: data.monitoringStatus,
      monitoringStatusColor: parseColor(data.monitoringStatusColor),
      monitoringStatusDays: data.monitoringStatusDays,
      canopySize: data.canopySize,
      canopySizeUnit: data.canopySizeUnit,
      treeHealth: data.treeHealth,
      treeGrowth: data.treeGrowth,
      confidence: (data.confidence * 100).clamp(0, 100).toInt(),
      ndvi: data.ndvi ?? 0.0,
      vari: data.vari ?? 0.0,
      gli: data.gli ?? 0.0,
      exg: data.exg ?? 0.0,
      tgi: data.tgi ?? 0.0,
      modelType: data.modelType,
    );
  }

  Widget _buildThumbnailPreview(String thumbnailUrl) {
    if (thumbnailUrl.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.image, color: Colors.grey, size: 48),
            const SizedBox(height: 8),
            const Text("No image available",
                style: TextStyle(color: Colors.grey)),
          ],
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.image, color: Colors.green[600], size: 24),
            const SizedBox(width: 8),
            const Text(
              "Satellite Image",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          "Captured satellite imagery",
          style: TextStyle(color: Colors.grey[600], fontSize: 12),
        ),
        const SizedBox(height: 16),
        ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: AspectRatio(
            aspectRatio: 1.5,
            child: Image.network(
              thumbnailUrl,
              fit: BoxFit.cover,
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return Container(
                  color: Colors.grey.shade200,
                  child: const Center(child: CircularProgressIndicator()),
                );
              },
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  color: Colors.grey.shade200,
                  child: const Center(
                    child: Icon(Icons.image_not_supported,
                        size: 48, color: Colors.grey),
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMediaPreview(List<MediaItem> media) {
    if (media.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.image, color: Colors.grey, size: 48),
            const SizedBox(height: 8),
            const Text(
              "No media available",
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.image, color: Colors.green[600], size: 24),
            const SizedBox(width: 8),
            const Text(
              "Satellite Image",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          "Captured satellite imagery",
          style: TextStyle(color: Colors.grey[600], fontSize: 12),
        ),
        const SizedBox(height: 16),
        // Show all media items in a scrollable horizontal list
        SizedBox(
          height: 200, // Fixed height for consistency
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: media.length,
            itemBuilder: (context, index) {
              final item = media[index];
              final isImage = item.type.toLowerCase() == 'image';
              // You can extend this for video later if needed

              return Padding(
                padding: const EdgeInsets.only(right: 12),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: SizedBox(
                    width: 180, // Fixed width per item
                    child: _buildMediaItem(item.media),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildMediaItem(String mediaUrl) {
    if (mediaUrl.isEmpty) {
      return _buildEmptyMediaPlaceholder();
    }

    return AspectRatio(
      aspectRatio: 1.5, // You can adjust (e.g., 4/3 = 1.33, 3/2 = 1.5)
      child: InkWell(
        onTap: () {
          AppRoute.goToNextPage(
              context: context,
              screen: FullScreenImageViewer.route,
              arguments: {'imagePath': mediaUrl, 'heroTag': 'image'});
        },
        child: Image.network(
          mediaUrl,
          fit: BoxFit.contain, // ✅ Ensures entire image is visible
          alignment: Alignment.center,
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) return child;
            return Container(
              color: Colors.grey.shade200,
              child: const Center(child: CircularProgressIndicator()),
            );
          },
          errorBuilder: (context, error, stackTrace) {
            return _buildEmptyMediaPlaceholder();
          },
        ),
      ),
    );
  }

  Widget _buildEmptyMediaPlaceholder() {
    return Container(
      color: Colors.grey.shade200,
      child: const Center(
        child: Icon(Icons.image_not_supported, size: 40, color: Colors.grey),
      ),
    );
  }

  /// --------------------
  /// Widget builders
  /// --------------------
  Widget _buildStatCard(
      String title, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: color, size: 16),
              const SizedBox(width: 4),
              Flexible(
                child: Text(
                  value,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[700],
              fontWeight: FontWeight.w500,
            ),
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildQuickStats(TreeDetails tree, BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _buildStatCard(
            "Canopy Coverage",
            "${tree.canopySize.toStringAsFixed(2)} ${tree.canopySizeUnit}",
            Icons.filter_center_focus,
            Colors.blue,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _buildStatCard(
            "Overall Health",
            tree.treeHealth,
            Icons.favorite,
            Colors.red,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _buildStatCard(
            "Growth Rate",
            tree.treeGrowth,
            Icons.trending_up,
            Colors.green,
          ),
        ),
      ],
    );
  }

  Widget _buildTreeVitals(TreeDetails tree, BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.analytics, color: Colors.green[600], size: 24),
            const SizedBox(width: 8),
            const Text(
              "Tree Vitals",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          "Scientific measurements of tree health and growth",
          style: TextStyle(color: Colors.grey[600], fontSize: 12),
        ),
        const SizedBox(height: 16),
        _buildVitalCard(
            "Vegetation Health (NDVI)",
            tree.ndvi,
            "Measures overall plant health and density",
            Icons.local_florist,
            Colors.green,
            "NDVI",
            true),
        const SizedBox(height: 12),
        _buildVitalCard(
            "Green Coverage (GLI)",
            tree.gli,
            "Shows how green and lush the tree appears",
            Icons.nature,
            Colors.lightGreen,
            "GLI",
            true),
        const SizedBox(height: 12),
        _buildVitalCard(
            "Growth Activity (ExG)",
            tree.exg,
            "Indicates active growing areas",
            Icons.trending_up,
            Colors.teal,
            "ExG",
            false),
        const SizedBox(height: 12),
        _buildVitalCard(
            "Leaf Condition (VARI)",
            tree.vari,
            "Evaluates leaf color and condition",
            Icons.eco,
            Colors.amber,
            "VARI",
            true),
        const SizedBox(height: 12),
        _buildVitalCard(
            "Chlorophyll Level (TGI)",
            tree.tgi,
            "Measures chlorophyll content in leaves",
            Icons.opacity,
            Colors.indigo,
            "TGI",
            false),
      ],
    );
  }

  Widget _buildVitalCard(
    String title,
    double value,
    String description,
    IconData icon,
    Color color,
    String indexType,
    bool isVisible,
  ) {
    final interpretation = _getIndexInterpretation(indexType, value);

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200, width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: color, size: 22),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      description,
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 13,
                        height: 1.2,
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    value.toStringAsFixed(2),
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: interpretation['color'].withOpacity(0.12),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      interpretation['status'],
                      style: TextStyle(
                        color: interpretation['color'],
                        fontWeight: FontWeight.w600,
                        fontSize: 11,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          if (isVisible) ...[
            const SizedBox(height: 20),
            Text(
              "Range: ${_getIndexRange(indexType)}",
              style: TextStyle(
                color: Colors.grey[500],
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 12),
            LayoutBuilder(
              builder: (context, constraints) {
                final barWidth = constraints.maxWidth;
                // Normalize from [-1, 1] to [0, 1]
                final normalized = ((value + 1) / 2).clamp(0.0, 1.0);

                return Column(
                  children: [
                    Stack(
                      alignment: Alignment.centerLeft,
                      children: [
                        Container(
                          width: barWidth,
                          height: 8,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(4),
                            gradient: LinearGradient(
                              colors: [
                                Colors.red.shade400,
                                Colors.orange.shade400,
                                Colors.green.shade400,
                              ],
                            ),
                          ),
                        ),
                        Positioned(
                          left: barWidth / 2 - 1,
                          child: Container(
                            width: 2,
                            height: 12,
                            decoration: BoxDecoration(
                              color: Colors.black54,
                              borderRadius: BorderRadius.circular(1),
                            ),
                          ),
                        ),
                        Positioned(
                          left: (normalized * barWidth - 6)
                              .clamp(0.0, barWidth - 12),
                          child: Container(
                            width: 12,
                            height: 12,
                            decoration: BoxDecoration(
                              color: interpretation['color'],
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.white, width: 2),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.2),
                                  blurRadius: 3,
                                  offset: const Offset(0, 1),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "-1.0",
                          style: TextStyle(
                            fontSize: 11,
                            color: Colors.grey[500],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          "0.0",
                          style: TextStyle(
                            fontSize: 11,
                            color: Colors.grey[600],
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          "+1.0",
                          style: TextStyle(
                            fontSize: 11,
                            color: Colors.grey[500],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ],
                );
              },
            ),
          ]
        ],
      ),
    );
  }

  Widget _buildAdditionalInfo(TreeDetails tree, BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Additional Information",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          _buildInfoRow("Tree ID", tree.species.id, Icons.tag),
          _buildInfoRow("Analysis Model", tree.modelType, Icons.psychology),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Colors.grey[600]),
          const SizedBox(width: 12),
          Text(label, style: TextStyle(color: Colors.grey[600], fontSize: 14)),
          const Spacer(),
          Flexible(
            child: Text(
              value,
              style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Map<String, dynamic> _getIndexInterpretation(String indexType, double value) {
    switch (indexType) {
      case 'NDVI':
        if (value > 0.7) return {'status': 'Excellent', 'color': Colors.green};
        if (value > 0.5) return {'status': 'Good', 'color': Colors.lightGreen};
        if (value > 0.3) return {'status': 'Moderate', 'color': Colors.orange};
        return {'status': 'Poor', 'color': Colors.red};
      case 'VARI':
      case 'GLI':
        if (value > 0.6) return {'status': 'Excellent', 'color': Colors.green};
        if (value > 0.4) return {'status': 'Good', 'color': Colors.lightGreen};
        if (value > 0.2) return {'status': 'Moderate', 'color': Colors.orange};
        return {'status': 'Poor', 'color': Colors.red};
      case 'ExG':
        if (value > 0.7) return {'status': 'Excellent', 'color': Colors.green};
        if (value > 0.5) return {'status': 'Good', 'color': Colors.lightGreen};
        if (value > 0.3) return {'status': 'Moderate', 'color': Colors.orange};
        return {'status': 'Poor', 'color': Colors.red};
      case 'TGI':
        if (value > 0.5) return {'status': 'Excellent', 'color': Colors.green};
        if (value > 0.3) return {'status': 'Good', 'color': Colors.lightGreen};
        if (value > 0.1) return {'status': 'Moderate', 'color': Colors.orange};
        return {'status': 'Poor', 'color': Colors.red};
      default:
        return {'status': 'Unknown', 'color': Colors.grey};
    }
  }

  String _getIndexRange(String indexType) {
    return '-1.0 to +1.0';
  }
}

class TreeDetails {
  final String thumbnail;
  final List<MediaItem> media;
  final TreeSpecies species;

  final String monitoringStatus;
  final int monitoringStatusColor;
  final int monitoringStatusDays;

  final double canopySize;
  final String canopySizeUnit;

  final String treeHealth;
  final String treeGrowth;
  final int confidence;

  final double ndvi;
  final double vari;
  final double gli;
  final double exg;
  final double tgi;

  final String modelType;

  TreeDetails({
    required this.thumbnail,
    required this.media,
    required this.species,
    required this.monitoringStatus,
    required this.monitoringStatusColor,
    required this.monitoringStatusDays,
    required this.canopySize,
    required this.canopySizeUnit,
    required this.treeHealth,
    required this.treeGrowth,
    required this.confidence,
    required this.ndvi,
    required this.vari,
    required this.gli,
    required this.exg,
    required this.tgi,
    required this.modelType,
  });

  factory TreeDetails.fromJson(Map<String, dynamic> json) {
    return TreeDetails(
      thumbnail: (json['thumbnail']) ?? "",
      media: json['media'],
      species: TreeSpecies.fromJson(json['tree_species'] ?? {}),
      monitoringStatus: json['monitoring_status'] ?? "",
      monitoringStatusColor: int.tryParse(
              json['monitoring_status_color']?.toString().trim() ??
                  "0xFF9E9E9E") ??
          0xFF9E9E9E,
      monitoringStatusDays: json['monitoring_status_days'] ?? 0,
      canopySize: (json['canopy_size'] ?? 0).toDouble(),
      canopySizeUnit: json['canopy_size_unit'] ?? "",
      treeHealth: json['tree_health'] ?? "",
      treeGrowth: json['tree_growth'] ?? "",
      confidence: json['confidence'] ?? 0,
      ndvi: (json['ndvi'] ?? 0).toDouble(),
      vari: (json['vari'] ?? 0).toDouble(),
      gli: (json['gli'] ?? 0).toDouble(),
      exg: (json['exg'] ?? 0).toDouble(),
      tgi: (json['tgi'] ?? 0).toDouble(),
      modelType: json['model_type'] ?? "",
    );
  }
}
