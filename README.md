# Visual Data and Schema Queries over Knowledge Graphs

This repository contains the supporting material and running environment for presenting the data schemas 
used by the [ViziQuer](https://github.com/LUMII-Syslab/viziquer) tool as the knowledge graphs themselves, so that
they can be presented and analyzed in the ViziQuer environment themselves, 
and can be used by other knowledge graph tools, as well.

The repository supports a demo presentation "Visual Data and Schema Queries over Knowledge Graphs" 
by Sergejs Rikačovs and Kārlis Čerāns at [EKAW'24](https://event.cwi.nl/ekaw2024/).

The software for creating a knowledge graph representation of a data schema from the ViziQuer tool database
is available in the `services/create_schema_kg` folder (with the usage instructions provided therein, as well).

The repository has been built as a fork from [ViziQuer Tools](https://github.com/LUMII-Syslab/viziquer-tools) environment that provides containers for [ViziQuer](https://github.com/LUMII-Syslab/viziquer)
and [Data Shape Server](https://github.com/LUMII-Syslab/data-shape-server) 
forming together a locally runnable visual schema and query environment. 
The ViziQuer Tools instructions (provided below in this readme instruction) apply for running the containers of
this repository, as well.

This repository provides a new initialization of the ViziQuer Tools environment 
(in the `db/init/pg` folder) with the schemas for `nobel_prizes` and `nobel_prizes_schema`
that are referred to from the paper. The considered schemas may be available on 
[ViziQuer Playground](https://viziquer.app), as well, at least for a while, however, this repository is considered to be 
the stable resource supporting the papers' presentation.

For an initial ultra-fast access to visual query environment over the 
Nobel Prizes data schema structure knowledge graph check the 
[public diagram](https://viziquer.app/public-diagram?schema=nobel_prizes_schema) 
(only visual queries available, for data schema visualization go to the full 
[ViziQuer Playground](https://viziquer.app), or run the tool locally).

The general information about the ViziQuer tool can be obtained from the [tool website](https://viziquer.lumii.lv) 
and its [GitHub repository](https://github.com/LUMII-Syslab/viziquer) (includes also the [tool wiki](https://github.com/LUMII-Syslab/viziquer/wiki)). 

# ViziQuer Tools

This repository contains scripts and initial data for starting your own copy of ViziQuer Tools as a set of interlinked containers.

This repository is just a glue + initial data; the tools themselves come from the following repositories:
- [ViziQuer](https://github.com/LUMII-Syslab/viziquer)
- [Data Shape Server](https://github.com/LUMII-Syslab/data-shape-server)
- [OBIS-SchemaExtractor](https://github.com/LUMII-Syslab/OBIS-SchemaExtractor) (to be included in a future release).

For more information on the ViziQuer tools family, please visit [viziquer.lumii.lv](https://viziquer.lumii.lv/).

## Requirements

You should have a Docker-compatible environment installed (e.g. [Docker Desktop](https://www.docker.com/products/docker-desktop/), [Podman](https://podman.io/), [OrbStack](https://orbstack.dev/), ...).

Any Linux server with Docker components installed will also be sufficient, either on cloud or on-premise.

You should have some free disk space for the data and for container images.

## Before First Start

Download this git repository, or clone it to a local directory of your choice.

Create a file `.env` as a copy of `sample.env`, and configure it to your preferences (ports, passwords, etc.)

## Start/Stop the Tools

Start the Tools by issuing the commands:

```bash
cd viziquer-tools
docker-compose up -d
```

On the first start, the required images will be pulled from registries, and the databases will be populated with starter data.

To stop the Tools, issue the command

```bash
cd viziquer-tools
docker-compose down
```

Note: Depending on your version of container tools, instead of `docker-compose ...` you may need to use `docker compose ...`.

## Using ViziQuer Tools

ViziQuer Tools are available via any modern Internet browser via addresses `http://localhost:%port%`.

The following addresses are shown assuming you used the default ports provided in `sample.env`

You can connect to the ViziQuer via `http://localhost:80`

You can connect to the pgAdmin via `http://localhost:9001`; on first start you will be asked for the password for the rdfmeta user

The DSS instance API is available via `http://localhost:9005`

The Postgres server is available at `localhost:5433`

## Populating the Data

To add a schema for another endpoint, whether public or your own, follow these two steps:

- extract the schema from the endpoint
- import the schema into ViziQuer Tools

Note: these steps will be automated in one of the next releases.

Alternatively, existing schemas (e.g., created on other servers) can be uploaded.

### Extracting the schema from the endpoint

To extract a schema from an endpoint, you should use [OBIS-SchemaExtractor](https://github.com/LUMII-Syslab/OBIS-SchemaExtractor), version 2, and follow the instructions there.

### Importing the schema into ViziQuer Tools

Once you have obtained a JSON file with the extracted schema, you need to import this JSON file into ViziQuer Tools. 

Currently, to import the schema, use the [importer module](https://github.com/LUMII-Syslab/data-shape-server/tree/main/import-generic)
from the Data Shape Server repository.

### Data schema uploading

An existing SQL database schema script (like the ones in `./db/init/pg` directory) can be executed against the database instance to create a new schema. 
Manual updates of tables `schemata` and `endpoints` in the `public` schema are needed to make this information accessible from the visual environment.

## (Re)starting from scratch

Data from the directories `./db/init/pg` and `./db/init/mongo` will be imported on first start of the system.

To restart later from scratch, remove the following directories:

- `./db/pg` to restart with a fresh DSS database content
- `./db/mongo` to restart with fresh content of ViziQuer projects database

and then restart the Tools, as in the following commands:

```bash
cd viziquer-tools
docker-compose down
rm -rf db/pg
docker-compose up -d
```

## Updating components

```bash
cd viziquer-tools
docker-compose down
docker-compose pull
docker-compose up -d
```

## Uninstalling ViziQuer Tools

Just delete the directory `./viziquer-tools` with all its subdirectories.

Note: Don't forget to export your project data before uninstalling ViziQuer Tools.
