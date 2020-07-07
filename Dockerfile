FROM debian:stretch-slim

LABEL authors="Julien Neuhart <j.neuhart@thecodingmachine.com>"

# |--------------------------------------------------------------------------
# | Libraries
# |--------------------------------------------------------------------------
# |
# | Installs all required libraries.
# |

RUN echo "deb http://httpredir.debian.org/debian/ stretch main contrib non-free" > /etc/apt/sources.list &&\
    apt-get update &&\
    apt-get install -y xvfb wkhtmltopdf pdftk unoconv ttf-mscorefonts-installer &&\
    ln -s /usr/bin/xvfb-run /usr/local/bin/xvfb-run &&\
    ln -s /usr/bin/wkhtmltopdf /usr/local/bin/wkhtmltopdf &&\
    ln -s /usr/bin/pdftk /usr/local/bin/pdftk &&\
    ln -s /usr/bin/unoconv /usr/local/bin/unoconv

RUN apt-get install -y curl gnupg &&\
    curl -sL https://deb.nodesource.com/setup_8.x | bash - &&\
    apt-get update &&\
    apt-get install -y nodejs

RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - &&\
    echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list &&\
    apt-get update &&\
    apt-get install -y yarn bzip2 &&\
    yarn global add markdown-pdf --prefix /usr/local

# |--------------------------------------------------------------------------
# | Japanese characters
# |--------------------------------------------------------------------------

RUN apt-get install -Vy ttf-wqy-zenhei fonts-arphic-ukai fonts-arphic-uming    

# |--------------------------------------------------------------------------
# | Asian fonts (https://help.accusoft.com/PrizmDoc/v12.2/HTML/Installing_Asian_Fonts_on_Ubuntu_and_Debian.html)
# |--------------------------------------------------------------------------

RUN apt-get install language-pack-ja
RUN apt-get install japan*
RUN apt-get install language-pack-zh*
RUN apt-get install chinese*
RUN apt-get install language-pack-ko
RUN apt-get install korean*
RUN apt-get install fonts-arphic-ukai fonts-arphic-uming fonts-ipafont-mincho fonts-ipafont-gothic fonts-unfonts-core

# |--------------------------------------------------------------------------
# | Gotenberg
# |--------------------------------------------------------------------------
# |
# | All Gotenberg related stuff.
# |

COPY .ci/gotenberg /usr/bin/gotenberg
RUN ln -s /usr/bin/gotenberg /usr/local/bin/gotenberg

COPY .ci/gotenberg.yml /gotenberg/gotenberg.yml

WORKDIR /gotenberg

EXPOSE 3000
CMD ["gotenberg"]