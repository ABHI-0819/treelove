import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:treelove/common/models/response.mode.dart';
import 'package:treelove/core/config/route/app_route.dart';
import 'package:treelove/core/widgets/common_notification.dart';
import 'package:treelove/features/authentication/models/login.request.model.dart';
import 'package:treelove/features/authentication/models/login.response.model.dart';
import 'package:treelove/features/authentication/screens/forgot_password_screen.dart';
import 'package:treelove/features/customer/b2b/home/screens/organization_home_screen.dart';


import '../../../common/bloc/api_event.dart';
import '../../../common/bloc/api_state.dart';
import '../../../common/repositories/login_repository.dart';
import '../../../core/config/constants/enum/input_enum.dart';
import '../../../core/config/constants/enum/notification_enum.dart';
import '../../../core/config/themes/app_fonts.dart';
import '../../../core/network/api_connection.dart';
import '../../../core/utils/device_identifier.dart';
import '../../customer/retail/home/screens/main_screen.dart';
import '../../fieldworker/home/screens/main_screen.dart';
import '../../vendor/home/screens/main-screen.dart';
import '../bloc/auth_bloc.dart';

class PasswordLoginScreen extends StatefulWidget {
  final String username;
  final InputType type;
  static const route = '/login-password';

  const PasswordLoginScreen(
      {super.key, required this.username, required this.type});

  @override
  State<PasswordLoginScreen> createState() => _PasswordLoginScreenState();
}

class _PasswordLoginScreenState extends State<PasswordLoginScreen> {
  late final AuthBloc _authBloc;
  final TextEditingController _passwordController = TextEditingController();
  final ValueNotifier<bool> _isSubmitting = ValueNotifier(false);
  bool _obscurePassword = true;

  @override
  void initState() {
    _authBloc = AuthBloc(LoginRepository(api: ApiConnection()));
    super.initState();
  }

  @override
  void dispose() {
    _passwordController.dispose();
    _authBloc.close();
    _isSubmitting.dispose();
    super.dispose();
  }

  Future<void> _onContinuePressed() async {
    final password = _passwordController.text.trim();

    if (password.isEmpty) {
      showNotification(
        context,
        message: 'Please enter your password',
        type: Not.warning,
      );
      return;
    }

    final deviceId = await DeviceIdentifier.getDeviceId();
    final String? email = widget.type == InputType.email ? widget.username : null;
    final String? phone = widget.type == InputType.phone ? widget.username : null;

    if (email == null && phone == null) {
      showNotification(
        context,
        message: 'Invalid login type. Please try again.',
        type: Not.warning,
      );
      return;
    }

    final request = LoginRequestModel(
      email: email,
      phone: phone,
      password: password,
      deviceId: deviceId.toString(),
    );

    _isSubmitting.value = true;
    EasyLoading.show(status: 'Logging in...');
    _authBloc.add(ApiAdd<LoginRequestModel>(request));
  }

  void _handleLoginSuccess(LoginResponseModel data) {
    final user = data.data.user;

    switch (user.groupName) {
      case 'retail_user':
        AppRoute.goToNextPage(
          context: context,
          screen: RetailMainScreen.route,
          arguments: {},
        );
        break;
      case 'fieldworker':
        AppRoute.goToNextPage(
          context: context,
          screen: FieldWorkerMainScreen.route,
          arguments: {},
        );
        break;
      case 'b2b_user':
        AppRoute.goToNextPage(
          context: context,
          screen: OrganizationHomeScreen.route,
          arguments: {},
        );
      // Handle b2b_user navigation
        break;
      case 'vendor':
        AppRoute.goToNextPage(
          context: context,
          screen: VendorMainScreen.route,
          arguments: {},
        );
      // Handle vendor navigation
        break;
      default:
        showNotification(
          context,
          message: 'Unknown user role.',
          type: Not.warning,
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFEFEF7),
      body: BlocProvider.value(
        value: _authBloc,
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: BlocListener<AuthBloc, ApiState<LoginResponseModel,ResponseModel>>(
              listener: (context, state) {
                _isSubmitting.value = false;
                EasyLoading.dismiss();
                if (state is ApiSuccess<LoginResponseModel, ResponseModel>) {
                  _handleLoginSuccess(state.data);
                } else if (state is ApiFailure<LoginResponseModel, ResponseModel>) {
                  showNotification(
                    context,
                    message: state.error.data.toString(), // Or customize based on ResponseModel structure
                    type: Not.failed,
                  );
                } else if (state is TokenExpired<LoginResponseModel, ResponseModel>) {
                  showNotification(
                    context,
                    message: state.error.message.toString(),
                    type: Not.warning,
                  );
                }
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildTopNav(),
                  const SizedBox(height: 32),
                  _buildTitle(),
                  const SizedBox(height: 24),
                  _buildForgotText(),
                  const SizedBox(height: 32),
                  _buildPasswordField(),
                  const SizedBox(height: 40),
                  _buildContinueButton(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }


  Widget _buildTopNav() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.pop(context),
        ),
      ],
    );
  }

  Widget _buildTitle() {
    return Text(
      'Your greens\ngetting closer',
      style: AppFonts.headline.copyWith(
        fontSize: 32,
        height: 1.3,
        color: Colors.black87,
      ),
    );
  }

  Widget _buildForgotText() {
    return RichText(
      text: TextSpan(
        style: const TextStyle(
          fontSize: 16,
          color: Colors.black,
          fontFamily: 'Sans',
        ),
        children: [
          const TextSpan(text: 'Forgot password? Enter the Email address '),
          TextSpan(
            text: 'here',
            style: const TextStyle(
              decoration: TextDecoration.underline,
              fontWeight: FontWeight.w500,
            ),
            recognizer: TapGestureRecognizer()
              ..onTap = () {
                AppRoute.goToNextPage(
                  context: context,
                  screen: ForgotPasswordScreen.route,
                  arguments: {},
                );
              },
          ),
          const TextSpan(text: ' associated with your account'),
        ],
      ),
    );
  }

  Widget _buildPasswordField() {
    return TextFormField(
      controller: _passwordController,
      obscureText: _obscurePassword,
      decoration: InputDecoration(
        labelText: 'Password',
        labelStyle: const TextStyle(color: Color(0xFFC9C2A8)),
        suffixIcon: IconButton(
          icon: Icon(
            _obscurePassword ? Icons.visibility_off : Icons.visibility,
          ),
          onPressed: () {
            setState(() {
              _obscurePassword = !_obscurePassword;
            });
          },
        ),
        enabledBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.black),
        ),
      ),
    );
  }

  Widget _buildContinueButton() {
    return ValueListenableBuilder<bool>(
      valueListenable: _isSubmitting,
      builder: (context, isSubmitting, _) {
        return SizedBox(
          width: double.infinity,
          height: 50,
          child: ElevatedButton(
            onPressed: isSubmitting ? null : _onContinuePressed,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF004D40),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(50),
              ),
            ),
            child: Text(
              isSubmitting ? 'Please wait...' : 'Continue',
              style: AppFonts.regular,
            ),
          ),
        );
      },
    );
  }
}


