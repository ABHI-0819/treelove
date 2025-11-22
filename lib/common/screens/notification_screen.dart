/*

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../core/config/themes/app_color.dart';



// Notification Model
class NotificationModel {
  final String id;
  final String title;
  final String message;
  final String type;
  bool isRead;
  final DateTime createdAt;

  NotificationModel({
    required this.id,
    required this.title,
    required this.message,
    required this.type,
    required this.isRead,
    required this.createdAt,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['id'],
      title: json['title'],
      message: json['message'],
      type: json['type'],
      isRead: json['is_read'],
      createdAt: DateTime.parse(json['created_at']),
    );
  }
}

// Notifications Screen
class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({Key? key}) : super(key: key);

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  List<NotificationModel> notifications = [];
  String selectedTab = 'All';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _loadNotifications();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _loadNotifications() {
    final sampleData = [
      {
        "id": "1",
        "title": "Almost Gone",
        "message": "Limited-time offer! Enjoy up to 40% off on selected furniture. Don't miss out! shop now before it's too late!",
        "type": "promo",
        "is_read": false,
        "created_at": "2025-10-18T12:00:00.000Z"
      },
      {
        "id": "2",
        "title": "Limited Offer! Claim \$50.00 Voucher",
        "message": "Sign up now and enjoy a \$50.00 voucher on your first purchase! Don't miss out.",
        "type": "promo",
        "is_read": false,
        "created_at": "2025-10-18T11:00:00.000Z"
      },
      {
        "id": "3",
        "title": "Unlock Your Exclusive Gift",
        "message": "Sign up now and enjoy a \$50.00 voucher on your first purchase! Don't miss out.",
        "type": "promo",
        "is_read": false,
        "created_at": "2025-10-18T10:00:00.000Z"
      },
      {
        "id": "4",
        "title": "Order Confirmed",
        "message": "We're preparing your order and will notify you once it's shipped. Track your order status anytime through the app.",
        "type": "order",
        "is_read": false,
        "created_at": "2025-10-18T09:00:00.000Z"
      },
      {
        "id": "5",
        "title": "Order Shipped",
        "message": "Great news! Your order has been shipped and is on its way to you. Expected delivery by 3 days. You can track your order.",
        "type": "order",
        "is_read": false,
        "created_at": "2025-10-18T08:00:00.000Z"
      },
      {
        "id": "6",
        "title": "Payment Received",
        "message": "Great news! The payment for your recent sale has been successfully processed. You can now check your balance.",
        "type": "payment",
        "is_read": false,
        "created_at": "2025-10-18T07:00:00.000Z"
      },
    ];

    setState(() {
      notifications = sampleData.map((e) => NotificationModel.fromJson(e)).toList();
    });
  }

  String _formatTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inMinutes < 60) return '${difference.inMinutes}m ago';
    if (difference.inHours < 24) return '${difference.inHours}h ago';
    return '${difference.inDays}d ago';
  }

  IconData _getNotificationIcon(String type) {
    switch (type) {
      case 'promo':
        return Icons.local_offer_outlined;
      case 'order':
        return Icons.shopping_bag_outlined;
      case 'payment':
        return Icons.payments_outlined;
      default:
        return Icons.notifications_outlined;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.white,
      appBar: AppBar(
        backgroundColor: AppColor.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColor.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Notification',
          style: TextStyle(
            color: AppColor.black,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(48),
          child: Container(
            color: AppColor.white,
            child: TabBar(
              controller: _tabController,
              labelColor: AppColor.primary,
              unselectedLabelColor: AppColor.textMuted,
              indicatorColor: AppColor.primary,
              indicatorWeight: 2,
              labelStyle: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
              unselectedLabelStyle: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w400,
              ),
              tabs: const [
                Tab(text: 'All'),
                Tab(text: 'Buyer'),
                Tab(text: 'Seller'),
                Tab(text: 'Promo'),
              ],
              onTap: (index) {
                setState(() {
                  selectedTab = ['All', 'Buyer', 'Seller', 'Promo'][index];
                });
              },
            ),
          ),
        ),
      ),
      body: notifications.isEmpty
          ? _buildEmptyState()
          : ListView.separated(
        padding: const EdgeInsets.symmetric(vertical: 8),
        itemCount: notifications.length,
        separatorBuilder: (context, index) => const Divider(
          height: 1,
          thickness: 1,
          color: AppColor.divider,
        ),
        itemBuilder: (context, index) {
          return _buildNotificationItem(notifications[index]);
        },
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.notifications_none,
            size: 64,
            color: AppColor.textMuted,
          ),
          const SizedBox(height: 16),
          Text(
            'No notifications yet',
            style: TextStyle(
              color: AppColor.textMuted,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationItem(NotificationModel notification) {
    return InkWell(
      onTap: () {
        setState(() {
          notification.isRead = true;
        });
      },
      child: Container(
        color: notification.isRead ? AppColor.white : AppColor.background,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: AppColor.accent.withOpacity(0.15),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                _getNotificationIcon(notification.type),
                color: AppColor.accent,
                size: 22,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          notification.title,
                          style: TextStyle(
                            color: AppColor.textPrimary,
                            fontSize: 14,
                            fontWeight: notification.isRead
                                ? FontWeight.w500
                                : FontWeight.w600,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Row(
                        children: [
                          Text(
                            _formatTime(notification.createdAt),
                            style: const TextStyle(
                              color: AppColor.textMuted,
                              fontSize: 12,
                            ),
                          ),
                          if (!notification.isRead) ...[
                            const SizedBox(width: 8),
                            Container(
                              width: 8,
                              height: 8,
                              decoration: const BoxDecoration(
                                color: AppColor.accent,
                                shape: BoxShape.circle,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    notification.message,
                    style: TextStyle(
                      color: AppColor.textSecondary,
                      fontSize: 13,
                      height: 1.4,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}


import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../core/config/themes/app_color.dart';


// Notification Model
class NotificationModel {
  final String id;
  final String user;
  final String userName;
  final String title;
  final String message;
  final String type;
  final String typeDisplay;
  final String? relatedObjectType;
  final String? relatedObjectId;
  bool isRead;
  final bool isActionable;
  final DateTime createdAt;

  NotificationModel({
    required this.id,
    required this.user,
    required this.userName,
    required this.title,
    required this.message,
    required this.type,
    required this.typeDisplay,
    this.relatedObjectType,
    this.relatedObjectId,
    required this.isRead,
    required this.isActionable,
    required this.createdAt,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['id'],
      user: json['user'],
      userName: json['user_name'],
      title: json['title'],
      message: json['message'],
      type: json['type'],
      typeDisplay: json['type_display'],
      relatedObjectType: json['related_object_type'],
      relatedObjectId: json['related_object_id'],
      isRead: json['is_read'],
      isActionable: json['is_actionable'],
      createdAt: DateTime.parse(json['created_at']),
    );
  }
}

// Notifications Screen
class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({Key? key}) : super(key: key);

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  List<NotificationModel> notifications = [];
  String selectedTab = 'All';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _loadNotifications();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _loadNotifications() {
    // Replace this with your actual API call
    final sampleData = [
      {
        "id": "0ebaf147-0bfa-45e4-84ed-b1662ddd55fe",
        "user": "f007d987-3b8f-4821-9955-fca63cfaf234",
        "user_name": "rahulfw@gmail.com",
        "title": "Test Notification",
        "message": "This is a test notification from the management command",
        "type": "system",
        "type_display": "System",
        "related_object_type": null,
        "related_object_id": null,
        "is_read": false,
        "is_actionable": false,
        "created_at": "2025-10-18T14:56:52.577771+05:30"
      },
      {
        "id": "90f74e38-53b9-4680-a154-759daaa92cdb",
        "user": "f007d987-3b8f-4821-9955-fca63cfaf234",
        "user_name": "rahulfw@gmail.com",
        "title": "Test Notification",
        "message": "This is a test notification from the management command",
        "type": "system",
        "type_display": "System",
        "related_object_type": null,
        "related_object_id": null,
        "is_read": false,
        "is_actionable": false,
        "created_at": "2025-10-18T14:56:45.897212+05:30"
      },
      {
        "id": "ef305ed4-52a8-4c91-a70d-1bd05c38038e",
        "user": "f007d987-3b8f-4821-9955-fca63cfaf234",
        "user_name": "rahulfw@gmail.com",
        "title": "Device Registered",
        "message": "Your device has been successfully registered for push notifications",
        "type": "system",
        "type_display": "System",
        "related_object_type": null,
        "related_object_id": null,
        "is_read": false,
        "is_actionable": false,
        "created_at": "2025-10-18T12:52:52.573038+05:30"
      }
    ];

    setState(() {
      notifications = sampleData.map((e) => NotificationModel.fromJson(e)).toList();
    });
  }

  String _formatTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inMinutes < 60) return '${difference.inMinutes}m ago';
    if (difference.inHours < 24) return '${difference.inHours}h ago';
    if (difference.inDays < 7) return '${difference.inDays}d ago';
    return DateFormat('MMM dd').format(dateTime);
  }

  IconData _getNotificationIcon(String type) {
    switch (type.toLowerCase()) {
      case 'alert':
        return Icons.warning_amber_outlined;
      case 'system':
        return Icons.info_outline;
      case 'promotion':
        return Icons.local_offer_outlined;
      case 'reminder':
        return Icons.notifications_active_outlined;
      default:
        return Icons.notifications_outlined;
    }
  }

  Color _getIconColor(String type) {
    switch (type.toLowerCase()) {
      case 'alert':
        return AppColor.error;
      case 'system':
        return AppColor.primary;
      case 'promotion':
        return AppColor.accent;
      case 'reminder':
        return AppColor.secondary;
      default:
        return AppColor.textMuted;
    }
  }

  List<NotificationModel> _getFilteredNotifications() {
    if (selectedTab == 'All') {
      return notifications;
    }
    return notifications.where((n) =>
    n.typeDisplay.toLowerCase() == selectedTab.toLowerCase()
    ).toList();
  }

  @override
  Widget build(BuildContext context) {
    final filteredNotifications = _getFilteredNotifications();

    return Scaffold(
      backgroundColor: AppColor.white,
      appBar: AppBar(
        backgroundColor: AppColor.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColor.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Notification',
          style: TextStyle(
            color: AppColor.black,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(48),
          child: Container(
            color: AppColor.white,
            child: TabBar(
              controller: _tabController,
              labelColor: AppColor.primary,
              unselectedLabelColor: AppColor.textMuted,
              indicatorColor: AppColor.primary,
              indicatorWeight: 2,
              labelStyle: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
              unselectedLabelStyle: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w400,
              ),
              tabs: const [
                Tab(text: 'All'),
                Tab(text: 'Alert'),
                Tab(text: 'System'),
                Tab(text: 'Promotion'),
              ],
              onTap: (index) {
                setState(() {
                  selectedTab = ['All', 'Alert', 'System', 'Promotion'][index];
                });
              },
            ),
          ),
        ),
      ),
      body: filteredNotifications.isEmpty
          ? _buildEmptyState()
          : ListView.separated(
        padding: const EdgeInsets.symmetric(vertical: 8),
        itemCount: filteredNotifications.length,
        separatorBuilder: (context, index) => const Divider(
          height: 1,
          thickness: 1,
          color: AppColor.divider,
          indent: 72,
        ),
        itemBuilder: (context, index) {
          return _buildNotificationItem(filteredNotifications[index]);
        },
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.notifications_none,
            size: 64,
            color: AppColor.textMuted,
          ),
          const SizedBox(height: 16),
          Text(
            'No notifications yet',
            style: TextStyle(
              color: AppColor.textMuted,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationItem(NotificationModel notification) {
    return InkWell(
      onTap: () {
        setState(() {
          notification.isRead = true;
        });
        // Add your navigation or action here
      },
      child: Container(
        color: notification.isRead ? AppColor.white : AppColor.background.withOpacity(0.3),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: _getIconColor(notification.type).withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                _getNotificationIcon(notification.type),
                color: _getIconColor(notification.type),
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          notification.title,
                          style: TextStyle(
                            color: AppColor.textPrimary,
                            fontSize: 14,
                            fontWeight: notification.isRead
                                ? FontWeight.w500
                                : FontWeight.w600,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Row(
                        children: [
                          Text(
                            _formatTime(notification.createdAt),
                            style: const TextStyle(
                              color: AppColor.textMuted,
                              fontSize: 12,
                            ),
                          ),
                          if (!notification.isRead) ...[
                            const SizedBox(width: 6),
                            Container(
                              width: 7,
                              height: 7,
                              decoration: BoxDecoration(
                                color: _getIconColor(notification.type),
                                shape: BoxShape.circle,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    notification.message,
                    style: const TextStyle(
                      color: AppColor.textSecondary,
                      fontSize: 13,
                      height: 1.4,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

 */
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:treelove/common/bloc/notification_bloc.dart';
import 'package:treelove/common/repositories/notification_repository.dart';
import '../../core/config/themes/app_color.dart';
import '../../core/network/api_connection.dart';
import '../../core/widgets/common_notification.dart';
import '../bloc/api_event.dart';
import '../bloc/api_state.dart';
import '../models/notifications_response_model.dart';
import '../models/response.mode.dart';

