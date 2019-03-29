FROM swift:4.2

RUN apt-get update
RUN apt-get install -y ruby-full lsb-release clang libicu-dev
