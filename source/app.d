import vibe.vibe;

void main()
{
	auto settings = new HTTPServerSettings;
	settings.port = 8888;
	settings.bindAddresses = ["0.0.0.0"];
	listenHTTP(settings, &hello);
	logInfo("listening on port %s".format(settings.port));
	runApplication();
}

void hello(HTTPServerRequest req, HTTPServerResponse res)
{
	import std.datetime;
	auto currentTime = Clock.currTime();
	res.writeBody("Hello! Current time: %s".format(currentTime));
}
