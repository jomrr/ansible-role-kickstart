cp -a /etc/dnf/dnf.conf /etc/dnf/dnf.conf.rpm

cat << EOF > /etc/dnf/dnf.conf
[main]
best=False
clean_requirements_on_remove=True
deltarpm=False
defaultyes=False
fastestmirror=True
gpgcheck=True
gpgkey_dns_verification=False
installonly_limit=3
install_weak_deps=False
keepcache=False
localpkg_gpgcheck=True
max_parallel_downloads=10
metadata_expire=3600
repo_gpgcheck=True
skip_if_unavailable=False
tsflags=nodocs
EOF
