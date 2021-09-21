#!/bin/bash

#mkdir -p /data/chaffctf/challog/${TARGET}/chaff/dumps
#mkdir -p /data/chaffctf/challog/${TARGET}/chaff/tmps
#mkdir -p /data/chaffctf/challog/${TARGET}/chaff/xinetd
#
#mkdir -p /data/chaffctf/challog/${TARGET}/unchaff/dumps
#mkdir -p /data/chaffctf/challog/${TARGET}/unchaff/tmps
#mkdir -p /data/chaffctf/challog/${TARGET}/unchaff/xinetd

TARGET=$1
UNPORT=$2
PORT=$(($UNPORT+1))
SCRIPT_PATH=$(dirname $(realpath $0))
DEPLOY_PATH=$(dirname ${SCRIPT_PATH})/ctf/${TARGET}
XINETD_PATH=$(dirname ${SCRIPT_PATH})/xinetd
CHAL_PATH=$(dirname ${SCRIPT_PATH})/chals/${TARGET}

mkdir -p ${DEPLOY_PATH}
mkdir -p ${XINETD_PATH}

pushd ${SCRIPT_PATH}
if [ -f ${CHAL_PATH}/chaff.tar ]; then
	mkdir -p /data/chaffctf/xinetdlog/${TARGET}_chaff
	mkdir -p /data/chaffctf/challog/${TARGET}_chaff/tmps
	chmod 777 /data/chaffctf/challog/${TARGET}_chaff/tmps
	mkdir -p /data/chaffctf/challog/${TARGET}_chaff/dumps
	chmod 777 /data/chaffctf/challog/${TARGET}_chaff/dumps

	xxd -u -l 16 -p /dev/urandom | awk '{print "flag{" $1 "}"}' > flag;
	tar -xf ${CHAL_PATH}/chaff.tar ${TARGET};
	docker build --build-arg target=${TARGET} --rm -t ${TARGET}_chaff .;
	mv flag ${DEPLOY_PATH}/flag_chaff;
	rm ${TARGET};

	cat ${SCRIPT_PATH}/template.cfg | python3 -c "import sys; sys.stdout.write(sys.stdin.read().format(WORKDIR='${SCRIPT_PATH}', TARGET='${TARGET}_chaff', PORT=${PORT}))" > ${XINETD_PATH}/${TARGET}_chaff
fi

if [ -f ${CHAL_PATH}/unchaff.tar ]; then
	mkdir -p /data/chaffctf/xinetdlog/${TARGET}_unchaff
	mkdir -p /data/chaffctf/challog/${TARGET}_unchaff/tmps
	chmod 777 /data/chaffctf/challog/${TARGET}_unchaff/tmps
	mkdir -p /data/chaffctf/challog/${TARGET}_unchaff/dumps
	chmod 777 /data/chaffctf/challog/${TARGET}_unchaff/dumps

	xxd -u -l 16 -p /dev/urandom | awk '{print "flag{" $1 "}"}' > flag;
	tar -xf ${CHAL_PATH}/unchaff.tar ${TARGET};
	docker build --build-arg target=${TARGET} --rm -t ${TARGET}_unchaff .;
	mv flag ${DEPLOY_PATH}/flag_unchaff;
	rm ${TARGET};

	cat ${SCRIPT_PATH}/template.cfg | python3 -c "import sys; sys.stdout.write(sys.stdin.read().format(WORKDIR='${SCRIPT_PATH}', TARGET='${TARGET}_unchaff', PORT=${UNPORT}))" > ${XINETD_PATH}/${TARGET}_unchaff
fi
popd
