import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_ru.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('ru')
  ];

  /// No description provided for @add.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get add;

  /// No description provided for @magnetLabel.
  ///
  /// In en, this message translates to:
  /// **'Magnet:'**
  String get magnetLabel;

  /// No description provided for @noFileSelected.
  ///
  /// In en, this message translates to:
  /// **'No file selected'**
  String get noFileSelected;

  /// No description provided for @selectTorrentFile.
  ///
  /// In en, this message translates to:
  /// **'Select .torrent file'**
  String get selectTorrentFile;

  /// No description provided for @clearSelectedFile.
  ///
  /// In en, this message translates to:
  /// **'Clear selected file'**
  String get clearSelectedFile;

  /// No description provided for @saving.
  ///
  /// In en, this message translates to:
  /// **'Saving...'**
  String get saving;

  /// No description provided for @titleOfTorrent.
  ///
  /// In en, this message translates to:
  /// **'Title of torrent'**
  String get titleOfTorrent;

  /// No description provided for @enterATitle.
  ///
  /// In en, this message translates to:
  /// **'Enter a title'**
  String get enterATitle;

  /// No description provided for @posterUrlLabel.
  ///
  /// In en, this message translates to:
  /// **'Poster URL'**
  String get posterUrlLabel;

  /// No description provided for @categoryLabel.
  ///
  /// In en, this message translates to:
  /// **'Category'**
  String get categoryLabel;

  /// No description provided for @postersLabel.
  ///
  /// In en, this message translates to:
  /// **'Posters:'**
  String get postersLabel;

  /// No description provided for @enterMagnetOrFile.
  ///
  /// In en, this message translates to:
  /// **'Please enter a magnet link or select a torrent file'**
  String get enterMagnetOrFile;

  /// No description provided for @torrentAddedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Torrent added successfully'**
  String get torrentAddedSuccessfully;

  /// No description provided for @errorAddingTorrent.
  ///
  /// In en, this message translates to:
  /// **'Error adding torrent'**
  String get errorAddingTorrent;

  /// No description provided for @errorPrefix.
  ///
  /// In en, this message translates to:
  /// **'Error:'**
  String get errorPrefix;

  /// No description provided for @moviesCategory.
  ///
  /// In en, this message translates to:
  /// **'Movies'**
  String get moviesCategory;

  /// No description provided for @seriesCategory.
  ///
  /// In en, this message translates to:
  /// **'Series'**
  String get seriesCategory;

  /// No description provided for @musicCategory.
  ///
  /// In en, this message translates to:
  /// **'Music'**
  String get musicCategory;

  /// No description provided for @otherCategory.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get otherCategory;

  /// No description provided for @donateTitle.
  ///
  /// In en, this message translates to:
  /// **'Please Donate'**
  String get donateTitle;

  /// No description provided for @supportDevelopment.
  ///
  /// In en, this message translates to:
  /// **'Support Development!'**
  String get supportDevelopment;

  /// No description provided for @supportDescription.
  ///
  /// In en, this message translates to:
  /// **'Your support helps cover server costs, development tools, and motivates continuous updates and improvements'**
  String get supportDescription;

  /// No description provided for @torrents.
  ///
  /// In en, this message translates to:
  /// **'Torrents'**
  String get torrents;

  /// No description provided for @search.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get search;

  /// No description provided for @donate.
  ///
  /// In en, this message translates to:
  /// **'Donate'**
  String get donate;

  /// No description provided for @torrServer.
  ///
  /// In en, this message translates to:
  /// **'TorrServer'**
  String get torrServer;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @searchEnterName.
  ///
  /// In en, this message translates to:
  /// **'Enter a name'**
  String get searchEnterName;

  /// No description provided for @sortByPeers.
  ///
  /// In en, this message translates to:
  /// **'By Peers'**
  String get sortByPeers;

  /// No description provided for @sortBySize.
  ///
  /// In en, this message translates to:
  /// **'By Size'**
  String get sortBySize;

  /// No description provided for @sortByDate.
  ///
  /// In en, this message translates to:
  /// **'By Date'**
  String get sortByDate;

  /// No description provided for @sortTooltipDesc.
  ///
  /// In en, this message translates to:
  /// **'From largest to smallest'**
  String get sortTooltipDesc;

  /// No description provided for @sortTooltipAsc.
  ///
  /// In en, this message translates to:
  /// **'From smallest to largest'**
  String get sortTooltipAsc;

  /// No description provided for @filterQuality.
  ///
  /// In en, this message translates to:
  /// **'Quality'**
  String get filterQuality;

  /// No description provided for @filterVoice.
  ///
  /// In en, this message translates to:
  /// **'Voice'**
  String get filterVoice;

  /// No description provided for @filterSeasons.
  ///
  /// In en, this message translates to:
  /// **'Seasons'**
  String get filterSeasons;

  /// No description provided for @filterTracker.
  ///
  /// In en, this message translates to:
  /// **'Tracker'**
  String get filterTracker;

  /// No description provided for @noResultsFound.
  ///
  /// In en, this message translates to:
  /// **'By query \"{query}\" not found.'**
  String noResultsFound(Object query);

  /// No description provided for @torrentsCount.
  ///
  /// In en, this message translates to:
  /// **'Torrents: {count}'**
  String torrentsCount(Object count);

  /// No description provided for @downloadTorrServer.
  ///
  /// In en, this message translates to:
  /// **'Download TorrServer'**
  String get downloadTorrServer;

  /// No description provided for @downloadAwaiting.
  ///
  /// In en, this message translates to:
  /// **'Awaiting...'**
  String get downloadAwaiting;

  /// No description provided for @downloadStarting.
  ///
  /// In en, this message translates to:
  /// **'Download file from: {filename}'**
  String downloadStarting(Object filename);

  /// No description provided for @downloadProgress.
  ///
  /// In en, this message translates to:
  /// **'Downloaded: {percent}% {received} / {total}'**
  String downloadProgress(Object percent, Object received, Object total);

  /// No description provided for @downloadPreparing.
  ///
  /// In en, this message translates to:
  /// **'Prepare file...'**
  String get downloadPreparing;

  /// No description provided for @downloadCompletePath.
  ///
  /// In en, this message translates to:
  /// **'Download complete: {path}'**
  String downloadCompletePath(Object path);

  /// No description provided for @downloadComplete.
  ///
  /// In en, this message translates to:
  /// **'Download complete.'**
  String get downloadComplete;

  /// No description provided for @downloadCompleteErrorPerm.
  ///
  /// In en, this message translates to:
  /// **'Download complete. Error set exec permission.'**
  String get downloadCompleteErrorPerm;

  /// No description provided for @downloadCompleteErrorQuarantine.
  ///
  /// In en, this message translates to:
  /// **'Download complete. Error remove quarantine attribute.'**
  String get downloadCompleteErrorQuarantine;

  /// No description provided for @downloadErrorPlatform.
  ///
  /// In en, this message translates to:
  /// **'Download only in desktop OS.'**
  String get downloadErrorPlatform;

  /// No description provided for @downloadErrorUnknownPlatform.
  ///
  /// In en, this message translates to:
  /// **'Error: unknown platform.'**
  String get downloadErrorUnknownPlatform;

  /// No description provided for @downloadErrorConnect.
  ///
  /// In en, this message translates to:
  /// **'Error connect to host: {code}'**
  String downloadErrorConnect(Object code);

  /// No description provided for @downloadError.
  ///
  /// In en, this message translates to:
  /// **'Error download: {error}'**
  String downloadError(Object error);

  /// No description provided for @downloadCanceled.
  ///
  /// In en, this message translates to:
  /// **'Download canceled.'**
  String get downloadCanceled;

  /// No description provided for @buttonCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get buttonCancel;

  /// No description provided for @buttonClose.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get buttonClose;

  /// No description provided for @settingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsTitle;

  /// No description provided for @tsAddressLabel.
  ///
  /// In en, this message translates to:
  /// **'Address of TorrServer (http://<host>:<port>)'**
  String get tsAddressLabel;

  /// No description provided for @tsAuthLabel.
  ///
  /// In en, this message translates to:
  /// **'Auth of TorrServer (username:password)'**
  String get tsAuthLabel;

  /// No description provided for @tsAuthHint.
  ///
  /// In en, this message translates to:
  /// **'username:password'**
  String get tsAuthHint;

  /// No description provided for @selectPlayerLabel.
  ///
  /// In en, this message translates to:
  /// **'Select a player'**
  String get selectPlayerLabel;

  /// No description provided for @selectPlayerHint.
  ///
  /// In en, this message translates to:
  /// **'vlc, mpv, etc...'**
  String get selectPlayerHint;

  /// No description provided for @rememberSearchParams.
  ///
  /// In en, this message translates to:
  /// **'Remember search parameters'**
  String get rememberSearchParams;

  /// No description provided for @saveSettings.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get saveSettings;

  /// No description provided for @settingsSaved.
  ///
  /// In en, this message translates to:
  /// **'Settings saved!'**
  String get settingsSaved;

  /// No description provided for @downloadTorrServerButton.
  ///
  /// In en, this message translates to:
  /// **'Download TorrServer'**
  String get downloadTorrServerButton;

  /// No description provided for @startTorrServerButton.
  ///
  /// In en, this message translates to:
  /// **'Start TorrServer'**
  String get startTorrServerButton;

  /// No description provided for @stopTorrServerButton.
  ///
  /// In en, this message translates to:
  /// **'Stop TorrServer'**
  String get stopTorrServerButton;

  /// No description provided for @torrstvLoading.
  ///
  /// In en, this message translates to:
  /// **'TorrsTV Loading...'**
  String get torrstvLoading;

  /// No description provided for @torrstvError.
  ///
  /// In en, this message translates to:
  /// **'TorrsTV Error: {error}'**
  String torrstvError(Object error);

  /// No description provided for @torrentInfoTitle.
  ///
  /// In en, this message translates to:
  /// **'Torrent Information'**
  String get torrentInfoTitle;

  /// No description provided for @loading.
  ///
  /// In en, this message translates to:
  /// **'Loading...'**
  String get loading;

  /// No description provided for @errorLabel.
  ///
  /// In en, this message translates to:
  /// **'Error: {error}'**
  String errorLabel(Object error);

  /// No description provided for @retryButton.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retryButton;

  /// No description provided for @hashLabel.
  ///
  /// In en, this message translates to:
  /// **'Hash'**
  String get hashLabel;

  /// No description provided for @sizeLabel.
  ///
  /// In en, this message translates to:
  /// **'Size'**
  String get sizeLabel;

  /// No description provided for @statusLabel.
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get statusLabel;

  /// No description provided for @seedersLabel.
  ///
  /// In en, this message translates to:
  /// **'Seeders'**
  String get seedersLabel;

  /// No description provided for @speedLabel.
  ///
  /// In en, this message translates to:
  /// **'Speed'**
  String get speedLabel;

  /// No description provided for @preloadLabel.
  ///
  /// In en, this message translates to:
  /// **'Preload'**
  String get preloadLabel;

  /// No description provided for @filesTitle.
  ///
  /// In en, this message translates to:
  /// **'Files ({count})'**
  String filesTitle(Object count);

  /// No description provided for @continueButton.
  ///
  /// In en, this message translates to:
  /// **'Continue Play'**
  String get continueButton;

  /// No description provided for @clearViewedButton.
  ///
  /// In en, this message translates to:
  /// **'Clear Viewed'**
  String get clearViewedButton;

  /// No description provided for @unknownFile.
  ///
  /// In en, this message translates to:
  /// **'Unknown file'**
  String get unknownFile;

  /// No description provided for @torrentStatusUnknown.
  ///
  /// In en, this message translates to:
  /// **'Unknown'**
  String get torrentStatusUnknown;

  /// No description provided for @internalError.
  ///
  /// In en, this message translates to:
  /// **'Internal error'**
  String get internalError;

  /// No description provided for @torrentStatusAdded.
  ///
  /// In en, this message translates to:
  /// **'Torrent added'**
  String get torrentStatusAdded;

  /// No description provided for @torrentStatusGettingInfo.
  ///
  /// In en, this message translates to:
  /// **'Torrent getting info'**
  String get torrentStatusGettingInfo;

  /// No description provided for @torrentStatusPreload.
  ///
  /// In en, this message translates to:
  /// **'Torrent preload'**
  String get torrentStatusPreload;

  /// No description provided for @torrentStatusWorking.
  ///
  /// In en, this message translates to:
  /// **'Torrent working'**
  String get torrentStatusWorking;

  /// No description provided for @torrentStatusClosed.
  ///
  /// In en, this message translates to:
  /// **'Torrent closed'**
  String get torrentStatusClosed;

  /// No description provided for @torrentStatusInDb.
  ///
  /// In en, this message translates to:
  /// **'Torrent in db'**
  String get torrentStatusInDb;

  /// No description provided for @emptyList.
  ///
  /// In en, this message translates to:
  /// **'Empty list'**
  String get emptyList;

  /// No description provided for @torrServerSettingsTitle.
  ///
  /// In en, this message translates to:
  /// **'TorrServer Settings'**
  String get torrServerSettingsTitle;

  /// No description provided for @loadingSettings.
  ///
  /// In en, this message translates to:
  /// **'Loading settings...'**
  String get loadingSettings;

  /// No description provided for @torrServerVersion.
  ///
  /// In en, this message translates to:
  /// **'TorrServer version: {version}, {host}'**
  String torrServerVersion(Object host, Object version);

  /// No description provided for @settingsSavedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Settings saved successfully'**
  String get settingsSavedSuccess;

  /// No description provided for @settingsSavedError.
  ///
  /// In en, this message translates to:
  /// **'Failed to save settings'**
  String get settingsSavedError;

  /// No description provided for @sendSettingsButton.
  ///
  /// In en, this message translates to:
  /// **'Send settings'**
  String get sendSettingsButton;

  /// No description provided for @tsCacheSizeLabel.
  ///
  /// In en, this message translates to:
  /// **'Cache size'**
  String get tsCacheSizeLabel;

  /// No description provided for @tsCacheSizeHint.
  ///
  /// In en, this message translates to:
  /// **'Cache size in bytes (minimum 32MB)'**
  String get tsCacheSizeHint;

  /// No description provided for @tsReaderReadAheadLabel.
  ///
  /// In en, this message translates to:
  /// **'Read-ahead'**
  String get tsReaderReadAheadLabel;

  /// No description provided for @tsReaderReadAheadHint.
  ///
  /// In en, this message translates to:
  /// **'Read-ahead buffer percentage'**
  String get tsReaderReadAheadHint;

  /// No description provided for @tsPreloadCacheLabel.
  ///
  /// In en, this message translates to:
  /// **'Preload cache size'**
  String get tsPreloadCacheLabel;

  /// No description provided for @tsPreloadCacheHint.
  ///
  /// In en, this message translates to:
  /// **'Preload cache size'**
  String get tsPreloadCacheHint;

  /// No description provided for @tsRetrackersModeLabel.
  ///
  /// In en, this message translates to:
  /// **'Retrackers mode'**
  String get tsRetrackersModeLabel;

  /// No description provided for @tsRetrackersModeHint.
  ///
  /// In en, this message translates to:
  /// **'Retrackers operation mode'**
  String get tsRetrackersModeHint;

  /// No description provided for @tsTorrentDisconnectTimeoutLabel.
  ///
  /// In en, this message translates to:
  /// **'Torrent disconnect timeout'**
  String get tsTorrentDisconnectTimeoutLabel;

  /// No description provided for @tsTorrentDisconnectTimeoutHint.
  ///
  /// In en, this message translates to:
  /// **'Timeout in seconds'**
  String get tsTorrentDisconnectTimeoutHint;

  /// No description provided for @tsDownloadRateLimitLabel.
  ///
  /// In en, this message translates to:
  /// **'Download rate limit'**
  String get tsDownloadRateLimitLabel;

  /// No description provided for @tsDownloadRateLimitHint.
  ///
  /// In en, this message translates to:
  /// **'Download speed limit in KB/s (0 - unlimited)'**
  String get tsDownloadRateLimitHint;

  /// No description provided for @tsUploadRateLimitLabel.
  ///
  /// In en, this message translates to:
  /// **'Upload rate limit'**
  String get tsUploadRateLimitLabel;

  /// No description provided for @tsUploadRateLimitHint.
  ///
  /// In en, this message translates to:
  /// **'Upload speed limit in KB/s (0 - unlimited)'**
  String get tsUploadRateLimitHint;

  /// No description provided for @tsConnectionsLimitLabel.
  ///
  /// In en, this message translates to:
  /// **'Connections limit'**
  String get tsConnectionsLimitLabel;

  /// No description provided for @tsConnectionsLimitHint.
  ///
  /// In en, this message translates to:
  /// **'Maximum number of connections'**
  String get tsConnectionsLimitHint;

  /// No description provided for @tsPeersListenPortLabel.
  ///
  /// In en, this message translates to:
  /// **'P2P port'**
  String get tsPeersListenPortLabel;

  /// No description provided for @tsPeersListenPortHint.
  ///
  /// In en, this message translates to:
  /// **'P2P listen port (0 - random)'**
  String get tsPeersListenPortHint;

  /// No description provided for @tsSslPortLabel.
  ///
  /// In en, this message translates to:
  /// **'SSL port'**
  String get tsSslPortLabel;

  /// No description provided for @tsSslPortHint.
  ///
  /// In en, this message translates to:
  /// **'SSL connection port'**
  String get tsSslPortHint;

  /// No description provided for @tsTorrentsSavePathLabel.
  ///
  /// In en, this message translates to:
  /// **'Cache storage path'**
  String get tsTorrentsSavePathLabel;

  /// No description provided for @tsTorrentsSavePathHint.
  ///
  /// In en, this message translates to:
  /// **'Path where cache will be stored'**
  String get tsTorrentsSavePathHint;

  /// No description provided for @tsFriendlyNameLabel.
  ///
  /// In en, this message translates to:
  /// **'DLNA name'**
  String get tsFriendlyNameLabel;

  /// No description provided for @tsFriendlyNameHint.
  ///
  /// In en, this message translates to:
  /// **'Server name for DLNA'**
  String get tsFriendlyNameHint;

  /// No description provided for @tsSslCertLabel.
  ///
  /// In en, this message translates to:
  /// **'SSL certificate'**
  String get tsSslCertLabel;

  /// No description provided for @tsSslCertHint.
  ///
  /// In en, this message translates to:
  /// **'Path to certificate file'**
  String get tsSslCertHint;

  /// No description provided for @tsSslKeyLabel.
  ///
  /// In en, this message translates to:
  /// **'SSL key'**
  String get tsSslKeyLabel;

  /// No description provided for @tsSslKeyHint.
  ///
  /// In en, this message translates to:
  /// **'Path to key file'**
  String get tsSslKeyHint;

  /// No description provided for @tsUseDiskLabel.
  ///
  /// In en, this message translates to:
  /// **'Use disk for cache'**
  String get tsUseDiskLabel;

  /// No description provided for @tsUseDiskHint.
  ///
  /// In en, this message translates to:
  /// **'Write cache to disk (slower but saves memory)'**
  String get tsUseDiskHint;

  /// No description provided for @tsRemoveCacheOnDropLabel.
  ///
  /// In en, this message translates to:
  /// **'Remove cache on torrent delete'**
  String get tsRemoveCacheOnDropLabel;

  /// No description provided for @tsRemoveCacheOnDropHint.
  ///
  /// In en, this message translates to:
  /// **'Delete data when torrent is removed'**
  String get tsRemoveCacheOnDropHint;

  /// No description provided for @tsForceEncryptLabel.
  ///
  /// In en, this message translates to:
  /// **'Force encryption'**
  String get tsForceEncryptLabel;

  /// No description provided for @tsForceEncryptHint.
  ///
  /// In en, this message translates to:
  /// **'Use encrypted headers'**
  String get tsForceEncryptHint;

  /// No description provided for @tsEnableDebugLabel.
  ///
  /// In en, this message translates to:
  /// **'Enable debug log'**
  String get tsEnableDebugLabel;

  /// No description provided for @tsEnableDebugHint.
  ///
  /// In en, this message translates to:
  /// **'Write detailed logs'**
  String get tsEnableDebugHint;

  /// No description provided for @tsEnableDLNALabel.
  ///
  /// In en, this message translates to:
  /// **'Enable DLNA'**
  String get tsEnableDLNALabel;

  /// No description provided for @tsEnableDLNAHint.
  ///
  /// In en, this message translates to:
  /// **'Activate DLNA server'**
  String get tsEnableDLNAHint;

  /// No description provided for @tsEnableRutorSearchLabel.
  ///
  /// In en, this message translates to:
  /// **'Enable Rutor search'**
  String get tsEnableRutorSearchLabel;

  /// No description provided for @tsEnableRutorSearchHint.
  ///
  /// In en, this message translates to:
  /// **'Enable built-in search'**
  String get tsEnableRutorSearchHint;

  /// No description provided for @tsEnableIPv6Label.
  ///
  /// In en, this message translates to:
  /// **'Enable IPv6'**
  String get tsEnableIPv6Label;

  /// No description provided for @tsEnableIPv6Hint.
  ///
  /// In en, this message translates to:
  /// **'Allow IPv6'**
  String get tsEnableIPv6Hint;

  /// No description provided for @tsDisableTCPLabel.
  ///
  /// In en, this message translates to:
  /// **'Disable TCP'**
  String get tsDisableTCPLabel;

  /// No description provided for @tsDisableTCPHint.
  ///
  /// In en, this message translates to:
  /// **'Use UTP only'**
  String get tsDisableTCPHint;

  /// No description provided for @tsDisableUTPLabel.
  ///
  /// In en, this message translates to:
  /// **'Disable UTP'**
  String get tsDisableUTPLabel;

  /// No description provided for @tsDisableUTPHint.
  ///
  /// In en, this message translates to:
  /// **'Use TCP only'**
  String get tsDisableUTPHint;

  /// No description provided for @tsDisableUPNPLabel.
  ///
  /// In en, this message translates to:
  /// **'Disable UPnP'**
  String get tsDisableUPNPLabel;

  /// No description provided for @tsDisableUPNPHint.
  ///
  /// In en, this message translates to:
  /// **'Disable automatic port forwarding'**
  String get tsDisableUPNPHint;

  /// No description provided for @tsDisableDHTLabel.
  ///
  /// In en, this message translates to:
  /// **'Disable DHT'**
  String get tsDisableDHTLabel;

  /// No description provided for @tsDisableDHTHint.
  ///
  /// In en, this message translates to:
  /// **'Disable DHT'**
  String get tsDisableDHTHint;

  /// No description provided for @tsDisablePEXLabel.
  ///
  /// In en, this message translates to:
  /// **'Disable PEX'**
  String get tsDisablePEXLabel;

  /// No description provided for @tsDisablePEXHint.
  ///
  /// In en, this message translates to:
  /// **'Disable PEX'**
  String get tsDisablePEXHint;

  /// No description provided for @tsDisableUploadLabel.
  ///
  /// In en, this message translates to:
  /// **'Disable upload'**
  String get tsDisableUploadLabel;

  /// No description provided for @tsDisableUploadHint.
  ///
  /// In en, this message translates to:
  /// **'Disable uploading to peers'**
  String get tsDisableUploadHint;

  /// No description provided for @tsResponsiveModeLabel.
  ///
  /// In en, this message translates to:
  /// **'Enable fast read mode'**
  String get tsResponsiveModeLabel;

  /// No description provided for @tsResponsiveModeHint.
  ///
  /// In en, this message translates to:
  /// **'Fast torrent reading mode'**
  String get tsResponsiveModeHint;

  /// No description provided for @playerSettingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Player Settings'**
  String get playerSettingsTitle;

  /// No description provided for @audioFiltersSection.
  ///
  /// In en, this message translates to:
  /// **'Audio filters'**
  String get audioFiltersSection;

  /// No description provided for @enableAudioFilters.
  ///
  /// In en, this message translates to:
  /// **'Enable audio filters'**
  String get enableAudioFilters;

  /// No description provided for @panVolumeSection.
  ///
  /// In en, this message translates to:
  /// **'Panorama Volume'**
  String get panVolumeSection;

  /// No description provided for @frontPanVolume.
  ///
  /// In en, this message translates to:
  /// **'Front Pan Volume'**
  String get frontPanVolume;

  /// No description provided for @centerPanVolume.
  ///
  /// In en, this message translates to:
  /// **'Center Pan Volume (voice)'**
  String get centerPanVolume;

  /// No description provided for @surroundPanVolume.
  ///
  /// In en, this message translates to:
  /// **'Surround Pan Volume (side speakers, 7.1 only)'**
  String get surroundPanVolume;

  /// No description provided for @rearPanVolume.
  ///
  /// In en, this message translates to:
  /// **'Rear Pan Volume'**
  String get rearPanVolume;

  /// No description provided for @audioEffectsSection.
  ///
  /// In en, this message translates to:
  /// **'Audio effects'**
  String get audioEffectsSection;

  /// No description provided for @normalize.
  ///
  /// In en, this message translates to:
  /// **'Normalize (volume normalization)'**
  String get normalize;

  /// No description provided for @smoothing.
  ///
  /// In en, this message translates to:
  /// **'Smoothing (peak smoothing)'**
  String get smoothing;

  /// No description provided for @stereoTo51.
  ///
  /// In en, this message translates to:
  /// **'Stereo to 5.1 (split stereo into 5.1 channels)'**
  String get stereoTo51;

  /// No description provided for @sevenOneTo51.
  ///
  /// In en, this message translates to:
  /// **'7.1 to 5.1 (convert 7.1 to 5.1 channels)'**
  String get sevenOneTo51;

  /// No description provided for @playerSettingsButton.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get playerSettingsButton;

  /// No description provided for @audioTracksButton.
  ///
  /// In en, this message translates to:
  /// **'Audio tracks'**
  String get audioTracksButton;

  /// No description provided for @subtitleTracksButton.
  ///
  /// In en, this message translates to:
  /// **'Subtitles'**
  String get subtitleTracksButton;

  /// No description provided for @audioTracksTitle.
  ///
  /// In en, this message translates to:
  /// **'Audio tracks'**
  String get audioTracksTitle;

  /// No description provided for @subtitlesTitle.
  ///
  /// In en, this message translates to:
  /// **'Subtitles'**
  String get subtitlesTitle;

  /// No description provided for @disableSubtitles.
  ///
  /// In en, this message translates to:
  /// **'Disable'**
  String get disableSubtitles;

  /// No description provided for @unknownAudio.
  ///
  /// In en, this message translates to:
  /// **'Audio {id}'**
  String unknownAudio(Object id);

  /// No description provided for @unknownSubtitles.
  ///
  /// In en, this message translates to:
  /// **'Subtitles {id}'**
  String unknownSubtitles(Object id);

  /// No description provided for @mono.
  ///
  /// In en, this message translates to:
  /// **'mono'**
  String get mono;

  /// No description provided for @stereo.
  ///
  /// In en, this message translates to:
  /// **'stereo'**
  String get stereo;

  /// No description provided for @buffering.
  ///
  /// In en, this message translates to:
  /// **'Buffering: {percentage}%'**
  String buffering(Object percentage);

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @systemLanguage.
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get systemLanguage;

  /// No description provided for @english.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get english;

  /// No description provided for @russian.
  ///
  /// In en, this message translates to:
  /// **'Russian'**
  String get russian;

  /// No description provided for @languageChanged.
  ///
  /// In en, this message translates to:
  /// **'Language changed successfully'**
  String get languageChanged;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['en', 'ru'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en': return AppLocalizationsEn();
    case 'ru': return AppLocalizationsRu();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
