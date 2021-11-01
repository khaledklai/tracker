FROM openjdk:8u131-jre

WORKDIR /app

COPY target/jarfile.jar .

CMD ["java" , "-jar" , "jarfile.jar" ]