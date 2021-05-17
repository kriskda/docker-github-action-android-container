#!/bin/bash

function start_emulator() {
	emulator -avd emu0 -memory 2048 -cores 2 -skin "1080x1920" -no-window -no-boot-anim -accel on -gpu swiftshader_indirect -no-audio -read-only -skip-adb-auth &
	
	WAIT_TIMEOUT=30

	counter=0
	while [[ $counter -lt $WAIT_TIMEOUT ]]
	do
		if [[ "`adb shell getprop sys.boot_completed | tr -d '\r' `" == "1" ]] ; then
			echo "Emulator is ready"
			break
		fi
		echo "Waiting for device"
		counter=$(( $counter + 1 ))
		sleep 1
	done
	echo "Finished waiting for device"
}

function disable_animation() {
	echo "Disable animations"
	adb shell "settings put global window_animation_scale 0.0"
	adb shell "settings put global transition_animation_scale 0.0"
	adb shell "settings put global animator_duration_scale 0.0"
}

function start_github_runner() {
	echo "Start github runner"
	RUNNER_TOKEN="$(curl -s -X POST \
							-H "Accept: application/vnd.github.v3+json" \
							-H "authorization: token $PERSONAL_ACCESS_TOKEN" \
							"https://api.github.com/repos/$REPO_OWNER/$REPO_NAME/actions/runners/registration-token" | jq -r .token)"
	cd actions-runner
	./config.sh --unattended --url https://github.com/$REPO_OWNER/$REPO_NAME --token $RUNNER_TOKEN --name $RUNNER_NAME --replace
	./run.sh	
}

sudo chmod 666 /dev/kvm
start_emulator
disable_animation
start_github_runner
