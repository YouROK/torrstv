import 'package:path/path.dart' as p;

class Mime {
  static String getMimeType(String filepath) {
    final ext = p.extension(filepath).toLowerCase();
    final cleanExt = ext.startsWith('.') ? ext.substring(1) : ext;

    if (_extVideo.contains(cleanExt)) {
      return "video/*";
    }
    if (_extAudio.contains(cleanExt)) {
      return "audio/*";
    }
    return "*/*";
  }

  static String _getExtension(String filepath) {
    final fileName = filepath.split(RegExp(r'[\\/]')).last;
    final dotIndex = fileName.lastIndexOf('.');
    if (dotIndex == -1 || dotIndex == fileName.length - 1) {
      return '';
    }
    return fileName.substring(dotIndex + 1);
  }

  static const _extVideo = ["3g2", "3gp", "aaf", "asf", "avchd", "avi", "drc", "flv", "iso", "m2v", "m2ts", "m4p", "m4v", "mkv", "mng", "mov", "mp2", "mp4", "mpe", "mpeg", "mpg", "mpv", "mxf", "nsv", "ogg", "ogv", "ts", "qt", "rm", "rmvb", "roq", "svi", "vob", "webm", "wmv", "yuv"];

  static const _extAudio = ["aac", "aiff", "ape", "au", "flac", "gsm", "it", "m3u", "m4a", "mid", "mod", "mp3", "mpa", "pls", "ra", "s3m", "sid", "wav", "wma", "xm"];
}
