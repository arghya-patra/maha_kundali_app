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
  bool? saved;
  bool isByKundaliId;
  String? id;
  String? gender;
  DoshaDetailsScreen(
      {required this.name,
      required this.dob,
      required this.tob,
      required this.pob,
      required this.lat,
      required this.lon,
      required this.language,
      this.saved,
      required this.screen,
      required this.isByKundaliId,
      required this.gender,
      this.id});

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

    print([widget.isByKundaliId, widget.id]);

    _tabController = TabController(length: 4, vsync: this);
    if (widget.isByKundaliId == false) {
      print("*****&&&&&***");
      _fetchHoroscopeData("horoscope"); // Fetch data for the first tab
      _fetchHoroscopeData("dosha");
      _fetchHoroscopeData("dasha");
      _fetchHoroscopeData("chart");
    } else {
      _fetchHoroscopeDataById("horoscope"); // Fetch data for the first tab
      _fetchHoroscopeDataById("dosha");
      _fetchHoroscopeDataById("dasha");
      _fetchHoroscopeDataById("chart");
    }
  }

  Future<void> _fetchHoroscopeDataById(page) async {
    setState(() {
      isLoading = true;
    });

    try {
      // Replace with your API URL
      String url = APIData.login;

      print(url.toString());
      final response = await http.post(Uri.parse(url), body: {
        'action': 'view-saved-kundali-details',
        'authorizationToken': ServiceManager.tokenID,
        'id': widget.id,
        'page': page
      });
      if (response.statusCode == 200) {
        print(["%^%^%^%^%^", response.body]);
        setState(() {
          if (page == 'horoscope') {
            var data = json.decode(response.body);
            horoscopeData = data['horoscope'];
            print(["%%%%%%%%%%%%%%", "jhjhj"]);
          }

          if (page == 'dosha') {
            var data = json.decode(response.body);
            doshaData = data['dosha'];
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

  Future<void> _fetchHoroscopeData(page) async {
    setState(() {
      isLoading = true;
    });

    try {
      // Replace with your API URL
      String url = APIData.login;
      var body1 = {
        'action': 'free-service-type',
        'authorizationToken': ServiceManager.tokenID,
        'type': 'kundali',
        'name': widget.name,
        'dob': widget.dob,
        'tob': widget.tob,
        'pob': widget.pob,
        'lang': widget.language == "English" ? 'en' : 'hi',
        'gender': widget.gender == "Male" ? 'm' : 'f',
        //'city': _selectedCity,
        'lat': widget.lat,
        'lon': widget.lon,
        'page': page,
        'save_name': "${widget.name}"
      };
      var body2 = {
        'action': 'free-service-type',
        'authorizationToken': ServiceManager.tokenID,
        'type': 'kundali',
        'name': widget.name,
        'dob': widget.dob,
        'tob': widget.tob,
        'pob': widget.pob,
        'lang': widget.language == "English" ? 'en' : 'hi',
        'gender': widget.gender == "Male" ? 'm' : 'f',
        //'city': _selectedCity,
        'lat': widget.lat,
        'lon': widget.lon,
        'page': page,
      };

      print(url.toString());
      final response =
          await http.post(Uri.parse(url), body: widget.saved! ? body1 : body2);
      if (response.statusCode == 200) {
        print(["%^%^%^%^%^", response.body]);
        setState(() {
          if (page == 'horoscope') {
            var data = json.decode(response.body);
            horoscopeData = data['horoscope'];
            print(["%%%%%%%%%%%%%%", "jhjhj"]);
          }

          if (page == 'dosha') {
            // doshaData = json.decode(response.body);
            var data = json.decode(response.body);
            doshaData = data['dosha'];

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

  // Widget _buildChartTab() {
  //   // Check if the chart data has been fetched
  //   if (chartData == null) {
  //     return const Center(
  //       child: CircularProgressIndicator(),
  //     );
  //   }

  //   return Container(
  //     // color: Color.fromARGB(255, 255, 160, 122),
  //     child: SingleChildScrollView(
  //       child: Column(
  //         children: [
  //           // Lagna Chart
  //           //  _buildChartWidget('Lagna', chartData!['Lagna']),

  //           // Dreshkana Chart
  //           _buildChartWidget('Dreshkana', chartData!['Dreshkana']),
  //           _buildChartWidget('Somanatha', chartData!['Somanatha']),
  //           _buildChartWidget('Saptamsa', chartData!['Saptamsa']),
  //           _buildChartWidget('Navamsa', chartData!['Navamsa']),
  //           _buildChartWidget('Dasamsa', chartData!['Dasamsa']),
  //           _buildChartWidget(
  //               'Dasamsa-EvenReverse', chartData!['Dasamsa-EvenReverse']),
  //           _buildChartWidget('Dwadasamsa', chartData!['Dwadasamsa']),
  //           _buildChartWidget('Shodashamsa', chartData!['Shodashamsa']),
  //           _buildChartWidget('Vimsamsa', chartData!['Vimsamsa']),
  //           _buildChartWidget(
  //               'ChaturVimshamsha', chartData!['ChaturVimshamsha']),
  //           _buildChartWidget('Trimshamsha', chartData!['Trimshamsha']),
  //           _buildChartWidget('KhaVedamsa', chartData!['KhaVedamsa']),
  //           _buildChartWidget('AkshaVedamsa', chartData!['AkshaVedamsa']),
  //           _buildChartWidget('Shastiamsha', chartData!['Shastiamsha']),
  //         ],
  //       ),
  //     ),
  //   );
  // }
  Widget _buildChartTab() {
    if (chartData == null) {
      return const Center(child: CircularProgressIndicator());
    }

    final chartKeys = [
      'Dreshkana',
      'Somanatha',
      'Saptamsa',
      'Navamsa',
      'Dasamsa',
      'Dasamsa-EvenReverse',
      'Dwadasamsa',
      'Shodashamsa',
      'Vimsamsa',
      'ChaturVimshamsha',
      'Trimshamsha',
      'KhaVedamsa',
      'AkshaVedamsa',
      'Shastiamsha',
    ];

    return DefaultTabController(
      length: chartKeys.length,
      child: Column(
        children: [
          Container(
            color: Colors.orange.shade100,
            child: TabBar(
              isScrollable: true,
              labelColor: Colors.black,
              indicatorColor: Colors.orange,
              tabs: chartKeys.map((key) => Tab(text: key)).toList(),
              tabAlignment: TabAlignment.start,
            ),
          ),
          Expanded(
            child: TabBarView(
              children: chartKeys
                  .map((key) => _buildChartWidget(key, chartData![key]))
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }

  // Widget _buildChartWidget(String title, String svgData) {
  //   return Padding(
  //     padding: const EdgeInsets.symmetric(vertical: 16.0),
  //     child: Column(
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       children: [
  //         Text(
  //           title,
  //           style: const TextStyle(
  //             fontSize: 24,
  //             fontWeight: FontWeight.bold,
  //           ),
  //         ),
  //         const SizedBox(height: 8),
  //         // Render the SVG image using an SVG package (like flutter_svg)
  //         SvgPicture.string(
  //           svgData,
  //           height: 300, // Adjust the size as needed
  //           width: double.infinity,
  //           placeholderBuilder: (BuildContext context) =>
  //               const CircularProgressIndicator(),
  //         ),
  //       ],
  //     ),
  //   );
  // }
  Widget _buildChartWidget(String title, String svgData) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          SvgPicture.string(
            svgData,
            height: 300,
            width: double.infinity,
            placeholderBuilder: (BuildContext context) =>
                const Center(child: CircularProgressIndicator()),
          ),
        ],
      ),
    );
  }

  Widget _buildDashaTab() {
    if (isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (dashaData == null) {
      return const Center(
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
        color: const Color.fromARGB(255, 255, 239, 191),
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
      return const Center(child: CircularProgressIndicator());
    }

    if (horoscopeData == null) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    final basicDetails = horoscopeData!['basic_details'];
    final ascendantReport = horoscopeData!['ascendant_report']['response'][0];

    final sunSignDetails = horoscopeData!['sunsign']['response'];
    final personalReport =
        horoscopeData!['personal_characteristics']['response'][0];

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Basic Details",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          Container(
            color: const Color.fromARGB(255, 255, 239, 191),
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
          const SizedBox(height: 20),
          const Text(
            "Ascendant Report",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          Container(
            color: const Color.fromARGB(255, 255, 239, 191),
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
                _buildTableRow("General Prediction",
                    ascendantReport['general_prediction']),
                _buildTableRow("Personalised Prediction",
                    ascendantReport['personalised_prediction']),
                _buildTableRow(
                    "Verbal Location", ascendantReport['verbal_location']),
                _buildTableRow("Ascendant Lord Strength",
                    ascendantReport['ascendant_lord_strength']),
                _buildTableRow("Zodiac Characteristics",
                    ascendantReport['zodiac_characteristics']),
                _buildTableRow(
                    "Day For Fasting", ascendantReport['day_for_fasting']),
                _buildTableRow(
                    "Gayatri Mantra", ascendantReport['gayatri_mantra']),
                _buildTableRow("Flagship Qualities",
                    ascendantReport['flagship_qualities']),
                _buildTableRow("Symbol", ascendantReport['symbol']),
                _buildTableRow("Lucky Gem", ascendantReport['lucky_gem']),
                _buildTableRow("Spirituality Advice",
                    ascendantReport['spirituality_advice']),
                _buildTableRow(
                    "Good Qualities", ascendantReport['good_qualities']),
                _buildTableRow(
                    "Bad Qualities", ascendantReport['bad_qualities']),
              ],
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            "Sunsign",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          Container(
            color: const Color.fromARGB(255, 255, 239, 191),
            child: Table(
              border: TableBorder.all(color: Colors.grey),
              columnWidths: const {
                0: FlexColumnWidth(1),
                1: FlexColumnWidth(2)
              },
              children: [
                _buildTableRow("Sunsign", sunSignDetails['sun_sign']),
                _buildTableRow("Prediction", sunSignDetails['prediction']),
              ],
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            "Personal Report",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          Container(
            color: const Color.fromARGB(255, 255, 239, 191),
            child: Table(
              border: TableBorder.all(color: Colors.grey),
              columnWidths: const {
                0: FlexColumnWidth(1),
                1: FlexColumnWidth(2)
              },
              children: [
                _buildTableRow("Ascendant", personalReport['ascendant']),
                _buildTableRow("Lord", personalReport['ascendant_lord']),
                _buildTableRow(
                    "Lord Location", personalReport['ascendant_lord_location']),
                _buildTableRow("House Location",
                    personalReport['ascendant_lord_house_location'].toString()),
                _buildTableRow(
                    "General Prediction", personalReport['general_prediction']),
                _buildTableRow("Personalised Prediction",
                    personalReport['personalised_prediction']),
                _buildTableRow(
                    "Verbal Location", personalReport['verbal_location']),
                _buildTableRow("Ascendant Lord Strength",
                    personalReport['ascendant_lord_strength']),
                _buildTableRow("Zodiac Characteristics",
                    personalReport['zodiac_characteristics']),
                _buildTableRow(
                    "Day For Fasting", personalReport['day_for_fasting']),
                _buildTableRow(
                    "Gayatri Mantra", personalReport['gayatri_mantra']),
                _buildTableRow(
                    "Flagship Qualities", personalReport['flagship_qualities']),
                _buildTableRow("Symbol", personalReport['symbol']),
                _buildTableRow("Lucky Gem", personalReport['lucky_gem']),
                _buildTableRow("Spirituality Advice",
                    personalReport['spirituality_advice']),
                _buildTableRow(
                    "Good Qualities", personalReport['good_qualities']),
                _buildTableRow(
                    "Bad Qualities", personalReport['bad_qualities']),
              ],
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            "Birth Dasa",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          Container(
            color: const Color.fromARGB(255, 255, 239, 191),
            child: Table(
              border: TableBorder.all(color: Colors.grey),
              columnWidths: const {
                0: FlexColumnWidth(1),
                1: FlexColumnWidth(2)
              },
              children: [
                _buildTableRow("Birth Dasa",
                    horoscopeData!['planet_details']['response']['birth_dasa']),
                _buildTableRow(
                    "Birth Dasa Time",
                    horoscopeData!['planet_details']['response']
                        ['birth_dasa_time']),
              ],
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            "Current Dasa",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          Container(
            color: const Color.fromARGB(255, 255, 239, 191),
            child: Table(
              border: TableBorder.all(color: Colors.grey),
              columnWidths: const {
                0: FlexColumnWidth(1),
                1: FlexColumnWidth(2)
              },
              children: [
                _buildTableRow(
                    "Current Dasa",
                    horoscopeData!['planet_details']['response']
                        ['current_dasa']),
                _buildTableRow(
                    "Current Dasa",
                    horoscopeData!['planet_details']['response']
                        ['current_dasa_time']),
              ],
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            "Lucky Gem",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          Container(
            color: const Color.fromARGB(255, 255, 239, 191),
            child: Table(
              border: TableBorder.all(color: Colors.grey),
              columnWidths: const {
                0: FlexColumnWidth(1),
                1: FlexColumnWidth(2)
              },
              children: [
                _buildTableRow(
                    "Lucky Gem",
                    horoscopeData!['planet_details']['response']['lucky_gem']
                        .toString()),
              ],
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            "Lucky Number",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          Container(
            color: const Color.fromARGB(255, 255, 239, 191),
            child: Table(
              border: TableBorder.all(color: Colors.grey),
              columnWidths: const {
                0: FlexColumnWidth(1),
                1: FlexColumnWidth(2)
              },
              children: [
                _buildTableRow(
                    "Lucky Number",
                    horoscopeData!['planet_details']['response']['lucky_num']
                        .toString()),
              ],
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            "Lucky Colors",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          Container(
            color: const Color.fromARGB(255, 255, 239, 191),
            child: Table(
              border: TableBorder.all(color: Colors.grey),
              columnWidths: const {
                0: FlexColumnWidth(1),
                1: FlexColumnWidth(2)
              },
              children: [
                _buildTableRow(
                    "Lucky Colors",
                    horoscopeData!['planet_details']['response']['lucky_colors']
                        .toString()),
              ],
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            "Lucky Name Strats",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          Container(
            color: const Color.fromARGB(255, 255, 239, 191),
            child: Table(
              border: TableBorder.all(color: Colors.grey),
              columnWidths: const {
                0: FlexColumnWidth(1),
                1: FlexColumnWidth(2)
              },
              children: [
                _buildTableRow(
                    "Lucky Name Starts",
                    horoscopeData!['planet_details']['response']
                            ['lucky_name_start']
                        .toString()),
              ],
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            "Planet Details",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          buildPlanetDetailsTable(horoscopeData!['planet_details'])
        ],
      ),
    );
  }

  Widget buildPlanetDetailsTable(Map<String, dynamic> planetDetails) {
    Map<String, dynamic> response = planetDetails["response"];

    // Extract only the first 10 (0-9) planets
    List<Map<String, dynamic>> planetList = [];
    for (int i = 0; i <= 9; i++) {
      if (response.containsKey(i.toString())) {
        planetList.add(response[i.toString()]);
      }
    }

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Container(
        color: const Color.fromARGB(255, 255, 239, 191),
        child: DataTable(
          columnSpacing: 12.0,
          border: TableBorder.all(color: Colors.grey),
          columns: const [
            DataColumn(label: Text('Name')),
            DataColumn(label: Text('Full Name')),
            DataColumn(label: Text('Zodiac')),
            DataColumn(label: Text('House')),
            DataColumn(label: Text('Nakshatra')),
            DataColumn(label: Text('Nakshatra Lord')),
            DataColumn(label: Text('Zodiac Lord')),
          ],
          rows: planetList.map((planet) {
            return DataRow(cells: [
              DataCell(Text(planet["name"].toString())),
              DataCell(Text(planet["full_name"].toString())),
              DataCell(Text(planet["zodiac"].toString())),
              DataCell(Text(planet["house"].toString())),
              DataCell(Text(planet["nakshatra"].toString())),
              DataCell(Text(planet["nakshatra_lord"].toString())),
              DataCell(Text(planet["zodiac_lord"].toString())),
            ]);
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildDoshaTab(Map<String, dynamic> data) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // === Kaal Sarp Dosh Section ===
          if (data['kaalsarpdosh']?['response'] != null)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildTableForDosha("Kaal Sarp Dosh", {
                  "Dosha Present": data['kaalsarpdosh']['response']
                          ['is_dosha_present']
                      ? "Yes"
                      : "No",
                  "Bot Response":
                      data['kaalsarpdosh']['response']['bot_response'] ?? '',
                  "Remedies":
                      (data['kaalsarpdosh']['response']['remedies'] is List &&
                              data['kaalsarpdosh']['response']['remedies']
                                  .isNotEmpty)
                          ? data['kaalsarpdosh']['response']['remedies'][0]
                          : 'N/A',
                }),
                const SizedBox(height: 10),
                if (data['kaalsarpdosh']['response']['is_dosha_present'] ==
                        true &&
                    data['kaalsarpdosh']['response']['remedies'] is List)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Remedies:",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      ...data['kaalsarpdosh']['response']['remedies']
                          .map<Widget>(
                            (remedy) => Padding(
                              padding: const EdgeInsets.symmetric(vertical: 4),
                              child: Text("- $remedy"),
                            ),
                          )
                          .toList(),
                    ],
                  ),
              ],
            ),

          // === Mangal Dosh Section ===
          const SizedBox(height: 20),
          if (data['mangaldosh']?['response'] != null &&
              data['mangaldosh']['response'] is Map &&
              data['mangaldosh']['response'].containsKey('is_dosha_present'))
            _buildTableForDosha("Mangal Dosh", {
              "Dosha Present":
                  data['mangaldosh']['response']['is_dosha_present'] == true
                      ? "Yes"
                      : "No",
              "Bot Response":
                  data['mangaldosh']['response']['bot_response'] ?? 'N/A',
              "Score": "${data['mangaldosh']['response']['score'] ?? 'N/A'}%",
              "Moon":
                  "${data['mangaldosh']['response']['factors']?['moon'] ?? 'N/A'}",
              "Venus":
                  "${data['mangaldosh']['response']['factors']?['venus'] ?? 'N/A'}",
            }),

          // === Pitra Dosh Section ===
          const SizedBox(height: 20),
          if (data['pitradosh']?['response'] != null)
            _buildTableForDosha("Pitra Dosh", {
              "Dosha Present":
                  data['pitradosh']['response']['is_dosha_present'] == true
                      ? "Yes"
                      : "No",
              "Bot Response":
                  data['pitradosh']['response']['bot_response'] ?? 'N/A',
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
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Container(
          color: const Color.fromARGB(255, 255, 239, 191),
          child: Table(
            border: TableBorder.all(color: Colors.grey, width: 0.5),
            columnWidths: const {
              0: FlexColumnWidth(1),
              1: FlexColumnWidth(2),
            },
            children: data.entries.map((entry) {
              return TableRow(children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    entry.key,
                    style: const TextStyle(fontWeight: FontWeight.bold),
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
            style: const TextStyle(fontWeight: FontWeight.bold),
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
            Tab(text: "Dosha"),
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
              : const Center(
                  child: CircularProgressIndicator(),
                ),
          _buildDashaTab(),
          _buildChartTab()
        ],
      ),
    );
  }
}
