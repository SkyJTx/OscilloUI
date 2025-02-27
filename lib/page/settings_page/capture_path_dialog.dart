import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oscillo_ui/l10n/generated/app_localizations.dart';
import 'package:oscillo_ui/page/settings_page/settings_cubit.dart';

class CapturePathDialog extends StatefulWidget {
  final GlobalKey<TextFormBoxState> imageSavePathTextFormBoxState;
  final GlobalKey<TextFormBoxState> videoSavePathTextFormBoxState;
  final TextEditingController imageSavePathTextController;
  final TextEditingController videoSavePathTextController;
  final SettingsCubit? settingsCubit;

  const CapturePathDialog({
    super.key,
    required this.imageSavePathTextFormBoxState,
    required this.videoSavePathTextFormBoxState,
    required this.imageSavePathTextController,
    required this.videoSavePathTextController,
    this.settingsCubit,
  });

  @override
  State<CapturePathDialog> createState() => CapturePathDialogState();
}

class CapturePathDialogState extends State<CapturePathDialog> {
  @override
  Widget build(BuildContext context) {
    final locale = AppLocalizations.of(context);
    final settingsCubit = widget.settingsCubit ?? context.read<SettingsCubit>();
    return ContentDialog(
      content: ListView(
        shrinkWrap: true,
        children: [
          InfoLabel(
            label: locale.settingsPageImageSavePathSettingTitle,
            child: TextFormBox(
              key: widget.imageSavePathTextFormBoxState,
              controller: widget.imageSavePathTextController,
              placeholder: locale.settingsPageImageSavePathSettingSubtitle,
              onChanged: (value) {
                widget.imageSavePathTextFormBoxState.currentState!.validate();
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
            label: locale.settingsPageVideoSavePathSettingSubtitle,
            child: TextFormBox(
              key: widget.videoSavePathTextFormBoxState,
              controller: widget.videoSavePathTextController,
              placeholder: locale.settingsPageVideoSavePathSettingSubtitle,
              onChanged: (value) {
                widget.videoSavePathTextFormBoxState.currentState!.validate();
              },
              validator: (value) {
                if (value?.isEmpty ?? true) {
                  return locale.textFormFieldRequiredError;
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
            final validateImage = widget.imageSavePathTextFormBoxState.currentState!.validate();
            final validateVideo = widget.videoSavePathTextFormBoxState.currentState!.validate();
            if (validateVideo && validateImage) {
              await Future.wait([
                settingsCubit.setImageSavePath(widget.imageSavePathTextController.text),
                settingsCubit.setVideoSavePath(widget.videoSavePathTextController.text),
              ]);
              if (context.mounted) Navigator.of(context).pop();
            }
          },
        ),
      ],
    );
  }
}
