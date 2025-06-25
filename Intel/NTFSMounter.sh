echo "NTFS mounter for macOS"
echo "By Longtail Amethyst Eralbrunia, Jun 2025"
# This script mounts NTFS drives on macOS using ntfs-3g

echo "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
echo "Before starting, please ensure you have unmounted the drive from Finder"
echo "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
echo "Have you unmount the drive from Finder? (y/n)"
read unmount_finder_choice
if [ "$unmount_finder_choice" != "y" ]; then
  echo "Please unmount the drive from Finder and run this script again."
  exit 1
fi

echo "Have you installed macFUSE?"
read installed_macFuse_choise
if [ "$installed_macFuse_choise" != "y"]; then
  echo "Please install macFUSE and run this script again."
  exit 1
fi

# select a disk to mount
echo "Available disks:"
diskutil list
echo "Hint: your external disk should be labeled as 'external' in the output."
echo "Enter the disk IDENTIFIER at the last column (e.g., disk8s9):"
read disk_identifier

# check if the disk is already mounted
if mount | grep -q "$disk_identifier"; then
  echo "The disk $disk_identifier is already mounted. Do you want to unmount it? (y/n)"
  read unmount_choice
  if [ "$unmount_choice" = "y" ]; then
    diskutil unmount "$disk_identifier"
    echo "Disk $disk_identifier unmounted."
  else
    echo "Exiting without unmounting."
    exit 0
  fi
fi

# select a mount point
echo "Enter the mount point (Default is /Volumes/NTFSMount):"
read mount_point
if [ -z "$mount_point" ]; then
  echo "Using default mount point: /Volumes/NTFSMount"
  # create the default mount point if it doesn't exist
  if [ ! -d Volumes/NTFSMount ]; then
    sudo mkdir -p /Volumes/NTFSMount
  fi
  mount_point="/Volumes/NTFSMount"
fi

# mount the NTFS drive
echo "Mounting $disk_identifier at $mount_point..."
sudo ./ntfs-3g "/dev/$disk_identifier" "$mount_point" -o local -o allow_other
if [ $? -eq 0 ]; then
  echo "Successfully mounted $disk_identifier at $mount_point. Check your Finder and you should see the drive mounted."
else
  echo "Failed to mount $disk_identifier."
  exit 1
fi

