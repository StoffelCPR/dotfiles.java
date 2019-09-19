#!/usr/bin/env bash

RED="\033[1;31m"
GREEN="\033[1;32m"
YELLOW="\033[1;33m"
BLUE="\033[1;34m"
MAGENTA="\033[1;35m"
UNDERLINED="\e[4m"
NORMAL="\e[0m"
BOLD="\e[1m"
NOCOLOR="\033[0m"

echo -e "${BLUE}${BOLD}########################################"
echo "#          Stoffel java setup          #"
echo -e "########################################${NORMAL}"

filepath=$( cd "$(dirname "$0")" ; pwd )

declare -a jdk_urls=(https://download.java.net/openjdk/jdk7u75/ri/openjdk-7u75-b13-linux-x64-18_dec_2014.tar.gz https://download.java.net/openjdk/jdk8u40/ri/openjdk-8u40-b25-linux-x64-10_feb_2015.tar.gz https://download.java.net/openjdk/jdk9/ri/openjdk-9+181_linux-x64_ri.zip https://download.java.net/openjdk/jdk10/ri/openjdk-10+44_linux-x64_bin_ri.tar.gz https://download.java.net/openjdk/jdk11/ri/openjdk-11+28_linux-x64_bin.tar.gz https://download.java.net/openjdk/jdk12/ri/openjdk-12+32_linux-x64_bin.tar.gz https://download.java.net/openjdk/jdk13/ri/openjdk-13+33_linux-x64_bin.tar.gz)

echo -e "${YELLOW} Trying to create temporary download directory${NOCOLOR}"
mkdir ./java_binaries && echo -e "${GREEN}...done${NOCOLOR}"

I=7
for url in "${jdk_urls[@]}" ; do
  break
    echo -e "${YELLOW}Processing JDK ${I}${NOCOLOR}"
    curl -o ./java_binaries/java${I} ${url}
    I=$((${I} + 1))
done


if [[ ${OS} == Debian ]]; then
    {
        echo -e "${YELLOW}Creating java directory${NOCOLOR}"
        [[ $(sudo mkdir ./jtest) ]] && echo -e "${GREEN}...done${NOCOLOR}"
    } || {
        JAVA_VERSION=7
        DIRECTORY="/var/lib/java/"
        echo -e "${YELLOW}Checking for existing java installations${NOCOLOR}"
        while [[ ${JAVA_VERSION} -le 13 ]]; do
          fullpath="${DIRECTORY}java${JAVA_VERSION}"

          if [[ -d "/var/lib/java/java${JAVA_VERSION}" ]]; then
            read -r -p "Java${JAVA_VERSION} already exists do you want to override it? [Y/n]" input
            case ${input} in
                [yY][eE][sS]|[yY])
                    echo -e "${YELLOW}Removing existing jdk in ${DIRECTORY}java${JAVA_VERSION}${NOCOLOR}"
                    sudo rm -rf ${DIRECTORY}java${JAVA_VERSION} && echo -e "${GREEN}...done${NOCOLOR}"
                    echo -e "${YELLOW}Creating final JDK directory in /var/lib/java for Java ${JAVA_VERSION}${NOCOLOR}"
                    sudo mkdir ${fullpath} && echo -e "${GREEN}...done${NOCOLOR}"
                    echo -e "${YELLOW}Extracting & moving downloaded java${JAVA_VERSION} binaries to ${DIRECTORY}java${JAVA_VERSION}${NOCOLOR}"
                    sudo tar xzf ./java_binaries/java${JAVA_VERSION} -C ${DIRECTORY}java${JAVA_VERSION} --strip-components 1 && echo -e "${GREEN}...done${NOCOLOR}"
                    JAVA_VERSION=$(($JAVA_VERSION+1))
                    continue
                ;;
                [nN][oO]|[nN])
                    echo -e "${RED}Not installing ${UNDERLINED}java${JAVA_VERSION}${NORMAL}${NOCOLOR}"
                    JAVA_VERSION=$(($JAVA_VERSION+1))
                    continue
                ;;
                *)
                echo -e "${YELLOW}Removing existing jdk in ${DIRECTORY}java${JAVA_VERSION}${NOCOLOR}"
                sudo rm -rf ${DIRECTORY}java${JAVA_VERSION} && echo -e "${GREEN}...done${NOCOLOR}"
                echo -e "${YELLOW}Creating final JDK directory in /var/lib/java for Java ${JAVA_VERSION}${NOCOLOR}"
                sudo mkdir ${fullpath} && echo -e "${GREEN}...done${NOCOLOR}"
                echo -e "${YELLOW}Extracting & moving downloaded java${JAVA_VERSION} binaries to ${DIRECTORY}java${JAVA_VERSION}${NOCOLOR}"
                sudo tar xzf ./java_binaries/java${JAVA_VERSION} -C ${DIRECTORY}java${JAVA_VERSION} --strip-components 1 && echo -e "${GREEN}...done${NOCOLOR}"
                JAVA_VERSION=$(($JAVA_VERSION+1))
                continue
                ;;
                esac
          fi
          echo -e "${YELLOW}Creating final JDK directory in /var/lib/java for Java ${JAVA_VERSION}${NOCOLOR}"
          sudo mkdir ${fullpath} && echo -e "${GREEN}...done${NOCOLOR}"
          echo -e "${YELLOW}Extracting & moving downloaded java${JAVA_VERSION} binaries to ${DIRECTORY}java${JAVA_VERSION}${NOCOLOR}"
          sudo tar xzf ./java_binaries/java${JAVA_VERSION} -C ${DIRECTORY}java${JAVA_VERSION} --strip-components 1 && echo -e "${GREEN}...done${NOCOLOR}"
          JAVA_VERSION=$(($JAVA_VERSION+1))
        done
        exit 1
    }
    exit 1
    echo "Copying cjava command to /bin..."
    sudo cp java/dotfiles/cjava /bin/
    echo "...done"
    echo "Making cjava executable..."
    sudo chmod a+x /bin/cjava
    echo "...done"
    echo "Making first symbolic link on java 11..."
    sudo ln -sf /var/lib/java/java11 /var/lib/java/java
    echo "done"
