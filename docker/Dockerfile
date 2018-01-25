FROM base/archlinux


RUN pacman --noconfirm -Syu
RUN pacman --noconfirm -S base-devel git
RUN pacman --noconfirm -S cmake gtest qt5-tools boost boost-libs miniupnpc zeromq unbound libunwind
RUN pacman -S --needed --noconfirm sudo

RUN useradd builduser -m
RUN passwd -d builduser
RUN printf 'builduser ALL=(ALL) ALL\n' | tee -a /etc/sudoers

USER builduser
WORKDIR /home/builduser

RUN git clone https://github.com/Neozaru/moneroz --recursive

WORKDIR /home/builduser/moneroz

RUN git config --global user.name "builduser"
RUN git config --global user.email "builduser@root"

CMD ["make"]
