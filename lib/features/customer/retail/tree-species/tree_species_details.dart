import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:treelove/common/repositories/cart_repository.dart';
import 'package:treelove/core/utils/logger.dart';
import 'package:treelove/core/widgets/common_notification.dart';
import 'package:treelove/features/customer/retail/cart/bloc/cart_item_bloc.dart';
import '../../../../common/bloc/api_event.dart';
import '../../../../common/bloc/api_state.dart';
import '../../../../common/models/response.mode.dart';
import '../../../../common/repositories/tree_species_repository.dart';
import '../../../../core/config/constants/enum/status_enum.dart';
import '../../../../core/config/resource/images.dart';
import '../../../../core/config/resource/service_ids.dart';
import '../../../../core/config/route/app_route.dart';
import '../../../../core/config/themes/app_color.dart';
import '../../../../core/config/themes/app_fonts.dart';
import '../../../../core/network/api_connection.dart';
import '../../../../core/storage/preference_keys.dart';
import '../../../../core/storage/secure_storage.dart';
import '../cart/cart_screen.dart';
import '../cart/model/cart_item_model.dart';
import '../cart/model/cart_request_model.dart';
import '../home/screens/location_selection_screen.dart';
import 'bloc/tree_species_bloc.dart';
import 'models/tree_species_model.dart';

class TreeSpeciesDetails extends StatefulWidget {
  final String id;
  final String areaId;
  static const route = '/tree-species-details';

  const TreeSpeciesDetails({super.key, required this.id, required this.areaId});

  @override
  State<TreeSpeciesDetails> createState() => _TreeSpeciesDetailsState();
}

class _TreeSpeciesDetailsState extends State<TreeSpeciesDetails> {
  late TreeDetailBloc _treeDetailBloc;

  final pref = SecurePreference();

  int quantity = 1;
  bool geoTagging = true;
  bool monitoring = false;
  bool maintenance = true;

  double price = 0;

  void incrementQuantity() {
    setState(() {
      quantity++;
    });
  }

  void decrementQuantity() {
    if (quantity > 1) {
      setState(() {
        quantity--;
      });
    }
  }

  late CartBloc cartBloc;

  String? navigateTo;

