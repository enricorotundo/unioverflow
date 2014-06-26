
function validateForm() {
	var campoErrori = document.getElementById("error");
    var email = document.forms["registrati-form"]["email"].value;
    var password = document.forms["registrati-form"]["password"].value;
    var passwordconfirm = document.forms["registrati-form"]["passwordconfirm"].value;
    var erroriForm = "";

    // ^[a-z0-9._%+-]{1,64}\@studenti.unipd.it$ : controlla che sia una mail valida
    // m : multiline
    if (email==null || !(new RegExp("^[a-z0-9._%+-]{1,64}\@studenti.unipd.it$", "m").test(email))  ) {
    	erroriForm = "<li>L'email deve finire con '\@studenti.unipd.it'</li>";
    }
    if(password==null || password=="" || password.trim() == "" || password.length < 8){
    	erroriForm = erroriForm + "<li>La password deve essere almeno di 8 caratteri e non può contenere caratteri speciali</li>";
    }
    if(passwordconfirm==null || passwordconfirm=="" || passwordconfirm.trim() == "" || passwordconfirm != password ){
    	erroriForm = erroriForm + "<li>La password di conferma non corrisponde!</li>";
    }

    if(erroriForm != "" ) {
    	erroriForm = "<p>Sono stati riscontrati i seguenti errori:</p><ul>".concat(erroriForm);
    	erroriForm.concat("</ul>");
    	campoErrori.innerHTML = erroriForm;
    	return false;
    }
};
