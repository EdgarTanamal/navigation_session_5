import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'screens.dart';
import 'screen_manager.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ScreenManager()),
        Provider<List<String>>(
          create: (context) {
            final screenManager = Provider.of<ScreenManager>(context, listen: false);
            return screenManager.generateRoutes();
          },
        ),
      ],
      child: MaterialApp(
        home: DynamicRouteScreen(),
        onGenerateRoute: (settings) {
          if (settings.name != null && settings.name!.startsWith('/screen_')) {
            return PageRouteBuilder(
              pageBuilder: (context, animation, secondaryAnimation) {
                final screenNumber = int.parse(settings.name!.split('_')[1]);
                return DynamicGeneratedScreen(screenNumber);
              },
              transitionsBuilder: (context, animation, secondaryAnimation, child) {
                const begin = Offset(1.0, 0.0);
                const end = Offset.zero;
                const curve = Curves.easeInOut;
                var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
                var offsetAnimation = animation.drive(tween);
                return SlideTransition(position: offsetAnimation, child: child);
              },
            );
          }
          // Handle non-existent routes by navigating to the default route
          return MaterialPageRoute(builder: (context) => DynamicRouteScreen());
        },
      ),
    );
  }
}


class DynamicGeneratedScreen extends StatelessWidget {
  final int screenNumber;

  DynamicGeneratedScreen(this.screenNumber);

  @override
  Widget build(BuildContext context) {
    final screenManager = Provider.of<ScreenManager>(context);
    final generatedRoutes = screenManager.generateRoutes();

    return Scaffold(
      appBar: AppBar(
        title: Text('Generated Screen $screenNumber'),
      ),
      body: Center(
        child: Text('Content of Generated Screen $screenNumber'),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: generatedRoutes.map((routeName) {
          final index = int.parse(routeName.split('_')[1]) - 1;
          return BottomNavigationBarItem(
            icon: Icon(Icons.screen_rotation),
            label: 'Screen ${index + 1}',
          );
        }).toList(),
        currentIndex: screenNumber - 1,
        onTap: (index) {
          final routeName = generatedRoutes[index];
          if (routeName.isNotEmpty) {
            Navigator.of(context).pushNamed(routeName);
          } else {
            // Show a CustomErrorDialog if the route name is empty
            showDialog(
              context: context,
              builder: (context) => CustomErrorDialog('Route not found'),
            );
          }
        },
      ),
    );
  }
}

class CustomErrorDialog extends StatelessWidget {
  final String message;

  CustomErrorDialog(this.message);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Error'),
      content: Text(message),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(); // Close the dialog
          },
          child: Text('OK'),
        ),
      ],
    );
  }
}

void main() {
  runApp(MyApp());
}
