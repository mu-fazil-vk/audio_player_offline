String formatDuration(int milliseconds) {
  Duration duration = Duration(milliseconds: milliseconds);
  int hours = duration.inHours;
  int minutes = duration.inMinutes % 60;
  int seconds = duration.inSeconds % 60;

  if (hours > 0) {
    return '${_twoDigits(hours)}:${_twoDigits(minutes)}:${_twoDigits(seconds)}';
  } else {
    return '${_twoDigits(minutes)}:${_twoDigits(seconds)}';
  }
}

String _twoDigits(int n) {
  return n.toString().padLeft(2, '0');
}
