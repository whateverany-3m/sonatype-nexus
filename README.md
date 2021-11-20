# sonatype-nexus

## Usage
To run in a terminal:
```bash
docker run -p 8081:8081 -v ~/.nexus-data:/nexus-data ghcr.io/whateverany-3m/3m-sonatype/sonatype-nexus:0.0.0
```

First ever run may require:
```bash
mkdir ~/.nexus-data
sudo chown 200 ~/.nexus-data
```

## REPO_URL Variable
Most things tried just work with this:
`REPO_URL=http://admin:admin123@host.docker.internal:8081/repository`

Note - The first run will run `/scripts/init.sh` which deletes the stock repository, runs scripts to create
       repos in $NEXUS_SCRIPTS and automagically creates repository groups.

## NEXUS_SCRIPTS
Is # separated list of groovy commands to run.

## TODO
* Automate deactivation of  annoying log messages for admin/system/capabilities/Outreach:Management
* Fix anonymous access.
* More testing - docker, pypi, rubygem, etc.
* Document/test `/nexus-data` maintainance/recovery/duplication procecdures.
