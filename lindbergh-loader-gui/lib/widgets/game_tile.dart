import 'dart:io';
import 'package:flutter/material.dart';
import 'package:lindbergh_games/models/game.dart';

class GameTile extends StatelessWidget {
  final Game game;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final VoidCallback onLaunch;
  final VoidCallback onTest;

  const GameTile({
    super.key,
    required this.game,
    required this.onEdit,
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
              )
            : const Icon(Icons.videogame_asset),
        title: Text(game.name),
        subtitle: Text(game.executablePath ?? 'No executable selected'),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.play_arrow),
              onPressed: game.executablePath != null ? onLaunch : null,
            ),
            IconButton(
              icon: const Icon(Icons.settings),
              onPressed: onEdit,
            ),
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: onDelete,
            ),
          ],
        ),
      ),
    );
  }
}
