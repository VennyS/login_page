import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:login_page/components/text_field.dart';
import 'package:login_page/components/custom_button.dart';
import 'package:flutter_svg/flutter_svg.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  LoginPageState createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  @override
  void initState() {
    super.initState();
  }

  Widget topLogo() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        SvgPicture.asset(
          "assets/svgs/gymapp_logo.svg",
          height: 85,
          colorFilter: const ColorFilter.mode(Colors.black, BlendMode.dstIn),
        ),
        const SizedBox(
          height: 4,
        ),
        const Text(
          "ПРИЛОЖЕНИЕ ДЛЯ ФИТНЕС-КЛУБОВ",
          textAlign: TextAlign.center,
          style: TextStyle(
              fontFamily: 'Inter',
              fontWeight: FontWeight.w900,
              fontSize: 13,
              letterSpacing: -0.41,
              height: 22 / 13,
              color: Color(0xFFA03FFF)),
        ),
      ],
    );
  }

  Widget richText() {
    return RichText(
      text: TextSpan(
        style: const TextStyle(
          fontFamily: 'Inter',
          fontWeight: FontWeight.w400,
          fontSize: 14,
          color: Color(0xFF8F9098),
        ),
        children: [
          const TextSpan(
            text: 'Продолжая, вы соглашаетесь с обработкой ',
          ),
          TextSpan(
            text: 'Персональных данных',
            style: const TextStyle(
              color: Color(0xFFBA87FC),
            ),
            recognizer: TapGestureRecognizer()
              ..onTap = () {
                print('Персональные данные');
              },
          ),
          const TextSpan(
            text: ' и ',
          ),
          TextSpan(
            text: 'Пользовательским соглашением',
            style: const TextStyle(
              color: Color(0xFFBA87FC),
            ),
            recognizer: TapGestureRecognizer()
              ..onTap = () {
                print('Пользовательское соглашение');
              },
          ),
        ],
      ),
    );
  }

  Widget middleTextField() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text("Введите номер телефона",
            textAlign: TextAlign.start,
            style: TextStyle(
                fontFamily: 'Roboto',
                fontWeight: FontWeight.w500,
                fontSize: 20,
                letterSpacing: 0.1,
                height: 1)),
        // TODO: Что-то не так либо с виджетом TextFieldComponents, либо с отступом.
        const SizedBox(
          height: 2,
        ),
        const TextFieldComponents(),
        const SizedBox(
          height: 2,
        ),
        CustomButton(
            text: "Войти через Telegram",
            leftSvg: SvgPicture.asset(
              "assets/svgs/telegram_logo.svg",
              height: 12,
            ),
            accentColor: const Color(0xFF006FFD),
            showLeftSvg: true,
            variant: CustomButtonVariants.primary,
            // ignore: avoid_print
            onPressed: () => print("enter via telegram pressed")),
        const SizedBox(
          height: 16,
        ),
        richText(),
      ],
    );
  }

  Widget bottomLogo() {
    return Column(
      children: [
        SvgPicture.asset(
          "assets/svgs/gymatech_logo.svg",
          height: 20,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.fromLTRB(32, 96, 32, 16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            topLogo(),
            const Spacer(flex: 1),
            middleTextField(),
            const Spacer(flex: 3),
            bottomLogo(),
          ],
        ),
      ),
    );
  }
}
