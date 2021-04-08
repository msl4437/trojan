#!sh
apk add --no-cache --virtual .build-deps build-base perl linux-headers git
wget --no-check-certificate https://github.com/openssl/openssl/archive/OpenSSL_1_1_1k.tar.gz
tar -zxf OpenSSL_1_1_1k.tar.gz
cd openssl-OpenSSL_1_1_1k
./config --openssldir=/etc/ssl enable-ec_nistp_64_gcc_128 no-ssl2 no-ssl3 no-comp no-idea no-dtls no-dtls1 no-shared no-psk no-srp no-ec2m no-weak-ssl-ciphers
make install_sw
cd ..
rm -rf OpenSSL_1_1_1k.tar.gz openssl-OpenSSL_1_1_1k

wget --no-check-certificate https://github.com/Kitware/CMake/releases/download/v3.19.8/cmake-3.19.8.tar.gz
tar -zxf cmake-3.19.8.tar.gz
cd cmake-3.19.8
./bootstrap --
make -j$(nproc) install
cd ..
rm -rf cmake-3.19.8.tar.gz cmake-3.19.8

wget --no-check-certificate https://dl.bintray.com/boostorg/release/1.72.0/source/boost_1_72_0.tar.gz
tar -zxf boost_1_72_0.tar.gz
cd boost_1_72_0
./bootstrap.sh
./b2 -j$(nproc) --with-system --with-program_options variant=release link=static threading=multi runtime-link=shared install
cd ..
rm -rf boost_1_72_0.tar.gz boost_1_72_0

wget --no-check-certificate https://github.com/mariadb-corporation/mariadb-connector-c/archive/v3.1.12.tar.gz
tar -zxf v3.1.12.tar.gz
cd mariadb-connector-c-3.1.12
echo "TARGET_LINK_LIBRARIES(libmariadb PUBLIC pthread)" >> libmariadb/CMakeLists.txt
cmake -DWITH_CURL=OFF -DWITH_DYNCOL=OFF -DWITH_MYSQLCOMPAT=ON -DWITH_UNIT_TESTS=OFF .
make -j$(nproc) install
cd ..
rm -rf v3.1.12.tar.gz mariadb-connector-c-3.1.12

git clone https://github.com/msl4437/trojan.git
cd trojan
echo 'target_link_libraries(trojan dl)' >> CMakeLists.txt
cmake -DCMAKE_CXX_FLAGS="-static" -DMYSQL_INCLUDE_DIR=/usr/local/include/mariadb -DMYSQL_LIBRARY=/usr/local/lib/mariadb/libmysqlclient.a -DDEFAULT_CONFIG=/usr/local/trojan.json -DFORCE_TCP_FASTOPEN=ON -DBoost_USE_STATIC_LIBS=ON .
make -j$(nproc)
strip -s trojan
