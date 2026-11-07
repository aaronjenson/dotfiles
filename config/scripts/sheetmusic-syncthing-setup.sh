set -e

DEVICE_ID="7GHB2SU-66XACYT-IDQELSS-7FQ2Y3N-HPOINOK-QBGB6XH-VHUE4RH-TBR7DQ3"

if ! syncthing cli config devices list | grep "$DEVICE_ID"; then
    syncthing cli config devices add --device-id "$DEVICE_ID"
    echo "Device $DEVICE_ID added."
else
    echo "Device $DEVICE_ID already exists."
fi

FOLDER_ID="xqwgd-9yjcg"
FOLDER_PATH="$HOME/sheet_music"

if ! syncthing cli config folders list | grep "$FOLDER_ID"; then
    echo syncthing cli config folders add --id "$FOLDER_ID" --path "$FOLDER_PATH"
    echo "Folder $FOLDER_PATH added."
else
    echo "Folder $FOLDER_PATH already exists."
fi
