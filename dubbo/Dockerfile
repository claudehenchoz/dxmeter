FROM maven

WORKDIR /app

RUN git clone https://github.com/apache/dubbo.git

WORKDIR /app/dubbo

RUN mvn clean install -DskipTests
