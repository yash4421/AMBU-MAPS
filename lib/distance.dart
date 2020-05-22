import 'package:maps_toolkit/maps_toolkit.dart';

class Calculatedistance {
  double meteredistance(userlatitude, userlongitude) {
    double distanceBetweenPoints = SphericalUtil.computeDistanceBetween(
        LatLng(userlatitude, userlongitude), LatLng(18.560757, 73.918210));
    return distanceBetweenPoints;
  }
}
