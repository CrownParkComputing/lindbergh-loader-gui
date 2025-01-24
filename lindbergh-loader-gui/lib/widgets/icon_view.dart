import 'dart:io';
import 'package:flutter/material.dart';
import '../models/game.dart';

class IconView extends StatelessWidget {
  final List<Game> games;
  final Function(Game) onPlay;

  const IconView({
    super.key,
    required this.games,
    required this.onPlay,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 0.8,
      ),
      itemCount: games.length,
      itemBuilder: (context, index) {
        final game = games[index];
        return InkWell(
          onTap: () => onPlay(game),
          borderRadius: BorderRadius.circular(8),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
            ),
            child: Stack(
              children: [
                if (game.iconPath != null)
                  Center(
                    child: Container(
                      constraints: BoxConstraints(
                        maxWidth: MediaQuery.of(context).size.width * 0.18,
                        maxHeight: MediaQuery.of(context).size.width * 0.18,
                      ),
                      child: Image.file(
                        File(game.iconPath!),
                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stackTrace) {
                          return Center(
                            child: Icon(
                              Icons.sports_esports,
                              size: 96,
                              color: Theme.of(context).primaryColor,
                            ),
                          );
                        },
                      ),
                    ),
                  )
                else
                  Center(
                    child: Icon(
                      Icons.sports_esports,
                      size: MediaQuery.of(context).size.width * 0.18,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    color: Colors.black.withOpacity(0.7),
                    padding: const EdgeInsets.all(8),
                    child: Text(
                      game.name,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            color: Colors.white,
                          ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
                Positioned(
                  bottom: 40,
                  right: 8,
                  child: FloatingActionButton.small(
                    onPressed: () => onPlay(game),
                    child: const Icon(Icons.play_arrow),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
