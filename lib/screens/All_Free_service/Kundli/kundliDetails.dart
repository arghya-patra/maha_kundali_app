import 'package:flutter/material.dart';
import 'package:maha_kundali_app/screens/All_Free_service/Kundli/kundliModel.dart';

class KundliDetailsScreen extends StatelessWidget {
  final BasicDetails basicDetails;
  final AscendantReport ascendantReport;
  final MoonSign moonSign;
  final SunSign sunSign;
  final Map<String, PlanetDetails> planetDetails;

  KundliDetailsScreen({
    required this.basicDetails,
    required this.ascendantReport,
    required this.moonSign,
    required this.sunSign,
    required this.planetDetails,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Kundali Details'),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.orange, Colors.red],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Basic Details',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              Divider(),
              _buildDetail('Name', basicDetails.name),
              _buildDetail('Date of Birth', basicDetails.dob),
              _buildDetail('Time of Birth', basicDetails.time),
              _buildDetail('City', basicDetails.city ?? 'Not Available'),
              SizedBox(height: 16.0),
              Text(
                'Ascendant Report',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              Divider(),
              _buildDetail('Ascendant', ascendantReport.ascendant),
              _buildDetail('Ascendant Lord', ascendantReport.ascendantLord),
              _buildDetail('Ascendant Lord Location',
                  ascendantReport.ascendantLordLocation),
              _buildDetail('Ascendant Lord House Location',
                  '${ascendantReport.ascendantLordHouseLocation}'),
              _buildDetail('Symbol', ascendantReport.symbol),
              _buildDetail('Lucky Gem', ascendantReport.luckyGem),
              _buildDetail('Day for Fasting', ascendantReport.dayForFasting),
              _buildDetail('Gayatri Mantra', ascendantReport.gayatriMantra),
              SizedBox(height: 16.0),
              Text(
                'Moon Sign',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              Divider(),
              _buildDetail('Moon Sign', moonSign.moonSign),
              _buildDetail('Prediction', moonSign.prediction),
              SizedBox(height: 16.0),
              Text(
                'Sun Sign',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              Divider(),
              _buildDetail('Sun Sign', sunSign.sunSign),
              _buildDetail('Prediction', sunSign.prediction),
              SizedBox(height: 16.0),
              // Text(
              //   'Planet Details',
              //   style: Theme.of(context).textTheme.headline6,
              // ),
              // Divider(),
              // ...planetDetails.values
              //     .map((planet) => _buildPlanetDetail(planet))
              //     .toList(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetail(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Expanded(
            child: Text(
              title,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: Text(value),
          ),
        ],
      ),
    );
  }

  Widget _buildPlanetDetail(PlanetDetails planet) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Card(
        elevation: 2.0,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Planet: ${planet.fullName}',
              ),
              _buildDetail('Degree (Local)', planet.localDegree.toString()),
              _buildDetail('Degree (Global)', planet.globalDegree.toString()),
              _buildDetail(
                  'Progress in Percentage', '${planet.progressInPercentage}%'),
              _buildDetail('Zodiac', planet.zodiac),
              _buildDetail('House', planet.house.toString()),
              _buildDetail('Nakshatra', planet.nakshatra),
              _buildDetail('Nakshatra Lord', planet.nakshatraLord),
              _buildDetail('Nakshatra Pada', planet.nakshatraPada.toString()),
              _buildDetail('Zodiac Lord', planet.zodiacLord),
              _buildDetail('Basic Avastha', planet.basicAvastha),
              _buildDetail('Combust', planet.isCombust ? 'Yes' : 'No'),
            ],
          ),
        ),
      ),
    );
  }
}
