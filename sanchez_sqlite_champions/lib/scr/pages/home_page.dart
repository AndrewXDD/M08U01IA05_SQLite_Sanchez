import 'package:sanchez_sqlite_champions/scr/providers/db_providers.dart';
import 'package:sanchez_sqlite_champions/scr/providers/champions_api_provider.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sanchez API/SQLITE'),
        centerTitle: true,
        actions: <Widget>[
          Container(
            padding: const EdgeInsets.only(right: 10.0),
            child: IconButton(
              icon: const Icon(Icons.settings_input_antenna),
              onPressed: () async {
                await _loadFromApi();
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.only(right: 10.0),
            child: IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () async {
                await _deleteData();
              },
            ),
          ),
        ],
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : _buildChampionsListView(),
    );
  }

  _loadFromApi() async {
    setState(() {
      isLoading = true;
    });

    var apiProvider = ChampionsApiProvider();
    await apiProvider.getAllChampions();

    // Esperar 2 segons per simular la carrega de les dades
    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      isLoading = false;
    });
  }

  _deleteData() async {
    setState(() {
      isLoading = true;
    });

    await DBProvider.db.deleteAllChampions();

    // Esperar 1 segon per simular la carrega de les dades
    await Future.delayed(const Duration(seconds: 1));

    setState(() {
      isLoading = false;
    });

    // ignore: avoid_print
    print('All Champions deleted');
  }

  _buildChampionsListView() {
    return FutureBuilder(
      future: DBProvider.db.getAllChampions(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (!snapshot.hasData) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else {
          return ListView.separated(
            separatorBuilder: (context, index) => const Divider(
              color: Colors.black12,
            ),
            itemCount: snapshot.data.length,
            itemBuilder: (BuildContext context, int index) {
              return ListTile(
                leading: Text(
                  "${index + 1}",
                  style: const TextStyle(fontSize: 20.0),
                ),
                title: Text("Nombre: ${snapshot.data[index].nom}"),
                subtitle: Text('${snapshot.data[index].description}'),
              );
            },
          );
        }
      },
    );
  }
}
