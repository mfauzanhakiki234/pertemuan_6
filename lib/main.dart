import 'dart:math';

import 'package:avatar_glow/avatar_glow.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:faker/faker.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';


const String namaSaya = 'M Fauzan Hakiki';
const String nimSaya = '4124032';
// =================================

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await initializeDateFormatting('id_ID', null);
  runApp(const KontakApp());
}

class KontakApp extends StatelessWidget {
  const KontakApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Daftar Kontak',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        useMaterial3: true,
      ),
      home: const MainPage(),
    );
  }
}

// ---------------------------------------------------------------------------
// Model & data dummy
// ---------------------------------------------------------------------------
class Kontak {
  final String nama;
  final String telepon;
  final String email;
  final DateTime ditambahkan;

  Kontak({
    required this.nama,
    required this.telepon,
    required this.email,
    required this.ditambahkan,
  });
}

const List<String> daftarNama = [
  'Badrussoleh',
  'Hobis Sastrawan',
  'Zulki Muji',
  'Pagistar',
  'Mikaza',
  'Samsudin',
  'Sono Budiman',
  'Asrulloh',
  'Doni Irawan',
  'Rendi Maulana',
  'Salehudin',
  'Maulana',
  'Firman Zaidi',
];

List<Kontak> buatKontakDummy(int jumlah) {
  final faker = Faker();
  final rnd = Random(42);
  return List.generate(jumlah, (i) {
    final nama = i < daftarNama.length ? daftarNama[i] : faker.person.name();
    final slug = nama.toLowerCase().replaceAll(RegExp(r'[^a-z0-9]'), '');
    final nomor =
        '08${rnd.nextInt(9) + 1}${List.generate(8, (_) => rnd.nextInt(10)).join()}';
    return Kontak(
      nama: nama,
      telepon: nomor,
      email: '$slug@gmail.com',
      ditambahkan: DateTime(2026, 10 + rnd.nextInt(2), 1 + rnd.nextInt(30)),

    );
  });
}

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _index = 0;

  final List<Widget> _pages = const [
    KontakPage(),
    CariPage(),
    ProfilPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(['Kontak', 'Cari', 'Profil'][_index])),
      body: IndexedStack(index: _index, children: _pages),
      bottomNavigationBar: ConvexAppBar(
        style: TabStyle.react,
        backgroundColor: Colors.indigo,
        activeColor: Colors.white,
        color: Colors.white70,
        initialActiveIndex: 0,
        items: const [
          TabItem(icon: Icons.contacts, title: 'Kontak'),
          TabItem(icon: Icons.search, title: 'Cari'),
          TabItem(icon: Icons.person, title: 'Profil'),
        ],
        onTap: (int i) => setState(() => _index = i),
      ),
    );
  }
}
class KontakPage extends StatefulWidget {
  const KontakPage({super.key});

  @override
  State<KontakPage> createState() => _KontakPageState();
}

class _KontakPageState extends State<KontakPage> {
  late final List<Kontak> _kontak = buatKontakDummy(15); // minimal 15
  final DateFormat _fmt = DateFormat('dd MMMM yyyy', 'id_ID');

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: _kontak.length,
      itemBuilder: (context, i) {
        final k = _kontak[i];
        return Column(
          children: [
            ListTile(
              leading: CircleAvatar(child: Text(k.nama[0])),
              title: Text(k.nama),
              subtitle: Text(
                '${k.telepon}\n${k.email}\nDitambahkan pada ${_fmt.format(k.ditambahkan)}',
              ),
              isThreeLine: true,
            ),
            const Divider(height: 1),
          ],
        );
      },
    );
  }
}

class CariPage extends StatefulWidget {
  const CariPage({super.key});

  @override
  State<CariPage> createState() => _CariPageState();
}

class _CariPageState extends State<CariPage> {
  final List<String> _kategori = const [
    'Keluarga',
    'Teman',
    'Kerja',
    'Kuliah',
    'Tetangga',
    'Lainnya',
  ];
  String? _dipilih;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          DropdownSearch<String>(
            items: _kategori,
            selectedItem: _dipilih,
            popupProps: const PopupProps.menu(
              showSearchBox: true,
              searchFieldProps: TextFieldProps(
                decoration: InputDecoration(
                  hintText: 'Cari kategori...',
                  prefixIcon: Icon(Icons.search),
                ),
              ),
            ),
            dropdownDecoratorProps: const DropDownDecoratorProps(
              dropdownSearchDecoration: InputDecoration(
                labelText: 'Kategori',
                hintText: 'Pilih kategori',
                border: OutlineInputBorder(),
              ),
            ),
            onChanged: (v) => setState(() => _dipilih = v),
          ),
          const SizedBox(height: 16),
          if (_dipilih != null) Text('Kategori terpilih: $_dipilih'),
        ],
      ),
    );
  }
}

class ProfilPage extends StatelessWidget {
  const ProfilPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AvatarGlow(
            glowColor: Colors.indigo,
            duration: const Duration(milliseconds: 2000),
            child: const CircleAvatar(
              radius: 60,
              backgroundImage: AssetImage('assets/foto.jpg'),
            ),
          ),
          const SizedBox(height: 32),
          const Text(namaSaya, style: TextStyle(fontSize: 20)),
          const SizedBox(height: 4),
          const Text('NIM $nimSaya - Sistem Informasi'),
        ],
      ),
    );
  }
}