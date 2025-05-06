import 'dart:convert';
import 'dart:io';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class UploadImageService {
  Future<String?> toImgur(File imageFile) async {
    final bytes = await imageFile.readAsBytes();
    final base64Image = base64Encode(bytes);
    final clientId = dotenv.env["IMGUR_CLIENT_ID"];

    final response = await http.post(
      Uri.parse('https://api.imgur.com/3/image'),
      headers: {'Authorization': 'Client-ID $clientId'},
      body: {'image': base64Image},
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['data']['link'];
    } else {
      print('Upload failed: ${response.body}');
      return null;
    }
  }
}
