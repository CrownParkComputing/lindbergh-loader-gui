import 'dart:io';
import 'package:flutter/material.dart';
import 'package:lindbergh_games/models/game.dart';
import 'package:lindbergh_games/widgets/game_settings_dialog.dart';

class GameTile extends StatelessWidget {
  final Game game;
  final VoidCallback onEditConfig;
  final VoidCallback onDelete;
  final VoidCallback onLaunch;
  final VoidCallback onTest;

  const GameTile({
    super.key,
    required this.game,
    required this.onEditConfig,
    required this.onDelete,
    required this.onLaunch,
    required this.onTest,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: game.iconPath != null
            ? Image.file(
                File(game.iconPath!),
                width: 48,
                height: 48,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return const Icon(Icons.sports_esports);
                },
              )
            : const Icon(Icons.sports_esports),
        title: Text(game.name),
        subtitle: Text('ID: ${game.id} - DVP: ${game.dvp}'),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.play_arrow),
              onPressed: game.isConfigured ? onLaunch : null,
              tooltip: 'Launch Game',
            ),
            IconButton(
              icon: const Icon(Icons.bug_report),
              onPressed: game.isConfigured ? onTest : null,
              tooltip: 'Launch Test Menu',
            ),
            IconButton(
              icon: const Icon(Icons.settings),
              onPressed: onEditConfig,
              tooltip: 'Edit lindbergh.conf',
            ),
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: onDelete,
              tooltip: 'Delete Game',
            ),
          ],
        ),
      ),
    );
  }
}
