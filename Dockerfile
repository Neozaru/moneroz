FROM base/archlinux

RUN pacman --noconfirm -Syu
RUN pacman --noconfirm -S git boost vim tree

RUN git clone https://github.com/Neozaru/moneroz --recursive

WORKDIR moneroz
CMD ["/moneroz/buildISO.sh"]
