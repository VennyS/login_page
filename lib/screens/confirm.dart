import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:login_page/api/api_service.dart';
import 'package:login_page/components/code_form.dart';
import 'package:login_page/components/custom_button.dart';
import 'package:login_page/screens/base.dart';
import 'package:url_launcher/url_launcher.dart';

class ConfirmPage extends StatefulWidget {
  final String phone;
  final String responseMessage;
  const ConfirmPage(
      {super.key, required this.phone, required this.responseMessage});

  @override
  ConfirmPageState createState() => ConfirmPageState();
}

class ConfirmPageState extends State<ConfirmPage> {
  late int enteredCode = 0;
  late bool isCodeCorrect = true;
  late bool isCodeValid = false;
  late String response;

  final GlobalKey<CodeInputWidgetState> _codeInputKey =
      GlobalKey<CodeInputWidgetState>();

  late Timer _timer;
  int _start = 60; // Начальное время таймера

  bool _showResendButton = false;
  String _timerText = 'Отправить повторно через 60 секунд';

  @override
  void initState() {
    super.initState();
    response = widget.responseMessage;
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_start == 0) {
        setState(() {
          _timer.cancel();
          _showResendButton = true;
          _timerText = 'Отправить повторно';
        });
      } else {
        setState(() {
          _start--;
          _timerText = 'Отправить повторно через $_start секунд';
        });
      }
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFD4D6DD),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 32),
        child: SingleChildScrollView(
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              color: Colors.white,
            ),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(8, 8, 8, 64),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _topPart(context),
                  const SizedBox(height: 36),
                  _choosedMiddlePart(response),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _choosedMiddlePart(String response) {
    switch (response) {
      case "verified phone at telegram":
      case "https://t.me/GAAuthTest_bot":
        return _botIsntRunning();
      case "New code is generated":
      case "Code in telegram":
        return _codeFormPart();
      default:
        return _botIsntRunning();
    }
  }

  Widget _topPart(BuildContext context) {
    return Column(
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: CustomButtonWidget(
            variant: CustomButtonVariants.primary,
            onPressed: () {
              Navigator.pop(context);
            },
            width: 48,
            height: 48,
            leftSvg: SvgPicture.asset(
              'assets/svgs/left_arrow.svg',
              width: 14,
              height: 14,
            ),
            accentColor: const Color(0xFFF7EEFF),
            showLeftSvg: true,
            showText: false,
          ),
        ),
        const SizedBox(height: 8),
        SvgPicture.asset(
          "assets/svgs/gymapp_logo.svg",
          height: 48,
        ),
      ],
    );
  }

  void onCodeEntered(String code) {
    setState(() {
      enteredCode = int.parse(code);
      isCodeValid = isFourDigitNumber(enteredCode);

      MaterialPageRoute(builder: (context) => const BaseScreen());
    });
  }

  Widget _codeFormPart() {
    return Column(
      children: [
        _sectionTitle("Подтверждение номера"),
        const SizedBox(height: 4),
        _sectionSubtitle(
            "Мы отправили код в телеграмме\n на номер +7 900 000 00 00"),
        const SizedBox(height: 36),
        Stack(
          clipBehavior: Clip.none,
          children: [
            CodeInputWidget(
              key: _codeInputKey,
              onCodeEntered: onCodeEntered,
              accentColor: isCodeCorrect
                  ? const Color(0xFFF1EDF5)
                  : const Color(0xFFFFE2E5),
            ),
            if (!isCodeCorrect)
              const Positioned(
                left: -2,
                top: -20,
                child: Align(
                  alignment: Alignment.topCenter,
                  child: Padding(
                    padding: EdgeInsets.only(left: 8.0),
                    child: Text(
                      "Неверный код",
                      style: TextStyle(
                        fontFamily: 'Roboto',
                        fontWeight: FontWeight.w400,
                        fontSize: 14,
                        height: 20 / 14,
                        letterSpacing: 0.1,
                        color: Color(0xFFED3241),
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(height: 36),
        _sendAgain(),
      ],
    );
  }

  bool isFourDigitNumber(int number) {
    String numberStr = number.toString();
    return numberStr.length == 5;
  }

  Widget _sendAgain() {
    return Column(
      children: [
        CustomButtonWidget(
          variant: CustomButtonVariants.primary,
          onPressed: () => onClickAccept(enteredCode),
          text: "Подтвердить",
          textColor: isCodeValid ? null : const Color(0xFF817B89),
          accentColor:
              isCodeValid ? const Color(0xFFA03FFF) : const Color(0xFFF1EDF5),
        ),
        const SizedBox(height: 24),
        GestureDetector(
            onTap: _showResendButton ? _resendCode : null,
            child: Text(
              _timerText,
              style: TextStyle(
                color: _showResendButton
                    ? const Color(0xFFA03FFF)
                    : const Color(0xFF000000),
                fontFamily: 'Roboto',
                fontWeight: FontWeight.w400,
                fontSize: 16,
                height: 16 / 20,
                letterSpacing: 0.1,
              ),
            )),
      ],
    );
  }

  void onClickAccept(int code) async {
    final response =
        await ApiService().proccesCode(widget.phone, code.toString());
    setState(() {
      isCodeCorrect = response == "Успешно";
      _codeInputKey.currentState?.clearCode();
      if (!isCodeCorrect) {
        isCodeValid = false;
      } else {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const BaseScreen(),
            ));
      }
    });
  }

  void _resendCode() {
    setState(() {
      _start = 60;
      _showResendButton = false;
      _startTimer();
    });
  }

  Widget _botIsntRunning() {
    return Column(
      children: [
        _sectionTitle("Бот не запущен"),
        const SizedBox(height: 16),
        _sectionSubtitle(
            "Вы будете перенаправлены в Телеграм к нашему боту “Gymapp.Бот”. После нажмите “Старт” и следуйте инструкциям."),
        const SizedBox(height: 36),
        CustomButtonWidget(
          variant: CustomButtonVariants.primary,
          onPressed: () {
            _launchURL("https://t.me/GAAuthTest_bot");
          },
          text: "Перейти в telegram",
          leftSvg: SvgPicture.asset("assets/svgs/telegram_logo.svg"),
          showLeftSvg: true,
          accentColor: const Color(0xFF006FFD),
        ),
      ],
    );
  }

  Widget _codeExpired() {
    return Column(
      children: [
        _sectionTitle("Подтверждение номера"),
        const SizedBox(height: 16),
        _sectionSubtitle("Срок действия кода истёк."),
        const SizedBox(height: 36),
        CustomButtonWidget(
          variant: CustomButtonVariants.primary,
          onPressed: () {
            setState(() {
              response = "Code in telegram";
            });
          },
          text: "Отправить новый код",
          accentColor: const Color(0xFFA03FFF),
        ),
      ],
    );
  }

  Widget _sectionTitle(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontFamily: 'Roboto',
        fontWeight: FontWeight.w500,
        fontSize: 20,
        height: 1,
        letterSpacing: 0.1,
      ),
    );
  }

  Widget _sectionSubtitle(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontFamily: 'Roboto',
        fontWeight: FontWeight.w400,
        fontSize: 16,
        height: 20 / 16,
        letterSpacing: 0.1,
      ),
      textAlign: TextAlign.center,
    );
  }

  Future<void> _launchURL(String urlString) async {
    final Uri url = Uri.parse(urlString);
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      // Сообщаем об ошибке, если URL не может быть открыт
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Не удалось открыть URL: $urlString'),
        ),
      );
    }
  }
}
