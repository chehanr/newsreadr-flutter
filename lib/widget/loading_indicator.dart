import 'package:flutter/material.dart';

class LoadingIndicator extends StatelessWidget {
  static const int IDLE = 0;
  static const int LOADING = 1;
  static const int ERROR = 3;

  final int state;
  final VoidCallback retry;

  const LoadingIndicator({Key key, this.state: 0, this.retry})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: state == LOADING
            ? CircularProgressIndicator()
            : Text(state == IDLE ? '' : 'Retry'),
      ),
      height: 64.0,
    );
  }
}
