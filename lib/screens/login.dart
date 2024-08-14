import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:login_page/api/api_service.dart';
import 'package:login_page/components/text_field.dart';
import 'package:login_page/components/custom_button.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:login_page/screens/confirm.dart';
import 'package:login_page/components/phote_formatter.dart';
import 'package:login_page/const.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  LoginPageState createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  final TextEditingController _phoneController = TextEditingController();
  GlobalKey<TextFieldWidgetState> textFieldKey =
      GlobalKey<TextFieldWidgetState>();
  String _responseMessage = '';
  bool _isPhoneElevenDigits = false;

  @override
  void initState() {
    _phoneController.addListener(_onTextChanged);
    super.initState();
  }

  void _clearTextField() {
    _phoneController.clear();
  }

  @override
  void dispose() {
    _phoneController.removeListener(_onTextChanged);
    _phoneController.dispose();
    super.dispose();
  }

  void _onTextChanged() {
    textFieldKey.currentState?.disableErrorState.call();
    setState(() {
      _isPhoneElevenDigits = _phoneController.text.length == 13;
    });
  }

  Future<void> _authPhone() async {
    setState(() {
      textFieldKey.currentState?.disableErrorState.call();
      _responseMessage = '';
    });

    try {
      final result = await ApiService()
          .processPhone(cleanPhoneNumber(_phoneController.text));

      if (mounted) {
        setState(() {
          _responseMessage = result;
        });

        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => ConfirmPage(
                    phone: cleanPhoneNumber(_phoneController.text),
                    responseMessage: _responseMessage,
                  )),
        );
      }
    } catch (error) {
      if (mounted) {
        setState(() {
          textFieldKey.currentState?.enableErrorState.call();
          _responseMessage = error.toString();
        });
      }
    }
  }

  Widget topLogo() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        SvgPicture.asset(
          SvgInfo.gymapplogo,
          height: 85,
          colorFilter: const ColorFilter.mode(Colors.black, BlendMode.dstIn),
        ),
        const SizedBox(height: 4),
        const Text("ПРИЛОЖЕНИЕ ДЛЯ ФИТНЕС-КЛУБОВ",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'Inter',
              fontWeight: FontWeight.w900,
              fontSize: 13,
              letterSpacing: -0.41,
              height: 22 / 13,
              color: ColorInfo.purpleDarkest,
            )),
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
          color: ColorInfo.darkGreyLightest,
        ),
        children: [
          const TextSpan(
            text: 'Продолжая, вы соглашаетесь с обработкой ',
          ),
          linkText('Персональных данных', () {}),
          const TextSpan(
            text: ' и ',
          ),
          linkText('Пользовательским соглашением', () {}),
        ],
      ),
    );
  }

  TextSpan linkText(String text, GestureTapCallback onTap) {
    return TextSpan(
      text: text,
      style: const TextStyle(color: ColorInfo.purpleDark),
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
          placeHolder: "XXX XXX-XX-XX",
          showPlaceHolder: true,
          icon: SvgPicture.asset(
            SvgInfo.cross,
            height: 16,
            colorFilter: const ColorFilter.mode(
                ColorInfo.darkGreyLightest, BlendMode.dstIn),
          ),
          showIcon: true,
          typingStateColor: ColorInfo.purpleDark,
          inputFormatter: PhoneNumberFormatter(),
          controller: _phoneController,
          onSuffixIconPressed: _clearTextField,
          keyboard: TextInputType.number,
        ),
        const SizedBox(height: 8),
        CustomButtonWidget(
          text: "Войти через Telegram",
          leftSvg: SvgPicture.asset(
            SvgInfo.telegramlogo,
            colorFilter: ColorFilter.mode(
                _isPhoneElevenDigits
                    ? Colors.white
                    : ColorInfo.darkGreyLightest,
                BlendMode.srcIn),
            height: 12,
          ),
          textColor: _isPhoneElevenDigits ? null : ColorInfo.darkGreyLightest,
          accentColor: _isPhoneElevenDigits
              ? ColorInfo.highlightDarkest
              : ColorInfo.purpleGreyLight,
          showLeftSvg: true,
          variant: CustomButtonVariants.primary,
          onPressed: _isPhoneElevenDigits ? _authPhone : null,
        ),
        const SizedBox(height: 16),
        richText(),
      ],
    );
  }

  Widget bottomLogo() {
    return SvgPicture.asset(
      SvgInfo.gymatechlogo,
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

  String cleanPhoneNumber(String formattedPhoneNumber) {
    return "7${formattedPhoneNumber.replaceAll(RegExp(r'\D'), '')}";
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
