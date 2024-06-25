import 'package:flutter/material.dart';

class PlaceCardDetail extends StatelessWidget {
  final String placeName;
  final String location;
  final String imageUrl;
  final String totalScore;
  final String humidity;
  final String temperature;
  final VoidCallback onTap;

  const PlaceCardDetail({
    Key? key,
    required this.placeName,
    required this.location,
    required this.imageUrl,
    required this.totalScore,
    required this.humidity,
    required this.temperature,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.fromLTRB(20.0, 8.0, 20.0, 8.0),
        height: 180.0,
        width: double.infinity,
        child: Stack(
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    offset: Offset(0.0, 5.0),
                    blurRadius: 10.0,
                  ),
                ],
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  ClipRRect(
                    borderRadius: BorderRadius.circular(20.0),
                    child: Container(
                      width: 180.0,
                      height: double.infinity,
                      child: Image.network(
                        imageUrl,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  SizedBox(width: 20.0),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          placeName.isNotEmpty ? placeName : 'Place Name',
                          style: TextStyle(
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                        ),
                        SizedBox(height: 12.0),
                        Text(
                          location.isNotEmpty ? location : 'Location',
                          style: TextStyle(
                            color: Colors.grey[500],
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 10.0),
                        _buildRatingStars(int.tryParse(totalScore) ?? 0),
                        SizedBox(height: 10.0),
                        Row(
                          children: <Widget>[
                            Container(
                              padding: EdgeInsets.all(5.0),
                              width: 80.0,  
                              height: 40.0, 
                              decoration: BoxDecoration(
                                color: Colors.black,  
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              alignment: Alignment.center,
                              child: Text(
                                'Humidity: $humidity%',
                                style: TextStyle(
                                  color: Colors.white, 
                                  fontSize: 10,  
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            SizedBox(width: 10.0),
                            Container(
                              padding: EdgeInsets.all(5.0),
                              width: 80.0,  
                              height: 40.0, 
                              decoration: BoxDecoration(
                                color: Colors.black,  
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              alignment: Alignment.center,
                              child: Text(
                                'Temp: $temperature°C',
                                style: TextStyle(
                                  color: Colors.white, 
                                  fontSize: 10, 
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              top: 20,
              right: 25,
              child: Icon(
                Icons.favorite,
                color: Colors.red,
                size: 30,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Text _buildRatingStars(int rating) {
    String stars = '';
    for (int i = 0; i < rating; i++) {
      stars += '⭐ ';
    }
    stars.trim();
    return Text(stars);
  }
}
