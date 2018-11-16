# SMC
Version 1.0

# qt钱包编译步骤

编译系统要求：ubuntu14.04.4  
运行系统要求：windows10

  - apt-get install gcc g++ automake libtool build-essential autotools-dev pkg-config bsdmainutils curl git -y
  - apt install g++-mingw-w64-x86-64 -y
  - PATH=$(echo "$PATH" | sed -e 's/:\/mnt.*//g')
  - git clone https://github.com/fg12347/smc.git
  - cd smc
  - cd depends
  - make HOST=x86_64-w64-mingw32
  - cd .\.
  - ./autogen.sh
  - CONFIG_SITE=$PWD/depends/x86_64-w64-mingw32/share/config.site ./configure --prefix=/
  - make
  
# linux节点编译步骤
编译系统要求：ubuntu14.04.4
运行系统要求：ubuntu14.04.4

  - apt-get install make gcc g++ autoconf  protobuf-compiler  -y
  - apt-get install libdb-dev libdb++-dev  libboost-dev  libboost-all-dev  zlib1g-dev  libssl-dev  build-essential  libminiupnpc-dev  libevent-dev  libprotobuf-dev libzmq3-dbg libzmq3-dev libzmq3 libtool  -y
  - ./autogen.sh
  - ./configure --with-incompatible-bdb
  - make
