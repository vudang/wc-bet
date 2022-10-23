import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:web_dashboard/src/color.dart';
import 'package:web_dashboard/src/widgets/app_text.dart';

enum AppButtonState {
  normal, pressed, disable
}

enum AppButtonSize {
  small, // height 31
  small01, // height 36
  medium, // height 44
  large, // height 48
  huge // height 60
}

enum AppButtonStyle {
  purple, white
}

class _ButtonSize {
  static const SMALL = 0;
  static const SMALL_01 = 1;
  static const MEDIUM = 2;
  static const LARGE = 3;
  static const HUGE = 4;
  final int size;
  _ButtonSize(this.size);

  double height() {
    switch (size) {
      case SMALL:
        return 31;
      case SMALL_01:
        return 36;
      case MEDIUM:
        return 44;
      case LARGE:
        return 48;
      default:
        return 60;
    }
  }

  double textSize() {
    switch (size) {
      case SMALL:
        return 14;
      case SMALL_01:
        return 14;
      case MEDIUM:
        return 15;
      case LARGE:
        return 17;
      default:
        return 20;
    }
  }

  double horizontalPadding() {
    switch (size) {
      case SMALL:
        return 14;
      case SMALL_01:
        return 14;
      case MEDIUM:
        return 28;
      case LARGE:
        return 40;
      default:
        return 52;
    }
  }
}

class _ButtonStyle {
  static const PURPLE = 0;
  static const WHITE = 1;
  final int style;
  final AppButtonState state;
  _ButtonStyle(this.style, this.state);

  Color normalColor() {
    return SystemColor.BLACK;
  }

  Color pressedColor() {
    return SystemColor.BLACK.withOpacity(0.5);
  }

  Color disableColor() {
    return SystemColor.BLACK.withOpacity(0.5);
  }

  Color textColor() {
    return SystemColor.WHITE;
  }
}

class AppSystemRegularButton extends StatefulWidget {
  final AppButtonSize size;
  final AppButtonStyle style;
  final AppButtonState state;
  final String text;
  final VoidCallback? onPressed;
  final Widget? prefixIcon;
  final double? horizontalPadding;
  final double? verticalPadding;
  final Color? customTextColor;
  final Color? customDisableColor;
  final Color? customColor;
  final double? width;
  final bool disableAfterPressed; // Button will be animate to disable state after pressed on

  const AppSystemRegularButton({
    Key? key,
    required this.text,
    this.prefixIcon,
    this.onPressed,
    this.horizontalPadding,
    this.verticalPadding,
    this.customTextColor,
    this.customDisableColor,
    this.disableAfterPressed = false,
    this.width,
    this.customColor,
    this.size = AppButtonSize.large,
    this.style = AppButtonStyle.purple,
    this.state = AppButtonState.normal,
  }) : super(key: key);


  @override
  State<StatefulWidget> createState() => _AppSystemRegularButtonState();
}

class _AppSystemRegularButtonState extends State<AppSystemRegularButton> with SingleTickerProviderStateMixin {
  late _ButtonSize _buttonSize;
  late _ButtonStyle _buttonStyle;
  bool _buttonHeldDown = false;

  static const Duration kFadeOutDuration = Duration(milliseconds: 200);
  static const Duration kFadeInDuration = Duration(milliseconds: 200);

  late AnimationController _animationController;
  late Animation<Color?> _colorAnimation;

  @override
  void initState() {
    super.initState();
    _buttonSize = _ButtonSize(widget.size.index);
    _buttonStyle = _ButtonStyle(widget.style.index, widget.state);

    _animationController = AnimationController(
      duration: const Duration(milliseconds: 400),
      value: 0.0,
      vsync: this,
    );

    final normalColor = _buttonStyle.normalColor();
    final pressedColor = _buttonStyle.pressedColor();
    final disableColor = widget.customDisableColor ?? _buttonStyle.disableColor();

    final listColor = [
      TweenSequenceItem(
        weight: 1.0,
        tween: ColorTween(begin: normalColor, end: pressedColor),
      )
    ];

    if (widget.disableAfterPressed) {
      final disableTween = TweenSequenceItem(
        weight: 0.2,
        tween: ColorTween(begin: pressedColor, end: disableColor),
      );
      listColor.add(disableTween);
    }
    _colorAnimation = TweenSequence<Color?>(listColor).animate(_animationController);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool enabled = widget.state != AppButtonState.disable;
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTapDown: enabled ? _handleTapDown : null,
      onTapUp: enabled ? _handleTapUp : null,
      onTapCancel: enabled ? _handleTapCancel : null,
      onTap: enabled ? widget.onPressed : null,
      child: _child()
    );
  }

  Widget _child() {
    final bool enable = widget.state != AppButtonState.disable;
    if (enable && widget.disableAfterPressed) {
      _revertAnimation();
    }

    final disableColor = widget.customDisableColor ?? _buttonStyle.disableColor();
    return AnimatedBuilder(
      animation: _colorAnimation,
      builder: (ctx, child) {
        return DecoratedBox(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: enable ? (widget.customColor != null ? widget.customColor : _colorAnimation.value) : disableColor,
          ),
          child: _childWidget()
        );
      },
    );
  }

  Widget _childWidget() {
    final textOpacity = widget.state == AppButtonState.disable ? 0.5 : 1.0;
    return SizedBox(
      width: widget.width ?? MediaQuery.of(context).size.width,
      height: _buttonSize.height(),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: widget.horizontalPadding ?? 0, vertical: widget.verticalPadding ?? 0),
        child: Align(
            alignment: Alignment.center,
            widthFactor: 1.0,
            heightFactor: 1.0,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Visibility(
                  visible: widget.prefixIcon != null,
                  child: Padding(
                    padding: EdgeInsets.only(right: 8, bottom: 1),
                    child: widget.prefixIcon ?? Container(),
                  ),
                ),
                AppText(
                    widget.text,
                    align: TextAlign.center,
                    size: _buttonSize.textSize(),
                    color: (widget.customTextColor ?? _buttonStyle.textColor()).withOpacity(textOpacity),
                    weight: FontWeight.w700
                )
              ],
            )
        ),
      ),
    );
  }

  void _handleTapDown(TapDownDetails event) {
    if (!_buttonHeldDown) {
      _buttonHeldDown = true;
      _animate();
    }
  }

  void _handleTapUp(TapUpDetails event) {
    if (_buttonHeldDown) {
      _buttonHeldDown = false;
      _animate();
    }
  }

  void _handleTapCancel() {
    if (_buttonHeldDown) {
      _buttonHeldDown = false;
      _animate();
    }
  }

  void _animate() {
    if (_animationController.isAnimating) {
      return;
    }

    if (widget.disableAfterPressed) {
      _animationController.animateTo(1.0, duration: kFadeOutDuration, curve: Curves.easeInOutCubicEmphasized);
      return;
    }

    final bool wasHeldDown = _buttonHeldDown;
    final TickerFuture ticker = _buttonHeldDown
        ? _animationController.animateTo(1.0, duration: kFadeOutDuration, curve: Curves.easeInOutCubicEmphasized)
        : _animationController.animateTo(0.0, duration: kFadeInDuration, curve: Curves.easeOutCubic);

    ticker.then<void>((void value) {
      if (mounted && wasHeldDown != _buttonHeldDown) {
        _animate();
      }
    });
  }

  void _revertAnimation() {
    _animationController.animateTo(0.0, duration: kFadeInDuration, curve: Curves.easeOutCubic);
  }
}
