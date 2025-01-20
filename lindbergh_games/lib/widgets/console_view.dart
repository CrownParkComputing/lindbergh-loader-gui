import 'package:flutter/material.dart';

class ConsoleView extends StatefulWidget {
  final Stream<String> outputStream;
  final Stream<String> errorStream;

  const ConsoleView({
    super.key,
    required this.outputStream,
    required this.errorStream,
  });

  @override
  State<ConsoleView> createState() => _ConsoleViewState();
}

class _ConsoleViewState extends State<ConsoleView> {
  final List<String> _lines = [];
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    widget.outputStream.listen(_addLine);
    widget.errorStream.listen(_addLine);
  }

  void _addLine(String line) {
    setState(() {
      _lines.add(line);
      if (_lines.length > 1000) {
        _lines.removeAt(0);
      }
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      padding: const EdgeInsets.all(8.0),
      child: ListView.builder(
        controller: _scrollController,
        itemCount: _lines.length,
        itemBuilder: (context, index) {
          return Text(
            _lines[index],
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
            ),
          );
        },
      ),
    );
  }
}
