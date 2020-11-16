
install:
	install gnvs.rb -D /usr/local/bin/gnvs
	install gnvs.cron -D /etc/cron.d/gnvs
	gnvs
