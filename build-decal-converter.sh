#!/usr/bin/env bash
##########################################################
# This script will build a .deb file for decal-converter #
#   Created by Ed Houseman Jr <justme488@gmail.com>      #
##########################################################

# Create a temp folder to use for downloading files and building  decal-converter.deb file
tmp_dir=$(mktemp -d)

# Create a temp folder "decal-converter"
mkdir "${tmp_dir}/decal-converter"

# Create a folder in tmp_dir/decal-converter named "DEBIAN"
mkdir "${tmp_dir}/decal-converter/DEBIAN"

# Create a folder in tmp_dir/decal-converter named "usr"
mkdir "${tmp_dir}/decal-converter/usr"

# Create a folder in tmp_dir/decal-converter/usr named "share"
mkdir "${tmp_dir}/decal-converter/usr/share"

# Create a folder in tmp_dir/decal-converter/usr/share named "applications"
mkdir "${tmp_dir}/decal-converter/usr/share/applications"

# Create a folder in tmp_dir/decal-converter/usr/share named "decal-converter"
mkdir "${tmp_dir}/decal-converter/usr/share/decal-converter"


# Now the main structure is Built

# Lets create a debian control file
touch "${tmp_dir}/decal-converter/DEBIAN/control"
echo "Package: decal-converter" >>  "${tmp_dir}/decal-converter/DEBIAN/control"
echo "Version: 2.0" >> "${tmp_dir}/decal-converter/DEBIAN/control"
echo "Architecture: amd64" >> "${tmp_dir}/decal-converter/DEBIAN/control"
echo "Installed-Size: 483100" >> "${tmp_dir}/decal-converter/DEBIAN/control"
echo "Maintainer: justme488 <justme488@gmail.com>" >> "${tmp_dir}/decal-converter/DEBIAN/control"
echo "Priority: optional" >> "${tmp_dir}/decal-converter/DEBIAN/control"
echo "Depends: imagemagick,pngquant,zenity" >> "${tmp_dir}/decal-converter/DEBIAN/control"
echo "Description: Decal-Converter" >> "${tmp_dir}/decal-converter/DEBIAN/control"
echo " A utility to convert decal images to png, gif, fill with black, colorize, watermark, and compress for Raven's Decals" >> "${tmp_dir}/decal-converter/DEBIAN/control"
echo " Features include:" >> "${tmp_dir}/decal-converter/DEBIAN/control"
echo " * Single or batch convert image to png" >> "${tmp_dir}/decal-converter/DEBIAN/control"
echo " * Single or batch convert image to gif" >> "${tmp_dir}/decal-converter/DEBIAN/control"
echo " * Single or batch colorize, fill with black, compress, and watermark decals images to White, Black, Blue, Teal, Red, green, silver, and pink" >> "${tmp_dir}/decal-converter/DEBIAN/control"
echo " * Saves original files to folder in home directory" >> "${tmp_dir}/decal-converter/DEBIAN/control"
echo " * Creates shortcut in Menu > Graphics > Decal Converter" >> "${tmp_dir}/decal-converter/DEBIAN/control"
echo " * Adds watermark for Raven's Decals" >> "${tmp_dir}/decal-converter/DEBIAN/control"

# Lets create the .desktop file

# Change directory to tmp_dir/decal-converter/usr/share/applications"
cd "${tmp_dir}/decal-converter/usr/share/applications"
touch "${tmp_dir}/decal-converter/usr/share/applications/decal-converter.desktop"
echo "[Desktop Entry]" >> "${tmp_dir}/decal-converter/usr/share/applications/decal-converter.desktop"
echo "Type=Application" >> "${tmp_dir}/decal-converter/usr/share/applications/decal-converter.desktop"
echo "Encoding=UTF-8" >> "${tmp_dir}/decal-converter/usr/share/applications/decal-converter.desktop"
echo "Name=Decal Converter" >> "${tmp_dir}/decal-converter/usr/share/applications/decal-converter.desktop"
echo "Comment=Convert decals and compresses" >> "${tmp_dir}/decal-converter/usr/share/applications/decal-converter.desktop"
echo "Exec=/usr/share/decal-converter/Decal-Converter.sh" >> "${tmp_dir}/decal-converter/usr/share/applications/decal-converter.desktop"
echo "Icon=/usr/share/decal-converter/decal-converter.png" >> "${tmp_dir}/decal-converter/usr/share/applications/decal-converter.desktop"
echo "Terminal=False" >> "${tmp_dir}/decal-converter/usr/share/applications/decal-converter.desktop"
echo "Categories=Graphics;" >> "${tmp_dir}/decal-converter/usr/share/applications/decal-converter.desktop"

# Start downloading files to the directories

# Change directory to tmp_dir
cd "$tmp_dir"

# Download zip file from github (main.zip)
wget "https://github.com/Justme488/Decal-Converter/archive/refs/heads/main.zip"

# Unzip tmp_dir/main.zip
unzip "${tmp_dir}/main.zip"

# If Decal-Converter-main exists in tmp_dir, that means main.zip was extracted and can be removed
if [[ -d "${tmp_dir}/Decal-Converter-main" ]]; then
  # Remove desktop/main,zip
  rm "${tmp_dir}/main.zip"
fi

# Move files from "tmp_dir/Decal-Converter-main" to "tmp_dir/decal-converter/usr/share/decal-converter"
mv "${tmp_dir}/Decal-Converter-main/Examples" "${tmp_dir}/decal-converter/usr/share/decal-converter"
mv "${tmp_dir}/Decal-Converter-main/decal-converter.png" "${tmp_dir}/decal-converter/usr/share/decal-converter"
mv "${tmp_dir}/Decal-Converter-main/Decal-Converter.sh" "${tmp_dir}/decal-converter/usr/share/decal-converter"
mv "${tmp_dir}/Decal-Converter-main/watermark.png" "${tmp_dir}/decal-converter/usr/share/decal-converter"

# We need to make decal-converter executable
chmod +x "${tmp_dir}/decal-converter/usr/share/decal-converter/Decal-Converter.sh"

# We need to change permissions on the folder, and all of it's contents
chmod 775 -R "${tmp_dir}/decal-converter"

# That's it for the required files, now let's build the .deb package

# Change directory to "tmp_dir/decal-converter"
cd "${tmp_dir}/decal-converter"

# Build the decal-converter.deb file
dpkg-deb --build "${tmp_dir}/decal-converter"

# Wait 2 seconds for .deb file to build before checking if it exists
sleep 2

# copy the .deb file to desktop
mv "${tmp_dir}/decal-converter.deb" "${HOME}/Desktop/decal-converter.deb"

# If the .deb file exists, delete the build directory
if [[ -f "$HOME/Desktop/decal-converter.deb" ]]; then
  zenity --info --title="Install File Is On Your Desktop" --text="decal-converter.deb is on your desktop\n\n( ${HOME}/Desktop/decal-converter.deb )" --width="400" --height="100"
  rm -rf "${tmp_dir}/decal-converter"
  rm -rf "${tmp_dir}/Decal-Converter-main"
  rm -rf "$tmp_dir"
fi

cd "$HOME"
exit