elif [[ ${OS} == CentOS ]]; then
    {
        echo "Creating java directory"
        sudo mkdir /var/lib/java
    } || {
        echo "Moving JDK files to java directory"
        echo "Moving JDK 7 to /var/lib/java/java7..."
        sudo mv jdk-7u80-linux-x64.tar.gz /var/lib/java/java7
        echo "...done"
        echo "Moving JDK 8 to /var/lib/java/java8..."
        sudo mv jdk-8u201-linux-x64.tar.gz /var/lib/java/java8
        echo "...done"
        echo "Moving JDK 9 to /var/lib/java/java9..."
        sudo mv jdk-9.0.4_linux-x64_bin.tar.gz /var/lib/java/java9
        echo "...done"
        echo "Moving JDK 10 to /var/lib/java/java10..."
        sudo mv jdk-10.0.2_linux-x64_bin.tar.gz /var/lib/java/java10
        echo "...done"
        echo "Moving JDK 11 to /var/lib/java/java11..."
        sudo mv jdk-11.0.2_linux-x64_bin.tar.gz /var/lib/java/java11
        echo "...done"
    }
    echo "Copying cjava command to /bin..."
    sudo cp java/dotfiles/cjava /bin/
    echo "...done"
    echo "Making cjava executable..."
    sudo chmod a+x /bin/cjava
    echo "...done"
    echo "Making first symbolic link on java 11..."
    sudo ln -sf /var/lib/java/java11 /var/lib/java/java
    echo "done"
else
    echo "java installation failed.. Couldn't figure out what system you use"
fi
