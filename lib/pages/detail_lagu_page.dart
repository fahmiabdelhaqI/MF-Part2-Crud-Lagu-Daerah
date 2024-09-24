// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_crud_with_api/data/datasource/lagu_remote_datasource.dart';

import 'package:flutter_crud_with_api/data/models/lagu_response_model.dart';
import 'package:flutter_crud_with_api/pages/home_pages.dart';
import 'package:image_picker/image_picker.dart';

class DetailLaguPage extends StatefulWidget {
  final Lagu lagu;
  const DetailLaguPage({
    super.key,
    required this.lagu,
  });

  @override
  State<DetailLaguPage> createState() => _DetailLaguPageState();
}

class _DetailLaguPageState extends State<DetailLaguPage> {
  final TextEditingController judulContoller = TextEditingController();
  final TextEditingController laguController = TextEditingController();
  final TextEditingController daerahController = TextEditingController();

  XFile? image;

  @override
  void initState() {
    judulContoller.text = widget.lagu.judul;
    laguController.text = widget.lagu.lagu;
    daerahController.text = widget.lagu.daerah;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.lagu.judul),
        elevation: 2,
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              showDialog(
                barrierDismissible: false,
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: const Text('Delete Lagu'),
                    content: const Text('Apa anda yakin ?'),
                    actions: [
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text('Cancel'),
                      ),
                      ElevatedButton(
                          onPressed: () async {
                            await LaguRemoteDataSource()
                                .deleteLaguDaerah(widget.lagu.id);
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) {
                                  return const HomePage();
                                },
                              ),
                            );
                          },
                          child: const Text('OK'))
                    ],
                  );
                },
              );
            },
            icon: const Icon(Icons.delete),
          ),
          ElevatedButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) {
                  return StatefulBuilder(
                    builder: (context, setState) {
                      return AlertDialog(
                        title: const Text('Edit New Lagu'),
                        content: SingleChildScrollView(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              TextField(
                                decoration: const InputDecoration(
                                  hintText: 'judul',
                                ),
                                controller: judulContoller,
                              ),
                              TextField(
                                decoration: const InputDecoration(
                                  hintText: 'Lagu',
                                ),
                                maxLines: 4,
                                controller: laguController,
                              ),
                              TextField(
                                decoration: const InputDecoration(
                                  hintText: 'Daerah',
                                ),
                                controller: daerahController,
                              ),
                              const SizedBox(
                                height: 12,
                              ),
                              widget.lagu.imageUrl != null && image == null
                                  ? SizedBox(
                                      height: 80,
                                      child: Image.network(
                                          '${LaguRemoteDataSource.imageUrl}/${widget.lagu.imageUrl}'),
                                    )
                                  : const SizedBox(),
                              image != null
                                  ? SizedBox(
                                      height: 80,
                                      child: Image.file(File(image!.path)))
                                  : const SizedBox(),
                              //upload image
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  ElevatedButton(
                                    onPressed: () async {
                                      final ImagePicker picker = ImagePicker();

                                      image = await picker.pickImage(
                                          source: ImageSource.gallery);
                                      setState(() {});
                                    },
                                    child: const Text('Upload Image'),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: const Text('Cancel'),
                          ),
                          TextButton(
                            onPressed: () async {
                              if (image == null) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Gambar Wajib diisi'),
                                    backgroundColor: Colors.red,
                                  ),
                                );
                                return;
                              }
                              //add new lagu
                              await LaguRemoteDataSource().updateLaguDaerah(
                                widget.lagu.id,
                                judulContoller.text,
                                laguController.text,
                                daerahController.text,
                                image!,
                              );
                              judulContoller.clear();
                              laguController.clear();
                              daerahController.clear();
                              image!;
                              // await _refreshPage();
                              Navigator.pushReplacement(context,
                                  MaterialPageRoute(
                                builder: (context) {
                                  return const HomePage();
                                },
                              ));
                            },
                            child: const Text('Update'),
                          ),
                        ],
                      );
                    },
                  );
                },
              );
            },
            child: const Icon(Icons.edit),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(
            widget.lagu.judul,
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          const SizedBox(
            height: 4,
          ),
          Text(
            widget.lagu.daerah,
            textAlign: TextAlign.center,
          ),
          const SizedBox(
            height: 12,
          ),
          widget.lagu.imageUrl == null
              ? const SizedBox()
              : Image.network(
                  '${LaguRemoteDataSource.imageUrl}/${widget.lagu.imageUrl!}',
                  height: 300,
                ),
          const SizedBox(
            height: 12,
          ),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
                color: Color.fromARGB(255, 240, 230, 230),
                borderRadius: BorderRadius.all(Radius.circular(20))),
            child: Text(
              widget.lagu.lagu,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 14),
            ),
          )
        ],
      ),
    );
  }
}
