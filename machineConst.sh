#!/bin/bash

cd ..
cd ..
mkdir -p DataWashingMachine
echo "DataWashingMachine folder was created..."
mv Downloads/DataWashingMachine-master/machineTurnOn.sh DataWashingMachine/

# declare download URLs for OpenRefine and OpenRefine client
openrefine_URL="https://github.com/OpenRefine/OpenRefine/releases/download/3.2/openrefine-linux-3.2.tar.gz"
client_URL="https://github.com/opencultureconsulting/openrefine-client/releases/download/v0.3.4/openrefine-client_0-3-4_linux-64bit"

# check system requirements
JAVA="$(which java 2> /dev/null)"
if [ -z "$JAVA" ] ; then
    echo 1>&2 "This action requires you to have 'Java JRE' installed. You can download it for free at https://java.com"
    exit 1
fi
# check if wget supports option --show-progress (since wget 1.16)
wget --help | grep -q '\--show-progress' && wget_opt="--show-progress" || wget_opt=""

# autoinstall OpenRefine
if [ ! -d "openrefine" ]; then
    echo "Download OpenRefine..."
    cd DataWashingMachine
    mkdir -p openrefine
    wget -q $wget_opt $openrefine_URL
    echo "Install OpenRefine in subdirectory openrefine..."
    tar -xzf "$(basename $openrefine_URL)" -C openrefine --strip 1 --totals
    rm -f "$(basename $openrefine_URL)"
    sed -i '$ a JAVA_OPTIONS=-Drefine.headless=true' openrefine/refine.ini
    sed -i 's/#REFINE_AUTOSAVE_PERIOD=60/REFINE_AUTOSAVE_PERIOD=1440/' openrefine/refine.ini
    sed -i 's/-Xms$REFINE_MIN_MEMORY/-Xms$REFINE_MEMORY/' openrefine/refine
    echo ""
fi

# autoinstall OpenRefine client
if [ ! -d "openrefine-client" ]; then
    echo "Download OpenRefine client..."
    mkdir -p openrefine-client
    wget -q -P openrefine-client $wget_opt $client_URL
    chmod +x openrefine-client/openrefine-client_0-3-4_linux-64bit
    echo ""
fi


# defaults
ram="2048M"
port="3333"
restartfile="true"
restarttransform="true"
export="true"
exportformat="tsv"
inputdir=/dev/null
configdir=/dev/null
crossdir=/dev/null

mkdir -p input
echo "input folder was created..."

mkdir -p config
echo "config folder was created..."

mkdir -p OUTPUT
echo "OUTPUT folder was created..."


echo "Install complete..."
# end
