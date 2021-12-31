import 'package:flutter/material.dart';

class DoubleBackToCloseWidget extends StatefulWidget {
  final Widget child; // Make Sure this child has a Scaffold widget as parent.

  const DoubleBackToCloseWidget({
    @required this.child,
  });

  @override
  _DoubleBackToCloseWidgetState createState() =>
      _DoubleBackToCloseWidgetState();
}

class _DoubleBackToCloseWidgetState extends State<DoubleBackToCloseWidget> {
  int _lastTimeBackButtonWasTapped;
  static const exitTimeInMillis = 2000;

  bool get _isAndroid => Theme.of(context).platform == TargetPlatform.android;

  @override
  Widget build(BuildContext context) {
    if (_isAndroid) {
      return WillPopScope(
        onWillPop: _handleWillPop,
        child: widget.child,
      );
    } else {
      return widget.child;
    }
  }

  Future<bool> _handleWillPop() async {
    final _currentTime = DateTime.now().millisecondsSinceEpoch;

    if (_lastTimeBackButtonWasTapped != null &&
        (_currentTime - _lastTimeBackButtonWasTapped) < exitTimeInMillis) {
      Scaffold.of(context).removeCurrentSnackBar();
      return true;
    } else {
      _lastTimeBackButtonWasTapped = DateTime.now().millisecondsSinceEpoch;
      Scaffold.of(context).removeCurrentSnackBar();
      Scaffold.of(context).showSnackBar(
        _getExitSnackBar(context),
      );
      return false;
    }
  }

  SnackBar _getExitSnackBar(
      BuildContext context,
      ) {
    return SnackBar(
      content: Text(
        'Press back again to exit!',
        // color: Colors.white,
      ),
      backgroundColor: Colors.red,
      duration: const Duration(
        seconds: 2,
      ),
      behavior: SnackBarBehavior.floating,
    );
  }
}
