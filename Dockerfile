FROM base/archlinux

RUN pacman --noconfirm -Sy
RUN pacman --noconfirm -S git boost

RUN git clone https://github.com/Neozaru/moneroz --recursive

WORKDIR moneroz
ENTRYPOINT ["/moneroz/buildISO.sh"]
