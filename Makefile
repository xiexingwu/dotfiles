
check_home:
	bash ./scripts/check_home.sh

push_home:
	echo cp -rf home/ $$HOME/
	# bash ./scripts/push_home.sh

fetch_home:
	bash ./scripts/fetch_home.sh
