
#Build

FROM maven as build

WORKDIR /opt/shipping

COPY pom.xml /opt/shipping/
RUN mvn dependency:resolve
COPY src /opt/shipping/src/
RUN mvn package

# this is JRE based on alpine OS
FROM openjdk:8-jre-alpine3.9
EXPOSE 8080

WORKDIR /opt/shipping

ENV CART_ENDPOINT=cart:8080
ENV DB_HOST=mysql

COPY --from=build /opt/shipping/target/shipping-1.0.jar shipping.jar
CMD [ "java", "-Xmn256m", "-Xmx768m", "-jar", "shipping.jar" ]

# 3 first run until 12 th  and build the shipping image max will get 600mb 
# then again until 23 we will run the script by using openjdk alpine os it will reduce the size
# will delete first container and build the image again will get deleted image size and new size 