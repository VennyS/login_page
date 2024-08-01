import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:login_page/components/text_field.dart';
import 'package:login_page/components/custom_button.dart';

// TODO: Поправить качество иконок
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
        Image.asset(
          "assets/pngs/gymapp_logo.png",
        ),
        const SizedBox(
          height: 4,
        ),
        const Text(
          "ПРИЛОЖЕНИЕ ДЛЯ ФИТНЕС-КЛУБОВ",
          textAlign: TextAlign.center,
          style: TextStyle(
              fontFamily: 'Inter',
              // TODO: Поправить.
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
            leftImage: "assets/pngs/telegram_logo.png",
            showLeftImage: true,
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
        Image.asset(
          "assets/pngs/gymatech_logo.png",
        ),
      ],
    );
  }

  // TODO: Поправить расположение верхнего лого.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.fromLTRB(32, 96, 32, 16),
        // padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 8),
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
