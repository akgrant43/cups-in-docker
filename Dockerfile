FROM phusion/baseimage

MAINTAINER Alistair Grant "akgrant@gmail.com"

# Install cups
RUN apt-get update && apt-get install cups cups-pdf whois -y
# && apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Disbale some cups backend that are unusable within a container
RUN mv /usr/lib/cups/backend/parallel /usr/lib/cups/backend-available/ && \
    mv /usr/lib/cups/backend/serial /usr/lib/cups/backend-available/
#    mv /usr/lib/cups/backend/usb /usr/lib/cups/backend-available/

ADD etc-cups /etc/cups
RUN mkdir -p /etc/cups/ssl
VOLUME /etc/cups/
VOLUME /var/log/cups
VOLUME /var/spool/cups
VOLUME /var/cache/cups

ADD etc-pam.d-cups /etc/pam.d/cups

RUN dpkg --add-architecture i386 && \
apt-get update && \
apt-get install -y libatk1.0-0 libcairo2 libfontconfig1 libglade2-0 libgtk2.0-0 libpango1.0-0 libx11-6 libxcursor1 libxext6; \
apt-get install -f && \
apt-get install -y libc6:i386 libncurses5:i386 libstdc++6:i386 && \
apt-get install -y libatk1.0-0:i386 libcairo2:i386 libgtk2.0-0:i386 libpango1.0-0:i386 libstdc++6:i386 libxml2:i386 libpopt0:i386

ADD Linux_CAPT_PrinterDriver_V270_uk_EN.tar.gz /root/

RUN cd /root/Linux_CAPT_PrinterDriver_V270_uk_EN/64-bit_Driver/Debian && \
dpkg -i cndrvcups-common_3.20-1_amd64.deb cndrvcups-capt_2.70-1_amd64.deb

EXPOSE 631

ADD start_cups.sh /etc/my_init.d/start_cups.sh
RUN chmod +x /etc/my_init.d/start_cups.sh
