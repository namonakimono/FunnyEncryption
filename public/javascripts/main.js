templateRealText = '😊 You are awesome. 你很棒棒哦。'
templateFakeText = '😢 You are not awesome. 你没很棒棒哦。'

templateDecText = 'eiiox2kDvrUFYI/Kf78oI6LD71qdM/EZf7GElYqMRILYy5t8wvPoe9bD5ZP9wqAjX8qaxarqvtbZWe4O8BClVf8PJhK9Z6iAjIsCW7k0H8YNJ+zbE6ltj6G+L/JscZSM2X5NfmEenMeM5MHY1mEBY/CYLFxyD2aFiZGRzZMbed0='

var randomDir = Math.random().toString(36).substring(7);

function copyEncryptedText(){
	var encryptedTextArea = document.getElementById('encrypted-text');
	encryptedTextArea.select();
	document.execCommand('Copy');
}

function encInit(){
	document.getElementById('real-text').value = templateRealText;
	document.getElementById('fake-text').value = templateFakeText;

	document.getElementById('real-key').value = "real";
	document.getElementById('fake-key').value = "fake";
}

function runEnc(){
	var realKey = document.getElementById('real-key').value;
	var realText = document.getElementById('real-text').value;
	var fakeKey = document.getElementById('fake-key').value;
	var fakeText = document.getElementById('fake-text').value;

	if (!realKey || !fakeKey) {
		alert('Please set both keys.');
		return;
	}

	if (!realText || !fakeText) {
		alert('Please set both text.');
		return;
	}

	$.ajax({
		url: '/enc',
		type: 'post',
		data: {
			realKey:  realKey,
			realText: realText,
			fakeKey:  fakeKey,
			fakeText: fakeText,
			randomDir: randomDir,
		},
	  success: function(res){
			if(res.status == "success"){
				document.getElementById("encrypted-text").readOnly = false;
				document.getElementById("encrypted-text").value = res.encryptedText;
				// document.getElementById("encrypted-text").readOnly = true;
			}
			else {
				alert("Encryption failed. Do you install FunnyEnc executable correctly?")
			}
	   }
 });
}

function decInit(){
	document.getElementById("dec-key").value = 'fake';
	document.getElementById("dec-text").value = templateDecText;
}

function runDec(){
	var decKey = document.getElementById("dec-key").value;
	var decText = document.getElementById("dec-text").value;

	if (!decKey || !decText) {
		alert('Please set decryption key and encrypted text.');
		return;
	}

	$.ajax({
		url: '/dec',
		type: 'post',
		data: {
			decKey:  decKey,
			decText: decText,
			randomDir: randomDir,
		},
	  success: function(res){
			if(res.status == "success"){
				document.getElementById("decrypted-text").readOnly = false;
				document.getElementById("decrypted-text").value = res.decryptedText;
				// document.getElementById("decrypted-text").readOnly = true;
			}
			else {
				alert('Decryption failed.\nPossible reasons:\n1. Text to be decrypted is invalid. (eg: length is not a multiple of 16)\n2. FunnyEnc executable is not installed correctly.')
			}
	   }
 });
}

