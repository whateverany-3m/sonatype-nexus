# sonatype-nexus

## Usage
To run in a terminal:
```bash
mkdir ~/.nexus-data
sudo chown 200 ~/.nexus-data
docker run -p 8081:8081 -v ~/.nexus-data:/nexus-data ghcr.io/whateverany-3m/3m-sonatype/sonatype-nexus:0.0.0
```

Note - The first run will run `/scripts/init.sh` which deletes the stock repos and creates babl artifactory
proxies.

## JFROG_URL Variable
Most things tried just work with this:
`JFROG_URL=http://admin:admin123@host.docker.internal:8081/repository`

## TODO
* Better parameterise initial repositories, json, etc.
* Automate deactivation of  annoying log messages for admin/system/capabilities/Outreach:Management
* Fix anonymous access.
* More testing - docker, pypi, rubygem, etc.
* Add apk for Alpine Linux
* Document/test `/nexus-data` maintainance/recovery/duplication procecdures.

