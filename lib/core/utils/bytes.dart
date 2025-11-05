import 'dart:math';

String bytesFmt(int bytes) {
  if (bytes <= 0) return "0 B";
  const suffixes = ["B", "KB", "MB", "GB", "TB", "PB", "EB"];
  var i = (log(bytes) / log(1024)).floor();
  return '${(bytes / pow(1024, i)).toStringAsFixed(2)} ${suffixes[i]}';
}

String speedFmt(double bytes) {
  if (bytes <= 0.0) return "0 B/Sec";
  const suffixes = ["B/Sec", "KB/Sec", "MB/Sec", "GB/Sec", "TB/Sec", "PB/Sec", "EB/Sec"];
  var i = (log(bytes) / log(1024)).floor();
  return '${(bytes / pow(1024, i)).toStringAsFixed(2)} ${suffixes[i]}';
}
