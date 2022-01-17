FROM openjdk:11 as build

COPY mvnw .
COPY .mvn .mvn
COPY pom.xml .
COPY src src

RUN chmod +x ./mvnw && ./mvnw clean install

FROM openjdk:11

ENV JAVA_OPTS='-Xmx768m' \
    HEALTHCHECK_URL=http://localhost:8080/actuator/health

EXPOSE 8080

COPY --from=build /target/camunda-config-server-ready-*.jar /camunda-config-server-ready.jar

CMD java -jar /camunda-config-server-ready.jar

HEALTHCHECK --interval=10s --timeout=3s CMD wget --no-verbose --tries=1 --spider $HEALTHCHECK_URL || exit 1
