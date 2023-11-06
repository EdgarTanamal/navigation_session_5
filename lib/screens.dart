import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'screen_manager.dart';

class DynamicRouteScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final screenManager = Provider.of<ScreenManager>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Dynamic Routes Example'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Enter the number of screens to generate:'),
          TextField(
            onChanged: (value) {
              final number = int.tryParse(value);
              if (number != null) {
                screenManager.numberOfScreens = number;
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  //Snackbar jika angka yang dimasukkan untuk membaut screen tidak valid
                  SnackBar(
                    content: Text('Invalid input. Please enter a valid number.'),
                  ),
                );
              }
            },
          ),
          ElevatedButton(
            onPressed: () {
              if (screenManager.numberOfScreens > 0) {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => GeneratedScreens(),
                  ),
                );
              } else {
                //Snackbar untuk menampilkan text semisalnya terjadinya suatu error
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Please enter a valid number of screens.'),
                  ),
                );
              }
            },
            child: Text('Generate Screens'),
          ),
        ],
      ),
    );
  }
}

//Class untuk membuat screen yang akar diurutkan menggunakan listview
class GeneratedScreens extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final screenManager = Provider.of<ScreenManager>(context);
    final generatedRoutes = screenManager.generateRoutes();

    return Scaffold(
      appBar: AppBar(
        title: Text('Generated Screens'),
      ),
      body: ListView.builder(
        itemCount: generatedRoutes.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text('Screen ${index + 1}'),
            onTap: () {
              Navigator.of(context).pushNamed(generatedRoutes[index]);
            },
          );
        },
      ),
    );
  }
}

