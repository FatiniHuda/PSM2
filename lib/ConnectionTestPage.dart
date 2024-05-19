import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ConnectionTestPage extends StatefulWidget {
  @override
  _ConnectionTestPageState createState() => _ConnectionTestPageState();
}

class _ConnectionTestPageState extends State<ConnectionTestPage> {
  String _connectionStatus = 'Connecting...';

  @override
  void initState() {
    super.initState();
    _testConnection();
  }

  Future<void> _testConnection() async {
    try {
      final response = await http.get(Uri.parse('your_php_api_endpoint'));
      if (response.statusCode == 200) {
        setState(() {
          _connectionStatus = 'Connection Successful';
        });
      } else {
        setState(() {
          _connectionStatus = 'Failed to connect';
        });
      }
    } catch (e) {
      setState(() {
        _connectionStatus = 'Error: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Connection Test'),
      ),
      body: Center(
        child: Text(_connectionStatus),
      ),
    );
  }
}
