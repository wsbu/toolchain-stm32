FROM wsbu/toolchain-native:v0.3.6

COPY conan/stm32 "${HOME}/.conan/profiles/stm32"
RUN ln -sf stm32 "${HOME}/.conan/profiles/default"
