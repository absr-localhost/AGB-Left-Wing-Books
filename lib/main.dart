import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'layar_pembuka.dart';
import 'tema.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  runApp(const AplikasiBuku());
}

class AplikasiBuku extends StatelessWidget {
  const AplikasiBuku({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AGB Left-Wing Books',
      debugShowCheckedModeBanner: false,
      theme: buatTema(),
      home: const LayarPembuka(),
    );
  }
}
