import 'package:flutter/material.dart';

class JadwalLapanganScreen extends StatefulWidget {
  static const String routeName = '/jadwal-lapangan-screen';
  const JadwalLapanganScreen({super.key});

  @override
  State<JadwalLapanganScreen> createState() => _JadwalLapanganScreenState();
}

List<String> daftarLapangan = <String>[
  'Lapangan a',
  'Lapangan b',
  'Lapangan c',
  'Lapangan d'
];

class _JadwalLapanganScreenState extends State<JadwalLapanganScreen> {
  DateTime? tanggalDipilih;

  String lapanganDipilih = daftarLapangan.first;

  // proses pilih tanggal
  Future<void> _pilihTanggal(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2022),
      lastDate: DateTime(2025),
    );
    if (picked != null && picked != tanggalDipilih) {
      setState(() {
        tanggalDipilih = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // daftar lapangannya

    return Scaffold(
      body: Column(
        children: [
          //button pilih tanggal
          ElevatedButton(
              onPressed: () {
                _pilihTanggal(context);
              },
              child: Text("Pilih tanggal")),
          Text(
              "Tanggal dipilih : ${tanggalDipilih == null ? '-' : tanggalDipilih.toString()}"),

          // List lapangan
          DropdownButton<String>(
            value: lapanganDipilih,
            icon: const Icon(Icons.arrow_downward),
            elevation: 16,
            style: const TextStyle(color: Colors.deepPurple),
            underline: Container(
              height: 2,
              color: Colors.deepPurpleAccent,
            ),
            onChanged: (String? value) {
              setState(() {
                lapanganDipilih = value!;
              });
            },
            items: daftarLapangan.map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
          ),
          // List jam
          Visibility(
            visible: lapanganDipilih != null && tanggalDipilih != null,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: 5,
              itemBuilder: (context, index) {
                return Container(
                  decoration: BoxDecoration(color: Colors.green[300]),
                  child: Column(
                    children: [
                      Text("Jam ke ${index + 1}"),
                      Text("Lapangan : $lapanganDipilih"),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
