// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Russian (`ru`).
class AppLocalizationsRu extends AppLocalizations {
  AppLocalizationsRu([String locale = 'ru']) : super(locale);

  @override
  String get add => 'Добавить';

  @override
  String get magnetLabel => 'Магнет:';

  @override
  String get noFileSelected => 'Файл не выбран';

  @override
  String get selectTorrentFile => 'Выбрать .torrent файл';

  @override
  String get clearSelectedFile => 'Очистить выбранный файл';

  @override
  String get saving => 'Сохранение...';

  @override
  String get titleOfTorrent => 'Название торрента';

  @override
  String get enterATitle => 'Введите название';

  @override
  String get posterUrlLabel => 'URL постера';

  @override
  String get categoryLabel => 'Категория';

  @override
  String get postersLabel => 'Постеры:';

  @override
  String get enterMagnetOrFile => 'Пожалуйста, введите магнет-ссылку или выберите торрент-файл';

  @override
  String get torrentAddedSuccessfully => 'Торрент успешно добавлен';

  @override
  String get errorAddingTorrent => 'Ошибка при добавлении торрента';

  @override
  String get errorPrefix => 'Ошибка:';

  @override
  String get moviesCategory => 'Фильмы';

  @override
  String get seriesCategory => 'Сериалы';

  @override
  String get musicCategory => 'Музыка';

  @override
  String get otherCategory => 'Другое';

  @override
  String get donateTitle => 'Пожертвовать';

  @override
  String get supportDevelopment => 'Поддержите разработку!';

  @override
  String get supportDescription => 'Ваша поддержка помогает покрывать расходы на серверы, инструменты для разработки и стимулирует постоянные обновления и улучшения';

  @override
  String get torrents => 'Торренты';

  @override
  String get search => 'Поиск';

  @override
  String get donate => 'Пожертвовать';

  @override
  String get torrServer => 'TorrServer';

  @override
  String get settings => 'Настройки';

  @override
  String get searchEnterName => 'Введите название';

  @override
  String get sortByPeers => 'По раздающим';

  @override
  String get sortBySize => 'По размеру';

  @override
  String get sortByDate => 'По дате';

  @override
  String get sortTooltipDesc => 'От большего к меньшему';

  @override
  String get sortTooltipAsc => 'От меньшего к большему';

  @override
  String get filterQuality => 'Качество';

  @override
  String get filterVoice => 'Озвучка';

  @override
  String get filterSeasons => 'Сезоны';

  @override
  String get filterTracker => 'Трекер';

  @override
  String noResultsFound(Object query) {
    return 'По запросу «$query» ничего не найдено.';
  }

  @override
  String torrentsCount(Object count) {
    return 'Торрентов: $count';
  }

  @override
  String get downloadTorrServer => 'Скачать TorrServer';

  @override
  String get downloadAwaiting => 'Ожидание...';

  @override
  String downloadStarting(Object filename) {
    return 'Скачивание файла: $filename';
  }

  @override
  String downloadProgress(Object percent, Object received, Object total) {
    return 'Скачано: $percent% $received / $total';
  }

  @override
  String get downloadPreparing => 'Подготовка файла...';

  @override
  String downloadCompletePath(Object path) {
    return 'Загрузка завершена: $path';
  }

  @override
  String get downloadComplete => 'Загрузка завершена.';

  @override
  String get downloadCompleteErrorPerm => 'Загрузка завершена. Ошибка установки прав на выполнение.';

  @override
  String get downloadCompleteErrorQuarantine => 'Загрузка завершена. Ошибка снятия карантина.';

  @override
  String get downloadErrorPlatform => 'Загрузка доступна только в десктопных ОС.';

  @override
  String get downloadErrorUnknownPlatform => 'Ошибка: неизвестная платформа.';

  @override
  String downloadErrorConnect(Object code) {
    return 'Ошибка подключения к хосту: $code';
  }

  @override
  String downloadError(Object error) {
    return 'Ошибка загрузки: $error';
  }

  @override
  String get downloadCanceled => 'Загрузка отменена.';

  @override
  String get buttonCancel => 'Отмена';

  @override
  String get buttonClose => 'Закрыть';

  @override
  String get settingsTitle => 'Настройки';

  @override
  String get tsAddressLabel => 'Адрес TorrServer (http://<хост>:<порт>)';

  @override
  String get tsAuthLabel => 'Авторизация TorrServer (логин:пароль)';

  @override
  String get tsAuthHint => 'логин:пароль';

  @override
  String get selectPlayerLabel => 'Выберите плеер';

  @override
  String get selectPlayerHint => 'vlc, mpv и др...';

