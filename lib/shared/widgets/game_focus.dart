import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../core/services/sound_service.dart';

typedef FocusedWidgetBuilder = Widget Function(BuildContext context, bool focused);

/// Gamepad/keyboard-aware focusable wrapper.
///
/// * Reacts to D-Pad / analog navigation driven by the Flutter focus system.
/// * Plays interactive sounds on focus and activation.
/// * Activates on gamepad `A`, `Enter`, `Space` and `Select`.
/// * Triggers [onBack] on gamepad `B` / `Escape` / hardware back.
class GameFocus extends StatefulWidget {
  const GameFocus({
    super.key,
    required this.builder,
    this.onSelect,
    this.onFocused,
    this.onBack,
    this.autofocus = false,
    this.canRequestFocus = true,
    this.focusNode,
  });

  final FocusedWidgetBuilder builder;
  final VoidCallback? onSelect;
  final ValueChanged<bool>? onFocused;
  final VoidCallback? onBack;
  final bool autofocus;
  final bool canRequestFocus;
  final FocusNode? focusNode;

  @override
  State<GameFocus> createState() => _GameFocusState();
}

class _GameFocusState extends State<GameFocus> {
  late final FocusNode _node;
  late final bool _ownsNode;
  bool _focused = false;

  @override
  void initState() {
    super.initState();
    final FocusNode? external = widget.focusNode;
    if (external != null) {
      _node = external;
      _ownsNode = false;
    } else {
      _node = FocusNode(debugLabel: 'GameFocus');
      _ownsNode = true;
    }
    _focused = _node.hasFocus;
    _node.addListener(_handleFocusChange);
  }

  void _handleFocusChange() {
    if (_focused == _node.hasFocus) return;
    setState(() => _focused = _node.hasFocus);
    if (_focused) {
      SoundService.instance.tick();
    }
    widget.onFocused?.call(_focused);
  }

  @override
  void dispose() {
    _node.removeListener(_handleFocusChange);
    if (_ownsNode) {
      _node.dispose();
    }
    super.dispose();
  }

  KeyEventResult _onKeyEvent(FocusNode node, KeyEvent event) {
    if (event is! KeyDownEvent) {
      return KeyEventResult.ignored;
    }
    final LogicalKeyboardKey key = event.logicalKey;
    final bool isBack = key == LogicalKeyboardKey.escape ||
        key == LogicalKeyboardKey.gameButtonB ||
        key == LogicalKeyboardKey.goBack;
    if (isBack && widget.onBack != null) {
      widget.onBack!.call();
      return KeyEventResult.handled;
    }
    return KeyEventResult.ignored;
  }

  void _activate() {
    widget.onSelect?.call();
    SoundService.instance.select();
  }

  @override
  Widget build(BuildContext context) {
    return Focus(
      focusNode: _node,
      autofocus: widget.autofocus,
      canRequestFocus: widget.canRequestFocus,
      onKeyEvent: _onKeyEvent,
      child: Actions(
        actions: <Type, Action<Intent>>{
          ActivateIntent: CallbackAction<ActivateIntent>(
            onInvoke: (ActivateIntent intent) {
              _activate();
              return null;
            },
          ),
        },
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () {
            _node.requestFocus();
            _activate();
          },
          child: widget.builder(context, _focused),
        ),
      ),
    );
  }
}
