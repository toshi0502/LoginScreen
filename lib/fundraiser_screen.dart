import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class FundraiserScreen extends StatefulWidget {
  @override
  _FundraiserScreenState createState() => _FundraiserScreenState();
}

class _FundraiserScreenState extends State<FundraiserScreen> {
  List<dynamic> topFundraisers = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchTopFundraisers('');
  }

  Future<void> fetchTopFundraisers(String token) async {
    String baseUrl = "https://hexeros.com/dev/fund-tool/api/V1/";
    String homeEndpoint = "home";

    String homeUrl = baseUrl + homeEndpoint;

    var headers = {
      'Authorization': 'Bearer $token',
    };

    var request = http.MultipartRequest('POST', Uri.parse(homeUrl));

    request.headers.addAll(headers);

    try {
      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        print(await response.stream.bytesToString());
      } else {
        print('Failed to load top fundraisers: ${response.reasonPhrase}');
      }
    } catch (error) {
      print("Network error: $error");
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Fundraisers'),
          bottom: TabBar(
            tabs: [
              Tab(text: 'Top Fundraisers'),
              Tab(text: 'My Fundraisers'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            isLoading
                ? Center(child: CircularProgressIndicator())
                : ListView.builder(
                    itemCount: topFundraisers.length,
                    itemBuilder: (context, index) {
                      final fundraiser = topFundraisers[index];
                      return ListTile(
                        title: Text(fundraiser['title']),
                        subtitle: Text(fundraiser['description']),
                      );
                    },
                  ),
            Center(child: Text('My Fundraisers List')),
          ],
        ),
      ),
    );
  }
}
