# sync rom
repo init --depth=1 --no-repo-verify -u https://github.com/Evolution-X/manifest -b snow -g default,-mips,-darwin,-notdefault
git clone https://github.com/NRanjan-17/local_manifest.git --depth 1 -b Evolution-X .repo/local_manifests
repo sync -c --no-clone-bundle --no-tags --optimized-fetch --prune --force-sync -j8

# build rom
source build/envsetup.sh
lunch evolution_mido-userdebug
export KBUILD_BUILD_USER=hyper
export KBUILD_BUILD_HOST=hyper
export BUILD_USERNAME=hyper
export BUILD_HOSTNAME=hyper
export BUILD_BROKEN_MISSING_REQUIRED_MODULES := true
export TZ=Asia/Delhi #put before last build command
mka evolution

# upload rom (if you don't need to upload multiple files, then you don't need to edit next line)
rclone copy out/target/product/$(grep unch $CIRRUS_WORKING_DIR/build_rom.sh -m 1 | cut -d ' ' -f 2 | cut -d _ -f 2 | cut -d - -f 1)/*.zip cirrus:$(grep unch $CIRRUS_WORKING_DIR/build_rom.sh -m 1 | cut -d ' ' -f 2 | cut -d _ -f 2 | cut -d - -f 1) -P
