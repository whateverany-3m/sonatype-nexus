ARG SOURCE_GROUP
ARG SOURCE_REGISTRY
ARG SOURCE_IMAGE
ARG SOURCE_VERSION

FROM $SOURCE_REGISTRY$SOURCE_GROUP$SOURCE_IMAGE:$SOURCE_VERSION

ARG NEXUS_RPM_REPO

COPY src/rootfs/ /

SHELL ["/bin/bash", "-c"]

USER root

RUN set -x ;\
    echo "INFO: BEGIN run." ;\
    echo "INFO: NEXUS_RPM_REPO=${NEXUS_RPM_REPO}" ;\
    sed -i -e "#https://cdn-ubi.redhat.com/content/public/ubi/dist#${NEXU_RPM_REPO}#" ;\
    yum install -y \
      java-1.8.0-openjdk-headless-1:1.8.0.312.b07-2.el8_5.x86_64 \
      jq-1.5-12.el8.x86_64 \
     ;\
    update-ca-trust force-enable ;\
    update-ca-trust extract ;\
    yum clean all ;\
    echo "INFO: END update and add packages"

USER nexus

ENV NEXUS_USERNAME admin
ENV NEXUS_PASSWORD admin123
ENV NEXUS_URL http://localhost:8081
ENV NEXUS_SCRIPTS security.setAnonymousAccess(Boolean.valueOf(args))#repository.createMavenProxy(\'maven2-repo1\',\'https://repo1.maven.org/maven2\')#repository.createRepository(repository.createProxy(\'apk-alpine_main\',\'apk-proxy\',\'https://dl-cdn.alpinelinux.org/alpine/v3.14/main\'))#repository.createRepository(repository.createProxy(\'apk-alpine_community\',\'apk-proxy\',\'https://dl-cdn.alpinelinux.org/alpine/v3.14/community\'))#repository.createAptProxy(\'apt-debian\',\'https://mirror.aarnet.edu.au/debian\',\'default\',\'deb\',false)#repository.createDockerProxy(\'docker-docker\',\'https://registry-1.docker.io\',\'REGISTRY\',null,null,null,\'default\',false,false)#repository.createDockerProxy(\'docker-ghcr\',\'https://ghcr.io\',\'REGISTRY\',null,null,null,\'default\',false,false)#repository.createRawProxy(\'raw-gradle\',\'https://services.gradle.org/distributions\',\'default\',false)#repository.createGolangProxy(\'go-gonexus\',\'https://gonexus.dev/\',\'default\',false)#repository.createNpmProxy(\'npm-npm\',\'https://registry.npmjs.org\')#repository.createNugetProxy(\'nuget-nuget\',\'https://api.nuget.org/v3/index.json\',\'default\',false)#repository.createPyPiProxy(\'pypi-pypi\',\'https://pypi.org/\',\'default\',false)#repository.createYumProxy(\'yum-ubi\',\'https://cdn-ubi.redhat.com/content/public/ubi/dist\',\'default\',false)#repository.createYumProxy(\'yum-centos\',\'http://mirror.centos.org/centos/\',\'default\',false)#repository.createRubygemsProxy(\'ruby-rubygems\',\'https://rubygems.org\',\'default\',false)

ENTRYPOINT ["/entrypoint.sh"]

CMD ["sh", "-c", "${SONATYPE_DIR}/start-nexus-repository-manager.sh"]

