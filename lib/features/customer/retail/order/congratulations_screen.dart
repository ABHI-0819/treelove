import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:share_plus/share_plus.dart';
import 'package:treelove/features/customer/retail/home/screens/home_screen.dart';
import 'package:treelove/features/customer/retail/order/order_list_screen.dart';

import '../../../../core/config/resource/images.dart';
import '../../../../core/config/route/app_route.dart';
import '../home/screens/main_screen.dart';
/*
class CongratulationsScreen extends StatefulWidget {
  static const route ='/congratulations';
  final String shareLink ;
  const CongratulationsScreen({super.key, this.shareLink ='https://example.com/share-link'});

  @override
  State<CongratulationsScreen> createState() => _CongratulationsScreenState();
}

class _CongratulationsScreenState extends State<CongratulationsScreen> {
  String shareLink = '' ;

  @override
  void initState() {
    shareLink= widget.shareLink;
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFEFEF7), // Background similar to image
      body: SafeArea(
        child: Padding(
          padding:  EdgeInsets.symmetric(horizontal: 16.w),
          child: Column(
            children: [
              // Top bar with back + close
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.black),
                    onPressed: () => AppRoute.pushReplacement(context, RetailMainScreen.route, arguments: {})
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.black),
                      onPressed: () => AppRoute.pushReplacement(context, OrderListScreen.route, arguments: {})
                  ),
                ],
              ),

              const SizedBox(height: 30),

              // Title
              const Text(
                "Congratulations!",
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 6),
              const Text(
                "You just made the world greener",
                style: TextStyle(fontSize: 15, color: Colors.black54),
              ),

              const SizedBox(height: 40),

              // Circle checkmark
              Container(
                height: 120,
                width: 120,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: const Color(0xFF76A693), width: 6),
                  color: const Color(0xFF004C3F),
                ),
                child: const Icon(Icons.check, size: 60, color: Colors.white),
              ),

              const SizedBox(height: 50),

              // Share link row
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: Row(
                  children: [
                    const Icon(Icons.link, size: 20, color: Colors.black87),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        shareLink,
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const Divider(height: 20, thickness: 1),

              const SizedBox(height: 20),

              // Copy button
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: SizedBox(
                  width: double.infinity,
                  height: 55,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF004C3F),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    onPressed: () async {
                      await Clipboard.setData(ClipboardData(text: shareLink));
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Link copied to clipboard")),
                      );
                    },
                    child: const Text(
                      "Copy",
                      style: TextStyle(fontSize: 18, color: Colors.white),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 40),

              // Share via text
              const Text(
                "Share this link via",
                style: TextStyle(fontSize: 14, color: Colors.black54),
              ),
              const SizedBox(height: 20),

              // Social icons row
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: SvgPicture.asset(Images.facebookIcon,width: 28,height: 28,),
                    onPressed: () => Share.share(shareLink),
                  ),
                  const SizedBox(width: 20),
                  IconButton(
                    icon: SvgPicture.asset(Images.whatsappIcon,width: 28,height: 28,),
                    onPressed: () => Share.share(shareLink),
                  ),
                  const SizedBox(width: 20),
                  IconButton(
                    icon:  SvgPicture.asset(Images.instagramIcon,width: 28,height: 28,),
                    // const Icon(Ico, size: 28, color: Color(0xFF004C3F)), // Instagram placeholder
                    onPressed: () => Share.share(shareLink),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

 */

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:share_plus/share_plus.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';



class CongratulationsScreen extends StatefulWidget {
  static const route = '/congratulations';
  final String shareLink;
  const CongratulationsScreen({super.key, this.shareLink = 'https://example.com/share-link'});

  @override
  State<CongratulationsScreen> createState() => _CongratulationsScreenState();
}

class _CongratulationsScreenState extends State<CongratulationsScreen> {
  late String shareLink;

  @override
  void initState() {
    super.initState();
    shareLink = widget.shareLink;
  }

  // 🔹 Social sharing helpers
  Future<void> _shareToInstagram(String link) async {
    final uri = Uri.parse("instagram://share?text=$link");
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      await launchUrl(Uri.parse("https://instagram.com/"));
    }
  }

  Future<void> _shareToWhatsApp(String link) async {
    final uri = Uri.parse("whatsapp://send?text=$link");
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      await launchUrl(Uri.parse("https://wa.me/?text=$link"));
    }
  }

  Future<void> _shareToFacebook(String link) async {
    final uri = Uri.parse("fb://facewebmodal/f?href=$link");
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      await launchUrl(Uri.parse("https://facebook.com/sharer/sharer.php?u=$link"));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFEFEF7),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Column(
            children: [
              // 🔹 Top bar
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.black),
                    onPressed: () => AppRoute.pushReplacement(
                        context, RetailMainScreen.route, arguments: {}),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.black),
                    onPressed: () => AppRoute.pushReplacement(
                        context, OrderListScreen.route, arguments: {}),
                  ),
                ],
              ),

              const SizedBox(height: 30),

              const Text(
                "Congratulations!",
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 6),
              const Text(
                "You just made the world greener",
                style: TextStyle(fontSize: 15, color: Colors.black54),
              ),

              const SizedBox(height: 40),

              // 🔹 Circle check
              Container(
                height: 120,
                width: 120,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: const Color(0xFF76A693), width: 6),
                  color: const Color(0xFF004C3F),
                ),
                child: const Icon(Icons.check, size: 60, color: Colors.white),
              ),

              const SizedBox(height: 50),

              // 🔹 Share link row
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: Row(
                  children: [
                    const Icon(Icons.link, size: 20, color: Colors.black87),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        shareLink,
                        style: const TextStyle(fontSize: 16, color: Colors.black87),
                      ),
                    ),
                  ],
                ),
              ),
              const Divider(height: 20, thickness: 1),

              const SizedBox(height: 20),

              // 🔹 Copy button
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: SizedBox(
                  width: double.infinity,
                  height: 55,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF004C3F),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    onPressed: () async {
                      await Clipboard.setData(ClipboardData(text: shareLink));
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Link copied to clipboard")),
                      );
                    },
                    child: const Text(
                      "Copy",
                      style: TextStyle(fontSize: 18, color: Colors.white),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 40),

              const Text(
                "Share this link via",
                style: TextStyle(fontSize: 14, color: Colors.black54),
              ),
              const SizedBox(height: 20),

              // 🔹 Social icons
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: SvgPicture.asset(Images.facebookIcon, width: 28, height: 28),
                    onPressed: () => _shareToFacebook(shareLink),
                  ),
                  const SizedBox(width: 20),
                  IconButton(
                    icon: SvgPicture.asset(Images.whatsappIcon, width: 28, height: 28),
                    onPressed: () => _shareToWhatsApp(shareLink),
                  ),
                  const SizedBox(width: 20),
                  IconButton(
                    icon: SvgPicture.asset(Images.instagramIcon, width: 28, height: 28),
                    onPressed: () => _shareToInstagram(shareLink),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

