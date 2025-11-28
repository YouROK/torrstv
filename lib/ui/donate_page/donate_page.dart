import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:torrstv/l10n/app_localizations.dart';
import 'package:url_launcher/url_launcher_string.dart';

class DonatePage extends ConsumerWidget {
  const DonatePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.donateTitle), backgroundColor: colorScheme.surface, elevation: 0),
      body: Container(
        padding: const EdgeInsets.all(24),
        alignment: Alignment.topCenter,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 800),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  l10n.supportDevelopment,
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold, color: colorScheme.onSurface),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 30),

                Text(l10n.supportDescription, style: Theme.of(context).textTheme.titleMedium, textAlign: TextAlign.center),
                const SizedBox(height: 40),

                ElevatedButton.icon(
                  onPressed: () {
                    launchUrlString("https://boosty.to/yourok");
                  },
                  label: Text("Boosty", style: const TextStyle(fontSize: 18)),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 30),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    elevation: 5,
                  ),
                ),
 
                const SizedBox(height: 10),
                ElevatedButton.icon(
                  onPressed: () {
                    launchUrlString("https://yoomoney.ru/to/410013733697114");
                  },
                  label: Text("ЮMoney", style: const TextStyle(fontSize: 18)),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 30),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    elevation: 5,
                  ),
                ),

                const SizedBox(height: 10),
                ElevatedButton.icon(
                  onPressed: () {
                    launchUrlString("https://www.tbank.ru/cf/742qEMhKhKn");
                  },
                  label: Text("TBank", style: const TextStyle(fontSize: 18)),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 30),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    elevation: 5,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
