FROM swift:3.1

RUN apt-get update
RUN apt-get install -y ruby-full lsb-release clang libicu-dev
