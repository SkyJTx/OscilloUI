import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:oscillo_ui/page/settings_page/settings_cubit.dart';

class ConnectionDialog extends StatefulWidget {
  final GlobalKey<TextFormBoxState> hostTextFormBoxState;
  final GlobalKey<TextFormBoxState> portTextFormBoxState;
  final TextEditingController hostTextController;
  final TextEditingController portTextController;
  final SettingsCubit? settingsCubit;

  const ConnectionDialog({
    super.key,
    required this.hostTextFormBoxState,
    required this.portTextFormBoxState,
    required this.hostTextController,
    required this.portTextController,
    this.settingsCubit,
  });

  @override
  State<ConnectionDialog> createState() => ConnectionDialogState();
}

class ConnectionDialogState extends State<ConnectionDialog> {
  @override
  Widget build(BuildContext context) {
    final locale = AppLocalizations.of(context);
    final settingsCubit = widget.settingsCubit ?? context.read<SettingsCubit>();
    return ContentDialog(
      content: ListView(
        shrinkWrap: true,
        children: [
          InfoLabel(
            label: locale.settingsPageHostSettingTitle,
            child: TextFormBox(
              key: widget.hostTextFormBoxState,
              controller: widget.hostTextController,
              placeholder: locale.settingsPageHostSettingSubtitle,
              onChanged: (value) {
                widget.hostTextFormBoxState.currentState!.validate();
              },
              validator: (value) {
                if (value?.isEmpty ?? true) {
                  return locale.textFormFieldRequiredError;
                }
                return null;
              },
            ),
          ),
          InfoLabel(
            label: locale.settingsPagePortSettingTitle,
            child: TextFormBox(
              key: widget.portTextFormBoxState,
              controller: widget.portTextController,
              keyboardType: TextInputType.number,
              maxLength: 5,
              placeholder: locale.settingsPagePortSettingSubtitle,
              onChanged: (value) {
                final port = int.tryParse(value);
                if (port != null) {
                  if (port < 0 || port > 65535) {
                    widget.portTextController.text = port.clamp(0, 65535).toString();
                  }
                }
                widget.portTextFormBoxState.currentState!.validate();
              },
              validator: (value) {
                final finalValue = value ?? '';
                if (finalValue.isEmpty) {
                  return locale.textFormFieldRequiredError;
                }
                final finalPort = int.tryParse(finalValue);
                if (finalPort == null) {
                  return locale.textFormFieldInvalidError;
                }
                if (finalPort < 0 || finalPort > 65535) {
                  return locale.textFormFieldInvalidError;
                }
                return null;
              },
            ),
          ),
        ].map((e) => Padding(padding: EdgeInsets.symmetric(vertical: 4.0), child: e)).toList(),
      ),
      actions: [
        Button(
          child: Text(locale.cancelText),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        FilledButton(
          child: Text(locale.saveText),
          onPressed: () async {
            final hostValidate = widget.hostTextFormBoxState.currentState!.validate();
            final portValidate = widget.portTextFormBoxState.currentState!.validate();
            if (hostValidate && portValidate) {
              await Future.wait([
                settingsCubit.setHost(widget.hostTextController.text),
                settingsCubit.setPort(int.parse(widget.portTextController.text)),
              ]);
              if (context.mounted) Navigator.of(context).pop();
            }
          },
        ),
      ],
    );
  }
}
