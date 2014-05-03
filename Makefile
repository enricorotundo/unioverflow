REMOTE_REPOSITORY= ~/tecweb/
USER= user

# Include, senza lamentarsi se il file è assente
-include config.mk

all: local

local: flags-local
	@#htaccess-local

tecweb: flags-tecweb
	@#htaccess-tecweb

tunnel:
	@echo "* Sarà visibile al link: http://localhost:30080/tecweb/~$(USER)/"
	ssh -L30080:tecnologie-web:80 -L30022:tecnologie-web:22 -A -t $(USER)@ssh.studenti.math.unipd.it ssh $(USER)@tecnologie-web

deploy:
	@echo "(*) Upload..."
	@scp -P 30022 -p -r ./* $(USER)@localhost:tecweb/
	@echo "(*) Executing Makefile via SSH..."
	ssh -p 30022 $(USER)@localhost "cd tecweb && make tecweb"
	@echo "(*) Fatto."

flags-local:
	@echo "(*) Sistemo i permessi dei file..."
	@find cgi-bin/ public_html/ -type d -exec chmod u=rwx,g=rx,o=rx '{}' \;
	@find cgi-bin/ public_html/ -type f -exec chmod u=rw,g=r,o=r '{}' \;
	@find cgi-bin/ -type f -name '*.pl' -or -name '*.cgi' -exec chmod +x '{}' \;
	@find db/ -type f -name '*.xml' -exec chmod a+w '{}' \;
	@echo "(*) Fatto."

flags-tecweb:
	@echo "(*) Sistemo i permessi dei file..."
	@find cgi-bin/ public_html/ -type d -exec chmod u=rwx,g=rx,o= '{}' \;
	@find cgi-bin/ public_html/ -type f -exec chmod u=rw,g=r,o= '{}' \;
	@find cgi-bin/ -type f -name '*.pl' -or -name '*.cgi' -exec chmod u+x,o+x '{}' \;
	@find db/ -type f -name '*.xml' -exec chmod +w '{}' \;
	@echo "(*) Fatto."
