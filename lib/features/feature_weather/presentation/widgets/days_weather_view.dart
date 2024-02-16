import 'package:clean_architecture/core/utils/date_converter.dart';
import 'package:clean_architecture/core/widgets/app_background.dart';
import 'package:clean_architecture/features/feature_weather/data/models/forecast_model.dart';
import 'package:flutter/material.dart';

class DaysWeatherView extends StatefulWidget {
  final Datalist datalist;

  const DaysWeatherView({
    super.key,
    required this.datalist,
  });

  @override
  State<DaysWeatherView> createState() => _DaysWeatherViewState();
}

class _DaysWeatherViewState extends State<DaysWeatherView>
    with SingleTickerProviderStateMixin {
  late AnimationController animationController;
  late Animation animation;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 300),);
    animation = Tween(
      begin: -1.0,
      end: 0.0,
    ).animate(CurvedAnimation(
        parent: animationController,
        curve: const Interval(0.5, 1, curve: Curves.decelerate),),);
    animationController.forward();
  }

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;

    String generateString() {
      String result = '';

      // Ensure weather data is not null
      if (widget.datalist.weather != null) {
        // Assuming weather data is ordered in ascending order
        int previousDay = -1;

        // Iterate through the weather data to filter one timestamp per day
        for (int i = 0; i < widget.datalist.weather!.length; i++) {
          DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(widget.datalist.dt! * 1000);
          int currentDay = dateTime.day;

          // If the day changes, add the weather information for that day
          if (currentDay != previousDay) {
            result += '${widget.datalist.weather![i]}';
            previousDay = currentDay;
          }
        }
      }

      return result;
    }

    return AnimatedBuilder(
      animation: animationController,
      builder: (context, child) {
        return Transform(
          transform:
              Matrix4.translationValues(animation.value * width, 0.0, 0.0),
          child: Padding(
            padding: const EdgeInsets.only(left: 8, right: 8),
            child: Card(
              color: Colors.transparent,
              elevation: 0,
              child: SizedBox(
                width: 50,
                height: 70,
                child: Column(
                  children: [
                    Text(
                      DateConverter.changeDtToDateTime(widget.datalist.dt),
                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 5.0),
                      child: AppBackground.setIconForMain(generateString()),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 5.0),
                        child: Text(
                          "${widget.datalist.main!.temp!.round()}\u00B0",
                          style: const TextStyle(
                              fontSize: 15, color: Colors.white,),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    animationController.dispose();
    // _fwBloc.dispose();
    // _cwBloc.dispose();
    super.dispose();
  }
}