  @override
  String get rememberSearchParams => 'Запоминать параметры поиска';

  @override
  String get saveSettings => 'Сохранить';

  @override
  String get settingsSaved => 'Настройки сохранены!';

  @override
  String get downloadTorrServerButton => 'Скачать TorrServer';

  @override
  String get startTorrServerButton => 'Запустить TorrServer';

  @override
  String get stopTorrServerButton => 'Остановить TorrServer';

  @override
  String get torrstvLoading => 'TorrsTV загружается...';

  @override
  String torrstvError(Object error) {
    return 'TorrsTV ошибка: $error';
  }

  @override
  String get torrentInfoTitle => 'Информация о торренте';

  @override
  String get loading => 'Загрузка...';

  @override
  String errorLabel(Object error) {
    return 'Ошибка: $error';
  }

  @override
  String get retryButton => 'Повторить';

  @override
  String get hashLabel => 'Хеш';

  @override
  String get sizeLabel => 'Размер';

  @override
  String get statusLabel => 'Статус';

  @override
  String get seedersLabel => 'Раздающие';

  @override
  String get speedLabel => 'Скорость';

  @override
  String get preloadLabel => 'Предзагрузка';

  @override
  String filesTitle(Object count) {
    return 'Файлы ($count)';
  }

  @override
  String get continueButton => 'Продолжить воспроизведение';

  @override
  String get clearViewedButton => 'Очистить просмотренные';

  @override
  String get unknownFile => 'Неизвестный файл';

  @override
  String get torrentStatusUnknown => 'Неизвестен';

  @override
  String get internalError => 'Внутренняя ошибка';

  @override
  String get torrentStatusAdded => 'Торрент добавлен';

  @override
  String get torrentStatusGettingInfo => 'Получение информации о торренте';

  @override
  String get torrentStatusPreload => 'Предзагрузка торрента';

  @override
  String get torrentStatusWorking => 'Торрент работает';

  @override
  String get torrentStatusClosed => 'Торрент закрыт';

  @override
  String get torrentStatusInDb => 'Торрент в базе';

  @override
  String get emptyList => 'Список пуст';

  @override
  String get torrServerSettingsTitle => 'Настройки TorrServer';

  @override
  String get loadingSettings => 'Загрузка настроек...';

  @override
  String torrServerVersion(Object host, Object version) {
    return 'Версия TorrServer: $version, $host';
  }

  @override
  String get settingsSavedSuccess => 'Настройки успешно сохранены';

  @override
  String get settingsSavedError => 'Не удалось сохранить настройки';

  @override
  String get sendSettingsButton => 'Отправить настройки';

  @override
  String get tsCacheSizeLabel => 'Размер кэша';

  @override
  String get tsCacheSizeHint => 'Размер кэша в байтах (минимум 32 МБ)';

  @override
  String get tsReaderReadAheadLabel => 'Упреждающее чтение';

  @override
  String get tsReaderReadAheadHint => 'Процент буфера упреждающего чтения';

  @override
  String get tsPreloadCacheLabel => 'Размер предзагрузки';

  @override
  String get tsPreloadCacheHint => 'Размер кэша предзагрузки';

  @override
  String get tsRetrackersModeLabel => 'Режим ретрекеров';

  @override
  String get tsRetrackersModeHint => 'Режим работы с ретрекерами';

  @override
  String get tsTorrentDisconnectTimeoutLabel => 'Таймаут отключения торрента';

  @override
  String get tsTorrentDisconnectTimeoutHint => 'Таймаут в секундах';

  @override
  String get tsDownloadRateLimitLabel => 'Лимит загрузки';

  @override
  String get tsDownloadRateLimitHint => 'Ограничение скорости загрузки в КБ/с (0 — без лимита)';

  @override
  String get tsUploadRateLimitLabel => 'Лимит отдачи';

  @override
  String get tsUploadRateLimitHint => 'Ограничение скорости отдачи в КБ/с (0 — без лимита)';

  @override
  String get tsConnectionsLimitLabel => 'Лимит соединений';

  @override
  String get tsConnectionsLimitHint => 'Максимальное количество соединений';

  @override
  String get tsPeersListenPortLabel => 'P2P порт';

  @override
  String get tsPeersListenPortHint => 'Порт для P2P-соединений (0 — случайный)';

  @override
  String get tsSslPortLabel => 'SSL порт';

  @override
  String get tsSslPortHint => 'Порт для SSL-соединений';

  @override
  String get tsTorrentsSavePathLabel => 'Путь хранения кэша';

  @override
  String get tsTorrentsSavePathHint => 'Путь, где будет сохранён кэш';

