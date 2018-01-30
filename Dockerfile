FROM base/archlinux


RUN pacman --noconfirm -Syu
RUN pacman --noconfirm -S git base-devel
RUN pacman --noconfirm -S cmake gtest qt5-tools boost boost-libs miniupnpc zeromq unbound libunwind
RUN pacman --noconfirm -S qt5-declarative qt5-graphicaleffects qt5-location qt5-quickcontrols qt5-webchannel qt5-webengine qt5-x11extras qt5-xmlpatterns
RUN pacman -S --needed --noconfirm sudo

RUN useradd builduser -m
RUN passwd -d builduser
RUN printf 'builduser ALL=(ALL) ALL\n' | tee -a /etc/sudoers

USER builduser
WORKDIR /home/builduser
ADD . ./
RUN sudo chown -R builduser ./{repository,*-packager}

CMD ["make"]