  @override
  void initState() {
    _treeDetailBloc = TreeDetailBloc(
      TreeSpeciesRepository(api: ApiConnection()),
    );
    cartBloc = CartBloc(CartRepository(api: ApiConnection()));
    _treeDetailBloc.add(ApiFetch(id: widget.id));
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => _treeDetailBloc,
          ),
          BlocProvider(
            create: (context) => cartBloc,
          ),
        ],
        child: BlocBuilder<TreeDetailBloc,
            ApiState<SingleTreeSpeciesResponse, ResponseModel>>(
          builder: (context, state) {
            if (state is ApiLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state is ApiSuccess<SingleTreeSpeciesResponse, ResponseModel>) {
              final SingleTreeSpeciesResponse treeDetail = state.data;
              price =
                  double.parse(treeDetail.data.servicePricing!.plantingPrice);
              return Stack(
                children: [
                  // Background Image
                  Positioned.fill(
                    child: Image.network(
                      treeDetail.data.image ??
                          'https://media.istockphoto.com/id/1407017283/photo/neem-leaves-and-fruits-neem-seeds-with-leaf-neem-tree-medicinal-herbs-plant-neem-known-as.jpg?s=1024x1024&w=is&k=20&c=DFaSRRjm-3mmwolJ4vfEwAmcAfrzZBG2J_fSS4Dy7Wc=',
                      // Images.sampleImg, // Replace with your image path
                      fit: BoxFit.cover,
                    ),
                  ),

                  // Dark Overlay
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.black.withOpacity(0.8),
                          Colors.transparent,
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                  ),

                  // Main Content
                  SafeArea(
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: 15.w, vertical: 10.h),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          InkWell(
                              onTap: () {
                                AppRoute.pop(context);
                              },
                              child: Icon(
                                Icons.arrow_back,
                                color: AppColor.white,
                              )),
                          SizedBox(
                            height: 20.h,
                          ),
                          // Title
                          Text(
                            treeDetail.data.treeName,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 36,
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          // Description
                          SizedBox(height: 16),
                          Text(
                            treeDetail.data.shortDescription,
                            // "It is a long established fact that a reader will be distracted by the readable content of a page when looking at its layout. The point of using Lorem Ipsum is that it has a more-or-less normal distribution",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                            ),
                          ),

                          // Separator Line
                          SizedBox(height: 16),
                          Divider(color: Colors.white),

                          // Cost per Tree Section
                          SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                // "Cost per tree – ${price*quantity}",
                                "Cost per tree – ${(price * quantity).toStringAsFixed(2)}",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                ),
                              ),
                              Row(
                                children: [
                                  IconButton(
                                    icon:
                                        Icon(Icons.remove, color: Colors.white),
                                    onPressed: decrementQuantity,
                                  ),
                                  Text(
                                    "$quantity",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  IconButton(
                                    icon: Icon(Icons.add, color: Colors.white),
                                    onPressed: incrementQuantity,
                                  ),
                                ],
                              ),
                            ],
                          ),

                          // Geo - Tagging Toggle
                          SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Geo – tagging",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                ),
                              ),
                              Switch(
                                value: geoTagging,
                                onChanged: (value) {
                                  // setState(() {
                                  //   geoTagging = value;
                                  // });
                                },
                                activeColor: Colors.white,
                              ),
                            ],
                          ), // Monitoring Toggle
                          SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Maintenance – ₹${treeDetail.data.servicePricing!.maintenancePrice}",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                ),
                              ),
                              Switch(
                                value: maintenance,
                                onChanged: (value) {
                                  setState(() {
                                    maintenance = value;
                                  });
                                },
                                activeColor: Colors.white,
                              ),
                            ],
                          ),
                          SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Monitoring – ₹${treeDetail.data.servicePricing!.monitoringPrice}",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                ),
                              ),
                              Switch(
                                value: monitoring,
                                onChanged: (value) {
                                  setState(() {
                                    monitoring = value;
                                  });
                                },
                                activeColor: Colors.white,
                              ),
                            ],
                          ),

                          // Maintenance Toggle

                          // Add to Cart Button
                          Spacer(),
                          BlocListener<CartBloc,
                              ApiState<AddToCartResponseModel, ResponseModel>>(
                            listener: (context, state) {
                              debugLog(state.toString());
                              if (state is ApiLoading<AddToCartResponseModel,
                                  ResponseModel>) {
                                EasyLoading.show();
                              } else if (state is ApiSuccess<
                                  AddToCartResponseModel, ResponseModel>) {
                                EasyLoading.dismiss();
                                if (navigateTo == 'another') {
                                  AppRoute.goToNextPage(
                                      context: context,
                                      screen: MapScreen.route,
                                      arguments: {});
                                } else if (navigateTo == 'cart') {
                                  AppRoute.goToNextPage(
                                      context: context,
                                      screen: CartScreen.route,
                                      arguments: {});
                                }
                              } else if (state is TokenExpired<
                                  AddToCartResponseModel, ResponseModel>) {
                                EasyLoading.dismiss();
                                showNotification(context,
                                    message: "Token Expired");
                              }else if(state is ApiFailure<AddToCartResponseModel, ResponseModel>){
                                EasyLoading.dismiss();
                                showNotification(context,
                                    message: state.error.message.toString());
                              }
                            },
                            child: SizedBox(
                              width: double.infinity,
                              height: 50,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Color(0xFFF6F2E8),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(28),
                                  ),
                                ),
                                onPressed: () async {
                                  navigateTo = 'another';
                                  final userId = await pref.getString(Keys.id);
                                  final cartItem = CartRequestDetail(
                                    isMaintenance: maintenance,
                                    isMonitoring: monitoring,
                                    cartItemRequest: CartItemRequest(
                                      user: userId,
                                      // required UUID
                                      projectArea: widget.areaId,
                                      // optional
                                      serviceType: ServiceIds.plantationId!,
                                      // required
                                      isGeotagOnly: geoTagging,
                                      parentService: null,
                                      quantity: quantity,
                                      treeSpecies: treeDetail.data.id,
                                      status: "pending",
                                      // required
                                      unitPrice: treeDetail.data.servicePricing!
                                          .plantingPrice, // required string decimal
                                    )
                                  );
                                  debugLog(jsonEncode(cartItem.cartItemRequest.toJson()),
                                      name: 'Cart item');
                                  cartBloc.add(ApiAdd(cartItem));
                                },
                                child: Text('Add other Tree species',
                                    style: AppFonts.regular
                                        .copyWith(color: Color(0xFFD2C7A6))),
                              ),
                            ),
                          ),

                          SizedBox(
                            height: 15.h,
                          ),
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
                              onPressed: () async{
                                navigateTo = 'cart';
                                final userId = await pref.getString(Keys.id);
                                final cartItem = CartRequestDetail(
                                    isMaintenance: maintenance,
                                    isMonitoring: monitoring,
                                    cartItemRequest: CartItemRequest(
                                      user: userId,
                                      // required UUID
                                      projectArea: widget.areaId,
                                      // optional
                                      serviceType: ServiceIds.plantationId!,
                                      // required
                                      isGeotagOnly: geoTagging,
                                      parentService: null,
                                      quantity: quantity,
                                      treeSpecies: treeDetail.data.id,
                                      status: "pending",
                                      // required
                                      unitPrice: treeDetail.data.servicePricing!
                                          .plantingPrice, // required string decimal
                                    )
                                );
                                 debugLog(cartItem.cartItemRequest.toJson().toString(),
                                    name: 'Cart item');
                                cartBloc.add(ApiAdd(cartItem));
                                // AppRoute.goToNextPage(
                                //     context: context,
                                //     screen: CartScreen.route,
                                //     arguments: {
                                //
                                //     });
                              },
                              child:
                                  Text('Add to cart', style: AppFonts.regular),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}
/*
  backgroundColor: const Color(0xFFF6F2E8),
                    foregroundColor: const Color(0xFFD2C7A6),
*/
