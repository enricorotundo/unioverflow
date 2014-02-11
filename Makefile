REMOTE_REPOSITORY= ~/tecweb/

# Include, senza lamentarsi se il file è assente
-include config.mk

tunnel:
	@echo "* Sarà visibile al link: http://localhost:20080/tecweb/~$(USERNAME)/"
	ssh -L30080:tecnologie-web:80 -L30022:tecnologie-web:22 $(USERNAME)@ssh.studenti.math.unipd.it

deploy:
	@echo "(*) Upload..."
	@scp -P 30022 -r ./* nomeutente@localhost:tecweb/
	@echo "(*) Done."
