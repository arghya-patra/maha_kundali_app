import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'dart:convert';
import 'package:maha_kundali_app/apiManager/apiData.dart';
import 'package:maha_kundali_app/service/serviceManager.dart';

class LalKitabScreen extends StatefulWidget {
  String? dob;
  String? tob;
  String? lat;
  String? lon;

  LalKitabScreen({
    required this.dob,
    required this.tob,
    required this.lat,
    required this.lon,
  });

  @override
  _LalKitabScreenState createState() => _LalKitabScreenState();
}

class _LalKitabScreenState extends State<LalKitabScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool isLoading = true;
  List<dynamic> horoscopeData = [];
  List<dynamic> debtsData = [];
  Map<String, dynamic> remediesData = {};
  List<dynamic> housesData = [];
  List<dynamic> planetsData = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
    _tabController.addListener(() {
      if (_tabController.index == 0) {
        fetchHoroscopeData();
      } else if (_tabController.index == 1) {
        fetchLalKitabDebts(); // For Debts tab
      } else if (_tabController.index == 2) {
        fetchLalKitabRemedies();
      } else if (_tabController.index == 3) {
        fetchLalKitabHouses(); // For Houses tab
      } else if (_tabController.index == 4) {
        // Index 4 is 5th tab
        fetchLalKitabPlanets(); // <-- Call planets API
      }
    });

    fetchHoroscopeData(); // Initial load
  }

  Future<void> fetchLalKitabHouses() async {
    String url = APIData.login;
    final dobMap = parseDOB(widget.dob ?? "");

    setState(() => isLoading = true);
    try {
      final response = await http.post(Uri.parse(url), body: {
        'action': 'lalkitab_houses',
        'authorizationToken': ServiceManager.tokenID,
        'tob': widget.tob ?? "",
        'lat': widget.lat ?? "",
        'lon': widget.lon ?? "",
        'zone': '5.5',
        ...dobMap,
      });

      print(["** Houses **", response.body]);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data['lalkitab_houses'] is List) {
          setState(() {
            housesData = data['lalkitab_houses'];
            isLoading = false;
          });
        } else {
          setState(() {
            housesData = [];
            isLoading = false;
          });
        }
      }
    } catch (e) {
      setState(() => isLoading = false);
      print("Error fetching Houses: $e");
    }
  }

  String formatDOB(String dob) {
    try {
      DateTime parsedDate = DateFormat('dd/MM/yyyy').parse(dob);
      return DateFormat('yyyy-MM-dd').format(parsedDate); // Output: 2025-05-01
    } catch (e) {
      print("Date parse error: $e");
      return "";
    }
  }

  Map<String, String> parseDOB(String dob) {
    try {
      final parsedDate = DateFormat('dd/MM/yyyy').parse(dob);
      return {
        'day': parsedDate.day.toString(),
        'month': parsedDate.month.toString(),
        'year': parsedDate.year.toString(),
      };
    } catch (e) {
      print("DOB parsing error: $e");
      return {'day': '', 'month': '', 'year': ''};
    }
  }

  Future<void> fetchHoroscopeData() async {
    String url = APIData.login;
    print(widget.dob);
    print(widget.tob);
    final dobMap = parseDOB(widget.dob ?? "");

    setState(() => isLoading = true);
    try {
      final response = await http.post(Uri.parse(url), body: {
        'action': 'lalkitab_horoscope',
        'authorizationToken': ServiceManager.tokenID,
        // 'dob': formatDOB(widget.dob ?? ""),
        'tob': widget.tob ?? "",
        'lat': widget.lat ?? "",
        'lon': widget.lon ?? "",
        'zone': '5.5',
        ...dobMap,
      });

      print(["****", response.body]);

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);

        if (data['lalkitab_horoscope'] is List) {
          setState(() {
            horoscopeData = data['lalkitab_horoscope'];
            isLoading = false;
          });
        } else {
          setState(() {
            horoscopeData = [];
            isLoading = false;
          });
          print("Unexpected structure: ${data['lalkitab_horoscope']}");
        }
      } else {
        throw Exception('Failed to load horoscope data');
      }
    } catch (e) {
      setState(() => isLoading = false);
      print("Error: $e");
    }
  }

  Future<void> fetchLalKitabPlanets() async {
    String url = APIData.login;
    final dobMap = parseDOB(widget.dob ?? "");

    setState(() => isLoading = true);
    try {
      final response = await http.post(Uri.parse(url), body: {
        'action': 'lalkitab_planets',
        'authorizationToken': ServiceManager.tokenID,
        'tob': widget.tob ?? "",
        'lat': widget.lat ?? "",
        'lon': widget.lon ?? "",
        'zone': '5.5',
        ...dobMap,
      });

      print(["** Planets **", response.body]);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['lalkitab_planets'] is List) {
          setState(() {
            planetsData = data['lalkitab_planets'];
            isLoading = false;
          });
        } else {
          setState(() {
            planetsData = [];
            isLoading = false;
          });
        }
      } else {
        throw Exception('Failed to load planet data');
      }
    } catch (e) {
      setState(() => isLoading = false);
      print("Error fetching Planets: $e");
    }
  }

  Future<void> fetchLalKitabDebts() async {
    String url = APIData.login; // Use the appropriate endpoint

    final dobMap = parseDOB(widget.dob ?? "");

    setState(() => isLoading = true);
    try {
      final response = await http.post(Uri.parse(url), body: {
        'action': 'lalkitab_debts',
        'authorizationToken': ServiceManager.tokenID,
        'tob': widget.tob ?? "",
        'lat': widget.lat ?? "",
        'lon': widget.lon ?? "",
        'zone': '5.5',
        ...dobMap,
      });

      print(["** Debts **", response.body]);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data['lalkitab_debts'] is List) {
          setState(() {
            debtsData = data['lalkitab_debts'];
            isLoading = false;
          });
        } else {
          setState(() {
            debtsData = [];
            isLoading = false;
          });
        }
      }
    } catch (e) {
      setState(() => isLoading = false);
      print("Error fetching Debts: $e");
    }
  }

  Future<void> fetchLalKitabRemedies() async {
    String url = APIData.login; // or the actual endpoint for remedies
    final dobMap = parseDOB(widget.dob ?? "");

    setState(() => isLoading = true);
    try {
      final response = await http.post(Uri.parse(url), body: {
        'action': 'lalkitab_remedies',
        'authorizationToken': ServiceManager.tokenID,
        'tob': widget.tob ?? "",
        'lat': widget.lat ?? "",
        'lon': widget.lon ?? "",
        'zone': '5.5',
        ...dobMap,
      });

      print(["** Remedies **", response.body]);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data['lalkitab_remedies'] is Map<String, dynamic>) {
          setState(() {
            remediesData = data['lalkitab_remedies'];
            isLoading = false;
          });
        } else {
          setState(() {
            remediesData = {};
            isLoading = false;
          });
        }
      }
    } catch (e) {
      setState(() => isLoading = false);
      print("Error fetching Remedies: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lal Kitab Results'),
        centerTitle: true,
        backgroundColor: Colors.orangeAccent,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          indicatorWeight: 3,
          isScrollable: true,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.black,
          tabs: const [
            Tab(text: 'Horoscope'),
            Tab(text: 'Debts'),
            Tab(text: 'Remedies'),
            Tab(text: 'Houses'),
            Tab(text: 'Planets'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          isLoading
              ? const Center(child: CircularProgressIndicator())
              : _buildHoroscopeTable(),
          isLoading
              ? const Center(child: CircularProgressIndicator())
              : _buildDebtsTable(),
          isLoading
              ? const Center(child: CircularProgressIndicator())
              : _buildRemediesUI(),
          isLoading
              ? const Center(child: CircularProgressIndicator())
              : _buildHousesTable(),
          isLoading
              ? const Center(child: CircularProgressIndicator())
              : _buildPlanetsTable(),
        ],
      ),
    );
  }

  Widget _buildPlanetsTable() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Table(
          border: TableBorder.all(color: Colors.grey),
          columnWidths: const {
            0: FractionColumnWidth(0.2),
            1: FractionColumnWidth(0.2),
            2: FractionColumnWidth(0.2),
            3: FractionColumnWidth(0.2),
            4: FractionColumnWidth(0.2),
          },
          children: [
            _buildPlanetsHeader(),
            ...planetsData.map<TableRow>((item) => TableRow(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(item['planet'] ?? '—',
                          style: const TextStyle(fontWeight: FontWeight.bold)),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(item['rashi'] ?? '—'),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(item['soya'] == true ? 'Yes' : 'No'),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(item['position'] ?? '—'),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(item['nature'] ?? '—'),
                    ),
                  ],
                )),
          ],
        ),
      ),
    );
  }

  TableRow _buildPlanetsHeader() {
    return const TableRow(
      decoration: BoxDecoration(color: Colors.orangeAccent),
      children: [
        Padding(
          padding: EdgeInsets.all(10),
          child: Text('Planet',
              style:
                  TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        ),
        Padding(
          padding: EdgeInsets.all(10),
          child: Text('Rashi',
              style:
                  TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        ),
        Padding(
          padding: EdgeInsets.all(10),
          child: Text('Soya',
              style:
                  TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        ),
        Padding(
          padding: EdgeInsets.all(10),
          child: Text('Position',
              style:
                  TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        ),
        Padding(
          padding: EdgeInsets.all(10),
          child: Text('Nature',
              style:
                  TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        ),
      ],
    );
  }

  Widget _buildHousesTable() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Table(
          border: TableBorder.all(color: Colors.grey),
          defaultColumnWidth: const FixedColumnWidth(120.0),
          children: [
            _buildHousesHeader(),
            ...housesData.map<TableRow>((item) => TableRow(
                  children: [
                    _tableCell(item['khana_number'].toString()),
                    _tableCell(item['maalik']),
                    _tableCell(item['pakka_ghar']),
                    _tableCell(item['kismat']),
                    _tableCell(item['soya'].toString()),
                    _tableCell(_formatList(item['exalt'])),
                    _tableCell(_formatList(item['debilitated'])),
                  ],
                )),
          ],
        ),
      ),
    );
  }

  TableRow _buildHousesHeader() {
    return TableRow(
      decoration: BoxDecoration(color: Colors.orangeAccent),
      children: [
        _headerCell('Khana'),
        _headerCell('Maalik'),
        _headerCell('Pakka Ghar'),
        _headerCell('Kismat'),
        _headerCell('Soya'),
        _headerCell('Exalt'),
        _headerCell('Debilitated'),
      ],
    );
  }

  static Widget _headerCell(String text) => Padding(
        padding: EdgeInsets.all(10),
        child: Text(text,
            style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white)),
      );

  Widget _tableCell(String text) => Padding(
        padding: const EdgeInsets.all(10),
        child: Text(text, style: const TextStyle(fontSize: 14)),
      );

  String _formatList(dynamic value) {
    if (value == null || value == '-' || value == 'null') return '-';
    if (value is List) return value.join(', ');
    return value.toString();
  }

  Widget _buildDebtsTable() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: debtsData.map<Widget>((item) {
            return Card(
              margin: const EdgeInsets.symmetric(vertical: 8),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item['debt_name'] ?? '—',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Indications: ${item['indications'] ?? '—'}',
                      style: const TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Events: ${item['events'] ?? '—'}',
                      style: const TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildHoroscopeTable() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Table(
          border: TableBorder.all(color: Colors.grey),
          columnWidths: const {
            0: FractionColumnWidth(0.3),
            1: FractionColumnWidth(0.7),
          },
          children: [
            _buildTableHeader(),
            ...horoscopeData.map<TableRow>((item) => TableRow(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Text(item['sign_name'],
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16)),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Text(
                        item['planet_small'] != null &&
                                item['planet_small'].isNotEmpty
                            ? item['planet_small'].join(', ')
                            : '—',
                        style: const TextStyle(fontSize: 15),
                      ),
                    ),
                  ],
                )),
          ],
        ),
      ),
    );
  }

  TableRow _buildTableHeader() {
    return const TableRow(
      decoration: BoxDecoration(color: Colors.orangeAccent),
      children: [
        Padding(
          padding: EdgeInsets.all(10),
          child: Text('Sign',
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white)),
        ),
        Padding(
          padding: EdgeInsets.all(10),
          child: Text('Planets',
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white)),
        ),
      ],
    );
  }

  Widget _buildRemediesUI() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(12),
      child: remediesData.isEmpty
          ? const Text("No remedies available.")
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: remediesData.entries.map((entry) {
                final planet = entry.key;
                final data = entry.value;
                return Card(
                  margin: const EdgeInsets.only(bottom: 16),
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "${data['planet']} in ${data['house']} House",
                          style: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          data['lal_kitab_desc'] ?? '',
                          style: const TextStyle(fontSize: 15),
                        ),
                        const SizedBox(height: 10),
                        const Text(
                          "Remedies:",
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(height: 6),
                        ...List.generate(
                          (data['lal_kitab_remedies'] as List).length,
                          (index) => Padding(
                            padding: const EdgeInsets.only(bottom: 6),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text("• ",
                                    style: TextStyle(fontSize: 15)),
                                Expanded(
                                  child: Text(
                                    data['lal_kitab_remedies'][index],
                                    style: const TextStyle(fontSize: 15),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
    );
  }

  Widget _buildDummyTab(String text) {
    return Center(
      child: Text(
        text,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
      ),
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
}
