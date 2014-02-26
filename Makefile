REMOTE_REPOSITORY= ~/tecweb/
USER= user
HTACCESS= public_html/.htaccess

# Include, senza lamentarsi se il file è assente
-include config.mk

all: local

local:
	#htaccess-local

tecweb: 
	#htaccess-tecweb

tunnel:
	@echo "* Sarà visibile al link: http://localhost:30080/tecweb/~$(USER)/"
	ssh -L30080:tecnologie-web:80 -L30022:tecnologie-web:22 -A -t $(USER)@ssh.studenti.math.unipd.it ssh $(USER)@tecnologie-web

deploy:
	@echo "(*) Upload..."
	@scp -P 30022 -p -r ./* $(USER)@localhost:tecweb/
	@echo "(*) Executing Makefile via SSH..."
	ssh -p 30022 $(USER)@localhost "cd tecweb && make tecweb"
	@echo "(*) Done."

htaccess-local:
	@echo -e "RewriteEngine On \n\
RewriteRule ^/?$$ /unioverflow/cgi-bin/dispatch.cgi [PT] \n\
RewriteCond %{SCRIPT_FILENAME} !-d \n\
RewriteCond %{SCRIPT_FILENAME} !-f \n\
RewriteRule ^(.*)$$ /unioverflow/cgi-bin/dispatch.cgi/$$1 [PT]" > "$(HTACCESS)"

htaccess-tecweb:
	@echo "RewriteEngine On \n\
RewriteRule ^/?$$ /tecweb/~$(USER)/cgi-bin/dispatch.cgi [PT] \n\
RewriteCond %{SCRIPT_FILENAME} !-d \n\
RewriteCond %{SCRIPT_FILENAME} !-f \n\
RewriteRule ^(.*)$$ /tecweb/~$(USER)/cgi-bin/dispatch.cgi/$$1 [PT]" > "$(HTACCESS)"
