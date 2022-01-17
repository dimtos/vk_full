#!/bin/bash

#
# По-хорошему, этот скрипт должен проверять ОС, её версию и много прочих условий,
# а также средствами ОС получать целевые каталоги, чтобы не хардкодить из здесь,
# но в рамках тестовой задачи стоит цель проверить знания Tarantool и Lua,
# поэтому скрипт развёртывания призван, скорее, продемонстрировать владение
# информацией о существующей возможности подобной автоматизации, как один из способов,
# нежели создать боевой деплой
#

if [ $EUID != 0 ]; then
    sudo "$0" "$@"
    exit $?
fi

tarantool_apps="/usr/share/tarantool"
source=`dirname $0`"/source"
target="$tarantool_apps/vk"

curl -L https://tarantool.io/twjOhaI/release/2.8/installer.sh | bash

apt-get -y install tarantool

cp "$source"/instance/vk.lua /etc/tarantool/instances.available/
ln -s /etc/tarantool/instances.available/vk.lua /etc/tarantool/instances.enabled/vk.lua

mkdir /db
mkdir /db/vk
mkdir /db/vk/memtx
mkdir /db/vk/vinyl
mkdir /db/vk/xlog
chown -R tarantool:tarantool /db/vk

mkdir "$target"
cd "$target"
#tarantoolctl rocks install http
cp -r "$source"/vk "$tarantool_apps"/

chown -R tarantool:tarantool "$target" # упрощаем, отдадим право владения tarantool-у
chmod -R g=u "$target" # именно в нашем случае так удобнее, чтобы своего юзера добавить в группу tarantool, и иметь доступ к скриптам

tarantoolctl restart vk

echo "That's all, folks!"
