import 'package:http/http.dart' as http;

import 'package:flutter_crud_with_api/data/models/lagu_response_model.dart';
import 'package:image_picker/image_picker.dart';

class LaguRemoteDataSource {
  static String baseUrl = 'http://192.168.1.11:8000/api';
  static String imageUrl = 'http://192.168.1.11:8000/storage/images';

  //getlagudaerah
  Future<LaguResponseModel> getLagu() async {
    final response = await http.get(Uri.parse('$baseUrl/lagudaerah'));
    if (response.statusCode == 200) {
      return LaguResponseModel.fromJson(response.body);
    } else {
      throw Exception('Failed to load data');
    }
  }

  //getlagu with page
  Future<LaguResponseModel> getLaguWithPage(int page) async {
    final response =
        await http.get(Uri.parse('$baseUrl/lagudaerah?page=$page'));
    if (response.statusCode == 200) {
      return LaguResponseModel.fromJson(response.body);
    } else {
      throw Exception('Failed to load data');
    }
  }

  Future<void> addLaguDaerah(
      String judul, String lagu, String daerah, XFile image) async {
    // final response = await http.post(
    //   Uri.parse('http://192.168.1.11:8000/api/lagudaerah'),
    //   headers: <String, String>{
    //     'Content-Type': 'application/json',
    //   },
    //   body: jsonEncode({
    //     'judul': judul,
    //     'lagu': lagu,
    //     'daerah': daerah,
    //   }),
    // );
    var request = http.MultipartRequest(
      'POST',
      Uri.parse('http://192.168.1.11:8000/api/lagudaerah'),
    );

    request.files.add(await http.MultipartFile.fromPath('image', image.path));
    request.fields.addAll({
      'judul': judul,
      'lagu': lagu,
      'daerah': daerah,
    });
    request.headers.addAll(
      {
        'Content-Type': 'application/json',
      },
    );

    http.StreamedResponse response = await request.send();

    if (response.statusCode != 201) {
      throw Exception('Failed to add data');
    }
  }

  //update lagu
  Future<void> updateLaguDaerah(
      int id, String judul, String lagu, String daerah, XFile image) async {
    var request = http.MultipartRequest(
        'POST', Uri.parse('http://192.168.1.11:8000/api/lagudaerah/$id'));

    request.files.add(await http.MultipartFile.fromPath('image', image.path));
    request.fields.addAll({'judul': judul, 'lagu': lagu, 'daerah': daerah});
    request.headers.addAll({
      'Content-Type': 'application/json',
    });
    // final response = await http.put(
    //   Uri.parse('http://192.168.1.11:8000/api/lagudaerah/$id'),
    //   headers: <String, String>{
    //     'Content-Type': 'application/json',
    //   },
    //   body: jsonEncode({
    //     'judul': judul,
    //     'lagu': lagu,
    //     'daerah': daerah,
    //   }),
    // );
    http.StreamedResponse response = await request.send();
    if (response.statusCode != 200) {
      throw Exception('Failed to update data');
    }
  }

  //delete lagu
  Future<void> deleteLaguDaerah(int id) async {
    final response = await http.delete(
      Uri.parse('http://192.168.1.11:8000/api/lagudaerah/$id'),
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to delete data');
    }
  }
}
