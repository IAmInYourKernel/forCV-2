import 'package:flutter/material.dart';
import 'package:healthka_customers/assistants/serviceAssistant.dart';
import 'package:healthka_customers/models/placePrediction.dart';
import 'package:healthka_customers/widgets/divider.dart';

class SearchLocationScreen extends StatefulWidget {
  const SearchLocationScreen({Key? key}) : super(key: key);

  @override
  State<SearchLocationScreen> createState() => _SearchLocationScreenState();
}

class _SearchLocationScreenState extends State<SearchLocationScreen> {
  TextEditingController dropTextEditingController = TextEditingController();
  List<PlacePrediction> placePredictionList = [];

  _getPlacePredictions(String placeName) async {
    List<PlacePrediction> result =
        await ServiceAssistant.getPlacePredictionsList(placeName);
    setState(() {
      placePredictionList = result;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(children: [
        Container(
            height: 150,
            decoration: const BoxDecoration(color: Colors.white, boxShadow: [
              BoxShadow(
                color: Colors.black,
                blurRadius: 6,
                spreadRadius: 0.5,
                offset: Offset(0.7, 0.7),
              )
            ]),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 20),
              child: Column(children: [
                const SizedBox(
                  height: 25,
                ),
                Stack(
                  children: [
                    GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: const Icon(Icons.arrow_back)),
                    const Center(
                      child: Text(
                        "Search Location",
                        style: TextStyle(
                          fontSize: 16,
                          fontFamily: "Brand-Regular",
                        ),
                      ),
                    )
                  ],
                ),
                const SizedBox(
                  height: 15,
                ),
                Row(
                  children: [
                    const Icon(Icons.search_rounded),
                    const SizedBox(
                      width: 18,
                    ),
                    Expanded(
                        child: Container(
                      decoration: BoxDecoration(
                          color: Colors.grey[400],
                          borderRadius: BorderRadius.circular(5)),
                      child: Padding(
                        padding: const EdgeInsets.all(3),
                        child: TextField(
                            onChanged: (val) {
                              _getPlacePredictions(val);
                            },
                            controller: dropTextEditingController,
                            autofocus: true,
                            decoration: InputDecoration(
                                hintText: "Search",
                                fillColor: Colors.grey[400],
                                filled: true,
                                border: InputBorder.none,
                                isDense: true,
                                contentPadding: const EdgeInsets.only(
                                    left: 11, top: 8, bottom: 8))),
                      ),
                    ))
                  ],
                )
              ]),
            )),

        // Prediction Tile
        (placePredictionList.isNotEmpty)
            ? Expanded(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  child: ListView.separated(
                    padding: const EdgeInsets.all(0),
                    itemBuilder: (context, index) {
                      return PredictionTile(
                          placePrediction: placePredictionList[index]);
                    },
                    separatorBuilder: (BuildContext context, int index) =>
                        const DividerWidget(),
                    itemCount: placePredictionList.length,
                    shrinkWrap: true,
                    physics: const ClampingScrollPhysics(),
                  ),
                ),
              )
            : Container(),
      ]),
    );
  }
}

class PredictionTile extends StatefulWidget {
  final PlacePrediction placePrediction;

  const PredictionTile({Key? key, required this.placePrediction})
      : super(key: key);

  @override
  State<PredictionTile> createState() => _PredictionTileState();
}

class _PredictionTileState extends State<PredictionTile> {
  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () async {
        Navigator.pop(
            context,
            await ServiceAssistant.getPlaceDetailsFromPlaceID(
                widget.placePrediction.placeID));
      },
      child: Column(
        children: [
          const SizedBox(
            width: 10,
          ),
          Row(children: [
            const Icon(
              Icons.add_location_alt_outlined,
              color: Colors.green,
            ),
            const SizedBox(
              width: 10,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 8,
                  ),
                  Text(
                    widget.placePrediction.mainText,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                        fontSize: 15, color: Color.fromARGB(255, 46, 38, 38)),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  Text(
                    widget.placePrediction.secondaryText,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 15, color: Colors.grey),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                ],
              ),
            )
          ]),
          const SizedBox(
            width: 10,
          ),
        ],
      ),
    );
  }
}
