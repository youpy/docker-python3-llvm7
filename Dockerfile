FROM python:3-alpine

RUN export BUILD_DEPS='alpine-sdk git diffutils' \
  && apk update \
  && apk add $BUILD_DEPS \
  && adduser -D apk \
  && adduser apk abuild \
  && sudo -iu apk abuild-keygen -a \
  && sudo -iu apk git clone --depth=1 -b pr-llvm-7 https://github.com/xentec/aports \
  && sudo -iu apk sh -xec 'cd aports/main/llvm7; abuild -r' \
  && cp /home/apk/.abuild/*.rsa.pub /etc/apk/keys \
  && apk add /home/apk/packages/main/$(uname -m)/*.apk \
  && deluser --remove-home apk \
  && rm -rf /var/cache/apk/APKINDEX* \
  && apk del --no-cache $BUILD_DEPS
