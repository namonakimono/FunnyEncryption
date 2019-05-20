const fs = require('fs');
const exec = require('child_process').exec;

function dec(req, res, next) {
  const decKey = req.body.decKey;
  const decText = req.body.decText;
  const randomDir = req.body.randomDir;

  exec("mkdir -p /tmp/" + randomDir, function(err){
    console.log(randomDir);
    if (err){console.log(err); console.log("Folder exists. It does not matter.")}
    var decFile = "/tmp/" + randomDir + "/encrypted.txt";
    var decryptedFile = "/tmp/" + randomDir + "/decrypted.txt";

    fs.writeFileSync(decFile, decText, 'utf8');
    exec("FunnyEnc " + "dec " +  decKey + " " + decFile + " " + decryptedFile, function(err){
      if(err){console.log(err); res.send({status: "fail", msg: err.toString() });}
      else {
        console.log("Text decrypted.");
        var decryptedText = fs.readFileSync(decryptedFile, 'utf8');
        res.send({status: "success", decryptedText: decryptedText});
      }
    });
  });
}


module.exports = dec;
