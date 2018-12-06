#! /bin/bash
yum -y install epel-release
yum -y groupinstall "Development Tools"
yum -y install wget git gcc gcc-c++ qt-devel boost-devel openssl-devel qt5-qtbase-devel qt5-linguist
wget https://github.com/arvidn/libtorrent/releases/download/libtorrent-1_1_6/libtorrent-rasterbar-1.1.6.tar.gz
tar -zxf libtorrent-rasterbar-1.1.6.tar.gz
cd libtorrent-rasterbar-1.1.6
./configure --prefix=/usr CXXFLAGS=-std=c++11
make
make install
ln -s /usr/lib/pkgconfig/libtorrent-rasterbar.pc /usr/lib64/pkgconfig/libtorrent-rasterbar.pc
ln -s /usr/lib/libtorrent-rasterbar.so.9 /usr/lib64/libtorrent-rasterbar.so.9
cd ..
git clone https://github.com/qbittorrent/qBittorrent.git
cd qBittorrent
./configure --prefix=/usr --disable-gui CPPFLAGS=-I/usr/include/qt5 CXXFLAGS=-std=c++11
make
make install
systemctl stop firewalld.service
systemctl disable firewalld.service
qbittorrent-nox
cat <<EOF | sudo tee /usr/lib/systemd/system/qbittorrent.service
[Unit]
Description=qbittorrent torrent server
    
[Service]
User=root
ExecStart=/usr/bin/qbittorrent-nox
Restart=on-abort
    
[Install]
WantedBy=multi-user.targe
EOF

systemctl daemon-reload
systemctl restart qbittorrent
systemctl enable qbittorrent
