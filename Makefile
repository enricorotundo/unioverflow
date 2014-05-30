SHELL= bash
REMOTE_REPOSITORY= ~/tecweb/
USER= user
BASE_URL= http://localhost/unioverflow

# Include, senza lamentarsi se il file è assente
-include config.mk

PAGES = \
	$(BASE_URL)/cgi-bin/accedi.cgi \
	$(BASE_URL)/cgi-bin/esci.cgi \
	$(BASE_URL)/cgi-bin/esegui-accesso.cgi \
	$(BASE_URL)/cgi-bin/index.cgi \
	$(BASE_URL)/cgi-bin/index.html \
	$(BASE_URL)/cgi-bin/manuale.cgi \
	$(BASE_URL)/cgi-bin/page-error.cgi \
	$(BASE_URL)/cgi-bin/registrati.cgi \
	$(BASE_URL)/cgi-bin/scrivi-domanda.cgi \
	$(BASE_URL)/cgi-bin/vedi-domanda.cgi

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

validate-db:
	@echo "(*) Valido il database XML usando lo schema XSD..."
	xmllint --noout --schema db/db.xsd db/db.xml
	@echo "(*) Il database XML è ok."

test-pages:
	@echo "(*) Controllo che le pagine si carichino (non controllo la validità)..."
	@for page in $(PAGES); do \
		if [[ $$(curl -s "$$page" | grep -i "not found\|stacktrace" -c) != 0 ]]; then \
			echo "/!\\ Ci sono degli errori alla pagina $$page"; \
			curl -s "$$page" | grep -i "not found\|stacktrace"; \
			exit 1; \
		else \
			echo "( ) La pagina $$page non ha errori"; \
		fi; \
	done
	@echo "(*) Le pagine non hanno errori evidenti."

test: validate-db test-pages