class NotificationModel {
  final String id;
  final String user;
  final String userName;
  final String title;
  final String message;
  final String type;
  final String typeDisplay;
  final String? relatedObjectType;
  final String? relatedObjectId;
  bool isRead;
  final bool isActionable;
  final DateTime createdAt;

  NotificationModel({
    required this.id,
    required this.user,
    required this.userName,
    required this.title,
    required this.message,
    required this.type,
    required this.typeDisplay,
    this.relatedObjectType,
    this.relatedObjectId,
    required this.isRead,
    required this.isActionable,
    required this.createdAt,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['id'],
      user: json['user'],
      userName: json['user_name'],
      title: json['title'],
      message: json['message'],
      type: json['type'],
      typeDisplay: json['type_display'],
      relatedObjectType: json['related_object_type'],
      relatedObjectId: json['related_object_id'],
      isRead: json['is_read'],
      isActionable: json['is_actionable'],
      createdAt: DateTime.parse(json['created_at']),
    );
  }
}

class NotificationsScreen extends StatefulWidget {
  static const route ='/notification';
  const NotificationsScreen({Key? key}) : super(key: key);

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String selectedTab = 'All';

  late NotificationBloc notificationBloc;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    notificationBloc = NotificationBloc(NotificationRepository(api: ApiConnection()));
    notificationBloc.add(ApiListFetch());
  }

  @override
  void dispose() {
    _tabController.dispose();
    notificationBloc.close();
    super.dispose();
  }

  String _formatTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inMinutes < 60) return '${difference.inMinutes}m ago';
    if (difference.inHours < 24) return '${difference.inHours}h ago';
    if (difference.inDays < 7) return '${difference.inDays}d ago';
    return DateFormat('MMM dd').format(dateTime);
  }

  IconData _getNotificationIcon(String type) {
    switch (type.toLowerCase()) {
      case 'alert':
        return Icons.warning_amber_outlined;
      case 'system':
        return Icons.info_outline;
      case 'promotion':
        return Icons.local_offer_outlined;
      case 'reminder':
        return Icons.notifications_active_outlined;
      default:
        return Icons.notifications_outlined;
    }
  }

  Color _getIconColor(String type) {
    switch (type.toLowerCase()) {
      case 'alert':
        return AppColor.error;
      case 'system':
        return AppColor.primary;
      case 'promotion':
        return AppColor.accent;
      case 'reminder':
        return AppColor.secondary;
      default:
        return AppColor.textMuted;
    }
  }

  List<NotificationModel> _getFilteredNotifications(List<NotificationModel> all) {
    if (selectedTab == 'All') return all;
    return all.where((n) =>
    n.typeDisplay.toLowerCase() == selectedTab.toLowerCase()
    ).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.white,
      appBar: AppBar(
        backgroundColor: AppColor.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColor.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Notification',
          style: TextStyle(
            color: AppColor.black,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(48),
          child: Container(
            color: AppColor.white,
            child: TabBar(
              controller: _tabController,
              labelColor: AppColor.primary,
              unselectedLabelColor: AppColor.textMuted,
              indicatorColor: AppColor.primary,
              indicatorWeight: 2,
              labelStyle: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
              unselectedLabelStyle: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w400,
              ),
              tabs: const [
                Tab(text: 'All'),
                Tab(text: 'Alert'),
                Tab(text: 'System'),
                Tab(text: 'Promotion'),
              ],
              onTap: (index) {
                setState(() {
                  selectedTab = ['All', 'Alert', 'System', 'Promotion'][index];
                });
              },
            ),
          ),
        ),
      ),
      body: BlocProvider(
  create: (context) => notificationBloc,
  child: BlocConsumer<NotificationBloc, ApiState<NotificationResponse, ResponseModel>>(
        listener: (context, state) {
          if (state is TokenExpired<NotificationResponse, ResponseModel>) {
            // Handle token expiry: redirect to login
            // Example:
            // Navigator.of(context).pushNamedAndRemoveUntil('/login', (route) => false);
          } else if (state is ApiFailure<NotificationResponse, ResponseModel>) {
            // Optional: show snackbar for non-critical errors
            showNotification(context, message: state.error.message.toString());
          }
        },
        builder: (context, state) {
          if (state is ApiLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is ApiSuccess<NotificationResponse, ResponseModel>) {
            // Map API response to NotificationModel list
            final notifications = state.data.data
                .map((item) => NotificationModel(
              id: item.id,
              user: item.user,
              userName: item.userName,
              title: item.title,
              message: item.message,
              type: item.type,
              typeDisplay: item.typeDisplay,
              relatedObjectType: item.relatedObjectType,
              relatedObjectId: item.relatedObjectId,
              isRead: item.isRead,
              isActionable: item.isActionable,
              createdAt: item.createdAt,
            ))
                .toList();

            final filtered = _getFilteredNotifications(notifications);

            if (filtered.isEmpty) {
              return _buildEmptyState();
            }

            return ListView.separated(
              padding: const EdgeInsets.symmetric(vertical: 8),
              itemCount: filtered.length,
              separatorBuilder: (context, index) => const Divider(
                height: 1,
                thickness: 1,
                color: AppColor.divider,
                indent: 72,
              ),
              itemBuilder: (context, index) {
                return _buildNotificationItem(filtered[index], () {
                  // Mark as read locally (UI only)
                  setState(() {
                    filtered[index].isRead = true;
                  });

                  // TODO: Optionally call API to mark as read if needed
                  // e.g., repository.markAsRead(filtered[index].id);
                });
              },
            );
          } else if (state is ApiFailure<NotificationResponse, ResponseModel>) {
            return _buildErrorState(state.error.message.toString());
          } else {
            // ApiInitial or unknown
            return const Center(child: Text('Ready...'));
          }
        },
      ),
),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.notifications_none,
            size: 64,
            color: AppColor.textMuted,
          ),
          const SizedBox(height: 16),
          Text(
            'No notifications yet',
            style: TextStyle(
              color: AppColor.textMuted,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, size: 64, color: AppColor.error),
          const SizedBox(height: 16),
          Text(
            message,
            textAlign: TextAlign.center,
            style: TextStyle(color: AppColor.textPrimary, fontSize: 16),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () {
              context.read<NotificationBloc>().add(ApiListFetch());
            },
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationItem(NotificationModel notification, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        color: notification.isRead ? AppColor.white : AppColor.background.withOpacity(0.3),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: _getIconColor(notification.type).withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                _getNotificationIcon(notification.type),
                color: _getIconColor(notification.type),
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          notification.title,
                          style: TextStyle(
                            color: AppColor.textPrimary,
                            fontSize: 14,
                            fontWeight: notification.isRead
                                ? FontWeight.w500
                                : FontWeight.w600,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Row(
                        children: [
                          Text(
                            _formatTime(notification.createdAt),
                            style: const TextStyle(
                              color: AppColor.textMuted,
                              fontSize: 12,
                            ),
                          ),
                          if (!notification.isRead) ...[
                            const SizedBox(width: 6),
                            Container(
                              width: 7,
                              height: 7,
                              decoration: BoxDecoration(
                                color: _getIconColor(notification.type),
                                shape: BoxShape.circle,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    notification.message,
                    style: const TextStyle(
                      color: AppColor.textSecondary,
                      fontSize: 13,
                      height: 1.4,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

