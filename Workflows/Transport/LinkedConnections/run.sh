#!/usr/bin/env bash

# make descriptions out of linked connections
eye test2.ttl test3.ttl test4.ttl --query descriptionGenerator.n3 --nope > descriptions.n3


#make a route
eye context.n3 descriptions.n3 gps-plugin.n3 --query gps-query.n3 --nope >out.n3

