CXX ?= g++

GoveeBTTempLogger/usr/local/bin/goveebttemplogger: goveebttemplogger.cpp
	mkdir -p $(shell dirname $@)
	$(CXX) -Wno-psabi -O3 -std=c++11 $? -o$@ -lbluetooth -lpaho-mqtt3c -lpaho-mqttpp3

deb: GoveeBTTempLogger/usr/local/bin/goveebttemplogger GoveeBTTempLogger/DEBIAN/control GoveeBTTempLogger/usr/local/lib/systemd/system/goveebttemplogger.service
	# Set architecture for the resulting .deb to the actually built architecture
	sed -i "s/Architecture: .*/Architecture: $(shell dpkg --print-architecture)/" GoveeBTTempLogger/DEBIAN/control
	chmod a+x GoveeBTTempLogger/DEBIAN/postinst GoveeBTTempLogger/DEBIAN/postrm GoveeBTTempLogger/DEBIAN/prerm
	dpkg-deb --build GoveeBTTempLogger

install-deb: deb
	apt install ./GoveeBTTempLogger.deb

clean:
	-rm -rf GoveeBTTempLogger/usr/local/bin
	-rm -f GoveeBTTempLogger.deb

.PHONY: clean deb install-deb
