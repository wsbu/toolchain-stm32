FROM ubuntu:18.04

ENV DEBIAN_FRONTEND=noninteractive \
    INSTALL_PATH=/opt/TrueSTUDIO \
    ARCHIVE_NAME=Atollic_TrueSTUDIO_for_STM32_linux_x86_64_v9.2.0_20181203-0921.tar.gz \
    HOME=/home/captain
ENV ECLIPSE_EXE="${INSTALL_PATH}/ide/TrueSTUDIO"

RUN apt-get update
RUN apt-get install --yes \
        libc6-i386 \
        make \
        sudo \
        wget


#  && tar --directory="${INSTALL_PATH}/plugins/fr.ac6.mcu.externaltools.arm-none.linux64_1.16.0.201807130628/tools/compiler" \
#    --strip-components=1 -xf "/opt/SystemWorkbench/plugins/fr.ac6.mcu.externaltools.arm-none.linux64_1.16.0.201807130628/tools/st-gnu-arm-gcc-7-2017-q4-major_gdb-5_4-2016q3-linux.tar.bz2" \

RUN cd /tmp \
   && wget --quiet -O- "http://download.atollic.com/TrueSTUDIO/installers/${ARCHIVE_NAME}" | tar -xz

RUN mkdir "${INSTALL_PATH}" \
  && tar -xzf /tmp/Atollic_TrueSTUDIO_for_STM32_9.2.0_installer/install.data -C "${INSTALL_PATH}" \
  && groupadd --gid 1000 captain \
  && useradd --home-dir "${HOME}" --uid 1000 --gid 1000 --create-home captain \
  && cp /root/.bashrc /root/.profile "${HOME}" \
  && chown --recursive captain:captain "${HOME}" \
  && chmod --recursive 777 "${HOME}" \
  && echo "ALL ALL=NOPASSWD: ALL" >> /etc/sudoers \
  && chown captain:captain "${INSTALL_PATH}/ide" -R

COPY start.sh "/usr/local/bin/start.sh"
RUN chmod +x "/usr/local/bin/start.sh"
ENTRYPOINT ["/usr/local/bin/start.sh"]
