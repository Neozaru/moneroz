FROM base/archlinux


RUN pacman --noconfirm -Syu
RUN pacman --noconfirm -S git base-devel archiso sudo
RUN pacman --noconfirm -S cmake qt5-tools boost boost-libs miniupnpc zeromq unbound libunwind qt5-declarative qt5-graphicaleffects qt5-location qt5-quickcontrols qt5-webchannel qt5-webengine qt5-x11extras qt5-xmlpatterns

RUN useradd -m -p "" -g users -G "adm,wheel" -s /usr/bin/bash builduser
RUN printf 'builduser ALL=(ALL) ALL\n' | tee -a /etc/sudoers

USER builduser
WORKDIR /home/builduser
ADD . ./
RUN sudo chown -R builduser ./{repository,*-packager}

CMD ["make"]
