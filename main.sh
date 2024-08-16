#!/bin/bash

Main() {
    clear
    echo "|----------------- Android Help Tool ------------------|"
    echo "|               | Made by NobreStacks |                |"
    echo "|------------------------------------------------------|"
    echo "| To open the documemtation type 1 [DONE]              |"
    echo "| To restart the phone type 2 [DONE]                   |"
    echo "| To Unlock the bootloader type 3 [DONE]               |"
    echo "| To flash an .zip file type 4 [DONE]                  |"
    echo "| To format the phone type 5 [DONE]                    |"
    echo "|------------------------------------------------------|"
    echo "| To debug the phone type 6 [DONE]                     |"
    echo "|------------------------------------------------------|"

    # Pick the input
    read -p "Usage: " choice

    case $choice in
        1)
            clear
            oscheck
            tmp=$?
            if [ "$tmp" == "0" ]; then
                xdg-open "https://github.com/NobreStack/Android-Help-Tool/tree/main"
            elif [ "$tmp" == "1" ]; then
                open "https://github.com/NobreStack/Android-Help-Tool/tree/main"
            fi
            Main
            ;;
        2)
            clear
            Restart
            ;;
        3)
            clear
            echo "Unlocking..."
            unlock_ability=$(fastboot flashing get_unlock_ability 2>&1 | grep -o '(?<=get_unlock_ability: )\d')

            if [ "$unlock_ability" == "1" ]; then
                echo "Unlocking..."
                
                fastboot flashing unlock
                sleep 2
                echo "Device unlocked, returning to main menu..."
                Main
            else
                echo "Unlock of device unauthorized, verify if the OEM permission is granted"
                echo "Returning to the main menu..."
            fi
            sleep 1
            Main
            ;;
        4)
            echo "Drag and drop the .zip file here: "
            read location
            clear
            fastboot flash "$location" 
            Main
            ;;
        5)
            clear
            echo "Warning this feature is not working properly, and will be removed for a while..."
            Main
            ;;
        6)
            clear
            echo "                 - Debug Mode -"
            echo "Debug Mode is ON. Type 'return-to-main' to exit."
            echo ""
            while true; do
                read -p "Enter the command: " cmd
                Debug "$cmd"
                if [ "$cmd" == "return-to-main" ]; then
                    Main
                    break
                fi
                echo ""
            done 
            ;;
        *)
            clear
            echo "Invalid choice. Please select a valid option."
            Main
            ;;
    esac
}

Debug() {
    $1
}

oscheck() {
    os_name=$(uname)

    if [[ "$os_name" == "Linux" ]]; then
        return 0
    elif [[ "$os_name" == "Darwin" ]]; then
        return 1
    else
        return 2
    fi
}

Restart() {
    clear
    echo "|-----------------   Restart Menu    ------------------|"
    echo "|               | Made by NobreStacks |                |"
    echo "|------------------------------------------------------|"
    echo "| To restart in Recovery type 1                        |"
    echo "| To restart in FastBoot type 2                        |"
    echo "| To restart in BootLoader type 3                      |"
    echo "| To restart in System type 4                          |"
    echo "| To Return type 5                                     |"
    echo "|------------------------------------------------------|"
    read -p "Usage: " choice

    case $choice in
        1)
            clear
            echo "|----------------- Select mode ------------------|"
            echo "| 1: Fastboot                   2: ADB           |"
            echo "|------------------------------------------------|"
            read -p "Usage: " sub_choice

            if [ "$sub_choice" == "1" ]; then
                fastboot reboot recovery
                echo "Device rebooted, returning to the main menu..."
                sleep 1
                Main
            elif [ "$sub_choice" == "2" ]; then
                adb reboot recovery
                echo "Device rebooted, returning to the main menu..."
                sleep 1
                Main
            else
                echo "Invalid choice, Returning..."
                sleep 1.5
                Restart
            fi
            ;;
        2)
            clear
            echo "|----------------- Select mode ------------------|"
            echo "| 1: Fastboot                   2: ADB           |"
            echo "|------------------------------------------------|"
            read -p "Usage: " sub_choice

            if [ "$sub_choice" == "1" ]; then
                fastboot reboot fastbootd
                echo "Device rebooted, returning to the main menu..."
                sleep 1
                Main
            elif [ "$sub_choice" == "2" ]; then
                adb reboot fastbootd
                echo "Device rebooted, returning to the main menu..."
                sleep 1
                Main
            else
                echo "Invalid choice, Returning..."
                sleep 1.5
                Restart
            fi
            ;;
        3)
            clear
            echo "|----------------- Select mode ------------------|"
            echo "| 1: Fastboot                   2: ADB           |"
            echo "|------------------------------------------------|"
            read -p "Usage: " sub_choice

            if [ "$sub_choice" == "1" ]; then
                fastboot reboot bootloader
                echo "Device rebooted, returning to the main menu..."
                sleep 1
                Main
            elif [ "$sub_choice" == "2" ]; then
                adb reboot bootloader
                echo "Device rebooted, returning to the main menu..."
                sleep 1
                Main
            else
                echo "Invalid choice, Returning..."
                sleep 1.5
                Restart
            fi
            ;;
        4)
            clear
            echo "|----------------- Select mode ------------------|"
            echo "| 1: Fastboot                   2: ADB           |"
            echo "|------------------------------------------------|"
            read -p "Usage: " sub_choice

            if [ "$sub_choice" == "1" ]; then
                fastboot reboot system
                echo "Device rebooted, returning to the main menu..."
                sleep 1
                Main
            elif [ "$sub_choice" == "2" ]; then
                adb reboot system
                echo "Device rebooted, returning to the main menu..."
                sleep 1
                Main
            else
                echo "Invalid choice, Returning..."
                sleep 1.5
                Restart
            fi
            ;;
        5)
            Main
            ;;
        *)
            echo "Invalid choice, Returning..."
            sleep 1.5
            Restart
            ;;
    esac
}

Main
