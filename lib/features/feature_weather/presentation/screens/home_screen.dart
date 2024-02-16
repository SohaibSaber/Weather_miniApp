import 'package:clean_architecture/core/widgets/app_background.dart';
import 'package:clean_architecture/core/widgets/dot_loading_widget.dart';
import 'package:clean_architecture/features/feature_weather/domain/entities/current_city_entity.dart';
import 'package:clean_architecture/features/feature_weather/domain/entities/forecast_days_entity.dart';
import 'package:clean_architecture/features/feature_weather/domain/use_cases/get_suggestion_city_usecase.dart';
import 'package:clean_architecture/features/feature_weather/presentation/bloc/fw_status.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

import '../../../../core/params/forecast_params.dart';
import '../../../../core/utils/date_converter.dart';
import '../../../../locator.dart';
import '../../../feature_bookmark/presentation/bloc/bookmark_bloc.dart';
import '../../data/models/forecast_model.dart';
import '../../data/models/suggest_city_model.dart';
import '../bloc/cw_status.dart';
import '../bloc/home_bloc.dart';
import '../widgets/bookmark_icon.dart';
import '../widgets/days_weather_view.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>  with AutomaticKeepAliveClientMixin{

  TextEditingController textEditingController = TextEditingController();

  GetSuggestionCityUseCase getSuggestionCityUseCase = GetSuggestionCityUseCase(
      locator());
  final String cityName = "Herat";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    BlocProvider.of<HomeBloc>(context).add(LoadCwEvent(cityName));
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery
        .of(context)
        .size
        .height;
    final width = MediaQuery
        .of(context)
        .size
        .width;

    return SafeArea(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(height: height * 0.02,),
          Padding(
            padding:  EdgeInsets.symmetric(horizontal: width * 0.03),
            child: Row(
              children: [
                Expanded(
                  child: TypeAheadField(
                    textFieldConfiguration: TextFieldConfiguration(
                      onSubmitted: (value) {
                        textEditingController.text = value;
                        BlocProvider.of<HomeBloc>(context).add(LoadCwEvent(value));
                      },
                      controller: textEditingController,
                      style: DefaultTextStyle.of(context).style.copyWith(
                        fontSize: 20,
                        color: Colors.white
                      ),
                      decoration: const InputDecoration (
                        contentPadding: EdgeInsets.only(left: 20),
                        hintText: "Enter City...",
                        hintStyle: TextStyle(
                          color: Colors.white,
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.white
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Colors.white
                          ),
                        ),
                      )
                    ),
                      suggestionsCallback: (prefix) {
                        return getSuggestionCityUseCase(prefix);
                      },
                      itemBuilder: (context, Data itemData) {
                          return ListTile(
                            leading: const Icon(Icons.location_pin),
                            title: Text(itemData.name!),

                          );
                      },
                      onSuggestionSelected: (Data itemData) {
                        textEditingController.text = itemData.name!;
                        BlocProvider.of<HomeBloc>(context).add(LoadCwEvent(itemData.name!));
                      },),
                ),
                const SizedBox(width: 10,),

                BlocBuilder<HomeBloc, HomeState>(
                    buildWhen: (previous, current){
                      if(previous.cwStatus == current.cwStatus){
                        return false;
                      }
                      return true;
                    },
                    builder: (context, state){
                      /// show Loading State for Cw
                      if (state.cwStatus is CwLoading) {
                        return const CircularProgressIndicator();
                      }

                      /// show Error State for Cw
                      if (state.cwStatus is CwError) {
                        return IconButton(
                          onPressed: (){
                            // ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            //   content: Text("please load a city!"),
                            //   behavior: SnackBarBehavior.floating, // Add this line
                            // ));
                          },
                          icon: const Icon(Icons.error,color: Colors.white,size: 35),);
                      }

                      if(state.cwStatus is CwCompleted){
                        final CwCompleted cwComplete = state.cwStatus as CwCompleted;
                        BlocProvider.of<BookmarkBloc>(context).add(GetCityByNameEvent(cwComplete.currentCityEntity.name!));
                        return BookMarkIcon(name: cwComplete.currentCityEntity.name!);
                      }

                      return Container();

                    }
                ),

              ],
            ),
          ),

          //Main UI
          BlocBuilder<HomeBloc, HomeState>(buildWhen: (previous, current) {
            if (previous.cwStatus == current.cwStatus) {
              return false;
            }
            return true;
          }, builder: (context, state) {
            if (state.cwStatus is CwLoading) {
              return const Expanded(child: DotLoadingWidget());
            }

            if (state.cwStatus is CwCompleted) {
              final CwCompleted cwCompleted = state.cwStatus as CwCompleted;

              final CurrentCityEntity currentCityEntity =
                  cwCompleted.currentCityEntity;

              /// create params for api call
              final ForecastParams forecastParams = ForecastParams(
                  currentCityEntity.coord!.lat!, currentCityEntity.coord!.lon!);

              /// start load Fw event
              BlocProvider.of<HomeBloc>(context)
                  .add(LoadFwEvent(forecastParams));

              /// change Times to Hour --5:55 AM/PM----
              final sunrise = DateConverter.changeDtToDateTimeHour(currentCityEntity.sys!.sunrise,currentCityEntity.timezone);
              final sunset =  DateConverter.changeDtToDateTimeHour(currentCityEntity.sys!.sunset,currentCityEntity.timezone);

              return Expanded(
                  child: ListView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    children: [
                      Padding(
                        padding: EdgeInsets.only(top: height * 0.001),
                        child: SizedBox(
                          width: width,
                          height: 400,
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(top: 50),
                                child: Text(
                                  currentCityEntity.name!,
                                  style: const TextStyle(
                                      color: Colors.white, fontSize: 30),
                                ),
                              ),
                              const Padding(
                                padding: EdgeInsets.only(top: 10),
                                child: Text(
                                  "Today",
                                  style: TextStyle(
                                      color: Colors.grey, fontSize: 20),
                                ),
                              ),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.only(top: 10),
                                  child: Text(
                                    currentCityEntity.weather![0]
                                        .description!,
                                    style: const TextStyle(
                                        color: Colors.grey, fontSize: 20),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.only(top: 10),
                                  child: AppBackground.setIconForMain(
                                      currentCityEntity
                                          .weather![0].description!),
                                ),
                              ),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.only(top: 20),
                                  child: Text(
                                    "${currentCityEntity.main!.temp!
                                        .round()}\u00B0",
                                    style: const TextStyle(
                                        color: Colors.white, fontSize: 50),
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              IntrinsicHeight(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment
                                      .center,
                                  children: [
                                    Column(
                                      children: [
                                        const Text(
                                          'max',
                                          style: TextStyle(
                                              color: Colors.grey,
                                              fontSize: 16),
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        Text(
                                          "${currentCityEntity.main!
                                              .tempMax!.round()}\u00B0",
                                          style: const TextStyle(
                                              fontSize: 16,
                                              color: Colors.white),
                                        )
                                      ],
                                    ),
                                    const VerticalDivider(
                                      color: Colors.white,
                                      width: 20,
                                      indent: 5,
                                      endIndent: 5,
                                      thickness: 2,
                                    ),
                                    Column(
                                      children: [
                                        const Text(
                                          'min',
                                          style: TextStyle(
                                              color: Colors.grey,
                                              fontSize: 16),
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        Text(
                                          "${currentCityEntity.main!
                                              .tempMin!.round()}\u00B0",
                                          style: const TextStyle(
                                              fontSize: 16,
                                              color: Colors.white),
                                        )
                                      ],
                                    ),
                                  ],
                                ),
                              )
                            ],
                          )
                        ),
                      ),
                      const Divider(
                        height: 15,
                        endIndent: 10,
                        indent: 10,
                        thickness: 2,
                        color: Colors.grey,
                      ),
                      SizedBox(
                        height: 100,
                        width: width,
                        child: Center(
                          child: BlocBuilder<HomeBloc, HomeState>(
                            builder: (context, state) {
                              if (state.fwStatus is FwLoading) {
                                return const DotLoadingWidget();
                              }

                              if (state.fwStatus is FwCompleted) {
                                final FwCompleted fwCompleted =
                                state.fwStatus as FwCompleted;
                                ForecastDaysEntity forecastDaysEntity =
                                    fwCompleted.forecastDaysEntity;

                                final List<
                                    Datalist> mainData = forecastDaysEntity
                                    .datalist!;

                                // Filter data to get only one data point per day
                                final List<
                                    Datalist> dailyData = filterDailyData(
                                    mainData);

                                return ListView.builder(
                                  shrinkWrap: true,
                                  scrollDirection: Axis.horizontal,
                                  itemCount: dailyData.length,
                                  itemBuilder: (BuildContext context,
                                      int index,) {
                                    return DaysWeatherView(
                                      datalist: dailyData[index],);
                                  },);
                              }
                              if (state.fwStatus is FwError) {
                                final FwError fwError =
                                state.fwStatus as FwError;
                                return Center(
                                  child: Text(
                                    fwError.message!, style: const TextStyle(
                                      color: Colors.white
                                  ),),
                                );
                              }

                              /// show Default State for Fw
                              return Container();
                            },
                          ),
                        ),
                      ),
                      const Divider(
                        height: 5,
                        endIndent: 10,
                        indent: 10,
                        thickness: 2,
                        color: Colors.grey,
                      ),
                      const SizedBox(height: 20,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Column(
                            children: [
                              Text("wind speed",
                                style: TextStyle(
                                  fontSize: height * 0.017, color: Colors.amber,),),
                              Padding(
                                padding: const EdgeInsets.only(top: 10.0),
                                child: Text(
                                  "${currentCityEntity.wind!.speed!} m/s",
                                  style: TextStyle(
                                    fontSize: height * 0.016,
                                    color: Colors.white,),),
                              ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 10),
                            child: Container(
                              color: Colors.white24,
                              height: 30,
                              width: 2,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 10.0),
                            child: Column(
                              children: [
                                Text("sunrise",
                                  style: TextStyle(
                                    fontSize: height * 0.017,
                                    color: Colors.amber,),),
                                Padding(
                                  padding:
                                  const EdgeInsets.only(top: 10.0),
                                  child: Text(sunrise,
                                    style: TextStyle(
                                      fontSize: height * 0.016,
                                      color: Colors.white,),),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 10),
                            child: Container(
                              color: Colors.white24,
                              height: 30,
                              width: 2,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 10.0),
                            child: Column(children: [
                              Text("sunset",
                                style: TextStyle(
                                  fontSize: height * 0.017, color: Colors.amber,),),
                              Padding(
                                padding: const EdgeInsets.only(top: 10.0),
                                child: Text(sunset,
                                  style: TextStyle(
                                    fontSize: height * 0.016,
                                    color: Colors.white,),),
                              ),
                            ],),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 10),
                            child: Container(
                              color: Colors.white24,
                              height: 30,
                              width: 2,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 10.0),
                            child: Column(children: [
                              Text("humidity",
                                style: TextStyle(
                                  fontSize: height * 0.017, color: Colors.amber,),),
                              Padding(
                                padding: const EdgeInsets.only(top: 10.0),
                                child: Text(
                                  "${currentCityEntity.main!.humidity!}%",
                                  style: TextStyle(
                                    fontSize: height * 0.016,
                                    color: Colors.white,),),
                              ),
                            ],),
                          ),
                        ],),

                      const SizedBox(height: 30,),


                    ],
                  ));
            }
            if (state.cwStatus is CwError) {
              return const Expanded(
                child: Center(
                  child: Text("Check your connection or \ninputted wrong country name",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white,fontSize: 20),),
                ),
              );
            }
            return Container();
          }),
        ],
      ),
    );
  }

  List<Datalist> filterDailyData(List<Datalist> data) {
    // Extract only one data point per day (excluding the first day)
    List<Datalist> dailyData = [];
    String currentDate = "";
    bool firstDaySkipped = false;

    for (Datalist dataPoint in data) {
      String date = dataPoint.dtTxt!.split(" ")[0];

      if (!firstDaySkipped) {
        // Skip the first day
        firstDaySkipped = true;
        currentDate = date;
        continue;
      }

      if (date != currentDate) {
        dailyData.add(dataPoint);
        currentDate = date;
      }
    }

    return dailyData;
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;

}
