import 'dart:developer';
import 'dart:io';

import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oscillo_ui/component/loading_ring.dart';
import 'package:oscillo_ui/page/main_page/oscilloscope_cubit.dart';
import 'package:oscillo_ui/repo/image_and_video/image_processing_repo.dart';
import 'package:oscillo_ui/repo/oscilloscope/oscilloscope_repo.dart';
import 'package:oscillo_ui/repo/settings/settings_repo.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  static const String routeName = '/';

  @override
  State<MainPage> createState() => MainPageState();
}

class MainPageState extends State<MainPage> {
  final textController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OscilloscopeCubit, OscilloscopeState>(
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

        return Container(
          padding: EdgeInsets.all(8),
          alignment: Alignment.center,
          child: Text('Connected'),
        );
      },
    );
  }
}
