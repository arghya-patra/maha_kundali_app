import 'package:flutter/material.dart';
import 'package:maha_kundali_app/screens/Personal%20Horoscope/personal_horoscope_model.dart';

class HoroscopeDetailScreen extends StatelessWidget {
  final HoroscopeResponse horoscopeResponse;

  HoroscopeDetailScreen({required this.horoscopeResponse});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Horoscope Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Horoscope Overview',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              _buildOverviewTable(),
              const SizedBox(height: 20),
              const Text(
                'Planetary Details',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              _buildPlanetaryDetailsTable(),
              const SizedBox(height: 20),
              const Text(
                'Dasha Details',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              _buildDashaDetailsTable(),
            ],
          ),
        ),
      ),
    );
  }

  // Table for Horoscope Overview
  Widget _buildOverviewTable() {
    return Table(
      border: TableBorder.all(),
      columnWidths: const {
        0: FlexColumnWidth(1),
        1: FlexColumnWidth(2),
      },
      children: [
        _buildTableRow('Manglik',
            horoscopeResponse.dosha.manglikDosh.isManglik ? 'Yes' : 'No'),
        _buildTableRow('Kaalsarp Dosh',
            horoscopeResponse.dosha.kaalsarpdosh.isDoshaPresent ? 'Yes' : 'No'),
        _buildTableRow('Pitra Dosh',
            horoscopeResponse.dosha.pitradosh.isDoshaPresent ? 'Yes' : 'No'),
        _buildTableRow('Mangal Dosh',
            horoscopeResponse.dosha.mangaldosh.isDoshaPresent ? 'Yes' : 'No'),
      ],
    );
  }

  // Table for Planetary Details
  Widget _buildPlanetaryDetailsTable() {
    return Table(
      border: TableBorder.all(),
      columnWidths: const {
        0: FlexColumnWidth(1),
        1: FlexColumnWidth(2),
      },
      children: [
        TableRow(children: [
          _buildTableCell('Planet'),
          _buildTableCell('Zodiac'),
          _buildTableCell('Nakshatra'),
          _buildTableCell('House'),
        ]),
        ...horoscopeResponse.planetDetails.planets.map((planet) {
          return TableRow(children: [
            _buildTableCell(planet.name),
            _buildTableCell(planet.zodiac),
            _buildTableCell(planet.nakshatra),
            _buildTableCell(planet.house),
          ]);
        }).toList(),
      ],
    );
  }

  // Table for Dasha Details
  Widget _buildDashaDetailsTable() {
    return Table(
      border: TableBorder.all(),
      columnWidths: const {
        0: FlexColumnWidth(1),
        1: FlexColumnWidth(2),
      },
      children: [
        TableRow(children: [
          _buildTableCell('Planet'),
          _buildTableCell('Start Date'),
          _buildTableCell('End Date'),
          _buildTableCell('Prediction'),
        ]),
        ...horoscopeResponse.dasha.details.map((dashaDetail) {
          return TableRow(children: [
            _buildTableCell(dashaDetail.planet),
            _buildTableCell(dashaDetail.startDate),
            _buildTableCell(dashaDetail.endDate),
            _buildTableCell(dashaDetail.prediction),
          ]);
        }).toList(),
      ],
    );
  }

  // Utility functions to build table rows and cells
  TableRow _buildTableRow(String label, String value) {
    return TableRow(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child:
              Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(value),
        ),
      ],
    );
  }

  Widget _buildTableCell(String value) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(value),
    );
  }
}
