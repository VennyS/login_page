import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:login_page/components/code_form.dart';
import 'package:login_page/components/custom_button.dart';

class ConfirmPage extends StatefulWidget {
  const ConfirmPage({super.key});

  @override
  _ConfirmPageState createState() => _ConfirmPageState();
}

class _ConfirmPageState extends State<ConfirmPage> {
  late int enteredCode = 0;
  late bool isCodeCorrect = true;
  late bool isCodeValid = false;

  final GlobalKey<CodeInputWidgetState> _codeInputKey =
      GlobalKey<CodeInputWidgetState>();

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
                  _codeFormPart(),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        ),
      ),
    );
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
    });
  }

  Widget _codeFormPart() {
    return Column(
      children: [
        _sectionTitle("Подтверждение номера"),
        const SizedBox(
          height: 4,
        ),
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
    return numberStr.length == 6;
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
          child: _sectionText("Отправить повторно",
              color: const Color(0xFFA03FFF)),
          onTap: () => print("Send again click"),
        ),
      ],
    );
  }

  void onClickAccept(int code) {
    setState(() {
      isCodeCorrect = code == 123456;
      _codeInputKey.currentState?.clearCode();
      if (!isCodeCorrect) {
        isCodeValid = false;
      }
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
          onPressed: () => print("Link to telegram click"),
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
          onPressed: () => print("Send again click"),
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

  Widget _sectionText(String text, {Color color = Colors.black}) {
    return Text(
      text,
      style: TextStyle(
        fontFamily: 'Roboto',
        fontWeight: FontWeight.w500,
        fontSize: 16,
        height: 16 / 20,
        letterSpacing: 0.1,
        color: color,
      ),
    );
  }
}
