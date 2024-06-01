import 'package:easy_crm/widgets/error_dialog.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

abstract class Launcher {
  static void launchPhone(BuildContext context, {String? phone}) async {
    final formattedPhone = '0${phone?.replaceAll(RegExp(r'[( )-]'), '')}';
    final Uri phoneUri = Uri(scheme: 'tel', path: formattedPhone);

    if ((await canLaunchUrl(phoneUri)) && (formattedPhone.length >= 8)) {
      await launchUrl(phoneUri);
    } else {
      if (context.mounted) {
        showDialog(
          context: context,
          builder: (context) => const ErrorDialog(title: 'Erro ao ligar', error: 'Não foi possível ligar para o cliente'),
        );
      }
    }
  }

  static void launchWhatsApp(BuildContext context, {String? phone}) async {
    final formattedPhone = '+55${phone?.replaceAll(RegExp(r'[( )-]'), '')}';
    final Uri whatsappUri = Uri.https('wa.me', '/$formattedPhone');

    if ((await canLaunchUrl(whatsappUri)) && (formattedPhone.length >= 11)) {
      await launchUrl(whatsappUri);
    } else {
      if (context.mounted) {
        showDialog(
          context: context,
          builder: (context) => const ErrorDialog(title: 'Erro ao abrir', error: 'Não foi possível iniciar a conversa'),
        );
      }
    }
  }

  static void launchEmail(BuildContext context, {String? email}) async {
    final Uri emailUri = Uri(scheme: 'mailto', path: email);

    if ((await canLaunchUrl(emailUri)) && (email?.isNotEmpty ?? false)) {
      await launchUrl(emailUri);
    } else {
      if (context.mounted) {
        showDialog(
          context: context,
          builder: (context) => const ErrorDialog(title: 'Erro ao ligar', error: 'Não foi possível ligar para o cliente'),
        );
      }
    }
  }

  static void launchMap(BuildContext context, {String? endereco, String? numero, String? cidade, String? estado}) async {
    String formattedEndereco = '$endereco, $numero, $cidade - $estado';

    final Uri mapUri = Uri(scheme: 'geo', host: '0,0', queryParameters: {'q': formattedEndereco});

    if ((await canLaunchUrl(mapUri)) && (formattedEndereco.length > 7)) {
      await launchUrl(mapUri);
    } else {
      if (context.mounted) {
        showDialog(
          context: context,
          builder: (context) => const ErrorDialog(title: 'Erro ao abrir mapa', error: 'Não foi possível abrir o endereço no aplicativo de mapa'),
        );
      }
    }
  }
}
