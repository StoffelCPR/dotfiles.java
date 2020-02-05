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
    echo -e "${YELLOW}Processing JDK ${I}${NOCOLOR}"
    curl -o ./java_binaries/java${I} ${url}
    I=$((${I} + 1))
done


if [[ Debian == Debian ]]; then
    {
        echo -e "${YELLOW}Creating java directory${NOCOLOR}"
        [[ $(sudo mkdir /var/lib/java) ]] && echo -e "${GREEN}...done${NOCOLOR}"
    } || {
        JAVA_VERSION=7
        DIRECTORY="/var/lib/java/"
        echo -e "${YELLOW}Checking for existing java installations${NOCOLOR}"
        while [[ ${JAVA_VERSION} -le 13 ]]; do
          fullpath="${DIRECTORY}java${JAVA_VERSION}"

          if [[ -d "/var/lib/java/java${JAVA_VERSION}" ]]; then
            echo -e "${RED}"
            read -r -p "Java${JAVA_VERSION} already exists do you want to override it? [Y/n]" input
            echo -e "${NOCOLOR}"
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
          else
            echo -e "${YELLOW}Creating final JDK directory in /var/lib/java for Java ${JAVA_VERSION}${NOCOLOR}"
            sudo mkdir ${fullpath} && echo -e "${GREEN}...done${NOCOLOR}"
            echo -e "${YELLOW}Extracting & moving downloaded java${JAVA_VERSION} binaries to ${DIRECTORY}java${JAVA_VERSION}${NOCOLOR}"
            sudo tar xzf ./java_binaries/java${JAVA_VERSION} -C ${DIRECTORY}java${JAVA_VERSION} --strip-components 1 && echo -e "${GREEN}...done${NOCOLOR}"
            JAVA_VERSION=$(($JAVA_VERSION+1))
            continue
          fi
          echo -e "${YELLOW}Creating final JDK directory in /var/lib/java for Java ${JAVA_VERSION}${NOCOLOR}"
          sudo mkdir ${fullpath} && echo -e "${GREEN}...done${NOCOLOR}"
          echo -e "${YELLOW}Extracting & moving downloaded java${JAVA_VERSION} binaries to ${DIRECTORY}java${JAVA_VERSION}${NOCOLOR}"
          sudo tar xzf ./java_binaries/java${JAVA_VERSION} -C ${DIRECTORY}java${JAVA_VERSION} --strip-components 1 && echo -e "${GREEN}...done${NOCOLOR}"
          JAVA_VERSION=$(($JAVA_VERSION+1))
        done
        echo -e "${GREEN}All Java versions have been installed.${NOCOLOR}"
        echo -e "${YELLOW}Creating first simbolic link${NOCOLOR}"

        JAVA_VERSION=$((${JAVA_VERSION}-1))
        if [[ -d "/var/lib/java/java" ]]; then
          echo -e "${RED}"
          read -r -p "Symbolic link /var/lib/java/java already exists do you want to overide it ? [Y/n]" input
          echo -e "${NOCOLOR}"
          case ${input} in
            [yY][eE][sS]|[yY] )
              echo -e "${YELLOW}Removing existing link${NOCOLOR}"
              sudo rm -rf /var/lib/java/java && echo -e "${GREEN}...done${NOCOLOR}"
              echo -e "${YELLOW} creating new link on java ${JAVA_VERSION}${NOCOLOR}"
              sudo ln -sf /var/lib/java/java${JAVA_VERSION} /var/lib/java/java && echo -e "${GREEN}...done${NOCOLOR}"
            ;;
            [nN][oO]|[nN])
              echo -e "${RED}Not creating new symblic link"
            ;;
            *)
            echo -e "${YELLOW}Removing existing link${NOCOLOR}"
            sudo rm -rf /var/lib/java/java && echo -e "${GREEN}...done${NOCOLOR}"
            echo -e "${YELLOW} creating new link on java ${JAVA_VERSION}${NOCOLOR}"
            sudo ln -sf /var/lib/java/java${JAVA_VERSION} /var/lib/java/java && echo -e "${GREEN}...done${NOCOLOR}"
            ;;
          esac
        else
          echo -e "${YELLOW} creating new link on java ${JAVA_VERSION}${NOCOLOR}"
          sudo ln -sf /var/lib/java/java${JAVA_VERSION} /var/lib/java/java && echo -e "${GREEN}...done${NOCOLOR}"
        fi

        echo -e "${BLUE}All java versions were installed to ${DIRECTORY}.${NOCOLOR}"

        # CJAVA COMMNAD
        echo -e "${YELLOW}Checking for cjava command...${NOCOLOR}"

        if hash cjava 2>/dev/null; then
          echo -e "${RED}cjava already exists!"
          read -r -p "Do you want to override your cjava command? [Y/n] " input
          echo -e "${NOCOLOR}"
          case ${input} in
              [yY][eE][sS]|[yY])
                  CJAVA_LOCATION_CURRENT=$(which cjava)
                  echo -e "${YELLOW}Deleting current cjava command which is located at: ${CJAVA_LOCATION_CURRENT}${NOCOLOR}"
                  sudo rm -rf ${CJAVA_LOCATION_CURRENT} && echo -e "${GREEN}...done${NOCOLOR}"
                  echo -e "${YELLOW}Copying cjava file to /bin/${NOCOLOR}"
                  sudo cp "./dotfiles.java/files/cjava" /bin && echo -e "${GREEN}...done${NOCOLOR}"
                  echo -e "${YELLOW}Modifying cjava with sudo privileges to make it executable${NOCOLOR}"
                  sudo chmod a+x /bin/cjava && echo -e "${GREEN}...done${NOCOLOR}"
              ;;
              [nN][oO]|[nN])
                  echo -e "${RED}Not overriding the current java command"
              ;;
              *)
                CJAVA_LOCATION_CURRENT=$(which cjava)
                echo -e "${YELLOW}Deleting current cjava command which is located at: ${CJAVA_LOCATION_CURRENT}${NOCOLOR}"
                sudo rm -rf ${CJAVA_LOCATION_CURRENT} && echo -e "${GREEN}...done${NOCOLOR}"
                echo -e "${YELLOW}Copying cjava file to /bin/${NOCOLOR}"
                sudo cp "./dotfiles.java/files/cjava" /bin && echo -e "${GREEN}...done${NOCOLOR}"
                echo -e "${YELLOW}Modifying cjava with sudo privileges to make it executable${NOCOLOR}"
                sudo chmod a+x /bin/cjava && echo -e "${GREEN}...done${NOCOLOR}"
              ;;
              esac
        else
          echo -e "${YELLOW}Copying cjava file to /bin/${NOCOLOR}"
          sudo cp "./dotfiles.java/files/cjava" /bin && echo -e "${GREEN}...done${NOCOLOR}"
          echo -e "${YELLOW}Modifying cjava with sudo privileges to make it executable${NOCOLOR}"
          sudo chmod a+x /bin/cjava && echo -e "${GREEN}...done${NOCOLOR}"
        fi
        exit 1
    }
elif [[ ${OS} == CentOS ]]; then
    echo -e "${RED}Not implemented${NOCOLOR}"
else
    echo "java installation failed.. Couldn't figure out what system you use"
fi
