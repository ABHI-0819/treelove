import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../config/themes/app_color.dart';
import '../config/themes/app_fonts.dart';

class InputField extends StatefulWidget {
  final TextEditingController controller;
  final String labelText;
  final String hintText;
  final String? asterisk;
  final bool enable;
  final String? prefixText;
  final String? errorText;
  final InputBorder? border;
  final TextInputType inputType;
  final String? suffixText;
  final Widget? suffixIcon;
  final bool isSecret;
  final String? obscuringCharacter;
  final bool hideCounter;
  final bool isAutoCorrect;
  final int? maxlength;
  final int? maxline;
  final List<TextInputFormatter>? inputFormatters;
  final Function(String)? onValueChanged;
  final Function()? onEditingComplete;
  final Function(String)? onFieldSubmitted;
  final String? Function(String?)? onValidator;

  InputField(
      {required this.controller,
        required this.hintText,
        required this.labelText,
        this.asterisk,
        this.enable = true,
        this.prefixText,
        this.errorText,
        this.border,
        this.isSecret = false,
        this.obscuringCharacter,
        this.hideCounter = false,
        this.isAutoCorrect = true,
        this.suffixIcon,
        this.suffixText,
        this.inputType = TextInputType.text,
        this.maxlength,
        this.maxline,
        this.inputFormatters,
        this.onValueChanged,
        this.onEditingComplete,
        this.onFieldSubmitted,
        this.onValidator})
      : assert(controller != null, "Controlled can't be null"),
        assert(hintText != null, "HintText can't be null");

  @override
  _InputFieldState createState() => _InputFieldState();
}

class _InputFieldState extends State<InputField> {
  bool __isSecret = false;
  bool __isEnable = true;

  @override
  initState() {
    __isSecret = widget.isSecret;
    __isEnable = widget.enable;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60.h,
      padding: EdgeInsets.symmetric(vertical: 5.h!,horizontal: 5.w!),
      decoration: BoxDecoration(
        color: AppColor.white,
        border: Border.all(
          color: Colors.black, // Change border color
          width: 0.1, // Change border width
        ),
        borderRadius: BorderRadius.circular(8.r!),
      ),
      child: Center(
          child: TextFormField(
            autocorrect: widget.isAutoCorrect,
            enabled: widget.enable,
            obscureText: __isSecret,
            obscuringCharacter: widget.obscuringCharacter ?? '*',
            maxLength: widget.maxlength,
            controller: widget.controller,
            onChanged: widget.onValueChanged,
            onEditingComplete: widget.onEditingComplete,
            onFieldSubmitted: widget.onFieldSubmitted,
            validator: widget.onValidator,
            keyboardType: widget.inputType,
            style: AppFonts.regular,
            textInputAction: TextInputAction.next,
            inputFormatters: widget.inputFormatters,
            autovalidateMode: AutovalidateMode.always,
            maxLines: widget.maxline ?? 1,
            // enableInteractiveSelection: false,
            decoration: InputDecoration(

              label: RichText(
                text: TextSpan(children: [
                  TextSpan(
                      text: widget.labelText,
                      style:const  TextStyle(color: Colors.black)),
                  TextSpan(
                      text: widget.asterisk,
                      style: TextStyle(color: Colors.red, fontSize: 14.sp))
                ]),
              ),
              // labelText: widget.labelText,
              hintText: widget.hintText,
              suffixText: widget.suffixText,
              errorText: widget.errorText,
              border: InputBorder.none,
              contentPadding: EdgeInsets.only(
                left: 10.r!,
                bottom: 10.r!,
              ),
              suffixIcon: widget.isSecret == true
                  ? GestureDetector(
                onTap: () {
                  setState(() {
                    __isSecret = !__isSecret;
                  });
                },
                child: __isSecret
                    ? const Icon(
                  Icons.visibility_off,
                  color: AppColor.textMuted,
                )
                    : const Icon(
                  Icons.visibility,
                  color: AppColor.textMuted,
                ),
              )
                  : widget.suffixIcon,
            ),
          )),
    );
  }
}

class SecondaryInputField extends StatefulWidget {
  final TextEditingController controller;
  final String labelText;
  final String hintText;
  final String? asterisk;
  final bool enable;
  final String? prefixText;
  final String? errorText;
  final InputBorder? border;
  final TextInputType inputType;
  final String? suffixText;
  final Widget? suffixIcon;
  final bool isSecret;
  final String? obscuringCharacter;
  final bool hideCounter;
  final bool isAutoCorrect;
  final int? maxlength;
  final int? maxline;
  final List<TextInputFormatter>? inputFormatters;
  final Function(String)? onValueChanged;
  final Function()? onEditingComplete;
  final Function(String)? onFieldSubmitted;
  final String? Function(String?)? onValidator;