  @override
  String get tsFriendlyNameLabel => 'Имя DLNA';

  @override
  String get tsFriendlyNameHint => 'Имя сервера для DLNA';

  @override
  String get tsSslCertLabel => 'SSL-сертификат';

  @override
  String get tsSslCertHint => 'Путь к файлу сертификата';

  @override
  String get tsSslKeyLabel => 'SSL-ключ';

  @override
  String get tsSslKeyHint => 'Путь к файлу ключа';

  @override
  String get tsUseDiskLabel => 'Использовать диск для кэша';

  @override
  String get tsUseDiskHint => 'Записывать кэш на диск (медленнее, но экономит память)';

  @override
  String get tsRemoveCacheOnDropLabel => 'Удалять кэш при удалении торрента';

  @override
  String get tsRemoveCacheOnDropHint => 'Удалять данные при удалении торрента';

  @override
  String get tsForceEncryptLabel => 'Принудительное шифрование';

  @override
  String get tsForceEncryptHint => 'Использовать зашифрованные заголовки';

  @override
  String get tsEnableDebugLabel => 'Включить отладочный лог';

  @override
  String get tsEnableDebugHint => 'Записывать подробные логи';

  @override
  String get tsEnableDLNALabel => 'Включить DLNA';

  @override
  String get tsEnableDLNAHint => 'Активировать DLNA-сервер';

  @override
  String get tsEnableRutorSearchLabel => 'Включить поиск Rutor';

  @override
  String get tsEnableRutorSearchHint => 'Включить встроенный поиск';

  @override
  String get tsEnableIPv6Label => 'Включить IPv6';

  @override
  String get tsEnableIPv6Hint => 'Разрешить IPv6';

  @override
  String get tsDisableTCPLabel => 'Отключить TCP';

  @override
  String get tsDisableTCPHint => 'Использовать только UTP';

  @override
  String get tsDisableUTPLabel => 'Отключить UTP';

  @override
  String get tsDisableUTPHint => 'Использовать только TCP';

  @override
  String get tsDisableUPNPLabel => 'Отключить UPnP';

  @override
  String get tsDisableUPNPHint => 'Отключить автоматическую настройку портов';

  @override
  String get tsDisableDHTLabel => 'Отключить DHT';

  @override
  String get tsDisableDHTHint => 'Отключить DHT';

  @override
  String get tsDisablePEXLabel => 'Отключить PEX';

  @override
  String get tsDisablePEXHint => 'Отключить PEX';

  @override
  String get tsDisableUploadLabel => 'Отключить отдачу';

  @override
  String get tsDisableUploadHint => 'Запретить отдачу пиров';

  @override
  String get tsResponsiveModeLabel => 'Быстрый режим чтения';

  @override
  String get tsResponsiveModeHint => 'Быстрый режим чтения торрента';

  @override
  String get playerSettingsTitle => 'Настройки плеера';

  @override
  String get audioFiltersSection => 'Аудиофильтры';

  @override
  String get enableAudioFilters => 'Включить аудиофильтры';

  @override
  String get panVolumeSection => 'Панорамирование звука';

  @override
  String get frontPanVolume => 'Громкость передних колонок';

  @override
  String get centerPanVolume => 'Громкость центральной колонки (голос)';

  @override
  String get surroundPanVolume => 'Громкость боковых колонок (только 7.1)';

  @override
  String get rearPanVolume => 'Громкость задних колонок';

  @override
  String get audioEffectsSection => 'Аудиоэффекты';

  @override
  String get normalize => 'Нормализация (выравнивание громкости)';

  @override
  String get smoothing => 'Сглаживание (подавление пиков)';

  @override
  String get stereoTo51 => 'Stereo → 5.1 (разделить стерео на 5.1 каналов)';

  @override
  String get sevenOneTo51 => '7.1 → 5.1 (преобразовать 7.1 в 5.1 каналы)';

  @override
  String get playerSettingsButton => 'Настройки';

  @override
  String get audioTracksButton => 'Аудиодорожки';

  @override
  String get subtitleTracksButton => 'Субтитры';

  @override
  String get audioTracksTitle => 'Аудиодорожки';

  @override
  String get subtitlesTitle => 'Субтитры';

  @override
  String get disableSubtitles => 'Отключить';

  @override
  String unknownAudio(Object id) {
    return 'Аудио $id';
  }

  @override
  String unknownSubtitles(Object id) {
    return 'Субтитры $id';
  }

  @override
  String get mono => 'моно';

  @override
  String get stereo => 'стерео';

  @override
  String buffering(Object percentage) {
    return 'Буферизация: $percentage%';
  }
}
