import 'package:flutter/material.dart';
import 'package:flutter_crud_with_api/data/datasource/lagu_remote_datasource.dart';
import 'package:flutter_crud_with_api/data/models/lagu_response_model.dart';
import 'package:flutter_crud_with_api/pages/add_lagu.dart';
import 'package:flutter_crud_with_api/pages/detail_lagu_page.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // late Future<LaguResponseModel> playlist;
  final PagingController<int, Lagu> _pagingController =
      PagingController(firstPageKey: 1);

  Future<void> _fetchPage(int pageKey) async {
    try {
      final newItems = await LaguRemoteDataSource().getLaguWithPage(pageKey);
      final isLastPage = newItems.data.currentPage == newItems.data.lastPage;
      if (isLastPage) {
        _pagingController.appendLastPage(newItems.data.data);
      } else {
        _pagingController.appendPage(newItems.data.data, ++pageKey);
      }
    } catch (error) {
      _pagingController.error = error;
    }
  }

  @override
  void initState() {
    // playlist = LaguRemoteDataSource().getLagu();
    _pagingController.addPageRequestListener(
      (pageKey) {
        _fetchPage(pageKey);
      },
    );
    super.initState();
  }

  Future<void> _refreshPage() async {
    _pagingController.refresh();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lirik Lagu'),
      ),
      body: PagedListView<int, Lagu>(
        pagingController: _pagingController,
        builderDelegate: PagedChildBuilderDelegate<Lagu>(
          itemBuilder: (context, item, index) {
            return InkWell(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(
                  builder: (context) {
                    return DetailLaguPage(
                      lagu: item,
                    );
                  },
                ));
              },
              child: Card(
                color: Colors.deepPurple[100],
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0),
                  side: const BorderSide(color: Colors.black, width: 1.0),
                ),
                elevation: 0,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      vertical: 12.0, horizontal: 24.0),
                  width: MediaQuery.of(context).size.width,
                  decoration: const BoxDecoration(
                      border: Border(
                        top: BorderSide(color: Colors.black, width: 1.0),
                        left: BorderSide(color: Colors.black, width: 1.0),
                        right: BorderSide(color: Colors.black, width: 3.0),
                        bottom: BorderSide(color: Colors.black, width: 3.0),
                      ),
                      borderRadius: BorderRadius.all(Radius.circular(12.0))),
                  child: Row(
                    children: [
                      CircleAvatar(
                        backgroundColor: Colors.deepPurple,
                        backgroundImage: NetworkImage(
                            '${LaguRemoteDataSource.imageUrl}/${item.imageUrl}'),
                      ),
                      const SizedBox(
                        width: 10.0,
                      ),
                      Text(item.judul),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) {
                return AddLaguPage();
              },
            ),
          );
          await _refreshPage();
        },
        backgroundColor: Colors.deepPurple,
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }
}
