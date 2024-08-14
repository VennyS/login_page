import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// Enum representing the different variants for toast notifications.
enum ToastVariant { informative, success, warning, error }

/// Map defining the default background colors for each toast variant.
Map<ToastVariant, Color> toastColors = {
  ToastVariant.informative: const Color(0xFFEAF2FF), // Informative toast
  ToastVariant.success: const Color(0xFFE7F4E8), // Success toast
  ToastVariant.warning: const Color(0xFFFFF4E4), // Warning toast
  ToastVariant.error: const Color(0xFFFFE2E5), // Error toast
};

/// Map defining the default leading leadingIcons for each toast variant.
Map<ToastVariant, SvgPicture> toastIcons = {
  ToastVariant.informative:
      svg("assets/svgs/informative.svg"), // Icon for informative toast
  ToastVariant.success:
      svg("assets/svgs/success.svg"), // Icon for success toast
  ToastVariant.warning:
      svg("assets/svgs/warning.svg"), // Icon for warning toast
  ToastVariant.error: svg("assets/svgs/error.svg"), // Icon for error toast
};

/// Method to include an SVG picture in a toast.
SvgPicture svg(String asset) {
  return SvgPicture.asset(asset); // Returns an SVG icon from the assets
}

/// Class to manage showing and hiding toast notifications.
class ToastManager {
  static final ToastManager _instance = ToastManager._internal();

  /// Factory constructor for creating or returning the singleton instance.
  factory ToastManager() {
    return _instance;
  }

  ToastManager._internal();

  OverlayEntry? _overlayEntry;

  /// Shows a toast using the provided `ToastWidget`.
  void showToast(BuildContext context, ToastWidget toast) {
    _overlayEntry?.remove(); // Remove any existing toast

    _overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        top: MediaQuery.of(context).padding.top + 16, // Offset from the top
        left: 32,
        right: 32,
        child: Material(
          color: Colors.transparent,
          child: toast, // The toast widget to display
        ),
      ),
    );

    Overlay.of(context).insert(_overlayEntry!); // Insert the new toast
  }

  /// Hides the currently displayed toast.
  void hideToast() {
    _overlayEntry?.remove(); // Remove the current toast
    _overlayEntry = null; // Reset the overlay entry
  }
}

/// A widget representing a toast notification.
class ToastWidget extends StatefulWidget {
  /// The variant of the toast (informative, success, etc.)
  final ToastVariant variant;

  /// Optional title text for the toast.
  final String? title;

  /// Optional description text for the toast.
  final String? description;

  /// Whether to show the title.
  final bool showTitle;

  /// Whether to show the description.
  final bool showDescription;

  /// Optional callback when the close icon is tapped.
  final VoidCallback? onTapClose;

  /// Optional map of custom colors.
  final Map<ToastVariant, Color>? colors;

  /// Optional map of custom leadingIcons.
  final Map<ToastVariant, SvgPicture>? leadingIcons;

  /// Duration for which the toast is visible.
  final Duration duration;

  final SvgPicture? trailingIcon;
  final bool showTrailingIcon;

  /// Constructor for `ToastWidget`.
  const ToastWidget({
    super.key,
    required this.variant,
    this.onTapClose,
    this.title,
    this.description,
    this.colors,
    this.leadingIcons,
    this.trailingIcon,
    this.duration =
        const Duration(seconds: 500), // Default duration is 3 seconds
    this.showTitle = true, // Default is to show the title
    this.showDescription = true, // Default is to show the description
    this.showTrailingIcon = true,
  })  : assert(showTitle || title != null,
            "[title] must be defined to show. Set [showTitle] = false or set any [title]"),
        assert(showDescription || description != null,
            "[description] must be defined to show. Set [showDescription] = false or set any [description]"),
        assert(showTrailingIcon && trailingIcon != null,
            "[trailingIcon] must be defined to show. Set [showTrailingIcon] = false or set any [description]");

  @override
  ToastWidgetState createState() =>
      ToastWidgetState(); // Creates the state for the toast widget
}

/// The state for the `ToastWidget`.
class ToastWidgetState extends State<ToastWidget> {
  /// Indicates whether the toast is visible.
  bool _isVisible = true;

  /// Map of colors to use for the toast.
  late Map<ToastVariant, Color> _colors;

  /// Map of leadingIcons to use for the toast.
  late Map<ToastVariant, SvgPicture> _icons;

  @override
  void initState() {
    super.initState();
    _colors =
        widget.colors ?? toastColors; // Use provided colors or default colors
    _icons = widget.leadingIcons ??
        toastIcons; // Use provided leadingIcons or default leadingIcons

    /// Hide the toast after the specified duration.
    Future.delayed(widget.duration, () {
      if (mounted) {
        setState(() {
          _isVisible = false;
        });
        if (widget.onTapClose != null) {
          widget.onTapClose!(); // Call the close callback if provided
        }
        ToastManager().hideToast(); // Hide the toast
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!_isVisible) {
      return const SizedBox
          .shrink(); // Return an empty widget if the toast is not visible
    }

    return Container(
      /// Set the background color based on the variant.
      // constraints:
      //     BoxConstraints(maxWidth: MediaQuery.of(context).size.width - 32),
      decoration: BoxDecoration(
        color: _colors[widget.variant],
        borderRadius: BorderRadius.circular(16), // Rounded corners
      ),
      padding: const EdgeInsets.all(16), // Padding inside the toast
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment:
            CrossAxisAlignment.center, // Aligns the children to the center
        children: [
          _icons[widget.variant]!, // Display the icon for the variant
          const SizedBox(width: 16), // Space between the icon and text
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment:
                  CrossAxisAlignment.start, // Align text to the start
              children: [
                if (widget.showTitle && widget.title != null)
                  Text(
                    widget.title!, // Display the title if provided
                    style: const TextStyle(
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w700,
                      fontSize: 12,
                      height: 14 / 12,
                    ),
                  ),
                if (widget.showDescription && widget.description != null)
                  const SizedBox(
                      height: 4), // Space between title and description
                Text(
                  widget.description!, // Display the description if provided
                  style: const TextStyle(
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w400,
                    fontSize: 12,
                    height: 16 / 12,
                  ),
                  maxLines: 3, // Limit the description to 3 lines
                  overflow: TextOverflow
                      .ellipsis, // Truncate text with ellipsis if too long
                ),
              ],
            ),
          ),
          const SizedBox(width: 16), // Space between text and close icon
          if (widget.showTrailingIcon && widget.trailingIcon != null)
            GestureDetector(
              onTap: () {
                if (widget.onTapClose == null) {
                  setState(() {
                    _isVisible =
                        false; // Hide the toast if no callback is provided
                  });
                } else {
                  widget.onTapClose
                      ?.call(); // Call the close callback if provided
                }
                ToastManager().hideToast(); // Hide the toast
              },
              child: widget.trailingIcon, // Close icon
            ),
        ],
      ),
    );
  }
}
