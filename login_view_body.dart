import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:uni_project/constants.dart';
import 'package:uni_project/core/utils/app_colors.dart';
import 'package:uni_project/core/widgets/custom_button.dart';
import 'package:uni_project/core/widgets/custom_text_field.dart';

class LoginViewBody extends StatelessWidget {
  const LoginViewBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: kHorizintalPadding),
      child: SingleChildScrollView(

        child: Column(
          children: [
            SizedBox(height: 24,),
            CustomTextFormField(hintText: 'البريد الالكتروني', textInputType:TextInputType.emailAddress ),
            SizedBox(height: 16),
            CustomTextFormField(hintText: 'كلمة المرور',
              textInputType:TextInputType.visiblePassword,
              suffixIcon: Icon(Icons.remove_red_eye),

            ),
            SizedBox(height: 16,),
            Text(
              'نسيت كبمة المرور؟',
              style: TextStyle(
                color: AppColors.lightPrimaryColor,
                fontSize: 13,
                fontFamily: 'Cairo',
                fontWeight: FontWeight.w600,
                height: 0.13
              ),
            ),

            SizedBox(height: 32,),
            
            CustomButton(onPressed: (){}, text: 'تسجيل الدخول'),
            SizedBox(height: 16,),
            Text.rich(TextSpan(
              children:
                [
                  TextSpan(
                    text: 'قم بأنشاء حساب',
                    style: TextStyle(
                      color: Color(0xFF1B5E37),
                      fontSize: 16,
                      fontFamily: 'Cairo',
                      fontWeight: FontWeight.w600,
                      height: 0.09,
                    ),

                  ),
                TextSpan(
                    text: ' ',
                    style: TextStyle(
                      color: Color(0xFF616A68),
                      fontSize: 16,
                      fontFamily: 'Cairo',
                      fontWeight: FontWeight.w600,
                      height: 0.09,
                    ),
                ),
                  TextSpan(
                    text: 'لا تمتلك حساب ',
                    style: TextStyle(
                      color: Color(0xFF949D9E),
                      fontSize: 16,
                      fontFamily: 'Cairo',
                      fontWeight: FontWeight.w600,
                      height: 0.09,
                    ),
                  )
                ]
                ),
              
            ),


          ],

        ),
      ),
    );
  }
}
