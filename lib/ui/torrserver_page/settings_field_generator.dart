import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:torrstv/ui/torrserver_page/ts_settings_provider.dart';
import 'package:torrstv/ui/widgets/dpad_form_text_field.dart';

class SettingsFieldGenerator extends ConsumerWidget {
  final String settingKey;
  final dynamic value;
  final String label;
  final String hint;

  const SettingsFieldGenerator({super.key, required this.settingKey, required this.value, required this.label, required this.hint});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifier = ref.read(torrServerSettingsNotifierProvider.notifier);
    final colorScheme = Theme.of(context).colorScheme;

    if (value is bool) {
      return SwitchListTile(title: Text(label), subtitle: Text(hint), value: value, onChanged: (newValue) => notifier.updateSetting(settingKey, newValue), activeThumbColor: colorScheme.primary);
    } else if (value is int) {
      return ListTile(
        title: Text(label),
        subtitle: DpadFormTextField(
          initialValue: value.toString(),
          keyboardType: TextInputType.number,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          decoration: InputDecoration(hintText: hint, isDense: true),
          onFieldSubmitted: (text) {
            final newValue = int.tryParse(text);
            if (newValue != null) {
              notifier.updateSetting(settingKey, newValue);
            }
          },
        ),
      );
    } else if (value is String) {
      return ListTile(
        title: Text(label),
        subtitle: DpadFormTextField(
          initialValue: value,
          decoration: InputDecoration(hintText: hint, isDense: true),
          onFieldSubmitted: (text) {
            notifier.updateSetting(settingKey, text);
          },
        ),
      );
    }

    return const SizedBox.shrink();
  }
}
