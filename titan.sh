#!/bin/bash

# ----------------------------
# Определения цветов и иконок
# ----------------------------
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
YELLOW='\033[1;33m'
MAGENTA='\033[0;35m'
RESET='\033[0m'

CHECKMARK="✅"
ERROR="❌"
PROGRESS="⏳"
INSTALL="🛠️"
STOP="⏹️"
RESTART="🔄"
LOGS="📄"
EXIT="🚪"
INFO="ℹ️"
ICON_KEFIR="🥛"

# ----------------------------
# Установка Docker
# ----------------------------
install_docker() {
    echo -e "${INSTALL} Установка Docker...${RESET}"
    
    # Добавление GPG-ключа Docker
    sudo apt-get update
    sudo apt-get install ca-certificates curl
    sudo install -m 0755 -d /etc/apt/keyrings
    sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
    sudo chmod a+r /etc/apt/keyrings/docker.asc

    # Добавление репозитория в источники Apt
    echo \
    "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
    $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
    sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
    sudo apt-get update
    sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

    echo -e "${CHECKMARK} Docker успешно установлен.${RESET}"
    read -p "Нажмите Enter, чтобы вернуться в главное меню."
}

# ----------------------------
# Запуск Titan Node
# ----------------------------
start_titan_node() {
    # Создание .env файла и запрос HASH
    echo -e "${INSTALL} Настройка Titan Node...${RESET}"
    read -p "Введите значение HASH для Titan Node: " HASH
    echo "HASH=$HASH" > .env

    # Запуск контейнера Titan Node
    docker run --network=host -d -v ~/.titanedge:/root/.titanedge nezha123/titan-edge
    sleep 10

    # Привязка узла с использованием HASH
    docker run --rm -it -v ~/.titanedge:/root/.titanedge nezha123/titan-edge bind --hash=$HASH https://api-test1.container1.titannet.io/api/v2/device/binding
    echo -e "${CHECKMARK} Titan Node запущен и успешно привязан.${RESET}"
    read -p "Нажмите Enter, чтобы вернуться в главное меню."
}

# ----------------------------
# Просмотр всех контейнеров
# ----------------------------
view_containers() {
    echo -e "${INFO} Просмотр всех контейнеров...${RESET}"
    docker ps -a
    read -p "Нажмите Enter, чтобы вернуться в главное меню."
}

# ----------------------------
# Просмотр логов контейнера
# ----------------------------
view_logs() {
    read -p "Введите ID контейнера для просмотра логов: " container_id
    echo -e "${LOGS} Получение логов для контейнера $container_id...${RESET}"
    docker logs $container_id
    read -p "Нажмите Enter, чтобы вернуться в главное меню."
}

# ----------------------------
# Управление контейнерами (Остановка и удаление)
# ----------------------------
manage_container() {
    read -p "Введите ID контейнера для остановки и удаления: " container_id
    echo -e "${STOP} Остановка контейнера $container_id...${RESET}"
    docker stop $container_id
    echo -e "${STOP} Удаление контейнера $container_id...${RESET}"
    docker rm $container_id
    echo -e "${CHECKMARK} Контейнер $container_id успешно остановлен и удалён.${RESET}"
    read -p "Нажмите Enter, чтобы вернуться в главное меню."
}

# ----------------------------
# Перезапуск контейнера
# ----------------------------
restart_container() {
    read -p "Введите ID контейнера для перезапуска: " container_id
    echo -e "${RESTART} Перезапуск контейнера $container_id...${RESET}"
    docker restart $container_id
    echo -e "${CHECKMARK} Контейнер $container_id успешно перезапущен.${RESET}"
    read -p "Нажмите Enter, чтобы вернуться в главное меню."
}

# ----------------------------
# Вывод ASCII-логотипа и ссылок
# ----------------------------
display_ascii() {
    echo -e "${CYAN}   ____   _  __   ___    ____ _   __   ____ ______   ____   ___    ____${RESET}"
    echo -e "${CYAN}  /  _/  / |/ /  / _ \\  /  _/| | / /  /  _//_  __/  /  _/  / _ |  / __/${RESET}"
    echo -e "${CYAN} _/ /   /    /  / // / _/ /  | |/ /  _/ /   / /    _/ /   / __ | _\\ \\  ${RESET}"
    echo -e "${CYAN}/___/  /_/|_/  /____/ /___/  |___/  /___/  /_/    /___/  /_/ |_|/___/  ${RESET}"
    echo -e ""
    echo -e "${YELLOW}Подписывайтесь на Telegram: https://t.me/CryptalikBTC${RESET}"
    echo -e "${YELLOW}Подписывайтесь на YouTube: https://www.youtube.com/@Cryptalik${RESET}"
    echo -e "${YELLOW}Здесь про аирдропы и ноды: https://t.me/indivitias${RESET}"
    echo -e "${YELLOW}Купи мне крипто бутылочку... ${ICON_KEFIR}кефира 😏${RESET} ${MAGENTA} 👉  https://bit.ly/4eBbfIr  👈 ${MAGENTA}"
    echo -e ""
}

# ----------------------------
# Главное меню
# ----------------------------
show_menu() {
    clear
    display_ascii
    echo -e "    ${YELLOW}Выберите опцию:${RESET}"
    echo -e "    ${CYAN}1.${RESET} ${INSTALL} Установить Docker"
    echo -e "    ${CYAN}2.${RESET} ${INSTALL} Запустить Titan Node"
    echo -e "    ${CYAN}3.${RESET} ${INFO} Просмотреть все контейнеры"
    echo -e "    ${CYAN}4.${RESET} ${LOGS} Просмотреть логи контейнера"
    echo -e "    ${CYAN}5.${RESET} ${STOP} Управление контейнерами (Остановить и удалить)"
    echo -e "    ${CYAN}6.${RESET} ${RESTART} Перезапустить контейнер"
    echo -e "    ${CYAN}7.${RESET} ${EXIT} Выход"
    echo -ne "    ${YELLOW}Введите ваш выбор [1-7]: ${RESET}"
}

# ----------------------------
# Основной цикл
# ----------------------------
while true; do
    show_menu
    read choice
    case $choice in
        1)
            install_docker
            ;;
        2)
            start_titan_node
            ;;
        3)
            view_containers
            ;;
        4)
            view_logs
            ;;
        5)
            manage_container
            ;;
        6)
            restart_container
            ;;
        7)
            echo -e "${EXIT} Выход...${RESET}"
            exit 0
            ;;
        *)
            echo -e "${ERROR} Неверная опция. Попробуйте снова.${RESET}"
            read -p "Нажмите Enter, чтобы продолжить..."
            ;;
    esac
done
