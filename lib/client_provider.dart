import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

ValueNotifier<GraphQLClient> clientFor({
  required String uri,
  String subscriptionUri = "",
}) {
  final HttpLink httpLink = HttpLink(
    uri,
  );
  final AuthLink authLink = AuthLink(
    getToken: () async => 'Bearer ${dotenv.env["FAUNA_KEY"]}',
  );
  Link link = authLink.concat(httpLink);
  return ValueNotifier<GraphQLClient>(
    GraphQLClient(
      cache: GraphQLCache(store: HiveStore()),
      link: link,
    ),
  );
}

/// Wraps the root application with the `graphql_flutter` client.
/// We use the cache for all state management.
class ClientProvider extends StatelessWidget {
  ClientProvider({
    required this.child,
    required String uri,
  }) : client = clientFor(
    uri: uri,
  );
  final Widget child;
  final ValueNotifier<GraphQLClient> client;
  @override
  Widget build(BuildContext context) {
    return GraphQLProvider(
      client: client,
      child: child,
    );
  }
}