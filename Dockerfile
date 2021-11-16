ARG SOURCE_GROUP
ARG SOURCE_REGISTRY
ARG SOURCE_IMAGE
ARG SOURCE_VERSION

FROM $SOURCE_REGISTRY$SOURCE_GROUP$SOURCE_IMAGE:$SOURCE_VERSION

ARG SOURCE_REPO

COPY src/rootfs/ /

SHELL ["/bin/bash", "-c"]

USER root

RUN set -x ;\
    echo "INFO: BEGIN run." ;\
    echo "INFO: SOURCE_REPO=${SOURCE_REPO}" ;\
    mkdir /etc/yum.repos.d.ORIG ;\
    mv /etc/yum.repos.d/* /etc/yum.repos.d.ORIG ;\
    echo -e "[BaseOS]\n"\
"name = BaseOS\n"\
"baseurl = ${SOURCE_REPO}/rpm/\$releasever/BaseOS/\$basearch/os\n"\
"enabled = 1\n"\
"gpgcheck = 0\n"\
"[AppStream]\n"\
"name = AppStream\n"\
"baseurl = ${SOURCE_REPO}/rpm/\$releasever/AppStream/\$basearch/os\n"\
"enabled = 1\n"\
"gpgcheck = 0\n"\
"#[Everything]\n"\
"#name = Everything\n"\
"#baseurl = ${SOURCE_REPO}/rpm/\$releasever/Everything/\$basearch\n"\
"#enabled = 1\n"\
"#gpgcheck = 0\n"\
"#[Modular]\n"\
"#name = Modular\n"\
"#baseurl = ${SOURCE_REPO}/rpm/\$releasever/Modular/\$basearch\n"\
"#enabled = 1\n"\
"#gpgcheck = 0" > "/etc/yum.repos.d/devops.repo" ;\
    yum install -y java-1.8.0-openjdk-headless-1:1.8.0.302.b08-0.el8_4.x86_64 ;\
    update-ca-trust force-enable ;\
    update-ca-trust extract ;\
    yum clean all ;\
    echo "INFO: END update and add packages"

USER nexus

ENTRYPOINT ["/entrypoint.sh"]

CMD ["sh", "-c", "${SONATYPE_DIR}/start-nexus-repository-manager.sh"]

