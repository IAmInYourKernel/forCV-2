import 'package:web_socket_channel/web_socket_channel.dart';

String localAPI = "";
String remoteAPI = "";
String serverAPI = localAPI;

String localRideRequestWS = "";
String localOngoingRideWS = "";
WebSocketChannel? rideRequestChannel;
WebSocketChannel? ongoingRideChannel;
