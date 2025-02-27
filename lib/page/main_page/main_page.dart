import 'dart:math';

import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oscillo_ui/component/loading_ring.dart';
import 'package:oscillo_ui/component/value_change_notifier/value_change_notifier.dart';
import 'package:oscillo_ui/page/main_page/oscilloscope_cubit.dart';
import 'package:oscillo_ui/l10n/generated/app_localizations.dart';
import 'package:oscillo_ui/repo/image_and_video/video_repo.dart';
import 'package:sizer/sizer.dart';

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
    context.read<OscilloscopeCubit>().fetchConnections();
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
          if (state.data == null) return;
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

        if (state.data == null) {
          return Center(
            child: Text(AppLocalizations.of(context).noDataText),
          );
        }

        final data = state.data!;

        return Container(
          padding: EdgeInsets.all(8),
          alignment: Alignment.center,
          child: Column(
            spacing: 4,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(vertical: 4),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    data.videoFrames.isNotEmpty
                        ? Expanded(
                            child: Stack(
                              children: [
                                Center(
                                  child: Image.memory(
                                    data.videoFrames[imageSliderController.value.toInt()].image,
                                    errorBuilder: (context, error, stackTrace) {
                                      return Center(
                                        child: Text(
                                          AppLocalizations.of(context).errorText,
                                        ),
                                      );
                                    },
                                    frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
                                      return AnimatedSwitcher(
                                        duration: Duration(milliseconds: 200),
                                        transitionBuilder: (child, animation) {
                                          return FadeTransition(
                                            opacity: animation,
                                            child: child,
                                          );
                                        },
                                        child: frame == null ? SizedBox.shrink() : child,
                                      );
                                    },
                                  ),
                                ),
                                if (data.videoCommandType.isPaused)
                                  Positioned.fill(
                                    child: Container(
                                      color: FluentTheme.of(context)
                                          .micaBackgroundColor
                                          .withAlpha(0x80),
                                      child: Center(
                                        child: Icon(
                                          FluentIcons.pause,
                                          size: min(30.w, 30.h),
                                          color: FluentTheme.of(context).activeColor,
                                        ),
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          )
                        : Text(AppLocalizations.of(context).noDataText),
                    Container(
                      padding: EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: FluentTheme.of(context).micaBackgroundColor,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: ListView(
                        shrinkWrap: true,
                        children: [
                          Divider(),
                          Text(data.ip),
                          Text(data.port.toString()),
                          Divider(),
                          Text(data.videoCommandType.command),
                          for (final ch in data.channels) Column(
                            children: [
                              Divider(),
                              Text(ch.channel.string),
                              Text(ch.state.toString()),
                              Text(ch.coupling.string),
                              Text(ch.offset.toString()),
                              Text(ch.probeScale.toString()),
                              Text(ch.voltsPerDiv.toString()),
                            ],
                          ),
                          Divider(),
                          Text(data.timePerDiv.toString()),
                          Divider(),
                          Text(data.trigger.channel.string),
                          Text(data.trigger.edge.string),
                          Text(data.trigger.level.toString()),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                children: [
                  IconButton(
                    icon: Icon(FluentIcons.play),
                    onPressed: () {
                      OscilloscopeCubit().play();
                    },
                  ),
                  IconButton(
                    icon: Icon(FluentIcons.pause),
                    onPressed: () {
                      OscilloscopeCubit().pause();
                    },
                  ),
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
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                spacing: 8,
                children: [
                  Button(
                    child: Text(AppLocalizations.of(context).captureText(
                      AppLocalizations.of(context).imageText,
                    )),
                    onPressed: () {
                      OscilloscopeCubit().capture();
                    },
                  ),
                  Button(
                    child: Text(AppLocalizations.of(context).captureText(
                      AppLocalizations.of(context).videoText,
                    )),
                    onPressed: () {
                      VideoRepo().saveVideo(
                        data.videoFrames,
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
