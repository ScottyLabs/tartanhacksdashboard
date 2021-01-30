Future<EventsList> fetchEvents() async {
  var url = 'https://thd-api.herokuapp.com/events/get';
  var body = json.encode({});
  var response = await http.post(
    url,
    headers: {
      'accept': 'application/json',
      'Content-Type': 'application/json-patch+json',
    },
    body: body,
  );

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    //print('The response body is: ${jsonDecode(response.body)}');
    print(jsonDecode(response.body));
    //return (jsonDecode(response.body));
    return EventsList.fromJson(jsonDecode(response.body));
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load events');
  }
}

class Event {
  final String name;
  final String description;
  final String timestamp;
  final String zoom_link;

  Event({this.name, this.description, this.timestamp, this.zoom_link});

  factory Event.fromJson(Map<String, dynamic> parsedJson) {
    return Event(
      name: parsedJson['name'],
      description: parsedJson['description'],
      timestamp: parsedJson['timestamp'],
      zoom_link: parsedJson['zoom_link'],
    );
  }
}

class EventsList {
  final List<Event> events;

  EventsList({
    this.events,
  });

  factory EventsList.fromJson(List<dynamic> parsedJson) {
    List<Event> events = new List<Event>();
    events = parsedJson.map((i)=>Event.fromJson(i)).toList();

    return new EventsList(
        events: events
    );
  }
}
