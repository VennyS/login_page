import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:login_page/components/text_field.dart';
import 'package:login_page/components/custom_button.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../screens/confirm.dart';
import 'package:login_page/components/phote_formatter.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  LoginPageState createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  final TextEditingController _phoneController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  // TODO: Странно работает при фокусе
  void _clearTextField() {
    _phoneController.clear();
  }

  @override
  void dispose() {
    _phoneController.dispose(); // Не забудьте освободить контроллер
    super.dispose();
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
        const SizedBox(height: 4),
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
          linkText('Персональных данных', () {
            print('Персональные данные');
          }),
          const TextSpan(
            text: ' и ',
          ),
          linkText('Пользовательским соглашением', () {
            print('Пользовательское соглашение');
          }),
        ],
      ),
    );
  }

  TextSpan linkText(String text, GestureTapCallback onTap) {
    return TextSpan(
      text: text,
      style: const TextStyle(color: Color(0xFFBA87FC)),
      recognizer: TapGestureRecognizer()..onTap = onTap,
    );
  }

  Widget middleTextField() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        sectionTitle("Введите номер телефона"),
        const SizedBox(height: 12),
        TextFieldWidget(
          unit: "+7",
          showUnit: true,
          placeHolder: "(XXX) XXX-XX-XX",
          showPlaceHolder: true,
          // TODO: поправить цвет иконки
          icon: SvgPicture.asset(
            "assets/svgs/cross.svg",
            height: 16,
            colorFilter:
                const ColorFilter.mode(Color(0xFF8F9098), BlendMode.dstIn),
          ),
          showIcon: true,
          typingStateColor: const Color(0xFFBA87FC),
          inputFormatter: PhoneNumberFormatter(),
          controller: _phoneController,
          onSuffixIconPressed: _clearTextField,
          keyboard: TextInputType.number,
        ),
        const SizedBox(height: 8),
        CustomButtonWidget(
          text: "Войти через Telegram",
          leftSvg: SvgPicture.asset(
            "assets/svgs/telegram_logo.svg",
            height: 12,
          ),
          accentColor: const Color(0xFF006FFD),
          showLeftSvg: true,
          variant: CustomButtonVariants.primary,
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const ConfirmPage()),
            );
          },
        ),
        const SizedBox(height: 16),
        richText(),
      ],
    );
  }

  Widget bottomLogo() {
    return SvgPicture.asset(
      "assets/svgs/gymatech_logo.svg",
      height: 20,
    );
  }

  Widget sectionTitle(String text) {
    return Text(
      text,
      textAlign: TextAlign.start,
      style: const TextStyle(
        fontFamily: 'Roboto',
        fontWeight: FontWeight.w500,
        fontSize: 20,
        letterSpacing: 0.1,
        height: 1,
      ),
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