  SecondaryInputField(
      {required this.controller,
        required this.labelText,
        required this.hintText,
        this.asterisk,
        this.enable = true,
        this.prefixText,
        this.errorText,
        this.border,
        this.isSecret = false,
        this.obscuringCharacter,
        this.hideCounter = false,
        this.isAutoCorrect = true,
        this.suffixIcon,
        this.suffixText,
        this.inputType = TextInputType.text,
        this.maxlength,
        this.maxline,
        this.inputFormatters,
        this.onValueChanged,
        this.onEditingComplete,
        this.onFieldSubmitted,
        this.onValidator})
      : assert(controller != null, "Controller can't be null"),
        assert(hintText != null, "HintText can't be null");

  @override
  _SecondaryInputFieldState createState() => _SecondaryInputFieldState();
}

class _SecondaryInputFieldState extends State<SecondaryInputField> {
  bool __isSecret = false;

  @override
  initState() {
    __isSecret = widget.isSecret;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(children: [
            TextSpan(
                text: widget.labelText,
                style:const  TextStyle(color:  AppColor.primary)),
            TextSpan(
                text: widget.asterisk,
                style: TextStyle(color: Colors.red, fontSize: 14.sp))
          ]),
        ),
        // Text(widget.labelText,style: AppFonts.small.copyWith(
        //   color: AppColor.primaryColor
        // )),
        SizedBox(
          height: 2.h,
        ),
        Container(
          padding: EdgeInsets.symmetric(vertical: 2.h!, horizontal: 5.w!),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(
              color: AppColor.textMuted,
              width: 0.6,
            ),
            borderRadius: BorderRadius.circular(8.r!),
          ),
          child: Center(
            child:  TextFormField(
              autocorrect: widget.isAutoCorrect,
              enabled: widget.enable,
              obscureText: __isSecret,
              obscuringCharacter: widget.obscuringCharacter ?? '*',
              maxLength: widget.maxlength,
              controller: widget.controller,
              onChanged: widget.onValueChanged,
              onEditingComplete: widget.onEditingComplete,
              onFieldSubmitted: widget.onFieldSubmitted,
              validator: widget.onValidator,
              keyboardType: widget.inputType,
              maxLines: widget.maxline ?? 1,
              inputFormatters: widget.inputFormatters,
              autovalidateMode: AutovalidateMode.always,
              style:AppFonts.body.copyWith(color: AppColor.black),
              decoration: InputDecoration(
                hintStyle: AppFonts.body.copyWith(color: AppColor.textMuted),
                hintText: widget.hintText,
                suffixText: widget.suffixText,
                errorText: widget.errorText,
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(horizontal: 10.w!,vertical: 10.h!),
                suffixIcon: widget.isSecret
                    ? GestureDetector(
                  onTap: () {
                    setState(() {
                      __isSecret = !__isSecret;
                    });
                  },
                  child: Icon(
                    __isSecret ? Icons.visibility_off : Icons.visibility,
                    color: AppColor.primary,
                  ),
                )
                    : widget.suffixIcon,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class InputTextField extends StatefulWidget {
  final TextEditingController controller;
  final String labelText;
  final String hintText;
  final bool isSecret;
  final bool obscureText;
  final Widget ? suffixIcon;
  final Color ? bgColor;
  final TextInputType inputType;
  final double ? widthSize ;
  final int? maxline;

  InputTextField({
    super.key,
    required this.controller,
    required this.labelText,
    required this.hintText,
    this.isSecret = false,
    this.suffixIcon,
    this.bgColor = AppColor.textMuted,
    this.obscureText = false, // Fixed typo and default value syntax
    this.inputType = TextInputType.text,
    this.widthSize,
    this.maxline
  });

  @override
  State<InputTextField> createState() => _InputTextFieldState();
}

class _InputTextFieldState extends State<InputTextField> {
  bool __isSecret = false;
  @override
  initState() {
    __isSecret = widget.isSecret;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    late final double width = widget.widthSize ?? 1.sw;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.labelText,
          style: AppFonts.body
              .copyWith(fontWeight: FontWeight.w600, color: AppColor.black),
        ),
        SizedBox(height: 6.h),
        SizedBox(
          width: width,
          child: TextFormField(
            controller: widget.controller,
            obscureText: __isSecret,
            keyboardType: widget.inputType,
            obscuringCharacter: '*',
            maxLines: widget.maxline ?? 1,
            style: AppFonts.caption.copyWith(fontWeight: FontWeight.w600, color: AppColor.black),
            decoration: InputDecoration(
              hintText: widget.hintText,
              hintStyle: AppFonts.caption
                  .copyWith(fontWeight: FontWeight.w400, color: AppColor.textMuted),
              filled: true,
              // Background fill
              fillColor: AppColor.secondary.withOpacity(0.1),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.r), // Rounded corners
                borderSide: BorderSide.none, // No border line
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.r),
                borderSide: BorderSide(color: Colors.grey[100]!),
              ),
              suffixIcon: widget.isSecret == true
                  ? GestureDetector(
                onTap: () {
                  setState(() {
                    __isSecret = !__isSecret;
                  });
                },
                child: __isSecret
                    ? const Icon(
                  Icons.visibility_off,
                  color: AppColor.textMuted,
                )
                    : const Icon(
                  Icons.visibility,
                  color: AppColor.textMuted,
                ),
              )
                  : widget.suffixIcon,
            ),
          ),
        ),
      ],
    );
  }
}