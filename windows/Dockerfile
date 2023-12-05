FROM mstorsjo/llvm-mingw

RUN apt-get update && apt-get upgrade -y

RUN apt-get install git automake autoconf pkg-config libtool-bin -y

WORKDIR /build
COPY libgnurx-2.5 libgnurx-2.5
COPY libmagic_win.sh .
#COPY fcntl.patch .
RUN chmod +x libmagic_win.sh
