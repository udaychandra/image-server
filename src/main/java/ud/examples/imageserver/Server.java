package ud.examples.imageserver;

import io.helidon.webserver.Routing;
import io.helidon.webserver.ServerConfiguration;
import io.helidon.webserver.StaticContentSupport;
import io.helidon.webserver.WebServer;

import java.nio.file.Paths;
import java.util.logging.Logger;

public class Server {

    private static final Logger logger = Logger.getLogger(Server.class.getName());

    public static void main(String... args) {
        var contentSupport = StaticContentSupport
                .create(Paths.get("/app/images"));

        var routing = Routing.builder()
                .register("/images", contentSupport)
                .build();

        var config = ServerConfiguration.builder()
                .port(8080)
                .build();

        WebServer.create(config, routing).start();
    }
}
