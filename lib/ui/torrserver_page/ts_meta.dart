// lib/ui/torrserver_page/torrserver_metadata_l10n.dart
import 'package:torrstv/l10n/app_localizations.dart';

Map<String, ({String label, String hint})> getTorrServerMetadata(AppLocalizations l10n) {
  return {
    // --- Числовые настройки (int) ---
    'CacheSize': (label: l10n.tsCacheSizeLabel, hint: l10n.tsCacheSizeHint),
    'ReaderReadAHead': (label: l10n.tsReaderReadAheadLabel, hint: l10n.tsReaderReadAheadHint),
    'PreloadCache': (label: l10n.tsPreloadCacheLabel, hint: l10n.tsPreloadCacheHint),
    'RetrackersMode': (label: l10n.tsRetrackersModeLabel, hint: l10n.tsRetrackersModeHint),
    'TorrentDisconnectTimeout': (label: l10n.tsTorrentDisconnectTimeoutLabel, hint: l10n.tsTorrentDisconnectTimeoutHint),
    'DownloadRateLimit': (label: l10n.tsDownloadRateLimitLabel, hint: l10n.tsDownloadRateLimitHint),
    'UploadRateLimit': (label: l10n.tsUploadRateLimitLabel, hint: l10n.tsUploadRateLimitHint),
    'ConnectionsLimit': (label: l10n.tsConnectionsLimitLabel, hint: l10n.tsConnectionsLimitHint),
    'PeersListenPort': (label: l10n.tsPeersListenPortLabel, hint: l10n.tsPeersListenPortHint),
    'SslPort': (label: l10n.tsSslPortLabel, hint: l10n.tsSslPortHint),

    // --- Строковые настройки (String) ---
    'TorrentsSavePath': (label: l10n.tsTorrentsSavePathLabel, hint: l10n.tsTorrentsSavePathHint),
    'FriendlyName': (label: l10n.tsFriendlyNameLabel, hint: l10n.tsFriendlyNameHint),
    'SslCert': (label: l10n.tsSslCertLabel, hint: l10n.tsSslCertHint),
    'SslKey': (label: l10n.tsSslKeyLabel, hint: l10n.tsSslKeyHint),

    // --- Булевы настройки (bool) ---
    'UseDisk': (label: l10n.tsUseDiskLabel, hint: l10n.tsUseDiskHint),
    'RemoveCacheOnDrop': (label: l10n.tsRemoveCacheOnDropLabel, hint: l10n.tsRemoveCacheOnDropHint),
    'ForceEncrypt': (label: l10n.tsForceEncryptLabel, hint: l10n.tsForceEncryptHint),
    'EnableDebug': (label: l10n.tsEnableDebugLabel, hint: l10n.tsEnableDebugHint),
    'EnableDLNA': (label: l10n.tsEnableDLNALabel, hint: l10n.tsEnableDLNAHint),
    'EnableRutorSearch': (label: l10n.tsEnableRutorSearchLabel, hint: l10n.tsEnableRutorSearchHint),
    'EnableIPv6': (label: l10n.tsEnableIPv6Label, hint: l10n.tsEnableIPv6Hint),
    'DisableTCP': (label: l10n.tsDisableTCPLabel, hint: l10n.tsDisableTCPHint),
    'DisableUTP': (label: l10n.tsDisableUTPLabel, hint: l10n.tsDisableUTPHint),
    'DisableUPNP': (label: l10n.tsDisableUPNPLabel, hint: l10n.tsDisableUPNPHint),
    'DisableDHT': (label: l10n.tsDisableDHTLabel, hint: l10n.tsDisableDHTHint),
    'DisablePEX': (label: l10n.tsDisablePEXLabel, hint: l10n.tsDisablePEXHint),
    'DisableUpload': (label: l10n.tsDisableUploadLabel, hint: l10n.tsDisableUploadHint),
    'ResponsiveMode': (label: l10n.tsResponsiveModeLabel, hint: l10n.tsResponsiveModeHint),
  };
}
