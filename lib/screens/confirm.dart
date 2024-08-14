import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:login_page/api/api_service.dart';
import 'package:login_page/components/code_form.dart';
import 'package:login_page/components/custom_button.dart';
import 'package:login_page/const.dart';
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

  // Таймер для кнопки отправить повторно.
  Timer? _sendAgainTimer;
  static const int _sendAgainStart = 60;
  int _sendAgainTemp = _sendAgainStart;
  bool _showResendButton = false;
  String _timerText = 'Отправить повторно через 60 секунд';

  // Таймер до появления страницы с текстом «Код истек»
  Timer? _codeExpiredTimer;
  static const int _codeExpiredStart = 300;
  int _codeExpiredTemp = _codeExpiredStart;

  @override
  void initState() {
    super.initState();
    response = widget.responseMessage;
  }

  void _startSendAgainTimer() {
    _sendAgainTimer?.cancel();
    _sendAgainTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_sendAgainTemp < 1.5) {
        setState(() {
          _sendAgainTimer!.cancel();
          _showResendButton = true;
          _timerText = 'Отправить повторно';
          _sendAgainTemp = _sendAgainStart;
        });
      } else {
        setState(() {
          _sendAgainTemp--;
          _showResendButton = false;
          _timerText = 'Отправить повторно через $_sendAgainTemp секунд';
        });
      }
    });
  }

  void _startCodeExpiredTimer() {
    _codeExpiredTimer?.cancel();
    _codeExpiredTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_codeExpiredTemp == 0) {
        setState(() {
          _codeExpiredTimer!.cancel();
          response = "code expired";
          _codeExpiredTemp = 300;
          _sendAgainTimer!.cancel();
          _sendAgainTemp = _sendAgainStart;
          _timerText = "Отправить повторно через 60 секунд";
        });
      } else {
        setState(() {
          _codeExpiredTemp--;
        });
      }
    });
  }

  @override
  void dispose() {
    _sendAgainTimer!.cancel();
    _codeExpiredTimer!.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorInfo.purpleLight,
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
      case "code expired":
        return _codeExpired();
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
            // TODO: Поправить цвет иконки
            leftSvg: SvgPicture.asset(
              SvgInfo.leftarrow,
              colorFilter: const ColorFilter.mode(
                  ColorInfo.neutralDarkGreyDarkest, BlendMode.srcIn),
              width: 14,
              height: 14,
            ),
            accentColor: ColorInfo.purpleLight,
            showLeftSvg: true,
            showText: false,
          ),
        ),
        const SizedBox(height: 8),
        SvgPicture.asset(
          SvgInfo.gymapplogo,
          height: 48,
        ),
      ],
    );
  }

  void onCodeEntered(String code) {
    setState(() {
      enteredCode = int.parse(code);
      isCodeValid = isFiveDigitNumber(enteredCode);

      MaterialPageRoute(builder: (context) => const BaseScreen());
    });
  }

  String formatedPhone(String phone) {
    return "+${phone[0]} ${phone.substring(1, 4)} ${phone.substring(4, 7)} ${phone.substring(7, 9)} ${phone.substring(9, 11)}";
  }

  Widget _codeFormPart() {
    _startCodeExpiredTimer();
    _startSendAgainTimer();

    return Column(
      children: [
        _sectionTitle("Подтверждение номера"),
        const SizedBox(height: 4),
        _sectionSubtitle(
            "Мы отправили код в телеграмме\n на номер ${formatedPhone(widget.phone)}"),
        const SizedBox(height: 36),
        Stack(
          clipBehavior: Clip.none,
          children: [
            CodeInputWidget(
              key: _codeInputKey,
              onCodeEntered: onCodeEntered,
              accentColor: isCodeCorrect
                  ? ColorInfo.purpleGreyLight
                  : ColorInfo.errorLight,
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
                        color: ColorInfo.errorDark,
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

  bool isFiveDigitNumber(int number) {
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
          textColor: isCodeValid ? null : ColorInfo.darkGreyLightest,
          accentColor:
              isCodeValid ? ColorInfo.purpleDarkest : ColorInfo.purpleGreyLight,
        ),
        const SizedBox(height: 24),
        GestureDetector(
            onTap: _showResendButton ? _resendCode : null,
            child: Text(
              _timerText, // Отправить повторно через N секунд.
              style: TextStyle(
                color:
                    _showResendButton ? ColorInfo.purpleDarkest : Colors.black,
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

  void _resendCode() async {
    setState(() {
      _sendAgainTemp = _sendAgainTemp;
      _showResendButton = false;
      _startSendAgainTimer();
    });

    ApiService().proccesCode(widget.phone, "0");
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
          leftSvg: SvgPicture.asset(SvgInfo.telegramlogo),
          showLeftSvg: true,
          accentColor: ColorInfo.highlightDarkest,
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
          accentColor: ColorInfo.purpleDarkest,
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
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } else {
      // Сообщаем об ошибке, если URL не может быть открыт
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Не удалось открыть URL: $urlString'),
          ),
        );
      }
    }
  }
}
