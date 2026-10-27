import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

const supabaseUrl = 'https://bckrevvqtyeotzndmmvn.supabase.co';
const supabaseKey = 'sb_publishable_Ly2SrPV_6JdsK1hYzr1gGQ_2rJ2eypw';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(url: supabaseUrl, anonKey: supabaseKey);
  runApp(const PixelGameApp());
}

class PixelGameApp extends StatelessWidget {
  const PixelGameApp({super.key});
  @override
  Widget build(BuildContext context) => MaterialApp(
        title: 'Pixel Game',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(colorSchemeSeed: Colors.deepPurple, useMaterial3: true),
        home: const TestPage(),
      );
}

class TestPage extends StatefulWidget {
  const TestPage({super.key});
  @override
  State<TestPage> createState() => _TestPageState();
}

class _TestPageState extends State<TestPage> {
  String status = 'Connexion...';
  List<Map<String, dynamic>> colors = [];

  @override
  void initState() {
    super.initState();
    load();
  }

  Future<void> load() async {
    try {
      final data =
          await Supabase.instance.client.from('colors').select().order('id');
      setState(() {
        colors = List<Map<String, dynamic>>.from(data);
        status = 'Connecté à Supabase (${colors.length} couleurs)';
      });
    } catch (e) {
      setState(() => status = 'Erreur : $e');
    }
  }

  Color hex(String h) => Color(int.parse('FF${h.substring(1)}', radix: 16));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Pixel Game')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(status, style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 20),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: [
                for (final c in colors)
                  CircleAvatar(radius: 22, backgroundColor: hex(c['hex'])),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
