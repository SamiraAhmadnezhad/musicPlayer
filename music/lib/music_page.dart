import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:path_provider/path_provider.dart';

class MusicPage extends StatefulWidget {
  const MusicPage({Key? key}) : super(key: key);

  @override
  State<MusicPage> createState() => _MusicPageState();
}

class _MusicPageState extends State<MusicPage> {
  final AudioPlayer _player = AudioPlayer();
  bool _loading = false;

  Future<void> giveMusics() async {
    setState(() => _loading = true);
    final stopwatch = Stopwatch()..start();

    try {
      final socket = await Socket.connect("192.168.114.236", 8000);
      print('[Socket] Connected in ${stopwatch.elapsedMilliseconds} ms');
      socket.write("giveMusics\u0000");
      await socket.flush();
      print('[Socket] Request sent at ${stopwatch.elapsedMilliseconds} ms');

      final completer = Completer<void>();
      final allBytes = <int>[];
      int chunkCount = 0;

      final sub = socket.listen(
            (chunk) {
          chunkCount++;
          allBytes.addAll(chunk);
          print('[Socket] chunk #$chunkCount: ${chunk.length} bytes (total ${allBytes.length}) at ${stopwatch.elapsedMilliseconds} ms');
        },
        onError: (e) {
          if (!completer.isCompleted) completer.completeError(e);
        },
        onDone: () {
          print('[Socket] onDone fired at ${stopwatch.elapsedMilliseconds} ms');
          if (!completer.isCompleted) completer.complete();
        },
        cancelOnError: true,
      );

      await completer.future;
      await sub.cancel();
      stopwatch.stop();
      print('[Socket] Finished receiving in ${stopwatch.elapsedMilliseconds} ms');

      print('[Decode] utf8.decode...');
      final res = utf8.decode(allBytes);
      print('[Decode] base64 length: ${res.length}');
      final audioBytes = base64Decode(res);
      print('[Decode] audio bytes: ${audioBytes.length}');

      final tempDir = await getTemporaryDirectory();
      final tempPath = '${tempDir.path}/music.mp3';
      print('[File] Writing to $tempPath');
      await File(tempPath).writeAsBytes(audioBytes);
      print('[File] Written');

      print('[Player] setFilePath');
      await _player.setFilePath(tempPath);
      print('[Player] play()');
      _player.play();
    } catch (e) {
      print('[Error] $e');
    } finally {
      setState(() => _loading = false);
      print('[UI] Loading hidden');
    }
  }


  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Music Player')),
      body: Center(
        child: _loading
            ? const CircularProgressIndicator()
            : ElevatedButton(
          onPressed: giveMusics,
          child: const Text("دریافت و پخش موزیک"),
        ),
      ),
    );
  }
}
