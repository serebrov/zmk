build:
	docker-compose build zmk

init:
	# docker-compose run --rm zmk west init -l app/
	docker-compose run --rm zmk west update
	docker-compose run --rm zmk west zephyr-export
	docker-compose run --rm zmk pip3 install --user -r zephyr/scripts/requirements-base.txt

zmk:
	docker-compose run --rm zmk bash

firmware:
	docker-compose run --rm zmk bash -c "source zephyr/zephyr-env.sh && cd app && west build -d build/left -b nice_nano -- -DSHIELD=microdox_left -DZMK_CONFIG=\"/zmk-config/config\""
	docker-compose run --rm zmk bash -c "source zephyr/zephyr-env.sh && cd app && west build -d build/right -b nice_nano -- -DSHIELD=microdox_right -DZMK_CONFIG=\"/zmk-config/config\""
	cp app/build/left/zephyr/zmk.uf2 ../microdox-left-$$(date "+%Y-%m-%d-%H-%M").uf2
	cp app/build/right/zephyr/zmk.uf2 ../microdox-right-$$(date "+%Y-%m-%d-%H-%M").uf2

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
