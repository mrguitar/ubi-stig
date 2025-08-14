FROM registry.access.redhat.com/ubi9/ubi

ADD ubi-stig.sh /

RUN ./ubi-stig.sh && rm -f /ubi-stig.sh
