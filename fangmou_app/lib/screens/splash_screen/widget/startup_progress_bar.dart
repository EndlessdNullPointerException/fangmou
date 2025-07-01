import 'dart:io';

import 'package:flutter/material.dart';

class StartupProgressBar extends StatefulWidget {
  final String message;
  final double progressPercent;
  final bool initializeFailed = false;

  const StartupProgressBar({super.key, required this.message, required this.progressPercent});

  @override
  State<StartupProgressBar> createState() => _StartupProgressBarState();
}

class _StartupProgressBarState extends State<StartupProgressBar> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        LinearProgressIndicator(
          value: widget.progressPercent,
          backgroundColor: Colors.grey.shade300,
          color: Colors.blue,
          minHeight: 12,
          borderRadius: BorderRadius.circular(10),
        ),
        const SizedBox(height: 16),
        Text(widget.message, style: const TextStyle(fontSize: 18), textAlign: TextAlign.center),
        const SizedBox(height: 32),
        if (widget.initializeFailed)
          Column(
            children: [
              const Icon(Icons.error_outline, size: 48, color: Colors.red),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                icon: const Icon(Icons.refresh),
                label: const Text('重试初始化'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                ),
                onPressed: () {},
              ),
              const SizedBox(height: 16),
              TextButton(onPressed: () => exit(0), child: const Text('退出应用')),
            ],
          ),
      ],
    );
  }
}
