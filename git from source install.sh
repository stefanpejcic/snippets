git from source installapt-get install dh-autoreconf libcurl4-gnutls-dev libexpat1-dev gettext libz-dev libssl-dev
apt-get install asciidoc xmlto docbook2x
ln -s /usr/bin/db2x_docbook2texi /usr/bin/docbook2x-texi

wget https://mirrors.edge.kernel.org/pub/software/scm/git/git-2.9.5.tar.gz
tar -xf git-2.9.5.tar.gz
cd git-2.9.5
make configure
./configure --prefix=/opt/git
make all doc info
make prefix=/opt/git install install-doc install-html install-info

cat >> /etc/profile << EOF export GIT_HOME=/opt/git export PATH=${GIT_HOME}/bin:${PATH} EOF ource /etc/profile git --version also cant get update: git clone git://git.kernel.org/pub/scm/git/git.git
