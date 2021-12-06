#!/bin/bash

[[ -f /etc/redhat-release ]] && unalias -a

INSTALL_VERSION=""

CAN_GOOGLE=1

FORCE_MODE=0

GO_PROXY_URL="https://goproxy.io,direct"


RED="31m"
GREEN="32m"
YELLOW="33m"
BLUE="36m"
FUCHSIA="35m"

colorEcho(){
    COLOR=$1
    echo -e "\033[${COLOR}${@:2}\033[0m"
}


while [[ $# > 0 ]];do
    KEY="$1"
    case $KEY in
        -v|--version)
        INSTALL_VERSION="$2"
        echo -e "Ready to install golang $(colorEcho ${BLUE} $INSTALL_VERSION)...\n"
        shift
        ;;
    esac
    shift
done


ipIsConnect(){
    ping -c2 -i0.3 -W1 $1 &>/dev/null
    if [ $? -eq 0 ];then
        return 0
    else
        return 1
    fi
}

setupEnv(){
    if [[ -z `echo $GOPATH` ]];then
        GOPATH="/go"
        mkdir -p $GOPATH
        echo "GOPATH值为: `colorEcho $BLUE $GOPATH`"
        echo "export GOROOT=/usr/local/go" >> /etc/profile
        echo "export GOPATH=$GOPATH" >> /etc/profile
        echo 'export PATH=$PATH:$GOROOT/bin:$GOPATH/bin' >> /etc/profile
    fi
    source /etc/profile
}

checkNetwork(){
    ipIsConnect "google.com"
    [[ ! $? -eq 0 ]] && CAN_GOOGLE=0
}

setupProxy(){
    if [[ $CAN_GOOGLE == 0 && `go env|grep proxy.golang.org` ]]; then
        go env -w GO111MODULE=on
        go env -w GOPROXY=$GO_PROXY_URL
        colorEcho $GREEN "The current network is China, set goproxy success"
    fi
}

sysArch(){
    ARCH=$(uname -m)
    if [[ "$ARCH" == "i686" ]] || [[ "$ARCH" == "i386" ]]; then
        VDIS="linux-386"
    elif [[ "$ARCH" == *"armv7"* ]] || [[ "$ARCH" == "armv6l" ]]; then
        VDIS="linux-armv6l"
    elif [[ "$ARCH" == *"armv8"* ]] || [[ "$ARCH" == "aarch64" ]]; then
        VDIS="linux-arm64"
    elif [[ "$ARCH" == *"s390x"* ]]; then
        VDIS="linux-s390x"
    elif [[ "$ARCH" == "ppc64le" ]]; then
        VDIS="linux-ppc64le"
    elif [[ "$ARCH" == *"darwin"* ]]; then
        VDIS="darwin-amd64"
    elif [[ "$ARCH" == "x86_64" ]]; then
        VDIS="linux-amd64"
    fi
}

installGo(){
    if [[ -z $INSTALL_VERSION ]];then
        echo "Getting the latest version of golang..."
        if [[ $CAN_GOOGLE == 0 ]];then
            INSTALL_VERSION=`curl -s https://go.dev/dl/|grep -w downloadBox|grep src|grep -oP '\d+\.\d+\.?\d*'|head -n 1`
        else
            INSTALL_VERSION=`curl -s https://github.com/golang/go/tags|grep releases/tag|grep -v rc|grep -v beta|grep -oP '\d+\.\d+\.?\d*'|head -n 1`
        fi
        [[ -z $INSTALL_VERSION ]] && { colorEcho $YELLOW "\nFailed to get golang version number!"; exit 1; }
        echo "The latest version of golang: `colorEcho $BLUE $INSTALL_VERSION`"
        if [[ $FORCE_MODE == 0 && `command -v go` ]];then
            if [[ `go version|awk '{print $3}'|grep -Eo "[0-9.]+"` == $INSTALL_VERSION ]];then
                return
            fi
        fi
    fi
    FILE_NAME="go${INSTALL_VERSION}.$VDIS.tar.gz"
    local TEMP_PATH=`mktemp -d`

    curl -H 'Cache-Control: no-cache' -L https://go.dev/dl/$FILE_NAME -o $FILE_NAME
    tar -C $TEMP_PATH -xzf $FILE_NAME
    if [[ $? != 0 ]];then
        colorEcho $YELLOW "\n Unzip failed! Switching the download source to download again..."
        rm -rf $FILE_NAME
        curl -H 'Cache-Control: no-cache' -L https://golang.google.cn/dl/$FILE_NAME -o $FILE_NAME
        tar -C $TEMP_PATH -xzf $FILE_NAME
        [[ $? != 0 ]] && { colorEcho $YELLOW "\n Unzip failed!"; rm -rf $TEMP_PATH $FILE_NAME; exit 1; }

    fi
    [[ -e /usr/local/go ]] && rm -rf /usr/local/go
    mv $TEMP_PATH/go /usr/local/
    rm -rf $TEMP_PATH $FILE_NAME
}

main(){
    sysArch
    checkNetwork
    installGo
    setupEnv
    setupProxy
    echo -e "golang `colorEcho $BLUE $INSTALL_VERSION` install success!"
}

main