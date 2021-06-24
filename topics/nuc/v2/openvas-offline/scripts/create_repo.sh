
yum install wget net-tools texlive-changepage texlive-titlesec perl-Tk perl-sub-Exporter lzma perl-Digest-MD5 --downloadonly --downloaddir=/var/www/html/general_mirror/atomic/RPMS
mkdir -p /usr/share/texlive/texmf-local/tex/latex/comment
wget -P /usr/share/texlive/texmf-local/tex/latex/comment http://mirror.utexas.edu/ctan/macros/latex/contrib/comment/community.sty
wget -q -O - https://updates.atomicorp.com/installers/atomic | sh
yum install openvas --downloadonly --downloaddir=/var/www/html/general_mirror/atomic/RPMS
:
REPO_FOLDER=general_mirror
REPO_ITEMS=atomic

REPOPATH="/var/www/html/"
REPOFILE="${REPOPATH}/${REPO_FOLDER}/atomic_local.repo"

mkdir -p $REPOPATH
rm $REPOFILE 2> /dev/null
touch $REPOFILE

echo "${REPOPATH}${REPO_FOLDER}"

for i in $(echo $REPO_ITEMS | sed "s/,/ /g")
do
    reposync -n -l --repoid=$i --download_path=/var/www/html/general_mirror/ --download-metadata
    wait

    createrepo -v /var/www/html/general_mirror/$i
    wait
done

for DIR in `find ${REPOPATH}/general_mirror/ -maxdepth 1 -mindepth 1 -type d`; do
    REPO_ITEM=$(basename $DIR)
    if [[ "${REPO_ITEMS}" =~ "${REPO_ITEM}" ]]; then
       echo -e "[${REPO_ITEM}]" >> $REPOFILE
       echo -e "name=${REPO_ITEM}" >> $REPOFILE
       echo -e "baseurl=http://[your.ip.or.url.goes.here]/general_mirror/${REPO_ITEM}/" >> $REPOFILE
       echo -e "enabled=1" >> $REPOFILE
       echo -e "gpgcheck=0" >> $REPOFILE
       echo -e "\n" >> $REPOFILE
    fi
done;
