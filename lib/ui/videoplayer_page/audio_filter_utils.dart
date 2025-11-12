import 'package:media_kit/media_kit.dart';
import 'package:torrstv/core/settings/videoplayer_settings.dart';

Future<void> applyAudioFiltersFromSettings(Player player, VideoPlayerSettings sets, int? channels) async {
  if (!sets.isAudioFilters()) {
    setAudioFilter(player, '');
    return;
  }

  final List<String> filters = [];

  if (channels != null) {
    final frontPan = sets.getFrontPan().toStringAsFixed(3);
    final centerPan = sets.getCenterPan().toStringAsFixed(3);
    final midPan = sets.getMiddlePan().toStringAsFixed(3);
    final rearPan = sets.getRearPan().toStringAsFixed(3);

    String panFilter = '';

    // Маска каналов для FFmpeg pan filter:
    // c0, c1: Front Left, Front Right (FL, FR)
    // c2: Center (C)
    // c3: LFE (Subwoofer) - обычно не панорамируется, оставляем 1.0
    // c4, c5: Back Left, Back Right (BL, BR)
    // c6, c7: Side Left, Side Right (SL, SR) - используются в 7.1

    switch (channels) {
      case 1: // Моно (1.0) -> 5.1
        if (sets.getStereoTo51()) {
          panFilter = 'pan=5.1|c0=$frontPan*c0|c1=$frontPan*c0|c2=$centerPan*c0|c3=1.0*c0|c4=$rearPan*c0|c5=$rearPan*c0';
        }
        break;
      case 2: // Стерео (2.0) -> 5.1
        if (sets.getStereoTo51()) {
          final centerCoeff = (sets.getCenterPan() / 2.0).toStringAsFixed(3);
          // Безопасный LFE: коэффициент 0.3 от микса, чтобы избежать перегрузки сабвуфера
          final lfeCoeff = (sets.getRearPan() / 4.0).toStringAsFixed(3);

          panFilter =
              'pan=5.1|' +
              'c0=$frontPan*c0|c1=$frontPan*c1|' + // FL/FR - FrontPan
              'c2=$centerCoeff*c0+$centerCoeff*c1|' + // Center - CenterPan от микса
              'c3=$lfeCoeff*c0+$lfeCoeff*c1|' + // LFE - Безопасный коэффициент от микса
              'c4=$rearPan*c0|c5=$rearPan*c1'; // BL/BR - RearPan
        }
        break;
      case 6: // 5.1: FL, FR, C, LFE, BL, BR (c0-c5)
        // FL=c0*FrontPan, FR=c1*FrontPan, C=c2*CenterPan, LFE=c3*1.0, BL=c4*RearPan, BR=c5*RearPan
        panFilter = 'pan=${channels - 1}.1|c0=$frontPan*c0|c1=$frontPan*c1|c2=$centerPan*c2|c3=1.0*c3|c4=$rearPan*c4|c5=$rearPan*c5';
        break;
      case 8: // 7.1: FL, FR, C, LFE, BL, BR, SL, SR (c0-c7)
        // Предполагаем, что BL/BR - Rear (rearPan), SL/SR - Side/Middle (midPan)
        // FL=c0*FrontPan, FR=c1*FrontPan, C=c2*CenterPan, LFE=c3*1.0
        // BL=c4*RearPan, BR=c5*RearPan
        // SL=c6*MidPan, SR=c7*MidPan
        if (!sets.get71To51()) {
          panFilter = 'pan=${channels - 1}.1|c0=$frontPan*c0|c1=$frontPan*c1|c2=$centerPan*c2|c3=1.0*c3|c4=$rearPan*c4|c5=$rearPan*c5|c6=$midPan*c6|c7=$midPan*c7';
        } else {
          // 7.1 (8 каналов) -> Даунмиксинг в 5.1 по формуле c4=(c4*RearPan+c6*MidPan)/2
          // Расчет коэффициентов для усреднения (Деление на 2)
          final rearCoeff = (sets.getRearPan() / 2.0).toStringAsFixed(3);
          final midCoeff = (sets.getMiddlePan() / 2.0).toStringAsFixed(3);

          // Выходной формат: pan=5.1 (6 каналов)
          panFilter =
              'pan=5.1|' +
              // Front, Center, LFE: применяем ваши настройки, каналы остаются 1:1
              'c0=$frontPan*c0|c1=$frontPan*c1|c2=$centerPan*c2|c3=1.0*c3|' +
              // Новый Задний Левый (c4) = (c4*RearPan + c6*MidPan) / 2
              // c4 получает вклад от заднего (c4) и бокового (c6)
              'c4=${rearCoeff}*c4+${midCoeff}*c6|' +
              // Новый Задний Правый (c5) = (c5*RearPan + c7*MidPan) / 2
              'c5=${rearCoeff}*c5+${midCoeff}*c7';
        }
        break;
      default:
        // Для всех остальных многоканальных форматов (3.0, 4.0 и т.д.)
        if (channels > 2) {
          panFilter = 'pan=$channels.0|'; // Выход = N.0 каналов
          // Применяем ко всем каналам FL/FR (c0, c1) FrontPan, ко всем остальным - RearPan
          for (int i = 0; i < channels; i++) {
            final coeff = (i < 2) ? frontPan : rearPan;
            panFilter += 'c$i=$coeff*c$i|';
          }
          panFilter = panFilter.substring(0, panFilter.length - 1);
        }
        break;
    }

    if (panFilter.isNotEmpty) {
      filters.add('lavfi=[$panFilter]');
    }
  }

  if (sets.getNormalize()) {
    // Пример настроек loudnorm для нормализации:
    // I (Integrated Loudness) = -16 LUFS (стандарт для потокового видео)
    // TP (True Peak) = -1.0 dBTP
    // LRA (Loudness Range) = 2.0 LU (очень низкий диапазон, для сжатия динамики)
    filters.add('loudnorm=I=-16:TP=-1:LRA=2');
  }

  if (sets.getSmoothing()) {
    // Используем простой аудиокомпрессор для "сглаживания" (уменьшения динамического диапазона)
    // threshold=-30dB: порог, ratio=2:1: компрессия
    // attack/release: скорость срабатывания
    filters.add('acompressor=threshold=-30dB:ratio=2:attack=0.01:release=0.05');
  }

  String finalFilter = filters.join(',');

  if (finalFilter.isEmpty) {
    await setAudioFilter(player, '');
  } else {
    await setAudioFilter(player, finalFilter);
  }
}

Future<void> setAudioFilter(Player player, String filter) async {
  if (player.platform is NativePlayer) {
    final native = player.platform as NativePlayer;
    await native.setProperty('af', filter, waitForInitialization: true);
    print('Audio filter set: $filter');
  } else {
    print('setAudioFilter: current platform is not NativePlayer');
  }
}
