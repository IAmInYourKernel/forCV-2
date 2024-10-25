import 'package:web_socket_channel/web_socket_channel.dart';

String localAPI = "http://192.168.4.58:3000/";
String remoteAPI = "http://3.94.234.149:3000/";
String serverAPI = localAPI;

String localRideRequestWS = "ws://192.168.0.102:3001/";
String localOngoingRideWS = "ws://192.168.0.102:3002/";
WebSocketChannel? rideRequestChannel;
WebSocketChannel? ongoingRideChannel;
