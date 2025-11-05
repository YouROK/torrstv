const Map<String, ({String label, String hint})> torrServerMetadata = {
  // --- Числовые настройки (int) ---
  'CacheSize': (label: 'Размер кэша', hint: 'Размер кэша в байтах (минимум 32МБ)'),
  'ReaderReadAHead': (label: 'Упреждающее чтение', hint: 'Процент буфера упреждающего чтения'),
  'PreloadCache': (label: 'Размер предзагрузки', hint: 'Размер кэша предзагрузки'),
  'RetrackersMode': (label: 'Режим ретрекеров', hint: 'Режим работы с ретрекерами'),
  'TorrentDisconnectTimeout': (label: 'Таймаут отключения торрента', hint: 'Таймаут в секундах'),
  'DownloadRateLimit': (label: 'Лимит загрузки', hint: 'Ограничение скорости загрузки в КБ/с (0 - без лимита)'),
  'UploadRateLimit': (label: 'Лимит отдачи', hint: 'Ограничение скорости отдачи в КБ/с (0 - без лимита)'),
  'ConnectionsLimit': (label: 'Лимит соединений', hint: 'Максимальное количество соединений'),
  'PeersListenPort': (label: 'Порт P2P', hint: 'Порт для прослушивания P2P соединений (0 - случайный)'),
  'SslPort': (label: 'Порт SSL', hint: 'Порт для SSL-соединений'),

  // --- Строковые настройки (String) ---
  'TorrentsSavePath': (label: 'Путь хранения кэша', hint: 'Путь где будет сохранен кэш'),
  'FriendlyName': (label: 'Имя DLNA', hint: 'Имя сервера для DLNA'),
  'SslCert': (label: 'Сертификат SSL', hint: 'Путь к файлу сертификата'),
  'SslKey': (label: 'Ключ SSL', hint: 'Путь к файлу ключа'),

  // --- Булевы настройки (bool) ---
  'UseDisk': (label: 'Использовать диск для кэша', hint: 'Записывать кэш на диск, медленный режим, но экономит память'),
  'RemoveCacheOnDrop': (label: 'Удалять кэш при удалении торрента', hint: 'Удалять данные, когда торрент удален'),
  'ForceEncrypt': (label: 'Принудительное шифрование', hint: 'Использовать шифрованные заголовки'),
  'EnableDebug': (label: 'Включить дебаг-лог', hint: 'Записывать подробные логи'),
  'EnableDLNA': (label: 'Включить DLNA', hint: 'Активировать DLNA-сервер'),
  'EnableRutorSearch': (label: 'Включить поиск Rutor', hint: 'Активировать встроенный поиск'),
  'EnableIPv6': (label: 'Включить IPv6', hint: 'Разрешить IPv6'),
  'DisableTCP': (label: 'Отключить TCP', hint: 'Использовать только UTP'),
  'DisableUTP': (label: 'Отключить UTP', hint: 'Использовать только TCP'),
  'DisableUPNP': (label: 'Отключить UPnP', hint: 'Отключить автоматическую настройку портов'),
  'DisableDHT': (label: 'Отключить DHT', hint: 'Отключить DHT'),
  'DisablePEX': (label: 'Отключить PEX', hint: 'Отключить PEX'),
  'DisableUpload': (label: 'Отключить отдачу', hint: 'Отключить возможность отдавать пирам'),
  'ResponsiveMode': (label: 'Включить быстрый режим чтения', hint: 'Быстрый режим чтения торрента'),
};
