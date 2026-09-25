import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../state/app_settings_store.dart';

class InactivityGuard extends StatefulWidget {
  const InactivityGuard({
    super.key,
    required this.child,
  });

  final Widget child;

  static InactivityGuardState? of(BuildContext context) {
    return context.findAncestorStateOfType<InactivityGuardState>();
  }

  @override
  State<InactivityGuard> createState() => InactivityGuardState();
}

class InactivityGuardState extends State<InactivityGuard>
    with WidgetsBindingObserver {
  static const _timeout = Duration(minutes: 3);

  Timer? _timer;
  bool _isEditingCard = false;
  bool _appIsActive = true;
  bool _autoCloseWasEnabled = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _autoCloseWasEnabled =
            context.read<AppSettingsStore>().autoCloseEnabled;
        _restartTimer();
      }
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _timer?.cancel();
    super.dispose();
  }

  /// Suspend le compte à rebours pendant la création ou la modification
  /// d'une carte, afin qu'aucune saisie en cours ne soit perdue.
  void setEditingCard(bool editing) {
    if (_isEditingCard == editing) return;

    _isEditingCard = editing;

    if (editing) {
      _timer?.cancel();
    } else {
      _restartTimer();
    }
  }

  /// Chaque action tactile ou clavier redémarre le compte à rebours.
  void registerUserActivity() {
    _restartTimer();
  }

  void _restartTimer() {
    _timer?.cancel();

    if (!mounted || !_appIsActive || _isEditingCard) return;

    final autoCloseEnabled = context.read<AppSettingsStore>().autoCloseEnabled;

    if (!autoCloseEnabled) return;

    _timer = Timer(
      _timeout,
      _closeApplication,
    );
  }

  Future<void> _closeApplication() async {
    if (!mounted || !_appIsActive || _isEditingCard) return;

    final autoCloseEnabled = context.read<AppSettingsStore>().autoCloseEnabled;

    if (!autoCloseEnabled) return;

    _timer?.cancel();

    // Ferme l'activité Android et termine l'application Flutter.
    await SystemNavigator.pop();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    _appIsActive = state == AppLifecycleState.resumed;

    if (_appIsActive) {
      _restartTimer();
    } else {
      _timer?.cancel();
    }
  }

  @override
  Widget build(BuildContext context) {
    final autoCloseEnabled = context.watch<AppSettingsStore>().autoCloseEnabled;

    if (autoCloseEnabled != _autoCloseWasEnabled) {
      _autoCloseWasEnabled = autoCloseEnabled;

      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;

        if (autoCloseEnabled) {
          _restartTimer();
        } else {
          _timer?.cancel();
        }
      });
    }

    return Listener(
      behavior: HitTestBehavior.translucent,
      onPointerDown: (_) => registerUserActivity(),
      onPointerMove: (_) => registerUserActivity(),
      onPointerUp: (_) => registerUserActivity(),
      onPointerSignal: (_) => registerUserActivity(),
      child: Focus(
        autofocus: true,
        onKeyEvent: (_, __) {
          registerUserActivity();
          return KeyEventResult.ignored;
        },
        child: widget.child,
      ),
    );
  }
}
