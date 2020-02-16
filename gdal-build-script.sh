
# Modify these as needed
GEOS_VERSION=3.6.4
GDAL_VERSION=2.4.4
PROJ4_VERSION=5.2.0

sudo yum -y update
sudo yum-config-manager --enable epel
sudo yum -y install make automake gcc gcc-c++ libcurl-devel proj-devel geos-devel s3cmd

# Compilation work for geos.
mkdir -p "/tmp/geos-${GEOS_VERSION}-build"
cd "/tmp/geos-${GEOS_VERSION}-build"
curl -o "geos-${GEOS_VERSION}.tar.bz2" \
    "http://download.osgeo.org/geos/geos-${GEOS_VERSION}.tar.bz2" \
    && bunzip2 "geos-${GEOS_VERSION}.tar.bz2" \
    && tar xvf "geos-${GEOS_VERSION}.tar"
cd "/tmp/geos-${GEOS_VERSION}-build/geos-${GEOS_VERSION}"
./configure --prefix=/usr/local/geos

# Make in parallel with 2x the number of processors.
make -j $(( 2 * $(cat /proc/cpuinfo | egrep ^processor | wc -l) )) \
 && sudo make install \
 && sudo ldconfig

# Compilation work for proj4.
mkdir -p "/tmp/proj-${PROJ4_VERSION}-build"
cd "/tmp/proj-${PROJ4_VERSION}-build"
curl -o "proj-${PROJ4_VERSION}.tar.gz" \
    "http://download.osgeo.org/proj/proj-${PROJ4_VERSION}.tar.gz" \
    && tar xfz "proj-${PROJ4_VERSION}.tar.gz"
cd "/tmp/proj-${PROJ4_VERSION}-build/proj-${PROJ4_VERSION}"
./configure --prefix=/usr/local/proj4

# Make in parallel with 2x the number of processors.
make -j $(( 2 * $(cat /proc/cpuinfo | egrep ^processor | wc -l) )) \
 && sudo make install \
 && sudo ldconfig

# Compilation work for proj4.
mkdir -p "/tmp/proj-${PROJ4_VERSION}-build"
cd "/tmp/proj-${PROJ4_VERSION}-build"
curl -o "proj-${PROJ4_VERSION}.tar.gz" \
    "http://download.osgeo.org/proj/proj-${PROJ4_VERSION}.tar.gz" \
    && tar xfz "proj-${PROJ4_VERSION}.tar.gz"
cd "/tmp/proj-${PROJ4_VERSION}-build/proj-${PROJ4_VERSION}"
./configure --prefix=/usr/local/proj4

# Make in parallel with 2x the number of processors.
make -j $(( 2 * $(cat /proc/cpuinfo | egrep ^processor | wc -l) )) \
 && sudo make install \
 && sudo ldconfig


# Bundle resources
cd /usr/local/geos
tar zcvf "/tmp/geos-${GEOS_VERSION}.tar.gz" *

cd /usr/local/proj4
tar zcvf "/tmp/proj4-${PROJ4_VERSION}.tar.gz" *

cd /usr/local/gdal
tar zcvf "/tmp/gdal-${GDAL_VERSION}.tar.gz" *

# Move them to public S3 folder
cd /tmp/
s3cmd --acl-public --force put "/tmp/geos-${GEOS_VERSION}.tar.gz" s3://##YOUR_PUBLIC_S3_URL##
s3cmd --acl-public --force put "/tmp/proj4-${PROJ4_VERSION}.tar.gz" s3://##YOUR_PUBLIC_S3_URL##
s3cmd --acl-public --force put "/tmp/gdal-${GDAL_VERSION}.tar.gz" s3://##YOUR_PUBLIC_S3_URL##
