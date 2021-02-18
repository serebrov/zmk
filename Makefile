build:
	docker-compose build zmk

init:
	# docker-compose run --rm zmk west init -l app/
	docker-compose run --rm zmk west update
	docker-compose run --rm zmk west zephyr-export
	docker-compose run --rm zmk pip3 install --user -r zephyr/scripts/requirements-base.txt

zmk:
	docker-compose run --rm zmk bash

firmware-left:
	docker-compose run --rm zmk bash -c "source zephyr/zephyr-env.sh && cd app && west build -d build/left -b nice_nano -- -DSHIELD=microdox_left -DZMK_CONFIG=\"/zmk-config/config\""
	cp app/build/left/zephyr/zmk.uf2 ../microdox-left-$$(date "+%Y-%m-%d-%H-%M").uf2

firmware-right:
	docker-compose run --rm zmk bash -c "source zephyr/zephyr-env.sh && cd app && west build -d build/right -b nice_nano -- -DSHIELD=microdox_right -DZMK_CONFIG=\"/zmk-config/config\""
	cp app/build/right/zephyr/zmk.uf2 ../microdox-right-$$(date "+%Y-%m-%d-%H-%M").uf2

firmware: firmware-left firmware-right
	echo "Done"

firmware-settings-reset:
	rm -r app/build
	docker-compose run --rm zmk bash -c "source zephyr/zephyr-env.sh && cd app && west build -b nice_nano -- -DSHIELD=settings_reset"
	cp app/build/zephyr/zmk.uf2 ../settings-reset-$$(date "+%Y-%m-%d-%H-%M").uf2
	rm -r app/build

update-upstream:
	git tag custom/$(date "+%Y-%m-%d-%H-%M")-before
	git fetch upstream
	git checkout main
	git pull
	git merge upstream/main
	git push origin HEAD
	git checkout custom
	git rebase main
	git tag custom/$(date "+%Y-%m-%d-%H-%M")-after
