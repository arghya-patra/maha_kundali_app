import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:maha_kundali_app/apiManager/apiData.dart';
import 'package:maha_kundali_app/service/serviceManager.dart';

class DoshaDetailsScreen extends StatefulWidget {
  String? name;
  String? dob;
  String? tob;
  String? pob;
  String? lat;
  String? lon;
  String? language;
  String? screen;
  DoshaDetailsScreen(
      {required this.name,
      required this.dob,
      required this.tob,
      required this.pob,
      required this.lat,
      required this.lon,
      required this.language,
      required this.screen});

  @override
  _DoshaDetailsScreenState createState() => _DoshaDetailsScreenState();
}

class _DoshaDetailsScreenState extends State<DoshaDetailsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  Map<String, dynamic>? horoscopeData;
  Map<String, dynamic>? doshaData;
  Map<String, dynamic>? dashaData;
  Map<String, dynamic>? chartData;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();

    _tabController = TabController(length: 4, vsync: this);
    _fetchHoroscopeData("horoscope"); // Fetch data for the first tab
    _fetchHoroscopeData("dosha");
    _fetchHoroscopeData("dasha");
    _fetchHoroscopeData("chart");
  }

  Future<void> _fetchHoroscopeData(page) async {
    setState(() {
      isLoading = true;
    });

    try {
      // Replace with your API URL
      String url = APIData.login;

      print(url.toString());
      final response = await http.post(Uri.parse(url), body: {
        'action': 'free-service-type',
        'authorizationToken': ServiceManager.tokenID,
        'type': 'kundali',
        'name': widget.name,
        'dob': widget.dob,
        'tob': widget.tob,
        'pob': widget.pob,
        'lang': widget.language == "English" ? 'en' : 'hi',
        //'city': _selectedCity,
        'lat': widget.lat,
        'lon': widget.lon,
        'page': page
      });
      if (response.statusCode == 200) {
        print(["%^%^%^%^%^", response.body]);
        setState(() {
          if (page == 'horoscope') {
            horoscopeData = json.decode(response.body);
            print(["%%%%%%%%%%%%%%", "jhjhj"]);
          }

          if (page == 'dosha') {
            doshaData = json.decode(response.body);
            // print(["%%%%%%%%%%%%%%", doshaData!['mangaldosh']]);
          }
          if (page == 'dasha') {
            var data = json.decode(response.body);
            dashaData = data['dasha'];
            print(["%%%%%%%%%%%%%%", dashaData]);
          }
          if (page == 'chart') {
            var data = json.decode(response.body);
            chartData = {
              'Lagna': data['chart']['Lagna'],
              'Dreshkana': data['chart']['Dreshkana'],
              'Somanatha': data['chart']['Somanatha'],
              'Saptamsa': data['chart']['Saptamsa'],
              'Navamsa': data['chart']['Navamsa'],
              'Dasamsa': data['chart']['Dasamsa'],
              'Dasamsa-EvenReverse': data['chart']['Dasamsa-EvenReverse'],
              'Dwadasamsa': data['chart']['Dwadasamsa'],
              'Shodashamsa': data['chart']['Shodashamsa'],
              'Vimsamsa': data['chart']['Vimsamsa'],
              'ChaturVimshamsha': data['chart']['ChaturVimshamsha'],
              'Trimshamsha': data['chart']['Trimshamsha'],
              'KhaVedamsa': data['chart']['KhaVedamsa'],
              'AkshaVedamsa': data['chart']['AkshaVedamsa'],
              'Shastiamsha': data['chart']['Shastiamsha']
            };
          }
        });
      } else {
        throw Exception("Failed to load data");
      }
    } catch (e) {
      print("Error fetching data: $e");
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Widget _buildChartTab() {
    // Check if the chart data has been fetched
    if (chartData == null) {
      return Center(
        child: CircularProgressIndicator(),
      );
    }

    return Container(
      // color: Color.fromARGB(255, 255, 160, 122),
      child: SingleChildScrollView(
        child: Column(
          children: [
            // Lagna Chart
            _buildChartWidget('Lagna', chartData!['Lagna']),

            // Dreshkana Chart
            _buildChartWidget('Dreshkana', chartData!['Dreshkana']),
            _buildChartWidget('Somanatha', chartData!['Somanatha']),
            _buildChartWidget('Saptamsa', chartData!['Saptamsa']),
            _buildChartWidget('Navamsa', chartData!['Navamsa']),
            _buildChartWidget('Dasamsa', chartData!['Dasamsa']),
            _buildChartWidget(
                'Dasamsa-EvenReverse', chartData!['Dasamsa-EvenReverse']),
            _buildChartWidget('Dwadasamsa', chartData!['Dwadasamsa']),
            _buildChartWidget('Shodashamsa', chartData!['Shodashamsa']),
            _buildChartWidget('Vimsamsa', chartData!['Vimsamsa']),
            _buildChartWidget(
                'ChaturVimshamsha', chartData!['ChaturVimshamsha']),
            _buildChartWidget('Trimshamsha', chartData!['Trimshamsha']),
            _buildChartWidget('KhaVedamsa', chartData!['KhaVedamsa']),
            _buildChartWidget('AkshaVedamsa', chartData!['AkshaVedamsa']),
            _buildChartWidget('Shastiamsha', chartData!['Shastiamsha']),
          ],
        ),
      ),
    );
  }

  Widget _buildChartWidget(String title, String svgData) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8),
          // Render the SVG image using an SVG package (like flutter_svg)
          SvgPicture.string(
            svgData,
            height: 300, // Adjust the size as needed
            width: double.infinity,
            placeholderBuilder: (BuildContext context) =>
                CircularProgressIndicator(),
          ),
        ],
      ),
    );
  }

  Widget _buildDashaTab() {
    if (isLoading) {
      return Center(
        child: CircularProgressIndicator(),
      );
    }

    if (dashaData == null) {
      return Center(
        child: CircularProgressIndicator(),
      );
    }

    final mahaDasha = dashaData!['maha_dasha']['response']['mahadasha'] as List;
    final mahaDashaOrder =
        dashaData!['maha_dasha']['response']['mahadasha_order'] as List;
    //     final antarDasha = dashaData!['antar_dasha']['response']['antar_dasha'] as List;
    // final antarDashaOrder =
    //     dashaData!['antar_dasha']['response']['antar_dasha_order'] as List;

    return SingleChildScrollView(
      child: Container(
        color: Color.fromARGB(255, 255, 239, 191),
        child: DataTable(
          columns: const [
            DataColumn(label: Text('Maha Dasha')),
            DataColumn(label: Text('Start Date')),
          ],
          rows: List<DataRow>.generate(
            mahaDasha.length,
            (index) => DataRow(
              cells: [
                DataCell(Text(mahaDasha[index])),
                DataCell(Text(mahaDashaOrder[index])),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHoroscopeTab() {
    if (isLoading) {
      return Center(child: CircularProgressIndicator());
    }

    if (horoscopeData == null) {
      return Center(
        child: CircularProgressIndicator(),
      );
    }

    final basicDetails = horoscopeData!['basic_details'];
    final ascendantReport = horoscopeData!['ascendant_report']['response'][0];

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Basic Details",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 10),
          Container(
            color: Color.fromARGB(255, 255, 239, 191),
            child: Table(
              border: TableBorder.all(color: Colors.grey),
              columnWidths: const {
                0: FlexColumnWidth(1),
                1: FlexColumnWidth(2)
              },
              children: [
                _buildTableRow("Name", basicDetails['name']),
                _buildTableRow("Date of Birth", basicDetails['dob']),
                _buildTableRow("Time", basicDetails['time']),
                _buildTableRow("Latitude", basicDetails['lat']),
                _buildTableRow("Longitude", basicDetails['lon']),
                _buildTableRow("Sun Sign", basicDetails['sun_sign']),
                _buildTableRow("City", basicDetails['city']),
              ],
            ),
          ),
          SizedBox(height: 20),
          Text(
            "Ascendant Report",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 10),
          Container(
            color: Color.fromARGB(255, 255, 239, 191),
            child: Table(
              border: TableBorder.all(color: Colors.grey),
              columnWidths: const {
                0: FlexColumnWidth(1),
                1: FlexColumnWidth(2)
              },
              children: [
                _buildTableRow("Ascendant", ascendantReport['ascendant']),
                _buildTableRow("Lord", ascendantReport['ascendant_lord']),
                _buildTableRow("Lord Location",
                    ascendantReport['ascendant_lord_location']),
                _buildTableRow(
                    "House Location",
                    ascendantReport['ascendant_lord_house_location']
                        .toString()),
                _buildTableRow("Symbol", ascendantReport['symbol']),
                _buildTableRow("Lucky Gem", ascendantReport['lucky_gem']),
                _buildTableRow(
                    "Good Qualities", ascendantReport['good_qualities']),
                _buildTableRow(
                    "Bad Qualities", ascendantReport['bad_qualities']),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDoshaTab(Map<String, dynamic> data) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Kaal Sarp Dosh Section
          _buildTableForDosha("Kaal Sarp Dosh", {
            "Dosha Present": data['kaalsarpdosh']['response']
                    ['is_dosha_present']
                ? "Yes"
                : "No",
            "Bot Response": data['kaalsarpdosh']['response']['bot_response'],
            "Remedies": data['kaalsarpdosh']['response']['remedies'][0],
          }),
          SizedBox(height: 10),
          // Remedies Section
          if (data['kaalsarpdosh']['response']['is_dosha_present']) ...[
            Text(
              "Remedies:",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            ...data['kaalsarpdosh']['response']['remedies'].map<Widget>(
              (remedy) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Text("- $remedy"),
              ),
            ),
          ],

          // Mangal Dosh Section
          SizedBox(height: 20),
          _buildTableForDosha("Mangal Dosh", {
            "Dosha Present": data['mangaldosh']['response']['is_dosha_present']
                ? "Yes"
                : "No",
            "Bot Response": data['mangaldosh']['response']['bot_response'],
            "Score": "${data['mangaldosh']['response']['score']}%",
            "Moon": "${data['mangaldosh']['response']['factors']['moon']}",
            "Venus": "${data['mangaldosh']['response']['factors']['venus']}",
          }),

          // Other Doshas Section
          SizedBox(height: 20),
          _buildTableForDosha("Pitra Dosh", {
            "Dosha Present": data['pitradosh']['response']['is_dosha_present']
                ? "Yes"
                : "No",
            "Bot Response": data['pitradosh']['response']['bot_response'],
          }),
        ],
      ),
    );
  }

  Widget _buildTableForDosha(String title, Map<String, String> data) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 8),
        Container(
          color: Color.fromARGB(255, 255, 239, 191),
          child: Table(
            border: TableBorder.all(color: Colors.grey, width: 0.5),
            columnWidths: {
              0: FlexColumnWidth(1),
              1: FlexColumnWidth(2),
            },
            children: data.entries.map((entry) {
              return TableRow(children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    entry.key,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(entry.value),
                ),
              ]);
            }).toList(),
          ),
        ),
      ],
    );
  }

  TableRow _buildTableRow(String key, String? value) {
    return TableRow(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            key,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(value ?? "N/A"),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            Text(widget.screen == 'dos' ? "Dasha Details" : "Kundali Details"),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.orange, Colors.deepOrange],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.orange,
          tabs: const [
            Tab(text: "Horoscope"),
            Tab(text: "Dosh"),
            Tab(text: "Dasha"),
            Tab(text: "Chart"),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildHoroscopeTab(),
          doshaData != null
              ? _buildDoshaTab(doshaData!)
              : Center(
                  child: CircularProgressIndicator(),
                ),
          _buildDashaTab(),
          _buildChartTab()
        ],
      ),
    );
  }
}
