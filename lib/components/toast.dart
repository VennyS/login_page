import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

enum ToastVariant { informative, succes, warning, error }

Map<ToastVariant, Color> toastColors = {
  ToastVariant.informative: const Color(0xFFEAF2FF),
  ToastVariant.succes: const Color(0xFFE7F4E8),
  ToastVariant.warning: const Color(0xFFFFF4E4),
  ToastVariant.error: const Color(0xFFFFE2E5),
};

Map<ToastVariant, SvgPicture> toastIcons = {
  ToastVariant.informative: svg("assets/svgs/informative.svg"),
  ToastVariant.succes: svg("assets/svgs/succes.svg"),
  ToastVariant.warning: svg("assets/svgs/warning.svg"),
  ToastVariant.error: svg("assets/svgs/error.svg"),
};

SvgPicture svg(String asset) {
  return SvgPicture.asset(asset);
}

class ToastWidget extends StatefulWidget {
  final ToastVariant variant;
  final String? title;
  final String? description;

  final bool showTitle;
  final bool showDescription;
  final VoidCallback? onTapClose;
  final Map<ToastVariant, Color>? colors;
  final Map<ToastVariant, SvgPicture>? icons;
  final Duration duration;

  const ToastWidget({
    super.key,
    required this.variant,
    this.onTapClose,
    this.title,
    this.description,
    this.colors,
    this.icons,
    this.duration = const Duration(seconds: 3),
    this.showTitle = true,
    this.showDescription = true,
  });

  @override
  ToastWidgetState createState() => ToastWidgetState();
}

class ToastWidgetState extends State<ToastWidget> {
  bool _isVisible = true;
  late Map<ToastVariant, Color> _colors;
  late Map<ToastVariant, SvgPicture> _icons;

  @override
  void initState() {
    super.initState();
    _colors = widget.colors ?? toastColors;
    _icons = widget.icons ?? toastIcons;

    Future.delayed(widget.duration, () {
      if (mounted) {
        setState(() {
          _isVisible = false;
        });
        if (widget.onTapClose != null) {
          widget.onTapClose!();
        }
      }
    });
  }

  void hideToast() {
    setState(() {
      _isVisible = false;
    });
  }

  void showToast() {
    setState(() {
      _isVisible = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!_isVisible) {
      return const SizedBox.shrink();
    }

    return Container(
      decoration: BoxDecoration(
          color: _colors[widget.variant],
          borderRadius: BorderRadius.circular(16)),
      padding: const EdgeInsets.all(16),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _icons[widget.variant]!,
          const SizedBox(
            width: 16,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (widget.showTitle && widget.title != null)
                Align(
                  child: Text(
                    widget.title!,
                    style: const TextStyle(
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w700,
                        fontSize: 12,
                        height: 14 / 12),
                  ),
                ),
              if (widget.showDescription && widget.description != null)
                const SizedBox(
                  height: 4,
                ),
              Text(
                widget.description!,
                style: const TextStyle(
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w400,
                    fontSize: 12,
                    height: 16 / 12),
              ),
            ],
          ),
          const SizedBox(
            width: 16,
          ),
          GestureDetector(
            onTap: () {
              if (widget.onTapClose == null) {
                setState(() {
                  _isVisible = false;
                });
              } else {
                widget.onTapClose?.call();
              }
            },
            child: SvgPicture.asset("assets/svgs/close.svg"),
          )
        ],
      ),
    );
  }
}
