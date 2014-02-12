REMOTE_REPOSITORY= ~/tecweb/

# Include, senza lamentarsi se il file è assente
-include config.mk

tunnel:
	@echo "* Sarà visibile al link: http://localhost:30080/tecweb/~$(USER)/"
	ssh -L30080:tecnologie-web:80 -L30022:tecnologie-web:22 -A -t $(USER)@ssh.studenti.math.unipd.it ssh $(USER)@tecnologie-web

deploy:
	@echo "(*) Upload..."
	@scp -P 30022 -r ./* $(USER)@localhost:tecweb/
	@echo "(*) Done."
