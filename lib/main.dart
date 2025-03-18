import 'package:appwrite_flutter_starter_kit/data/models/log.dart';
import 'package:appwrite_flutter_starter_kit/data/models/status.dart';
import 'package:appwrite_flutter_starter_kit/data/repository/appwrite_repository.dart';
import 'package:appwrite_flutter_starter_kit/ui/components/checkered_background.dart';
import 'package:appwrite_flutter_starter_kit/ui/components/collapsible_bottomsheet.dart';
import 'package:appwrite_flutter_starter_kit/ui/components/connection_status_view.dart';
import 'package:appwrite_flutter_starter_kit/ui/components/getting_started_cards.dart';
import 'package:appwrite_flutter_starter_kit/ui/components/top_platform_view.dart';
import 'package:appwrite_flutter_starter_kit/utils/app_initializer.dart';
import 'package:appwrite_flutter_starter_kit/utils/extensions/build_context.dart';
import 'package:flutter/material.dart';

void main() async {
  await AppInitializer.initialize();
  runApp(AppwriteApp());
}

class AppwriteApp extends StatelessWidget {
  const AppwriteApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Appwrite StarterKit',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const AppwriteStarterKit(),
    );
  }
}

class AppwriteStarterKit extends StatefulWidget {
  const AppwriteStarterKit({super.key});

  @override
  State<AppwriteStarterKit> createState() => _AppwriteStarterKit();
}

class _AppwriteStarterKit extends State<AppwriteStarterKit> {
  final List<Log> _logs = [];
  Status _status = Status.idle;
  final AppwriteRepository _repository = AppwriteRepository();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CheckeredBackground(
        child: SafeArea(
          minimum: EdgeInsets.only(top: context.isLargeScreen ? 24 : 16),
          child: Stack(
            children: [
              SingleChildScrollView(
                child: Column(
                  spacing: context.isLargeScreen ? 64 : 32,
                  children: [
                    TopPlatformView(status: _status),
                    ConnectionStatusView(
                      status: _status,
                      onButtonClick: () async {
                        setState(() => _status = Status.loading);
                        final log = await _repository.ping();
                        _logs.add(log);

                        await Future.delayed(
                          const Duration(milliseconds: 1250),
                        );

                        setState(
                          () => _status =
                              (200 <= log.status && log.status <= 399)
                                  ? Status.success
                                  : Status.error,
                        );
                      },
                    ),
                    GettingStartedCards()
                  ],
                ),
              ),

              // bottomsheet
              Align(
                alignment: Alignment.bottomCenter,
                child: CollapsibleBottomSheet(
                  logs: _logs,
                  projectInfo: _repository.getProjectInfo(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
