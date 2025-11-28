// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get add => 'Add';

  @override
  String get magnetLabel => 'Magnet:';

  @override
  String get noFileSelected => 'No file selected';

  @override
  String get selectTorrentFile => 'Select .torrent file';

  @override
  String get clearSelectedFile => 'Clear selected file';

  @override
  String get saving => 'Saving...';

  @override
  String get titleOfTorrent => 'Title of torrent';

  @override
  String get enterATitle => 'Enter a title';

  @override
  String get posterUrlLabel => 'Poster URL';

  @override
  String get categoryLabel => 'Category';

  @override
  String get postersLabel => 'Posters:';

  @override
  String get enterMagnetOrFile => 'Please enter a magnet link or select a torrent file';

  @override
  String get torrentAddedSuccessfully => 'Torrent added successfully';

  @override
  String get errorAddingTorrent => 'Error adding torrent';

  @override
  String get errorPrefix => 'Error:';

  @override
  String get moviesCategory => 'Movies';

  @override
  String get seriesCategory => 'Series';

  @override
  String get musicCategory => 'Music';

  @override
  String get otherCategory => 'Other';

  @override
  String get donateTitle => 'Please Donate';

  @override
  String get supportDevelopment => 'Support Development!';

  @override
  String get supportDescription => 'Your support helps cover server costs, development tools, and motivates continuous updates and improvements';

  @override
  String get torrents => 'Torrents';

  @override
  String get search => 'Search';

  @override
  String get donate => 'Donate';

  @override
  String get torrServer => 'TorrServer';

  @override
  String get settings => 'Settings';

  @override
  String get searchEnterName => 'Enter a name';

  @override
  String get sortByPeers => 'By Peers';

  @override
  String get sortBySize => 'By Size';

  @override
  String get sortByDate => 'By Date';

  @override
  String get sortTooltipDesc => 'From largest to smallest';

  @override
  String get sortTooltipAsc => 'From smallest to largest';

  @override
  String get filterQuality => 'Quality';

  @override
  String get filterVoice => 'Voice';

  @override
  String get filterSeasons => 'Seasons';

  @override
  String get filterTracker => 'Tracker';

  @override
  String noResultsFound(Object query) {
    return 'By query \"$query\" not found.';
  }

  @override
  String torrentsCount(Object count) {
    return 'Torrents: $count';
  }

  @override
  String get downloadTorrServer => 'Download TorrServer';

  @override
  String get downloadAwaiting => 'Awaiting...';

  @override
  String downloadStarting(Object filename) {
    return 'Download file from: $filename';
  }

  @override
  String downloadProgress(Object percent, Object received, Object total) {
    return 'Downloaded: $percent% $received / $total';
  }

  @override
  String get downloadPreparing => 'Prepare file...';

  @override
  String downloadCompletePath(Object path) {
    return 'Download complete: $path';
  }

  @override
  String get downloadComplete => 'Download complete.';

  @override
  String get downloadCompleteErrorPerm => 'Download complete. Error set exec permission.';

  @override
  String get downloadCompleteErrorQuarantine => 'Download complete. Error remove quarantine attribute.';

  @override
  String get downloadErrorPlatform => 'Download only in desktop OS.';

  @override
  String get downloadErrorUnknownPlatform => 'Error: unknown platform.';

  @override
  String downloadErrorConnect(Object code) {
    return 'Error connect to host: $code';
  }

  @override
  String downloadError(Object error) {
    return 'Error download: $error';
  }

  @override
  String get downloadCanceled => 'Download canceled.';

  @override
  String get buttonCancel => 'Cancel';

  @override
  String get buttonClose => 'Close';

  @override
  String get settingsTitle => 'Settings';

  @override
  String get tsAddressLabel => 'Address of TorrServer (http://<host>:<port>)';

  @override
  String get tsAuthLabel => 'Auth of TorrServer (username:password)';

  @override
  String get tsAuthHint => 'username:password';

  @override
  String get selectPlayerLabel => 'Select a player';

  @override
  String get selectPlayerHint => 'vlc, mpv, etc...';

  @override
  String get rememberSearchParams => 'Remember search parameters';

  @override
  String get saveSettings => 'Save';

  @override
  String get settingsSaved => 'Settings saved!';

  @override
  String get downloadTorrServerButton => 'Download TorrServer';

  @override
  String get startTorrServerButton => 'Start TorrServer';

  @override
  String get stopTorrServerButton => 'Stop TorrServer';

  @override
  String get torrstvLoading => 'TorrsTV Loading...';

  @override
  String torrstvError(Object error) {
    return 'TorrsTV Error: $error';
  }

  @override
  String get torrentInfoTitle => 'Torrent Information';

  @override
  String get loading => 'Loading...';

  @override
  String errorLabel(Object error) {
    return 'Error: $error';
  }

  @override
  String get retryButton => 'Retry';

  @override
  String get hashLabel => 'Hash';

  @override
  String get sizeLabel => 'Size';

  @override
  String get statusLabel => 'Status';

  @override
  String get seedersLabel => 'Seeders';

  @override
  String get speedLabel => 'Speed';

  @override
  String get preloadLabel => 'Preload';

  @override
  String filesTitle(Object count) {
    return 'Files ($count)';
  }

  @override
  String get continueButton => 'Continue Play';

  @override
  String get clearViewedButton => 'Clear Viewed';

  @override
  String get unknownFile => 'Unknown file';

  @override
  String get torrentStatusUnknown => 'Unknown';

  @override
  String get internalError => 'Internal error';

  @override
  String get torrentStatusAdded => 'Torrent added';

  @override
  String get torrentStatusGettingInfo => 'Torrent getting info';

  @override
  String get torrentStatusPreload => 'Torrent preload';

  @override
  String get torrentStatusWorking => 'Torrent working';

  @override
  String get torrentStatusClosed => 'Torrent closed';

  @override
  String get torrentStatusInDb => 'Torrent in db';

  @override
  String get emptyList => 'Empty list';

  @override
  String get torrServerSettingsTitle => 'TorrServer Settings';

  @override
  String get loadingSettings => 'Loading settings...';

  @override
  String torrServerVersion(Object host, Object version) {
    return 'TorrServer version: $version, $host';
  }

  @override
  String get settingsSavedSuccess => 'Settings saved successfully';

  @override
  String get settingsSavedError => 'Failed to save settings';

  @override
  String get sendSettingsButton => 'Send settings';

  @override
  String get tsCacheSizeLabel => 'Cache size';

  @override
  String get tsCacheSizeHint => 'Cache size in bytes (minimum 32MB)';

  @override
  String get tsReaderReadAheadLabel => 'Read-ahead';

  @override
  String get tsReaderReadAheadHint => 'Read-ahead buffer percentage';

  @override
  String get tsPreloadCacheLabel => 'Preload cache size';

  @override
  String get tsPreloadCacheHint => 'Preload cache size';

  @override
  String get tsRetrackersModeLabel => 'Retrackers mode';

  @override
  String get tsRetrackersModeHint => 'Retrackers operation mode';

  @override
  String get tsTorrentDisconnectTimeoutLabel => 'Torrent disconnect timeout';

  @override
  String get tsTorrentDisconnectTimeoutHint => 'Timeout in seconds';

  @override
  String get tsDownloadRateLimitLabel => 'Download rate limit';

  @override
  String get tsDownloadRateLimitHint => 'Download speed limit in KB/s (0 - unlimited)';

  @override
  String get tsUploadRateLimitLabel => 'Upload rate limit';

  @override
  String get tsUploadRateLimitHint => 'Upload speed limit in KB/s (0 - unlimited)';

  @override
  String get tsConnectionsLimitLabel => 'Connections limit';

  @override
  String get tsConnectionsLimitHint => 'Maximum number of connections';

  @override
  String get tsPeersListenPortLabel => 'P2P port';

  @override
  String get tsPeersListenPortHint => 'P2P listen port (0 - random)';

  @override
  String get tsSslPortLabel => 'SSL port';

  @override
  String get tsSslPortHint => 'SSL connection port';

  @override
  String get tsTorrentsSavePathLabel => 'Cache storage path';

  @override
  String get tsTorrentsSavePathHint => 'Path where cache will be stored';

  @override
  String get tsFriendlyNameLabel => 'DLNA name';

  @override
  String get tsFriendlyNameHint => 'Server name for DLNA';

  @override
  String get tsSslCertLabel => 'SSL certificate';

  @override
  String get tsSslCertHint => 'Path to certificate file';

  @override
  String get tsSslKeyLabel => 'SSL key';

  @override
  String get tsSslKeyHint => 'Path to key file';

  @override
  String get tsUseDiskLabel => 'Use disk for cache';

  @override
  String get tsUseDiskHint => 'Write cache to disk (slower but saves memory)';

  @override
  String get tsRemoveCacheOnDropLabel => 'Remove cache on torrent delete';

  @override
  String get tsRemoveCacheOnDropHint => 'Delete data when torrent is removed';

  @override
  String get tsForceEncryptLabel => 'Force encryption';

  @override
  String get tsForceEncryptHint => 'Use encrypted headers';

  @override
  String get tsEnableDebugLabel => 'Enable debug log';

  @override
  String get tsEnableDebugHint => 'Write detailed logs';

  @override
  String get tsEnableDLNALabel => 'Enable DLNA';

  @override
  String get tsEnableDLNAHint => 'Activate DLNA server';

  @override
  String get tsEnableRutorSearchLabel => 'Enable Rutor search';

  @override
  String get tsEnableRutorSearchHint => 'Enable built-in search';

  @override
  String get tsEnableIPv6Label => 'Enable IPv6';

  @override
  String get tsEnableIPv6Hint => 'Allow IPv6';

  @override
  String get tsDisableTCPLabel => 'Disable TCP';

  @override
  String get tsDisableTCPHint => 'Use UTP only';

  @override
  String get tsDisableUTPLabel => 'Disable UTP';

  @override
  String get tsDisableUTPHint => 'Use TCP only';

  @override
  String get tsDisableUPNPLabel => 'Disable UPnP';

  @override
  String get tsDisableUPNPHint => 'Disable automatic port forwarding';

  @override
  String get tsDisableDHTLabel => 'Disable DHT';

  @override
  String get tsDisableDHTHint => 'Disable DHT';

  @override
  String get tsDisablePEXLabel => 'Disable PEX';

  @override
  String get tsDisablePEXHint => 'Disable PEX';

  @override
  String get tsDisableUploadLabel => 'Disable upload';

  @override
  String get tsDisableUploadHint => 'Disable uploading to peers';

  @override
  String get tsResponsiveModeLabel => 'Enable fast read mode';

  @override
  String get tsResponsiveModeHint => 'Fast torrent reading mode';

  @override
  String get playerSettingsTitle => 'Player Settings';

  @override
  String get audioFiltersSection => 'Audio filters';

  @override
  String get enableAudioFilters => 'Enable audio filters';

  @override
  String get panVolumeSection => 'Panorama Volume';

  @override
  String get frontPanVolume => 'Front Pan Volume';

  @override
  String get centerPanVolume => 'Center Pan Volume (voice)';

  @override
  String get surroundPanVolume => 'Surround Pan Volume (side speakers, 7.1 only)';

  @override
  String get rearPanVolume => 'Rear Pan Volume';

  @override
  String get audioEffectsSection => 'Audio effects';

  @override
  String get normalize => 'Normalize (volume normalization)';

  @override
  String get smoothing => 'Smoothing (peak smoothing)';

  @override
  String get stereoTo51 => 'Stereo to 5.1 (split stereo into 5.1 channels)';

  @override
  String get sevenOneTo51 => '7.1 to 5.1 (convert 7.1 to 5.1 channels)';

  @override
  String get playerSettingsButton => 'Settings';

  @override
  String get audioTracksButton => 'Audio tracks';

  @override
  String get subtitleTracksButton => 'Subtitles';

  @override
  String get audioTracksTitle => 'Audio tracks';

  @override
  String get subtitlesTitle => 'Subtitles';

  @override
  String get disableSubtitles => 'Disable';

  @override
  String unknownAudio(Object id) {
    return 'Audio $id';
  }

  @override
  String unknownSubtitles(Object id) {
    return 'Subtitles $id';
  }

  @override
  String get mono => 'mono';

  @override
  String get stereo => 'stereo';

  @override
  String buffering(Object percentage) {
    return 'Buffering: $percentage%';
  }

  @override
  String get language => 'Language';

  @override
  String get systemLanguage => 'System';

  @override
  String get english => 'English';

  @override
  String get russian => 'Russian';

  @override
  String get languageChanged => 'Language changed successfully';
}
