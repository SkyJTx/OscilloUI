import 'dart:developer';

import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oscillo_ui/component/loading_ring.dart';
import 'package:oscillo_ui/component/value_change_notifier/value_change_notifier.dart';
import 'package:oscillo_ui/page/main_page/oscilloscope_cubit.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  static const String routeName = '/';

  @override
  State<MainPage> createState() => MainPageState();
}

class MainPageState extends State<MainPage> {
  final textController = TextEditingController();
  final imageSliderController = ValueChangeNotifer(0.0);

  @override
  void initState() {
    super.initState();
    context.read<OscilloscopeCubit>().fetchConnections().then((_) {
      log('MainPageState fetchConnections');
    });
  }

  @override
  void dispose() {
    textController.dispose();
    imageSliderController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<OscilloscopeCubit, OscilloscopeState>(
      listener: (context, state) {
        if (state.isInitialized && state.isConnected) {
          if (imageSliderController.value == state.data!.videoFrames.length - 2) {
            imageSliderController.value = state.data!.videoFrames.length - 1;
            return;
          }
          imageSliderController.value = (imageSliderController.value).clamp(
            0,
            state.data!.videoFrames.length.toDouble() - 1,
          );
        }
      },
      builder: (context, state) {
        if (!state.isInitialized) {
          return LoadingRing();
        }
        if (!state.isConnected) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              spacing: 8,
              children: [
                Text(AppLocalizations.of(context).notConnectedText),
                FilledButton(
                  onPressed: () {
                    OscilloscopeCubit().connect(
                      state.connections.first.hostname,
                      state.connections.first.port,
                    );
                  },
                  child: Text(AppLocalizations.of(context).connectText),
                ),
              ],
            ),
          );
        }

        final data = state.data!;

        return Container(
          padding: EdgeInsets.all(8),
          alignment: Alignment.center,
          child: Column(
            spacing: 4,
            children: [
              data.videoFrames.isNotEmpty
                  ? Expanded(
                      child: Image.memory(
                        data.videoFrames[imageSliderController.value.toInt()].image,
                        errorBuilder: (context, error, stackTrace) {
                          return Center(child: Text(AppLocalizations.of(context).errorText));
                        },
                      ),
                    )
                  : Text(AppLocalizations.of(context).noDataText),
              ValueChangeNotifierBuilder(
                valueChangeNotifier: imageSliderController,
                builder: (context, value, setValue, child) {
                  return Slider(
                    value: value,
                    onChanged: setValue,
                    min: 0,
                    divisions: data.videoFrames.length,
                    max: data.videoFrames.length.toDouble() - 1,
                  );
                },
              ),
              Align(
                alignment: Alignment.centerRight,
                child: Button(
                  child: Text('Capture'),
                  onPressed: () {
                    OscilloscopeCubit().capture();
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
