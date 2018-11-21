FROM ubuntu:18.04

ENV DEBIAN_FRONTEND=noninteractive \
    INSTALL_PATH=/opt/SystemWorkbench \
    INSTALLER_NAME=install_sw4stm32_linux_64bits-v2.7.run \
    HOME=/home/captain

RUN apt-get update
RUN apt-get install --yes \
        make \
        sudo \
        wget

RUN wget --quiet -O "/tmp/${INSTALLER_NAME}" \
        "http://www.ac6-tools.com/downloads/SW4STM32/${INSTALLER_NAME}" \
  && chmod +x /tmp/${INSTALLER_NAME} \
  && mkdir -p /etc/udev/rules.d \
  && printf "1\n 1\n1\n1\n${INSTALL_PATH}\nO\n1\nN\n1\n" | \
        "/tmp/install_sw4stm32_linux_64bits-v2.7.run" -f -c \
  && rm "/tmp/${INSTALLER_NAME}" \
  && mkdir "${INSTALL_PATH}/plugins/fr.ac6.mcu.externaltools.arm-none.linux64_1.16.0.201807130628/tools/compiler" \
  && tar --directory="${INSTALL_PATH}/plugins/fr.ac6.mcu.externaltools.arm-none.linux64_1.16.0.201807130628/tools/compiler" \
    --strip-components=1 -xf "/opt/SystemWorkbench/plugins/fr.ac6.mcu.externaltools.arm-none.linux64_1.16.0.201807130628/tools/st-gnu-arm-gcc-7-2017-q4-major_gdb-5_4-2016q3-linux.tar.bz2" \
  && groupadd --gid 1000 captain \
  && useradd --home-dir "${HOME}" --uid 1000 --gid 1000 --create-home captain \
  && cp /root/.bashrc /root/.profile "${HOME}" \
  && chown --recursive captain:captain "${HOME}" \
  && chmod --recursive 777 "${HOME}" \
  && echo "ALL ALL=NOPASSWD: ALL" >> /etc/sudoers \
  && chown captain:captain "${INSTALL_PATH}" -R

COPY eclipse-headless.sh "/usr/local/bin/eclipse-headless.sh"
RUN chmod +x "/usr/local/bin/eclipse-headless.sh"

COPY start.sh "/usr/local/bin/start.sh"
RUN chmod +x "/usr/local/bin/start.sh"
ENTRYPOINT ["/usr/local/bin/start.sh"]
