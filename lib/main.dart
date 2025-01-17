import 'package:bloc_updated_tutorial/model/form_demo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'bloc/bloc.dart';
import 'model/weather.dart';
import 'package:bloc_updated_tutorial/bloc/form_bloc/form_state.dart' as f1;

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter SpringBoard',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: WeatherPage(),
    );
  }
}

// Since version 0.17.0, you can use a stateless widget with Bloc
class WeatherPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Fake Weather App"),
      ),
      body: SingleChildScrollView(
        child: MultiBlocProvider(
          providers: [
            BlocProvider<WeatherBloc>(
              builder: (context) => WeatherBloc(),
            ),
            BlocProvider<FormDemoBloc>(
              builder: (context) => FormDemoBloc(),
            ),
          ],
          child: WeatherPageChild(),
        ),
      ),
    );
  }
}

// Because we now don't hold a reference to the WeatherBloc directly,
// we have to get it through the BlocProvider. This is only possible from
// a widget which is a child of the BlocProvider in the widget tree.
class WeatherPageChild extends StatelessWidget {
  const WeatherPageChild({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          padding: EdgeInsets.symmetric(vertical: 16),
          alignment: Alignment.center,
          child: BlocListener(
            bloc: BlocProvider.of<FormDemoBloc>(context),
            listener: (BuildContext context, FormDemoState state) async {
              if (state is FormDemoLoaded) {
                print("Loaded: ${state.props.toString()}");
              }
            },
            // BlocBuilder invokes the builder when new state is emitted.
            child: BlocBuilder(
              bloc: BlocProvider.of<FormDemoBloc>(context),
              builder: (BuildContext context, FormDemoState state) {
                if (state is FormDemoLoaded) {
                  return (Text(
                      "Form Data: ${state.formDemo.name} : ${state.formDemo.lastName}"));
                }
              },
            ),
          ),
        ),
        Container(
          padding: EdgeInsets.symmetric(vertical: 16),
          alignment: Alignment.center,
          // BlocListener invokes the listener when new state is emitted.
          child: BlocListener(
            bloc: BlocProvider.of<WeatherBloc>(context),
            // Listener is the place for logging, showing Snackbars, navigating, etc.
            // It is guaranteed to run only once per state change.
            listener: (BuildContext context, WeatherState state) {
              if (state is WeatherLoaded) {
                print("Loaded: ${state.weather.cityName}");
              }
            },
            // BlocBuilder invokes the builder when new state is emitted.
            child: BlocBuilder(
              bloc: BlocProvider.of<WeatherBloc>(context),
              // The builder function has to be a "pure function".
              // That is, it only returns a Widget and doesn't do anything else.
              builder: (BuildContext context, WeatherState state) {
                // Changing the UI based on the current state
                if (state is WeatherInitial) {
                  return buildInitialInput();
                } else if (state is WeatherLoading) {
                  return buildLoading();
                } else if (state is WeatherLoaded) {
                  return buildColumnWithData(state.weather);
                }
              },
            ),
          ),
        )
      ],
    );
  }

  Widget buildInitialInput() {
    return Center(
      child: CityInputField(),
    );
  }

  Widget buildLoading() {
    return Center(
      child: CircularProgressIndicator(),
    );
  }

  // Builds widgets from the starter UI with custom weather data
  Column buildColumnWithData(Weather weather) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        Text(
          weather.cityName,
          style: TextStyle(
            fontSize: 40,
            fontWeight: FontWeight.w700,
          ),
        ),
        Text(
          // Display the temperature with 1 decimal place
          "${weather.temperature.toStringAsFixed(1)} °C",
          style: TextStyle(fontSize: 80),
        ),
        CityInputField(),
      ],
    );
  }
}

class CityInputField extends StatefulWidget {
  const CityInputField({
    Key key,
  }) : super(key: key);

  @override
  _CityInputFieldState createState() => _CityInputFieldState();
}

class _CityInputFieldState extends State<CityInputField> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 50),
      child: TextField(
        onSubmitted: submitCityName,
        textInputAction: TextInputAction.search,
        decoration: InputDecoration(
          hintText: "Enter a city",
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          suffixIcon: Icon(Icons.search),
        ),
      ),
    );
  }

  void submitCityName(String cityName) {
    // Get the Bloc using the BlocProvider
    final weatherBloc = BlocProvider.of<WeatherBloc>(context);
    // Initiate getting the weather
    weatherBloc.dispatch(GetWeather(cityName));
    final formDemoBloc = BlocProvider.of<FormDemoBloc>(context);
    formDemoBloc.dispatch(UpdateForm(new FormDemo(
        name: "${cityName} FirstName", lastName: "${cityName} LastName")));
  }
}
