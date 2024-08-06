import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:login_page/components/custom_button.dart';

class ConfirmPage extends StatelessWidget {
  const ConfirmPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color(0xFFD4D6DD),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 32),
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
                    topPart(context),
                    const SizedBox(height: 36),
                    codeFormPart(),
                    const SizedBox(height: 32),
                  ],
                ),
              )),
        ));
  }

  Widget topPart(BuildContext context) {
    return Column(
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: CustomButton(
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

  Widget codeFormPart() {
    return Column(
      children: [
        sectionTitle("Подтверждение номера"),
        sectionSubtitle(
            "Мы отправили код в телеграмме на номер +7 900 000 00 00"),
        const SizedBox(height: 36),
        Container(
          height: 60,
          width: 250,
          color: Colors.red,
        ),
        const SizedBox(
          height: 36,
        ),
        sendAgain(),
      ],
    );
  }

  Widget sendAgain() {
    return Column(
      children: [
        CustomButton(
          variant: CustomButtonVariants.primary,
          onPressed: () => print("Enter click"),
          text: "Подтвердить",
          accentColor: const Color(0xFFA03FFF),
        ),
        const SizedBox(height: 24),
        GestureDetector(
          child:
              sectionText("Отправить повторно", color: const Color(0xFFA03FFF)),
          onTap: () => print("Send again click"),
        )
      ],
    );
  }

  Widget botIsntRunning() {
    return Column(
      children: [
        sectionTitle("Бот не запущен"),
        const SizedBox(height: 16),
        sectionSubtitle(
            "Вы будете перенаправлены в Телеграм к нашему боту “Gymapp.Бот”. После нажмите “Старт” и следуйте инструкциям."),
        const SizedBox(height: 36),
        CustomButton(
          variant: CustomButtonVariants.primary,
          onPressed: () => print("Link to telegram click"),
          text: "Перейти в telegram",
          leftSvg: SvgPicture.asset("assets/svgs/telegram_logo.svg"),
          showLeftSvg: true,
          accentColor: const Color(0xFF006FFD),
        )
      ],
    );
  }

  Widget codeExpired() {
    return Column(
      children: [
        sectionTitle("Подтверждение номера"),
        const SizedBox(height: 16),
        sectionSubtitle("Срок действия кода истёк."),
        const SizedBox(height: 36),
        CustomButton(
          variant: CustomButtonVariants.primary,
          onPressed: () => print("Send again click"),
          text: "Отправить новый код",
          accentColor: const Color(0xFFA03FFF),
        )
      ],
    );
  }

  Widget sectionTitle(String text) {
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

  Widget sectionSubtitle(String text) {
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

  Widget sectionText(String text, {Color color = Colors.black}) {
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
